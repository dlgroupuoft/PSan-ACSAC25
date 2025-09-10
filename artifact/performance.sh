#!/usr/bin/env bash
set -e

git clone https://github.com/dlgroupuoft/InFatPointer-ASPLOS2021-Eval.git
cd InFatPointer-ASPLOS2021-Eval
cd olden
git apply ~/projects/olden.patch
CC=gclang make
cd ../..

cp -r ~/projects/psan-eval .
cd psan-eval
source ./sourceme.sh
mkdir -p $EVAL_TMPDIR
mkdir -p $EVAL_IRDIR
mkdir -p $EVAL_EXEDIR
mkdir -p $EVAL_IRDIR/olden
cp ../InFatPointer-ASPLOS2021-Eval/olden/*.bc $EVAL_IRDIR/olden
python3 ./psaneval.py -nc
# static stats available at psan_static_stats.xlsx
python3 ./psaneval.py -g
cd $EVAL_EXEDIR
chmod u+x ./*.sh
mkdir -p log
./run_split.sh
cd ../..
python3 ./psaneval.py -p
# runtime stats available at psan_runtime_stats_*.csv
cd ..
