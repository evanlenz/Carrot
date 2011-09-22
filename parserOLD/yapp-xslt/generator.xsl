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
 |   http://www.o-xml.org/projects/yapp.html                                 |
 |                                                                           |
 +- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:exsl="http://exslt.org/common"
  xmlns:tns="urn:out"
  xmlns:t="http://www.pingdynasty.com/namespaces/tokenizer"
  xmlns:p="http://www.pingdynasty.com/namespaces/parser"
  exclude-result-prefixes="xalan">

  <xsl:namespace-alias stylesheet-prefix="tns" result-prefix="xsl"/>

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <tns:stylesheet version="2.0"
      xalan:ignore="ignore" t:ignore="ignore" p:ignore="ignore"
      exclude-result-prefixes="xalan">
      <xsl:apply-templates select="grammar/import"/>
      <tns:output method="xml" indent="yes" encoding="UTF-8"/>

      <!-- Added for Saxon -->
      <tns:function name="exsl:node-set">
        <tns:param name="rtf"/>
        <tns:sequence select="$rtf"/>
      </tns:function>

      <xsl:apply-templates select="grammar"/>
    </tns:stylesheet>
  </xsl:template>

  <xsl:template match="text()"/>

  <xsl:template match="import">
    <tns:import href="{@href}"/>
  </xsl:template>

  <xsl:template match="templates">
    <xsl:copy-of select="node()"/>
  </xsl:template>

  <xsl:template match="grammar">

    <xsl:comment> Templates for terminals </xsl:comment>
    <xsl:apply-templates select="terminal"/>

    <xsl:comment> Templates for non-terminals </xsl:comment>
    <xsl:apply-templates select="construct" mode="content"/>

    <xsl:comment> Templates from grammar </xsl:comment>
    <xsl:apply-templates select="templates[not(@rule)]"/>
  </xsl:template>

  <xsl:template match="construct" mode="content">
    <xsl:comment> Construct: <xsl:value-of select="@name"/> </xsl:comment>
    <tns:template name="p:{@name}">
      <tns:param name="in"/>
      <tns:message>
        <xsl:value-of select="@name"/> gets in {<tns:value-of select="$in"/>}
      </tns:message>
      <xsl:apply-templates select="option[1]" mode="content"/>
    </tns:template>
  </xsl:template>

  <xsl:template match="option[part]" mode="content">
    <xsl:comment>
      <xsl:value-of select="concat(' ', ../@name, ' -> ')"/>
      <xsl:for-each select="part">
        <xsl:value-of select="concat(@name, ' ')"/>
      </xsl:for-each>
    </xsl:comment>
    <xsl:variable name="title">
      <xsl:for-each select="part">
        <xsl:value-of select="concat('-', @name)"/>
      </xsl:for-each>
    </xsl:variable>
    <tns:variable name="option{$title}">
      <xsl:apply-templates select="part" mode="content"/>
    </tns:variable>
<tns:message>option<xsl:value-of select="$title"/>: <tns:copy-of select="$option{$title}"/></tns:message>
    <tns:choose>
      <tns:when test="count(exsl:node-set($option{$title})/term) = {count(part)}">
        <term name="{../@name}">
          <tns:copy-of select="exsl:node-set($option{$title})/term"/>
        </term>
        <remainder>
          <tns:value-of select="exsl:node-set($option{$title})/remainder[{count(part)}]"/>
        </remainder>
      </tns:when>
      <tns:otherwise>
        <xsl:apply-templates select="following-sibling::option[1]" mode="content"/>
      </tns:otherwise>
    </tns:choose>
  </xsl:template>

  <!-- option with no parts -->
  <xsl:template match="option" mode="content">
    <xsl:comment>
      <xsl:value-of select="concat(' ', ../@name, ' -> ')"/>
    </xsl:comment>
    <term name="{../@name}"/>
    <remainder><tns:value-of select="$in"/></remainder>
  </xsl:template>

  <!-- first part -->
  <xsl:template match="part" mode="content">
    <xsl:comment> part <xsl:value-of select="@name"/></xsl:comment>
    <tns:variable name="part{position()}">
      <tns:call-template name="p:{@name}">
        <tns:with-param name="in" select="$in"/>
      </tns:call-template>
    </tns:variable>
    <tns:copy-of select="exsl:node-set($part{position()})"/>
  </xsl:template>

  <!-- middle or last part -->
  <xsl:template match="part[preceding-sibling::part]" mode="content">
    <xsl:comment> and part <xsl:value-of select="@name"/></xsl:comment>
      <tns:variable name="part{position()}">
        <tns:if test="exsl:node-set($part{position() - 1})/remainder">
          <tns:call-template name="p:{@name}">
            <tns:with-param name="in" 
              select="exsl:node-set($part{position() - 1})/remainder"/>
          </tns:call-template>
        </tns:if>
      </tns:variable>
      <tns:copy-of select="exsl:node-set($part{position()})"/>
  </xsl:template>
      
  <xsl:template match="terminal">
    <tns:template name="p:{@name}">
      <tns:param name="in"/>
      <tns:message>
        <xsl:value-of select="@name"/> gets in: <tns:value-of select="$in"/>
      </tns:message>
      <tns:variable name="token">
        <tns:call-template name="t:nextToken">
          <tns:with-param name="in" select="$in"/>
        </tns:call-template>
      </tns:variable>
      <tns:if test="exsl:node-set($token)/token/@type='{@name}'">
        <tns:message>
          <xsl:value-of select="@name"/> matches {<tns:value-of select="exsl:node-set($token)/token"/>}
        </tns:message>
        <term name="{@name}">
          <tns:value-of select="exsl:node-set($token)/token"/>
        </term>
        <remainder>
          <tns:value-of select="exsl:node-set($token)/remainder"/>
        </remainder>
      </tns:if>
    </tns:template>
  </xsl:template>

</xsl:stylesheet>
