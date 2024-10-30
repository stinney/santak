#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $u1 = 0xF1000;
my $u2 = 0xF2000;

# add pua entries to lak.tsv where they don't have a uni

while (<>) {
    chomp;
    my @f = split(/\t/,$_);
    if ($f[1]) {
	if (!/\tU\+[0-9A-F]+\t$/ && !/\t(x[0-9A-F.x]+)\t$/) {
	    my $uu = sprintf("U+%X",$u1++);
	    s/\t$/$uu\t/;
	}
	print "$_\n";
    } else {
	my $uu = sprintf("U+%X",$u2++);
	s/$/\t$uu\t/;
	print "$_\n";
    }
}


1;
