
Thank you for downloading YAPP XSLT!
------------------------------------

YAPP XSLT is published under the GNU General Public Licence
(see http://www.gnu.org/licenses/licenses.html#GPL).

A copy of the licence agreement (gpl.txt) must be part of any 
redistribution of any form.

YAPP XSLT was created by Martin Klang <mars@pingdynasty.com>.

For detailed usage instructions and more information about YAPP XSLT please see:
http://www.o-xml.org/yapp/


Quick Instructions
------------------

You can use the Makefile (first edit the location of your Xalan installation) and 
run a test with ->

make test

Or you can use Xalan directly to run YAPP tools as follows:

generate parser ->

xalan -XSL generator.xsl -IN grammar.xml > parser.xsl


generate lexer ->

xalan -XSL tokenizer.xsl -IN grammar.xml > lexer.xsl


calling the parser ->

 <xsl:call-template name="p:NameOfProduction"
   xmlns:p="http://www.pingdynasty.com/namespaces/parser">
   <xsl:with-param name="in" select="'text to be parsed'"/>
 </xsl:call-template>


run the left-recursion eliminator ->

xalan -XSL eliminator.xsl -IN grammar.xml > fixed-grammar.xml


create the BNF parser and lexer ->

xalan -XSL generator.xsl -IN bnf-grammar.xml > bnf-parser.xsl
xalan -XSL tokenizer.xsl -IN bnf-grammar.xml > bnf-lexer.xsl


parse a BNF grammar (example included) ->

xalan -XSL bnf-parser.xsl -IN xpath-grammar.bnf > xpath-grammar.xml
