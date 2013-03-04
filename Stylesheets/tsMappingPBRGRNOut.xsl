<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal GRNs into a PBR comma separated text file .
 
 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       				| Description of modification
******************************************************************************************
 08/10/2008	| S Dubey G Lokhande	| Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		<!--Header -->
		<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DespatchDate"/>
		<xsl:value-of select="$NewLine"/>	
		<!--GRN one or more detail lines  -->
		<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">			
			<xsl:value-of select="LineNumber"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="PackSize"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="AcceptedQuantity"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="AcceptedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="LineDiscountRate"/>
			<xsl:text>,</xsl:text>		
			<xsl:value-of select="LineDiscountValue"/>
			<xsl:value-of select="$NewLine"/>				
		</xsl:for-each>

	</xsl:template>
	
</xsl:stylesheet>