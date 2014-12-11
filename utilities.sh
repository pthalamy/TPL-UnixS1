html_head () {
    cat << EOF
	   <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
                     "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>
EOF
    printf "$1"
    cat << EOF 
    </title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style type="text/css">
      body {
      background-color: #b0e0e6;
      }

      .vgframe {
      height: 250px;
      width: 330px;
      float: left;
      background-color: white;
      border: dashed 1px #BBDDBB;
      margin: 1ex;
      padding: 1ex;
      text-align:center;
      }

      .imgframe {
      float: center;
      text-align:center;
      height: 800px;
      width: 1250px;
      }

      .image {
      margin: 1ex;
      float: center;
      border: solid 1px lightgrey;
      }

      .legend {
      font-style:italic;
      font-size:25px;
      background-color: white;
      border: 1px #BBDDBB;
      margin: 4px;
      padding: 1px;
      color: #002000;
      }

    </style>
    
  </head>
  <body>
EOF
}

html_title () {
    echo "<h1>$1</h1>
          <div>Cliquez sur une vignette voir l'image en taille réelle" \
	      " et afficher ses infos.</div>"
}

html_viewer_title () {
    echo '<h1 align="center">'"$1"'</h1>'
}

html_tail () {
    echo '
  <footer align="right">
  –– Guillaume Halb & Pierre Thalamy
  <footer>
  </body>
</html>'
}

# Prend un fichier jpg en argument et renvoi par un echo 
# la date exif de prise de vue de l'image si présente.
# Format: JJ/MM/AAAA
# Usage: exif_date BIN_dir jpg_image
#        BIN_DIR est le repertoire contenant l'executable exiftags
exif_date () {
    # On évite les msgs d'erreur inutiles de exiftags
    exec 2>/dev/null 
    
    date=$("$1"/exiftags "$2" \
	| grep "Image Created:" \
	| cut -f3 -d " ")
    year=$(echo $date | cut -f1 -d ":")
    month=$(echo $date | cut -f2 -d ":")
    day=$(echo $date | cut -f3 -d ":")

    echo "$day/$month/$year"
}

# Prend en argument un chemin relatif vers un fichier et retourne
# son chemin absolu.
# Usage: FileRelative2Absolute file
FileRelative2Absolute () {
    FILE_DIR=$(cd $(dirname "$1") && pwd) 
    FILE_BASE="$(basename "$1")"
    
    echo "$FILE_DIR"/"$FILE_BASE"
}
