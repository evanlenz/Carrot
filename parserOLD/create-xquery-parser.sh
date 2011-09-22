# For debugging purposes only; keep the last results around
cp xquery-grammar.xml xquery-grammar_PREVIOUS.xml
cp xquery-grammar_PRETTY.xml xquery-grammar_PRETTY_PREVIOUS.xml

cp xquery-grammar-fixed.xml xquery-grammar-fixed_PREVIOUS.xml
cp xquery-grammar-fixed_PRETTY.xml xquery-grammar-fixed_PRETTY_PREVIOUS.xml

cp xquery-parser.xsl xquery-parser_PREVIOUS.xsl

cp xquery-lexer.xsl xquery-lexer_PREVIOUS.xsl

# This is the important part
xsltproc yapp-xslt/bnf-parser.xsl xquery-grammar.bnf >xquery-grammar.xml
xsltproc yapp-xslt/eliminator.xsl xquery-grammar.xml >xquery-grammar-fixed.xml
xsltproc yapp-xslt/generator.xsl xquery-grammar-fixed.xml >xquery-parser.xsl
xsltproc yapp-xslt/tokenizer.xsl xquery-grammar-fixed.xml >xquery-lexer.xsl

# For debugging purposes only; make readable versions
xmllint --format xquery-grammar.xml >xquery-grammar_PRETTY.xml
xmllint --format xquery-grammar-fixed.xml >xquery-grammar-fixed_PRETTY.xml

# Output the changes (also for debugging)
diff xquery-grammar_PRETTY_PREVIOUS.xml       xquery-grammar_PRETTY.xml       >xquery-grammarDIFFS.txt
diff xquery-grammar-fixed_PRETTY_PREVIOUS.xml xquery-grammar-fixed_PRETTY.xml >xquery-grammar-fixedDIFFS.txt
diff xquery-parser_PREVIOUS.xsl               xquery-parser.xsl               >xquery-parserDIFFS.txt
diff xquery-lexer_PREVIOUS.xsl                xquery-lexer.xsl                >xquery-lexerDIFFS.txt
