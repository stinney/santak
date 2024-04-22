#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;
use Data::Dumper;

# Take an fss-oid-ucp.tab which defines the set of character images in
# a directory and compare it to a rep.tab, which defines the
# repertoire of an arbitrary piece of corpus.
#
# This tells you what signs are used in the corpus repertoire that you
# don't yet have in the image set.

use Getopt::Long;

GetOptions(
    );

1;
