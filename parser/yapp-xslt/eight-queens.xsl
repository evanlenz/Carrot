<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template match="/">
    
    <html>
      <head>
        <title>Eight Queens</title>
      </head>
      
      <body>
        <h3>Eight Queens</h3>
        
        <xsl:apply-templates select="program/solution"/>

        <p><a href="javascript:location.reload()" target="_self">generate a new solution</a></p>
        <p><a href="/examples">back to examples</a></p>        
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="solution">
    <table cellspacing="0" cellpadding="0" border="1">
      <xsl:apply-templates select="queen">
        <xsl:sort select="row" data-type="number" order="descending"/>
      </xsl:apply-templates>
    </table>
  </xsl:template>
  
  <xsl:template match="queen">
    <xsl:variable name="queen" select="."/>
    <tr>
      <xsl:for-each select="../queen"><!-- there are eight of them -->
        <td>
          <xsl:choose>
            <xsl:when test="$queen/column = position()">
              <img src="images/queen.png"/>
            </xsl:when>
            <xsl:when test="$queen/row mod 2 = position() mod 2">
              <img src="images/black.png"/>
            </xsl:when>
            <xsl:otherwise>
              <img src="images/white.png"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:for-each>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
