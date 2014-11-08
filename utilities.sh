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

.imgframe {
    float: left;
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
    echo "<h1>$1</h1>"
}

html_tail () {
    echo "</body>"
    echo "</html>"
}
