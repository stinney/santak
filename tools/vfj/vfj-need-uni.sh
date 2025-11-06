#!/bin/sh
#
# This is the pipeline to turn crpsigns.sh 'need' output into a list of Unicode code points
#
cut -f1 need | grep -f - ~/orc/osl/02pub/unicode.tsv | cut -f1 | sed 's/^U+//' | tr . '\n' | sed 's/^x//' | sort -u
