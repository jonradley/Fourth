<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Date		    | Name					| Description of modification
'******************************************************************************************
' 21/09/2015	| M Dimant			| FB10508: Created.
'******************************************************************************************
' 19/11/2015	| M Dimant			| FB10617: Change to location of Ship To address
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                              xmlns:user="http://mycompany.com/mynamespace">
  
	<xsl:output method="text"/>
	<xsl:template match="PurchaseOrder">
		<!-- Row Type -->
		<xsl:text>WEB</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Users email address/login id -->
		<xsl:text>,</xsl:text>
		
		<!-- Sessionid -->
		<xsl:text>,</xsl:text>
		
		<!-- Webref -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Name -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Email -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Telephone Number -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Fax Number -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Mobile Number -->
		<xsl:text>,</xsl:text>
		
		<!-- Contact Telephone Number 2 -->
		<xsl:text>,</xsl:text>
		
		<!-- Country Code -->
		<xsl:text>,</xsl:text>

		<!-- Marketing Opt Out Flag -->
		<xsl:text>,</xsl:text>
		
		<!-- Transaction currency -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Contact Name -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Country Code -->
		<xsl:text>,</xsl:text>
		
		<!-- Web Customer Model Account -->
		<xsl:text>,</xsl:text>
		
		<!-- Billing address post code -->
		<xsl:text>,</xsl:text>
		
		<!-- Customer type -->
		<xsl:text>,</xsl:text>
		
		<!-- Create new account -->
		<xsl:text>N</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- Header Row -->
		<xsl:text>HDR</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- Reserved -->
		<xsl:text>,,,,,,,</xsl:text>
		
		<!-- ANA Location Code -->
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>		
			<xsl:text>,</xsl:text>
		
		<!-- Branch Location Code -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>		
			<xsl:text>,</xsl:text>
	
		<!-- Customer Account Ref -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Name -->
		<xsl:apply-templates select="PurchaseOrderHeader/SendersAddress/ShipToName"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Address 1 -->
		<xsl:apply-templates select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Address 2 -->
		<xsl:apply-templates select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Address 3 -->
		<xsl:apply-templates select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Address 4 -->
		<xsl:apply-templates select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Post Code -->
		<xsl:apply-templates select="TradeSimpleHeader/SendersAddress/PostCode"/>
		<xsl:text>,</xsl:text>
		
		<!-- Customer Order No -->
		<xsl:apply-templates select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Date  -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Reserved -->
		<xsl:text>,,</xsl:text>
		
		<!-- Reserved -->
		<xsl:text>,,</xsl:text>
		
		<!-- Delivery Date -->		
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery instructions 1 -->
		<xsl:text>,</xsl:text>
			
		<!-- Delivery instructions 2 -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery instructions 3 -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery instructions 4 -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery instructions 5 -->
		<xsl:apply-templates select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
		<xsl:text>,,,,</xsl:text>
		
		<!-- File No -->
		<xsl:value-of select="substring(PurchaseOrderHeader/OrderID,2,6)"/>
		<xsl:text>,</xsl:text>
			
		<!-- File Date -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
				
		<!-- Cash Sale -->
		<xsl:text>N,</xsl:text>
		
		<!-- Payment Method Code -->
		<xsl:text>,</xsl:text>
			
		<!-- Delivery Method Code -->
		<xsl:text>,</xsl:text>
				
		<!-- Carriage Amount -->
		<xsl:text>,</xsl:text>
					
		<!-- Discount Rate -->
		<xsl:text>,</xsl:text>
						
		<!-- Retain Prices -->
		<xsl:text>,</xsl:text>
		
		<!-- Customer Email Address -->
		<xsl:text>,</xsl:text>
		
		<!-- Promotion Code -->
		<xsl:text>,</xsl:text>
		
		<!-- Depot Code -->
		<xsl:text>,</xsl:text>
		
		<!-- Reserved -->
		<xsl:text>,</xsl:text>
							
		<!-- Invoice Prefix -->
		<xsl:text>,</xsl:text>
		
		<!-- Carriage VAT Code -->
		<xsl:text>,</xsl:text>
		
		<!-- Order Value -->
		<xsl:apply-templates select="/PurchaseOrder/PurchaseOrderTrailer/TotalExclVAT"/>
		<xsl:text>,</xsl:text>
		
		<!-- Order Type -->
		
		<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsBranchReference"/>
		<xsl:text>,</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
				
				<!-- Header Row -->
				<xsl:text>OLD</xsl:text>
				<xsl:text>,</xsl:text>
		
				<!-- Barcode Number -->				
				<xsl:text>,</xsl:text>
				
				<!-- Stock Code -->
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>,</xsl:text>
				
				<!-- Customers Stock Code -->
				<xsl:text>,</xsl:text>
				
				<!-- Order Quantity -->
				<xsl:value-of select="OrderedQuantity"/>
				<xsl:text>,</xsl:text>
				
				<!-- Selling Unit -->
				<xsl:text>,</xsl:text>
				
				<!-- Selling Unit Description -->
				<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
				<xsl:text>,</xsl:text>
		
				<!-- Unit Price -->
				<xsl:value-of select="UnitValueExclVAT"/>
				<xsl:text>,</xsl:text>
				
				<!-- Description -->
				<xsl:text>"</xsl:text>
				<xsl:value-of select="ProductDescription"/>
				<xsl:text>"</xsl:text>
				<xsl:text>,</xsl:text>
				
				<!-- Description 2-->
				<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>

		
	</xsl:template>
	
	<!-- Format the date-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>		
		<xsl:value-of select="concat(substring($date,9,2),substring($date,6,2),substring($date,3,2))"/>
	</xsl:template>	
</xsl:stylesheet>
