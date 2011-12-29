<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <xsl:param name="source"/>

  <xsl:template match="/">
    <carrot>
      <xsl:copy-of select="unparsed-text($source)"/>
    </carrot>
  </xsl:template>

</xsl:stylesheet>

