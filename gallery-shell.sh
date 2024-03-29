#! /bin/sh

# Memorisation du repertoire de travail et includes
DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utilities.sh

# Variables globales
src=''
unsafe_dest=''
dest=''
title="Galerie d'images"
verbose=0
dry_run='' # dry_run inactif par defaut
open=0
main_file='index.html' 

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
             -o,  --open             \tOuvre directement la galerie
EOF
}

# Parsing des arguments du script
parse_args () {
    while test $# -ne 0; do
	case "$1" in
            "--help"|"-h")
		help
		exit 0
		;;
            "--source" | "--src" | "-s")
		shift; 
		src="$(cd "${1%/}" && pwd)"
		;;
            "--destination" | "--dest" | "-d")
		shift; 
		unsafe_dest="$1"
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
	    "-o" | "--open")
	        open=1
		;;
            *)
		echo "erreur: Argument non reconnu : $1"
		usage
		exit 1
		;;
	esac
	shift
    done
}

# Initialise les elements nécessaires au script en fonction 
# des résultats du parsing
init () {
    # On transforme le dest passé en argument en son chemin absolu et le crée
    # si nécessaire
    if ! [ -d "$unsafe_dest" ]; then
	$dry_run mkdir "$unsafe_dest"
    fi
    if [ "$dry_run" = "" ]; then
	dest="$(cd "${unsafe_dest%/}" && pwd)"
    else
	dest="${unsafe_dest%/}"
    fi

    # On doit avoir au minimum le repertoire source et dest comme arguments
    if [ "$src" = "" -o "$dest" = "" ]; then
	echo "erreur: Il manque un ou plusieurs arguments." >&2
	usage; exit 1
    fi

    ## Si la verbose est inactive, redirection de nos sorties vers /dev/null
    # 1: stdout
    # 2: stderr
    # 3: verbose stdout
    # 4: verbose stderr
    # 5: fichier html
    if [ $dry_run ]; then 
	echo 'exec 5> $dest/$main_file'
    else
	exec 5> "$dest"/"$main_file"
    fi
    
    if [ "$verbose" = 1 ]; then
	exec 4>&2 3>&1
    else
	exec 4>/dev/null 3>/dev/null
    fi

    # Notification d'activation du dry_run
    if [ $dry_run ]; then 
	printf "!-- Execution a sec, aucune commande ne sera executee --!\n\n" >&2
    fi

    # Creation de l'arborescence du site si inexistante
    if ! [ -d "$dest/images/" ]; then
	$dry_run mkdir "$dest/images/"
    fi
    if ! [ -d "$dest/vignettes/" ]; then
	$dry_run mkdir "$dest/vignettes/"
    fi
    if ! [ -d "$dest/viewers/" ]; then
	$dry_run mkdir "$dest/viewers/"
    fi

    # Vérification que exiftags est compilé
    if ! [ -f "$DIR"/exiftags  ]; then
	echo "$DIR/exiftags n'existe pas, on le compile... " >&2
	(cd "$DIR"/exiftags-1.01 && make && mv exiftags "$DIR" ) > /dev/null
    fi
}

print_index_header () {
    # Ecriture du header et titre
    if [ $dry_run ]; then 
	echo 'html_head '"$title"' >&5'
	echo 'html_title '"$title"' >&5'
    else 
	html_head "$title" >&5
	html_title "$title" >&5
    fi
}

# Generation des vignettes pour chaque image jpg de src
generate_thumbs () {
    printf "* Generation des vignettes... \n"

    for file in "$src"/*.jpg; do

	if [ "$file" = "$src"'/*.jpg' ]; then # Pas d'images dans source
	    continue;
	fi;

	filename="$(basename "$file")"

	# Copie de l'image dans $dest/images/ si inexistante
	# Et redimensionnement si plus grande que 800x600
	if ! [ -f "$dest"/images/"$filename" ]; then
	    echo "cp $file $dest/images" >&3
	    $dry_run cp "$file" "$dest/images/"
	    echo 'convert -resize "650x412>" '"$dest/images/$filename" \
		"$dest/images/$filename" >&3
	    $dry_run convert -resize "650x412>" "$dest/images/$filename" \
		"$dest/images/$filename"
	fi
	
	# Si la vignette n'existe pas, la creer
	if [ -f "$dest"/vignettes/vg-"$filename" ]; then
            echo "$dest/vignettes/vg-$filename existe deja, on l'ignore..." >&3
	else 
	    echo "convert -thumbnail 320x240 $file $dest/vignettes/vg-$filename" >&3
	    $dry_run convert -thumbnail '320x240' \
		"$file" "$dest/vignettes/vg-$filename"
	fi
    done
}

# Inclusion des images dans le fichier HTMl
include_images () {
    printf "\n* Ecriture des images dans le fichier HTMl...\n"
    
    for img in "$dest"/images/*; do
	if [ "$img" = "$dest"'/images/*' ]; then # Pas d'images dans source
	    continue;
	fi;

	imageName=$(basename "$img")
	viewerName=$(basename "$imageName" .jpg).html

	if [ "$dry_run" != '' -o "$verbose" -eq 1 ]; then 
	    echo "$DIR"'/generate-img-fragment.sh' \
		"$dest"/vignettes/vg-"$imageName"	\
		./viewers/"$viewerName"'>&5'

	    echo "$DIR"'/generate-viewer.sh '"$dest $imageName" \
		"$dest/$main_file "'>' "$dest/viewers/$viewerName"
	fi

	if [ "$dry_run" = '' ]; then
	    "$DIR"/generate-img-fragment.sh "$dest"/vignettes/vg-"$imageName" \
		./viewers/"$viewerName" >&5
	    
	    "$DIR"/generate-viewer.sh  "$dest" "$img" "$dest"/"$main_file" \
		> "$dest"/viewers/"$viewerName"
	fi
    done
}

print_index_footer () {
    if [ $dry_run ]; then 
	echo 'html_tail >&5'; 
    else 
	html_tail >&5; 
    fi
}

open_gallery () {
    if [ "$open" -eq 1 ]; then
        firefox "$dest"/"$main_file"
    fi
}

echo "
                 --------- Script Gallerie Shell ---------
"

parse_args "$@"
init

print_index_header

generate_thumbs
include_images

print_index_footer

printf "\n* Fini: Le fichier html genere est disponible ici: %s/%s \n" \
    "$dest" "$main_file"
echo "
                  -- Par Guillaume Halb & Pierre Thalamy --"

open_gallery

exit 0
