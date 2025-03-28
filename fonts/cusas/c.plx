#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $pcsl = '/home/stinney/orc/pcsl/newsl';

my %n = (); load_oid();
my %u = (); load_unicode();

while (<>) {
    my($n) = (/^(\S+)/);
    if ($n{$n}) {
	my $o = $n{$n};
	if ($o) {
	    if ($u{$o}) {
		print "$n{$n}\t$u{$o}\t$_";
	    } else {
		print "$n{$n}\tNO\t$_";
	    }
	}
    } else {
	print "NO\t$_";
    }
}

1;

################################################################################

sub load_oid {
    my @o = `grep ^o09 /home/oracc/oid/oid.tab | cut -f1,3`; chomp @o;
    foreach (@o) {
	my($o,$n) = split(/\t/,$_); $n{$n} = $o;
    }
}
sub load_unicode {
    my @u = `cat $pcsl/00etc/unicode.tsv`; chomp @u;
    foreach (@u) { my($o,$u) = split(/\t/,$_); $u{$o} = $u; }
    my @a = `cat $pcsl/00etc/ap24-codes.tsv`; chomp @a;
    foreach (@a) { my($o,$u) = split(/\t/,$_); $u{$o} = $u unless $u{$u}; }
    @a = `cut -f1-2 $pcsl/../00etc/add-data.tsv`; chomp @a;
    foreach (@a) { my($o,$u) = split(/\t/,$_); $u{$o} = $u unless $u{$u}; }
}
