#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my %warned = ();

my $ligfile = undef;
my $outfile = undef;
my $ttxfile = undef;
my $verbose = 0;

GetOptions(
    'lig:s'=>\$ligfile,
    'out:s'=>\$outfile,
    'ttx:s'=>\$ttxfile,
    verbose=>\$verbose,
    );

die "Usage: $0 -l [LIG] -t [TTX] -o [OUT]\n"
    unless $ligfile && $outfile && $ttxfile;

my $status = 0;
my %lig = ();
my %tab = (); my @t = `cat $ligfile`; chomp @t;
foreach (@t) {
    my($o,$n) = split(/\t/,$_);
    if ($tab{$o}) {
	warn "$0: duplicate 'old' char $o\n";
	++$status;
    }
    if ($lig{$n}++) {
	warn "$0: duplicate 'lig' $n\n";
	++$status;
    }
    $tab{$o} = $n;
}

die "$0: errors in lig table. Stop.\n" if $status;

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
    my $noprint = 0;
    if (/(?:name|glyph|in)="u([0-9A-F]{5})([".])/) {
	my $old_u = $1;
	my $endchar = $2;
	my $new_u = $tab{"\U$old_u"};
	if ($new_u) {
	    s/"u$old_u./"$new_u$endchar/;
	    s/class="1/class="2/ if /class="1/;
	    warn "map u$old_u to $new_u\n" if $verbose;
	    if (/ out="u$old_u/) {
		s/ out="u$old_u/ out="$new_u/;
	    }
	} else {
	    # optional
	}
	if (/code="0x([0-9A-F]{5})"/i) {
	    $old_u = $1;
	    $new_u = $tab{"\U$old_u"};
	    if ($new_u) {
		warn "map 0x$old_u dropped\n" if $verbose;
		$noprint = 1;
	    } else {
		# optional
	    }
	}
    } elsif (/(12[0-9A-F]){3}/) {
	my $u = $1;
	warn "$_" if $tab{"\U$u"};
    }
    print unless $noprint;
}
close(T);

1;
