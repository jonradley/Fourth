<?xml version="1.0" encoding="UTF-8"?>

<!--*********************************************************************
tradesimple internalorder  to QubicaAMF ORDERS spec map
*************************************************************************
Name		| Date       | Change
*************************************************************************
A Barber	| 01/02/2010 | Created.
**********************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/">
	
		<!--Header-->
		<xsl:text>ORDHDR</xsl:text>
		<xsl:text>,</xsl:text>
		<!--TNrPartner :: Can be left blank, is for a German standard-->
		<xsl:text>,</xsl:text>
		<!--DocumentNumber-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<!--DocumentDate-->
		<xsl:value-of select="concat(substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4),
									substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2),
									substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2),
									substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,1,2),
									substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,4,2),
									substring(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,7,2))"/>
		<xsl:text>,</xsl:text>
		<!--DocumentSubType :: Can be left blank, was for old standard-->
		<xsl:text>,</xsl:text>
		<!--TestFlag-->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!--SpecialConditions :: Leave blank-->
		<xsl:text>,</xsl:text>
		<!--OrderType :: Can be left blank - differentiation  between season, NOS or onetime buy-->
		<xsl:text>,</xsl:text>
		<!--ReferenceCustomersReference-->
		<xsl:text>,</xsl:text>
		<!--ReferenceBlockOrder-->
		<xsl:text>,</xsl:text>
		<!--SupplierILN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--SupplierNumberAtBuyingGroup-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<!--UltimateConsignyILN-->
		<xsl:text>,</xsl:text>
		<!--Unit GLN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--BuyerPurchasingContact-->
		<xsl:text>,</xsl:text>
		<!--BuyerILN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--InvoiceRecipientILN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--DeliveryPartyILN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--UltimateConsignyILN-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
		<xsl:text>,</xsl:text>
		<!--BuyerNumberAtBuyingGroup-->
		<xsl:text>,</xsl:text>
		<!--BuyerPurchasingContact-->
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/>
		<xsl:text>,</xsl:text>
		<!--Currency, fixed to 'GBP'-->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<!--DeliveryDate-->
		<xsl:value-of select="concat(substring(PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,1,4),
									substring(PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,6,2),
									substring(PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,9,2))"/>
		<xsl:text>,</xsl:text>
		<!--DeliveryDateFrom-->
		<xsl:text>,</xsl:text>
		<!--DeliveryDateTo-->
		<xsl:text>,</xsl:text>
		<!--DeliveryDateFix-->
		<xsl:text>,</xsl:text>
		<!--PickupDate-->
		<xsl:text></xsl:text>
		
		<!--End of line-->			
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Purchase Order Lines-->	
		<xsl:for-each select="PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!--Record Tag-->
			<xsl:text>ORDPOS</xsl:text>
			<xsl:text>,</xsl:text>
			<!--PositionNumber-->
			<xsl:value-of select="LineNumber"/>
			<xsl:text>,</xsl:text>
			<!--EAN-->
			<xsl:value-of select="ProductID/GTIN"/>
			<xsl:text>,</xsl:text>
			<!--OrderedQuantity-->
			<xsl:value-of select ="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<!--OrderedQuantityMeasureUnit-->
			<xsl:value-of select ="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!--PurchasePriceNet-->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<!--LabelPrice :: This is the price that is charged if items need to be labelled (usage mostly in fashion)-->
			<xsl:text>,</xsl:text>
			<!--LabelPriceCurrency-->
			
			<!--End of line-->
			<xsl:text>&#13;&#10;</xsl:text>
		
		</xsl:for-each>
		
	</xsl:template>
		
</xsl:stylesheet>
