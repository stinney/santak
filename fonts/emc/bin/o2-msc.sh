#!/bin/sh
if [[ "emc.vfj" -nt "emc-flat.vfj" ]]; then
    echo $0: emc.vfj newer than emc-flat.vfj. Flatten emc.vfj then try again.
    exit 1
fi
if [[ "emc-flat.vfj" -nt "emc-flat.ttf" ]]; then
    echo $0: emc-flat.vfj newer than emc-flat.ttf. Export emc-flat.ttf then try again.
    exit 1
fi 
mv emc-flat.ttf Oracc-EMC.ttf
(cd ~/o2/msc/fonts ; make ; make install ; git commit -a -m "Oracc-EMC.ttf update")
