<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  exclude-result-prefixes="out">

  <xsl:include href="simplify.xsl"/>
  <xsl:include href="annotate.xsl"/>
  <xsl:include href="definitions.xsl"/>
  <xsl:include href="expressions.xsl"/>
  <xsl:include href="helpers.xsl"/>
  <xsl:include href="output-format.xsl"/>

  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl"/>

  <xsl:param name="DEBUG"/>

  <xsl:variable name="simplified">
    <xsl:apply-templates mode="simplify" select="/"/>
  </xsl:variable>
  <xsl:variable name="annotated">
    <xsl:apply-templates mode="annotate" select="$simplified"/>
  </xsl:variable>
  <xsl:variable name="compiled">
    <xsl:apply-templates select="$annotated/*"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$DEBUG">
        <result>
          <ORIGINAL>
            <xsl:copy-of select="."/>
          </ORIGINAL>
          <SIMPLIFIED>
            <xsl:copy-of select="$simplified"/>
          </SIMPLIFIED>
          <ANNOTATED>
            <xsl:copy-of select="$annotated"/>
          </ANNOTATED>
          <COMPILED>
            <xsl:copy-of select="$compiled"/>
          </COMPILED>
        </result>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$compiled"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/Carrot/CarrotModule">
    <xsl:comment>
      <xsl:text>Auto-generated from the following Carrot source:&#xA;&#xA;</xsl:text>
      <xsl:value-of select="."/>
    </xsl:comment>
    <out:stylesheet version="2.0" xmlns:helper="http://evanlenz.net/carrot/helper">
      <xsl:apply-templates select="NamespaceDecl"/>
      <xsl:apply-templates select="VarDecl | FunctionDecl | RuleDecl"/>
      <xsl:apply-templates mode="helper" select="."/>
    </out:stylesheet>
  </xsl:template>

</xsl:stylesheet>
