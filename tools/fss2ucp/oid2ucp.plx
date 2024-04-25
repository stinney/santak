#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

my %ucp = ();
my $ucp = "$ENV{'ORACC_BUILDS'}/osl/00etc/ucp.tab";
my @ucp1 = `cut -f1 $ucp`; chomp @ucp1;
my @ucp2 = `cut -f2 $ucp`; chomp @ucp2;
@ucp{@ucp1} = @ucp2;

open(F,'fss-oid.tab') || die;
open(U,'>fss-ucp.tab') || die;
while (<F>) {
    chomp;
    my($fn,$fss,$oid) = split(/\t/,$_);
    if ($ucp{$oid}) {
	print U "$fn\t$ucp{$oid}\n";
    } else {
	warn "$0: no data for $_\n";
    }
}
close(U);
close(F);

1;
