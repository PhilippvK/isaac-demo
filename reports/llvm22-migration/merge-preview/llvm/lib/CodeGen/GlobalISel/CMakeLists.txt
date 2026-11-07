option(ENABLE_CDFG_PASS "Enable the CDFG pass (requires mgclient)" OFF)

set(EXTRA_GISEL_SRCS "")

if(ENABLE_CDFG_PASS)
  list(APPEND EXTRA_GISEL_SRCS CDFGPass.cpp)
else()
  list(APPEND LLVM_OPTIONAL_SOURCES CDFGPass.cpp)
endif()

add_llvm_component_library(LLVMGlobalISel
  ${EXTRA_GISEL_SRCS}
  CSEInfo.cpp
  GISelValueTracking.cpp
  CSEMIRBuilder.cpp
  CallLowering.cpp
  GlobalISel.cpp
  Combiner.cpp
  CombinerHelper.cpp
  CombinerHelperArtifacts.cpp
  CombinerHelperCasts.cpp
  CombinerHelperCompares.cpp
  CombinerHelperVectorOps.cpp
  GIMatchTableExecutor.cpp
  GISelChangeObserver.cpp
  IRTranslator.cpp
  InlineAsmLowering.cpp
  InstructionSelect.cpp
  InstructionSelector.cpp
  LegalityPredicates.cpp
  LegalizeMutations.cpp
  Legalizer.cpp
  LegalizerHelper.cpp
  LegalizerInfo.cpp
  LegacyLegalizerInfo.cpp
  LoadStoreOpt.cpp
  Localizer.cpp
  LostDebugLocObserver.cpp
  MachineFloatingPointPredicateUtils.cpp
  MachineIRBuilder.cpp
  RegBankSelect.cpp
  Utils.cpp

  ADDITIONAL_HEADER_DIRS
  ${LLVM_MAIN_INCLUDE_DIR}/llvm/CodeGen/GlobalISel
  DEPENDS
  intrinsics_gen

  LINK_COMPONENTS
  Analysis
  CodeGen
  CodeGenTypes
  Core
  MC
  SelectionDAG
  Support
  Target
  TransformUtils
  )


if(ENABLE_CDFG_PASS)
  find_package(mgclient REQUIRED)
  TARGET_INCLUDE_DIRECTORIES(LLVMGlobalISel PUBLIC
    ${MGCLIENT_INCLUDE_DIRS}
  )
  target_link_libraries(LLVMGlobalISel PUBLIC mgclient)
  target_compile_definitions(LLVMGlobalISel PUBLIC HAS_CDFG_PASS)
  target_compile_definitions(LLVMCodeGen PUBLIC HAS_CDFG_PASS)
endif()
