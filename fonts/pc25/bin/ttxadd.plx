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

my %warned = ();

my $addfile = undef;
my $outfile = undef;
my $ttxbase = undef;
my $verbose = 0;

GetOptions(
    'add:s'=>\$addfile,
    'out:s'=>\$outfile,
    'ttx:s'=>\$ttxbase,
    verbose=>\$verbose,
    );

die "Usage: $0 -a [ADD] -t [TTX] -o [OUT]\n"
    unless $addfile && $outfile && $ttxbase;

my $status = 0;
my @add = (); my %add = (); load_adds();

my %hmtx = (); load_hmtx();

my %ttglyph = (); load_ttglyph();

die "$0: errors in add table. Stop.\n" if $status;

# print Dumper \%add; exit 1;

my $gid = getgid();
my @g = ();
my @h = ();
my @t = ();

foreach my $a (@add) {
    push @g, glyphid($a);
    my $src = $add{$a};
    if ($hmtx{$src}) {
	my $h = $hmtx{$src};
	$h =~ s/name=".*?"/name="$a"/;
	push @h, $h;
    } else {
	warn "$0: bad src $src when adding $a\n";
    }
    if ($ttglyph{$src}) {
	my $t = $ttglyph{$src};
	$t =~ s/name=".*?"/name="$a"/;
	my $c =  "<component glyphName=\"$src\" x=\"0\" y=\"0\" flags=\"0x1000\"/>";
	push @t, $t.$c."</TTGlyph>";
    } else {
	warn "$0: bad src $src when adding $a\n";
    }
} 

#print @t;

ttxadd("$ttxbase.GlyphOrder.ttx", '</GlyphOrder>', @g);

1;

################################################################################

sub getgid {
    my $g = `grep '<GlyphID' $ttxbase.GlyphOrder.ttx | tail -1 | cut -d'"' -f2`; chomp $g;
    return $g;
}

sub glyphid {
    my $u = shift;
    ++$gid;
    "<GlyphID id=\"$gid\" name=\"$u\"/>";
}

sub load_adds {
    my @t = `cat $addfile`; chomp @t;
    foreach (@t) {
	my($a,$m) = split(/\t/,$_);
	if ($add{$a}) {
	    warn "$0: duplicate 'add' char $a\n";
	    ++$status;
	} else {
	    if ($m eq '-' || $m =~ /^[0-9A-F_u]+$/) {
		$add{$a} = $m;
		push @add, $a;
	    } else {
		warn "$0: bad character in method '$m' for add '$a'\n";
		++$status;
	    }
	}
    }
}

sub load_hmtx {
    my @x = `grep '<mtx' $ttxbase._h_m_t_x.ttx`; chomp @x;
    foreach (@x) {
	my($n) = (/name="(.*?)"/);
	$hmtx{$n} = $_;
    }
}

sub load_ttglyph {
    my @x = `grep '<TTGlyph' $ttxbase._g_l_y_f.ttx`; chomp @x;
    foreach (@x) {
	my($n) = (/name="(.*?)"/);
	$ttglyph{$n} = $_;
    }
}

sub ttxadd {
    my($file,$tag,@add) = @_;
    open(F,$file) || die "$0: ttxadd failed to open $file for read. Stop.\n";
    my $outfile = $file; $outfile =~ s/src/out/;
    open(O,">$outfile") || die "$0: ttxadd unable to write to $outfile. Stop.\n";
    select O;
    while (<F>) {
	if (/$tag/) {
	    print join("\n",@add),"\n";
	}
	print;
    }
    close(O);
    close(F);
}
  
