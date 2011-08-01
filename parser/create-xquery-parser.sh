xsltproc bnf-parser.xsl xquery-grammar.bnf >xquery-grammar.xml
xsltproc eliminator.xsl xquery-grammar.xml >xquery-grammar-fixed.xml
xsltproc generator.xsl xquery-grammar-fixed.xml >xquery-parser.xsl
xsltproc tokenizer.xsl xquery-grammar-fixed.xml >xquery-lexer.xsl
