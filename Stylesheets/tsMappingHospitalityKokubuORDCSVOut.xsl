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
 10/12/2017		| M Dimant		| FB12153: Add quotes around descriptions. Map UOM to supplier's format.
=======================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-ltd.com/blah">
	
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	<xsl:template match="/">
	
		<xsl:for-each select="//PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- 伝票番号 A Purchase order number -->	
			<xsl:value-of select="//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 行番号 B Line# -->	
			<xsl:value-of select="LineNumber"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 発注日 C Order Date -->
			<xsl:value-of select="translate(//PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 納品日 D Delivery Date -->	
			<xsl:value-of select="translate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 取引先コード E Vendor -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 伝票区分 F Order Classification -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 分類コード G Category -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- センターコード H Warehouse# -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 店舗コード I Destination# -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 商品コード J Product# -->
			<xsl:choose>
				<xsl:when test="contains(ProductID/BuyersProductCode,'-')">
					<xsl:value-of select="substring-before(ProductID/BuyersProductCode,'-')"/>	
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="ProductID/BuyersProductCode"/>	
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 商品名全角 K Product Description -->
			<xsl:text>"</xsl:text>
			<xsl:call-template name="msQuotes">
				<xsl:with-param name="vs" select="ProductDescription"/>
			</xsl:call-template>			
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 商品名半角 L Product Description -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 規格全角 M Product Info1 -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 規格半角 N Product Info2 -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 発注単位 O Order Unit (EA=3, CS=1) -->	
			<xsl:variable name="UOM" select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:choose>
				<xsl:when test="$UOM='EA'">
					<xsl:text>3</xsl:text>
				</xsl:when>
				<xsl:when test="$UOM='CS'">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$UOM"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
						
			<!-- 発注数 P Quantity of order Unit -->	
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 発注総バラ数量 Q Total order pieces -->	
			<xsl:value-of select="PackSize"/>	
			<xsl:value-of select="$FieldSeperator"/>
					
			<!-- 納品単位 R Delivery unit -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 発注単価 S Order unit Price -->
			<xsl:value-of select="UnitValueExclVAT"/>	
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 発注金額 T Order amount -->	
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:value-of select="$FieldSeperator"/>
						
			<!-- 納品単価 U Delivery unit price -->
			<xsl:value-of select="$FieldSeperator"/>
								
			<!-- 納品金額 V Delivery amount -->	
			<xsl:value-of select="$FieldSeperator"/>
							
			<!-- 納品重量 X Delivery weight -->	
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:for-each>				
		
	</xsl:template>


	<!-- Remove double quotes -->
	<xsl:template name="msQuotes">
		<xsl:param name="vs"/>
	
		<xsl:choose>
	
		  <xsl:when test="$vs=''"/>
		  <!-- base case-->
	
		  <xsl:when test="substring($vs,1,1)='&quot;'">
			<!-- " found -->
			<xsl:value-of select="substring($vs,1,1)"/>
			<xsl:value-of select="'&quot;'"/>
			<xsl:call-template name="msQuotes">
			  <xsl:with-param name="vs" select="substring($vs,2)"/>
			</xsl:call-template>
		  </xsl:when>
	
		  <xsl:otherwise>
			<!-- other character -->
			<xsl:value-of select="substring($vs,1,1)"/>
			<xsl:call-template name="msQuotes">
			  <xsl:with-param name="vs" select="substring($vs,2)"/>
			</xsl:call-template>
		  </xsl:otherwise>
		</xsl:choose>
	
	 </xsl:template>
	 
</xsl:stylesheet>
