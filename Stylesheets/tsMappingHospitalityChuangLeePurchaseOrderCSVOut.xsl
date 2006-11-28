<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 Maps a single iXML purchase order into Chuanglee's Sage CSV format
 
 © Alternative Business Solutions Ltd, 2006
==========================================================================================
 Module History
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 28/11/2006	| Lee Boyton        | Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	<xsl:output method="text" encoding="iso-8859-1"/>
	
	<xsl:template match="/PurchaseOrder">
	
		<!-- store repeated header information in local variables -->
		
		<!-- Client Code - Chuanglee's code for Ship To -->
		<xsl:variable name="clientCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		</xsl:variable>
		
		<!-- Due Date - delivery date in format dd/mm/yyyy -->
		<xsl:variable name="dueDate">
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,9,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,6,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,1,4)"/>
		</xsl:variable>
		
		<!-- Order Ref -->
		<xsl:variable name="orderReference">
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		</xsl:variable>
		
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:value-of select="$clientCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="PackSize"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$dueDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$orderReference"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
