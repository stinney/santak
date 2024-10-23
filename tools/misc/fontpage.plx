#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %names = ();
my $dir = $ARGV[0];
my @f = `ls $dir`; chomp @f;

foreach (@f) {
    my $n = $_;
    my $b = $_;
    $b =~ s/[-,_.].*$//;
    push @{$names{$b}}, $n;
}

print "<html><title>Font Page</title></head><body><table>\n";

foreach my $b (sort keys %names) {
    print '<tr>';
    foreach my $n (sort @{$names{$b}}) {
	print "<td>$n</td>";
    }
    print '</tr>';
    print "\n";
    print '<tr>';
    foreach my $n (sort @{$names{$b}}) {
	print "<td><img height=\"50px\" src=\"$dir/$n\"/></td>";
    }
    print '</tr>';
    print "\n";
}

print "</table></body></html>\n";

1;
