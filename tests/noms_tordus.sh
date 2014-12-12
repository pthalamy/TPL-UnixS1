#! /bin/sh

# Teste gallery-shell avec :
# Répertoire source :
#  - chemin relatif
#  - Toutes sortes de noms tordus, dont images
# Répertoire destination :
#  - chemin relatif
#  - pré-existant, noms de fichiers et repertoires avec caracteres speciaux
# Script:
#  - Nom d'index avec espace
#

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

# Création d'images
make-img.sh 'source/aaa.jpg' 
make-img.sh 'source/tata-*.jpg' 
make-img.sh 'source/truca.jpg'
make-img.sh 'source/..jpg'
make-img.sh 'source/$img.jpg'
make-img.sh 'source/~ls.jpg' 
make-img.sh 'source/nomNormal.jpg'

# Autres fichiers de source/
touch "dest/fichier1" "dest/fichier2" "dest/fi*ier" "dest/dontreadme.txt"

# Dest contenant fichiers et dossiers avec caractères spéciaux
make-img.sh "dest/imageAIgnorer.jpg"
touch "dest/fichier3" "dest/fichier4" "dest/machin-*" "dest/ space" 
mkdir -p "dest/dir" "dest/o-*dir2"

gallery-shell.sh --source source --destination dest -mf 'index espace.html' -v

if [ -f 'dest/index espace.html' ]; then
    echo "Now run 'firefox dest/index espace.html' to check the result"
else
    echo "ERROR: dest/index espace.html was not generated"
fi
