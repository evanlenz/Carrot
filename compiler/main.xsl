<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <xsl:import href="declarations.xsl"/>
  <xsl:import href="expressions.xsl"/>

  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl"/>

  <xsl:template match="/Carrot/CarrotModule">
    <xsl:comment>
      <xsl:text>Auto-generated from the following Carrot source:&#xA;&#xA;</xsl:text>
      <xsl:value-of select="."/>
    </xsl:comment>
    <out:stylesheet version="2.0">
      <xsl:apply-templates select="NamespaceDecl, VarDecl | FunctionDecl | RuleDecl"/>
      <xsl:apply-templates mode="auxiliary-defs" select="//DirElemConstructor"/> <!-- FIXME: complete this list -->
    </out:stylesheet>
  </xsl:template>

</xsl:stylesheet>
