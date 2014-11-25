#! /bin/sh

DIR=$(cd "$(dirname "$0")" && pwd)
. "$DIR"/utilities.sh

title="Image Viewer"

usage () {
    cat <<EOF
Utilisation: generate-viewer.sh image
EOF
}

# Printing du header
html_head "$title" 
html_viewer_title "$title" 

# Affichage de l'image
echo '<center>'
echo '<div class="imgframe">'
echo '<img class="image" src="'"$1"'"><br>'
echo '</div>' 
echo '</center>'

# Affichage des menus de navigation
echo '<a href="$1" align="left">link text</a>

# Balises de fin
html_tail

exit 0
