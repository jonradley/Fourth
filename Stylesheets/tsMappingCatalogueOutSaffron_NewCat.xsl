<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview
 Maps Catalogue into a Saffron csv format for Harrison Catering.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 02/02/2009	| Rave Tech		| Created Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 09/09/2009 | Steve Hewitt    | FB3109 : Removed the group and sub-group, renamed as it is now used for Harrisons and Mitie
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	
	<xsl:template match="/Catalogue">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--### HEADER LINE ###-->
		<xsl:text>CATHEAD,</xsl:text>
		
		<xsl:value-of select="substring(CatalogueHeader/CatalogueCode,1,10)"/>
		<xsl:text>,</xsl:text>

		<xsl:value-of select="substring(CatalogueHeader/CatalogueName,1,50)"/>
		<xsl:text>,</xsl:text>

		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
		<xsl:text>,T</xsl:text>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(Products/Product)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>CATITEM,</xsl:text>

			<xsl:value-of select="substring(//CatalogueHeader/CatalogueCode,1,10)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,20)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductDescription,1,50)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PackSize,1,20)"/>
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>