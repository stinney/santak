.PRECIOUS: src/bits.ttx src/test.ttx

default: pc25

%: %.ttf
	true

# For any font that is going to be generated there must be a src/%.ttx
%.ttf: src/%.ttx src/bits.ttx
	true

src/%.ttx: src/%.ttf
	ttx -o $@ -i $<

