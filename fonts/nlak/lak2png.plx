#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $status = 0;

my $check = 0;
my $file = 0;

GetOptions(
    c=>\$check,
    'f:s'=>\$file,
    );

my %seen_mv = ();
my %seen_to = ();

my %lak = ();
my @lak = `cut -f1,4 ~/orc/edsl/lak/etc/LAK.lft`; chomp @lak;
shift @lak;
foreach (@lak) {
    my($l,$u) = split(/\t/,$_);
    $l =~ s/K0+/K/;
    if ($u !~ s/^U\+//) {
	$u =~ s/=.*$//;
    } else {
	$u =~ s/\..*$//;
    }
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

my @png = ();
if ($file) {
    @png = `cat $file`; chomp @png;
} else {
    @png = <lak/*.png>;
}
@png = map { s#lak/##; s/\.png$//; $_} sort @png;

#print @png;

my @cp = ();
my @mv = ();
foreach my $p (@png) {
    my($l,$s) = split(/-/,$p);
    if ($lak{$l}) {
	if (exists $font{$lak{$l}}) {
	    #warn "processing $lak{$l} via $font{$lak{$l}} with l=$l and s=$s\n";
	    if ($s <= $font{$lak{$l}}) {
		my $x = ++$font{$lak{$l}};
		my $mv = "$lak{$l},$x.png";
		if ($seen_mv{$mv}++) {
		    warn "duplicate mv target $mv\n";
		    ++$status;
	        } else {
		    push @mv, "cp lak/$l-$s.png ucp/$mv\n";
	        }
	    } else {
		my $fr = "$l-$s.png";
		my $to = "$lak{$l},$s.png";
		if (-r $seen_to{$to}++) {
		    warn "duplicate cp target $to\n";
		    ++$status;
		} else {
		    push @cp, "cp lak/$fr ucp/$to\n";
		}
	    }
	} else {
	    warn "$lak{$l} not in \%font hash\n";
	    ++$status;
	}
    } else {
	warn "$l not found in LAK\n";
	++$status;
    }
}

print sort @cp, @mv
    unless $check;

exit $status;

################################################################################

