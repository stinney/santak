#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

my %pua = ();
my @puatok = `cut -f1 $pua`; chomp; @puatok;
my @pua = `cut -f1 $

my $fss = '/Users/stinney/santak/tools/atffss/fss.tab';
my $ns = `cat nsprefix.txt`; chomp $ns;

1;
