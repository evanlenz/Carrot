<?xml version="1.0" encoding="UTF-8"?>
<tns:stylesheet xmlns:tns="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:t="http://www.pingdynasty.com/namespaces/tokenizer" xmlns:p="http://www.pingdynasty.com/namespaces/parser" xmlns:xalan="http://xml.apache.org/xalan" version="1.0" xalan:ignore="ignore" t:ignore="ignore" p:ignore="ignore" exclude-result-prefixes="xalan"><tns:import href="bnf-lexer.xsl"/><tns:output method="xml" indent="yes" encoding="UTF-8"/><!-- Templates for terminals --><tns:template name="p:end"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='end'"><term name="end"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:number"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='number'"><term name="number"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:name"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='name'"><term name="name"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:pattern"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='pattern'"><term name="pattern"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:literal"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='literal'"><term name="literal"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:def"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='def'"><term name="def"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:bar"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='bar'"><term name="bar"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:semicolon"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='semicolon'"><term name="semicolon"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:plus"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='plus'"><term name="plus"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:asterisk"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='asterisk'"><term name="asterisk"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><tns:template name="p:question"><tns:param name="in"/><tns:variable name="token"><tns:call-template name="t:nextToken"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:if test="exsl:node-set($token)/token/@type='question'"><term name="question"><tns:value-of select="exsl:node-set($token)/token"/></term><remainder><tns:value-of select="exsl:node-set($token)/remainder"/></remainder></tns:if></tns:template><!-- Templates for non-terminals --><!-- Construct: Grammar--><tns:template name="p:Grammar"><tns:param name="in"/><!-- Grammar -> Rules end --><tns:variable name="option-Rules-end"><!-- part Rules--><tns:variable name="part1"><tns:call-template name="p:Rules"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/><!-- and part end--><tns:variable name="part2"><tns:if test="exsl:node-set($part1)/remainder"><tns:call-template name="p:end"><tns:with-param name="in" select="exsl:node-set($part1)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part2)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-Rules-end)/term) = 2"><term name="Grammar"><tns:copy-of select="exsl:node-set($option-Rules-end)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-Rules-end)/remainder[2]"/></remainder></tns:when><tns:otherwise/></tns:choose></tns:template><!-- Construct: Rules--><tns:template name="p:Rules"><tns:param name="in"/><!-- Rules -> Rule Rules --><tns:variable name="option-Rule-Rules"><!-- part Rule--><tns:variable name="part1"><tns:call-template name="p:Rule"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/><!-- and part Rules--><tns:variable name="part2"><tns:if test="exsl:node-set($part1)/remainder"><tns:call-template name="p:Rules"><tns:with-param name="in" select="exsl:node-set($part1)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part2)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-Rule-Rules)/term) = 2"><term name="Rules"><tns:copy-of select="exsl:node-set($option-Rule-Rules)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-Rule-Rules)/remainder[2]"/></remainder></tns:when><tns:otherwise><!-- Rules -> --><term name="Rules"/><remainder><tns:value-of select="$in"/></remainder></tns:otherwise></tns:choose></tns:template><!-- Construct: Rule--><tns:template name="p:Rule"><tns:param name="in"/><!-- Rule -> name def Definition Definitions semicolon --><tns:variable name="option-name-def-Definition-Definitions-semicolon"><!-- part name--><tns:variable name="part1"><tns:call-template name="p:name"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/><!-- and part def--><tns:variable name="part2"><tns:if test="exsl:node-set($part1)/remainder"><tns:call-template name="p:def"><tns:with-param name="in" select="exsl:node-set($part1)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part2)"/><!-- and part Definition--><tns:variable name="part3"><tns:if test="exsl:node-set($part2)/remainder"><tns:call-template name="p:Definition"><tns:with-param name="in" select="exsl:node-set($part2)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part3)"/><!-- and part Definitions--><tns:variable name="part4"><tns:if test="exsl:node-set($part3)/remainder"><tns:call-template name="p:Definitions"><tns:with-param name="in" select="exsl:node-set($part3)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part4)"/><!-- and part semicolon--><tns:variable name="part5"><tns:if test="exsl:node-set($part4)/remainder"><tns:call-template name="p:semicolon"><tns:with-param name="in" select="exsl:node-set($part4)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part5)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-name-def-Definition-Definitions-semicolon)/term) = 5"><term name="Rule"><tns:copy-of select="exsl:node-set($option-name-def-Definition-Definitions-semicolon)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-name-def-Definition-Definitions-semicolon)/remainder[5]"/></remainder></tns:when><tns:otherwise/></tns:choose></tns:template><!-- Construct: Definitions--><tns:template name="p:Definitions"><tns:param name="in"/><!-- Definitions -> bar Definition Definitions --><tns:variable name="option-bar-Definition-Definitions"><!-- part bar--><tns:variable name="part1"><tns:call-template name="p:bar"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/><!-- and part Definition--><tns:variable name="part2"><tns:if test="exsl:node-set($part1)/remainder"><tns:call-template name="p:Definition"><tns:with-param name="in" select="exsl:node-set($part1)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part2)"/><!-- and part Definitions--><tns:variable name="part3"><tns:if test="exsl:node-set($part2)/remainder"><tns:call-template name="p:Definitions"><tns:with-param name="in" select="exsl:node-set($part2)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part3)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-bar-Definition-Definitions)/term) = 3"><term name="Definitions"><tns:copy-of select="exsl:node-set($option-bar-Definition-Definitions)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-bar-Definition-Definitions)/remainder[3]"/></remainder></tns:when><tns:otherwise><!-- Definitions -> --><term name="Definitions"/><remainder><tns:value-of select="$in"/></remainder></tns:otherwise></tns:choose></tns:template><!-- Construct: Definition--><tns:template name="p:Definition"><tns:param name="in"/><!-- Definition -> Terms --><tns:variable name="option-Terms"><!-- part Terms--><tns:variable name="part1"><tns:call-template name="p:Terms"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-Terms)/term) = 1"><term name="Definition"><tns:copy-of select="exsl:node-set($option-Terms)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-Terms)/remainder[1]"/></remainder></tns:when><tns:otherwise/></tns:choose></tns:template><!-- Construct: Terms--><tns:template name="p:Terms"><tns:param name="in"/><!-- Terms -> Term Terms --><tns:variable name="option-Term-Terms"><!-- part Term--><tns:variable name="part1"><tns:call-template name="p:Term"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/><!-- and part Terms--><tns:variable name="part2"><tns:if test="exsl:node-set($part1)/remainder"><tns:call-template name="p:Terms"><tns:with-param name="in" select="exsl:node-set($part1)/remainder"/></tns:call-template></tns:if></tns:variable><tns:copy-of select="exsl:node-set($part2)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-Term-Terms)/term) = 2"><term name="Terms"><tns:copy-of select="exsl:node-set($option-Term-Terms)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-Term-Terms)/remainder[2]"/></remainder></tns:when><tns:otherwise><!-- Terms -> --><term name="Terms"/><remainder><tns:value-of select="$in"/></remainder></tns:otherwise></tns:choose></tns:template><!-- Construct: Term--><tns:template name="p:Term"><tns:param name="in"/><!-- Term -> name --><tns:variable name="option-name"><!-- part name--><tns:variable name="part1"><tns:call-template name="p:name"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-name)/term) = 1"><term name="Term"><tns:copy-of select="exsl:node-set($option-name)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-name)/remainder[1]"/></remainder></tns:when><tns:otherwise><!-- Term -> Terminal --><tns:variable name="option-Terminal"><!-- part Terminal--><tns:variable name="part1"><tns:call-template name="p:Terminal"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-Terminal)/term) = 1"><term name="Term"><tns:copy-of select="exsl:node-set($option-Terminal)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-Terminal)/remainder[1]"/></remainder></tns:when><tns:otherwise/></tns:choose></tns:otherwise></tns:choose></tns:template><!-- Construct: Terminal--><tns:template name="p:Terminal"><tns:param name="in"/><!-- Terminal -> literal --><tns:variable name="option-literal"><!-- part literal--><tns:variable name="part1"><tns:call-template name="p:literal"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-literal)/term) = 1"><term name="Terminal"><tns:copy-of select="exsl:node-set($option-literal)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-literal)/remainder[1]"/></remainder></tns:when><tns:otherwise><!-- Terminal -> pattern --><tns:variable name="option-pattern"><!-- part pattern--><tns:variable name="part1"><tns:call-template name="p:pattern"><tns:with-param name="in" select="$in"/></tns:call-template></tns:variable><tns:copy-of select="exsl:node-set($part1)"/></tns:variable><tns:choose><tns:when test="count(exsl:node-set($option-pattern)/term) = 1"><term name="Terminal"><tns:copy-of select="exsl:node-set($option-pattern)/term"/></term><remainder><tns:value-of select="exsl:node-set($option-pattern)/remainder[1]"/></remainder></tns:when><tns:otherwise/></tns:choose></tns:otherwise></tns:choose></tns:template><!-- Templates from grammar -->

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="node()|@*">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="bnf">
      <!-- three-pass processing -->
      <xsl:variable name="parsed">
        <!-- parse the bnf grammar -->
        <xsl:call-template name="p:Grammar">
          <xsl:with-param name="in" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="grammar">
        <!-- turn 'term' elements into something more useful -->
        <xsl:apply-templates select="exsl:node-set($parsed)/term" mode="rewrite"/>
      </xsl:variable>
      <!-- turn productions into grammar -->
      <xsl:apply-templates select="exsl:node-set($grammar)" mode="generate"/>

    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="term[*]" mode="rewrite">
      <xsl:element name="{@name}">
        <xsl:apply-templates mode="rewrite"/>
      </xsl:element>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="term" mode="rewrite">
      <xsl:element name="{@name}">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="text()" mode="generate"/>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="Grammar" mode="generate">
        <xsl:apply-templates mode="generate"/>
    </xsl:template>

    <!-- constructs -->
    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="Rule" mode="generate">
      <construct name="{name}">
        <xsl:apply-templates mode="generate"/>
      </construct>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="Definition" mode="generate">
      <option>
        <xsl:apply-templates mode="generate"/>
      </option>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="Term[name]" mode="generate">
      <part name="{name}"/>
    </xsl:template>

    <!-- terminals -->
    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="Rule[descendant::Terminal]" mode="generate">
      <terminal name="{name}">
        <xsl:apply-templates select="descendant::Terminal" mode="generate"/>
      </terminal>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="pattern" mode="generate">
      <any><xsl:value-of select="."/></any>
    </xsl:template>

    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="literal" mode="generate">
      <equals>
        <xsl:value-of select="."/>
      </equals>
    </xsl:template>

  </tns:stylesheet>
