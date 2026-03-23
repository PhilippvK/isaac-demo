## Variants Overview

WIP!

Markdown:

| Variant                                                         | Core     | RV32I | RV64I | M | A | C | F | D | Zicsr | Zifencei | B (Bitmanip) | V (Vector) | Custom / Vendor | XISAAC |
| --------------------------------------------------------------- | -------- | ----- | ----- | - | - | - | - | - | ----- | -------- | ------------ | ---------- | --------------- | ------ |
| `vex_4s` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [VexRiscv](https://github.com/SpinalHDL/VexRiscv) (4 Stages) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ❌         | ❌ | ❌        | ⚠️ (WIP) |
| `vex_5s` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [VexRiscv](https://github.com/SpinalHDL/VexRiscv) (5 Stages) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ❌         | ❌ | ❌        | ⚠️ (WIP) |
| `cva5` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CVA5](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ❌         | ❌ | ❌        | ⚠️ (untested) |
| `cv32e40p` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CV32E40P](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ❌         | ❌ | ❌        | ⚠️ (untested) |
| `cv32e40p_xcorev` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CV32E40P](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ❌         | ❌ | ✅ (`xcvalu_xcvbi_xcvmac_xcvsimd`)        | ⚠️ (untested) |
| `cv32e40x` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CV32E40X](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                    | ✅ (`zba_zbb_zbc_zbs`)         | ❌ |  ❌       | ⚠️ (untested) |
| `cv32e40x_vicuna` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CV32E40X](TODO) + [Vicuna2.0](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                    | ✅ (`zba_zbb_zbc_zbs`)         | ✅ (`zve32x`) |  ❌       | ⚠️ (untested) |
| `cv32a60x` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | CV32A60X](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ✅ (`zba_zbb_zbc_zbs`)         | ❌ | ❌      | ⚠️ (untested) |
| `cv32a60x_vicuna` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CV32A60X](TODO) + [Vicuna2.0](TODO) | ✅    | ❌  | ✅ | ✅ | ❌ | ❌ | ❌     | ✅        | ✅                   | ✅ (`zba_zbb_zbc_zbs`)         | ✅ (`zve32x`) | ❌      | ⚠️ (untested) |
| `cva6` ([Docker](TODO), [Environment](TODO), [Config](TODO)) | [CVA6](TODO)     | ❌    | ✅  | ✅ | ✅ | ❌ | ❌| ❌     | ✅        | ✅                   | ❌          | ❌| ❌               | ⚠️ (untested) |
