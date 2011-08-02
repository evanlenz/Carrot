<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <xsl:include href="xquery-parser.xsl"/>

  <!-- TODO: Figure out why this one doesn't work (especially the "every" expression at the end
  <xsl:variable name="expr">for $x as empty-sequence() at $i in "string", $y as node()+ at $j in "bat" where "true" order by "foo" ascending empty greatest collation "http:foobar.com" return let $foo := "bar", $bar := "bang" return <!- -some $asdf in "bat" satisfies- -> <!- -some $asdf in- -> every $dummy in "blah" satisfies "true"</xsl:variable>
  -->
  <xsl:variable name="expr">for $foo in "bar", $bar in "bang", $baz in "blah" return some $blah in "bat" satisfies "true"</xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="p:Expr" xmlns:p="http://www.pingdynasty.com/namespaces/parser">
      <xsl:with-param name="in" select="string($expr)"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>

