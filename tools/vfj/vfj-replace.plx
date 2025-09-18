#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "/Users/stinney/santak/tools/vfj";

use VFJ;

use Getopt::Long;

GetOptions(
    );

my $f1 = $ARGV[0];
my $f2 = $ARGV[1];

die "$0: must give two font names on command line. Stop.\n"
    unless $f1 && $f2;

die "$0: file $f1 non-existent or unreadable\n" unless -r $f1;
die "$0: file $f2 non-existent or unreadable\n" unless -r $f2;

# Replace glyphs in font1 with glyphs in font2 if they exist there

my %font1 = load_glyphs($f1);
my %font2 = load_glyphs($f2);

my $i = 0;
foreach my $g (sort keys %font1) {
    print ",\n" if $i++;
    print $font2{$g} || $font1{$g};
}

1;

################################################################################

