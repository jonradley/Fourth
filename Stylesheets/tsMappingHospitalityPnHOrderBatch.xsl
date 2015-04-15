<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/PurchaseOrder">
		
		<!-- 1.01 - Rectype -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- 1.02 - Store Code -->
		<xsl:value-of select="translate(TradeSimpleHeader/RecipientsCodeForSender,',','')"/>
		<xsl:text>,</xsl:text>

		<!-- 1.03 - Transmission Date -->
		<xsl:variable name="dtPODate">
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($dtPODate,9,2),substring($dtPODate,6,2),substring($dtPODate,1,4))"/>
		<xsl:text>,</xsl:text>

		<!-- 1.04 - Order Number -->
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		
		<!-- 1.05 - Type 2 Count -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>

		<!-- 1.06 - Order Type -->
		<xsl:text>T</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- 1.07 - Delivery Date -->
		<xsl:variable name="dtDelDate">
			<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($dtDelDate,9,2),substring($dtDelDate,6,2),substring($dtDelDate,1,4))"/>
		<xsl:text>,</xsl:text>
		
		<!-- 1.08 - SSP Delivery Time -->
		<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart != ''">
			<xsl:variable name="tmSlotStart">
				<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/>
			</xsl:variable>
			<xsl:value-of select="concat(substring($tmSlotStart,1,2),'.',substring($tmSlotStart,4,2))"/>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- 1.09 - SSP Vendor No -->
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/RecipientsBranchReference = '71504'">
				<xsl:text>504353</xsl:text>
			</xsl:when>
			<xsl:when test="TradeSimpleHeader/RecipientsBranchReference = '71502'">
				<xsl:text>504351</xsl:text>
			</xsl:when>
			<xsl:when test="TradeSimpleHeader/RecipientsBranchReference = '71503'">
				<xsl:text>504352</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>

		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
			<!-- 2.01 - Rectype -->
			<xsl:text>2</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- 2.02 - Order Line-Number -->
			<xsl:value-of select="LineNumber"/>
			<xsl:text>,</xsl:text>

			<!-- 2.03 - Order Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>

			<!-- 2.04 - Ordered SKU -->
			<xsl:value-of select="translate(ProductID/SuppliersProductCode,',','')"/>
			<xsl:text>,</xsl:text>

			<!-- 2.05 - Order GTIN -->
			<xsl:text>55555555555555</xsl:text>
			<xsl:text>,</xsl:text>

			<!-- 2.06 - Cost Price -->
			<xsl:value-of select="format-number(UnitValueExclVAT * 100,'0')"/>
			<xsl:text>&#13;&#10;</xsl:text>

			
		</xsl:for-each>
	
	</xsl:template>

</xsl:stylesheet>
