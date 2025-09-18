<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template match="jx.glyphs/o">
    <xsl:if test=".//jx.elements">
      <xsl:choose>
	<xsl:when test="jx.unicode">
	  <xsl:value-of select="jx.name"/>
	  <xsl:text>&#x9;</xsl:text>
	  <xsl:value-of select="translate(jx.unicode,'abcdef','ABCDEF')"/>
	  <xsl:text>&#xa;</xsl:text>
	</xsl:when>
	<xsl:when test="jx.unicodes">
	  <xsl:for-each select="jx.unicodes/v">
	    <xsl:value-of select="../../jx.name"/>
	    <xsl:text>&#x9;</xsl:text>
	    <xsl:variable name="hex">
	      <xsl:call-template name="decimal-to-hex">
		<xsl:with-param name="number" select="."/>
	      </xsl:call-template>
	    </xsl:variable>
	    <xsl:choose>
	      <xsl:when test="starts-with($hex,'0')">
		<xsl:value-of select="substring-after($hex,'0')"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="$hex"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:text>&#xa;</xsl:text>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="jx.name"/>
	  <xsl:text>&#x9;&#xa;</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="text()"/>
  <xsl:template name="decimal-to-hex">
    <xsl:param name="number"/>
    <xsl:variable name="hex-chars" select="'0123456789ABCDEF'"/>
    <xsl:if test="$number > 0">
      <xsl:call-template name="decimal-to-hex">
        <xsl:with-param name="number" select="floor($number div 16)"/>
      </xsl:call-template>
      <xsl:value-of select="substring($hex-chars, ($number mod 16) + 1, 1)"/>
    </xsl:if>
    <xsl:if test="$number = 0 and not(floor($number div 16))">
      <xsl:text>0</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:transform>
