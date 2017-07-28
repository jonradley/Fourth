<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Overview 
'  Hospitality iXML to Henderson CSV Outbound format.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        	| Name       	| Description of modification
'******************************************************************************************
' 26/04/2016  | M Dimant		| FB 10936: Created.
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
		
		<!--Order Type (can be 0) -->	
		<xsl:text>0,</xsl:text>
		
		<!-- Purchase Order Reference -->
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:value-of select="user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32))"/>
		<xsl:if test="contains(user:msEscapeQuotes(substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,32)),',')">
			<xsl:text>"</xsl:text>
		</xsl:if>
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date -->
		<xsl:variable name="deldate"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></xsl:variable>
		<xsl:value-of select="concat(substring($deldate,9,2),'/',substring($deldate,6,2),'/',substring($deldate,1,4))"/>
		<xsl:text>,</xsl:text>
		
		<!-- Message Type -->
		<xsl:text>Order</xsl:text>
		
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
			
					
			<!-- Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			
			<!-- Retail Price Adjustment (Optional) -->
			<xsl:text>,</xsl:text>
			
			<!-- Stocked at Store (Optional) -->
			<xsl:text>,</xsl:text>
			
			<!-- Override RSP (Optional) -->
			<xsl:text>,</xsl:text>
			
			<!-- Ordered UoM -->
			<xsl:choose>
				<!-- Always set UOM to C for SSP, as agreed with Henderson in May 2016 -->
				<xsl:when test="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN='5027615900022'">
					<xsl:text>C</xsl:text>
				</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure='EA'">
					<xsl:text>S</xsl:text>
				</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure='CS'">
					<xsl:text>C</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"></xsl:value-of>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
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
