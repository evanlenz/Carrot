<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <xsl:include href="xquery-parser.xsl"/>

  <xsl:template match="/">
    <xsl:call-template name="p:Expr" xmlns:p="http://www.pingdynasty.com/namespaces/parser">
      <xsl:with-param name="in" select="'for $foo'"/><!--for let where stable order by for return orderModifier return for let where order by for return orderModifier return'"/>-->
      <!--
      <xsl:with-param name="in" select="'for let where order by for return return for let where stable order by let where return return'"/>
      -->
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>

