# PSan: Towards Hybrid Metadata Scheme for Efficient Pointer Checking

This repository contains artifacts and files used to reproduce experiments in paper "PSan: Towards Hybrid Metadata Scheme for Efficient Pointer Checking".


## Artifacts
Most of the artifacts are in the `artifact` directory. It contains the source code or patches for PSan and other tools/benchmarks we used in evaluation:

* PSan source code available in [`svf-psan.zip`](artifact/svf-psan.zip), containing both SVF and PSan. (SVF is a pointer analysis library, and PSan is currently implemented as a tool in SVF repo.) The [`svf-psan.config.in`](artifact/svf-psan.config.in) should be renamed to `.config.in` and placed in the repo as well.
* SoftBoundCETS ported to LLVM 15 and configured as a standalone LLVM IR instrumentation tool, available in [`softboundcets-outoftree.zip`](artifact/softboundcets-outoftree.zip). We used it in the evaluation of PSan.
* patch to the olden benchmark (based on [InFatPointer's Olden](https://github.com/dlgroupuoft/InFatPointer-ASPLOS2021-Eval)) available as [`olden.patch`](artifact/olden.patch). The patch also includes a new `Makefile` we use to create bitcode files from Olden benchmarks.
* patch to [Juliet test suite](https://samate.nist.gov/SARD/test-suites/112) available as [`juliet.patch`](artifact/juliet.patch). The patch also includes a helper script `psan_juliet.py` to run the tests.


### Note on build paths
Currently, PSan and the modified SoftboundCETS use macro to get paths to runtime library (LLVM bitcode files), so once the tools are built, the build directory should not be moved, otherwise they will not able to find the runtime libraries. Because of this, all our environment setup scripts build the executables without installing them.

### Dependencies
The artifacts depend on LLVM 15. The code is only tested in Linux environments. There is no hardware requirements. We recommend to test on Ubuntu distributions where you can install LLVM 15 from `apt`; Otherwise you will need to build LLVM 15 and Clang 15 from source.

## Environments
This repository provides two ways of reproducing the experiment results:
1. Docker: one can build a docker image (based on Ubuntu 25.04) and run experiments in it.
2. VM / bare-metal: we provide [`install.sh`](install.sh) for setting up dependencies on a Ubuntu 24.04 machine with `sudo` permission. We tested it on [CloudLab](https://www.cloudlab.us/landing.php) with `small-lan` profile (one r320 node in the APT cluster, bare-metal).

### Docker
To build the docker image, create a new directory and `cd` into it, then run `artifact/docker_fileprep.sh`, then run `docker build` with `--file` pointing to [`artifact/Dockerfile`](artifact/Dockerfile). For example:

```
cd /tmp
mkdir dockerbuild && cd dockerbuild
~/PSan-ACSAC25/artifact/docker_fileprep.sh # unzip archives and copy files over
docker build . --file ~/PSan-ACSAC25/artifact/Dockerfile
```

Assuming this repo is cloned under the home directory.

After starting a container from the image, the working directory is set to `/root` (which is `$HOME` as well) and related files in `artifact` subdirectory are placed at `/root/projects`.

### VM / bare-metal

For a Ubuntu 24.04 VM or bare-metal machine, after cloning the repo, [`install.sh`](install.sh) and [`sourceme_after_install.sh`](sourceme_after_install.sh) can be used to build dependencies and setup environments. Please do not move the directory after running `install.sh`, because tool executables remember runtime library paths when they are built.

### Build them yourselves

Please refer to [`install.sh`](install.sh) or [`artifact/Dockerfile`](artifact/Dockerfile) on how to setup the dependencies and build the tools.

## PSan usage

### PSan tool

The `psan` executable should be on `PATH` for the docker image and the VM / bare-metal setup. The general way of using it is as follows:

```
psan [options] --psan-mss=true --psan-mts=true input.ll -o output.ll
```

The `input.ll` is the input LLVM IR and can be bitcode file (`input.bc`) as well. The input LLVM IR must use typed pointer and should be at least O1 optimized. In our experiments, we produce the input LLVM IR with the following flags to clang: `-Xclang -no-opaque-pointers -fno-vectorize -fno-slp-vectorize -fno-tree-vectorize`. Currently PSan always output textual LLVM IR output (i.e., output must be `.ll`) Set `--psan-mss=false` is spatial safety is **NOT** needed, and set `--psan-mts=false` if temporal safety is **NOT** needed.

Commonly used options:

* `--psan-no-debug` (recommended): Disable debug log output. `psan` by default write **A LOT OF** internal states into `psan_debug_prints.txt` (can be specified with `--psan-debug-print-filename=...`). Without this, `psan` can write GB of logs for large programs and will be very slow.
* `--psan-no-dump` (recommended): `psan` by default dumps an LLVM IR after each major step for debugging. This option disables this LLVM IR dump.
* `--psan-verify-output`: This option let `psan` to verify the output LLVM IR before exiting, useful for debugging `psan`.
* `--psan-enable-conservative-oob` (recommended): This option enables the workaround to detect obsolete metadata due to uninstrumented code modifying pointers using the shadow memory. With this option, a copy of the current pointer value is stored along with the metadata in the shadow memory, and a metadata load will compare the pointer value from the metadata and the current loaded value. In this way, if an uninstrumented function modifies a pointer (e.g., `qsort()` on an pointer array), the instrumentation can realize that the pointer has been modified and subsequent checks should not use the obsolete metadata.
* `--psan-disable-eptg`: This option disables the hybrid metadata scheme, so only the shadow memory is used. `PSan-shadow` mode in the paper uses `--psan-disable-eptg`.
* `--psan-collect-runtime-stat`: This option enables additional instrumentation to count certain events (e.g., number of pointer loads using shadow memory vs using inline metadata). Programs instrumented with this flag will print stats at the end of the execution.

### Using PSan end-to-end

To apply PSan on a C program, one needs to:

* Create a whole-program LLVM IR for the program. This can be done by compiling with [gllvm](https://github.com/SRI-CSL/gllvm) (Included in the Docker and VM / bare-metal setup) and run `get-bc` from the gllvm project with the executable as input.
* Invoke `psan` with the flags you want to instrument the whole-program IR.
* Compile the IR with `clang` to produce the final executable.

## Experiments

We provide scripts for two experiments:

1. Security evaluation: PSan instrumentation should pass selected test cases in Juliet test suite. See [Claim 1 description](claims/claim1_security_eval/claim.txt) for more details.
2. Performance evaluation: PSan (hybrid scheme) should incur less performance overhead than SoftBoundCETS and PSan (shadow memory only) on Olden benchmarks. See [Claim 2 description](claims/claim2_performance_eval/claim.txt) for more details.

