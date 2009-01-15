<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="PurchaseOrder">
		<!-- Requested Delivery Date YYYYMMDD -->
		<xsl:variable name="DelDate">
			<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
		</xsl:variable>
		<!-- Harvey Nicks' Site Code-->
		<xsl:variable name="SiteCode">
			<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		</xsl:variable>
		<!-- External Identifier-->
		<xsl:variable name="ExternalID">
			<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		</xsl:variable>

		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<xsl:value-of select="$ExternalID"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DelDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$SiteCode"/>
			<xsl:text>,,,,,,,,,</xsl:text>
			<!-- Merret SKU-->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<!-- Qty Requested-->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>&#13;&#10;</xsl:text>

		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
