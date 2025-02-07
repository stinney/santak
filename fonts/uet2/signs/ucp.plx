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
my $pua = 0xF2000;
my $not = 0xF3000;
my $salt = 0xF4000;
my @u = `cut -f1,6 bau.tsv`; chomp @u;
foreach (@u) {
    my($uet,$uni) = split(/\t/,$_);
    if ($uni =~ s/^U\+//) {
	$u{$uet} = $uni;
    } else {
	$u{$uet} = sprintf("%X", $pua++);
    }
}

while (<>) {
    chomp;
    my $u = $_;
    $u =~ s#\.png##;
    $u =~ s/,.*$//;
    if ($u{$u}) {
	if (/,/) {
	    my $s = sprintf("%X", $salt++);
	    print "cp png/$_ ucp/$s.png\n";
	} else {
	    print "cp png/$_ ucp/$u{$u}.png\n";
	}
    } else {
	# warn "$_ not found\n";
	my $n = sprintf("%X", $not++);
	print "cp png/$_ ucp/$n.png\n";
    }
}

1;

################################################################################

