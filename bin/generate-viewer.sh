#! /bin/sh

DIR=$(pwd)
BIN=$(cd "$(dirname "$0")" && pwd)
. "$BIN"/utilities.sh

title="Image Viewer"
index="$DIR"/"$3"
legend="$2"

usage () {
    cat <<EOF
Utilisation: generate-viewer.sh image "legend" indexName
EOF
}

# Listing des images présentes 
img_list=$(cd "$DIR"/images && ls)

# Récuperation de la première et dernière image de la liste
current="$1"
first=$(echo $img_list | cut -f1 -d ' ')
for _last in $img_list; do true; done # !Hack!
last="$_last"

prev=$(echo "$img_list" | grep "$current" -B 1 | head -n 1)
prev=${prev%.*}

next=$(echo "$img_list" | grep "$current" -A 1 | tail -n 1)
next=${next%.*}

# Printing du header
html_head "$title" 
html_viewer_title "$title" 

# Affichage du code HTML
echo '<center>'
echo '<div class="imgframe">'
echo '<img class="image" src="'"$DIR/images/$1"'"><br>'
echo '<span class="legend">'"$legend"'</span>'
echo '</div>' 
echo '</center>'

# Affichage des menus de navigation
if ! [ "$current" = "$first" ]; then
    echo '<center><a href='"$DIR/viewers/$prev"'.html>Précédent</a>'
else 
    echo '<center><b>Précédent</b>'
fi
  
echo '<a href='"$index"' align="center">Index</a>'

if ! [ "$current" = "$last" ]; then
    echo '<a href='"$DIR/viewers/$next"'.html align="center">
Suivant</a></center>'
else
    echo '<b>Suivant</b></center>'
fi

# Balises de fin
html_tail

exit 0
