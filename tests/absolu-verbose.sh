#! /bin/sh

# Test très simple qui teste gallery-shell avec :
# Répertoire source :
#  - chemin absolu
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires
#  - contient des images, et uniquement des images.
# Répertoire destination :
#  - existant avant le lancement du script, vide.
#  - chemin absolu
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"
SOURCE=./source
DEST=./dest

rm -fr source dest
mkdir -p source dest

ABS_SOURCE=$(cd "$SOURCE" && pwd)
ABS_DEST=$(cd "$DEST" && pwd)

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

gallery-shell.sh -v --source "$ABS_SOURCE" --destination "$ABS_DEST" -v

if [ -f "$ABS_DEST"/index.html ]
then
    echo "Now run 'firefox $ABS_DEST/index.html' to check the result"
else
    echo "ERROR: $ABS_DEST/index.html was not generated"
fi
