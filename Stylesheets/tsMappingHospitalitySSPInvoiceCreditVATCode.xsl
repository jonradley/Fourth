<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
	SSP specifc version of ts internal XML (!)
==========================================================================================
 Module History
==========================================================================================
 Version	|						|
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
11/12//2008	| Rave Tech				| 2640. Changes VAT Code as 'T' when VAT Rate is 15%.
==========================================================================================
           		|                 				|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- identity transformation -->
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="//VATCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="../VATCode='S' and (number(../VATRate)=15)">T</xsl:when>
			<xsl:otherwise><xsl:value-of select="../VATCode"></xsl:value-of></xsl:otherwise> 
			</xsl:choose>
		</xsl:copy> 
	</xsl:template>
	
	<xsl:template match="//@VATCode">
		<xsl:attribute name="VATCode">		
			<xsl:choose>
				<xsl:when test="../@VATCode='S' and (number(../@VATRate)=15)">T</xsl:when>
			<xsl:otherwise><xsl:value-of select="../@VATCode"></xsl:value-of></xsl:otherwise> 
			</xsl:choose>
		</xsl:attribute> 
	</xsl:template>

</xsl:stylesheet>