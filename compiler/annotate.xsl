<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:c="http://evanlenz.net/carrot"
  xmlns="http://evanlenz.net/carrot"
  exclude-result-prefixes="xs c">

  <!-- ASSUMPTION: No attributes are in the input (and are hence ignored). -->

  <!-- By default, copy everything through -->
  <xsl:template mode="annotate
                      annotate-xpath
                      annotate-sequence-constructor" match="node()">
    <xsl:copy>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!-- Assume sequence constructor mode for function and rule bodies -->
  <xsl:template mode="annotate" match="FunctionDecl/Expr
                                     | RuleDecl/Expr">
    <xsl:apply-templates mode="annotate-sequence-constructor" select="."/>
  </xsl:template>

  <!-- Assume XPath mode for patterns -->
  <xsl:template mode="annotate" match="RuleDecl/Pattern">
    <xsl:apply-templates mode="annotate-xpath" select="."/>
  </xsl:template>

  <!-- By default, choose XPATH (@select attribute) for xsl:variable/xsl:param -->
  <xsl:template mode="annotate" priority=".49" match="VarDecl/Expr
                                                    | ParamWithDefault/ExprSingle
                                                    | InitializedParam/ExprSingle">
    <XPATH>
      <xsl:apply-templates mode="annotate-xpath" select="."/>
    </XPATH>
  </xsl:template>


  <!-- Switch to sequence constructor mode -->
  <!-- NOTE: nice mode/pattern tuple use case -->
  <xsl:template mode="annotate
                      annotate-xpath" match=" (:annotate:)
                                              VarDecl/Expr               [*[c:requires-sequence-constructor(.)]]
                                            | ParamWithDefault/ExprSingle[*[c:requires-sequence-constructor(.)]]
                                            | InitializedParam/ExprSingle[*[c:requires-sequence-constructor(.)]]
 
                                              (:annotate-xpath:)
                                            | *[c:requires-sequence-constructor(.)]
                                            ">
    <SEQUENCE_CONSTRUCTOR>
      <xsl:if test="not(parent::VarDecl | parent::ParamWithDefault | parent::InitializedParam)">
        <xsl:attribute name="needs-helper" select="'yes'"/>
      </xsl:if>
      <xsl:apply-templates mode="annotate-sequence-constructor" select="."/>
    </SEQUENCE_CONSTRUCTOR>
  </xsl:template>

          <xsl:function name="c:requires-sequence-constructor">
            <xsl:param name="carrot-expr"/>
            <xsl:apply-templates mode="requires-sequence-constructor" select="$carrot-expr"/>
          </xsl:function>

          <xsl:template mode="requires-sequence-constructor" match="*"/>
          <xsl:template mode="requires-sequence-constructor" match=" TypeswitchExpr
                                                                   | ValidateExpr
                                                                   | ExtensionExpr
                                                                   | OrderedExpr
                                                                   | UnorderedExpr
                                                                   | Constructor
                                                                   | QuantifiedExpr[TypeDeclaration]
                                                                   | RulesetCall
                                                                   | TextNodeLiteral
                                                                   | FLWORExpr[ LetClause
                                                                              | WhereClause
                                                                              | OrderByClause
                                                                              | ForClause/ForBinding/TypeDeclaration
                                                                              | ForClause/ForBinding/PositionalVar
                                                                              ]">
            <xsl:sequence select="true()"/>
          </xsl:template>

</xsl:stylesheet>
