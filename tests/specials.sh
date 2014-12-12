#! /bin/sh

# Test sur un répertoire source dont l'un des fichiers, 
# les répertoires source/dest ainsi que 
# le nom de l'index contiennent un espace.

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

index='index espace.html'
src='source dir'
dest='dest dir'

rm -fr "$src" "$dest"
mkdir -p "$src" "$dest"

make-img.sh "$src/image espace.jpg"
make-img.sh "$src/image  deuxespaces.jpg"
make-img.sh "$src/image3* *.jpg"
make-img.sh "$src/image4.jpg"

gallery-shell.sh --source "$src" --destination "$dest" \
    -mf "$index" -v -o

if [ -f "$dest/$index" ]
then
    echo "Now run 'firefox $dest/$index' to check the result"
else
    echo "ERROR: $dest/$index was not generated"
fi
