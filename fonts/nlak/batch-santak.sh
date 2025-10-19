#!/bin/sh
#
# Pick up a batch of png from edsl/lak/more?? and process it into a
# ttf that goes back to the batch directory

b_base=$1
if [ "$b_base" = "" ]; then
    echo "$0: must give batch base (e.g., more07) on command line. Stop."
    exit 1
fi

batch=~/orc/edsl/lak/$b_base
if [ ! -d $batch ]; then
    echo $0: no such batch $batch. Stop
    exit 1
fi

ttf=$batch/$b_base.ttf
if [ -r $ttf ]; then
    echo $0: $ttf already exists. Stop.
    exit 1
fi

# move/remove the previous batch
set ucp/*.png
if [ "$1" != "ucp/*.png" ]; then
    mv -f ucp/* ucp-done
fi
rm -fr lak ; ln -sf $batch lak
rm -fr svg

# set up the new batch
./lak2png.plx | /bin/sh -s
make svg
./ttf-on-build.sh
mv ttf ttf-$b_base

cat <<EOF
Individual ttf written to ttf-$b_base.
EOF
