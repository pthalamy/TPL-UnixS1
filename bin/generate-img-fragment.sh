#! /bin/sh

alt="$3"
legend="$4"

usage () {
    echo 'usage: generate-img-fragment.sh vignette image ' \
	'"alt-name" "legend"' >&2
}

if [ $# -ge 2 ]; then
    if ! [ -r $1 ]; then
	echo "generate-img-fragment.sh: Le fichier $1 n'existe pas." >&2
	exit 1;
    elif ! [ -r $2 ]; then
	echo "generate-img-fragment.sh: Le fichier $2 n'existe pas." >&2
	exit 1;
    else
	echo '<div class="imgframe">'
	echo '<a href='"$2"' target="_blank">'
	echo '<img class="image" src="'"$1"'" alt="'"$alt"'"><br>'
	echo '</a>'
	echo '<span class="legend">'"$legend"'</span>'
	echo '</div>'
    fi
    
    exit 0
else
    echo "generate-img-fragment.sh: Nombre d'arguments invalide." >&2
    usage; exit 1;
fi
