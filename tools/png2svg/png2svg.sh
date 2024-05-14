#!/bin/dash
path=$1
if [ ! -d ucp ]; then
    if [ -d png ]; then
	echo $0: convert png to ucp first. Stop
	exit 1
    else
	echo $0: no png or ucp directories. Stop.
	exit 1
    fi
fi
mkdir -p svg
rm -fr svg/*
mkdir -p misc_files
rm -fr misc_files/*
python3 $path/png2svg.py ucp
