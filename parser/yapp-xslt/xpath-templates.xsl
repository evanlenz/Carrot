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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:p="http://www.pingdynasty.com/namespaces/parser"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:exsl="http://exslt.org/common"
  version="1.0">

  <xsl:template match="text()"/>

  <xsl:template match="/">
    <result>
      <xsl:apply-templates/>
    </result>
  </xsl:template>

  <xsl:template match="*[@select]">
    <xsl:variable name="forest">
      <xsl:call-template name="p:Expr">
        <xsl:with-param name="in" select="@select"/>
      </xsl:call-template>
    </xsl:variable>
    <expression select="{@select}">
      <xsl:apply-templates select="exsl:node-set($forest)" mode="result"/>
    </expression>
  </xsl:template>

  <xsl:template match="term[*]" mode="result">
    <xsl:element name="{@name}">
      <xsl:apply-templates mode="result"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="term[contains(@name, '-rest')]" mode="result">
    <xsl:apply-templates mode="result"/>
  </xsl:template>

  <xsl:template match="term" mode="result">
    <xsl:element name="{@name}">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
