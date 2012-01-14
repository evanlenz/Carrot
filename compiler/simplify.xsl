<!-- This stylesheet simplifies the parsed input by removing
     intermediate elements in the hierarchy that don't
     particularly help with implementing the compiler.
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <!-- ASSUMPTION: No attributes are in the input (and are hence ignored). -->

  <xsl:template mode="simplify" match="node()">
    <xsl:copy>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always contains just one child (choice group), or doesn't
       add any useful information (RelativePathExpr) -->
  <!-- The compiler should never reference these elements;
       they'll always be absent after this. -->
  <xsl:template mode="simplify"
                match="Expr/ExprSingle
                     | ValueExpr
                     | PrimaryExpr
                     | Literal
                     | StepExpr
                     | RelativePathExpr">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <!-- If only one child, then it's a useless container -->
  <!-- If the compiler comes across one of these elements, it
       means the element contains more than one child, which
       means it actually is what it says it is, e.g. "$x or $y"
       would be annotated as an <OrExpr> but not "'hello'" (even
       though it technically is an OrExpr the way grammar is defined.)
  -->
  <xsl:template mode="simplify"
                match="*[count(*) eq 1]
                        [not(TOKEN)]
                        [local-name() = ( 'OrExpr'
                                        , 'AndExpr'
                                        , 'ComparisonExpr'
                                        , 'RangeExpr'
                                        , 'AdditiveExpr'
                                        , 'MultiplicativeExpr'
                                        , 'UnionExpr'
                                        , 'IntersectExceptExpr'
                                        , 'InstanceofExpr'
                                        , 'TreatExpr'
                                        , 'CastableExpr'
                                        , 'CastExpr'
                                        , 'UnaryExpr'
                                        , 'PathExpr'
                                        )]">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <!-- Strip out <FilterExpr> except when there's an actual filter (predicate) -->
  <xsl:template mode="simplify" match="FilterExpr[not(PredicateList/Predicate)]">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>


  <!-- Strip out empty elements (such as <PredicateList>) -->
  <xsl:template mode="simplify" match="*[not(node())]"/>

</xsl:stylesheet>
