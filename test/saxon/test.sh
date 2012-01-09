./run-carrot.sh ../01/test.crt ../01/test.xml
xmllint --format temp/compiled-carrot.xsl >temp/compiled-carrotPRETTY.xsl
xmllint --format temp/parsed-carrot.xml   >temp/parsed-carrotPRETTY.xml
