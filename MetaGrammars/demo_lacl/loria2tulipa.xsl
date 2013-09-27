<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
            version="1.0"
            encoding="iso-8859-1"
            doctype-system="xmg-mctag.dtd,xml"
            indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="grammar">
  <mcgrammar>
    <xsl:copy-of select="entry"/>
  </mcgrammar>
</xsl:template>

</xsl:stylesheet>
