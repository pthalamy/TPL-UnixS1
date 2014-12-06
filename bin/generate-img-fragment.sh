#! /bin/sh

alt="$3"
legend="$4"

usage () {
    echo 'usage: generate-img-fragment.sh vignette viewerName' >&2
}

if [ $# -ge 1 ]; then
    if ! [ -r $1 ]; then
	echo "generate-img-fragment.sh: Le fichier $1 n'existe pas." >&2
	exit 1;
    else
	echo '<div class="vgframe">'
	echo '<a href='"viewers/$2"' target="_top">'
	echo '<img class="image" src='"$1"'><br>'
	echo '</a>'
	echo '</div>'
    fi
    
    exit 0
else
    echo "generate-img-fragment.sh: Nombre d'arguments invalide." >&2
    usage; exit 1;
fi
