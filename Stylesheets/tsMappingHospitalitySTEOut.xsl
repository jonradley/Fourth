<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
==========================================================================================
 23/08/2013	| S Hussain 				|	FB 6958: Generic - Site Transfers Mapper | Created
==========================================================================================
 04/09/2013	| RC Cambridge				|	FB 6958: Date formating new expects YYYY-MM-DD input (previously expected YYYMMDD)
 ==========================================================================================
 24/09/2013	| S Sehgal						|	FB 7107 / 7108 Added column names as the first row
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://abs-ltd.com">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="/">
	<xsl:text>Site Name</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Site Number</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>P</xsl:text><xsl:value-of select="'&amp;'" /><xsl:text>L Nominal</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Element 4</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Desciption</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Debit</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Credit</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Line Type</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Tax Code</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Tax Line Code</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Inclusive/Exclusive</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Tax Value</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Tax Doc Sum</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Tax Turnover</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:text>Ext Ref 1</xsl:text>
	<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="SiteTransfersExport/SiteTransfers"/>
	</xsl:template>
	<xsl:template match="SiteTransfer">
		<!--Unit Name-->
		<xsl:value-of select="SiteTransferLocation/UnitSiteName"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Site Code-->
		<xsl:value-of select="SiteTransferLocation/BuyersSiteCode"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--P&L Nominal-->
		<xsl:value-of select="CategoryNominal"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Blank Field-->
		<xsl:value-of select="$FieldSeperator"/>
		<!--Description-->
		<xsl:value-of select="ProductDescription"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Credit or Debit Line Value-->
		<xsl:choose>
			<xsl:when test="TransactionType = 'Debit'">
				<xsl:apply-templates select="LineValueExclVAT"/>
				<xsl:value-of select="$FieldSeperator"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:apply-templates select="LineValueExclVAT"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$FieldSeperator"/>	
		<xsl:apply-templates select="TransactionDate"/>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<xsl:template match="LineValueExclVAT">
		<xsl:value-of select="format-number(., '0.00')"/>
	</xsl:template>
	<xsl:template match="TransactionDate">
		<xsl:value-of select="concat(substring(.,9,2),'/',substring(.,6,2),'/',substring(.,1,4))"/>
	</xsl:template>
</xsl:stylesheet>
