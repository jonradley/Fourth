<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to Venus pip separated format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 06/12/2012  | KO  | Created
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
	
	<!--Row type-->
	<xsl:text>ORH</xsl:text>
	<xsl:text>|</xsl:text>
	
	<!--Order date YYYYMMDD-->
	<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
	<xsl:text>|</xsl:text>
	
	<!--Suppliers code for unit-->
	<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
	<xsl:text>|</xsl:text>
	
	<!--Customer name-->
	<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
	<xsl:text>|</xsl:text>
	
	<!--Requested delivery date-->
	<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
	<xsl:text>|</xsl:text>
	
	<!--Purchase order reference-->
	<xsl:text>OR_</xsl:text>
	<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
	<xsl:text>&#13;&#10;</xsl:text>
	
	<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
	
		<!--Row type-->
		<xsl:text>ORD</xsl:text>
		<xsl:text>|</xsl:text>
		
		<!--Product code-->
		<xsl:value-of select="ProductID/SuppliersProductCode"/>
		<xsl:text>|</xsl:text>
		
		<!--Product level 1, has to be set to 0-->
		<xsl:text>0</xsl:text>
		<xsl:text>|</xsl:text>
	
		<!--Product level 2, has to be set to 0-->
		<xsl:text>0</xsl:text>
		<xsl:text>|</xsl:text>
		
		<!--unit of measure-->
		<xsl:choose>
			<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">
				<xsl:text>2</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>1</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>|</xsl:text>
		
		<!--Pack size-->
		<!--xsl:call-template name="characterStrip">
			<xsl:with-param name="inputText" select="substring-before(PackSize,'x')"/>
		</xsl:call-template-->
		<xsl:text>|</xsl:text>
		
		<!--Barcode-->
		<xsl:choose>
			<xsl:when test="ProductID/GTIN != '55555555555555'">
				<xsl:value-of select="ProductID/GTIN"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>|</xsl:text>
		
		<!--Quantity-->
		<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
		<xsl:text>|</xsl:text>
		<xsl:text>|</xsl:text>
	
	<xsl:text>&#13;&#10;</xsl:text>
	
	</xsl:for-each>	
	
	<!--Row type-->
	<xsl:text>ORT</xsl:text>
	<xsl:text>|</xsl:text>
	
	<!--Date-->
	<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
	<xsl:text>|</xsl:text>

	<!--Line count-->
	<xsl:value-of select="count(PurchaseOrderDetail/PurchaseOrderLine)"/>
		
	</xsl:template>
	
	<!--xsl:template name="characterStrip">
		<xsl:param name="inputText"/>
		<xsl:choose>
			<xsl:when test="$inputText = ''"/>
			<xsl:otherwise>
				<xsl:variable name="firstCharacter" select="substring($inputText,1,1)"/>
				<xsl:choose>
					<xsl:when test="translate($firstCharacter,'-/','') = ''">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="translate($firstCharacter,'1234567890','') = ''">
						<xsl:value-of select="$firstCharacter"/>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="characterStrip">
					<xsl:with-param name="inputText" select="substring($inputText,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template-->

</xsl:stylesheet>
