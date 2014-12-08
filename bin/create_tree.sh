#! /bin/sh

(echo $1 >&2
if ! [ -d "$1" ]; then
    mkdir "$1"
fi
DEST=$(cd "$1" && pwd)
echo "$DEST" >&2
if ! [ -d "$DEST"/vignettes ]; then
    mkdir "$DEST"/vignettes/
fi
if ! [ -d "$DEST"/includes ]; then
    mkdir "$DEST"/includes/
fi
if ! [ -d "$DEST"/images/ ]; then
    mkdir "$DEST"/images/
fi
if ! [ -d "$DEST"/viewers/ ]; then
    mkdir "$DEST"/viewers/
fi

exit 0)

    
