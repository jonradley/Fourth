<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order mapper
'  Hospitality iXML to BASDA 2.4 format.
'
' NB: Various blank or zero valued elements have been added simply for backwards compatability
' with the BASDA 2.4 files produced by the Shared platform.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 26/04/2005  | Lee Boyton   | Created        
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/PurchaseOrder">
		<!-- all this biztalk header stuff is just a hang over from the old Shared platform, but needs to be included for backwards compatability -->
		<biztalk_1 xmlns="urn:schemas-biztalk-org/biztalk_1.xml">
			<header>
				<delivery>
					<message>
						<messageID>1</messageID>
						<sent>03/11/2004 09:58:40</sent>
						<subject>XML Document</subject>
					</message>
					<to>
						<address>Biztalk receiver</address>
						<state>
							<referenceID>0</referenceID>
							<handle>0</handle>
							<process>ClientProcess</process>
						</state>
					</to>
					<from>
						<address>Business Portal</address>
						<state>
							<referenceID>1</referenceID>
							<handle>1</handle>
							<process>Mapping Process</process>
						</state>
					</from>
				</delivery>
				<manifest>
					<document>
						<name>XML</name>
						<description>XML Document</description>
					</document>
				</manifest>
			</header>
			<body>
				<ORDER xmlns="urn:www-basda-org/schema/purord.xml">					
					<!-- Header (Test or Live order) information -->
					<xsl:choose>
						<xsl:when test="boolean(TradeSimpleHeader/TestFlag) = true">
							<!-- TEST order -->
							<ORDERHEAD ORDERTYPE="POU" FUNCCODE="TEO">
								<ORDERDESC>Purchase Order</ORDERDESC>
								<FUNCDESC>Test order</FUNCDESC>
								<CURRENCY CURRTYPE="ORD" CURRCODE="GBP">
									<CURRTYPEDESC>Order Currency</CURRTYPEDESC>
									<CURRCODESC>Pound Sterling</CURRCODESC>
									<CURRATE>0.0</CURRATE>
								</CURRENCY>								
							</ORDERHEAD>
						</xsl:when>
						<xsl:otherwise>
							<!-- LIVE order -->
							<ORDERHEAD ORDERTYPE="POU" FUNCCODE="FIO">
								<ORDERDESC>Purchase Order</ORDERDESC>
								<FUNCDESC>Firm Order</FUNCDESC>
								<CURRENCY CURRTYPE="ORD" CURRCODE="GBP">
									<CURRTYPEDESC>Order Currency</CURRTYPEDESC>
									<CURRCODESC>Pound Sterling</CURRCODESC>
									<CURRATE>0.0</CURRATE>
								</CURRENCY>								
							</ORDERHEAD>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Unique message identifier
					<REFERENCE REFTYPE="MID">
						<REFDESC>Portal message ID</REFDESC>
						<REFCODE>999999999</REFCODE>
						<REFCODESC/>
						<REFVALUE/>
					</REFERENCE>
					-->
					<!-- Unique portal order identifier
					<REFERENCE REFTYPE="PON">
						<REFDESC>Portal Order Number</REFDESC>
						<REFCODE>99999</REFCODE>
						<REFCODESC/>
						<REFVALUE/>
					</REFERENCE>
					-->
					<!-- Purchase Order Number -->
					<REFERENCE REFTYPE="CUR">
						<REFDESC>Customer's Purchase Order Number</REFDESC>
						<REFCODE>
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</REFCODE>						
					</REFERENCE>
					<!-- optional MDH accounting code -->
					<xsl:if test="PurchaseOrderHeader/HeaderExtraData/AccountingCode">
						<REFERENCE REFTYPE="ACC">
							<REFDESC>Accounting Code</REFDESC>
							<REFCODE>
								<xsl:value-of select="PurchaseOrderHeader/HeaderExtraData/AccountingCode"/>
							</REFCODE>
						</REFERENCE>
					</xsl:if>
					<!-- Purchase Order Date (and time) -->
					<DATEINFO DATETYPE="ORD">
						<DATEDESC>Purchase Order Date</DATEDESC>
						<DATE>
							<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						</DATE>
						<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime">
							<TIME>
								<!-- strip seconds from the time element if present -->
								<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,1,5)"/>
							</TIME>
						</xsl:if>
					</DATEINFO>
					<!-- Delivery date -->
					<DATEINFO DATETYPE="DED">
						<DATEDESC>Required Delivery Date</DATEDESC>
						<DATE>
							<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
						</DATE>
						<TIME>00:00</TIME>
					</DATEINFO>
					<!-- Party and trading relationship information -->
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
							<LINEACTIONDESC>Add Line</LINEACTIONDESC>
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
							<QUANTITY QTYCODE="ORD" QTYUOM="">
								<QTYCODESC>Ordered Quantity</QTYCODESC>
								<QUANTITYAMOUNT>
									<xsl:value-of select="OrderedQuantity"/>
								</QUANTITYAMOUNT>
								<QTYUOMDESC>
									<xsl:value-of select="PackSize"/>
								</QTYUOMDESC>
								<PACKSIZE>0</PACKSIZE>
							</QUANTITY>
							<PRICE PRICETYPE="COS" PRICEUOM="SEL">
								<PRICEDESC>Cost</PRICEDESC>
								<PRICEAMOUNT>
									<!-- net price is optional but most suppliers will want a value -->
									<xsl:choose>
										<xsl:when test="UnitValueExclVAT">
											<xsl:value-of select="UnitValueExclVAT"/>
										</xsl:when>
										<xsl:otherwise>0.00</xsl:otherwise>
									</xsl:choose>
								</PRICEAMOUNT>
							</PRICE>
							<DISCOUNT DISCTYPE="USR">
								<DISCDESC>Discount</DISCDESC>
								<DISCAMOUNT>0</DISCAMOUNT>
								<DISCMULT>0</DISCMULT>
							</DISCOUNT>							
							<!-- there is no line tax information on the hospitality platform so the following cannot be output
							<LINETAX>
								<MIXTAXIND/>
								<TAXCODE>S</TAXCODE>
								<TAXRATE>17.5</TAXRATE>
								<TAXVALUE>48.07</TAXVALUE>
								<TAXREF/>
								<TAXREFDESC/>
							</LINETAX>
							 -->
						</ORDERLINE>						
					</xsl:for-each>					
					<DISCOUNT DISCTYPE="">
						<DISCDESC/>
						<DISCAMOUNT>0.0</DISCAMOUNT>
						<DISCMULT>0.0</DISCMULT>
					</DISCOUNT>
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
						<!-- We have no Tax information on Purchase orders in Hospitality so these can not be added
						<ORDTAXTOT>0.00</ORDTAXTOT>
						<ORDGROSSPAY>
							<xsl:choose>
								<xsl:when test="PurchaseOrderTrailer/TotalExclVAT">
									<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>								
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</ORDGROSSPAY>
						 -->
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
