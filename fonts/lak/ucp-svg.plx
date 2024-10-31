#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @bad = `cat bad`; chomp @bad; my %bad = (); @bad{@bad} = ();

while (<>) {
    chomp;
    my($n,$f,$u) = split(/\t/,$_);
    my $uf = $u;
    $uf =~ s/^U\+//;
    $uf =~ tr/x//d;
    $uf =~ tr/./-/;
    print "ln -sf ../svgsrc/$f.svg $uf.svg\n"
	unless exists $bad{$uf};
}

1;
