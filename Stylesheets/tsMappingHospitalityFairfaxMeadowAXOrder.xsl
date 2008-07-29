<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="PurchaseOrder">
		<!-- Row Type -->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Recipient’s Code for Unit -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<!-- test flag -->
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">N</xsl:when>
			<xsl:otherwise>Y</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Purchase Order Reference -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Purchase Order Date YYYYMMDD -->
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<!-- Requested Delivery Date YYYYMMDD -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
		<xsl:text>,</xsl:text>
		<!--Delivery Slot Start Time HHMM -->
		<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
		<xsl:text>,</xsl:text>
		<!-- Delivery Slot End Time HHMM -->
		<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Contact -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Name -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Address Line 1 -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Address Line 2 -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Address Line 3 -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Address Line 4 -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Delivery Location Address PostCode -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Number of Lines -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		<!-- Number of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<!-- Recipient’s Branch Reference -->
		<xsl:text>&quot;</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
		<xsl:text>&quot;</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<!-- Row Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier’s Product Code -->
			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Product Description -->
			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Pack Size -->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!-- Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<!-- Unit Price Ex VAT -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<!-- Line Value Ex VAT -->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
