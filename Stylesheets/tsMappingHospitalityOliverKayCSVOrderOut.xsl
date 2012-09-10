<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:template match="PurchaseOrder">
		
		<!-- 1. Order Header Record Type -->	
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- 2. Customer Code -->
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<!-- 3. Order Type -->
		<xsl:text>05</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- 4. Customer Order Number -->
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<!-- 5. Delivery Date -->
		<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>

		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
			<!-- 1 Order Detail Line Record Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- 2 Product Code -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			
			<!-- 3 Order Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<xsl:text>0</xsl:text>
			
			<xsl:text>&#13;&#10;</xsl:text>	
		
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="decodeUoM">
		<xsl:param name="inUoM"/>
		<xsl:choose>
			<xsl:when test="$inUoM = 'KGM'">KG</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inUoM"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>
