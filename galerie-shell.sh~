#! /bin/sh

usage () {
    echo 'usage: generate-img-fragment.sh src "alt-name" "legend"'
}

if [ $# -eq 3 ] && [ -r $1 ]; then
    echo '<img src="'"$1"'">'
    echo '<div class="imgframe">'
    echo '<img class="image" src="'"$1"'" alt="'"$2"'"><br>'
    echo '<span class="legend">'"$3"'</span>'
    echo '</div>'
else
    usage
fi