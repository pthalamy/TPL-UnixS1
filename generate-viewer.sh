#! /bin/sh

DIR=$(cd "$(dirname "$0")" && pwd)
DEST=$(cd "$1" && pwd)
. "$DIR"/utilities.sh

title="Image Viewer"
index="$3"
legend=""

usage () {
    cat <<EOF
Utilisation: generate-viewer.sh dest image index
EOF
}

# Listing des images présentes 
img_list=$(cd "$DEST"/images && ls)

# Récuperation de la première et dernière image de la liste
current=$(basename "$2") 
first=$(echo $img_list | cut -f1 -d ' ')
for _last in $img_list; do true; done # !Hack!
last="$_last"

prev=$(echo "$img_list" | grep "$current" -B 1 | head -n 1)
prev=${prev%.*}

next=$(echo "$img_list" | grep "$current" -A 1 | tail -n 1)
next=${next%.*}

# Formatage de la date pour la légende
date=$(exif_date "$DIR" "$DEST/images/$current") 

if ! [ "$date" = "//"  ]; then
    legend="$(basename "$current" .jpg) – $date"
else
    legend="$(basename "$current" .jpg)"
fi

# Printing du header
html_head "$title" 
html_viewer_title "$title" 

# Affichage du code HTML
echo '<center>'
echo '<div class="imgframe">'
echo '<img class="image" src="'$(FileRelative2Absolute "$2")'"><br>'
echo '<span class="legend">'"$legend"'</span>'
echo '</div>' 
echo '</center>'

# Affichage des menus de navigation
if ! [ "$current" = "$first" ]; then
    echo '<center><a href='"$DEST/viewers/$prev"'.html>Précédent</a>'
else 
    echo '<center><b>Précédent</b>'
fi
  
echo '<a href='"$index"'>Index</a>'

if ! [ "$current" = "$last" ]; then
    echo '<a href='"$DEST/viewers/$next"'.html>
Suivant</a></center>'
else
    echo '<b>Suivant</b></center>'
fi

# Balises de fin
html_tail

exit 0
