Transform -s:embed-carrot.xsl -xsl:embed-carrot.xsl -o:temp/carrot-embedded.xml source=$1
Query -q:parse.xqy +carrot-source=temp/carrot-embedded.xml
