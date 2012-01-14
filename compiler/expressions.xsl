<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <!-- Convert a parsed Carrot expression to XPath -->
  <xsl:function name="c:xpath">
    <xsl:param name="carrot-expr"/>
    <xsl:apply-templates mode="xpath" select="$carrot-expr"/>
  </xsl:function>

  <!-- Convert a parsed Carrot expression to an XSLT sequence constructor -->
  <!--
  <xsl:template mode="sequence-constructor" match="*">
    <out:sequence select="{c:xpath(.)}"/>
  </xsl:template>
  -->

  <xsl:template match="FunctionCall">
    <out:sequence select="{c:xpath(.)}"/>
  </xsl:template>


  <xsl:template match="DirElemConstructor">
    <xsl:element name="{QName[1]}"> <!-- Any reason to use out:element instead of LREs? -->
      <xsl:apply-templates select="DirAttributeList/QName,
                                   DirElemContent"/>
    </xsl:element>
  </xsl:template>

          <xsl:template match="DirAttributeList/QName">
            <!-- Variable definition is a workaround for XSLTBUG 15227 -->
            <xsl:variable name="att-value">
              <xsl:apply-templates select="following-sibling::DirAttributeValue[1]"/>
            </xsl:variable>
            <xsl:attribute name="{.}">
              <xsl:value-of select="$att-value"/>
            </xsl:attribute>
          </xsl:template>

          <xsl:template match="DirAttributeValue">
            <!-- FIXME: handle enclosed arbitrary expressions -->
            <xsl:apply-templates select="node() except TOKEN"/> <!-- exclude the delimiters -->
          </xsl:template>

          <xsl:template match="DirElemContent/CommonContent/EnclosedExpr">
            <xsl:apply-templates select="node() except TOKEN"/> <!-- exclude the delimiters -->
          </xsl:template>


  <xsl:template match="RulesetCall">
    <out:apply-templates select="{c:xpath(Expr)}">
      <xsl:apply-templates select="ModeName,
                                   RulesetCallParamList/InitializedParam"/>
    </out:apply-templates>
  </xsl:template>

          <xsl:template match="InitializedParam">
            <out:with-param name="{Param/QName}">
              <xsl:apply-templates select="Tunnel"/>
              <xsl:apply-templates mode="variable-value" select="c:*"/>
            </out:with-param>
          </xsl:template>


  <xsl:template match="TextNodeLiteral">
    <out:text>
      <xsl:value-of select="substring-before(substring-after(.,'`'),'`')"/>
    </out:text>
  </xsl:template>

  <xsl:function name="c:expr-id">
    <xsl:param name="expr-node" as="element()"/>
    <xsl:apply-templates mode="expr-id-prefix" select="$expr-node"/>
  </xsl:function>

          <xsl:template mode="expr-id-prefix" match="DirElemConstructor">
          </xsl:template>


  <xsl:template match="Expr/TOKEN"/> <!-- strip out commas in sequence constructor mode -->

  <xsl:template match="ExprSingle">
    <xsl:variable name="xpath">
      <xsl:apply-templates mode="xpath" select="."/>
    </xsl:variable>
    <out:sequence select="{$xpath}"/>
  </xsl:template>

</xsl:stylesheet>
