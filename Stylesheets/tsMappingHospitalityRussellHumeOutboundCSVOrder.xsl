<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 23/01/2012  | K O'Shaughnessy  | Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              xmlns:user="http://mycompany.com/mynamespace">
                              
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
	
		<xsl:variable name="one_quote">"</xsl:variable>
		<xsl:variable name="two_quotes">""</xsl:variable>
	
		<!-- Row Type -->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Recipient's Code for Unit -->
		<xsl:if test="contains(TradeSimpleHeader/RecipientsCodeForSender,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(string(TradeSimpleHeader/RecipientsCodeForSender))"/>
		<xsl:if test="contains(TradeSimpleHeader/RecipientsCodeForSender,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Test Flag -->
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = '0'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'False'">N</xsl:when>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'FALSE'">N</xsl:when>
			<xsl:otherwise>
				<xsl:text>Y</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Reference -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Purchase Order Date -->
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot Start Time -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart,':','')"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Slot End Time -->
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd,':','')"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Contact -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ContactName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ContactName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>

		<!-- Delivery Location Name -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 1 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 2 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 3 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 4 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address PostCode -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Lines -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
		<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
			<xsl:text>,</xsl:text>
			<xsl:call-template name="characterStrip">
				<xsl:with-param name="inputText" select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,1,120)"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- Row Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Suppliers Product Code -->
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(string(ProductID/SuppliersProductCode))"/>
			<xsl:if test="contains(user:msEscapeQuotes(string(ProductID/SuppliersProductCode)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Product Description -->
			<xsl:if test="contains(user:msEscapeQuotes(substring(ProductDescription,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(ProductDescription,1,40))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(ProductDescription,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Pack Size -->
			<xsl:if test="contains(user:msEscapeQuotes(substring(PackSize,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(PackSize,1,40))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(PackSize,1,40)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit Price Excl VAT -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			
			<!-- Line Value Excl VAT -->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>
			
			<!--UOM-->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="characterStrip">
		<xsl:param name="inputText"/>
		<xsl:choose>
			<xsl:when test="$inputText = ''"/>
			<xsl:otherwise>
				<xsl:variable name="firstCharacter" select="substring($inputText,1,1)"/>
				<xsl:choose>
					<xsl:when test="translate($firstCharacter,'-/','') = ''">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="translate($firstCharacter,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890(). ','') = ''">
						<xsl:value-of select="$firstCharacter"/>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="characterStrip">
					<xsl:with-param name="inputText" select="substring($inputText,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			Dim sReturn
				       	
			'sReturn = inputValue.item(0).nodeTypedValue
			sReturn = inputValue
	      		msEscapeQuotes = Replace(sReturn,"""","""" & """")
			
			End Function 
	]]></msxsl:script>

</xsl:stylesheet>
