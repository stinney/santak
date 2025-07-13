#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

##
## An ADD table consists of pairs of character names and methods
##
## A character name is either an OT feature, e.g., u12345.1, or a
## ligature expressed as a sequence of components separated by
## underscores, e.g., u12345_u12367; .liga is automatically added to
## these names.  If the notation uses double underscore a ZWJ is
## inserted into the name where each '__' occurs.
##
## A method encodes how to create the added character. If it is a
## single unicode character the added character includes this as a
## component.  For ligatures only, if it is a dash ('-') then a
## character is constructed using the components but omitting any ZWJ.
##

my $debug = 0;
my %warned = ();

my $addfile = undef;
my $outfile = undef;
my $ttxfile = undef;
my $verbose = 0;

GetOptions(
    debug=>\$debug,
    'add:s'=>\$addfile,
    'out:s'=>\$outfile,
    'ttx:s'=>\$ttxfile,
    verbose=>\$verbose,
    );

die "Usage: $0 -a [ADD] -t [TTX] -o [OUT]\n"
    unless $addfile && $outfile && $ttxfile;

my %known = (); my @k = `grep GlyphID $ttxfile | cut -d'"' -f4`; chomp @k; @known{@k} = ();
my %mtx = (); my @m = `grep '<mtx ' $ttxfile`; chomp @m;
foreach (@m) {
    my($u,$w,$l) = (/name="(.*?)".*?width="(.*?)".*?lsb="(.*?)"/);
    $mtx{$u} = [ $w , $l ];
}
#print Dumper \%mtx; exit 1;

my @glyphid = ();
my @mtx = ();
my @ttglyph = ();
my @code = ();

my $status = 0;
my %add = ();
my %tab = (); my @t = `cat $addfile`; chomp @t;
foreach (@t) {
    my($a,$m) = split(/\t/,$_);
    next if $a =~ /u4F/ || $m !~ /^\@/;
    $a =~ s/^_//;
    $a =~ s/^u?/u/;
    if ($tab{$a}++) {
	warn "$0: duplicate 'add' char $a\n";
	++$status;
    } else {
	if ($a =~ /liga$/) {
	    $a =~ s/u(?=200D|2062|2064)/uni/g;
	    $status = check_liga($a)
		if $a =~ /_/;
	} else {
	    ++$known{$a} if $a =~ /cv/;
	}
	if ($m =~ s/^\@//) {
	    if ($status) {
		#warn "ignoring $a because status != 0\n";
	    } else {
		push @glyphid, "<GlyphID name=\"$a\"/>\n";

		# remove and save scale factor
		my $sf = '';
		my $sfx = '';
		if ($m =~ s/\s+\*\s+(\S+)\s*$//) {
		    $sfx = $1;
		    $sf = " scale=\"$sfx\"";
		}

		my $u = $m;
		$u =~ s/^u?/u/; #ensure u-prefix is on name
		$m =~ s/^u//;   #ensure no u-prefix on hex value
		
		## Get MTX for imported char; scale that, and set
		## width to it; also use LSB from imported char
		my $mtx = $mtx{$u};
		if ($mtx) {
		    my ($w,$l) = @$mtx;
		    if ($sfx) {
			$w *= $sfx;
			$w = sprintf("%d",$w+0.5);
		    }
		    push @mtx, "<mtx name=\"$a\" width=\"$w\" lsb=\"$l\"/>\n";
		} else {
		    warn "$0: failed to find <mtx/> for $u or $a\n" unless length $m == 0;
		    push @mtx, "<mtx name=\"$a\" width=\"0\" lsb=\"0\"/>\n";
		}
		my $c = "0x\L$a";
		$c =~ s/xu/x/;
		push @code, "<map code=\"$c\" name=\"$a\"/><!--xxx-->\n"
		    unless $a =~ /\./;
		my $component = '';
		if ($m) {
		    $component = "<component glyphName=\"u$m\" x=\"8\" y=\"0\" $sf flags=\"0x1000\"/>";
		}
		push @ttglyph, <<EOF;
<TTGlyph name=\"$a\" >
$component
</TTGlyph>
EOF
	    }
	} else {
	    warn "$0: bad character in method '$m' for add '$a'\n";
	    ++$status;
	}
    }
}

die "$0: errors in add table. Stop.\n" if $status;

if ($debug) {
    open(D,'>ttxadd.dbg'); select D;
    print '<debug>';
    print '<GlyphOrder>', @glyphid, '</GlyphOrder>';
    print '<hmtx>', @mtx, '</hmtx>';
    print '<glyf>', @ttglyph, '</glyf>';
    print '</debug>';
    close(D);
} else {
    open(T, $ttxfile) || die;
    open(O, ">$outfile") || die; select O;
    while (<T>) {
	if (m#</GlyphOrder#) {
	    print @glyphid;
	} elsif (m#</hmtx#) {
	    print @mtx;
	} elsif (m#</glyf#) {
	    print @ttglyph;
	} elsif (m#</cmap_format_12#) {
	    print @code if $#code >= 0;
	}
	print;
    }
    close(O);
    close(T);
}

1;

################################################################################

sub check_liga {
    my $l = shift;
    my $lstatus = 0;
    $l =~ s/\.liga$// || warn "$l has no .liga\n";
    $l =~ s/^_//;
    my @l = split(/_/,$l);
    foreach my $x (@l) {
	unless (exists $known{$x}) {
	    warn "$l.liga has unknown component $x\n" if length $x;
	    ++$lstatus;
	}
    }
    return $lstatus;
}
