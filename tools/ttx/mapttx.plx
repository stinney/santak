#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my %warned = ();

my $mapfile = undef;
my $outfile = undef;
my $ttxfile = undef;
my $verbose = 0;

GetOptions(
    'map:s'=>\$mapfile,
    'out:s'=>\$outfile,
    'ttx:s'=>\$ttxfile,
    verbose=>\$verbose,
    );

die "Usage: $0 -m [MAP] -t [TTX] -o [OUT]\n"
    unless $mapfile && $outfile && $ttxfile;

my $status = 0;
my %new = ();
my %tab = (); my @t = `cat $mapfile`; chomp @t;
foreach (@t) {
    my($o,$n) = split(/\t/,$_);
    if ($tab{$o}) {
	warn "$0: duplicate 'old' char $o\n";
	++$status;
    }
    if ($new{$n}++) {
	warn "$0: duplicate 'new' char $n\n";
	++$status;
    }
    $tab{$o} = $n;
}

die "$0: errors in map table. Stop.\n" if $status;

#print Dumper \%tab; exit 1;

if (-r $ttxfile) {
    open(T,$ttxfile) || die;
} elsif (-r "$ttxfile.gz") {
    open(T,'gzip -cd PC-240412.ttx.gz|') || die;
} else {
    die "$0: unable to open $ttxfile or $ttxfile.gz. Stop.";
}
open(O,">$outfile") || die "$0: unable to write to $outfile. Stop.\n";
select O;
while (<T>) {
    my $orig = $_;
    if (/(?:name|glyph)="u([0-9A-F]{5})"/) {
	my $old_u = $1;
	my $new_u = $tab{"\U$old_u"};
	if ($new_u) {
	    s/"u$old_u"/"u$new_u"/;
	    warn "map u$old_u to u$new_u\n" if $verbose;
	} else {
	    warn "no tab entry for $old_u\n"
		unless $warned{$old_u}++;
	}
	if (/code="0x([0-9A-F]{5})"/i) {
	    $old_u = $1;
	    $new_u = $tab{"\U$old_u"};
	    if ($new_u) {
		s/"0x$old_u"/"0x$new_u"/;
		warn "map 0x$old_u to 0x$new_u\n" if $verbose;
	    } else {
		warn "no tab entry for code=$old_u\n"
		    unless $warned{"\U$old_u"}++;
	    }
	}
    } elsif (/12[0-9A-F]{3}/) {
	warn "$_" unless /Uni12580/;
    }
    print
}
close(T);

1;
