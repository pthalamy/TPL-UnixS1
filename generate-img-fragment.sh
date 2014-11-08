#! /bin/sh

usage () {
    echo 'usage: generate-img-fragment.sh src "alt-name" "legend"'
}

if [ $# -eq 3 ]; then
    if ! [ -r $1 ]; then
	echo "Le fichier $1 n'existe pas." >&2
    else
	echo '<div class="imgframe">'
	echo '<img class="image" src="'"$1"'" alt="'"$2"'"><br>'
	echo '<span class="legend">'"$3"'</span>'
	echo '</div>'
	exit 0
    fi

else
    echo "Nombre d'arguments invalide." >&2
    usage; exit 1;
fi
