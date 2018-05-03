<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Date		    | Name					| Description of modification
'******************************************************************************************
' 12/01/2018	| W Nassor			| FB12252: Created Module: Created.
' 03/05/2018 | W Nassor			| FB12734: Changes to Mapper - Removed ANA Location Code (Buyers GLN), Escaped double quotes from product description, changes to comma positioning. 
'******************************************************************************************
-->
  
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
  
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="PurchaseOrder">

		<!-- Header Row -->
		<xsl:text>HDR</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- 2,3,4,5,6,7 Reserved -->
		<xsl:text>,,,,,,,</xsl:text>
		
		<!-- ANA Location Code -->
		<xsl:text>,</xsl:text>
		
		<!-- Branch Location Code -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>		
			<xsl:text>,</xsl:text>
	
		<!-- Customer Account Ref -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Name -->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToName"/>
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
		
		<!--  Customer Order No -->
		<xsl:apply-templates select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<!--<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,'*\%!@$&amp;', )"/>-->
		<xsl:text>,</xsl:text>
		
		<!--  Order Date  -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Date Order Transmitted by Customer -->
			<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Time Order Transmitted by Customer -->
		<xsl:text>12:00</xsl:text>
		<xsl:text>,</xsl:text>

		<!-- Date Order Received by edi-L-I-N-K -->
		<xsl:text>,</xsl:text>
		
		<!-- Latest Delivery Date -->		
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Requested Delivery Date -->
		<xsl:text>,</xsl:text>
		
		<!-- Delivery Instruction No. / Booking Reference -->
		<xsl:text>,</xsl:text>
		
		<!--  Delivery instructions 1 -->
		<xsl:text>,</xsl:text>
			
		<!--  Delivery instructions 2 -->
		<xsl:text>,</xsl:text>
		
		<!--  Delivery instructions 3 -->
		<xsl:apply-templates select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
		<xsl:text>,</xsl:text>
		
		<!-- Delivery instructions 4 -->
		<xsl:text>,</xsl:text>
		
		<!-- File No -->
		<xsl:value-of select="substring(PurchaseOrderHeader/OrderID,2,6)"/>
		<xsl:text>,</xsl:text>
			
		<!--  File Date -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		<!-- Cash Sales Indicator -->
		<xsl:text>N,</xsl:text>
		
		<!--  Payment Method Code -->
		<xsl:text>,</xsl:text>
	
		<!--  Delivery Method Code -->
		<xsl:text>,</xsl:text>
	
		<!-- Carriage Value -->
		<xsl:text>,</xsl:text>
	
		<!--  Discount Rate -->
		<xsl:text>,</xsl:text>
	
		<!--  Retain Price Indicator -->
		<xsl:text>,</xsl:text>
		
		<!--  Customer Email Address -->
		<xsl:text>,</xsl:text>
		
		<!--  Promotion Code -->
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
				<xsl:value-of select="translate(ProductDescription,'3&quot;',' ')"/>
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
