#! /bin/sh

src=''
dest=''
title="Galerie d'images"
verbose=0
dry_run='' # dry_run inactif par defaut
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
             -s,  --source REP          \tRepertoire contenant les images JPEG 
                                     \ta miniaturiser
             -d,  --dest REP         \tRepertoire cible pour vignettes 
                                     \tet fichier html                    
             -t,  --title TITRE      \tTitre de la page
EOF
}

# Parsing des arguments du script
while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            help
            exit 0
            ;;
        "--source" | "--src" | "-s")
            shift; src="${1%/}"
            ;;
        "--destination" | "--dest" | "-d")
            shift; dest="${1%/}"
            ;;
        "--main-file" | "-mf")
            shift; main_file="$1"
            ;;
        "--title" | "-t")
            shift; title="$1"
            ;;
        "--dry-run" | "-dr")
            dry_run="echo"
            ;;
        "--verbose" | "-v")
            verbose=1
            ;;
        *)
            echo "erreur: Argument non reconnu : $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# Si la verbose est inactive, redirection de nos sorties vers /dev/null
if [ "$verbose" = 1 ]; then
    exec 4>&2 3>&1
else
    exec 4>/dev/null 3>/dev/null
fi

# On doit avoir au minimum le repertoire source et dest comme arguments
if [ "$src" = "" -o "$dest" = "" ]; then
    echo "erreur: Il manque un ou plusieurs arguments."
    usage; exit 1
fi

if [ $dry_run ]; then 
    printf "!-- Execution a sec, aucune commande ne sera executee --!\n\n"
fi

# Creation de l'arborescence du site si inexistante
if ! [ -d "$dest" ]; then
    $dry_run mkdir "$dest"
fi
if ! [ -d "$dest/images/" ]; then
    $dry_run mkdir "$dest/images/"
fi
if ! [ -d "$dest/vignettes/" ]; then
    $dry_run mkdir "$dest/vignettes/"
fi

## Ecriture du fichier HTML
# Ouverture du fichier de sortie sur le desc 5
# et ecriture du header et titre
if [ $dry_run ]; then 
    echo 'exec 5>' "$dest/$main_file"
    echo 'html_head '"$title"' >&5'
    echo 'html_title '"$title"' >&5'
else 
    exec 5> "$dest/$main_file"
    html_head "$title" >&5
    html_title "$title" >&5
fi

# Generation des vignettes pour chaque image jpeg de src
printf "\n* Generation des vignettes... \n"

for file in "$src"/*; do
    filename=$(basename "$file")

    # Copie de l'image dans $dest/images/ si inexistante
    if ! [ -f "$dest/images/$filename" ]; then
	echo "cp $file $dest/images" >&3
	$dry_run cp "$file" "$dest"/images/
    fi
    
    # Si la vignette n'existe pas, la creer
    if [ -f "$dest/vignettes/vg-$filename" ]; then
        echo "$dest/vignettes/vg-$filename existe deja, on l'ignore..." >&3
    else 
	echo "convert -thumbnail 320x240 $file $dest/vignettes/vg-$filename" >&3
	$dry_run convert -thumbnail 320x240 \
	    "$file" "$dest/vignettes/vg-$filename"
    fi
done

# Ecriture des images dans le fichier HTMl
printf "\n* Ecriture des images dans le fichier HTMl...\n"

echo "cd $dest" >&3
$dry_run cd "$dest"

while true; do
    echo "Voulez vous entrer des legendes pour chaque image ? [oO | (nN)]"
    read legendMode
    case "$legendMode" in
	"o" | "O" | "Oui")
	    break
	    ;;
	"n" | "N" | "Non")
	    break
	    ;;
	'')
	    legendMode='n'; break
	    ;;
	*)
	    echo "Veuillez repondre par oui ou non."
	    ;;
    esac
done

for img in images/*; do
    imageName=$(basename "$img")

    if ! [ $legendMode = 'n' -o $legendMode = 'N' ]; then
	echo "--> Veuillez entrer la legende de l'image $imageName: "
	$dry_run read legend
    fi
	
    printf "generate-img-fragment.sh vignettes/vg-$imageName " \
	"images/$imageName " >&3
    printf "$imageName $legend > $main_file \n" >&3

    if [ $dry_run ]; then 
	echo "$DIR"/generate-img-fragment.sh vignettes/vg-"$imageName" \
	    images/"$imageName" "$imageName" "$legend"' >&5'
    else
	"$DIR"/generate-img-fragment.sh vignettes/vg-"$imageName" \
	    images/"$imageName" "$imageName" "$legend" >&5
    fi
done

$dry_run cd "$DIR"

if [ $dry_run ]; then echo 'html_tail >&5'; else html_tail >&5; fi

printf "\n* Fini: Le fichier html genere est disponible ici: $dest/$main_file\n"
exit 0
