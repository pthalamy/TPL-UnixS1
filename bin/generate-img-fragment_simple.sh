#! /bin/sh

alt="$3"
legend="$4"

usage () {
    echo 'usage: generate-img-fragment.sh vignette image ' \
	'"alt-name" "legend"' >&2
}

if [ $# -ge 2 ]; then
    echo '<div class="imgframe">'
    echo '<a href='"$(basename $2).html"' target="_blank">'
    echo '<img class="image" src="'"$1"'" alt="'"$alt"'"><br>'
    echo '</a>'
    echo '<span class="legend">'"$legend"'</span>'
    echo '</div>'    
    exit 0
else
    echo "generate-img-fragment.sh: Nombre d'arguments invalide." >&2
    usage; exit 1;
fi
