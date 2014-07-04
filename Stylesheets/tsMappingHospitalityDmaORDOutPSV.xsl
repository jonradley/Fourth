<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to ITN pipe separated format.
'
' © Fourth Ltd., 2013.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 04/07/2014  | Jose Miguel  | FB 7566: Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
		<!--Row type-->
		<xsl:text>H</xsl:text>
		<xsl:text>|</xsl:text>
		<!--PO number - ‘H’ (constant) for PO Header record -->
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference, '|', '¦')"/>
		<xsl:text>|</xsl:text>
		<!--Distributor Center Id - Distribution Center/Warehouse ID provided by ITN -->
		<xsl:value-of select="translate(TradeSimpleHeader/RecipientsBranchReference, '|', '¦')"/>
		<xsl:text>|</xsl:text>
		<!--Customer Number - Distributor Customer Number -->
		<xsl:value-of select="translate(PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode, '|', '¦')"/>
		<xsl:text>|</xsl:text>
		<!--Delivery Date - Requested Delivery Date of order ‘yyyymmdd’ -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-', '')"/>
		<xsl:text>|</xsl:text>
		<!--Special Intructions - Special Instructions/Notes -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions, '|', '¦')"/>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
	</xsl:template>
	<xsl:template match="PurchaseOrderDetail/PurchaseOrderLine">
		<!--Row type-->
		<xsl:text>I</xsl:text>
		<xsl:text>|</xsl:text>
		<!--Distributor Item Number - Distributors assigned item number -->
		<xsl:call-template name="GetProductCode">
			<xsl:with-param name="str" select="translate(ProductID/SuppliersProductCode, '|', '¦')"/>
		</xsl:call-template>
		<xsl:text>|</xsl:text>
		<!--Chain Item Number - Chain Product/Item number -->
		<xsl:value-of select="translate(ProductID/BuyersProductCode, '|', '¦')"/>
		<xsl:text>|</xsl:text>
		<!--Quantity Ordered	N	4,0	Quantity Ordered (Integer, no decimals) -->
		<xsl:value-of select="format-number(OrderedQuantity, '####')"/>
		<xsl:text>|</xsl:text>
		<!-- Break Level logic 
			When we see a a product code with a ~ -> take the value after the ~ for the break level
			if not ~ not break level.-->
		<xsl:call-template name="GetBreakLevelIndicator">
			<xsl:with-param name="str" select="translate(ProductID/SuppliersProductCode, '|', '¦')"/>
		</xsl:call-template>		
		<xsl:text>|</xsl:text>
		<!--Unit of measure -->
		<xsl:choose>
			<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">
				<xsl:text>CA</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>|</xsl:text>
		<!--BreakLevel Indicator	A	1	Indicates how the item is being ordered.
			‘0’ – Main/Case (default)
			‘1’ – Split/BrokenCase/Each
			
			Unit of Measure	A	2 	UOM Code
			‘CA’ – Main/Case
			‘EA’ – BrokenCase/Each
			
			Only for distributor items that are Case-breakable.	O**	 
		-->
		<!--	<xsl:choose>	
			<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">
				-->
		<!--Breaklevel Indicator-->
		<!--
				<xsl:text>0</xsl:text>
				<xsl:text>|</xsl:text>
				-->
		<!--Unit of measure -->
		<!--
				<xsl:text>CA</xsl:text>
				<xsl:text>|</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				-->
		<!--Breaklevel Indicator-->
		<!--
				<xsl:text>1</xsl:text>
				<xsl:text>|</xsl:text>
				-->
		<!--Unit of measure -->
		<!--
				<xsl:text>EA</xsl:text>
				<xsl:text>|</xsl:text>
			</xsl:otherwise>
		</xsl:choose>-->
		<!--Price	A	10	Unit price of the Item based on the BreakLevel or UOM. Must include the decimal point character ‘.’  Maximum of 4 decimals. ‘nnnnn.nnnn'-->
		<xsl:value-of select="format-number(UnitValueExclVAT, '#.####')"/>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<xsl:template name="GetProductCode">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, '~')">
				<xsl:value-of select="substring-before($str, '~')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GetBreakLevelIndicator">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, '~')">
				<xsl:value-of select="substring-after($str, '~')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
</xsl:stylesheet>
