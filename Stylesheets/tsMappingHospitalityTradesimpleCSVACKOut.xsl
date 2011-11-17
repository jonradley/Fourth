<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-11-17		| 4966 Created Module
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="PurchaseOrderAcknowledgement">
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
	</xsl:template>
	
</xsl:stylesheet>