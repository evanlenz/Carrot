<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <xsl:template match="NamespaceDecl">
    <xsl:namespace name="{NCName/NCName}" select="URILiteral/substring(., 2, string-length(.) - 2)"/>
  </xsl:template>


  <xsl:template match="VarDecl">
    <out:variable name="{QName}">
      <xsl:apply-templates select="TypeDeclaration"/>
      <xsl:apply-templates mode="xpath-or-sequence-constructor" select="Expr"/>
    </out:variable>
  </xsl:template>

        <xsl:template match="TypeDeclaration"> 
          <xsl:attribute name="as" select="string(SequenceType)"/>
        </xsl:template>


  <xsl:template match="FunctionDecl">
    <out:function name="{FunctionName/QName}">
      <xsl:apply-templates select="TypeDeclaration"/>
      <xsl:apply-templates mode="sequence-constructor" select="Expr"/>
    </out:function>
  </xsl:template>

          <xsl:template match="ParamList/Param">
            <out:param name="{QName}">
              <xsl:apply-templates select="TypeDeclaration"/>
            </out:param>
          </xsl:template>


  <xsl:template match="RuleDecl">
    <out:template match="{c:xpath(Pattern)}">
      <xsl:apply-templates select="ModeName[1],
                                   (IntegerLiteral | DecimalLiteral),
                                   RuleParamList/ParamWithDefault"/>
      <xsl:apply-templates mode="sequence-constructor" select="Expr"/>
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
              <xsl:apply-templates select="Tunnel"/>
              <xsl:apply-templates mode="xpath-or-sequence-constructor" select="ExprSingle"/>
            </out:param>
          </xsl:template>

                  <xsl:template match="Tunnel">
                    <xsl:attribute name="tunnel" select="'yes'"/>
                  </xsl:template>

                  <xsl:template match="ParamWithDefault/ExprSingle
                                     | InitializedParam/ExprSingle">
                    <xsl:attribute name="select" select="c:xpath(.)"/>
                  </xsl:template>

</xsl:stylesheet>
