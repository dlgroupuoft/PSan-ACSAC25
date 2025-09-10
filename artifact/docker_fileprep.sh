#!/usr/bin/env bash

SRCPATH=$(dirname $(realpath -s ${BASH_SOURCE[0]}))

mkdir projects
cd projects
mkdir svf-psan && cd svf-psan && unzip $SRCPATH/svf-psan.zip && cp $SRCPATH/svf-psan.config.in ./.config.in && cd ..
mkdir softboundcets-outoftree && cd softboundcets-outoftree && unzip $SRCPATH/softboundcets-outoftree.zip && cd ..
cp -r $SRCPATH/psan-eval .
cp $SRCPATH/*.patch .
cp $SRCPATH/*.sh .
cd ..
