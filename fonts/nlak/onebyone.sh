#!/bin/sh
for a in svg/*.svg ; do
    rm -fr one
    mkdir one
    cp $a one
    ./svg2ttf.sh .
    mv lak.ttf `basename $a .svg`.ttf
done
