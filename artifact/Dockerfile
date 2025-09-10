FROM ubuntu:25.04

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Toronto

RUN apt update
RUN apt install -y software-properties-common git build-essential cmake && \
    apt install -y clang-15 llvm-15-dev && \
    apt install -y libzstd-dev golang unzip wget file time && \
    apt install -y python3-full python3-dev python3-pip && \
    apt install -y python3-openpyxl python3-xlsxwriter && \
    go install github.com/SRI-CSL/gllvm/cmd/...@latest && \
    apt clean

RUN ln -s /usr/bin/clang-15     /usr/bin/clang && \
    ln -s /usr/bin/clang++-15   /usr/bin/clang++ && \
    ln -s /usr/bin/llvm-link-15 /usr/bin/llvm-link && \
    ln -s /usr/bin/llvm-dis-15  /usr/bin/llvm-dis && \
    ln -s /usr/bin/llvm-symbolizer-15 /usr/bin/llvm-symbolizer

COPY projects ./projects

RUN mkdir svf-psan-build && cd svf-psan-build && \
    cmake ../projects/svf-psan && make -j`nproc` && cd ..

RUN cp -r ./projects/softboundcets-outoftree . && cd softboundcets-outoftree && \
    mkdir build && cd build && \
    cmake .. && make -j`nproc` && cd .. && \
    cd compiler-rt && make && cd ../..

#----------------------------------------------------------------------
# Environment variables for scripts
#----------------------------------------------------------------------

ENV LLVM_BIN=/usr/bin
ENV CLANG=$LLVM_BIN/clang-15
ENV LLVM_DIS=$LLVM_BIN/llvm-dis-15
ENV LLVM_SYMBOLIZER_PATH=$LLVM_BIN/llvm-symbolizer-15

# where is PSAN binary (and other tools)
ENV PSAN_BIN=/root/svf-psan-build/bin
ENV PSAN_EXEC=$PSAN_BIN/psan
ENV PSAN_WPA=$PSAN_BIN/wpa

# where is softboundcets
ENV SOFTBOUNDCETS_BUILD_DIR=/root/softboundcets-outoftree/build
ENV SOFTBOUNDCETS_EXEC="$SOFTBOUNDCETS_BUILD_DIR/SoftBoundCETS/softboundcets --softboundcets-associate-missing-metadata"
ENV SOFTBOUNDCETS_LDFLAGS=""

# when using LLVM 15, do not create IR with opaque pointers
# also disable vectorizations
ENV COMMON_CFLAGS="-Xclang -no-opaque-pointers -fno-vectorize -fno-slp-vectorize -fno-tree-vectorize -g"

ENV PATH=$SOFTBOUNDCETS_BUILD_DIR/SoftBoundCETS:$PSAN_BIN:/root/go/bin:$PATH
CMD ["bash"]
