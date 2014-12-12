#! /bin/sh

# Test très simple qui teste gallery-shell avec :
# EN MODE DRY_RUN
# Répertoire source :
#  - chemin relatif
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires
#  - contient des images, et uniquement des images.
# Répertoire destination :
#  - existant avant le lancement du script, vide.
#  - chemin relatif
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

SOURCE=./source
DEST=./dest

rm -fr "$SOURCE" "$DEST"
mkdir "$SOURCE"

make-img.sh "$SOURCE"/image1.jpg
make-img.sh "$SOURCE"/image2.jpg

gallery-shell.sh -v --source "$SOURCE" --destination "$DEST" -dr

# Aucun fichier ne doit avoir été genéré
if ! [ -d "$DEST" ]
then
    echo "--> L'execution à sec à fonctionné."
else
    echo "ERREUR: Le script à genéré des fichiers !"
fi
