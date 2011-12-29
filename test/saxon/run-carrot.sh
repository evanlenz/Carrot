mkdir -p temp
./parse.sh   $1                     >temp/parsed-carrot.xml
./compile.sh temp/parsed-carrot.xml >temp/compiled-carrot.xsl
Transform -s:$2 -xsl:temp/compiled-carrot.xsl
