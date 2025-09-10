#!/usr/bin/env bash
set -e

wget https://samate.nist.gov/SARD/downloads/test-suites/2017-10-01-juliet-test-suite-for-c-cplusplus-v1-3.zip
mkdir juliet
cd juliet
unzip ../2017-10-01-juliet-test-suite-for-c-cplusplus-v1-3.zip
cd C
git apply ~/projects/juliet.patch

# disable core dumps to reduce recovery time for (expected) failed tests
# WARNING: disabling core dumps inside a container may need a bit more work
# psan_juliet.py will check if PSAN_NO_COREDUMP is set.
# Here we just set it without disabling core dumps correctly.
ulimit -c 0
export PSAN_NO_COREDUMP=1

python3 ./psan_juliet.py -m
make -f Makefile_psan -j`nproc`
echo "==============================="
echo "Running Juliet tests with PSAN"
echo "If this step is SLOW, please check if core dumps are disabled correctly."
echo "(Should be ~1s per test at most, some can be faster)"
echo "If inside a container, you may need to disable core dumps on the host too."
echo "For ubuntu host, run the following command on the host:"
echo "  ulimit -c 0"
echo "  sudo sysctl -w kernel.core_pattern='|/bin/false'"
echo "==============================="
python3 ./psan_juliet.py -r
# results available at psan_juliet.xlsx
cd ../..
