# isaac-demo

This repository demonstrates the usage and setup of the ISAAC (ISA Automated Customization) toolkit and all its dependencies.

**Disclaimer:** This project consists of several complex dependencies. Make sure that you have a powerful machine and at least 30GB of disk space available

## Prerequisites

### Common

Make sure to clone all submodules!

```sh
git submodule update --init --recursive
```

### OS Packages

This demo is supposed to be run on an Ubuntu/Debian-like operating system. WSL2 was tested, too.

The following APT packages should be installed:

```sh
sudo apt install libssl-dev cmake build-essential graphviz graphviz-dev ninja-build poppler-utils ccache git libboost-system-dev libboost-filesystem-dev libboost-program-options-dev zlib1g-dev libtinfo-dev libxml2-dev libedit-dev libncurses5-dev libffi-dev libssl-dev unzip
```

Further requirements:
- Docker (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
- Python v3.10+
- CMake Version 3.20 or higher

### Python

Setup virtual Python environment. The following script will also automatically install the packages listed in `requirements.txt`.

```sh
./scripts/setup_python.sh
```

Before using the flow, make sure to source the environment script:

```sh
. scripts/env.sh
```

### Memgraph

A memgraph database is used to store the CDFGs of the software compiled by LLVM.

First, the memgraph platform itself (database, lab (GUI),...) can be launched using docker:

```sh
docker run -p 7687:7687 -p 7444:7444 -p 3000:3000 --name memgraph memgraph/memgraph-platform
```

Further, we need the `mgclient` libraries to interface with the platform.

Executing `scripts/setup_mgclient.sh` should to perform all required steps.

### CCache

CCache is used to speed up local LLVM & ETISS rebuilds. Make sure to have `ccache` installed and run `scripts/setup_ccache.sh` to initialize the `install/ccache` directory.

### LLVM

Our patched version of LLVM depends on the `mgclient` lib, hence that library has to be installed in the previous step.

We provide the `scripts/setup_llvm.sh` script which should allow you to install LLVM. This step will take a long time depending on your machine!

#### Local LLVM 22 port

LLVM 19 remains the default. Prepare the separate LLVM 22.1.8 CDFG checkout with
`scripts/prepare_llvm22.sh`; the portable patch is in `cfg/seal5/llvm22-isaac.patch`.
For local retargeting, set `LLVM_MAJOR=22` when running `scripts/flow_seal5.sh`.
The runner selects matching Seal5/PatternGen settings and retains its build tree.
`SEAL5_BUILD_THREADS` controls compilation concurrency; `CLEANUP=1` explicitly
opts into deleting that tree after exports complete. LLVM 22 outputs use a
separate directory from LLVM 19 outputs.

The Toolkit BB-map decoder handles formats 2–5. Keep
`-fbasic-block-sections=labels` for RISC-V compatibility across LLVM 19–22.
Unpatched LLVM compilers do not provide CDFG export: LLVM 20/21 local retargeting
requires a matching patched source or `ENABLE_CDFG_PASS=0`.
Local retargeting of the 32-ISE CRC32 set passes all 26 generated tests.
Toolkit RV32/RV64 compatibility probes pass on LLVM 19–22. Results, limitations
and reproduction instructions are in [the port report](reports/llvm22-port/report.md).

#### Fused conditional branches

The generation path supports arithmetic fused into `BEQ`, `BNE`, `BLT`, `BGE`,
`BLTU` and `BGEU`, using SelectionDAG TableGen patterns. Generated branch
patterns have `GISelShouldIgnore = 1`. Enable branch candidates in query/potential
filtering, generate and auto-encode the instruction set using the current
`M2-ISA-R` checkout, then enable branch lowering for local retargeting:

```bash
FUSED_BRANCHES=1 LLVM_MAJOR=22 scripts/flow_seal5.sh RUN_DIR
```

The optional configuration is `cfg/seal5/optional/fused-branches.yml`; it can
also be supplied directly to `docker/seal5_script_local.sh` after the model.
The initial supported shape has one conditional branch, at most two GPR inputs,
no register results and no memory effects. Its signed 13-bit byte displacement
uses the standard B-format bit placement and implicit zero low bit. Other
branch forms are filtered. Details and validation status are in
[the implementation note](reports/fused-branches-20261104/implementation.md).

#### Fused scalar memory instructions and selector choice

Integer loads/stores can be fused with address or data arithmetic. Enable
candidate filtering with `cfg/isaac/query/fused-memory.yml`, then retarget with:

```bash
FUSED_MEMORY=1 LLVM_MAJOR=22 scripts/flow_seal5.sh RUN_DIR
```

This uses ordinary TableGen patterns and LLVM's normal GlobalISel importer.
PatternGen's experimental direct GISel-table support is not used. The initial
scope is one scalar memory access, up to three GPR inputs, and no branch,
atomic or volatile candidate. Loads preserve access width and sign extension;
stores have no destination register. See the [validation report](reports/fused-memory-20261104/report.md).

Choose `GLOBAL_ISEL=0` (SelectionDAG) or `GLOBAL_ISEL=1` (GlobalISel).
`ISAAC_ISEL=dag|gisel` is an equivalent spelling; when both are set they must
agree. `flow_trace.sh` records the choice. `flow_compare.sh` and
`flow_retrace.sh` inherit it when no explicit override is supplied. Legacy
runs without selector metadata retain the DAG default. Pattern coverage can
differ between selectors; the existing fused branches currently use DAG.

To reuse the same discovered instruction set and evaluate both selectors:

```bash
FINAL=1 bash scripts/flow_compare_isel.sh RUN_DIR
```

This runs compare, retrace and reanalysis for each selector, retaining
`_isel_dag` and `_isel_gisel` outputs. `isel-comparison_final.json` compares
measured instruction counts, static ISE sites and dynamic ISE use. Discovery
is shared; this does not compare separately discovered instruction sets.

#### VEX_5S without reuse-I/O

The original `vex_5s` candidate policy is unchanged. The separate
`cfg/flow/paper/vex_5s_mem_branch.env` preset enables experimental scalar
memory and branch candidates with **reuse-I/O disabled**. It uses an explicit
Vex x0 writeback contract, SCAIE-V encoding constraints, CBC scheduling, and no
ASIP/FPGA synthesis by default.

Build the local HLS image containing the Vex subword-store generator fix:

```bash
docker build -f docker/Dockerfile_hls_vex -t isaac-quickstart-hls-vex5:local .
```

The preset selects this image; `VEX5_HLS_IMAGE` overrides it. See the
[Vex experiment](reports/vex-5s-hls-20261107/report.md) for CRC32 discovery,
real Nailgun/SCAIE-V RTL generation, firmware execution in RTL simulation,
known initial failures, and cycle/instruction measurements. The separate `vex_5s_arty_a7_100t` preset provides the validated Vex Arty shell.

#### Nailgun RTL benchmark simulation

CVA5 and VEX_5S have a shared RTL execution stage for the actual MLIF extraction
benchmarks through the native MLonMCU `nailgun` target, with native and retargeted variants, result validation, cycle
measurements and bounded execution. No FPGA board or Vivado is needed.

```bash
export RTL_SIM_VERILATOR=/path/to/verilator-5.040/bin/verilator
scripts/full_flow.sh crc32 latest rtl_sim_0
# Or insert simulation after each HLS stage:
export RTL_SIM_ENABLE=1
```

Run tracing, compiler retargeting and HLS first. Use the matching step suffix,
such as `rtl_sim_0_filtered_selected`, for a selected extension. See the
[RTL simulation guide](scripts/rtl_sim/README.md) for setup, target/runtime
constraints and overrides, and the
[integration validation report](reports/rtl-sim-integration-20261109/report.md)
for CRC32/SHA256 and generated memory ISE execution.

For Vex Arty hardware execution, use `scripts/full_flow.sh crc32 latest fpga_run_0`
after generating matching RTL and compiler artifacts. This explicit stage invokes
MLonMCU firmware generation, Vivado synthesis, volatile programming and validation.
See the same guide for board settings and the
[hardware follow-up results](reports/vex-fpga-followup-20261110/report.md).


#### CVA5 presets

Select the corresponding file under `cfg/flow/paper/`:

| Preset | Memory/branch candidates | FPGA target |
|---|---|---|
| `cva5_reuseio` | Disabled | Generic CVA5, xc7a200t |
| `cva5_reuseio_mem_branch` | Experimental | Generic CVA5, xc7a200t |
| `cva5_reuseio_arty_a7_100t` | Disabled | Arty A7-100, xc7a100t |
| `cva5_reuseio_mem_branch_arty_a7_100t` | Experimental | Arty A7-100, xc7a100t |

The original query and potential filters disable memory and branches. The
experimental preset selects separate query and Toolkit YAML files. Branch
FPGA execution still has a known backward-BGEU stall; see the execution report.

#### CVA5 / SCAIE-V 2.0 encodings

The experimental `cva5_reuseio_mem_branch` preset enables
`ISAAC_ENCODING_INTERFACE=scaiev2`.
`flow_isaac_etiss.sh` forwards this as `--encoding-interface scaiev2` to the
shared instruction allocator. The compiler, simulator and HLS exports then
use the same constrained encodings.

Memory instructions retain the source load/store's RISC-V `funct3` field
(bits 14:12): LB/SB=000, LH/SH=001, LW/SW=010, LD/SD=011;
unsigned loads LBU/LHU/LWU use 100/101/110. SCAIE-V distinguishes encodings
using opcode, funct3 and funct7, so allocation also checks collisions under
the decoder mask `0xfe00707f`. Fixed unused register-field bits cannot serve
as additional discriminators in this mode. Incompatible layouts, pinned
manifests and existing decoder overlaps are rejected.

`encoding_interface.json` records the decoder mask and per-instruction
constraints next to `encoding_plan.json`. The default `generic` mode retains
the full 32-bit decoding policy. See the
[CVA5 HLS report](reports/cva5-reuseio-hls-20261105/report.md).

#### CVA5 FPGA synthesis on Arty A7-100

The `cva5_reuseio_arty_a7_100t` preset selects `FPGA_SYN_BOARD=arty_a7_100`,
`xc7a100tcsg324-1`, and a 20 MHz core clock. The board shell keeps AXI
internal, derives the clock from the 100 MHz oscillator, and connects
reset button 0 and a 115200-baud UART. See the
[board-shell instructions](scripts/fpga_syn/boards/arty_a7_100/README.md)
and [Arty implementation report](reports/cva5-arty-a7-100-20261105/build-results.md).
Optional memory initialization is separate from synthesis; ETISS semihosting
firmware does not directly provide board UART support.
Physical UART execution results, firmware sources, and cycle comparisons are
in the [FPGA execution report](reports/cva5-fpga-execution-20261105/report.md).

### ETISS

The simulator used for tracing and evaluating custom instruction candidates. Before starting extending ETISS, you will need to install ETISS once by running the `scripts/setup_etiss.sh` script.

### MLonMCU

MLonMCU is our automated benchmarking and deployment flow for TinyML applications. It supports a large numbert of different frontends/frameworks/targets/features/... and is also capable of executing non-ML workloads (i.e. general purpose embedded ebenchmarks). Here we use MLonMCU for tracing the programs of interest.

Execute `scripts/setup_mlonmcu.sh` to initialize a MLonMCU environment and install all dependencies. This step will take a long time depending on the available number of CPU cores and internet speed.

### M2-ISA-R

To update our ETISS cores, the M2-ISA-R metamodelling tool is used. ISAAC will interface with M2-ISA-R automatically (assuming it's found in `PYTHONPATH`), hence it does not need to be installed here.


### Memgraph Experiments

This repository contains the tools/scripts to query and evaluate candidates for custom instructions from the Memgraph DB. The tool is called automatically from ISAAC whithout a need for installation.


### ISAAC

Finally, the ISAAC toolkit itself deserves some words. ISAAC is fully-written in Python and manages its internal state in sessions stored in directories. Here, we use the command line to interface with ISAAC, but a Python-based API is aslo available.

## Demos

### MLonMCU (ETISS RV64 + CoreMark)

0. Define common settings and paths.

```sh
# export MLONMCU_HOME=... (if not already done via . scripts/env.sh)
BENCH=coremark
DATE=$(date +%Y%m%dT%H%M%S)
LABEL=isaac-demo-$BENCH-$DATE
STAGE=32  # 32 -> post finalizeisel/expandpseudos

OUT_DIR_BASE=$(pwd)/out
OUT_DIR=out/$BENCH/$DATE
mkdir -p $OUT_DIR

RUN=$OUT_DIR/run
SESS=$OUT_DIR/sess
WORK=$OUT_DIR/work
```

1. First, we run a baseline benchmark without ISAAC extensions.

```sh
python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-baseline
```

2. Now, we re-run the same experiment with tracing features enabled.

```sh
python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=1 --label $LABEL-trace

python3 -m mlonmcu.cli.main export --run -- $RUN
```

3. We setup an ISAAC session and load all relevant files

Hints:
- If a ISAAC session already exists, either remove the `sess` dir first or add an `--force` to each of the remaining commands.
- Make sure that the Memgraph Container hosting the graph database is up and running: `docker ps`

```sh
python3 -m isaac_toolkit.session.create --session $SESS

python3 -m isaac_toolkit.frontend.elf.riscv $RUN/generic_mlonmcu --session $SESS
python3 -m isaac_toolkit.frontend.linker_map $RUN/mlif/generic/linker.map --session $SESS
python3 -m isaac_toolkit.frontend.instr_trace.etiss $RUN/etiss_instrs.log --session $SESS --operands
python3 -m isaac_toolkit.frontend.disass.objdump $RUN/generic_mlonmcu.dump --session $SESS
python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session $SESS --label $LABEL

```

4. Run the analysis and transform steps in ISAAC.

```sh
python3 -m isaac_toolkit.analysis.static.dwarf --session $SESS
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session $SESS
python3 -m isaac_toolkit.analysis.static.mem_footprint --session $SESS
python3 -m isaac_toolkit.analysis.static.linker_map --session $SESS
python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session $SESS --imm-only
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode --sess $SESS
python3 -m isaac_toolkit.analysis.dynamic.histogram.instr --sess $SESS
python3 -m isaac_toolkit.analysis.static.histogram.disass_instr --sess $SESS
python3 -m isaac_toolkit.analysis.static.histogram.disass_opcode --sess $SESS
python3 -m isaac_toolkit.analysis.dynamic.trace.basic_blocks --session $SESS
python3 -m isaac_toolkit.analysis.dynamic.trace.map_llvm_bbs_new --session $SESS
python3 -m isaac_toolkit.analysis.dynamic.trace.track_used_functions --session $SESS
python3 -m isaac_toolkit.backend.memgraph.annotate_bb_weights --session $SESS --label $LABEL
```

5. Investigate and plot the ISAAC artifacts.

```sh
tree $SESS/table
# ...
python3 -m isaac_toolkit.visualize.pie.runtime --sess $SESS --legend
python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess $SESS --legend
python3 -m isaac_toolkit.visualize.pie.disass_counts --sess $SESS --legend
ls $SESS/plots
# ...
```

6. Continue with the automatic generation of ISAX candidates

```sh
# Create workdir
mkdir -p $WORK

# Make choices (func_name + bb_name)
python3 -m isaac_toolkit.generate.ise.choose_bbs --sess $SESS --threshold 0.9 --min-weight 0.05 --max-num 3 --force

# Look at choices
python3 -m isaac_toolkit.utils.pickle_printer $SESS/table/choices.pkl

# Generate candidates for custom instructions
python3 -m isaac_toolkit.generate.ise.query_candidates_from_db --sess $SESS --workdir $WORK --label $LABEL --stage $STAGE

# Check number of selected candidates per function
# cat $WORK/crcu16_%bb.0_0/pie.csv
# ...

# Investigate properties of selected candidates
# less $WORK/combined_index.yml

# Lookup generated CDSL/Flat code
# cat $WORK/gen/name1.core_desc
# cat $WORK/gen/name1.flat
# cat $WORK/gen/name1.fuse_core_desc
```

7. Combine candidates into ETISS core.

```sh
python3 -m isaac_toolkit.generate.iss.generate_etiss_core --sess $SESS --workdir $WORK --core-name XIsaacCore --set-name XIsaac --xlen 32 --semihosting --base-extensions "i,m,a,f,d,c,zicsr,zifencei" --auto-encoding --split --base-dir $(pwd)/etiss_arch_riscv/rv_base/ --tum-dir $(pwd)/etiss_arch_riscv

# Investigate generated instruction set
# cat $WORK/XIsaac.core_desc
```

8. Perform the retargeting of ETISS/LLVM.

```sh
# TODO:
# patch_llvm

# locally (TODO)
# TODO: prepare/build docker image

# via docker (WIP)
# TODO: replace hardcoded cfg paths
mkdir -p $WORK/docker/
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-seal5:latest $WORK/docker/ $WORK/XIsaac.core_desc $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml $(pwd)/cfg/seal5/riscv.yml

# patch_etiss
docker run -it --rm -v $(pwd):$(pwd) isaac-quickstart-etiss:latest $WORK/docker/ $WORK/XIsaacCore.core_desc

# TODO: fix or run etiss in docker?
# rebuild etiss on host (due to libbost incompatibility in docker)
# mkdir -p $WORK/docker/etiss_source
# cd $WORK/docker/etiss_source
# zip ../etiss_source.zip
# cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$(pwd)/install
# cmake --build build/ -j `nproc`
# cmake --install build
# cd -


# hls flow
cp $WORK/XIsaac.hls.core_desc /work/git/tuda/isax-tools-integration/nailgun/isaxes/isaac.core_desc  # TODO: do not hardcode
# TODO: allow running the flow for multiple isaxes in parallel
mkdir -p $WORK/docker/hls/
sudo chmod 777 -R $WORK/docker/hls
mkdir -p $WORK/docker/hls/output
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools/nailgun && CONFIG_PATH=$WORK/docker/hls/.config OUTPUT_PATH=$WORK/docker/hls/output ISAXES=ISAAC SIM_EN=n CORE=VEX_4S SKIP_AWESOME_LLVM=y make gen_config ci"
python3 collect_hls_metrics.py $WORK/docker/hls/output --output $WORK/docker/hls/hls_metrics.csv --print
python3

# synthesis flow
# starting at 25 MHz (40ns period) clk
cp $WORK/docker/hls/output/ISAX_sqrt_stall.sv $WORK/docker/hls/output/VexRiscv_4s
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) isaac-quickstart-hls:latest "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py $WORK/docker/hls/output/VexRiscv_4s/ $WORK/docker/hls/syn_dir prj LEGACY 40 20 top clk"
# TODO: pick best prj?
PRJ="prj_LEGACY_38.46153846153847ns_30.0%"
python3 collect_syn_metrics.py $WORK/docker/hls/syn_dir/$PRJ --output $WORK/docker/hls/syn_metrics.csv --print --min --rename
# TODO: cleanup old!
```

TODO: analyze seal5 reports
TODO: run etiss tests
TODO: collect hls metrics
TODO: openlane flow
TODO: cost/benefit analysis
TODO: rtl sim (verilator)

9. Test if everything still works?

```sh
# python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-isaacnew -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_source/build --config-gen _ --config-gen etiss.arch=rv32imfd_xisaac
python3 -m mlonmcu.cli.main flow run $BENCH --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm --label $LABEL-isaacnew -c etissvp.script=$WORK/docker/etiss_install/bin/run_helper.sh -c etiss.cpu_arch=XIsaacCore -c etiss.print_outputs=1 -c llvm.install_dir=$WORK/docker/llvm_install --config-gen _ --config-gen etiss.arch=rv32imfd_xisaac --post config2cols -c config2cols.limit=etiss.arch --post rename_cols -c rename_cols.mapping="{'config_etiss.arch': 'Arch'}"
python3 -m mlonmcu.cli.main export --session -- ${RUN}_compare
# TODO: -f global_isel
```

### More compact ISAAC Flow



### Automated Flow Scripts

**Examples:**

```sh
# Source config file first
source scripts/defaults.env
source cfg/flow/paper/vex_5s.env

# Override out dir (optional)
export OUT_DIR=$(pwd)/out

# Syntax
./scripts/full_flow.sh [FRONTEND/PROG] [DATE|now|latest] [STAGE[;STAGE[;...]]]

# Run multiple stages
./scripts/full_flow.sh embench/picojpeg now "all"
./scripts/full_flow.sh embench/picojpeg latest "bench_0;trace_0;isaac_0_load"
./scripts/full_flow.sh embench/picojpeg 20250709T162530 "until_isaac_new"

# Run single stage
./scripts/full_flow.sh embench/picojpeg latest "isaac_0_generate"
```

**Directory structure**

```
out/embench/picojpeg/20250709T162530
├── experiment.ini  # Contains metadata
├── logs/  # Log files
├── run*/  # MLonMCU artifacts
├── sess*/  # ISAAC Sessions
├── times.csv  # Profiling of stages
├── vars.env  # Snapshot of environment vars
└── work/  # Working directory for ISA DSE
```

### WIP: Docker Flows

```
git submodule update --init --recursive -- seal5 etiss mlonmcu isaac-toolkit memgraph_experiments etiss_arch_riscv
```


## Investigation reports

Performance measurements, BB identity/compiler traces, and decoder/mapping notes
are retained under [reports/](reports/README.md), including selected evidence and
reproducers. They do not depend on temporary-directory retention.

### ASIP standard-cell synthesis

The [Design Compiler guide](scripts/asip_syn/README.md) describes reproducible
Nangate45 and Sky130 library preparation and matched baseline/extension area
and timing evaluation. Nangate45 remains the default. Use `ASIP_SYN_LIBRARY`
for an existing `.db` or the pinned open-library preparation helper.

OpenLane2/LibreLane can also be selected as independent ASIP synthesis targets
with `ASIP_SYN_TOOL=ol2` or `librelane`. Use the Vex `vex_5s_openlane2.env` or
`vex_5s_librelane.env` preset and the normal `syn_0` stage. The
[backend guide](scripts/asip_syn/README.md#independent-openlane2-and-librelane-target)
explains native/Docker setup, PDK requirements, metrics and preserved evidence.
