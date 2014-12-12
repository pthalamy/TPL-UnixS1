#! /bin/sh

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utilities.sh

usage () {
    echo 'usage: generate-img-fragment.sh vignette viewer date' >&2
}

if [ $# -ne 1 ]; then
	legend="$(basename "$2" .html)"

	echo '<div class="vgframe">'
	echo '<a href="'"$2"'" target="_top">'
	echo '<img class="image" '
	echo 'alt="'"$(basename "$1" .jpg)"'" '
	echo 'src="'"$(FileRelative2Absolute "$1")"'"><br>'
	echo '</a>'
	echo '<span class="vg-legend">'"$legend"'</span>'
	echo '</div>'
    
    exit 0
else
    echo "generate-img-fragment.sh: Nombre d'arguments invalide." >&2
    usage; exit 1;
fi
