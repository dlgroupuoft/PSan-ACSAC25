sudo apt update
sudo apt install -y software-properties-common git build-essential cmake
sudo apt install -y clang-15 llvm-15-dev
sudo apt install -y libzstd-dev golang unzip wget file time
sudo apt install -y python3-full python3-dev python3-pip
sudo apt install -y python3-openpyxl python3-xlsxwriter
sudo go install github.com/SRI-CSL/gllvm/cmd/...@latest
sudo apt clean

sudo ln -s /usr/bin/clang-15     /usr/bin/clang
sudo ln -s /usr/bin/clang++-15   /usr/bin/clang++
sudo ln -s /usr/bin/llvm-link-15 /usr/bin/llvm-link
sudo ln -s /usr/bin/llvm-dis-15  /usr/bin/llvm-dis
sudo ln -s /usr/bin/llvm-symbolizer-15 /usr/bin/llvm-symbolizer

cd artifact
mkdir svf-psan && cd svf-psan && unzip ../svf-psan.zip && cp ../svf-psan.config.in ./.config.in && cd ..
mkdir softboundcets-outoftree && cd softboundcets-outoftree && unzip ../softboundcets-outoftree.zip && cd ..
cd ..

mkdir svf-psan-build && cd svf-psan-build
cmake ../artifact/svf-psan && make -j`nproc` && cd ..

cp -r ./artifact/softboundcets-outoftree . && cd softboundcets-outoftree && mkdir build && cd build
cmake .. && make -j`nproc` && cd .. && cd compiler-rt && make && cd ../..

echo "Installation finished; please run 'source sourceme_after_install.sh' to setup environment variables."
