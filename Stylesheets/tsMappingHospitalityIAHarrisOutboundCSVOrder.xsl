<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 $Header: $ $NoKeywords: $
 Overview 
  Adapted from tsMappingHospitalityMainstreamOutboundCSVOrder.xsl

 © ABS Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 03/04/2008  | R Cambridge  | 2079 Created
******************************************************************************************
             |              | 
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              xmlns:user="http://mycompany.com/mynamespace">
                              
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
	
		<xsl:variable name="one_quote">"</xsl:variable>
		<xsl:variable name="two_quotes">""</xsl:variable>
	
		<!-- Row Type -->
		<xsl:text>"H"</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Recipient's Code for Unit -->
		<xsl:value-of select="user:msEscapeQuotes(string(TradeSimpleHeader/RecipientsCodeForSender))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Test Flag -->
		<xsl:text>"</xsl:text>
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = '0'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'False'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'FALSE'">N</xsl:when>
			<xsl:otherwise>
				<xsl:text>Y</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>",</xsl:text>
		
		<!-- Purchase Order Reference -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Date -->
		<xsl:value-of select="user:msEscapeQuotes(translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-',''))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date -->
		<xsl:value-of select="user:msEscapeQuotes(translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-',''))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot Start Time -->
		<xsl:value-of select="user:msEscapeQuotes(translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart,':',''))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot End Time -->
		<xsl:value-of select="user:msEscapeQuotes(translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd,':',''))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Contact -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ContactName,1,40))"/>
		<xsl:text>,</xsl:text>

		<!-- Delivery Location Name -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToName,1,40))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 1 -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1,1,40))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 2 -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2,1,40))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 3 -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3,1,40))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 4 -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4,1,40))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address PostCode -->
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode,1,9))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Lines -->
		<xsl:value-of select="string(PurchaseOrderTrailer/NumberOfLines)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="string(PurchaseOrderTrailer/TotalExclVAT)"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- Row Type -->
			<xsl:text>"D"</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Suppliers Product Code -->
			<xsl:value-of select="user:msEscapeQuotes(string(ProductID/SuppliersProductCode))"/>
			<xsl:text>,</xsl:text>
			
			<!-- Product Description -->
			<xsl:value-of select="user:msEscapeQuotes(substring(ProductDescription,1,40))"/>
			<xsl:text>,</xsl:text>
			
			<!-- Pack Size -->
			<xsl:value-of select="user:msEscapeQuotes(substring(PackSize,1,40))"/>
			<xsl:text>,</xsl:text>
			
			<!-- Quantity -->
			<xsl:value-of select="string(OrderedQuantity)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit Price Excl VAT -->
			<xsl:value-of select="string(UnitValueExclVAT)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Line Value Excl VAT -->	
			<xsl:value-of select="string(LineValueExclVAT)"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
	</xsl:template>

	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			Dim sReturn
				       	
			'sReturn = inputValue.item(0).nodeTypedValue
			sReturn = inputValue
	      		msEscapeQuotes = """" & Replace(sReturn,"""","""" & """") & """"
			
			End Function 
	]]></msxsl:script>

</xsl:stylesheet>
