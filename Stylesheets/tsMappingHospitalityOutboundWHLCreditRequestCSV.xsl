<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Request for Credit mapper
'  Hospitality iXML to CSV Outbound format.
'
'******************************************************************************************
' Module History
'******************************************************************************************
' Date      	  | Name      	   		| Description of modification
'******************************************************************************************
' 26/02/2010  | Andrew Barber	| Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              xmlns:user="http://mycompany.com/mynamespace">
                              
	<xsl:output method="text"/>
	<xsl:template match="CreditRequest">
	
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

		<!-- Suppliers Name -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Address Line 1 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Address Line 2 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine1,2,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Address Line 3 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Address Line 4 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Address PostCode -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Supplier/SuppliersAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier VAT Number -->
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Name -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Address Line 1 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Address Line 2 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine1,2,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Address Line 3 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Address Line 4 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Buyer Address PostCode -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/Buyer/BuyersAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Credit Request Reference -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/CreditRequestReferences/CreditRequestReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/CreditRequestReferences/CreditRequestReference,1,32))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/CreditRequestReferences/CreditRequestReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Credit Request Date -->
		<xsl:value-of select="translate(CreditRequestHeader/CreditRequestReferences/CreditRequestDate,'-','')"/>
		<xsl:text>,</xsl:text>
		
		<!-- Invoice Reference -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/InvoiceReferences/InvoiceReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/InvoiceReferences/InvoiceReference,1,32))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/InvoiceReferences/InvoiceReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Invoice Date -->
		<xsl:value-of select="translate(CreditRequestHeader/InvoiceReferences/InvoiceDate,'-','')"/>
		<!--<xsl:value-of select="concat(substring(CreditRequestHeader/InvoiceReferences/InvoiceDate,7,4),
									substring(CreditRequestHeader/InvoiceReferences/InvoiceDate,4,2),
									substring(CreditRequestHeader/InvoiceReferences/InvoiceDate,1,2))"/>-->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Note Reference -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteReference,1,32))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Note Date -->
		<xsl:value-of select="translate(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteDate,'-','')"/>
		<!--<xsl:value-of select="concat(substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteDate,7,4),
									substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteDate,4,2),
									substring(CreditRequestHeader/DeliveryNoteReferences/DeliveryNoteDate,1,2))"/>-->
		<xsl:text>,</xsl:text>
		
		<!-- Currency -->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Name -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToName,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToName,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 1 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine1,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine1,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 2 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine2,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine2,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine1,2,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 3 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine3,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine3,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 4 -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine4,1,40))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/AddressLine4,1,40)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address PostCode -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/PostCode,1,9))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(CreditRequestHeader/ShipTo/ShipToAddress/PostCode,1,9)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Lines -->
		<xsl:value-of select="CreditRequestTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Items -->
		<!--<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>-->
		<xsl:value-of select="CreditRequestTrailer/NumberOfItems"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="CreditRequestTrailer/TotalExclVAT"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="CreditRequestDetail/CreditRequestLine">
		
			<!-- Row Type -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Line Status -->
			<xsl:if test="@LineStatus='QuantityChanged'">
				<xsl:text>Q</xsl:text>
			</xsl:if>
			<xsl:if test="@LineStatus='PriceChanged'">
				<xsl:text>P</xsl:text>
			</xsl:if>
			<xsl:if test="@LineStatus='Rejected'">
				<xsl:text>R</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Reason for Request -->
			<xsl:if test="contains(user:msEscapeQuotes(substring(Narrative,1,60)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(Narrative,1,60))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(Narrative,1,60)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Purchase Order Reference -->
			<xsl:if test="contains(user:msEscapeQuotes(substring(../../CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:value-of select="user:msEscapeQuotes(substring(../../CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32))"/>
			<xsl:if test="contains(user:msEscapeQuotes(substring(../../CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
				<xsl:text>"</xsl:text>
			</xsl:if>
			<xsl:text>,</xsl:text>
			
			<!-- Purchase Order Date -->
			<xsl:value-of select="translate(../../CreditRequestHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
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
			
			<!-- Quantity -->
			<xsl:value-of select="format-number((RequestedQuantity*PackSize), '0')"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit Price Excl VAT -->
			<xsl:value-of select="format-number((UnitValueExclVAT div PackSize), '0.0000')"/>
			<xsl:text>,</xsl:text>
			
			<!-- Line Value Excl VAT -->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
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
