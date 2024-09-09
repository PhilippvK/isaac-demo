# isaac-demo

This repository demonstrates the usage and setup of the ISAAC (ISA Automated Customization) toolkit and all its dependencies.

**Disclaimer:** This project consists of several complex dependencies. Make sure that you have a powerful machine and at least 30GB of disk space available

## Prerequisites

### Common

Clone submodules!

Setup virtual Python environment
Do not forget to activate!

Install all required packages!


### OS Packages

This demo is supposed to be run on an Ubuntu/Debia-like operating system. WSL2 should work but was not tested!

In addition to the default development packages (CMake, build-essential,...), the following SW is required to run this demo:

- Docker (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)


### Memgraph

A memgraph database is used to store the CDFGs of the software compiled by LLVM.

First, the memgraph platform itself (database, lab (GUI),...) can be launched using docker:

```sh

```

Further, we need the `mgclient` libraries to interface with the platform.

Executing `scripts/setup_mgclient.sh` should to perform all required steps.

### LLVM

Our patched version of LLVM depends on the `mgclient` lib, hence that library has to be installed ion the previous step.

We provide the `scripts/setup_llvm.sh` scrip[t which should allow you to install LLVM. This step will take a long time depending on your machine!

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
