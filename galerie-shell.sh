#! /bin/sh

SRC=''
DEST=''
VERBOSE=0
DRY_RUN=0
MAIN_FILE='index.html'

usage () {
    echo 'utilisation: galerie-shell.sh [OPTIONS] SOURCE DEST'
    echo "Saisissez «galerie-shell.sh --help» pour plus d'informations."
}

help () {
    echo 'utilisation: generate-img-fragment.sh [OPTIONS] SOURCE DEST'
    echo 'OPTIONS:'
    echo '\t -v, --verbose'
    echo '\t --dry-run'
    echo '\t --help'
    echo '\t --help'
}

parse_args () {
    for I in `seq 1 $#`; do 
	case 
    done 
}

if [ $# -eq 1 ] && [ -d $1 ]; then
    
    
else
    usage
fi