#!/bin/bash
if [ -n "$1" ]; then 
  ./run-carrot.sh ../tests/$1/test.crt ../tests/$1/test.xml
  xmllint --format temp/compiled-carrot.xsl >temp/compiled-carrotPRETTY.xsl
  xmllint --format temp/parsed-carrot.xml   >temp/parsed-carrotPRETTY.xml
else
  echo "USAGE: You must specify the test directory, e.g.: ./test.sh 001"
fi
