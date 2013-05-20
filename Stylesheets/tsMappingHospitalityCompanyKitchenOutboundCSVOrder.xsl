<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to Company Kitchen CSV Outbound format.
'
' © ABS Ltd., 2013
'******************************************************************************************
' Module History
'******************************************************************************************
' Date		    | Name				   | Description of modification
'******************************************************************************************
' 07/05/2013	| Sahir Hussain	   | Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              xmlns:user="http://mycompany.com/mynamespace">
                              
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
		<!-- Row Type -->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Recipient's Code for Unit -->
		<xsl:apply-templates select="TradeSimpleHeader/RecipientsCodeForSender" />
		<xsl:text>,</xsl:text>
		
		<!-- Test Flag -->
		<xsl:choose>
			<xsl:when test="user:msToUpperCase(string(TradeSimpleHeader/TestFlag)) = 'FALSE' or
									TradeSimpleHeader/TestFlag = '0'">N</xsl:when>
			<xsl:otherwise>
				<xsl:text>Y</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Reference -->
		<xsl:apply-templates select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference" />
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Date -->
		<xsl:apply-templates select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate" />
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date -->
		<xsl:apply-templates select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot Start Time -->
		<xsl:apply-templates select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot End Time -->
		<xsl:apply-templates select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Contact -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ContactName" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Name -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToName" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 1 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 2 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 3 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 4 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4" />
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address PostCode -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode" />
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Lines -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
		<xsl:text>,</xsl:text>
		
		<!-- Recipients Branch Reference -->
		<xsl:apply-templates select="TradeSimpleHeader/RecipientsBranchReference" />
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- Line Detail -->
		<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
	</xsl:template>
	<xsl:template match="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate |
									 PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate |
									 PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart |
									 PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd">
		<xsl:variable name="delimeter">
			<xsl:choose>
				<xsl:when test="contains(node(),'PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart') or 
										contains(node(),'PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart')">:</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="translate(.,$delimeter,'')"/>
	</xsl:template>
	<xsl:template match="PurchaseOrderDetail/PurchaseOrderLine">
			<!-- Row Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Suppliers Product Code -->
			<xsl:apply-templates select="ProductID/SuppliersProductCode" />
			<xsl:text>,</xsl:text>
			
			<!-- Product Description -->
			<xsl:apply-templates select="ProductDescription" />
			<xsl:text>,</xsl:text>
			
			<!-- Pack Size -->
			<xsl:apply-templates select="PackSize" />
			<xsl:text>,</xsl:text>
			
			<!-- Quantity -->
			<xsl:value-of select="format-number(OrderedQuantity,0)"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit Price Excl VAT -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			
			<!-- Line Value Excl VAT -->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>
			
			<!-- UOM -->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="TradeSimpleHeader/RecipientsCodeForSender |
									 TradeSimpleHeader/RecipientsBranchReference |
									 ProductID/SuppliersProductCode">
		<xsl:if test="contains(.,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(string(.))"/>
		<xsl:if test="contains(.,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference |
									 PurchaseOrderHeader/ShipTo/ContactName |
									 PurchaseOrderHeader/ShipTo/ShipToName |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode |
									 ProductDescription |
									 PackSize">
									 
		<xsl:variable name="formatindex">
			<xsl:choose>
				<xsl:when test="contains(name(),'PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode')">9</xsl:when>
				<xsl:when test="contains(name(),'PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference')">32</xsl:when>
				<xsl:otherwise>40</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="formattedstring" select="user:msEscapeQuotes(substring(.,1,$formatindex))" />
		
		<xsl:if test="contains($formattedstring,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$formattedstring"/>
		<xsl:if test="contains($formattedstring,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>
	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			msEscapeQuotes = Replace(inputValue,"""","""" & """")
		End Function 
		
		Function msToUpperCase(inputValue)
			msToUpperCase = UCase(inputValue)
		End Function
	]]></msxsl:script>
</xsl:stylesheet>
