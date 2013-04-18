<!-- This implements the whitespace-stripping rules defined here:

     http://www.w3.org/TR/xslt20/#stylesheet-stripping
-->
<!DOCTYPE xsl:stylesheet [
<!ENTITY WHITESPACE "text()[not(normalize-space())]">
]>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- 1. All comments and processing instructions are removed. -->
  <xsl:template match="comment() | processing-instruction()"/>


  <!-- 2. Any text nodes that are now adjacent to each other are merged.
          (nothing to do here) -->


  <!-- 3. Any whitespace text node that satisfies both the
          following conditions is removed from the tree:

            * The parent of the text node is not an xsl:text element
            * The text node does not have an ancestor element that has
              an xml:space attribute with a value of preserve, unless
              there is a closer ancestor element having an xml:space
              attribute with a value of default.
  -->
  <xsl:template match="&WHITESPACE;[not(parent::xsl:text)]
                                   [ancestor::*[@xml:space][1]/@xml:space eq 'default'
                             or not(ancestor::*/@xml:space)]"/>


  <!-- 4. Any whitespace text node whose parent is one of the following
          elements is removed from the tree, regardless of any xml:space attributes:
  -->
  <xsl:template priority="1"
                match="&WHITESPACE;[parent::xsl:analyze-string
                                 or parent::xsl:apply-imports
                                 or parent::xsl:apply-templates
                                 or parent::xsl:attribute-set
                                 or parent::xsl:call-template
                                 or parent::xsl:character-map
                                 or parent::xsl:choose
                                 or parent::xsl:next-match
                                 or parent::xsl:stylesheet
                                 or parent::xsl:transform]"/>


  <!-- Any whitespace text node whose following-sibling node is an xsl:param
       or xsl:sort element is removed from the tree, regardless of any xml:space attributes.
  -->
  <xsl:template priority="2"
                match="&WHITESPACE;[following-sibling::xsl:param
                                 or following-sibling::xsl:sort]"/>


  <!-- By default, copy everything through -->
  <xsl:template match="@* | * | text()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
