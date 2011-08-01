xsltproc yapp-xslt/bnf-parser.xsl xquery-grammar.bnf >xquery-grammar.xml
xsltproc yapp-xslt/eliminator.xsl xquery-grammar.xml >xquery-grammar-fixed.xml
xsltproc yapp-xslt/generator.xsl xquery-grammar-fixed.xml >xquery-parser.xsl
xsltproc yapp-xslt/tokenizer.xsl xquery-grammar-fixed.xml >xquery-lexer.xsl
