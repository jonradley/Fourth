<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="PurchaseOrder">
	
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		
		<!--File Header-->
		<xsl:text>ENV001</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>ORDER</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="$NewLine"/>
		
		<!--Batch Header-->
		<xsl:text>000010</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>ORDHDR</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<!--GLN-->
		<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN[1]"/>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="$NewLine"/>
		
		<xsl:for-each select="PurchaseOrderHeader">
		
			<!--Order Header-->
			<xsl:text>000011</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>ORDERS</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<!--Order Number-->
			<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>*</xsl:text>
			<!--Concept Code-->
			<xsl:text>SP</xsl:text>
			<xsl:text>*</xsl:text>
			<!--Delivery Date-->
			<xsl:value-of select="substring(OrderedDeliveryDetails/DeliveryDate,3,2)"/>
			<xsl:value-of select="substring(OrderedDeliveryDetails/DeliveryDate,6,2)"/>
			<xsl:value-of select="substring(OrderedDeliveryDetails/DeliveryDate,9,2)"/>
			<xsl:text>*</xsl:text>
			<!--Order Date-->
			<xsl:value-of select="substring(PurchaseOrderReferences/PurchaseOrderDate,3,2)"/>
			<xsl:value-of select="substring(PurchaseOrderReferences/PurchaseOrderDate,6,2)"/>
			<xsl:value-of select="substring(PurchaseOrderReferences/PurchaseOrderDate,9,2)"/>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$NewLine"/>
			
			<!--Order Detail-->
			<xsl:for-each select="../PurchaseOrderDetail/PurchaseOrderLine">
			
				<xsl:text>000020</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<!--Product Code-->
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<!--Quantity-->
				<xsl:value-of select="OrderedQuantity"/>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:text>*</xsl:text>
				<xsl:value-of select="$NewLine"/>
				
			</xsl:for-each>
			
			<!--Delivery Detail 1-->
			<xsl:text>000025</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>1</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:value-of select="ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$NewLine"/>
			
			<!--Delivery Detail 2-->
			<xsl:text>000025</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>2</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$NewLine"/>
			
			<!--Order Trailer-->
			<xsl:text>000030</xsl:text>
			<xsl:text>*</xsl:text>
			<!--Number of Order Detail Lines-->
			<xsl:value-of select="count(//PurchaseOrderLine)"/>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:text>*</xsl:text>
			<xsl:value-of select="$NewLine"/>
			
		</xsl:for-each>
		
		<!--Batch Trailer-->
		<xsl:text>000040</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>ORDTLR</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="$NewLine"/>
		
		<!--File Trailer-->
		<xsl:text>000050</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<!--Number of Order Header Records-->
		<xsl:value-of select="count(//PurchaseOrder)"/>
		<xsl:text>*</xsl:text>
		<!--Number of Units Ordered-->
		<xsl:value-of select="sum(//OrderedQuantity)"/>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:text>*</xsl:text>
		<xsl:value-of select="$NewLine"/>

	</xsl:template>
	
</xsl:stylesheet>
