#! /bin/sh

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utilities.sh

title="Galerie d'images"

usage () {
    cat <<EOF
Utilisation: generate-index.sh <includes>
Crée une page HTML contenant en body le contenu de tous les fichiers en arg.
EOF
}

# Printing du header
html_head "$title" 
html_title "$title" 

# Insertion du code de chaque image
while test $# -ne 0; do
    echo
    cat "$1"
    shift
done

# Balises de fin
html_tail

exit 0
