xalan-home = ~/xalan-j_2_7_0

xalan = java -jar $(xalan-home)/xalan.jar -XSLTC

test: xpath
	$(xalan) -XSL xpath-parser.xsl -IN eight-queens.xsl

bnf: bnf-parser.xsl bnf-lexer.xsl

bnf-parser.xsl: generator.xsl bnf-grammar.xml
	$(xalan) -XSL generator.xsl -IN bnf-grammar.xml -OUT bnf-parser.xsl

bnf-lexer.xsl: tokenizer.xsl bnf-grammar.xml
	$(xalan) -XSL tokenizer.xsl -IN bnf-grammar.xml -OUT bnf-lexer.xsl


xpath: xpath-parser.xsl xpath-lexer.xsl

xpath-grammar.xml: xpath-grammar.bnf bnf
	$(xalan) -XSL bnf-parser.xsl -IN xpath-grammar.bnf -OUT xpath-grammar.xml

fixed-xpath-grammar.xml: xpath-grammar.xml eliminator.xsl
	$(xalan) -XSL eliminator.xsl -IN xpath-grammar.xml -OUT fixed-xpath-grammar.xml

xpath-parser.xsl: fixed-xpath-grammar.xml
	$(xalan) -XSL generator.xsl -IN fixed-xpath-grammar.xml -OUT xpath-parser.xsl

xpath-lexer.xsl: fixed-xpath-grammar.xml
	$(xalan) -XSL tokenizer.xsl -IN fixed-xpath-grammar.xml -OUT xpath-lexer.xsl

clean:
	rm -f bnf-lexer.xsl bnf-parser.xsl fixed-xpath-grammar.xml xpath-grammar.xml xpath-lexer.xsl xpath-parser.xsl