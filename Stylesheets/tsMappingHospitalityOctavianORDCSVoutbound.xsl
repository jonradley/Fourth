<?xml version="1.0" encoding="UTF-8"?>
<!--*************************************************************************
Date	|	Name	|	Comment	
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		|			|
***************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="ascii"/>
	<xsl:template match="/PurchaseOrder">
	
		<!--Message header-->
		<xsl:text>"HEADER"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Cert Octavian warehouse code-->
		<xsl:text>"OCT"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Cert Octavian customer/owner code-->
		<xsl:text>"</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Date order raised YYYYMMDD-->
		<xsl:text>"</xsl:text>
		<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Customer's order number-->
		<xsl:text>"</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Consignee's order number/reference -->
		<xsl:text>"</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Delivery point name -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToName != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Address 1 -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>	
		<!--Address 2 -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>	
		<!--Address 3 -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Address 4 -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Postcode-->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<!--Delivery Date -->
		<xsl:text>"</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Delivery Code -->
		<xsl:text>"DUTY PAID"</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Excise Number / Deferment Account Number - alway blank as not appicable-->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Delivery Text 1 -->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 	
		<!--Delivery Text 2 -->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Delivery Text 3 -->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Delivery Text 4 -->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Booking In Name -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/ShipTo/ContactName != '' ">
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Booking In Phone Number-->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text> 
		<!--Booking In Date -->
		<xsl:text>""</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!--Line detail-->
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:text>"DETAIL"</xsl:text>
			<xsl:text>,</xsl:text>
			<!--Line Number -->
			<xsl:text>"</xsl:text>
				<xsl:value-of select="LineNumber"/>
			<xsl:text>"</xsl:text>
			<xsl:text>,</xsl:text> 
			<!--Product Code -->
			<xsl:text>"</xsl:text>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>"</xsl:text>
			<xsl:text>,</xsl:text> 
			<!--Rotation NA-->
			<xsl:text>""</xsl:text>
			<xsl:text>,</xsl:text> 
			<!--Quantity -->		
			<xsl:text>"</xsl:text>
				<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>"</xsl:text>
			<xsl:text>,</xsl:text> 	
			<!--Unit Of Measure -->
			<xsl:text>"</xsl:text>
			<xsl:call-template name="decodeUOM">
				<xsl:with-param name="dcUOM" select="OrderedQuantity/@UnitOfMeasure"/>
			</xsl:call-template>	
			<xsl:text>"</xsl:text>
			<xsl:text>,</xsl:text>
			<!--Case Sales value NA-->
			<xsl:text>""</xsl:text>
			<xsl:text>,</xsl:text> 
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>	
		
	</xsl:template>
	
<!--=======================================================================================
  Routine        : msFormateDate()
  Description    :  
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : Katherine OShaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormateDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''), 0)"/>
	
	</xsl:template>	
	
<!--=======================================================================================
  Routine        : Decode UOM
  Description    :  
  Inputs         : vsUOM
  Outputs        : 
  Returns        : A string
  Author         : Katherine OShaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="decodeUOM">
		<xsl:param name="dcUOM"/>
		<xsl:choose>
			<xsl:when test="$dcUOM = 'EA'">
				<xsl:text>UNITS</xsl:text>
			</xsl:when>
			<xsl:when test="$dcUOM = 'CS'">
				<xsl:text>CASES</xsl:text>
			</xsl:when>
			<xsl:otherwise>UNITS</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
