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
<!DOCTYPE xsl:stylesheet [
<!ENTITY squot "'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:tns="urn:out"
  xmlns:t="http://www.pingdynasty.com/namespaces/tokenizer"
  exclude-result-prefixes="xalan">

  <xsl:namespace-alias stylesheet-prefix="tns" result-prefix="xsl"/>
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:variable name="stop" select="' '"/>

  <xsl:template match="delimited">
    <tns:when test="starts-with($in, '{begin}')">
      <tns:variable name="after" select="substring($in, {string-length(begin)+1})"/>
      <token type="{../@name}">
        <tns:value-of select="substring-before($after, '{end}')"/>
      </token>
      <remainder>
        <tns:value-of select="substring-after($after, '{end}')"/>
      </remainder>
    </tns:when>
  </xsl:template>

  <!-- need to handle patterns with single quotes separately -->
  <xsl:template match='delimited[contains(begin, "&squot;")]'>
    <tns:when test='starts-with($in, "{begin}")'>
      <token type="{../@name}">
        <tns:value-of select='substring-before(substring($in, 2), "{end}")'/>
      </token>
      <remainder>
        <tns:value-of select='substring-after(substring($in, 2), "{end}")'/>
      </remainder>
    </tns:when>
  </xsl:template>

  <xsl:template match="equals">
    <tns:when test="starts-with($in, '{.}')">
      <token type="{../@name}">
        <tns:value-of select="substring($in, 1, {string-length(.)})"/>
      </token>
      <remainder>
        <tns:value-of select="substring($in, {string-length(.)+1})"/>
      </remainder>
    </tns:when>
  </xsl:template>

  <xsl:variable name="t:allChars">
    <xsl:value-of select="/grammar/ignore/@char"/>
    <xsl:apply-templates select="/grammar/terminal/*/text()"/>
  </xsl:variable>

  <xsl:template match="any">
    <xsl:variable name="other" select="translate($t:allChars, ., '')"/>
    <pattern name="{../@name}">
      <match>
        <tns:text><xsl:value-of select="."/></tns:text>
      </match>
      <inverse>
        <tns:text><xsl:value-of select="$other"/></tns:text>
      </inverse>
      <stopper>
        <tns:text><xsl:call-template name="pad">
          <xsl:with-param name="length" select="string-length($other)"/>
          <xsl:with-param name="char" select="$stop"/>
        </xsl:call-template></tns:text>
      </stopper>
    </pattern>
  </xsl:template>

  <xsl:template match="end">
    <tns:when test="string-length($in) = 0">
      <token type="{../@name}"/>
    </tns:when>
  </xsl:template>

  <xsl:template match="ignore">
    <tns:when test="starts-with($in, '{@char}')">
      <tns:call-template name="t:nextToken">
        <tns:with-param name="in" select="substring($in, 2)"/>
      </tns:call-template>
    </tns:when>
  </xsl:template>

  <xsl:template match="/">
    <tns:stylesheet version="1.0"
      xalan:ignore="ignore" t:ignore="ignore"
      exclude-result-prefixes="xalan">
      <tns:output method="xml" indent="yes" encoding="UTF-8"/>

      <xsl:apply-templates/>

    </tns:stylesheet>
  </xsl:template>

  <xsl:template name="pad">
    <xsl:param name="length"/>
    <xsl:param name="char"/>
    <xsl:if test="$length > 0">
      <xsl:value-of select="$char"/>
      <xsl:call-template name="pad">
        <xsl:with-param name="length" select="$length - 1"/>
        <xsl:with-param name="char" select="$char"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="grammar">
    <tns:template name="t:nextToken">
      <tns:param name="in"/>
      <tns:choose>
        <xsl:apply-templates select="terminal/end"/>
        <xsl:apply-templates select="ignore"/>
        <xsl:apply-templates select="terminal/equals">
          <xsl:sort select="string-length(.)" data-type="number" order="descending"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="terminal/delimited">
          <xsl:sort select="string-length(begin)" data-type="number" order="descending"/>
        </xsl:apply-templates>
        <tns:otherwise>
          <!-- try the patterns -->
          <tns:call-template name="t:token">
            <tns:with-param name="in" select="$in"/>
          </tns:call-template>
        </tns:otherwise>
      </tns:choose>
    </tns:template>

    <tns:variable name="t:patterns">
      <xsl:apply-templates select="terminal/any"/>
    </tns:variable>

    <tns:template name="t:token">
      <tns:param name="in"/>
      <xsl:comment> create the longest possible token from a set of accepted characters </xsl:comment>
      <xsl:variable name="expr">
        <xsl:text>substring-before(concat(translate($in, inverse/text(), stopper/text()), '</xsl:text>
        <xsl:value-of select="$stop"/>
        <xsl:text>'), '</xsl:text>
        <xsl:value-of select="$stop"/>
        <xsl:text>')</xsl:text>
      </xsl:variable>
      <tns:variable name="matches">
        <tns:for-each select="xalan:nodeset($t:patterns)/pattern">
          <tns:sort select="string-length({$expr})"
            data-type="number" order="descending"/>
          <pattern>
            <name><tns:value-of select="@name"/></name>
            <match><tns:value-of select="{$expr}"/></match>
          </pattern>
        </tns:for-each>
      </tns:variable>
      <tns:variable name="token" select="xalan:nodeset($matches)/pattern[1]/match"/>
      <tns:variable name="name" select="xalan:nodeset($matches)/pattern[1]/name"/>
      <tns:if test="$token">
        <token>
          <xsl:attribute name="type">{$name}</xsl:attribute>
          <tns:value-of select="$token"/>
        </token>
        <remainder>
          <tns:value-of select="substring-after($in, $token)"/>
        </remainder>
      </tns:if>
    </tns:template>

    <tns:template name="t:tokenize">
      <tns:param name="in"/>
      <tns:variable name="token">
        <tns:call-template name="t:nextToken">
          <tns:with-param name="in" select="$in"/>
        </tns:call-template>
      </tns:variable>
      <tns:copy-of select="xalan:nodeset($token)/token"/>
      <tns:if test="xalan:nodeset($token)/token/@type != '{terminal[end]/@name}'">
        <tns:call-template name="t:tokenize">
          <tns:with-param name="in" select="xalan:nodeset($token)/remainder"/>
        </tns:call-template>
      </tns:if>
    </tns:template>

  </xsl:template>

</xsl:stylesheet>
