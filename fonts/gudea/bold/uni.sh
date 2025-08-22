#!/bin/sh
for a in *.png ; do
    f=`basename $a .png | cut -d- -f1`
    u=`grep ^$f'	' ~/santak/tools/atffss/fss-uni.tab | cut -f3`
    if [ "$u" = "" ]; then
	>&2 echo $f not found
    else
	echo mv $a $u=$a
    fi
done
