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
 06/06/2005 | Lee Boyton | H369. Created module.
******************************************************************************************
 05/07/2005 | Lee Boyton | H369. Cater for Coors using CatSpecificPrices="True" rather than "Yes"
******************************************************************************************
            |            |
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#default">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="@*|node()" />
		</BatchRoot>
	</xsl:template>

	<!--ensure that the catalogue specific prices element is set to 'Yes' if it is incorrectly specified as another boolean true value-->
	<xsl:template match="@CatSpecificPrices">
		<xsl:choose>
			<xsl:when test=". = 'True' or . = 'true' or . = '1'">
				<xsl:attribute name="CatSpecificPrices">
					<xsl:text>Yes</xsl:text>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="CatSpecificPrices">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
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
