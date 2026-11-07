//===- llvm/CodeGen/GlobalISel/PatternGen.cpp - PatternGen ---==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the PatternGen class.
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/GlobalISel/PatternGen.h"
#include "../../../tools/pattern-gen/lib/InstrInfo.hpp"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Analysis/LazyBlockFrequencyInfo.h"
#include "llvm/Analysis/ProfileSummaryInfo.h"
#include "llvm/CodeGen/GlobalISel/GISelValueTracking.h"
#include "llvm/CodeGen/GlobalISel/GenericMachineInstrs.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/LegalizerInfo.h"
#include "llvm/CodeGen/GlobalISel/Utils.h"
#include "llvm/CodeGen/ISDOpcodes.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/MachineOptimizationRemarkEmitter.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/CodeGenTypes/LowLevelType.h"
#include "llvm/Config/config.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/IntrinsicsRISCV.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CodeGenCoverage.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/TypeSize.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/Utils/PredicateInfo.h"
#include <memory>
#include <sstream>
#include <string>
#include <utility>

#define DEBUG_TYPE "pattern-gen"

using namespace llvm;

STATISTIC(PatternGenNumInstructionsProcessed, "Processed instructions");
STATISTIC(PatternGenNumInstructionsFailing, "Failing instructions");
STATISTIC(PatternGenNumPatternsGenerated, "Generated patterns");
STATISTIC(PatternGenNumPatternsFailing, "Failing patterns");
STATISTIC(PatternGenNumErrorMultipleBlocks, "Errors of type: MULTIPLE_BLOCKS");
STATISTIC(PatternGenNumErrorFormatReturn, "Errors of type: FORMAT_RETURN");
STATISTIC(PatternGenNumErrorFormatStore, "Errors of type: FORMAT_STORE");
STATISTIC(PatternGenNumErrorFormatLoad, "Errors of type: FORMAT_LOAD");
STATISTIC(PatternGenNumErrorFormatImm, "Errors of type: FORMAT_IMM");
STATISTIC(PatternGenNumErrorFormat, "Errors of type: FORMAT");
STATISTIC(PatternGenNumErrorMultipleStores, "Errors of type: MULTIPLE STORES");
STATISTIC(PatternGenNumErrorUnusedOperand, "Errors of type: UNUSED_OPERAND");
STATISTIC(PatternGenNumErrorOperandMissmatch,
          "Errors of type: OPERAND_MISSMATCH");

#ifdef LLVM_GISEL_COV_PREFIX
static cl::opt<std::string>
    CoveragePrefix("gisel-coverage-prefix", cl::init(LLVM_GISEL_COV_PREFIX),
                   cl::desc("Record GlobalISel rule coverage files of this "
                            "prefix if instrumentation was generated"));
#else
static const std::string CoveragePrefix;
#endif

std::ostream *PatternGenArgs::OutStream = nullptr;
std::vector<CDSLInstr> const *PatternGenArgs::Instrs = nullptr;
PGArgsStruct PatternGenArgs::Args;
bool PatternGenArgs::Failed = false;

struct PatternArg {
  std::string ArgTypeStr;
  LLT Llt;
  // We also have in and out bits in the CDSLInstr struct itself.
  // These bits are currently ignored though. Instead, we find inputs
  // and outputs during pattern gen and store that in these fields.
  // We may want to add a warning on mismatch between the two.
  bool In;
  bool Out;
};

static CDSLInstr const *CurInstr = nullptr;
static SmallVector<PatternArg, 8> PatternArgs;
static bool HasSideEffects = 0; // TODO: get from parser attrs
static bool MayLoad = 0;
static bool MayStore = 0;
static bool IsBranch = 0;

static uint64_t XLen;
static std::string RegT;

char PatternGen::ID = 0;
INITIALIZE_PASS_BEGIN(
    PatternGen, DEBUG_TYPE,
    "Convert instruction behavior functions to TableGen ISel patterns", false,
    false)
INITIALIZE_PASS_DEPENDENCY(TargetPassConfig)
INITIALIZE_PASS_DEPENDENCY(GISelValueTrackingAnalysisLegacy)
INITIALIZE_PASS_DEPENDENCY(ProfileSummaryInfoWrapperPass)
INITIALIZE_PASS_DEPENDENCY(LazyBlockFrequencyInfoPass)
INITIALIZE_PASS_END(
    PatternGen, DEBUG_TYPE,
    "Convert instruction behavior functions to TableGen ISel patterns", false,
    false)

PatternGen::PatternGen(CodeGenOptLevel OL)
    : MachineFunctionPass(ID), OptLevel(OL) {}

// In order not to crash when calling getAnalysis during testing with -run-pass
// we use the default opt level here instead of None, so that the addRequired()
// calls are made in getAnalysisUsage().
PatternGen::PatternGen()
    : MachineFunctionPass(ID), OptLevel(CodeGenOptLevel::Default) {}

void PatternGen::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<TargetPassConfig>();
  AU.addRequired<GISelValueTrackingAnalysisLegacy>();
  AU.addPreserved<GISelValueTrackingAnalysisLegacy>();

  if (OptLevel != CodeGenOptLevel::None) {
    AU.addRequired<ProfileSummaryInfoWrapperPass>();
    LazyBlockFrequencyInfoPass::getLazyBFIAnalysisUsage(AU);
  }
  getSelectionDAGFallbackAnalysisUsage(AU);
  MachineFunctionPass::getAnalysisUsage(AU);
}

enum PatternErrorT {
  SUCCESS = 0,
  MULTIPLE_BLOCKS,
  FORMAT_RETURN,
  FORMAT_STORE,
  FORMAT_LOAD,
  FORMAT_IMM,
  FORMAT,
  MULTIPLE_STORES,
  UNUSED_OPERANDS
};
struct PatternError {
  PatternErrorT Type;
  MachineInstr *Inst;
  PatternError(PatternErrorT Type) : Type(Type), Inst(nullptr) {}
  PatternError(PatternErrorT Type, MachineInstr *Inst)
      : Type(Type), Inst(Inst) {}
  operator bool() const { return Type != 0; }
};

std::string Errors[] = {"success",        "multiple blocks", "expected return",
                        "expected store", "load format",     "immediate format",
                        "format",         "multiple stores"};
llvm::Statistic *ErrorStats[] = {nullptr,
                                 &PatternGenNumErrorMultipleBlocks,
                                 &PatternGenNumErrorFormatReturn,
                                 &PatternGenNumErrorFormatStore,
                                 &PatternGenNumErrorFormatLoad,
                                 &PatternGenNumErrorFormatImm,
                                 &PatternGenNumErrorFormat,
                                 &PatternGenNumErrorMultipleStores,
                                 &PatternGenNumErrorUnusedOperand};

static const std::unordered_map<unsigned, std::string> CmpStr = {
    {CmpInst::Predicate::ICMP_EQ, "SETEQ"},
    {CmpInst::Predicate::ICMP_NE, "SETNE"},
    {CmpInst::Predicate::ICMP_SLT, "SETLT"},
    {CmpInst::Predicate::ICMP_SLE, "SETLE"},
    {CmpInst::Predicate::ICMP_SGT, "SETGT"},
    {CmpInst::Predicate::ICMP_SGE, "SETGE"},
    {CmpInst::Predicate::ICMP_ULT, "SETULT"},
    {CmpInst::Predicate::ICMP_ULE, "SETULE"},
    {CmpInst::Predicate::ICMP_UGT, "SETUGT"},
    {CmpInst::Predicate::ICMP_UGE, "SETUGE"},
};

std::string lltToString(LLT Llt) {
  if (Llt.isFixedVector())
    return "v" + std::to_string(Llt.getElementCount().getFixedValue()) +
           lltToString(Llt.getElementType());
  if (Llt.isScalar())
    return "i" + std::to_string(Llt.getSizeInBits());
  if (Llt.isPointer())
    return "iPTR";
  assert(0 && "invalid type");
  return "invalid";
}

std::string lltToRegTypeStr(LLT Type) {
  if (Type.isValid()) {
    if (Type.isFixedVector() && Type.getElementType().isScalar() &&
        Type.getSizeInBits() == 32) {
      if (Type.getElementType().getSizeInBits() == 8)
        return "GPR32V4";
      if (Type.getElementType().getSizeInBits() == 16)
        return "GPR32V2";
      abort();
    } else
      return "GPR";
  }
  assert(0 && "invalid type");
  return "invalid";
}

std::string makeImmTypeStr(int Size, bool Signed, std::string llvm_type) {
  if (llvm_type.empty())
    return (Signed ? "simm" : "uimm") + std::to_string(Size);
  return llvm_type;
}

struct PatternNode {
  enum PatternNodeKind {
    PN_NOp,
    PN_Binop,
    PN_Ternop,
    PN_Shuffle,
    PN_SextInreg,
    PN_Compare,
    PN_Unop,
    PN_Constant,
    PN_Register,
    PN_Load,
    PN_Select,
    PN_Cast,
    PN_Store,
    PN_Branch
  };

private:
  const PatternNodeKind Kind;

public:
  PatternNodeKind getKind() const { return Kind; }
  LLT Type;
  bool IsImm = false;
  PatternNode(PatternNodeKind Kind, LLT Type, bool IsImm)
      : Kind(Kind), Type(Type), IsImm(IsImm) {}

  virtual std::string patternString() = 0;
  virtual LLT getRegisterTy(int OperandId) const {
    if (OperandId == -1)
      return Type;
    return LLT();
  }
  virtual ~PatternNode() {}
};

struct NOpNode : public PatternNode {
  int Op;
  std::vector<std::unique_ptr<PatternNode>> Operands;
  NOpNode(LLT Type, int Op, std::vector<std::unique_ptr<PatternNode>> Operands)
      : PatternNode(PN_NOp, Type, false), Op(Op),
        Operands(std::move(Operands)) {}

  std::string patternString() override {
    static const std::unordered_map<int, std::string> NOpStr = {
        {TargetOpcode::G_BUILD_VECTOR, "build_vector"},
        {TargetOpcode::G_SELECT, "vselect"}};

    std::string S = "(" + std::string(NOpStr.at(Op)) + " ";
    for (auto &Operand : Operands)
      S += Operand->patternString() + ", ";
    if (!Operands.empty())
      S = S.substr(0, S.size() - 2);

    S += ")";
    return S;
  }
  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    for (auto &Operand : Operands) {
      auto T = Operand->getRegisterTy(OperandId);
      if (T.isValid())
        return T;
    }
    return LLT();
  }
  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_NOp;
  }
};

struct ShuffleNode : public PatternNode {
  int Op;
  std::unique_ptr<PatternNode> First;
  std::unique_ptr<PatternNode> Second;
  ArrayRef<int> Mask;

  ShuffleNode(LLT Type, int Op, std::unique_ptr<PatternNode> First,
              std::unique_ptr<PatternNode> Second, ArrayRef<int> Mask)
      : PatternNode(PN_Shuffle, Type, false), Op(Op), First(std::move(First)),
        Second(std::move(Second)), Mask(std::move(Mask)) {}

  std::string patternString() override {
    std::string TypeStr = lltToString(Type);
    std::string MaskStr = "";

    for (size_t I = 0; I < Mask.size(); I++) {
      if (I != 0) {
        MaskStr += ", ";
      }
      MaskStr += std::to_string(Mask[I]);
    }
    std::string OpString = "(vector_shuffle<" + MaskStr + "> " +
                           First->patternString() + ", " +
                           Second->patternString() + ")";

    // Explicitly specifying types for all ops increases pattern compile time
    // significantly, so we only do for ops where deduction fails otherwise.
    bool PrintType = false;

    if (PrintType)
      return "(" + TypeStr + " " + OpString + ")";
    return OpString;
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    auto FirstT = First->getRegisterTy(OperandId);
    auto SecondT = Second->getRegisterTy(OperandId);
    return FirstT.isValid() ? FirstT : SecondT;
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Shuffle;
  }
};

struct SextInregNode : public PatternNode {
  int Op;
  std::unique_ptr<PatternNode> First;
  int Bit;

  SextInregNode(LLT Type, int Op, std::unique_ptr<PatternNode> First, int Bit)
      : PatternNode(PN_SextInreg, Type, false), Op(Op), First(std::move(First)),
        Bit(Bit) {}

  std::string patternString() override {
    std::string TypeStr = lltToString(Type);
    std::string MaskStr = "";

    std::string OpString = "(sext_inreg " + First->patternString() + ", i" +
                           std::to_string(Bit) + ")";

    // Explicitly specifying types for all ops increases pattern compile time
    // significantly, so we only do for ops where deduction fails otherwise.
    bool PrintType = false;

    if (PrintType)
      return "(" + TypeStr + " " + OpString + ")";
    return OpString;
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    auto FirstT = First->getRegisterTy(OperandId);
    return FirstT.isValid() ? FirstT : LLT();
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_SextInreg;
  }
};

struct TernopNode : public PatternNode {
  int Op;
  std::unique_ptr<PatternNode> First;
  std::unique_ptr<PatternNode> Second;
  std::unique_ptr<PatternNode> Third;

  TernopNode(LLT Type, int Op, std::unique_ptr<PatternNode> First,
             std::unique_ptr<PatternNode> Second,
             std::unique_ptr<PatternNode> Third)
      : PatternNode(PN_Ternop, Type, false), Op(Op), First(std::move(First)),
        Second(std::move(Second)), Third(std::move(Third)) {}

  std::string patternString() override {
    static const std::unordered_map<int, std::string> TernopStr = {
        {TargetOpcode::G_FSHL, "fshl"},
        {TargetOpcode::G_FSHR, "fshr"},
        {TargetOpcode::G_INSERT_VECTOR_ELT, "vector_insert"},
        {TargetOpcode::G_SELECT, "select"}};

    std::string TypeStr = lltToString(Type);
    std::string OpString =
        "(" + std::string(TernopStr.at(Op)) + " " + First->patternString() +
        ", " + Second->patternString() + ", " + Third->patternString() + ")";

    bool PrintType = false;
    if (PrintType)
      return "(" + TypeStr + " " + OpString + ")";
    return OpString;
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    auto FirstT = First->getRegisterTy(OperandId);
    auto SecondT = Second->getRegisterTy(OperandId);
    auto ThirdT = Third->getRegisterTy(OperandId);
    return FirstT.isValid() ? FirstT : (SecondT.isValid() ? SecondT : ThirdT);
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Ternop;
  }
};

struct BinopNode : public PatternNode {
  int Op;
  std::unique_ptr<PatternNode> Left;
  std::unique_ptr<PatternNode> Right;

  BinopNode(LLT Type, int Op, std::unique_ptr<PatternNode> Left,
            std::unique_ptr<PatternNode> Right)
      : PatternNode(PN_Binop, Type, false), Op(Op), Left(std::move(Left)),
        Right(std::move(Right)) {}

  std::string patternString() override {
    static const std::unordered_map<int, std::string> BinopStr = {
        {TargetOpcode::G_ADD, "add"},
        {TargetOpcode::G_PTR_ADD, "ptradd"},
        {TargetOpcode::G_SUB, "sub"},
        {TargetOpcode::G_MUL, "mul"},
        {TargetOpcode::G_UMULH, "mulhu"},
        {TargetOpcode::G_SMULH, "mulhs"},
        {TargetOpcode::G_UDIV, "udiv"},
        {TargetOpcode::G_SREM, "srem"},
        {TargetOpcode::G_UREM, "urem"},
        {TargetOpcode::G_SDIV, "sdiv"},
        {TargetOpcode::G_SADDSAT, "saddsat"},
        {TargetOpcode::G_UADDSAT, "uaddsat"},
        {TargetOpcode::G_SSUBSAT, "ssubsat"},
        {TargetOpcode::G_USUBSAT, "usubsat"},
        {TargetOpcode::G_SSHLSAT, "sshlsat"},
        {TargetOpcode::G_USHLSAT, "ushlsat"},
        {TargetOpcode::G_SMULFIX, "smulfix"},
        {TargetOpcode::G_UMULFIX, "umulfix"},
        {TargetOpcode::G_SMULFIXSAT, "smulfixsat"},
        {TargetOpcode::G_UMULFIXSAT, "umulfixsat"},
        {TargetOpcode::G_SDIVFIX, "sdivfix"},
        {TargetOpcode::G_UDIVFIX, "udivfix"},
        {TargetOpcode::G_SDIVFIXSAT, "sdivfixsat"},
        {TargetOpcode::G_UDIVFIXSAT, "udivfixsat"},
        {TargetOpcode::G_AND, "and"},
        {TargetOpcode::G_OR, "or"},
        {TargetOpcode::G_XOR, "xor"},
        {TargetOpcode::G_SHL, "shl"},
        {TargetOpcode::G_LSHR, "srl"},
        {TargetOpcode::G_ASHR, "sra"},
        {TargetOpcode::G_SMAX, "smax"},
        {TargetOpcode::G_UMAX, "umax"},
        {TargetOpcode::G_SMIN, "smin"},
        {TargetOpcode::G_UMIN, "umin"},
        {TargetOpcode::G_ROTR, "rotr"},
        {TargetOpcode::G_ROTL, "rotl"},
        {TargetOpcode::G_EXTRACT_VECTOR_ELT, "vector_extract"}};

    static const std::vector<double> CommOps = {
        TargetOpcode::G_ADD,   TargetOpcode::G_MUL,  TargetOpcode::G_UMULH,
        TargetOpcode::G_SMULH, TargetOpcode::G_AND,  TargetOpcode::G_OR,
        TargetOpcode::G_XOR,   TargetOpcode::G_UMAX, TargetOpcode::G_SMIN,
        TargetOpcode::G_UMIN}; // TODO: extend list
    bool IsCommutable =
        std::find(CommOps.begin(), CommOps.end(), Op) != CommOps.end();
    // RegisterNode* LeftReg = static_cast<RegisterNode*>(Left.get());
    // RegisterNode* RightReg = static_cast<RegisterNode*>(Right.get());
    // bool LeftImm = (LeftReg != 0) ? LeftReg->IsImm : false;
    // bool RightImm = (RightReg != 0) ? RightReg->IsImm : false;
    bool LeftImm = Left->IsImm;
    bool RightImm = Right->IsImm;
    bool DoSwap = IsCommutable && LeftImm && !RightImm;
    std::string TypeStr = lltToString(Type);
    std::string LhsTypeStr = lltToString(Left->Type);
    std::string RhsTypeStr = lltToString(Right->Type);

    // Explicitly specifying types for all ops increases pattern compile time
    // significantly, so we only do for ops where deduction fails otherwise.
    bool PrintType = false;
    bool PrintSrcTypes = false;
    PrintType |= Type.getSizeInBits() != XLen;
    switch (Op) {
    case TargetOpcode::G_SHL:
    case TargetOpcode::G_LSHR:
    case TargetOpcode::G_ASHR:
    case TargetOpcode::G_PTR_ADD:
      PrintType |= true;
      PrintSrcTypes |= true;
      break;
    default:
      break;
    }
    std::string LeftString = (DoSwap ? Right : Left)->patternString();
    std::string RightString = (DoSwap ? Left : Right)->patternString();
    if (PrintSrcTypes) {
      LeftString =
          "(" + (DoSwap ? RhsTypeStr : LhsTypeStr) + " " + LeftString + ")";
      RightString =
          "(" + (DoSwap ? LhsTypeStr : RhsTypeStr) + " " + RightString + ")";
    }
    std::string OpString = "(" + std::string(BinopStr.at(Op)) + " " +
                           LeftString + ", " + RightString + ")";

    if (PrintType)
      return "(" + TypeStr + " " + OpString + ")";
    return OpString;
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    auto LeftT = Left->getRegisterTy(OperandId);
    return LeftT.isValid() ? LeftT : Right->getRegisterTy(OperandId);
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Binop;
  }
};

struct CompareNode : public BinopNode {
  CmpInst::Predicate Cond;

  CompareNode(LLT Type, CmpInst::Predicate Cond,
              std::unique_ptr<PatternNode> Left,
              std::unique_ptr<PatternNode> Right)
      : BinopNode(Type, ISD::SETCC, std::move(Left), std::move(Right)),
        Cond(Cond) {
    // The ordinary GlobalISel importer matches comparison operands in order.
    // Put condition immediates on the right, as LLVM does in generated code.
    if (this->Left->IsImm && !this->Right->IsImm) {
      std::swap(this->Left, this->Right);
      this->Cond = CmpInst::getSwappedPredicate(Cond);
    }
  }

  std::string patternString() override {
    std::string TypeStr = lltToString(Type);
    std::string LhsTypeStr = lltToString(Left->Type);
    std::string RhsTypeStr = lltToString(Right->Type);

    return "(" + TypeStr + " (setcc (" + LhsTypeStr + " " +
           Left->patternString() + "), (" + RhsTypeStr + " " +
           Right->patternString() + "), " + CmpStr.at(Cond) + "))";
  }
};

struct SelectNode : public PatternNode {
  ISD::CondCode Cond;
  std::unique_ptr<PatternNode> Left;
  std::unique_ptr<PatternNode> Right;
  std::unique_ptr<PatternNode> Tval;
  std::unique_ptr<PatternNode> Fval;

  SelectNode(LLT Type, ISD::CondCode Cond, std::unique_ptr<PatternNode> Left,
             std::unique_ptr<PatternNode> Right,
             std::unique_ptr<PatternNode> Tval,
             std::unique_ptr<PatternNode> Fval)
      : PatternNode(PN_Select, Type, false), Cond(Cond), Left(std::move(Left)),
        Right(std::move(Right)), Tval(std::move(Tval)), Fval(std::move(Fval)) {}

  std::string patternString() override {
    std::string TypeStr = lltToString(Type);

    return "(" + TypeStr + " (riscv_selectcc " + Left->patternString() + ", " +
           Right->patternString() + ", " + CmpStr.at(Cond) + ", " +
           Tval->patternString() + ", " + Fval->patternString() + "))";
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1)
      return Type;

    for (auto *Operand : {&Left, &Right, &Tval, &Fval}) {
      auto T = (*Operand)->getRegisterTy(OperandId);
      if (T.isValid())
        return T;
    }
    return LLT();
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Select;
  }
};

struct UnopNode : public PatternNode {
  int Op;
  std::unique_ptr<PatternNode> Operand;

  UnopNode(LLT Type, int Op, std::unique_ptr<PatternNode> Operand)
      : PatternNode(PN_Unop, Type, false), Op(Op), Operand(std::move(Operand)) {
  }

  std::string patternString() override {
    static const std::unordered_map<int, std::string> UnopStr = {
        {TargetOpcode::G_ANYEXT, "anyext"},
        {TargetOpcode::G_SEXT, "sext"},
        {TargetOpcode::G_ZEXT, "zext"},
        {TargetOpcode::G_VECREDUCE_ADD, "vecreduce_add"},
        {TargetOpcode::G_TRUNC, "trunc"},
        {TargetOpcode::G_BSWAP, "bswap"},
        {TargetOpcode::G_BITREVERSE, "bitreverse"},
        {TargetOpcode::G_BITCAST, "bitcast"},
        {TargetOpcode::G_CTLZ, "ctlz"},
        {TargetOpcode::G_CTTZ, "cttz"},
        {TargetOpcode::G_CTLZ_ZERO_UNDEF, "ctlz_zero_undef"},
        {TargetOpcode::G_CTTZ_ZERO_UNDEF, "cttz_zero_undef"},
        {TargetOpcode::G_CTPOP, "ctpop"},
        {TargetOpcode::G_ABS, "abs"}};

    std::string TypeStr = lltToString(Type);

    // ignore bitcast ops for now
    if ((Op == TargetOpcode::G_BITCAST) ||
        (Op == TargetOpcode::G_CONSTANT_FOLD_BARRIER))
      return Operand->patternString();

    return "(" + TypeStr + " (" + std::string(UnopStr.at(Op)) + " " +
           Operand->patternString() + "))";
  }

  LLT getRegisterTy(int OperandId) const override {
    if (OperandId == -1 && Op != TargetOpcode::G_BITCAST &&
        Op != TargetOpcode::G_CONSTANT_FOLD_BARRIER)
      return Type;
    return Operand->getRegisterTy(OperandId);
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Unop;
  }
};

struct ConstantNode : public PatternNode {
  uint64_t Constant;
  ConstantNode(LLT Type, uint64_t Const)
      : PatternNode(PN_Constant, Type, true), Constant(Const) {}

  std::string patternString() override {
    std::string ConstantStr = (XLen == 64) ? std::to_string((int64_t)Constant)
                                           : std::to_string((int32_t)Constant);
    if (Type.isFixedVector()) {

      std::string TypeStr = lltToString(Type);
      return "(" + TypeStr + " (" + RegT + " " + ConstantStr + "))";
    }
    return "(" + lltToString(Type) + " " + ConstantStr + ")";
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Constant;
  }
};

struct RegisterNode : public PatternNode {

  StringRef Name;
  int Size;
  bool Sext;
  std::string llvm_type;

  size_t RegIdx;

  RegisterNode(LLT Type, StringRef Name, size_t RegIdx, bool IsImm, int Size,
               bool Sext, std::string llvm_type)
      : PatternNode(PN_Register, Type, IsImm), Name(Name), Size(Size),
        Sext(Sext), llvm_type(llvm_type), RegIdx(RegIdx) {}

  std::string patternString() override {
    std::string TypeStr = lltToString(Type);
    bool PrintType = Type.isPointer();

    if (IsImm) {
      // Immediate Operands
      std::string pre;
      if (llvm_type.empty())
        pre = (Sext ? "simm" : "uimm") + std::to_string(Size);
      else
        pre = llvm_type;
      return ("(" + RegT + " ") + pre + ":$" + std::string(Name) + ")";
    }

    // Vector Types (currently rv32 only)
    if (Type.isFixedVector()) {
      assert((uint64_t)Size == 32 && XLen == 32);
      std::string Str;
      if (Type.isFixedVector() && Type.getSizeInBits() == 32 &&
          Type.getElementType().isScalar() &&
          Type.getElementType().getSizeInBits() == 8)
        Str = "GPR32V4:$" + std::string(Name);
      if (Type.isFixedVector() && Type.getSizeInBits() == 32 &&
          Type.getElementType().isScalar() &&
          Type.getElementType().getSizeInBits() == 16)
        Str = "GPR32V2:$" + std::string(Name);
      if (PrintType)
        return "(" + TypeStr + " " + Str + ")";
      return Str;
    }

    // Full-Size Register Operands
    if (Size == 32 || Size == 64) {
      std::string Str = "GPR:$" + std::string(Name);
      PrintType |= Size == 32 && XLen == 64;
      if (PrintType)
        return "(" + TypeStr + " " + Str + ")";
      return Str;
    }

    abort();
  }

  static bool classof(const PatternNode *Pat) {
    return Pat->getKind() == PN_Register;
  }
};

struct LoadNode : public PatternNode {

  int Size;
  bool Sext;
  std::unique_ptr<PatternNode> Addr;

  LoadNode(int Size, bool Sext, std::unique_ptr<PatternNode> Addr)
      : PatternNode(PN_Load, LLT::scalar(Size), false), Size(Size), Sext(Sext),
        Addr(std::move(Addr)) {}

  std::string patternString() override {
    if ((size_t)Size == XLen)
      return "(" + RegT + " (load " + Addr->patternString() + "))";
    assert((size_t)Size < XLen && "load size > xlen");
    assert(Size >= 8 && "load size < 8");
    assert(Size % 8 == 0 && "load size unaligned");
    // TODO: use AddrRegImm?
    // TODO: how about anyext?
    if (Sext)
      return "(" + RegT + " (sextloadi" + std::to_string(Size) + " " +
             Addr->patternString() + "))";
    return "(" + RegT + " (zextloadi" + std::to_string(Size) + " " +
           Addr->patternString() + "))";
    abort();
  }

  static bool classof(const PatternNode *p) { return p->getKind() == PN_Load; }
};

struct CastNode : public PatternNode {
  std::unique_ptr<PatternNode> Value;

  CastNode(LLT Type, std::unique_ptr<PatternNode> Value)
      : PatternNode(PN_Cast, Type, false), Value(std::move(Value)) {}

  std::string patternString() override {
    auto LLTString = lltToString(Type);
    return "(" + LLTString + " " + Value->patternString() + ")";
  }

  static bool classof(const PatternNode *p) { return p->getKind() == PN_Cast; }
};

struct StoreNode : public PatternNode {
  std::unique_ptr<PatternNode> Value;
  std::unique_ptr<PatternNode> Addr;

  StoreNode(LLT Type, std::unique_ptr<PatternNode> Value,
            std::unique_ptr<PatternNode> Addr)
      : PatternNode(PN_Store, Type, false), Value(std::move(Value)),
        Addr(std::move(Addr)) {}

  std::string patternString() override {

    std::string ValuePat = Value->patternString();
    std::string AddrPat = Addr->patternString();

    if (Type.getSizeInBits() == XLen)
      return "(store (XLenVT " + ValuePat + "), " + AddrPat + ")";
    if (Type.getSizeInBits() == 8)
      return "(truncstorei8 (XLenVT " + ValuePat + "), " + AddrPat + ")";
    if (Type.getSizeInBits() == 16)
      return "(truncstorei16 (XLenVT " + ValuePat + "), " + AddrPat + ")";
    if (Type.getSizeInBits() == 32)
      return "(truncstorei32 (XLenVT " + ValuePat + "), " + AddrPat + ")";
    abort();
  }

  static bool classof(const PatternNode *p) { return p->getKind() == PN_Store; }
};

struct BranchNode : public PatternNode {
  std::unique_ptr<PatternNode> Condition;
  std::string Target;
  BranchNode(std::unique_ptr<PatternNode> Condition, std::string Target)
      : PatternNode(PN_Branch, LLT(), false), Condition(std::move(Condition)),
        Target(std::move(Target)) {}
  std::string patternString() override {
    return "(brcond " + Condition->patternString() + ", bb:$" + Target + ")";
  }
};

using PatternOrError = std::pair<PatternError, std::unique_ptr<PatternNode>>;
static PatternOrError pError(PatternErrorT Type, MachineInstr *Inst) {
  return std::make_pair(PatternError(Type, Inst), nullptr);
}
static PatternOrError PError(PatternError Error) {
  return std::make_pair(Error, nullptr);
}
static PatternOrError PError(PatternErrorT Type) {
  return std::make_pair(PatternError(Type), nullptr);
}
static PatternOrError PPattern(std::unique_ptr<PatternNode> Pattern) {
  return std::make_pair(PatternError(SUCCESS), std::move(Pattern));
}

static PatternOrError traverse(MachineRegisterInfo &MRI, MachineInstr &Cur);

/*static PatternOrError traverseOperand(MachineRegisterInfo &MRI,
                                      MachineInstr &Cur, int Start) {
  assert(Cur.getOperand(1).isReg() && "expected register");
  auto *Op = MRI.getOneDef(Cur.getOperand(1).getReg());
  if (!Op)
    return PError(FORMAT);
  auto [Err, Node] = traverse(MRI, *Op->getParent());
  if (Err)
    return PError(Err);

  return PPattern(std::move(Node));
}*/

static std::tuple<PatternError, std::unique_ptr<PatternNode>,
                  std::unique_ptr<PatternNode>, std::unique_ptr<PatternNode>>
traverseTernopOperands(MachineRegisterInfo &MRI, MachineInstr &Cur,
                       int Start = 1) {
  assert(Cur.getOperand(Start).isReg() && "expected register");
  auto *First = MRI.getOneDef(Cur.getOperand(Start).getReg());
  if (!First)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr, nullptr,
                           nullptr);
  assert(Cur.getOperand(Start + 1).isReg() && "expected register");
  auto *Second = MRI.getOneDef(Cur.getOperand(Start + 1).getReg());
  if (!Second)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr, nullptr,
                           nullptr);
  assert(Cur.getOperand(Start + 2).isReg() && "expected register");
  auto *Third = MRI.getOneDef(Cur.getOperand(Start + 2).getReg());
  if (!Third)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr, nullptr,
                           nullptr);

  auto [ErrFirst, NodeFirst] = traverse(MRI, *First->getParent());
  if (ErrFirst)
    return std::make_tuple(ErrFirst, nullptr, nullptr, nullptr);

  auto [ErrSecond, NodeSecond] = traverse(MRI, *Second->getParent());
  if (ErrSecond)
    return std::make_tuple(ErrSecond, nullptr, nullptr, nullptr);

  auto [ErrThird, NodeThird] = traverse(MRI, *Third->getParent());
  if (ErrThird)
    return std::make_tuple(ErrThird, nullptr, nullptr, nullptr);

  return std::make_tuple(SUCCESS, std::move(NodeFirst), std::move(NodeSecond),
                         std::move(NodeThird));
}

static std::tuple<PatternError, std::unique_ptr<PatternNode>,
                  std::unique_ptr<PatternNode>>
traverseBinopOperands(MachineRegisterInfo &MRI, MachineInstr &Cur,
                      int Start = 1) {
  assert(Cur.getOperand(Start).isReg() && "expected register");
  auto *LHS = MRI.getOneDef(Cur.getOperand(Start).getReg());
  if (!LHS)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr, nullptr);
  assert(Cur.getOperand(Start + 1).isReg() && "expected register");
  auto *RHS = MRI.getOneDef(Cur.getOperand(Start + 1).getReg());
  if (!RHS)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr, nullptr);

  auto [ErrL, NodeL] = traverse(MRI, *LHS->getParent());
  if (ErrL)
    return std::make_tuple(ErrL, nullptr, nullptr);

  auto [ErrR, NodeR] = traverse(MRI, *RHS->getParent());
  if (ErrR)
    return std::make_tuple(ErrR, nullptr, nullptr);
  return std::make_tuple(SUCCESS, std::move(NodeL), std::move(NodeR));
}

static std::tuple<PatternError, std::unique_ptr<PatternNode>>
traverseUnopOperands(MachineRegisterInfo &MRI, MachineInstr &Cur,
                     int Start = 1) {
  assert(Cur.getOperand(Start).isReg() && "expected register");
  auto *RHS = MRI.getOneDef(Cur.getOperand(Start).getReg());
  if (!RHS)
    return std::make_tuple(PatternError(FORMAT, &Cur), nullptr);

  auto [ErrR, NodeR] = traverse(MRI, *RHS->getParent());
  if (ErrR)
    return std::make_tuple(ErrR, nullptr);
  return std::make_tuple(SUCCESS, std::move(NodeR));
}

static std::tuple<PatternError, std::vector<std::unique_ptr<PatternNode>>>
traverseNOpOperands(MachineRegisterInfo &MRI, MachineInstr &Cur, size_t N,
                    int Start = 1) {
  std::vector<std::unique_ptr<PatternNode>> Operands(N);
  for (size_t I = 0; I < N; I++) {
    // llvm::outs() << "i=" << i << '\n';
    assert(Cur.getOperand(Start + I).isReg() && "expected register");
    auto *Node = MRI.getOneDef(Cur.getOperand(Start + I).getReg());
    if (!Node) {
      // llvm::outs() << "Err" << '\n';
      return std::make_tuple(PatternError(FORMAT, &Cur),
                             std::vector<std::unique_ptr<PatternNode>>());
    }

    auto [Err_, Node_] = traverse(MRI, *Node->getParent());
    if (Err_) {
      // llvm::outs() << "Err2" << '\n';
      return std::make_tuple(Err_, std::vector<std::unique_ptr<PatternNode>>());
    }
    // return std::make_tuple(SUCCESS, std::move(NodeR));
    Operands[I] = std::move(Node_);
  }
  return std::make_tuple(SUCCESS, std::move(Operands));
}

static int getArgIdx(MachineRegisterInfo &MRI, Register Reg) {
  auto It = std::find_if(MRI.livein_begin(), MRI.livein_end(),
                         [&](std::pair<MCRegister, Register> const &E) {
                           return E.first == Reg.asMCReg();
                         });

  if (It == MRI.livein_end())
    return -1;
  unsigned ArgIdx = It - MRI.livein_begin();
  for (unsigned I = 0; I < CurInstr->fields.size() - 1; ++I) {
    if (CurInstr->fields[I].fixedImm)
      continue;
    if (ArgIdx-- == 0)
      return I;
  }
  return -1;
}

static CDSLInstr::Field const *getArgField(MachineRegisterInfo &MRI,
                                           Register Reg) {
  uint Idx = getArgIdx(MRI, Reg);
  if (Idx >= CurInstr->fields.size() - 1)
    return nullptr;
  return &CurInstr->fields[Idx];
}

static auto getArgInfo(MachineRegisterInfo &MRI, Register Reg) {
  return std::make_pair(getArgIdx(MRI, Reg), getArgField(MRI, Reg));
}
static PatternOrError traverseMemLoad(MachineRegisterInfo &MRI,
                                      MachineInstr &Cur, int ReadSize,
                                      MachineInstr *AddrI) {
  MayLoad = 1;
  if (AddrI->getOpcode() == TargetOpcode::G_INTTOPTR) {
    auto *AddrInt = MRI.getOneDef(AddrI->getOperand(1).getReg());
    auto [Err, Node] = traverse(MRI, *AddrInt->getParent());
    if (Err)
      return PError(Err);
    bool Sext = Cur.getOpcode() == TargetOpcode::G_SEXTLOAD;
    return PPattern(
        std::make_unique<LoadNode>(ReadSize, Sext, std::move(Node)));
  }
  if (AddrI->getOpcode() == TargetOpcode::G_PTR_ADD) {
    auto [Err, Node] = traverse(MRI, *AddrI);
    if (Err)
      return PError(Err);
    bool Sext = Cur.getOpcode() == TargetOpcode::G_SEXTLOAD;
    return PPattern(
        std::make_unique<LoadNode>(ReadSize, Sext, std::move(Node)));
  }
  abort();
}

static PatternOrError traverseRegLoad(MachineRegisterInfo &MRI,
                                      MachineInstr &Cur, int ReadSize,
                                      MachineInstr *AddrI) {

  int ReadOffset = 0;

  if (AddrI->getOpcode() == TargetOpcode::G_PTR_ADD) {
    assert(AddrI->getOperand(1).isReg());
    auto *BaseAddr = MRI.getOneDef(AddrI->getOperand(1).getReg())->getParent();
    auto *Offset = MRI.getOneDef(AddrI->getOperand(2).getReg())->getParent();

    if (Offset->getOpcode() != TargetOpcode::G_CONSTANT)
      return traverseMemLoad(MRI, Cur, ReadSize, AddrI);

    AddrI = BaseAddr;
    ReadOffset = Offset->getOperand(1).getCImm()->getLimitedValue();
  }
  if (AddrI->getOpcode() == TargetOpcode::G_SELECT) {
    assert(AddrI->getOperand(1).isReg() && "expected register");
    auto CondInstr = AddrI->getOperand(1);
    auto CondReg = CondInstr.getReg();
    auto [ErrCond, CondNode] = traverse(MRI, *MRI.getVRegDef(CondReg));
    if (ErrCond)
      return PError(ErrCond);
    assert(AddrI->getOperand(2).isReg() && "expected register");
    auto TrueInstr = AddrI->getOperand(2);
    auto TrueReg = TrueInstr.getReg();
    auto [ErrTrue, TrueNode] =
        traverseRegLoad(MRI, Cur, ReadSize, MRI.getVRegDef(TrueReg));
    if (ErrTrue)
      return PError(ErrTrue);
    assert(AddrI->getOperand(3).isReg() && "expected register");
    auto FalseInstr = AddrI->getOperand(3);
    auto FalseReg = FalseInstr.getReg();
    auto [ErrFalse, FalseNode] =
        traverseRegLoad(MRI, Cur, ReadSize, MRI.getVRegDef(FalseReg));
    if (ErrFalse)
      return PError(ErrFalse);
    auto Node = std::make_unique<TernopNode>(
        MRI.getType(Cur.getOperand(0).getReg()), AddrI->getOpcode(),
        std::move(CondNode), std::move(TrueNode), std::move(FalseNode));
    return PPattern(std::move(Node));
  }
  if (AddrI->getOpcode() != TargetOpcode::COPY)
    return pError(FORMAT_LOAD, AddrI);

  assert(Cur.getOperand(1).isReg() && "expected register");
  auto AddrLI = AddrI->getOperand(1).getReg();
  if (!MRI.isLiveIn(AddrLI) || !AddrLI.isPhysical())
    return pError(FORMAT_LOAD, AddrI);

  auto [Idx, Field] = getArgInfo(MRI, AddrLI);
  if (Field == nullptr)
    return pError(FORMAT_LOAD, AddrI);

  auto Type = MRI.getType(Cur.getOperand(0).getReg());
  PatternArgs[Idx].Llt = Type;
  PatternArgs[Idx].ArgTypeStr = lltToRegTypeStr(PatternArgs[Idx].Llt);
  PatternArgs[Idx].In = true;

  assert(Cur.getOperand(0).isReg() && "expected register");
  std::unique_ptr<PatternNode> Node = std::make_unique<RegisterNode>(
      Type, Field->ident, Idx, false, Type.getSizeInBits(), false,
      Field->llvm_type);

  bool SizeMismatch = (int)Type.getSizeInBits() != ReadSize;

  if (Cur.getOpcode() == TargetOpcode::G_ZEXTLOAD && SizeMismatch) {
    if (ReadOffset != 0)
      Node = std::make_unique<BinopNode>(
          Type, TargetOpcode::G_LSHR, std::move(Node),
          std::make_unique<ConstantNode>(Type, ReadOffset * 8));
    if ((uint64_t)(ReadSize + ReadOffset * 8) < XLen) {
      Node = std::make_unique<BinopNode>(
          Type, TargetOpcode::G_AND, std::move(Node),
          std::make_unique<ConstantNode>(Type, (1UL << ReadSize) - 1));
    }
  } else if (Cur.getOpcode() == TargetOpcode::G_SEXTLOAD && SizeMismatch) {
    int Shamt = XLen - ReadSize - ReadOffset * 8;
    auto Left = Shamt == 0 ? std::move(Node)
                           : std::make_unique<BinopNode>(
                                 Type, TargetOpcode::G_SHL, std::move(Node),
                                 std::make_unique<ConstantNode>(Type, Shamt));

    Node = std::make_unique<BinopNode>(
        Type, TargetOpcode::G_ASHR, std::move(Left),
        std::make_unique<ConstantNode>(Type, XLen - ReadSize));
  }

  return PPattern(std::move(Node));
}

static PatternOrError traverse(MachineRegisterInfo &MRI, MachineInstr &Cur) {

  switch (Cur.getOpcode()) {
  case TargetOpcode::G_ADD:
  case TargetOpcode::G_PTR_ADD:
  case TargetOpcode::G_SUB:
  case TargetOpcode::G_MUL:
  case TargetOpcode::G_UMULH:
  case TargetOpcode::G_SMULH:
  case TargetOpcode::G_SDIV:
  case TargetOpcode::G_UDIV:
  case TargetOpcode::G_SREM:
  case TargetOpcode::G_UREM:
  case TargetOpcode::G_SADDSAT:
  case TargetOpcode::G_UADDSAT:
  case TargetOpcode::G_SSUBSAT:
  case TargetOpcode::G_USUBSAT:
  case TargetOpcode::G_SSHLSAT:
  case TargetOpcode::G_USHLSAT:
  case TargetOpcode::G_SMULFIX:
  case TargetOpcode::G_UMULFIX:
  case TargetOpcode::G_SMULFIXSAT:
  case TargetOpcode::G_UMULFIXSAT:
  case TargetOpcode::G_SDIVFIX:
  case TargetOpcode::G_UDIVFIX:
  case TargetOpcode::G_SDIVFIXSAT:
  case TargetOpcode::G_UDIVFIXSAT:
  case TargetOpcode::G_AND:
  case TargetOpcode::G_OR:
  case TargetOpcode::G_XOR:
  case TargetOpcode::G_SMAX:
  case TargetOpcode::G_UMAX:
  case TargetOpcode::G_SMIN:
  case TargetOpcode::G_UMIN:
  case TargetOpcode::G_EXTRACT_VECTOR_ELT:
  case TargetOpcode::G_ROTR:
  case TargetOpcode::G_ROTL:
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_LSHR:
  case TargetOpcode::G_ASHR: {

    auto [Err, NodeL, NodeR] = traverseBinopOperands(MRI, Cur);
    if (Err)
      return std::make_pair(Err, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    LLT Type = MRI.getType(Cur.getOperand(0).getReg());
    unsigned Opcode = Cur.getOpcode();
    if (Opcode == TargetOpcode::G_PTR_ADD && !NodeR->IsImm) {
      // Match the selector's early lowering of variable pointer offsets.
      // Immediate offsets retain ptradd for native base+offset folding.
      Opcode = TargetOpcode::G_ADD;
      Type = LLT::scalar(XLen);
      while (auto *Cast = dyn_cast<CastNode>(NodeL.get())) {
        if (!Cast->Type.isPointer())
          break;
        auto Value = std::move(Cast->Value);
        NodeL = std::move(Value);
      }
      if (NodeL->Type.isPointer())
        NodeL->Type = Type;
    }
    auto Node = std::make_unique<BinopNode>(
        Type, Opcode, std::move(NodeL), std::move(NodeR));

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_CONSTANT_FOLD_BARRIER:
  case TargetOpcode::G_ANYEXT:
  case TargetOpcode::G_SEXT:
  case TargetOpcode::G_ZEXT:
  case TargetOpcode::G_VECREDUCE_ADD:
  case TargetOpcode::G_TRUNC:
  case TargetOpcode::G_BSWAP:
  case TargetOpcode::G_BITREVERSE:
  case TargetOpcode::G_CTLZ:
  case TargetOpcode::G_CTTZ:
  case TargetOpcode::G_CTLZ_ZERO_UNDEF:
  case TargetOpcode::G_CTTZ_ZERO_UNDEF:
  case TargetOpcode::G_CTPOP:
  case TargetOpcode::G_ABS: {

    auto [Err, NodeR] = traverseUnopOperands(MRI, Cur);
    if (Err)
      return std::make_pair(Err, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    auto Node =
        std::make_unique<UnopNode>(MRI.getType(Cur.getOperand(0).getReg()),
                                   Cur.getOpcode(), std::move(NodeR));

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_BITCAST: {
    assert(Cur.getOperand(1).isReg() && "expected register");
    auto *Operand = MRI.getOneDef(Cur.getOperand(1).getReg());
    if (!Operand)
      return std::make_pair(PatternError(FORMAT_LOAD, &Cur), nullptr);

    auto [Err, Node] = traverse(MRI, *Operand->getParent());
    if (Err)
      return std::make_pair(Err, nullptr);

    // if the bitcasted value is a register access, we need to patch the
    // register access type
    if (auto *AsRegNode = llvm::dyn_cast<RegisterNode>(Node.get())) {
      assert(Cur.getOperand(0).isReg() && "expected register");
      AsRegNode->Type = MRI.getType(Cur.getOperand(0).getReg());
      PatternArgs[AsRegNode->RegIdx].ArgTypeStr =
          lltToRegTypeStr(AsRegNode->Type);
    }

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_ZEXTLOAD:
  case TargetOpcode::G_SEXTLOAD: {

    MachineMemOperand *MMO = *Cur.memoperands_begin();
    int ReadSize = MMO->getSizeInBits().getValue();

    assert(Cur.getOperand(1).isReg() && "expected register");
    auto *Addr = MRI.getOneDef(Cur.getOperand(1).getReg());
    if (!Addr)
      return std::make_pair(PatternError(FORMAT_LOAD, &Cur), nullptr);
    auto *AddrI = Addr->getParent();

    auto [Error, Node] = traverseRegLoad(MRI, Cur, ReadSize, AddrI);
    if (!Error)
      return PPattern(std::move(Node));
    if (AddrI->getOpcode() == TargetOpcode::G_INTTOPTR ||
        AddrI->getOpcode() == TargetOpcode::G_PTR_ADD)
      return traverseMemLoad(MRI, Cur, ReadSize, AddrI);
    return PError(Error);
  }
  case TargetOpcode::G_CONSTANT: {
    auto *Imm = Cur.getOperand(1).getCImm();
    assert(Cur.getOperand(0).isReg() && "expected register");
    return std::make_pair(SUCCESS, std::make_unique<ConstantNode>(
                                       MRI.getType(Cur.getOperand(0).getReg()),
                                       Imm->getLimitedValue()));
  }
  case TargetOpcode::G_IMPLICIT_DEF: {
    assert(Cur.getOperand(0).isReg() && "expected register");
    return std::make_pair(SUCCESS,
                          std::make_unique<ConstantNode>(
                              MRI.getType(Cur.getOperand(0).getReg()), 0));
  }
  case TargetOpcode::G_ICMP: {
    auto Pred = Cur.getOperand(1);
    auto [Err, NodeL, NodeR] = traverseBinopOperands(MRI, Cur, 2);
    if (Err)
      return std::make_pair(Err, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    return std::make_pair(SUCCESS, std::make_unique<CompareNode>(
                                       MRI.getType(Cur.getOperand(0).getReg()),
                                       (CmpInst::Predicate)Pred.getPredicate(),
                                       std::move(NodeL), std::move(NodeR)));
  }
  case TargetOpcode::COPY: {
    // Immediate Operands
    assert(Cur.getOperand(1).isReg() && "expected register");
    auto Reg = Cur.getOperand(1).getReg();

    // Copying from a physical reg means this is a function argument,
    // so a register or immediate value in the behavior function.
    if (Reg.isPhysical()) {
      auto [Idx, Field] = getArgInfo(MRI, Reg);

      if (Field == nullptr)
        return std::make_pair(FORMAT_IMM, nullptr);
      PatternArgs[Idx].In = true;
      PatternArgs[Idx].Llt = LLT();
      PatternArgs[Idx].ArgTypeStr = makeImmTypeStr(
          Field->len, Field->type & CDSLInstr::SIGNED, Field->llvm_type);

      if (Field == nullptr)
        return std::make_pair(FORMAT_IMM, nullptr);

      assert(Cur.getOperand(0).isReg() && "expected register");
      return std::make_pair(
          SUCCESS,
          std::make_unique<RegisterNode>(
              MRI.getType(Cur.getOperand(0).getReg()), Field->ident, Idx, true,
              Field->len, Field->type & CDSLInstr::SIGNED, Field->llvm_type));
    }

    // Else COPY is just a pass-through.
    auto [Err, Node] = traverseUnopOperands(MRI, Cur);
    return std::make_pair(Err, std::move(Node));
  }
  case TargetOpcode::G_INTTOPTR: {
    auto [Err, Node] = traverseUnopOperands(MRI, Cur);
    if (Err)
      return PError(Err);

    return PPattern(
        std::make_unique<CastNode>(LLT::pointer(0, XLen), std::move(Node)));
  }
  case TargetOpcode::G_BUILD_VECTOR: {
    size_t N = Cur.getNumOperands();
    auto [Err, operands] = traverseNOpOperands(MRI, Cur, N - 1);
    if (Err)
      return std::make_pair(Err, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");

    auto Node =
        std::make_unique<NOpNode>(MRI.getType(Cur.getOperand(0).getReg()),
                                  Cur.getOpcode(), std::move(operands));

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_FSHL:
  case TargetOpcode::G_FSHR:
  case TargetOpcode::G_SELECT:
  case TargetOpcode::G_INSERT_VECTOR_ELT: {
    auto [Err, NodeFirst, NodeSecond, NodeThird] =
        traverseTernopOperands(MRI, Cur);
    if (Err)
      return std::make_pair(Err, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    auto Node = std::make_unique<TernopNode>(
        MRI.getType(Cur.getOperand(0).getReg()), Cur.getOpcode(),
        std::move(NodeFirst), std::move(NodeSecond), std::move(NodeThird));

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_SHUFFLE_VECTOR: {
    assert(Cur.getOperand(1).isReg() && "expected register");
    auto *First = MRI.getOneDef(Cur.getOperand(1).getReg());
    if (!First)
      return std::make_pair(PatternError(FORMAT, &Cur), nullptr);
    assert(Cur.getOperand(2).isReg() && "expected register");
    auto *Second = MRI.getOneDef(Cur.getOperand(2).getReg());
    if (!Second)
      return std::make_pair(PatternError(FORMAT, &Cur), nullptr);
    assert(Cur.getOperand(3).isShuffleMask() && "expected shufflemask");
    ArrayRef<int> Mask = Cur.getOperand(3).getShuffleMask();

    auto [ErrFirst, NodeFirst] = traverse(MRI, *First->getParent());
    if (ErrFirst)
      return std::make_pair(ErrFirst, nullptr);

    auto [ErrSecond, NodeSecond] = traverse(MRI, *Second->getParent());
    if (ErrSecond)
      return std::make_pair(ErrSecond, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    auto Node = std::make_unique<ShuffleNode>(
        MRI.getType(Cur.getOperand(0).getReg()), Cur.getOpcode(),
        std::move(NodeFirst), std::move(NodeSecond), Mask);

    return std::make_pair(SUCCESS, std::move(Node));
  }
  case TargetOpcode::G_SEXT_INREG: {
    assert(Cur.getOperand(1).isReg() && "expected register");
    auto *First = MRI.getOneDef(Cur.getOperand(1).getReg());
    if (!First)
      return std::make_pair(PatternError(FORMAT, &Cur), nullptr);
    assert(Cur.getOperand(2).isImm() && "expected imm");
    int Bit = Cur.getOperand(2).getImm();
    if (Bit <= 0)
      return std::make_pair(PatternError(FORMAT, &Cur), nullptr);

    auto [ErrFirst, NodeFirst] = traverse(MRI, *First->getParent());
    if (ErrFirst)
      return std::make_pair(ErrFirst, nullptr);

    assert(Cur.getOperand(0).isReg() && "expected register");
    auto Node = std::make_unique<SextInregNode>(
        MRI.getType(Cur.getOperand(0).getReg()), Cur.getOpcode(),
        std::move(NodeFirst), Bit);

    return std::make_pair(SUCCESS, std::move(Node));
  }
  }

  return std::make_pair(PatternError(FORMAT, &Cur), nullptr);
}

static PatternOrError traverseRegStore(size_t Idx, MachineRegisterInfo &MRI,
                                       MachineInstr &Root) {
  LLT Type;
  if (Root.getOpcode() == TargetOpcode::G_BITCAST)
    Type = MRI.getType(Root.getOperand(1).getReg());
  else
    Type = MRI.getType(Root.getOperand(0).getReg());

  PatternArgs[Idx].Out = true;
  PatternArgs[Idx].Llt = Type;
  PatternArgs[Idx].ArgTypeStr = lltToRegTypeStr(Type);

  return traverse(MRI, Root);
}

static PatternOrError traverseMemStore(LLT Type, MachineRegisterInfo &MRI,
                                       MachineInstr &Value,
                                       MachineInstr &Addr) {
  // Starting with LLVM20, there will be a G_TRUNC before G_STORE for s8, s16
  // TODO: check if pattern matches
  MachineInstr &ValMI = [&]() -> MachineInstr & {
    if (Value.getOpcode() == TargetOpcode::G_TRUNC) {
      Register SrcReg = Value.getOperand(1).getReg();
      return *MRI.getVRegDef(SrcReg);
    }
    return Value;
  }();
  auto ValueP = traverse(MRI, ValMI);
  if (ValueP.first)
    return PError(ValueP.first);
  // A low-bit register slice may be parsed as a narrow load directly from
  // the register argument, rather than an XLEN load followed by G_TRUNC.
  // A truncstore consumes the full register and observes only these low bits.
  if (auto *Reg = dyn_cast<RegisterNode>(ValueP.second.get());
      Reg && !Reg->IsImm && Reg->Type.isScalar() &&
      Reg->Type.getSizeInBits() < XLen) {
    if (ValMI.getOpcode() != TargetOpcode::G_LOAD)
      return pError(FORMAT_LOAD, &ValMI);
    auto *Address = MRI.getVRegDef(ValMI.getOperand(1).getReg());
    if (!Address || Address->getOpcode() != TargetOpcode::COPY)
      return pError(FORMAT_LOAD, &ValMI);
    Reg->Type = LLT::scalar(XLen);
    Reg->Size = XLen;
    PatternArgs[Reg->RegIdx].Llt = Reg->Type;
    PatternArgs[Reg->RegIdx].ArgTypeStr = lltToRegTypeStr(Reg->Type);
  }
  auto AddrP = traverse(MRI, Addr);
  if (AddrP.first)
    return PError(AddrP.first);

  MayStore = 1;

  return PPattern(std::make_unique<StoreNode>(Type, std::move(ValueP.second),
                                              std::move(AddrP.second)));
}

static PatternOrError traverseStore(MachineRegisterInfo &MRI,
                                    MachineInstr &Store) {
  MachineMemOperand *MMO = *Store.memoperands_begin();

  auto *ValueR = MRI.getOneDef(Store.getOperand(0).getReg());
  if (ValueR == nullptr)
    return pError(FORMAT_STORE, &Store);
  auto *ValueI = ValueR->getParent();

  auto *Addr = MRI.getOneDef(Store.getOperand(1).getReg());
  if (Addr == nullptr)
    return pError(FORMAT_STORE, &Store);

  auto *AddrD = MRI.getOneDef(Addr->getReg());
  if (AddrD == nullptr)
    return pError(FORMAT_STORE, &Store);

  auto *AddrI = MRI.getOneDef(AddrD->getReg())->getParent();
  if (AddrI->getOpcode() == TargetOpcode::COPY) {
    auto Idx = getArgIdx(MRI, AddrI->getOperand(1).getReg());
    if (Idx != -1) {
      if (MMO->getSizeInBits() != XLen && MMO->getSizeInBits() != 32)
        return pError(FORMAT_STORE, &Store);
      return traverseRegStore(Idx, MRI, *ValueI);
    }
  }

  return traverseMemStore(MMO->getType(), MRI, *ValueI, *AddrI);
}

static PatternOrError generatePattern(MachineFunction &MF) {

  if (MF.size() != 1)
    return std::make_pair(MULTIPLE_BLOCKS, nullptr);

  MachineBasicBlock &BB = *MF.begin();
  MachineRegisterInfo &MRI = MF.getRegInfo();

  auto Instrs = BB.instr_rbegin();
  auto InstrsEnd = BB.instr_rend();

  // Semantic functions end in a return and one observable store or branch.
  if (Instrs == InstrsEnd || !Instrs->isReturn())
    return PError(FORMAT_RETURN);
  ++Instrs;
  if (Instrs == InstrsEnd)
    return PError(FORMAT_STORE);

  if (Instrs->getOpcode() == TargetOpcode::G_INTRINSIC_W_SIDE_EFFECTS &&
      cast<GIntrinsic>(*Instrs).getIntrinsicID() ==
          Intrinsic::riscv_pg_branch) {
    const CDSLInstr::Field *Target = nullptr;
    for (const auto &Field : CurInstr->fields)
      if (Field.type & CDSLInstr::BRANCH_OFFS) {
        if (Target || Field.fixedImm)
          return pError(FORMAT_IMM, &*Instrs);
        Target = &Field;
      }
    if (!Target)
      return pError(FORMAT_IMM, &*Instrs);
    auto *Cond = MRI.getVRegDef(Instrs->getOperand(2).getReg());
    if (!Cond)
      return pError(FORMAT, &*Instrs);
    auto [Err, Node] = traverse(MRI, *Cond);
    if (Err)
      return PError(Err);
    // Folding other observable writes into a branch needs a multi-root matcher.
    for (auto It = std::next(Instrs); It != InstrsEnd; ++It)
      if (It->mayStore() || It->hasUnmodeledSideEffects())
        return pError(MULTIPLE_STORES, &*It);
    // Branch on a nonzero value; comparisons already produce a boolean.
    if (!(isa<BinopNode>(Node) && cast<BinopNode>(*Node).Op == ISD::SETCC)) {
      LLT Type = Node->Type;
      Node = std::make_unique<CompareNode>(
          LLT::scalar(XLen), CmpInst::ICMP_NE, std::move(Node),
          std::make_unique<ConstantNode>(Type, 0));
    }
    IsBranch = true;
    return PPattern(std::make_unique<BranchNode>(std::move(Node),
                                                 std::string(Target->ident)));
  }
  if (Instrs->getOpcode() != TargetOpcode::G_STORE)
    return pError(FORMAT_STORE, &*Instrs);

  auto Result = traverseStore(MRI, *Instrs);
  // Return on error
  if (Result.first)
    return Result;

  Instrs++;

  for (; Instrs != InstrsEnd; Instrs++)
    if (Instrs->mayStore() || Instrs->hasUnmodeledSideEffects()) {
      MachineInstr &MI = *Instrs;
      return pError(PatternErrorT::MULTIPLE_STORES, &MI);
    }

  return Result;
}

bool PatternGen::runOnMachineFunction(MachineFunction &MF) {

  bool Generated = false;
  auto Cleanup = make_scope_exit([&] {
    if (!Generated)
      PatternGenArgs::Failed = true;
    // No semantic instruction, including an extraction-only intrinsic, may
    // reach the native instruction selector after success or failure.
    for (auto &MBB : MF)
      MBB.clear();
  });

  // for convenience
  XLen = PatternGenArgs::Args.Is64Bit ? 64 : 32;
  RegT = PatternGenArgs::Args.Is64Bit ? "i64" : "i32";
  MayLoad = 0;
  MayStore = 0;
  IsBranch = 0;

  if (PatternGenArgs::Args.DumpMIR) {
    MF.print(errs());
  }

  std::string InstName = MF.getName().str().substr(4);
  ++PatternGenNumInstructionsProcessed;
  {
    auto It = std::find_if(
        PatternGenArgs::Instrs->begin(), PatternGenArgs::Instrs->end(),
        [&](CDSLInstr const &Inst) { return Inst.name == InstName; });
    assert(It != PatternGenArgs::Instrs->end() &&
           "implementation function without instruction definition");
    CurInstr = It.base();
  }
  std::string InstMnemonic = CurInstr->mnemonic;
  std::string LLVMInstr = CurInstr->llvm_instr;
  std::string InstNameO = LLVMInstr.empty() ? InstName : LLVMInstr;

  // We use the PatternArgs vector to store additional information
  // about parameters that may be found during pattern gen.
  PatternArgs.clear();
  PatternArgs.append(CurInstr->fields.size(), PatternArg());
  for (unsigned I = 0; I < CurInstr->fields.size() - 1; ++I)
    if (CurInstr->fields[I].type & CDSLInstr::BRANCH_OFFS) {
      PatternArgs[I].In = true;
      PatternArgs[I].ArgTypeStr = "patterngen_btarget";
    }

  auto [Err, Node] = generatePattern(MF);
  if (Err) {
    llvm::errs() << "Pattern Generation failed for " << MF.getName() << ": "
                 << Errors[Err.Type] << '\n';
    ++(*ErrorStats[Err.Type]);
    if (Err.Inst) {
      llvm::errs() << "Match failure occurred here:\n";
      llvm::errs() << *Err.Inst << "\n";
    }
    ++PatternGenNumInstructionsFailing;
    ++PatternGenNumPatternsFailing;
    return true;
  }

  LLT OutType = LLT();
  std::string OutsString;
  std::string InsString;
  std::string PatternDstOps;
  std::string BranchOperand;
  std::string BranchPatternOperand;
  for (size_t I = 0; I < CurInstr->fields.size() - 1; I++) {
    const auto &Field = CurInstr->fields[I];
    if (IsBranch && (Field.type & CDSLInstr::BRANCH_OFFS)) {
      if (Field.len != 13 || !(Field.type & CDSLInstr::SIGNED)) {
        errs() << "Pattern Generation failed for " << MF.getName()
               << ": branch offset must be signed<13>\n";
        return true;
      }
      // The MC branch fixup uses the standard B-format displacement layout.
      static constexpr unsigned DestBits[] = {0,  8,  9,  10, 11, 25, 26,
                                              27, 28, 29, 30, 7,  31};
      unsigned Seen = 0;
      bool ValidLayout = true;
      for (const auto &Frag : CurInstr->frags) {
        if (Frag.idx != I)
          continue;
        for (unsigned Bit = 0; Bit < Frag.len; ++Bit) {
          unsigned Source = Frag.srcOffset + Bit;
          if (Source == 0 || Source > 12 ||
              DestBits[Source] != Frag.dstOffset + Bit ||
              (Seen & (1u << Source))) {
            ValidLayout = false;
            break;
          }
          Seen |= 1u << Source;
        }
      }
      if (!ValidLayout || Seen != 0x1ffe) {
        errs() << "Pattern Generation failed for " << MF.getName()
               << ": branch offset must use the RISC-V B-format bit layout\n";
        return true;
      }
      BranchOperand = "patterngen_btarget:$" + std::string(Field.ident) + ", ";
      BranchPatternOperand = "bb:$" + std::string(Field.ident) + ", ";
      continue;
    }
    if (Field.fixedImm) {
      InsString += makeImmTypeStr(Field.len, Field.type & CDSLInstr::SIGNED,
                                  Field.llvm_type) +
                   ":$" + std::string(Field.ident) + ", ";
      PatternDstOps += std::to_string(*Field.fixedImm) + ", ";
      continue;
    }
    // handle unused operands
    if (!PatternArgs[I].In && !PatternArgs[I].Out) {
      llvm::errs() << "Pattern Generation failed for " << MF.getName() << ": "
                   << "Operand '" << CurInstr->fields[I].ident
                   << "' not used in pattern!\n";
      ++PatternGenNumErrorUnusedOperand;
      return true;
    }

    // check for missmatches between operands
    if ((CurInstr->fields[I].type & CDSLInstr::IN) && !PatternArgs[I].In) {
      llvm::errs() << "Pattern Generation failed for " << MF.getName() << ": "
                   << "Operand '" << CurInstr->fields[I].ident
                   << "' should be an input!\n";
      ++PatternGenNumErrorOperandMissmatch;
      return true;
    }
    if ((CurInstr->fields[I].type & CDSLInstr::OUT) && !PatternArgs[I].Out) {
      llvm::errs() << "Pattern Generation failed for " << MF.getName() << ": "
                   << "Operand '" << CurInstr->fields[I].ident
                   << "' should be an output!\n";
      ++PatternGenNumErrorOperandMissmatch;
      return true;
    }

    if (PatternArgs[I].In) {
      std::string Op = PatternArgs[I].ArgTypeStr + ":$" +
                       std::string(CurInstr->fields[I].ident) + ", ";
      InsString += Op;
      PatternDstOps += Op;
    }
    if (PatternArgs[I].Out) {
      bool IO = PatternArgs[I].In;
      OutsString += PatternArgs[I].ArgTypeStr + ":$" +
                    std::string(CurInstr->fields[I].ident) +
                    (IO ? "_wb, " : ", ");

      assert(!OutType.isValid());
      OutType = PatternArgs[I].Llt;
    }
  }

  InsString += BranchOperand;
  PatternDstOps += BranchPatternOperand;
  llvm::outs() << "Pattern for " << InstName << " [" << InstMnemonic
               << "]: " << Node->patternString() << '\n';
  ++PatternGenNumPatternsGenerated;

  InsString = InsString.substr(0, InsString.size() - 2);
  PatternDstOps = PatternDstOps.substr(0, PatternDstOps.size() - 2);
  OutsString = OutsString.substr(0, OutsString.size() - 2);

  auto &OutStream = *PatternGenArgs::OutStream;

  std::string TargetDefName = InstNameO + "_";
  if (EmittedInstructionDefs.insert(TargetDefName).second) {
    OutStream << "let hasSideEffects = " + std::to_string((int)HasSideEffects) +
                     ", mayLoad = " + std::to_string((int)MayLoad) +
                     ", mayStore = " + std::to_string((int)MayStore) +
                     ", isBranch = " + std::to_string((int)IsBranch) +
                     ", isTerminator = " + std::to_string((int)IsBranch) +
                     ", isCodeGenOnly = 1";

    if (IsBranch)
      OutStream << ", Format = InstFormatB";
    OutStream << ", Constraints = \"";
    {
      std::string Constr = "";
      for (size_t I = 0; I < CurInstr->fields.size(); I++) {
        auto const &Field = CurInstr->fields[I];
        if (PatternArgs[I].In && PatternArgs[I].Out)
          Constr += "$" + std::string(Field.ident) + " = $" +
                    std::string(Field.ident) + "_wb, ";
      }
      Constr = Constr.substr(0, Constr.size() - 2);
      OutStream << Constr;
    }
    OutStream << "\" in ";
    OutStream << "def " << TargetDefName << " : RVInst_" << InstNameO
              << "<(outs " << OutsString << "), (ins " << InsString << ")>;\n";
  }

  std::string PatternStr = Node->patternString();
  // Folding a shared load would introduce another memory access. In
  // particular, duplicating a volatile read changes observable behavior.
  if (MayLoad && !isa<LoadNode>(Node.get())) {
    for (const char *Op : {"load", "sextloadi8", "sextloadi16", "sextloadi32",
                           "zextloadi8", "zextloadi16", "zextloadi32"}) {
      std::string Needle = "(" + std::string(Op) + " ";
      if (PatternStr.find(Needle) == std::string::npos)
        continue;
      std::string Fragment = InstNameO + "_singleuse_" + Op;
      if (EmittedInstructionDefs.insert(Fragment).second) {
        // PatFrags have no Predicates field: declare the helper outside the
        // instruction feature guard, then resume that guard for the rule.
        const std::string &Predicates = PatternGenArgs::Args.Predicates;
        if (!Predicates.empty())
          OutStream << "}\n";
        OutStream << "def " << Fragment
                  << " : PatFrag<(ops node:$ptr), (" << Op
                  << " node:$ptr)> { let HasOneUse = 1; }\n";
        if (!Predicates.empty())
          OutStream << "let Predicates = [" << Predicates << "] in {\n";
      }
      std::string Replacement = "(" + Fragment + " ";
      size_t Pos = 0;
      while ((Pos = PatternStr.find(Needle, Pos)) != std::string::npos) {
        PatternStr.replace(Pos, Needle.size(), Replacement);
        Pos += Replacement.size();
      }
    }
  }
  std::string Code = "def : Pat<\n\t";

  if (OutType.isValid())
    Code += "(" + lltToString(OutType) + " " + PatternStr + "),\n\t(" +
            TargetDefName + " ";
  else
    Code += PatternStr + ",\n\t(" + TargetDefName + " ";

  Code += PatternDstOps;
  Code += ")>";
  // Address casts and pointer arithmetic lower to copies before selection.
  // Match the underlying arithmetic while retaining GlobalISel folding checks.
  if (MayLoad || MayStore)
    Code += ", GISelFlags { let GIIgnoreCopies = 1; }";
  else
    Code += ";";
  OutStream << "\n" << Code << "\n\n";

  Generated = true;
  return true;
}
