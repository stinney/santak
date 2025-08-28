#!/bin/sh
jx.sh Gudea-Bold.vfj >gb.xml
xsltproc ~/santak/tools/vfj/vfj-chars.xsl gb.xml >gb.chr
grep -F -v . gb.chr | cut -f2 | grep -vf - gudea.rep >gb.not
wc -l gudea.rep gb.chr gb.not | grep -v total
