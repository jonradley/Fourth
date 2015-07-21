<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview:
 Maps Catalogue into a Saffron csv format from New Cat.

 © Fourth Hospitality, 2010.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       			| Description of modification
******************************************************************************************
18/10/2010	| Andrew Barber	| Copied Saffron catalouge out and amended for new cat.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
02/12/2010	| Andrew Barber	| FB:4068 Substring on recipients code for 3663 agreements.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
07/12/2010	| Andrew Barber	| FB:4077 Translate of commas in descriptive elements.
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

		<xsl:value-of select="substring(translate(CatalogueHeader/CatalogueName,',',''),1,50)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Strip the leading agreement number off for 3663 accounts -->
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'#')">
				<xsl:value-of select="substring(substring-after(TradeSimpleHeader/RecipientsCodeForSender,'#'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,T</xsl:text>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(Products/Product)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>CATITEM,</xsl:text>

			<xsl:value-of select="substring(//CatalogueHeader/CatalogueCode,1,10)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,20)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(translate(ProductDescription,',',''),1,50)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(translate(PackSize,',',''),1,20)"/>
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>