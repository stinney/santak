#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

my %ucp = ();
my $ucp = "/Users/stinney/orc/osl/00etc/ucp.tab";
my @ucp1 = `cut -f1 $ucp`; chomp @ucp1;
my @ucp2 = `cut -f2 $ucp`; chomp @ucp2;
@ucp{@ucp1} = @ucp2;


1;
