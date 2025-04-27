.PRECIOUS: src/bits.ttx src/test.ttx

default: pc25

%: %.ttf
	(cd out ; ttx $*.ttx)

# For any font that is going to be generated there must be a src/%.ttx
%.ttf: src/%.ttx src/bits.ttx
	rm -f out/$*.ttx out/$*.*.ttx
	bin/ttxadd.plx -t src/$*
	bin/cpttx.sh $*

src/%.ttx: src/%.ttf Makefile
	ttx -o $@ -s -i $<

