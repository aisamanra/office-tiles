SVGS ::= $(wildcard raws/*.svg)
PNGS ::= $(SVGS:.svg=.png)

all: $(PNGS) sheet/spritesheet.png sheet/spritesheet.xml

%.png: %.svg
	inkscape -e $@ $<

sheet/spritesheet.png: $(PNGS)
	mkdir -p sheet
	montage $(sort $(PNGS)) -background None -geometry +0+0 -tile 8x8 $@

sheet/spritesheet.xml: $(PNGS)
	mkdir -p sheet
	echo "<TextureAtlas>" >$@
	for Y in `seq 0 8`; do \
	  for X in `seq 0 8`; do \
	    NX=`echo $$X '*' 40 | bc`; \
	    NY=`echo $$Y '*' 40 | bc`; \
	    C=`echo $$X + $$Y '*' 8 | bc`; \
	    FN=`printf '%03d-' $$C`; \
	    FL=raws/$$FN*.png; \
	    test '!' -e $$FL || \
	    echo "  <SubTexture name=\"$${FN}sprite\" x=\"$$NX\" y=\"$$NY\" width=\"40\" height=\"40\" />" >>$@; \
	  done;\
	done
	echo "</TextureAtlas>" >>$@

clean:
	rm -f sheet/spritesheet.xml sheet/spritesheet.png raws/*.png
