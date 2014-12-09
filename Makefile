# Source and destination directories, to be configured here:
SOURCE=./exifimages
DEST=./dest

SOURCE_IMAGES=${shell cd $(SOURCE) && echo *.jpg}
DEST_IMAGES=$(SOURCE_IMAGES:%=$(DEST)/images/%)
THUMBS=$(SOURCE_IMAGES:%=$(DEST)/vignettes/vg-%)

IMAGE_DESCS=$(SOURCE_IMAGES:%.jpg=$(DEST)/includes/%.inc)
IMAGE_VIEWERS=$(SOURCE_IMAGES:%.jpg=$(DEST)/viewers/%.html)

TREE_DIRS=$(DEST)/vignettes/ $(DEST)/viewers/ $(DEST)/images/ $(DEST)/includes/

# TODO
.PHONY: gallery
gallery: $(DEST) ./exiftags $(TREE_DIRS) $(DEST)/index.html $(THUMBS) $(IMAGE_VIEWERS) $(DEST_IMAGES)

.PHONY: view
view: gallery 
	open $(DEST)/index.html

$(TREE_DIRS): 
	mkdir $@

$(DEST):
	mkdir $@

$(DEST)/index.html: $(IMAGE_DESCS)
	./generate-index.sh $^ > $@

$(DEST)/vignettes/vg-%.jpg: $(SOURCE)/%.jpg
	convert -thumbnail 320x240 $< $@

$(DEST)/includes/%.inc: $(DEST)/vignettes/vg-%.jpg $(DEST)/viewers/%.html
	./generate-img-fragment.sh $(DEST)/vignettes/vg-$*.jpg \
		./viewers/$*.html > $@

$(DEST)/viewers/%.html: $(DEST)/images/%.jpg $(DEST_IMAGES)
	./generate-viewer.sh $(DEST)/ $(DEST)/images/$*.jpg \
		$(realpath DEST)/index.html > $@

$(DEST)/images/%.jpg: $(SOURCE)/%.jpg
	cp $(SOURCE)/$*.jpg $(DEST)/images/

.PHONY: clean
clean:
	@rm -f $(THUMBS) $(IMAGE_DESCS) $(IMAGE_VIEWERS) $(DEST_IMAGES)
	@rm -f $(DEST)/index.html
	@rmdir $(TREE_DIRS)

.PHONY: realclean
realclean: 
	@rm -rf $(DEST) $(EXIFTAGS_OBJS) ./exiftags

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
