package VFJ; require Exporter; @ISA=qw/Exporter/; @EXPORT = qw/load_glyphs/;

use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $name = '';

#
# given a file name return a hash of all the glyphs indexed by their "name"
#
sub load_glyphs {
    my $f = shift;
    open(F,$f) || die "load_glyphs: failed to open $f\n";
    my %glyphs = ();
    do { $_ = <F> } until (/glyphs/);
    while (<F>) {
	if (/^      \{/) {
	    my $g = scan_glyph($_);
	    $glyphs{$name} = $g;
	} elsif (/^    \]/) {
	    last;
	}
    }
    close(F);
    (%glyphs);
}

1;

################################################################################

sub scan_glyph {
    my @g = @_;
    $name = '';
    while (<F>) {
	if (/^      \}/) {
	    s/,$//;
	    push @g, $_;
	    return join('', @g);
	} else {
	    unless ($name) {
		$name = $1 if /"name":"(.*?)"/;
	    }
	    push @g, $_;
	}
    }
}
