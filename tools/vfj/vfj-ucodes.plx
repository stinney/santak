#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

# by default omit glyphs with no elements
my $empties = 0;
GetOptions(
    e=>\$empties,
    );

my $f1 = $ARGV[0];

die "$0: must give font name on command line. Stop.\n"
    unless $f1;

die "$0: file $f1 non-existent or unreadable\n" unless -r $f1;

# Scan a .vfj file for "unicode" and "unicodes"

my @u = ();

open(F, $f1);
while (<F>) {
    if (/"unicode".*?"(.*?)"/) {
	print @u if $empties && $#u >= 0;
	@u = ();
	my $h = hex($1);
	if ($h) {
	    push @u, sprintf("%s\n", chr($h));
	}
    } elsif (/"unicodes"/) {
	print @u if $empties;
	@u = ();
	while (1) {
	    my $u = <F>;
	    last if $u =~ /\]/;
	    chomp $u;
	    $u =~ s/^\s+//;
	    $u =~ s/,.*$//;
	    if ($u =~ /^\d+$/) { # FontLab up to 8.x uses decimal here
		push @u, sprintf("%s\n", chr($u));
	    } else { # but maybe they will use hex one day
		printf @u, sprintf("%s\n", chr(hex($u)));
	    }
	}
    } elsif (/"elements"/) {
	print @u;
	@u = ();
    }
}
close(F);

1;

################################################################################

