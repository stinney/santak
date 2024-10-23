#!/bin/sh
grep LAK ~/orc/osl/00lib/osl.asl | grep @list | cut -d' ' -f2 | cut -d'	' -f2 | sort -u | tail +2 >osl-lak.lst
