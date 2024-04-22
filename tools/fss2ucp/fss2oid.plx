#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

my $fss = '/Users/stinney/santak/tools/atffss/fss.tab';

my %tab = ();
my @fss = `cut -f1 $fss`; chomp @fss;
my @oid = `cut -f2 $fss`; chomp @oid;
@tab{@fss} = @oid;

my @fn = <*>;
foreach (@fn) {
    next unless /\.(xcf|png|jpg|svg)$/;
    my $fn = $_;
    s/\.[^.]+$//;
    s/sz/c/g;
    tr/x/*/ unless $tab{$_};
    if ($tab{$_}) {
	print "$fn\t$_\t$tab{$_}\n";
    } else {
	warn "$_ not found in fss tab\n";
    }
}

1;
