<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <xsl:include href="simplify.xsl"/>
  <xsl:include href="annotate.xsl"/>
  <xsl:include href="declarations.xsl"/>
  <xsl:include href="expressions.xsl"/>
  <xsl:include href="helpers.xsl"/>

  <!-- TODO: Replace this with a more sophisticated indentation algorithm?
             Ensure the indentation doesn't change the meaning of the program,
             e.g., by adding whitespace to <xsl:text> or other places where
             space is preserved (due to xml:space="preserve" in the stylesheet). -->
  <xsl:output indent="yes"/>

  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl"/>

  <!--
  <xsl:strip-space elements="*"/>

  <xsl:template match="TOKEN">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>
  -->

  <xsl:param name="DEBUG"/>

  <xsl:template match="/">
    <xsl:variable name="simplified">
      <xsl:apply-templates mode="simplify" select="."/>
    </xsl:variable>
    <xsl:variable name="annotated">
      <xsl:apply-templates mode="annotate" select="$simplified"/>
    </xsl:variable>
    <xsl:variable name="compiled">
      <xsl:apply-templates select="$annotated/*"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$DEBUG">
        <result>
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

          <xsl:template mode="helper" match="text()"/>

</xsl:stylesheet>
