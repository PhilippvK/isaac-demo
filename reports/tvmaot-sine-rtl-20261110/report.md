# TVM AOT sine model on Nailgun RTL

## Result

**Pass on VEX_5S and CVA5: all four supplied inputs match the supplied model
reference outputs with `atol=1e-6`, `rtol=1e-6`.** Both cores produce bit-identical
float32 outputs. Maximum absolute difference from the references is
`2.384185791015625e-7`.

| Input | RTL output, both cores | Supplied model reference |
|---:|---:|---:|
| 0 | 0.0320389867 | 0.0320388675 |
| 1.57 | 0.952165425 | 0.952165186 |
| 3.14 | -0.0468829274 | -0.0468828082 |
| 4.71 | -1.01331592 | -1.01331568 |

This tests the learned model against its supplied reference values, not against
exact mathematical `sin(x)`. Numerical `allclose` was selected explicitly;
classification top-k checks on a scalar output would not establish correctness.

## Configuration

- MLonMCU `sine_model` / `tvmaot`, native `nailgun` target.
- TVM 0.18.0, C AOT code generation, CRT, 160-byte reported workspace.
- LLVM22 GISel; the existing explicit DAG exception remains only `bench.c`.
- RV32IM/ILP32, software floating point; no hardware FPU is required.
- MLIF template **v2**, generated ROM input buffers, binary stdout result capture.
- Four supplied file inputs/references; `validate_new` and `validate_outputs`.
- Generated baseline Vex/CVA5 RTL from the earlier HLS experiments; no FPGA board.

The legacy MLIF v1 template does not consume generated validation I/O. A first
v1 attempt executed firmware but emitted no result arrays, so it was rejected
at postprocessing and is not counted as a validated run.

## Fix required

MLonMCU's file-input loader unconditionally attempted quantization, asserting
that float32 sine inputs were integers. It now quantizes only when quantization
metadata exists and the stored/input dtypes differ. This preserves unquantized
float file inputs. The generated ROM buffers contain the original four float32
input values unchanged.

No model, generated RTL, TVM source or LLVM source was changed. The test used an
existing TVM installation and a local copy of the tflite 2.18.0 schema package;
paths and revisions are recorded in `source-versions.json` and
`dependency-notes.json`. On a new setup install the schema package in the Python
environment or provide its directory on TVM's Python path.

## Preserved evidence

`vex/` and `cva5/` contain the model, generated AOT archive, wrapper, firmware ELF,
compile commands, input/reference/actual NumPy arrays, numerical results,
MLonMCU report and RTL execution logs/metadata. `results.json` compares both
cores. Bulk build trees and the borrowed dependency copy are excluded from Git.
`run.sh` records the reusable command; configure normal TVM/LLVM/GNU paths first.

The run initially encountered a full filesystem. Only previously generated,
rebuildable Verilator `obj_dir` directories were removed with approval;
committed source, firmware and evidence remained intact.
