#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @lakucp = `cut -f1,5 LAK.tsv`; chomp @lakucp;
my %u = ();
foreach (@lakucp) {
    my($l,$u) = split(/\t/,$_);
    $u{$l} = $u;
}

my @f = (<svgsrc/*.svg>); map { s#^svgsrc/(.*?)\.svg$#$1#; $_ } @f;
my %f = ();

my %u_used = ();
my $i = 0;
foreach my $f (sort @f) {
    ++$i;
    if ($u{$f}) {
	if ($u_used{$u{$f}}++) {
	    my $comma = $u_used{$u{$f}} - 1;
	    print "1\t$f\t$u{$f},$comma\n";	 
	} else {
	    print "1\t$f\t$u{$f}\n";
	}
    } elsif ($f =~ /,/) {
	my $fx= $f;
	$fx =~ s/,1$/a/;
	if ($u{$fx}) {
	    my $u = $u{$fx};
	    if ($u_used{$u}++) {
		my $comma = $u_used{$u} - 1;
		$u = "$u,$comma";
	    }
	    print "3\t$f\t$u\n";
	} else {
	    unless ($fx =~ s/,2$/b/) {
		$fx =~ s/,3$/c/;
	    }
	    if ($u{$fx}) {
		my $u = $u{$fx};
		if ($u_used{$u}++) {
		    my $comma = $u_used{$u} - 1;
		    $u = "$u,$comma";
		}
		print "4\t$f\t$u\n";
	    } else {
		$fx = $f;
		$fx =~ s/,.$//;
		if ($u{$fx}) {
		    my $u = $u{$fx};
		    if ($u_used{$u}++) {
			my $comma = $u_used{$u} - 1;
			$u = "$u,$comma";
		    }
		    print "5\t$f\t$u\n";
		} else {
		    $fx = $f;
		    $fx =~ s/[ab],.*$//;
		    if ($u{$fx}) {
			my $u = $u{$fx};
			if ($u_used{$u}++) {
			    my $comma = $u_used{$u} - 1;
			    $u = "$u,$comma";
			}
			print "6\t$f\t$u\n";
		    } else {
			print "YYY$f\n";
		    }
		}
	    }
	}
    } else {
	if ($u{"${f}a"}) {
	    my $u = $u{"${f}a"};
	    if ($u_used{$u}++) {
		my $comma = $u_used{$u{$f}} - 1;
		print "1\t$f\t$u,$comma\n";
	    } else {
		print "1\t$f\t$u\n";
	    }
	} elsif ($f =~ /[ab]$/) {
	    my $fnoab = $f;
	    $fnoab =~ s/[ab]$//;
	    if ($u{$fnoab}) {
		my $u = $u{$fnoab};
		if ($u_used{$u}++) {
		    my $comma = $u_used{$u} - 1;
		    $u = "$u,$comma";
		}
		print "2\t$f\t$u\n";
	    } else {
		print "XXX$f\n";
	    }
	}
    }
}

1;
