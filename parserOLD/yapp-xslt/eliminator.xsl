<?xml version="1.0"?>
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
 |                                                                           |
 | YAPP XSLT is published under the GNU General Public Licence               |
 |   (see http://www.gnu.org/licenses/licenses.html#GPL).                    |
 |                                                                           |
 | A copy of the licence agreement (gpl.txt) must be part of any             |
 |   redistribution of any form.                                             |
 |                                                                           |
 | YAPP XSLT was created by Martin Klang <mars@pingdynasty.com>.             |
 |                                                                           |
 | For usage instructions and more information about YAPP XSLT please see:   |
 |   http://www.o-xml.org/yapp/                                              |
 |                                                                           |
 +- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="construct[option/part[1]/@name = current()/@name]">
    <!-- construct with left-recursive option -->
    <construct name="{@name}">
      <xsl:for-each select="option[part[1]/@name != current()/@name]">
        <option>
          <xsl:apply-templates select="part"/>
          <part name="{../@name}-rest"/>
        </option>
      </xsl:for-each>
    </construct>
    <!-- create right-recursive rest construct -->
    <construct name="{@name}-rest">
      <xsl:for-each select="option[part[1]/@name = current()/@name]">
        <option>
          <xsl:apply-templates select="part[position() &gt; 1]"/>
          <part name="{../@name}-rest"/>
        </option>
      </xsl:for-each>
      <option>
        <xsl:comment> empty </xsl:comment>
      </option>
    </construct>
  </xsl:template>

</xsl:stylesheet>
