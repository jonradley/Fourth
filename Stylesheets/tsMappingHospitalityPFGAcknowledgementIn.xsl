<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 2009-09-18	| 3119 Created module
**********************************************************************
				|					|
**********************************************************************
				|					|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" />	
	
	
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="@* | node()"/>
		</BatchRoot>
	</xsl:template>
	
	
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">84</xsl:attribute>			
			<xsl:apply-templates select="@* | node()"/>			
		</xsl:copy>	
	</xsl:template>	

	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderAcknowledgementDate">
	
		<xsl:copy>
		
			<xsl:value-of select="substring(.,1,4)"/>			
			<xsl:text>-</xsl:text>			
			<xsl:value-of select="substring(.,5,2)"/>			
			<xsl:text>-</xsl:text>							
			<xsl:value-of select="substring(.,7,2)"/>

		</xsl:copy>
	
	</xsl:template>
	
	<xsl:template match="NumberOfLines">
		<xsl:copy>
			<xsl:value-of select="format-number(.,'#')"/>
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="TotalExclVAT">
		<xsl:copy>
			<xsl:value-of select="format-number(.,'#.00')"/>
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	
</xsl:stylesheet>
