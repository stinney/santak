#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;
use Data::Dumper;

# Take an fss-oid-ucp.tab which defines the set of character images in
# a directory and compare it to a rep.tab, which defines the
# repertoire of an arbitrary piece of corpus.
#
# This tells you what signs are used in the corpus repertoire that you
# don't yet have in the image set.

use Getopt::Long;

GetOptions(
    );

my $fssoid = 'fss-oid-ucp.tab';
die "$0: there must be a $fssoid here for me to work with. Stop.\n"
    unless -r $fssoid;
my $reptab = 'rep.tab';
die "$0: there must be a rep.tab here for me to work with. Stop.\n"
    unless -r $reptab;

my %set = (); my @set = `cut -f3 $fssoid`; chomp @set; @set{@set} = ();
my %rep = (); my @repkey = `cut -f1 $reptab`; chomp @repkey;
my @rep = `cat $reptab`; chomp @rep;
@rep{@repkey} = @rep;

foreach (sort keys %rep) {
    # warn "trying $_\n";
    unless (exists $set{$_}) {
	warn "$rep{$_}\n"
	    unless $rep{$_} =~ /\tx[0-9A-F]/;
    }
}

1;
