#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %lak = ();
my @lak = `cut -f1,4 ~/orc/edsl/lak/etc/LAK.lft`; chomp @lak;
shift @lak;
foreach (@lak) {
    my($l,$u) = split(/\t/,$_);
    $l =~ s/K0+/K/;
    if ($u !~ s/^U\+//) {
	$u =~ s/=.*$//;
    }
    $u =~ tr/./,/;
    $lak{"\L$l"} = $u;
}
#print Dumper \%lak;

my %font = ();
my @font = `sed 's/^u//' ~/orc/edsl/lak/bld/font-glyphs.lst`; chomp @font;
foreach (@font) {
    my($u,$s) = split(/\./,$_);
    if ($s) {
	++$font{$u};
    } else {
	$font{$u} = 0;
    }
}

my @png = map { s#lak/##; s/\.png$//; $_} (<lak/*.png>);
#print @png;

foreach (@png) {
    my($l,$s) = split(/-/,$_);
    if ($lak{$l}) {
	if (exists $font{$lak{$l}}) {
	    if ($s <= $font{$lak{$l}}) {
		my $x = $font{$lak{$l}} + $s;
		warn "mv $l-$s.png $l-$x.png\n";
	    } else {
		print "cp lak/$l-$s.png ucp/$lak{$l},$s.png\n";
	    }
	}
    } else {
	warn "$l not found in LAK\n";
    }
}

1;

################################################################################

