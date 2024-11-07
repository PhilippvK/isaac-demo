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

This demo is supposed to be run on an Ubuntu/Debia-like operating system. WSL2 should work but was not tested!

In addition to the default development packages (CMake, build-essential,...), the following SW is required to run this demo:

- Docker (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
- Python v3.10

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

### LLVM

Our patched version of LLVM depends on the `mgclient` lib, hence that library has to be installed ion the previous step.

We provide the `scripts/setup_llvm.sh` scrip[t which should allow you to install LLVM. This step will take a long time depending on your machine!

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

0. Define common settings.

```sh
# export MLONMCU_HOME=... (if not already done via . scripts/env.sh)
LABEL=isaac-demo-$(date +%Y%m%dT%H%M%S)
STAGE=32  # 32 -> post finalizeisel/expandpseudos
```

1. First, we run a baseline benchmark without ISAAC extensions.

```sh
python3 -m mlonmcu.cli.main flow run coremark --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm
```

2. Now, we re-run the same experiment with tracing features enabled.

```sh
python3 -m mlonmcu.cli.main flow run coremark --target etiss -c run.export_optional=1 -c etiss.compressed=0 -c etiss.atomic=0 -c etiss.fpu=double -c mlif.debug_symbols=1 -v -c mlif.toolchain=llvm -f memgraph_llvm_cdfg -c memgraph_llvm_cdfg.session=$LABEL -c memgraph_llvm_cdfg.stage=$STAGE -f llvm_basic_block_sections -f log_instrs -c log_instrs.to_file=1 -c mlif.num_threads=1

```

3. We setup an ISAAC session and load all relevant files

Hints:
- If a ISAAC session already exists, either remove the `sess` dir first or add an `--force` to each of the remaining commands.
- Make sure that the Memgraph Container hosting the graph database is up and running: `docker ps`

```sh
python3 -m isaac_toolkit.session.create --session sess

python3 -m isaac_toolkit.frontend.elf.riscv install/mlonmcu/temp/sessions/latest/runs/latest/generic_mlonmcu --session sess
python3 -m isaac_toolkit.frontend.linker_map install/mlonmcu/temp/sessions/latest/runs/latest/mlif/generic/linker.map --session sess
python3 -m isaac_toolkit.frontend.instr_trace.etiss install/mlonmcu/temp/sessions/latest/runs/latest/etiss_instrs.log --session sess --operands
python3 -m isaac_toolkit.frontend.memgraph.llvm_mir_cdfg --session sess --label $LABEL

```

4. Run the analysis and transform steps in ISAAC.

```sh
python3 -m isaac_toolkit.analysis.static.dwarf --session sess
python3 -m isaac_toolkit.analysis.static.llvm_bbs --session sess
python3 -m isaac_toolkit.analysis.static.mem_footprint --session sess
python3 -m isaac_toolkit.analysis.static.linker_map --session sess
python3 -m isaac_toolkit.analysis.dynamic.trace.instr_operands --session sess --imm-only
python3 -m isaac_toolkit.analysis.dynamic.histogram.opcode --sess sess
python3 -m isaac_toolkit.analysis.dynamic.histogram.instr --sess sess
python3 -m isaac_toolkit.analysis.dynamic.trace.basic_blocks --session sess
python3 -m isaac_toolkit.analysis.dynamic.trace.map_llvm_bbs_new --session sess
python3 -m isaac_toolkit.analysis.dynamic.trace.track_used_functions --session sess
python3 -m isaac_toolkit.backend.memgraph.annotate_bb_weights --session sess --label $LABEL
```

5. Investigate and plot the ISAAC artifacts.

```sh
tree sess/table
# ...
python3 -m isaac_toolkit.visualize.pie.runtime --sess sess --legend
python3 -m isaac_toolkit.visualize.pie.mem_footprint --sess sess --legend
ls sess/plots
# ...
```

6. Continue with the automatic generation of ISAX candidates

```sh
# Create workdir
mkdir -p work

# Make choices (func_name + bb_name)
python3 -m isaac_toolkit.generate.ise.choose_bbs --sess sess --threshold 0.9 --min-weight 0.05 --max-num 3 --force

# Look at choices
python3 -m isaac_toolkit.utils.pickle_printer sess/table/choices.pkl

# Generate candidates for custom instructions
python3 -m isaac_toolkit.generate.ise.query_candidates_from_db --sess sess --workdir work --label $LABEL --stage $STAGE

# Check number of selected candidates per function
# cat work/crcu16_%bb.0_0/pie.csv
# ...

# Investigate properties of selected candidates
# less work/combined_index.yml

# Lookup generated CDSL/Flat code
# cat work/gen/name1.core_desc
# cat work/gen/name1.flat
# cat work/gen/name1.fuse_core_desc
```

7. Combine candidates into ETISS core.

```sh
python3 -m isaac_toolkit.generate.iss.generate_etiss_core --sess sess --workdir work --core-name XIsaacCore --set-name XIsaac --xlen 32 --semihosting --base-extensions "i,m,a,f,d,c,zifencei" --auto-encoding --split --base-dir $(pwd)/etiss_arch_riscv/rv_base/ --tum-dir $(pwd)/etiss_arch_riscv

# Investigate generated instruction set
# cat work/XIsaac.core_desc
```

8. Perform the retargeting of ETISS/LLVM.

```sh
# TODO:
# patch_llvm

# locally (TODO)
# TODO: prepare/build docker image

# via docker (WIP)
# TODO: replace hardcoded cfg paths
mkdir work/docker/
docker run -it --rm -v $(pwd):$(pwd) seal5-quickstart:minimal2 $(pwd)/work/docker/ $(pwd)/work/XIsaac.core_desc $(pwd)/cfg/seal5/patches.yml $(pwd)/cfg/seal5/llvm.yml $(pwd)/cfg/seal5/git.yml $(pwd)/cfg/seal5/filter.yml $(pwd)/cfg/seal5/tools.yml


# patch_etiss
docker run -it --rm -v $(pwd):$(pwd) --entrypoint /work/etiss_script.sh seal5-quickstart:minimal2 $(pwd)/work/docker/ $(pwd)/work/XIsaacCore.core_desc


# hls flow
mkdir $(pwd)/work/docker/hls/
sudo chmod 777 -R work/docker/hls
mkdir $(pwd)/work/docker/hls/output
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) jhvjkcyyfdxghjk/isax-tools-integration-env "date && cd /isax-tools/nailgun && CONFIG_PATH=/work/git/isaac-demo/work/docker/hls/.config OUTPUT_PATH=/work/git/isaac-demo/work/docker/hls/output ISAXES=SQRT_STALL SIM_EN=n TB_PATH=/isax-tools/nailgun/../custom_tbs/sqrt.cpp TB_EXPECTED_PATH=/isax-tools/nailgun/../custom_tbs/sqrt_expected.txt CORE=VEX_4S SKIP_AWESOME_LLVM=y make ci"
python3 collect_hls_metrics.py work/docker/hls/output --output work/docker/hls/hls_metrics.csv --print
python3

# synthesis flow
# starting at 25 MHz (40ns period) clk
cp work/docker/hls/output/ISAX_sqrt_stall.sv work/docker/hls/output/VexRiscv_4s
docker run -it --rm -v /work/git/tuda/isax-tools-integration/:/isax-tools -v $(pwd):$(pwd) jhvjkcyyfdxghjk/isax-tools-integration-env "date && cd /isax-tools && volare enable --pdk sky130 0fe599b2afb6708d281543108caf8310912f54af && python3 dse.py /work/git/isaac-demo/work/docker/hls/output/VexRiscv_4s/ /work/git/isaac-demo/work/docker/hls/syn_dir prj LEGACY 40 20 top clk"
# TODO: pick best prj?
PRJ="prj_LEGACY_38.46153846153847ns_30.0%"
python3 collect_syn_metrics.py work/docker/hls/syn_dir/$PRJ --output work/docker/hls/syn_metrics.csv --print --min --rename
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
# TODO: !
```
