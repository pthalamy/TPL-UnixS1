# Source and destination directories, to be configured here:
SOURCE=./images
DEST=./dest


IMAGES=${shell cd $(SOURCE) && echo *.jpg}
THUMBS=$(IMAGES:%=$(DEST)/vg-%)
IMAGE_DESC=$(IMAGES:%.jpg=$(DEST)/%.inc)


# TODO
$(DEST)/%.inc: $(DEST)/vg-%.jpg
	./bin/generate-img-fragment_simple.sh vg-$*.jpg vg-$*.jpg > $@

$(DEST)/index.html: $(IMAGE_DESC)
	./bin/generate-index.sh $^ > $@

$(DEST)/vg-%.jpg: $(SOURCE)/%.jpg
	convert -thumbnail 320x240 $< $@

.PHONY: gallery
gallery: $(DEST)/index.html $(THUMBS)

.PHONY: view
view:

.PHONY: clean
clean:
	rm -rf $(DEST)/*

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

./exiftags: $(EXIFTAGS_OBJS)
	$(CC) $(CFLAGS) -o $@ $(EXIFTAGS_OBJS) -lm
