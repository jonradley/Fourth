<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml"/>
	<xsl:template match="/">	
		<Order>
			<xsl:attribute name="SiteCode"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/AztecSiteID"/></xsl:attribute>
			<xsl:attribute name="SiteRef"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/HardysSiteID"/></xsl:attribute>
			<xsl:attribute name="Supplier"><xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
			<xsl:attribute name="OrderNo"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
			<xsl:attribute name="OrderDate"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:attribute>
			<xsl:attribute name="DeliveryDate"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/></xsl:attribute>
			<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart">
				<xsl:attribute name="DeliveryTime"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="Lines"><xsl:value-of select="count(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected'])"/></xsl:attribute>
			<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT">
				<xsl:attribute name="Value"><xsl:value-of select="sum(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT)"/></xsl:attribute>
			</xsl:if>
			<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected']">
				<Line>
					<xsl:attribute name="LineNo"><xsl:value-of select="LineNumber"/></xsl:attribute>
					<xsl:attribute name="ImpExpRef"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
					<xsl:if test="ProductDescription">
						<xsl:attribute name="Description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="PackSize">
						<xsl:attribute name="PackSize"><xsl:value-of select="PackSize"/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name="Quantity"><xsl:value-of select="ConfirmedQuantity"/></xsl:attribute>
					<xsl:if test="UnitValueExclVAT">
						<xsl:attribute name="UnitCost"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>
					</xsl:if>
				</Line>
			</xsl:for-each>
		</Order>
	</xsl:template>
</xsl:stylesheet>
