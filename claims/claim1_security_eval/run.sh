#!/usr/bin/env bash
set -e

wget https://samate.nist.gov/SARD/downloads/test-suites/2017-10-01-juliet-test-suite-for-c-cplusplus-v1-3.zip
mkdir juliet
cd juliet
unzip ../2017-10-01-juliet-test-suite-for-c-cplusplus-v1-3.zip
cd C
git init # allow patching even if parent directory is inside a git repo (will not work otherwise)
git apply ../../../../artifact/juliet.patch

# disable core dumps to reduce recovery time for (expected) failed tests
source ./sourceme.sh

python3 ./psan_juliet.py -m
make -f Makefile_psan -j`nproc`
echo "==============================="
echo "Running Juliet tests with PSAN"
echo "If this step is SLOW, please check if core dumps are disabled correctly."
echo "(Should be ~1s per test at most, some can be faster)"
echo "==============================="
python3 ./psan_juliet.py -r
# results available at psan_juliet.xlsx
cd ../..
