#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

open(P,'>preamble.vfj') || die;
while (<>) {
    print P;
    last if /^\s+\"glyphs\":/;
}
close(P);

do {
    $_ = <>
} until (/^    \]/);

open(P,'>postamble.vfj') || die;
do {
    print P;
} while (<>);
close(P);

1;

################################################################################

