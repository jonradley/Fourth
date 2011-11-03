<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2008
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 08/05/2008	| Moty Dimant  	| Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							  |
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:template match="/">
	
		<!-- 7-digit Moto Unit Code -->
		<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
				
		<!-- Unit Name --> 
		<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/SendersName"/>
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Number --> 
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Date --> 
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date --> 
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		<xsl:text>,</xsl:text>
		
		<!-- New Line --> 
		<xsl:text>&#13;&#10;</xsl:text>	
	
		
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- Product Code --> 
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			
			<!-- Quantity --> 
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			
			<!-- Product Description --> 
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			
			<!-- New Line --> 
			<xsl:text>&#13;&#10;</xsl:text>
		
		</xsl:for-each>
		
		<!-- End of File (as requested in spec) -->
		<xsl:text>&lt;EOF&gt;</xsl:text>

	</xsl:template>
	
</xsl:stylesheet>
