#!/bin/sh
path=$1
if [ ! -d svg ]; then
    echo $0: create svg directory first
    exit 1
fi
cp $path/25A1.svg svg
ff=`which fontforge`
if [ "$ff" = "" ]; then
    if [ -r /Applications/FontForge.app/Contents/MacOS/FFPython ]; then
	ff=/Applications/FontForge.app/Contents/MacOS/FFPython
    fi
fi
uname=`uname`
if [ "$uname" = "Darwin" ]; then
    script=
else
    script=-script
fi
$ff $script $path/svg2ttf.py
