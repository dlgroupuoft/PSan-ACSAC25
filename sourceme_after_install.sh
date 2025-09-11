# execute in the root of the repo after installation

export LLVM_BIN=/usr/bin
export CLANG=$LLVM_BIN/clang-15
export LLVM_DIS=$LLVM_BIN/llvm-dis-15
export LLVM_SYMBOLIZER_PATH=$LLVM_BIN/llvm-symbolizer-15

# where is PSAN binary (and other tools)
export PSAN_BIN=`pwd`/svf-psan-build/bin
export PSAN_EXEC=$PSAN_BIN/psan
export PSAN_WPA=$PSAN_BIN/wpa

# where is softboundcets
export SOFTBOUNDCETS_BUILD_DIR=`pwd`/softboundcets-outoftree/build
export SOFTBOUNDCETS_EXEC="$SOFTBOUNDCETS_BUILD_DIR/SoftBoundCETS/softboundcets --softboundcets-associate-missing-metadata"
export SOFTBOUNDCETS_LDFLAGS=""

# when using LLVM 15, do not create IR with opaque pointers
# also disable vectorizations
export COMMON_CFLAGS="-Xclang -no-opaque-pointers -fno-vectorize -fno-slp-vectorize -fno-tree-vectorize -g"

export PATH=$SOFTBOUNDCETS_BUILD_DIR/SoftBoundCETS:$PSAN_BIN:$HOME/go/bin:$PATH
