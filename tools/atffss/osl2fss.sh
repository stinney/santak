#!/bin/sh
grep '^"' slmap.js | grep -v selpages | grep -v '⁻\|⁺\|ē\|ī\|ū' | tr -d "'" |
    sed 's#^"\([a-z0-9@*.+%&_~]\{1,\}\)":"#\1	#' | grep -v '^"' >f1
cut -f1 f1 >f11
cut -f2 f1 | cut -d/ -f2 | tr -d '",' >f12 
paste f11 f12 >fss.tab
rm -f f1 f11 f12
