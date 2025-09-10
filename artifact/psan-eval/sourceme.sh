#!/usr/bin/env bash

# where is the LLVM/Clang
# export LLVM_BIN=$TEST_LLVM_BIN
# export CLANG=$LLVM_BIN/clang
# export LLVM_DIS=$LLVM_BIN/llvm-dis
# export LLVM_SYMBOLIZER_PATH=$LLVM_BIN/llvm-symbolizer

# where is PSAN binary (and other tools)
# export PSAN_EXEC=$PSAN_BIN/psan
# export PSAN_WPA=$PSAN_BIN/wpa

# where is softboundcets
# export SOFTBOUNDCETS_EXEC="$SOFTBOUNDCETS_BUILD_DIR/SoftBoundCETS/softboundcets --softboundcets-associate-missing-metadata"
#UPDATE: now the softboundcets executable links in the runtime library automatically
# export SOFTBOUNDCETS_LDFLAGS=""  #"-L$SOFTBOUNDCETS_BUILD_DIR/compiler-rt -lsoftboundcets_standard"

# ASAN
# export ASAN_EXEC=""
# export ASAN_LDFLAGS="-O3 -fsanitize=address -fsanitize-recover=all"
# export ASAN_OPTIONS="halt_on_error=0,detect_leaks=0,handle_segv=0"

# when using LLVM 15, do not create IR with opaque pointers
# also disable vectorizations
# export COMMON_CFLAGS="-Xclang -no-opaque-pointers -fno-vectorize -fno-slp-vectorize -fno-tree-vectorize -g"

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
export TOOLPATH=$(dirname $(realpath -s ${BASH_SOURCE[0]}))

# root for the temporary files
export EVAL_TMPDIR=$TOOLPATH/build

# where to place IR files
export EVAL_IRDIR=$EVAL_TMPDIR/IRs

# where to place executables
export EVAL_EXEDIR=$EVAL_TMPDIR/executables

# where to place temporary IR files during compilation pipeline
export EVAL_TMPIR_DIR=$EVAL_TMPDIR/tmpIRs
