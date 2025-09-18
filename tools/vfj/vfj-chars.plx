#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @u = (<>); chomp @u;
for (my $i = 0; $i < $#u; ++$i) {
    print ",\n" if $i;
    vfj_char("u$u[$i]", "\L$u[$i]");
}

1;

################################################################################

sub vfj_char {
    my($n,$u) = @_;
    print <<EOF;
      {
        "name":"$n",
        "unicode":"$u",
        "lastModified":"2025-08-28 11:58:30",
        "colorFlag":240,
        "layers":[
          {
            "name":"Regular",
            "colorFlag":240,
            "advanceWidth":1447
          }
        ]
      }
EOF
}
