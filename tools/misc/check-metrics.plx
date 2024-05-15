#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

# use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

# Read a FontLab .vfm file and report any ymax that are outside the
# +800/-200 range used for Oracc cuneiform fonts.
my $u = '';

while (<>) {
    if (/^\s+"(u+[A-Z0-9]{5})/) {
	$u = $1;
    } elsif (/ymax":\s+(.*?),?$/) {
	my $ymax = $1;
	if ($ymax > 0) {
	    warn "$u: ymax > 800 \@ $1\n" if $ymax > 800;
	} elsif ($ymax < 0) {
	    warn "$u: ymax < 200 \@ $1\n" if $ymax < -200;
	}	    
    } elsif (/ymin":\s+(.*?),?$/) {
	my $ymin = $1;
	if ($ymin > 0) {
	    warn "$u: ymin > 800 \@ $1\n" if $ymin > 800;
	} elsif ($ymin < 0) {
	    warn "$u: ymin < 200 \@ $1\n" if $ymin < -200;
	}	    
    }	
}

1;

