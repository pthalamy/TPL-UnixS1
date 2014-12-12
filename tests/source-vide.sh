#! /bin/sh

# Test très simple qui teste gallery-shell avec :
# Répertoire source :
#  - vide
#  - chemin relatif
# Répertoire destination :
#  - existant avant le lancement du script, vide.
#  - chemin relatif

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

gallery-shell.sh -v --source source --destination dest

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi
