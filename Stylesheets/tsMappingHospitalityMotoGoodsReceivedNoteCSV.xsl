<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Goods Received Note translation following CSV 
flat file mapping for Moto.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Rave Tech	| 02/01/2008| Created Module
*******************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!--set value of documentstatus -->
	<xsl:template match="DocumentStatus">
		<DocumentStatus>
			<xsl:text>Original</xsl:text>
		</DocumentStatus>
	</xsl:template>
			
	<!-- translate the date from [dd/mm/yyyy] format to [yyyy-mm-dd] -->
	<xsl:template match="GoodsReceivedNoteDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<GoodsReceivedNoteDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</GoodsReceivedNoteDate>
	</xsl:template>	
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
