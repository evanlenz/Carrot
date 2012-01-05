mkdir -p temp

echo "Parsing Carrot program..."
./parse.sh   $1                     >temp/parsed-carrot.xml

echo "Compiling Carrot program..."
./compile.sh temp/parsed-carrot.xml >temp/compiled-carrot.xsl

echo "Running Carrot program..."
Transform -s:$2 -xsl:temp/compiled-carrot.xsl
