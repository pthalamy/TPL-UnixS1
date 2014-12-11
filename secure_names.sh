#! /bin/sh

# Usage: secure_names dossier
# Si $1 est définit:
# Renomme les images jpg contenu dans dossier en remplacant les espaces dans
# leur nom par '_'.
# Sinon :
# Ne fait rien. (Si appelé par make clean par exemple)

if [ "$1" != "" ]; then
    for img in "$1"/*.jpg; do 
	mv "$img" $(echo $img | tr ' ' '_') ; 
    done
fi

exit 0
