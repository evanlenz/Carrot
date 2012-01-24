<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <!-- Convert a parsed Carrot expression to XPath -->
  <xsl:function name="c:xpath" as="xs:string">
    <xsl:param name="carrot-expr"/>
    <xsl:variable name="xpath" as="xs:string">
      <xsl:value-of>
        <xsl:apply-templates mode="xpath" select="$carrot-expr"/>
      </xsl:value-of>
    </xsl:variable>
    <!-- Attribute values are normalized, losing potentially useful whitespace in the Carrot source.
         Ultimately, consider using (and first building) a framework that has tighter lexical control
         over the XML text that's output. -->
    <xsl:sequence select="normalize-space($xpath)"/>
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
    <out:sequence select="{c:xpath(.)}"/>
  </xsl:template>

  <xsl:template match="FLWORExpr[not(OrderByClause) or c:has-simple-orderby(.)]">
    <xsl:apply-templates mode="flwor" select="*[1]"/>
  </xsl:template>

          <!-- This may be overly restrictive, but better safe than sorry. -->
          <!-- We'll only try to translate an OrderBy into <xsl:sort> if each of its order specs
               refers only to the last-defined variable (bound by "for"). Otherwise, we punt and
               defer to the more complicated translation (TBD).
          -->
          <xsl:function name="c:has-simple-orderby" as="xs:boolean">
            <xsl:param name="flwor"/>
            <xsl:variable name="orderby" select="$flwor/OrderByClause"/>
            <xsl:sequence select="every $spec in $orderby/OrderSpecList/OrderSpec satisfies
                                  (count($spec//VarRef) eq 1 and
                                   $spec//VarRef/VarName eq $orderby/preceding-sibling::ForClause[1]/ForBinding[last()]/VarName
                                  )"/>
          </xsl:function>
  

          <xsl:template mode="flwor" match="LetClause">
            <xsl:apply-templates mode="#current" select="LetBinding"/>

            <!-- This isn't right yet. -->
            <xsl:apply-templates mode="flwor" select="following-sibling::*[self::LetClause|self::ForClause][1]"/>
          </xsl:template>

                  <xsl:template mode="flwor" match="LetBinding">
                    <out:variable name="..."/>
                  </xsl:template>


          <xsl:template mode="flwor" match="ForClause">
            <xsl:apply-templates mode="flwor" select="ForBinding[1]"/>
          </xsl:template>

                  <xsl:template mode="flwor" match="ForBinding">
                    <out:for-each select="{c:xpath(ExprSingle)}">
                      <!-- Consider making this more idiomatic by only binding a variable when necessary
                           (replacing variable references with "." when possible). -->
                      <out:variable name="{VarName}" select=".">
                        <xsl:apply-templates select="TypeDeclaration"/>
                      </out:variable>
                      <xsl:apply-templates select="PositionalVar"/>
                      <xsl:apply-templates mode="for-each-content" select="."/>
                    </out:for-each>
                  </xsl:template>

                          <xsl:template mode="for-each-content" match="ForBinding">
                            <xsl:apply-templates mode="flwor" select="following-sibling::ForBinding[1]"/>
                          </xsl:template>

                          <xsl:template mode="for-each-content" match="ForBinding[last()]">
                            <!-- This isn't right yet. -->
                            <xsl:apply-templates mode="flwor"
                                                 select="../following-sibling::*[self::LetClause|self::ForClause][1]"/>
                          </xsl:template>

  <!-- For OrderBy, we may need to use <xsl:perform-sort/> -->


                          <xsl:template match="PositionalVar">
                            <out:variable name="{VarName}" select="position()"/>
                          </xsl:template>

</xsl:stylesheet>
