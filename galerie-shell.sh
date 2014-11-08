#! /bin/sh

src=''
dest=''
verbose=0
dry_run=0
main_file='index.html'

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utilities.sh

usage () {
    cat <<EOF
Utilisation: generate-img-fragment.sh [OPTIONS] SOURCE DEST
Saisissez «galerie-shell.sh --help» pour plus d'informations.
EOF
}

help () {
    cat <<EOF
utilisation: generate-img-fragment.sh [OPTIONS] SOURCE DEST
    Options: -v   --verbose          \tmode verbeux 
             -dr  --dry-run          \texecution "a sec"
             -h,  --help             \taffiche ce message
             -mf, --main-file FICHIER\tSpecifie le nom du fichier html de sortie
             -s,  --src REP          \tRepertoire contenant les images JPEG 
                                     \ta miniaturiser
             -d,  --dest REP         \tRepertoire cible pour vignettes 
                                     \tet fichier html                    
EOF
}

# Parsing des arguments du script
while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            help
            exit 0
            ;;
        "--src" | "-s")
            shift; src="$1"
            ;;
        "--dest" | "-d")
            shift; dest="$1"
            ;;
        "--main-file" | "-mf")
            shift; main_file="$1"
            ;;
        "--dry-run" | "-dr")
            dry_run=1
            ;;
        "--verbose" | "-v")
            verbose=1
            ;;
        *)
            echo "Argument non reconnu : $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# Ouverture du fichier de sortie sur le desc 5
if ! [ -d "$dest" ]; then
    mkdir "$dest"
fi
exec 5>"$dest/$main_file"

# On doit avoir au minimum le repertoire source et dest comme arguments
if [ "$src" = "" -o "$dest" = "" ]; then
    echo "Il manque un ou plusieurs arguments."
    usage; exit 1
fi

# Si la verbose est inactive, redirection de nos sorties vers /dev/null
if [ "$verbose" = 1 ]; then
    exec 4>&2 3>&1
else
    exec 4>/dev/null 3>/dev/null
fi

html_head "GALERIE DE CHATONS MIGNONS" >&5
html_title "GALERIE DE CHATONS MIGNONS" >&5

# Generation des vignettes pour chaque image jpeg de src
for file in "$src"/*; do
    filename=$(basename $file)
    if [ -f "$dest/thumb-$filename" ]; then
	echo "$dest/thumb-$filename existe deja, on l'ignore..." >&3
    else 
	echo "convert -thumbnail 320x240 $file $dest/thumb-$filename" >&3
	convert -thumbnail 320x240 "$file" "$dest/thumb-$filename"
	echo "generate-img-fragment.sh thumb-$filename alt-name legend >&5" >&3
	cd "$dest"
	"$DIR"/generate-img-fragment.sh "thumb-$filename" "alt-name" "legend" >&5
	cd "$DIR"
    fi
done

html_tail >&5

printf "\nLe fichier html genere est disponible ici: $dest/$main_file\n"
exit 0
