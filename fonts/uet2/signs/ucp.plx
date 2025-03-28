#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %u = ();
my $pua = 0xF2000;
my $not = 0xF3000;
my $salt = 0xF4000;
my @u = `cut -f1,6 bau.tsv`; chomp @u;
my %seen = ();
open(L,'>F234.log');
foreach (@u) {
    next if $seen{$_}++;
    my($uet,$uni) = split(/\t/,$_);
    if ($uni =~ s/^U\+//) {
	$u{$uet} = $uni;
	print L "$uet\t$uni\n";
    } else {
	my $p = $_; $p =~ s/^\S+\s+//;
	printf L "$uet\t%X\t$p\n", $pua;
	$u{$uet} = sprintf("%X", $pua++);
    }
}
#close(L);
#open(SALT, '>salt.log') || die;
my %saltindex = ();
while (<>) {
    chomp;
    my $u = $_;
    $u =~ s#\.png##;
    $u =~ s/,.*$//;
    if ($u{$u}) {
	if (/,/) {
#	    my $salt = $1;
#	    print "cp png/$_ ucp/$u{$u},$salt.png\n";
	    my $s = sprintf("%X", $salt++);
	    printf L "$_\t$s\t$u{$u}.%d\n", ++$saltindex{$u};
	    print "cp png/$_ ucp/$s.png\n";
	} else {
	    print "cp png/$_ ucp/$u{$u}.png\n";
	}
    } else {
	# warn "$_ not found\n";
	printf L "$u\t%X\t\n", $not;
	my $n = sprintf("%X", $not++);
	print "cp png/$_ ucp/$n.png\n";
    }
}
#close(SALT);
close(L);

1;

################################################################################

