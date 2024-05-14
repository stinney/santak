#!/bin/dash
if [ ! -r fss-ucp.tab ]; then
    echo $0: no fss-ucp.tab. Stop.
fi
mkdir -p ucp
if [ -d ucp ]; then
    rm -fr ucp/*
    (cd ucp ; cat ../fss-ucp.tab | \
	 rocox -n -R 'ln -sf ../%1 %2.png' |
	 /bin/dash -s
    )
else
    echo $0: failed to create directory ucp. Stop.
fi

