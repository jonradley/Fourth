<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================================================================
Overview

Outbound Purchase Orders in CSV based on Kokubu CSV format.


==========================================================================================================================================
 Module History
==========================================================================================================================================
 Date			| Name 			| Description of modification
==========================================================================================================================================
 20/04/2017		| M Dimant		| FB11686: Created.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 				| 
=======================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	<xsl:template match="/">
	
		<xsl:for-each select="//PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- 伝票番号 Purchase order number -->	
			<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 行番号 Line# -->	
			<xsl:value-of select="LineNumber"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 発注日 Order Date -->
			<xsl:value-of select="translate(//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 納品日 Delivery Date -->	
			<xsl:value-of select="translate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 取引先コード Vendor -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 伝票区分 Order Classification -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 分類コード Category -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- センターコード Warehouse# -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 店舗コード Destination# -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 商品コード Product# -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 商品名全角 Product Description -->
			<xsl:value-of select="ProductDescription"/>	
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 商品名半角 Product Description -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 規格全角 Product Info1 -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 規格半角 Product Info2 -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 発注単位 Order Unit -->	
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>	
			<xsl:value-of select="$FieldSeperator"/>
						
			<!-- 発注数 Quantity of order Unit -->	
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 発注総バラ数量 Total order pieces -->	
			<xsl:value-of select="PackSize"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 納品単位 Delivery unit -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 発注単価 Order unit Price -->
			<xsl:value-of select="UnitValueExclVAT"/>	
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 発注金額 Order amount -->	
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:value-of select="$FieldSeperator"/>
						
			<!-- 納品単価 Delivery unit price -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 納品金額 Delivery amount -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 納品重量 Delivery weight -->	
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:for-each>				
		
	</xsl:template>


</xsl:stylesheet>
