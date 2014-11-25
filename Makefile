# Source and destination directories, to be configured here:
SOURCE=./exif-images
DEST=./dest
BIN=./bin

IMAGES=${shell cd $(SOURCE) && echo *.jpg}
THUMBS=$(IMAGES:%=$(DEST)/vg-%)
IMAGE_DESC=$(IMAGES:%.jpg=$(DEST)/%.inc)
IMAGE_VIEWER=$(IMAGES:%.jpg=$(DEST)/%.html)

# TODO
$(DEST)/%.inc: $(DEST)/vg-%.jpg exiftags
	./bin/generate-img-fragment_simple.sh vg-$*.jpg vg-$*.jpg \
	"$*" "$* - $($(BIN)/exiftags $(SOURCE)/$*.jpg | grep 'Equipment Make')" > $@

$(DEST)/index.html: $(IMAGE_DESC)
	./bin/generate-index.sh $^ > $@

$(DEST)/vg-%.jpg: $(SOURCE)/%.jpg
	convert -thumbnail 320x240 $< $@

$(DEST)/%.html: $(SOURCE)/%.jpg
	mv $< $(DEST)
	./bin/generate-viewer.sh $*.jpg

.PHONY: gallery
gallery: $(DEST)/index.html $(THUMBS)

.PHONY: view
view: gallery
	open $(DEST)/index.html

.PHONY: clean
clean:
	@rm -f $(THUMBS) $(IMAGE_DESC) $(DEST)/index.html

.PHONY: realclean
realclean: clean
	@rm -f $(EXIFTAGS_OBJS) $(BIN)/exiftags

# Simplified version of exiftags's Makefile
EXIFTAGS_OBJS=exiftags-1.01/exif.o exiftags-1.01/tagdefs.o exiftags-1.01/exifutil.o \
	exiftags-1.01/exifgps.o exiftags-1.01/jpeg.o exiftags-1.01/makers.o \
	exiftags-1.01/canon.o exiftags-1.01/olympus.o exiftags-1.01/fuji.o \
	exiftags-1.01/nikon.o exiftags-1.01/casio.o exiftags-1.01/minolta.o \
	exiftags-1.01/sanyo.o exiftags-1.01/asahi.o exiftags-1.01/leica.o \
	exiftags-1.01/panasonic.o exiftags-1.01/sigma.o exiftags-1.01/exiftags.o
EXIFTAGS_HDRS=exiftags-1.01/exif.h exiftags-1.01/exifint.h \
	exiftags-1.01/jpeg.h exiftags-1.01/makers.h

%.o: %.c $(EXIFTAGS_HDRS)
	$(CC) $(CFLAGS) -o $@ -c $<

$(BIN)/exiftags: $(EXIFTAGS_OBJS)
	$(CC) $(CFLAGS) -o $@ $(EXIFTAGS_OBJS) -lm

exiftags: $(BIN)/exiftags
