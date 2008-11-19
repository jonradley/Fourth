<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:template match="PurchaseOrder">
		
		<!-- 1. Record Type -->	
		<xsl:text>HDR</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- 2. Customer Number -->
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>,</xsl:text>
		<!-- 3. SOP Type -->
		<xsl:text>STD ORDER</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- 4. SOP Number -->
		<xsl:text>,</xsl:text>
		<!-- 5. DocumentID -->
		<xsl:text>,</xsl:text>
		<!-- 6. Document Date -->
		<xsl:variable name="PODate">
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($PODate,9,2),substring($PODate,6,2),substring($PODate,1,4))"/>
		<xsl:text>,</xsl:text>
		<!-- 7. Customer PO Number -->
		<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<!-- 8 Comment 1 -->
		<xsl:text>,</xsl:text>
		<!-- 9 Comment 2 -->
		<xsl:text>,</xsl:text>
		<!-- 10 Address 1 -->
		<xsl:text>,</xsl:text>
		<!-- 11 Address 2 -->
		<xsl:text>,</xsl:text>
		<!-- 12 City -->
		<xsl:text>,</xsl:text>
		<!-- 13 State -->
		<xsl:text>,</xsl:text>
		<!-- 14 Zip -->
		<xsl:text>,</xsl:text>
		<!-- 15 Country -->
		<xsl:text>,</xsl:text>
		<!-- 16 Ship to Address Code -->
		<!--xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/-->
		<xsl:value-of select="MAIN"/>
		<xsl:text>,</xsl:text>
		<!-- 17 User ID -->
		<xsl:text>,</xsl:text>
		<!-- 18 Trade Discount Amt. -->
		<xsl:text>,</xsl:text>
		<!-- 19 Freight Amount -->
		<xsl:text>,</xsl:text>
		<!-- 20 Misc Amount -->
		<xsl:text>,</xsl:text>
		<!-- 21 Deposit/Amount Received -->
		<xsl:text>,</xsl:text>
		<!-- 22 Currency ID -->
		<xsl:text>,</xsl:text>
		<!-- 23 Exchange Rate -->
		<xsl:text>,</xsl:text>
		<!-- 24 User Defined Table 1 -->
		<xsl:text>,</xsl:text>
		<!-- 25 User Defined Table 2 -->
		<xsl:text>,</xsl:text>
		<!-- 26 User Defined Table 3 -->
		<xsl:text>,</xsl:text>
		<!-- 27 User Defined Date 1 -->
		<xsl:text>,</xsl:text>
		<!-- 28 User Defined Date 2 -->
		<xsl:text>,</xsl:text>
		<!-- 29 User Defined 1 -->
		<xsl:text>,</xsl:text>
		<!-- 30 User Defined 2 -->
		<xsl:text>,</xsl:text>
		<!-- 31 User Defined 3 -->
		<xsl:text>,</xsl:text>
		<!-- 32 User Defined 4 -->
		<xsl:text>,</xsl:text>
		<!-- 33 User Defined 5 -->
		<xsl:text>,</xsl:text>
		<!-- 34 Default Site ID -->
		<xsl:text>,</xsl:text>
		<!-- 35 Requested Ship Date -->
		<xsl:variable name="ReqDelDate">
			<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:variable>
		<xsl:value-of select="concat(substring($ReqDelDate,9,2),substring($ReqDelDate,6,2),substring($ReqDelDate,1,4))"/>
		<xsl:text>,</xsl:text>
		<!-- 36 Comment ID -->
		<xsl:text>,</xsl:text>
		<!-- 37 Shipping Method -->
		<xsl:text>,</xsl:text>
		<!-- 38 Due Date -->
		<xsl:text>,</xsl:text>
		<!-- 39 Batch Number -->
		<xsl:text>,</xsl:text>
		<!-- 40 Bill to Address Code -->
		<xsl:text>,</xsl:text>
		<!-- 41 Trade Discount Percent -->
		<xsl:text>,</xsl:text>
		<!-- 42 Default Price Level -->
		<xsl:text>,</xsl:text>
		<!-- 43 Salesperson ID -->
		<xsl:text>,</xsl:text>
		<!-- 44 Sales Territory ID -->
		<xsl:text>,</xsl:text>
		<!-- 45 Commission Percent -->
		<xsl:text>,</xsl:text>
		<!-- 46 Commission Amount -->
		<xsl:text>,</xsl:text>
		<!-- 47 Percent of Sale -->
		<xsl:text>,</xsl:text>
		<!-- 48 Commission Sales Amount -->
		<xsl:text>,</xsl:text>
		<!-- 49 Tax Schedule ID -->
		<xsl:text>,</xsl:text>
		<!-- 50 Contact Person -->
		<xsl:text>,</xsl:text>
		<!-- 51 Ship to Company Name -->
		<xsl:text>,</xsl:text>
		<!-- 52 Address 3 -->
		<xsl:text>,</xsl:text>
		<!-- 53 Payment Terms ID -->
		<xsl:text>,</xsl:text>
		<!-- 54 Debtor Comment1 -->
		<xsl:text>,</xsl:text>
		<!-- 55 Email Recipient -->			
			
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
			<xsl:text>&#13;&#10;</xsl:text>
		
			<!-- 1 Record Type -->
			<xsl:text>DTL</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- 2 Item Number -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<!-- 3 Quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>,</xsl:text>
			<!-- 4 Unit Price -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<!-- 5 Item Description -->
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			<!-- 6 Unit Markdown Amount -->
			<xsl:text>,</xsl:text>
			<!-- 7 Shipping Method -->
			<xsl:text>,</xsl:text>
			<!-- 8 Site ID -->
			<xsl:text>,</xsl:text>
			<!-- 9 Unit of Measure -->
			<xsl:call-template name="decodeUoM">
				<xsl:with-param name="inUoM">
					<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			<!-- 10 Item Class ID -->
			<xsl:text>,</xsl:text>
			<!-- 11 Standard Cost -->
			<xsl:text>,</xsl:text>
			<!-- 12 Current Cost -->
			<xsl:text>,</xsl:text>
			<!-- 13 List Price -->
			<xsl:text>,</xsl:text>
			<!-- 14 Item Short Description -->
			<xsl:text>,</xsl:text>
			<!-- 15 Generic Description -->
			<xsl:text>,</xsl:text>
			<!-- 16 Price Schedule -->
			<xsl:text>,</xsl:text>
			<!-- 17 Default Price Level -->
			<xsl:text>,</xsl:text>
			<!-- 18 Item User Category 1 -->
			<xsl:text>,</xsl:text>
			<!-- 19 Item User Category 2 -->
			<xsl:text>,</xsl:text>
			<!-- 20 Item User Category 3 -->
			<xsl:text>,</xsl:text>
			<!-- 21 Item User Category 4 -->
			<xsl:text>,</xsl:text>
			<!-- 22 Item User Category 5 -->
			<xsl:text>,</xsl:text>
			<!-- 23 Item User Category 6 -->
			<xsl:text>,</xsl:text>
			<!-- 24 Alternate Item 1 -->
			<xsl:text>,</xsl:text>
			<!-- 25 Alternate Item 2 -->
			<xsl:text>,</xsl:text>
			<!-- 26 Template Price List Item -->
			<xsl:text>,</xsl:text>
			<!-- 27 Requested Ship Date -->
			<xsl:text>,</xsl:text>
			<!-- 28 Fulfilment Date -->
			<xsl:text>,</xsl:text>
			<!-- 29 Actual Ship Date -->
			<xsl:text>,</xsl:text>
			<!-- 30 Markdown Percent -->
			<xsl:text>,</xsl:text>
			<!-- 31 Drop Ship Flag -->
			<xsl:text>,</xsl:text>
			<!-- 32 Unit Cost -->
		
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="decodeUoM">
		<xsl:param name="inUoM"/>
		<xsl:choose>
			<xsl:when test="$inUoM = 'KGM'">KG</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inUoM"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>
