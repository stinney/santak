#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %u = ();
my $uid = 0xF106C;

while (<>) {
    chomp;
    my($r,$u) = split(/\t/,$_);
    if ($u{$u}++) {
	my $v = $u;
	$u = sprintf("%X",$uid++);
	warn "mapping $v to $u\n";
    }
    print "$r\t$u\n";
}

1;

################################################################################

