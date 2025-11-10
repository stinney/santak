#!/bin/sh
mv emc-flat.ttf Oracc-EMC.ttf
(cd ~/o2/msc/fonts ; make ; make install ; git commit -a -m "Oracc-EMC.ttf update")
