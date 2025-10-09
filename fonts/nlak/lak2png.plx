#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %seen_to = ();

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
		do {
		    my $x = $font{$lak{$l}} + $s; 	# reset SALT number starting after font-max-salt
		    ++$font{$lak{$l}}; 			# roll the font-max-salt number
		} while (-r "lak/$l-$x.png"); 		# if files are sorted by SALT this
							# should always be false

		warn "mv $l-$s.png $l-$x.png\n";
	    } else {
		my $fr = "$l-$s.png";
		my $to = "$lak{$l},$s.png";
		if (-r $seen_to{$to}++) {
		    warn "duplicate output file name ucp/$to\n";
		} else {
		    print "cp $lak/$fr ucp/$to\n";
		}
	    }
	}
    } else {
	warn "$l not found in LAK\n";
    }
}

1;

################################################################################

