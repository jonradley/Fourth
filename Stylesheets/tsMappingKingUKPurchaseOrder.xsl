<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to King platform (BASDA 2.4) format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 03/03/2005  | Lee Boyton   | Created        
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/PurchaseOrder">
		<biztalk_1>
			<body>
				<ORDER xmlns="urn:www-basda-org/schema/purord.xml">					
					<!-- Header (Test or Live order) information -->
					<xsl:choose>
						<xsl:when test="boolean(TradeSimpleHeader/TestFlag) = true">
							<!-- TEST order -->
							<ORDERHEAD ORDERTYPE="POU" FUNCCODE="TEO">
								<ORDERDESC>Purchase Order</ORDERDESC>
								<FUNCDESC>Test order</FUNCDESC>
								<CURRENCY CURRTYPE="ORD" CURRCODE="GBP"/>
							</ORDERHEAD>
						</xsl:when>
						<xsl:otherwise>
							<!-- LIVE order -->
							<ORDERHEAD ORDERTYPE="POU" FUNCCODE="FIO">
								<ORDERDESC>Purchase Order</ORDERDESC>
								<FUNCDESC>Firm Order</FUNCDESC>
								<CURRENCY CURRTYPE="ORD" CURRCODE="GBP"/>
							</ORDERHEAD>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Purchase Order Number -->
					<REFERENCE REFTYPE="CUR">
						<REFDESC>Customer's Purchase Order Number</REFDESC>
						<REFCODE>
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</REFCODE>
					</REFERENCE>
					<!-- Proxy Branch reference
					<REFERENCE REFTYPE="UNO">
						<REFDESC>Unit number</REFDESC>
						<REFCODE>
							<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
						</REFCODE>
					</REFERENCE>
					 -->
					<!-- Purchase Order Date (and time) -->
					<DATEINFO DATETYPE="ORD">
						<DATEDESC>Purchase Order Date</DATEDESC>
						<DATE>
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						</DATE>
						<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime">
							<TIME>
								<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime"/>
							</TIME>
						</xsl:if>
					</DATEINFO>
					<!-- Delivery date -->
					<DATEINFO DATETYPE="DED">
						<DATEDESC>Required Delivery Date</DATEDESC>
						<DATE>
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						</DATE>
					</DATEINFO>
					<!-- Earliest delivery date -->
					<DATEINFO DATETYPE="EDD">
						<DATEDESC>Earliest Delivery Date</DATEDESC>
						<DATE>
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						</DATE>
					</DATEINFO>					
					<!-- Party and trading relationship information -->
					<!-- Buyer -->
					<BUYER>
						<PARTYCODE IDTYPE="SCB">
							<IDDESC>Supplier's Code For Buyer</IDDESC>
							<IDCODE>
								<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
							</IDCODE>
						</PARTYCODE>
						<xsl:if test="PurchaseOrderHeader/Buyer/BuyersName or PurchaseOrderHeader/Buyer/BuyersAddress">
							<ADDRESS>
								<xsl:if test="PurchaseOrderHeader/Buyer/BuyersName">
									<NAME>
										<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
									</NAME>
								</xsl:if>
								<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress"/>
							</ADDRESS>
						</xsl:if>
					</BUYER>
					<!-- Supplier -->
					<SUPPLIER>
						<PARTYCODE IDTYPE="BCS">
							<IDDESC>Buyer's Code For Supplier</IDDESC>
							<IDCODE>
								<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
							</IDCODE>
						</PARTYCODE>
						<xsl:if test="PurchaseOrderHeader/Supplier/SuppliersName or PurchaseOrderHeader/Supplier/SuppliersAddress">
							<ADDRESS>
								<xsl:if test="PurchaseOrderHeader/Supplier/SuppliersName">
									<NAME>
										<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/>
									</NAME>
								</xsl:if>
								<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress"/>
							</ADDRESS>
						</xsl:if>
					</SUPPLIER>
					<!-- ShipTo -->
					<DELIVERY>
						<xsl:if test="PurchaseOrderHeader/ShipTo/SuppliersCode">
							<PARTYCODE IDTYPE="DEL">
								<IDDESC>Deliver to</IDDESC>
								<IDCODE>
									<xsl:value-of select="PurchaseOrderHeader/ShipTo/SuppliersCode"/>
								</IDCODE>
							</PARTYCODE>
						</xsl:if>
						<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToName or PurchaseOrderHeader/ShipTo/ShipToAddress">
							<ADDRESS>
								<xsl:if test="PurchaseOrderHeader/ShipTo/ShipToName">
									<NAME>
										<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
									</NAME>
								</xsl:if>
								<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress"/>
							</ADDRESS>
						</xsl:if>
					</DELIVERY>
					<!-- Buyer again -->
					<INVOICETO>
						<xsl:if test="PurchaseOrderHeader/Buyer/SuppliersCode">
							<PARTYCODE IDTYPE="BUY">
								<IDDESC>Buyer</IDDESC>
								<IDCODE>
									<xsl:value-of select="PurchaseOrderHeader/Buyer/SuppliersCode"/>
								</IDCODE>
							</PARTYCODE>
						</xsl:if>
						<xsl:if test="PurchaseOrderHeader/Buyer/BuyersName or PurchaseOrderHeader/Buyer/BuyersAddress">
							<ADDRESS>
								<xsl:if test="PurchaseOrderHeader/Buyer/BuyersName">
									<NAME>
										<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>
									</NAME>
								</xsl:if>
								<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress"/>
							</ADDRESS>
						</xsl:if>
					</INVOICETO>
					<!-- Order line details -->
					<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
						<xsl:sort select="LineNumber" data-type="number"/>
						<ORDERLINE LINETYPE="GDS" LINEACTION="1">
							<LINETYPEDESC>Goods</LINETYPEDESC>
							<LINENO>
								<xsl:value-of select="LineNumber"/>
							</LINENO>
							<LINETOTAL>
								<!-- line value is optional but the King platform needs a value -->
								<xsl:choose>
									<xsl:when test="LineValueExclVAT">
										<xsl:value-of select="LineValueExclVAT"/>									
									</xsl:when>
									<xsl:otherwise>0.00</xsl:otherwise>
								</xsl:choose>
							</LINETOTAL>
							<PRODUCT PRODCODETYPE="SPC">
								<PRODCODEDESC>Seller's Code</PRODCODEDESC>
								<PRODNUM>
									<!-- supplier's product code is optional so use the GTIN if this is not present -->
									<xsl:choose>
										<xsl:when test="ProductID/SuppliersProductCode">
											<xsl:value-of select="ProductID/SuppliersProductCode"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ProductID/GTIN"/>
										</xsl:otherwise>
									</xsl:choose>
								</PRODNUM>
								<DESCRIPTION>
									<xsl:value-of select="ProductDescription"/>									
								</DESCRIPTION>
							</PRODUCT>
							<QUANTITY QTYCODE="ORD">
								<QTYCODESC>Ordered Quantity</QTYCODESC>
								<QUANTITYAMOUNT>
									<!-- King UK can only handle integer quantities -->
									<xsl:choose>
										<xsl:when test="OrderedQuantity &lt; 1">
											<xsl:text>1</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="floor(OrderedQuantity)"/>
										</xsl:otherwise>
									</xsl:choose>									
								</QUANTITYAMOUNT>
							</QUANTITY>
							<PRICE PRICETYPE="COS">
								<PRICEAMOUNT>
									<!-- net price is optional but the King platform needs a value (for confirmation map) -->
									<xsl:choose>
										<xsl:when test="UnitValueExclVAT">
											<xsl:value-of select="UnitValueExclVAT"/>
										</xsl:when>
										<xsl:otherwise>0.00</xsl:otherwise>
									</xsl:choose>
								</PRICEAMOUNT>
							</PRICE>
						</ORDERLINE>						
					</xsl:for-each>
					<!-- Delivery notes -->
					<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
						<NARRATIVE NARRTYPE="SPI">
							<NARRDESC>Special Instructions</NARRDESC>
							<TEXT>
								<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
							</TEXT>
						</NARRATIVE>
					</xsl:if>
					<!-- Document totals -->
					<ORDERTOTAL>
						<ORDNOLINES>
							<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>						
						</ORDNOLINES>
						<TOTALINES>
							<xsl:value-of select="floor(sum(PurchaseOrderDetail/PurchaseOrderLine/OrderedQuantity))"/>
						</TOTALINES>
						<ORDLINETOT>
							<xsl:choose>
								<xsl:when test="PurchaseOrderTrailer/TotalExclVAT">
									<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>								
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</ORDLINETOT>
						<ORDTAXTOT>0.00</ORDTAXTOT>
						<ORDGROSSPAY>
							<xsl:choose>
								<xsl:when test="PurchaseOrderTrailer/TotalExclVAT">
									<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>								
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</ORDGROSSPAY>
					</ORDERTOTAL>
				</ORDER>
			</body>
		</biztalk_1>
	</xsl:template>
	
	<!-- template for outputting optional address details for a Buyer, Supplier, or ShipTo party -->
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<STREET xmlns="urn:www-basda-org/schema/purord.xml">
			<xsl:value-of select="AddressLine1"/>
		</STREET>
		<xsl:if test="AddressLine2">
			<STREET xmlns="urn:www-basda-org/schema/purord.xml">
				<xsl:value-of select="AddressLine2"/>
			</STREET>
		</xsl:if>
		<xsl:if test="AddressLine3">
			<CITY xmlns="urn:www-basda-org/schema/purord.xml">
				<xsl:value-of select="AddressLine3"/>
			</CITY>
		</xsl:if>
		<xsl:if test="AddressLine4">
			<STATE xmlns="urn:www-basda-org/schema/purord.xml">
				<xsl:value-of select="AddressLine4"/>
			</STATE>
		</xsl:if>
		<xsl:if test="PostCode">
			<POSTCODE xmlns="urn:www-basda-org/schema/purord.xml">
				<xsl:value-of select="PostCode"/>
			</POSTCODE>
		</xsl:if>
		<CNTRYCODE xmlns="urn:www-basda-org/schema/purord.xml">GB</CNTRYCODE>
		<COUNTRY xmlns="urn:www-basda-org/schema/purord.xml">United Kingdom</COUNTRY>
	</xsl:template>
	
</xsl:stylesheet>
