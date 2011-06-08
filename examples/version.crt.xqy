
^(ml:version-list) :=
  <div id="version_list">
    <span>API Reference </span>
    <span class="version">{`(`,^version-list-item($versions),`)`}</span>
  </div>;

    ^version-list-item( version ) :=
      ^version-list-item-link(.),
      if (position() ne last()) then ` | ` else ();

        ^version-list-item-link( version ) := text{@number};
        ^version-list-item-link( version[not(@number eq $api:version)] ) :=
          <a href="/{@number}">{ ^^next-match() }</a>;

==>

  <xsl:template match="ml:version-list">
    <div id="version_list">
      <span>API Reference </span>
      <span class="version">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates mode="version-list-item" select="$versions"/>
        <xsl:text>)</xsl:text>
      </span>
    </div>
  </xsl:template>

          <xsl:template mode="version-list-item" match="version">
            <xsl:apply-templates mode="version-list-item-link" select="."/>
            <xsl:if test="position() ne last()"> | </xsl:if>
          </xsl:template>

                  <xsl:template mode="version-list-item-link" match="version[not(@number eq $api:version)]">
                    <a href="/{@number}">
                      <xsl:next-match/>
                    </a>
                  </xsl:template>

                  <xsl:template mode="version-list-item-link" match="version">
                    <xsl:value-of select="@number"/>
                  </xsl:template>


(: Example 2: :)

    ^version-list-item( version ) :=
      <a href="/{@number}">{^current-version-class-att(.),text{@number}}</a>,
      if (position() ne last()) then ` | ` else ();

        ^current-version-class-att( version                          ) := ();
        ^current-version-class-att( version[@number eq $api:version] ) :=
          attribute class { "currentVersion" };


==>

          <xsl:template mode="version-list-item" match="version">
            <a href="/{@number}">
              <xsl:apply-templates mode="current-version-class-att" select="."/>
              <xsl:value-of select="@number"/>
            </a>
            <xsl:if test="position() ne last()"> | </xsl:if>
          </xsl:template>

                  <xsl:template mode="current-version-class-att" match="version"/>
                  <xsl:template mode="current-version-class-att" match="version[@number eq $api:version]">
                    <xsl:attribute name="class" select="'currentVersion'"/>
                  </xsl:template>


