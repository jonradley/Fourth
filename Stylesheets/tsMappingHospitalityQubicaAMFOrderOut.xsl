<?xml version="1.0" encoding="UTF-8"?>

<!--*********************************************************************
tradesimple internalorder  to QubicaAMF ORDERS spec map
*************************************************************************
Name		| Date       | Change
*************************************************************************
A Barber	| 01/02/2010 | Created.
**********************************************************************
Mark E	| 01/02/2010 | Modified
**********************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/">
	
		<!--Header - Order Number-->
		<xsl:text>SYEDOC</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/>
		<xsl:text>,</xsl:text>
		<!--Order Type-->
		<xsl:text>SYEDCT</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>SP</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Sold To-->
		<xsl:text>SYSHAN</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!-- Order Date -->
		<xsl:text>SYTRDJ</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:variable name="PODate" select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		<xsl:value-of select="concat(substring($PODate,9,2),
									'/',substring($PODate,6,2),
									'/',substring($PODate,1,4))"/>
		<xsl:text>,</xsl:text>									
		<!--PO-->
		<xsl:text>SYVR01</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>SP</xsl:text>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>/</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Currency, fixed to 'GBP'-->
		<xsl:text>SYCRCD</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>GBP</xsl:text>
		
		<!--End of line-->			
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Purchase Order Lines-->	
		<xsl:for-each select="PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!--Order No-->
			<xsl:text>SZEDOC</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="//..//PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/>
			<xsl:text>,</xsl:text>
			<!--Order Type-->
			<xsl:text>SZEDCT</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>SP</xsl:text>
			<xsl:text>,</xsl:text>			
			<!--LineNumber-->
			<xsl:text>SZEDLN</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="LineNumber"/>
			<xsl:text>,</xsl:text>
			<!-- Ship To-->
			<xsl:text>SZSHAN</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="//..//PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:text>,</xsl:text>
			<!-- Order Date-->
			<xsl:text>SZTRDJ</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="concat(substring(//..//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,9,2),
									'/',substring(//..//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,6,2),
									'/',substring(//..//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,1,4))"/>
			<xsl:text>,</xsl:text>
			<!--PO-->
			<xsl:text>SZVR02</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>SP</xsl:text>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="//..//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="LineNumber"/>
			<xsl:text>/</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Item-->
			<xsl:text>SZLITM</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<!--UOM-->
			<xsl:text>SZUOM</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select ="PackSize"/>
			<xsl:text>,</xsl:text>
			<!--OrderedQuantity-->
			<xsl:text>SZUORG</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select ="format-number(OrderedQuantity,'0.0000')"/>
			<!--End of line-->
			<xsl:text>&#13;&#10;</xsl:text>
		
		</xsl:for-each>
		
	</xsl:template>
		
</xsl:stylesheet>
