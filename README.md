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
