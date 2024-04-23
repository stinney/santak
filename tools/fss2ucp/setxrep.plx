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

my @missing = ();

foreach (sort keys %rep) {
    # warn "trying $_\n";
    unless (exists $set{$_}) {
	push(@missing, $_)
	    unless $rep{$_} =~ /\tx[0-9A-F]/;
    }
}

my %really_missing = ();
my %seen = ();
foreach (@missing) {
    my @f = split(/\t/, $rep{$_});
    if ($f[4]) {
	my @o = split(/\s+/,$f[4]);
	my @n = split(/\s+/,$f[5]);
	for (my $i = 0; $i <= $#o; ++$i) {
	    my $o = $o[$i];
	    my $n = $n[$i];
	    if (exists $set{$o}) {
		warn "missing $f[0] in $o is in set as $n\n";
		++$seen{$o};
	    } elsif ($n =~ /\tx[0-9A-F]/) {
		# ignore because this is a sequence
	    } else {
		warn "missing $f[0] in $o not in set\n";
		$seen{$o} = $n;
		++$really_missing{$_};
	    }
	}
    } else {
	++$really_missing{$_};
    }
}

foreach (sort keys %really_missing) {
    my $r = $rep{$_};
    $r =~ /\t(\S+)\t/;
    print "$_\t$1\n";
}

1;
