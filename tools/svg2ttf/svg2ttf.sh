#!/bin/sh
path=$1
if [ ! -d svg ]; then
    echo $0: create svg directory first
    exit 1
fi
cp $path/25A1.svg svg
fontforge -script $path/svg2ttf.py
