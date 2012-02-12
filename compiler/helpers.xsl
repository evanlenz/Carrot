<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:out="dummy"
  xmlns:c="http://evanlenz.net/carrot"
  exclude-result-prefixes="out c">

  <xsl:template mode="helper" match="text()"/>

  <!-- Delegate non-XPath expressions to stylesheet helper functions -->
  <xsl:template mode="helper" match="c:SEQUENCE_CONSTRUCTOR[@needs-helper]">
    <out:function name="{c:helper-name(.)}">
      <xsl:apply-templates mode="helper-param" select="c:helper-params(.)"/>
      <xsl:apply-templates select="."/>
    </out:function>
    <!-- Check for sub-expressions that also require help -->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

          <xsl:template mode="helper-param" match="component">
            <out:param name="{@name}"/>
          </xsl:template>

          <xsl:function name="c:helper-params">
            <xsl:param name="carrot-expr"/>
            <xsl:apply-templates mode="helper-params" select="$carrot-expr"/>
          </xsl:function>

                  <xsl:template mode="helper-params" match="*">
                    <component name="context-item"     translate="."/>
                    <component name="context-position" translate="position()"/>
                    <component name="context-size"     translate="last()"/>
                    <component name="current-item"     translate="current()"/>
                    <!-- Not currently supported by Carrot
                    <component name="current-grouping-key"/>
                    <component name="current-group"/>
                    <component name="regex-group"/>
                    -->
                  </xsl:template>


  <!-- Call the helper function from within XPath -->
  <xsl:template mode="xpath" match="c:SEQUENCE_CONSTRUCTOR">
    <!-- hack to make sure the tokens are separated -->
    <xsl:text> </xsl:text>
    <xsl:value-of select="c:helper-name(.)"/>
    <xsl:text>(</xsl:text>
    <!-- Pass in all the necessary dynamic context -->
    <!-- TODO: address static context components... -->
    <xsl:apply-templates mode="helper-arg" select="c:helper-params(.)"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

          <xsl:template mode="helper-arg" match="component">
            <xsl:value-of select="@translate"/>
            <xsl:if test="position() ne last()">,</xsl:if>
          </xsl:template>


  <!-- Can the given expression not be represented in XPath? -->
  <!--
  <xsl:function name="c:requires-sequence-constructor">
    <xsl:param name="carrot-expr"/>
    <xsl:apply-templates mode="requires-sequence-constructor" select="$carrot-expr"/>
    <!- -
    <xsl:variable name="sequence-constructor" as="item()*">
      <xsl:apply-templates mode="sequence-constructor" select="$carrot-expr">
        <xsl:with-param name="just-checking" select="'yes'"/>
      </xsl:apply-templates>
    </xsl:variable>
    <!- - If the sequence constructor for this expression is just the default (<out:sequence>),
         then it doesn't need help. It can be expressed in XPath alone. - ->
    <xsl:sequence select="$sequence-constructor = ''"/>
    - ->
  </xsl:function>
  -->


  <!-- Generate a name for the helper function -->
  <xsl:function name="c:helper-name">
    <xsl:param name="carrot-expr"/>
    <xsl:apply-templates mode="helper-name" select="$carrot-expr"/>
  </xsl:function>

          <!-- TODO: Use more friendly names -->
          <xsl:template mode="helper-name" match="*">
            <!-- TODO: Check for available/unused namespace prefixes to avoid conflicts -->
            <xsl:text>helper:</xsl:text>
            <xsl:value-of select="generate-id(.)"/>
          </xsl:template>

</xsl:stylesheet>
