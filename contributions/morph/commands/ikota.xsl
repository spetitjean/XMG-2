<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" version="1.0"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/">
    <xsl:for-each select="/grammar/entry/morph">
      <xsl:for-each select="fields/f/sym">
	<xsl:if test="position()!=1"><xsl:text>+</xsl:text></xsl:if>
	<xsl:value-of select="@value"/>
      </xsl:for-each>
      <xsl:for-each select="feats">
	<xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="f[@name='nc']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="f[@name='active']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
    <xsl:text>active</xsl:text>
  </xsl:template>
  <xsl:template match="f[@name='n']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="f[@name='p']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="f[@name='prog']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
    <xsl:text>prog</xsl:text>
  </xsl:template>
  <xsl:template match="f[@name='neg']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
    <xsl:text>neg</xsl:text>
  </xsl:template>
  <xsl:template match="f[@name='tense']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="f[@name='proxi']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="f[@name='vclass']">
    <xsl:text> </xsl:text>
    <xsl:value-of select="sym/@value"/>
  </xsl:template>
  <xsl:template match="*"/>
</xsl:stylesheet>
