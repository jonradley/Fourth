<?xml version="1.0"?>
<!--
******************************************************************************************
 Overview

 This XSL file is used to transform old style MDH/Shared catalogue XML into the catalogue
 XML supported by the Hospitality platform.

 © Alternative Business Solutions Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 06/06/2005 | Lee Boyton | Created module.
******************************************************************************************
            |            |
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#default">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="@*|node()" />
	</xsl:template>

	<!--change the old PriceCatHdr element to use the new PriceCatHeader naming convention-->
	<xsl:template match="PriceCatHdr">
		<PriceCatHeader>
			<xsl:apply-templates select="@*|node()"/>
		</PriceCatHeader>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
