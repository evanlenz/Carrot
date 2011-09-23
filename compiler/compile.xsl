<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  exclude-result-prefixes="xs out">

  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl"/>

  <xsl:template match="/Carrot/CarrotModule">
    <out:stylesheet version="2.0">
      <xsl:apply-templates select="VarDecl | FunctionDecl | RuleDecl"/>
    </out:stylesheet>
  </xsl:template>

  <xsl:template match="RuleDecl">
    <out:template match="{Pattern}"> <!-- FIXME: How will we handle nested arbitrary expressions in the pattern? -->
      <xsl:apply-templates select="ModeName[1],
                                   (IntegerLiteral | DecimalLiteral),
                                   RuleParamList/ParamWithDefault,
                                   Expr"/>
    </out:template>
  </xsl:template>

          <xsl:template match="ModeName[1]">
            <xsl:attribute name="mode">
              <xsl:value-of select="."/>
              <xsl:apply-templates select="following-sibling::ModeName"/>
            </xsl:attribute>
          </xsl:template>

          <xsl:template match="ModeName">
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
          </xsl:template>

  
          <xsl:template match="RuleDecl/IntegerLiteral
                             | RuleDecl/DecimalLiteral">
            <xsl:attribute name="priority" select="."/>
          </xsl:template>


          <xsl:template match="ParamWithDefault">
            <out:param name="{Param/QName}">
              <xsl:apply-templates select="Tunnel, ExprSingle"/>
            </out:param>
          </xsl:template>

                  <xsl:template match="Tunnel">
                    <xsl:attribute name="tunnel" select="'yes'"/>
                  </xsl:template>

                  <xsl:template match="ParamWithDefault/ExprSingle">
                    <xsl:attribute name="select"> <!-- FIXME: this doesn't support arbitrary expressions yet -->
                      <xsl:value-of select="."/>
                    </xsl:attribute>
                  </xsl:template>


  <xsl:template match="DirElemConstructor">
    <xsl:element name="{QName[1]}"> <!-- Any reason to use out:element instead of LREs? -->
      <xsl:apply-templates select="DirAttributeList/QName,
                                   DirElemContent"/>
    </xsl:element>
  </xsl:template>

          <xsl:template match="DirAttributeList/QName">
            <xsl:attribute name="{.}">
              <xsl:apply-templates select="following-sibling::DirAttributeValue[1]"/>
            </xsl:attribute>
          </xsl:template>

          <xsl:template match="DirAttributeValue">
            <xsl:apply-templates select="node() except TOKEN"/> <!-- FIXME: handle enclosed arbitrary expressions -->
          </xsl:template>

</xsl:stylesheet>
