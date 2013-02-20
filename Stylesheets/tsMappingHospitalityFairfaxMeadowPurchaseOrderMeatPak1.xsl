<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text"/>
	
	<xsl:template match="PurchaseOrder">
	
		<xsl:text>START</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- Record Type -->
		<xsl:text>H</xsl:text>
		<xsl:text>|</xsl:text>
		<!-- Purchase Order Ref -->
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>|</xsl:text>
		<!-- Purchase Order Date -->
		<xsl:variable name="sPODate">
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($sPODate,1,4),substring($sPODate,6,2),substring($sPODate,9,2))"/>
		<xsl:text>|</xsl:text>
		<!-- Delivery Date -->
		<xsl:variable name="sDelDate">
			<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($sDelDate,1,4),substring($sDelDate,6,2),substring($sDelDate,9,2))"/>
		<xsl:text>|</xsl:text>
		<!-- OrderedBy -->
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
		<xsl:text>|</xsl:text>
		<!-- Email -->
		<xsl:text>|</xsl:text>
		<!-- Phone -->
		<xsl:text>|</xsl:text>
		<!-- Order method -->
		<xsl:text>O</xsl:text>
		<xsl:text>|</xsl:text>
		<!-- Account -->
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>&#13;&#10;</xsl:text>


		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- Record type -->
			<xsl:text>L</xsl:text>
			<xsl:text>|</xsl:text>
			
			<!-- Product Code -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>|</xsl:text>

			<!-- Product Title -->
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>|</xsl:text>

			<!-- Price -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>|</xsl:text>
			
			<!-- Qty -->
			<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
			<xsl:text>&#13;&#10;</xsl:text>

		
		</xsl:for-each>
	
		<!-- Record Type -->
		<xsl:text>N</xsl:text>
		<xsl:text>|</xsl:text>
		
		<!-- Notes -->
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions != ''">
				<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
			</xsl:when>
			<xsl:otherwise>NONE</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>

		<xsl:text>END</xsl:text>
	
	</xsl:template>

</xsl:stylesheet>
