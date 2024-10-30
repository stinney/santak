#!/bin/sh
grep ^LAK /home/oracc/osl/02pub/lists.tsv | tail +2 | ./lak-add-ucp.plx >LAK.tsv

