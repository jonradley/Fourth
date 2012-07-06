<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
 Overview 
  XSL Purchase Order mapper
  Hospitality iXML to Underwoods CSV Outbound format.

 © ABS Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name         | Description of modification
******************************************************************************************
 13/09/2005  	| Calum Scott  | Created
******************************************************************************************
 10/10/2005  	| Lee Boyton   | Corrected delivery date element name.
******************************************************************************************
 22/03/2007		| Nigel Emsen	| FogBuzz: 933 Correct Address line output.
******************************************************************************************
 22/08/2007  	| R Cambridge 	| 1331 Added recipients branch reference
******************************************************************************************
08/12/2008		| Lee Boyton	| 2602. Branched to handle HTML break characters.
******************************************************************************************
        			|             	| 
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
		<xsl:apply-templates select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
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
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ContactName"/>
		<xsl:text>,</xsl:text>

		<!-- Delivery Location Name -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToName"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 1 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 2 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 3 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address Line 4 -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Location Address PostCode -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Lines -->
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>,</xsl:text>
		
		<!-- Number Of Items -->
		<xsl:value-of select="sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Total Ex VAT -->
		<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
		
		<!-- Recipient's Branch Reference -->
		<xsl:if test="string(TradeSimpleHeader/RecipientsBranchReference) != ''">	
			<xsl:text>,</xsl:text>	
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
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
			<xsl:apply-templates select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			
			<!-- Pack Size -->
			<xsl:apply-templates select="PackSize"/>
			<xsl:text>,</xsl:text>
			
			<!-- Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			
			<!-- Unit Price Excl VAT -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			
			<!-- Line Value Excl VAT -->
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ContactName | ShipToName | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | ProductDescription | PackSize">
		<xsl:variable name="textOutput">
			<xsl:value-of select="user:msEscapeQuotes(substring(user:msStripHTMLBreaks(string(.)),1,40))"/>
		</xsl:variable>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$textOutput"/>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="PurchaseOrderReference">
		<xsl:variable name="textOutput">
			<xsl:value-of select="user:msEscapeQuotes(substring(user:msStripHTMLBreaks(string(.)),1,32))"/>
		</xsl:variable>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$textOutput"/>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="PostCode">
		<xsl:variable name="textOutput">
			<xsl:value-of select="user:msEscapeQuotes(substring(user:msStripHTMLBreaks(string(.)),1,9))"/>
		</xsl:variable>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="$textOutput"/>
		<xsl:if test="contains($textOutput,',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="user"><![CDATA[ 
	
		Function msEscapeQuotes(inputValue)
			Dim sReturn
				       	
			'sReturn = inputValue.item(0).nodeTypedValue
			sReturn = inputValue
	      		msEscapeQuotes = Replace(sReturn,"""","""" & """")
			
		End Function 

		Function msStripHTMLBreaks(inputValue)
			Dim sReturn
			
			sReturn = inputValue
	      		sReturn = Replace(sReturn,"&lt;br&gt;"," ")
	      		sReturn = Replace(sReturn,"&lt;br/&gt;"," ")
	      		sReturn = Replace(sReturn,"&lt;/br&gt;"," ")
	      		msStripHTMLBreaks = Trim(sReturn)
	      		
		End Function
						
	]]></msxsl:script>

</xsl:stylesheet>
