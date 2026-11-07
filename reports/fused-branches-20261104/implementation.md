# Fused conditional branch generation

## Implementation

- Candidate operand analysis identifies target labels as displacement inputs,
  orders targets last, and excludes the branch effect from destination registers.
- Tree generation retains the branch as an explicit effect. BEQ/BNE use unsigned
  equality; BLT/BGE use signed XLEN comparisons; BLTU/BGEU use unsigned comparisons.
  Pure intermediate declarations are expanded into a single conditional PC update,
  which the existing Seal5 branch recognizer can lower. Normal and fused CoreDSL
  output use the same semantics, including `no_cont` and `cond` attributes.
- The `offset` operand is a signed 13-bit byte displacement annotated
  `is_branch_offs`. Encoding accounting reserves 12 physical bits (bit zero is
  implicit), and the M2-ISA-R planner allocates a B-format custom instruction.
  Fragments map offset[12], [10:5], [4:1], [11] to instruction bits 31, 30:25,
  11:8, 7. Existing allocator collision checks and pinned manifests still apply.
  Free source-selector capacity may hold additional small immediate operands.
- Planner fields now retain their logical source bit position. Ordinary fields
  keep their old manifest representation. The new operand enum member is appended
  to preserve existing enum values in serialized models.
- Unsupported branches and multiple branch effects are filtered. Branches with
  register results, memory effects, or more than two GPR selectors are excluded.
  Register reuse and constant-variation passes currently skip branch candidates.
- Seal5 marks recognized branches as branch terminators, uses its existing
  B-target/encoding support, and wraps branch pattern output in
  `let GISelShouldIgnore = 1`. No branch GlobalISel table or selector is added.
- `FUSED_BRANCHES=1 scripts/flow_seal5.sh RUN_DIR` supplies the optional Seal5
  normalization/branch settings. Queries and potential filtering must separately
  permit branch candidates. Local retargeting uses the current main M2-ISA-R;
  the older separate `M2-ISA-R-new` checkout does not include this encoding change.

## Validation status

End-to-end verification passed on LLVM22 / RV32 after fixing intrinsic model
writing, the TableGen ignore-flag scope, and matching RISC-V's lowered branch DAG.
All six ISEs are generated, selected from C and executed. The differential suite
passes 15,834 cases, including backward/boundary offsets and relaxed long branches.
Generation and encoding also pass for RV64. GlobalISel remains excluded.

See [the full test report](report.md) for exact coverage, fixes, reproduction,
retained evidence and limits. The earlier implementation-only status is superseded.
