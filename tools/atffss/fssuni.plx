#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %u = (); my @u = `cut -f1,3 $ENV{'ORACC'}/osl/02pub/unicode.tsv`; chomp @u;
foreach (@u) {
    my($u,$o)=split(/\t/,$_); $u=~s/U\+//;
    $u{$o}=$u;
}

while (<>) {
    chomp;
    /(o\d+)/;
    my $u = $u{$1} || '';
    print "$_\t$u\n";
}

1;

################################################################################

