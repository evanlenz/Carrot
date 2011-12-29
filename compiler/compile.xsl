<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:my="http://localhost"
  exclude-result-prefixes="xs out">

  <xsl:namespace-alias stylesheet-prefix="out" result-prefix="xsl"/>

  <xsl:template match="/Carrot/CarrotModule">
    <xsl:comment>
      <xsl:text>Auto-generated from the following Carrot source:&#xA;&#xA;</xsl:text>
      <xsl:value-of select="."/>
    </xsl:comment>
    <out:stylesheet version="2.0">
      <xsl:apply-templates select="VarDecl | FunctionDecl | RuleDecl"/>
      <xsl:apply-templates mode="auxiliary-defs" select="//DirElemConstructor"/> <!-- FIXME: complete this list -->
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

                  <xsl:template match="ParamWithDefault/ExprSingle
                                     | InitializedParam/ExprSingle">
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
    <xsl:variable name="xpath-expr">
      <xsl:apply-templates mode="xpath" select="Expr"/>
    </xsl:variable>
    <out:apply-templates select="{$xpath-expr}"> <!-- FIXME: handle arbitrary expressions -->
      <xsl:apply-templates select="ModeName,
                                   RulesetCallParamList/InitializedParam"/>
    </out:apply-templates>
  </xsl:template>

          <xsl:template mode="auxiliary-defs" match="text()"/>

          <xsl:template mode="auxiliary-defs" match="*">
            <out:function name="{generate-id(.)}" as="element()">
              <out:param name="context-item"/>
              <out:param name="context-position"/>
              <out:param name="context-size"/>
              <xsl:apply-templates select="."/>
            </out:function>
          </xsl:template>

          <xsl:template mode="xpath" match="*">
            <xsl:text>my:</xsl:text>
            <xsl:value-of select="generate-id(.)"/>
            <xsl:text>(., position(), last())</xsl:text>
          </xsl:template>

          <xsl:template match="InitializedParam">
            <out:with-param name="{Param/QName}">
              <xsl:apply-templates select="Tunnel, ExprSingle"/>
            </out:with-param>
          </xsl:template>


  <xsl:template match="TextNodeLiteral">
    <out:text>
      <xsl:value-of select="substring-before(substring-after(.,'`'),'`')"/>
    </out:text>
  </xsl:template>

  <xsl:function name="my:expr-id">
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
