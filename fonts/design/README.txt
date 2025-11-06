Oracc Font Design Parameters
============================

This document is an attempt to define basic parameters for new Oracc
fonts.  The dimensions are based on observation of Noto Sans Cuneiform
which is generally well-proportioned and embeds well in non-cuneiform
contexts.

Heights and Depths
==================

The top line for characters is 750 units; the centre line is 315; the
baseline is at 0 units; the bottom line (or descender depth) is -250
units.

Characters generally hang from the top line and reach to the baseline.
For signs that have a middle axis like GIR₂, TI, BALA, the middle of
the centre horizontal is on the centre line.  For signs that sit on
the baseline, the lower horizontal's centre line is on the baseline
rather than the lower corner of its wedge.

Characters may extend up to 100 units above the top line and/or below
the bottom line.  Characters that must be bigger than this should not
be allowed to influence the overall heights and depths of the font.

Wedge Sizing
============

Reusable component wedges are defined in a fixed set of sizes and are
described according to four dimensions: head; waist; tail; and stroke.

	* HEAD is the width of the head at its broadest extent

	* WAIST is the point on the sign where the width of the stroke
  	  becomes constant; smaller numbers mean the wedge is closer
  	  to the head than larger numbers

	* TAIL is the length of the sign

	* STROKE is the width of the sign at the end of the tail

Sizes are given as a range from 0..9, so the syntax of a wedge description is:

 hNwNtNsN

where N = number from 0..9.  Most wedge descriptions omit the final
component, stroke, because that is normally fixed.

The correlations of numbers to unit sizes differ according to the
dimensions.  In general, 5 is the average size for the font; 9 is the
largest; 1 is the smallest.

The prototypical wedge, the AŠ/DIŠ, will normally be h5w5t5

Straight lines are notated simply as:

 sN

Such lines generally need to be sized to their containing component
and since they can be lengthened or shortened without loss of
proportion it is sufficient to specify a stroke width.


