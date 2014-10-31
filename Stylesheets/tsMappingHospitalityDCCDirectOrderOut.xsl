<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2008-05-22		| 2245 Created Module
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:order="urn:ean.ucc:order:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
	<xsl:output method="text" encoding="UTF-8" />
	
	<xsl:template match="/">
	
		<!-- 
		MTO,MTOUNIT01,PO-123456,080416,080421
		 -->		 
		 
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>&#13;&#10;</xsl:text>

		<!-- 	
		MTOUNIT001,PO-123456,080416,080421, 
		MTOLB0112,6,1 
		MTOLS0412/R,5,2 
		MTOLB0210,4,3 
		 -->
		 
		<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
		
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="position()"/>
			<xsl:if test="position() != last()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>

		
		</xsl:for-each>
	
	
	</xsl:template>
	
	
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		
		<xsl:value-of select="concat(substring($date,3,2),substring($date,6,2),substring($date,9,2))"/>
	
	</xsl:template>

	
</xsl:stylesheet>
