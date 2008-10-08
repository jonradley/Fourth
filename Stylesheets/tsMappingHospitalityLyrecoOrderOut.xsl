<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================

	Lyreco specifc version of ts internal XML (!)

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 10/09/2008	| R Cambridge			| 1764 Created module
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- identity transformation -->
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Derive UoM code based on pack size supplied by Moto -->
	<xsl:template match="//@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure">		
		
			<xsl:variable name="packSize">
				<!-- remove superfluous characters -->
				<xsl:variable name="temp" select="translate(../../PackSize,'0123456789 ','')"/>
				
				<!-- convert to lowercase -->
				<xsl:value-of select="translate($temp,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>				
							
			</xsl:variable>		
		
			<xsl:choose>
				<xsl:when test="contains($packSize,'box')">BOX</xsl:when>
				<xsl:when test="contains($packSize,'each')">EA</xsl:when>
				<xsl:when test="contains($packSize,'pack')">PKG</xsl:when>
				<xsl:when test="contains($packSize,'wallet')">EA</xsl:when>				
				<xsl:otherwise/>				
			</xsl:choose>		
		</xsl:attribute>	
	</xsl:template>	
	
	
</xsl:stylesheet>