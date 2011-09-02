<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************************************************
Alterations
*******************************************************************************************************************************
Name			| Date				| Change
*******************************************************************************************************************************
M Dimant 	|   20/07/2010		| 3776 Created Module. Builds an asterisk delimited order for use in Socretes.
*******************************************************************************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/PurchaseOrder">

		<!--ENVELOPE HEADER-->
		<xsl:text>ENV001*ORDER******</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--BATCH HEADER-->
		<xsl:text>000010*ORDHDR**</xsl:text>
		<!--xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/-->
		<xsl:text>**</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>

		<!--ORDER HEADER-->
		<xsl:text>000015*ORDERS***</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>*CC*</xsl:text>
		<xsl:value-of select="translate(substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,3,8),'-','')"/>
		<xsl:text>*******</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
				
				
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!--ORDER DETAIL-->
			<xsl:text>000020**</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>**</xsl:text>
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>*************</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!--DELIVERY DETAIL-->
			<xsl:text>000025*1*</xsl:text>
			<xsl:value-of select="//TradeSimpleHeader/RecipientsCodeForSender"/>
			<xsl:text>***********</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
			<xsl:text>000025*2*********</xsl:text>
			<xsl:text>&#13;&#10;</xsl:text>
	
		</xsl:for-each>		
		
		<!--ORDER TRAILER-->
		<xsl:text>000030*</xsl:text>
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>***</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<!--BATCH TRAILER-->
		<xsl:text>000040*ORDTLR****</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>

		<!--ENVELOPE TRAILER-->
		<xsl:text>000050*1*1*</xsl:text>
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>****</xsl:text>
		
	</xsl:template>
</xsl:stylesheet>
