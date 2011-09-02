<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 30/10/2007	| 1558 Created stylesheet
**********************************************************************
				|					|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

	<xsl:template match="/PurchaseOrder">
	
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">


			<!--
			TENANT NUMBER, TEXT, 20, OPTIONAL
				=  blank
				-->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			TENANT NAME, TEXT, 40, OPTIONAL
				=  Contact name
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ContactName"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY NUMBER, TEXT, 12, OPTIONAL
				=  Recipient’s Code for Sender
				-->
			<xsl:value-of select="../../TradeSimpleHeader/RecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY NAME, TEXT, 30, MANDATORY
				=  Delivery Location Name
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToName"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY ADD1, TEXT, 40, MANDATORY
				=  DL Address line 1
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY ADD2, TEXT, 40, OPTIONAL
				=  DL Address line 2
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY ADD3, TEXT, 40, OPTIONAL
				=  DL Address line 3
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY ADD4, TEXT, 40, OPTIONAL
				=  DL Address line 4
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY POSTCODE, TEXT, 12, MANDATORY
				=  DL Address Postcode
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PROPERTY TELEPHONE, TEXT, 50, MANDATORY (See Notes)
				=  “Not Provided”
				-->
			<xsl:text>Not Provided</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			ORCHID PO NUMBER, TEXT, 15, MANDATORY (See Notes)
				=  Purchase Order Reference
				-->
			<xsl:value-of select="../../PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>,</xsl:text>
			
			<!--
			ORDER TYPE, TEXT, 10, MANDATORY (See Notes)
				=  “ORD”
				-->
			<xsl:text>ORD</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			ORDER SUBTYPE, TEXT, 10, OPTIONAL
				= blank
				-->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			ORDER DATE, “DD/MM/YYYY”, DATE, MANDATORY
				=  Purchase Order Date
				-->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="input" select="../../PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			
			<!--
			ORDER REFERENCE, TEXT, 12, OPTIONAL
				=  
				-->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			REQUIRED DELIVERY DATE, “DD/MM/YYYY”, DATE, OPTIONAL
				=  Required Delivery Date
				-->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="input" select="../../PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
			</xsl:call-template>
			
			<xsl:text>,</xsl:text>
			
			<!--
			DELIVERY INSTRUCTIONS1, TEXT, 100, OPTIONAL 
				= Left(Special Instructions, 100)
				-->
			<xsl:value-of select="substring(../../PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions, 1, 100)"/>
			<xsl:text>,</xsl:text>
			
			<!--
			DELIVERY INSTRUCTIONS2, TEXT, 30, OPTIONAL 
				= Mid(Special Instructions, 100, 30)
				-->
			<xsl:value-of select="substring(../../PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions, 100, 30)"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PRODUCT CODE, TEXT, 15, MANDATORY
				=  Supplier Product Code
				-->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PRODUCT DESCRIPTION, TEXT, 100, MANDATORY
				=  Product Description
				-->
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			
			<!--
			PRODUCT UNITS, INTEGER, NA, MANDATORY
				=  Quantity
				-->
			<xsl:value-of select="format-number(OrderedQuantity,'#')"/>
			<xsl:text>,</xsl:text>
			
			<!--
			EXTRA INFO NAME, TEXT, 30, OPTIONAL (See Notes)
				=  “PRICE”
				-->
			<xsl:text>PRICE</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!--
			EXTRA INFO VALUE, TEXT, 30, OPTIONAL (See Notes)
				=  Unit Price ex VAT
				-->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>&#13;&#10;</xsl:text>

		
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="input"/>
		
		<xsl:value-of select="concat(substring($input,9,2),'/',substring($input,6,2),'/',substring($input,1,4))"/>
	
	</xsl:template>

</xsl:stylesheet>
