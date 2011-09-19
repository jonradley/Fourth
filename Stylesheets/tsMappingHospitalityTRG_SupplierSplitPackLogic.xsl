<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="IGNORE_MAXSPLITS" select="'IGNORE_MAXSPLITS'"/>
	<xsl:variable name="CONVERT_TO_EACHS" select="'CONVERT_TO_EACHS'"/>
		
	<xsl:template name="sProcessMaxSplits">
		<xsl:param name="vsSupplierCode"/>
	
		<xsl:choose>
			<xsl:when test="$vsSupplierCode = '7'"><xsl:value-of select="$IGNORE_MAXSPLITS"/></xsl:when>
			<xsl:when test="$vsSupplierCode = 'V000001'"><xsl:value-of select="$IGNORE_MAXSPLITS"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$CONVERT_TO_EACHS"/></xsl:otherwise>
		</xsl:choose>	
		
	</xsl:template>

</xsl:stylesheet>
