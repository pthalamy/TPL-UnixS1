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
      background-color: #f1f6df;
      }

      .vgframe {
      float: left;
      background-color: white;
      border: dashed 1px #BBDDBB;
      margin: 1ex;
      padding: 1ex;
      text-align:center;
      }

      .imgframe {
      float: center;
      background-color: white;
      border: dashed 1px #BBDDBB;
      margin: 1ex;
      padding: 1ex;
      text-align:center;
      }

      .image {
      margin: 1ex;
      border: solid 1px lightgrey;
      }

      .legend {
      font-style:italic;
      color: #002000;
      }

    </style>
    
  </head>
  <body>
EOF
}

html_title () {
    echo "<h1>$1</h1>
          <div>Cliquez sur une vignette pour l'agrandir.</div>"
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
