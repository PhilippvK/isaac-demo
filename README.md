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

1. First, we run a baseline benchmark without ISAAC extensions.

```sh

```

2. Now, we re-ru n the same experiment with tracing features enabled.

```sh

```

3. We setup an ISAAC session and load all relevant files

```sh

```

4. Run the analysis and transform steps in ISAAC.

```sh

```

5. Investigate the ISAAC artifacts.

```sh

```

6. Continue with the automatic generation of ISAX candidates

```sh

```

7. Combine candidates into ETISS core.

```sh

```

8. Perform the retargeting of ETISS/LLVM.

```sh

```

9. Test if everything still works?

```sh

```
