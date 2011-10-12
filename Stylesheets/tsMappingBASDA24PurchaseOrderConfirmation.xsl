<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation mapper
'  Old Shared platform (BASDA 2.4) to Hospitality platform iXML format.
'
' Please note that this mapper applys the following rules that are required for both
' Coors and The Astron Grou
' 1) The original PO Date is set to the Confirmation Date if missing
' 2) The original Delivery Date is set to the Confirmation Delivery Date if missing
' 3) The original order quantity is set to the confirmed quantity
'    (the BASDA2.4 format only has one quantity field)
'
' These rules have been applied so that the original order document does not need to be
' referenced and means that during the switch over from Shared to Hospitality (core) these
' suppliers can send confirmations for orders that were placed on Shared.
' 
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 22/06/2005  | Lee Boyton   | Created        
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="http://mycompany.com/mynamespace"
                exclude-result-prefixes="#default msxsl user">
	<xsl:output method="xml"/>
	<xsl:template match="/ORDER">
		<!-- BatchRoot is required by the Inbound XSL Transform processor-->
		<BatchRoot>
			<!-- The actual mapped document starts here -->
			<Batch>
				<BatchHeader/>
				<BatchDocuments>
					<BatchDocument>
						<PurchaseOrderConfirmation>
							<!-- Routing information -->
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="BUYER/PARTYCODE[@IDTYPE = 'SCB']/IDCODE"/>
								</SendersCodeForRecipient>
								<TestFlag>
									<xsl:choose>
										<xsl:when test="ORDERHEAD/@FUNCCODE = 'TEO'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</TestFlag>
							</TradeSimpleHeader>
							<!-- Purchase order confirmation header information -->
							<PurchaseOrderConfirmationHeader>
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								<!-- Trading partner and coding information -->
								<Buyer>
									<BuyersLocationID>
										<GLN>
											<xsl:text>5555555555555</xsl:text>
										</GLN>
										<xsl:if test="BUYER/PARTYCODE[@IDTYPE = 'SCB']/IDCODE != ''">
											<SuppliersCode>
												<xsl:value-of select="BUYER/PARTYCODE[@IDTYPE = 'SCB']/IDCODE"/>						
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									<xsl:if test="BUYER/ADDRESS/NAME != ''">
										<BuyersName>
											<xsl:value-of select="BUYER/ADDRESS/NAME"/>				
										</BuyersName>
									</xsl:if>		
									<xsl:if test="BUYER/ADDRESS/STREET[1] != ''">
										<BuyersAddress>
											<AddressLine1>
												<xsl:value-of select="BUYER/ADDRESS/STREET[1]"/>
											</AddressLine1>
											<xsl:if test="BUYER/ADDRESS/STREET[2] != ''">
												<AddressLine2>
													<xsl:value-of select="BUYER/ADDRESS/STREET[2]"/>
												</AddressLine2>
											</xsl:if>
											<xsl:if test="BUYER/ADDRESS/CITY != ''">
												<AddressLine3>
													<xsl:value-of select="BUYER/ADDRESS/CITY"/>
												</AddressLine3>
											</xsl:if>
											<xsl:if test="BUYER/ADDRESS/STATE != ''">
												<AddressLine4>
													<xsl:value-of select="BUYER/ADDRESS/STATE"/>
												</AddressLine4>
											</xsl:if>
											<xsl:if test="BUYER/ADDRESS/POSTCODE != ''">
												<PostCode>
													<xsl:value-of select="BUYER/ADDRESS/POSTCODE"/>
												</PostCode>
											</xsl:if>
										</BuyersAddress>
									</xsl:if>	
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:text>5555555555555</xsl:text>
										</GLN>
										<BuyersCode>
											<xsl:value-of select="SUPPLIER/PARTYCODE[@IDTYPE = 'BCS']/IDCODE"/>					
										</BuyersCode>
									</SuppliersLocationID>
									<xsl:if test="SUPPLIER/ADDRESS/NAME != ''">
										<SuppliersName>
											<xsl:value-of select="SUPPLIER/ADDRESS/NAME"/>				
										</SuppliersName>
									</xsl:if>		
									<xsl:if test="SUPPLIER/ADDRESS/STREET[1] != ''">
										<SuppliersAddress>
											<AddressLine1>
												<xsl:value-of select="SUPPLIER/ADDRESS/STREET[1]"/>
											</AddressLine1>
											<xsl:if test="SUPPLIER/ADDRESS/STREET[2] != ''">
												<AddressLine2>
													<xsl:value-of select="SUPPLIER/ADDRESS/STREET[2]"/>
												</AddressLine2>
											</xsl:if>
											<xsl:if test="SUPPLIER/ADDRESS/CITY != ''">
												<AddressLine3>
													<xsl:value-of select="SUPPLIER/ADDRESS/CITY"/>
												</AddressLine3>
											</xsl:if>
											<xsl:if test="SUPPLIER/ADDRESS/STATE != ''">
												<AddressLine4>
													<xsl:value-of select="SUPPLIER/ADDRESS/STATE"/>
												</AddressLine4>
											</xsl:if>
											<xsl:if test="SUPPLIER/ADDRESS/POSTCODE != ''">
												<PostCode>
													<xsl:value-of select="SUPPLIER/ADDRESS/POSTCODE"/>
												</PostCode>
											</xsl:if>
										</SuppliersAddress>
									</xsl:if>	
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<GLN>
											<xsl:text>5555555555555</xsl:text>
										</GLN>
										<SuppliersCode>
											<xsl:value-of select="BUYER/PARTYCODE[@IDTYPE = 'SCB']/IDCODE"/>						
										</SuppliersCode>
									</ShipToLocationID>
									<xsl:if test="DELIVERY/ADDRESS/NAME != ''">
										<ShipToName>
											<xsl:value-of select="DELIVERY/ADDRESS/NAME"/>				
										</ShipToName>
									</xsl:if>
									<!-- ShipToAddress and AddressLine1 are mandatory -->		
									<ShipToAddress>
										<AddressLine1>
											<xsl:choose>
												<xsl:when test="DELIVERY/ADDRESS/STREET[1] != ''">
													<xsl:value-of select="DELIVERY/ADDRESS/STREET[1]"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Not Provided</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</AddressLine1>
										<xsl:if test="DELIVERY/ADDRESS/STREET[2] != ''">
											<AddressLine2>
												<xsl:value-of select="DELIVERY/ADDRESS/STREET[2]"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="DELIVERY/ADDRESS/CITY != ''">
											<AddressLine3>
												<xsl:value-of select="DELIVERY/ADDRESS/CITY"/>
											</AddressLine3>
										</xsl:if>
										<xsl:if test="DELIVERY/ADDRESS/STATE != ''">
											<AddressLine4>
												<xsl:value-of select="DELIVERY/ADDRESS/STATE"/>
											</AddressLine4>
										</xsl:if>
										<xsl:if test="DELIVERY/ADDRESS/POSTCODE != ''">
											<PostCode>
												<xsl:value-of select="DELIVERY/ADDRESS/POSTCODE"/>
											</PostCode>
										</xsl:if>
									</ShipToAddress>
								</ShipTo>
								<!-- Purchase order number and date -->
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="REFERENCE[@REFTYPE = 'CUR']/REFCODE"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:choose>
											<xsl:when test="DATEINFO[@DATETYPE = 'ORD']/DATE != ''">
												<xsl:apply-templates select="DATEINFO[@DATETYPE = 'ORD']/DATE"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates select="DATEINFO[@DATETYPE = 'FIA']/DATE"/>
											</xsl:otherwise>
										</xsl:choose>
									</PurchaseOrderDate>
									<xsl:if test="DATEINFO[@DATETYPE = 'ORD']/TIME != ''">
										<PurchaseOrderTime>
											<xsl:value-of select="DATEINFO[@DATETYPE = 'ORD']/TIME"/>
											<xsl:if test="string-length(DATEINFO[@DATETYPE = 'ORD']/TIME) = 5">
												<xsl:text>:00</xsl:text>
											</xsl:if>
										</PurchaseOrderTime>
									</xsl:if>
								</PurchaseOrderReferences>
								<!-- Purchase order confirmation number and date -->
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:choose>
											<xsl:when test="REFERENCE[@REFTYPE = 'FIA']/REFCODE != ''">
												<xsl:value-of select="REFERENCE[@REFTYPE = 'FIA']/REFCODE"/>
											</xsl:when>
											<!-- use purchase order number if confirmation number is missing -->
											<xsl:otherwise>										
												<xsl:value-of select="REFERENCE[@REFTYPE = 'CUR']/REFCODE"/>
											</xsl:otherwise>
										</xsl:choose>
									</PurchaseOrderConfirmationReference>
									<PurchaseOrderConfirmationDate>
										<xsl:choose>
											<xsl:when test="DATEINFO[@DATETYPE = 'FIA']/DATE != ''">
												<xsl:apply-templates select="DATEINFO[@DATETYPE = 'FIA']/DATE"/>
											</xsl:when>
											<!-- use today's date if confirmation date is missing -->
											<xsl:otherwise>
												<xsl:value-of select="user:sTodayAsXMLDate()"/>
											</xsl:otherwise>
										</xsl:choose>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
								<!-- Original order delivery date - copy the confirmed delivery date (see header notes for explanation) -->
								<OrderedDeliveryDetails>
									<DeliveryType><xsl:text>Delivery</xsl:text></DeliveryType>
									<DeliveryDate>
										<xsl:choose>
											<xsl:when test="DATEINFO[@DATETYPE = 'DED']/DATE != ''">
												<xsl:apply-templates select="DATEINFO[@DATETYPE = 'DED']/DATE"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>1900-01-01</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</DeliveryDate>
								</OrderedDeliveryDetails>
								<!-- Confirmed delivery date -->
								<ConfirmedDeliveryDetails>
									<DeliveryType><xsl:text>Delivery</xsl:text></DeliveryType>
									<DeliveryDate>
										<xsl:choose>
											<xsl:when test="DATEINFO[@DATETYPE = 'DED']/DATE != ''">
												<xsl:apply-templates select="DATEINFO[@DATETYPE = 'DED']/DATE"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>1900-01-01</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</DeliveryDate>
									<!-- optional confirmation narrative text -->
									<xsl:if test="NARRATIVE[1]/TEXT != ''">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="NARRATIVE[1]/TEXT"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</ConfirmedDeliveryDetails>
							</PurchaseOrderConfirmationHeader>			
							<!-- Order line details -->
							<PurchaseOrderConfirmationDetail>
								<xsl:for-each select="ORDERLINE">
									<xsl:sort select="LINENO" data-type="number"/>
									<PurchaseOrderConfirmationLine>
										<!-- line status -->
										<xsl:attribute name="LineStatus">
											<xsl:choose>
												<xsl:when test="@LINEACTION = '1'"><xsl:text>Added</xsl:text></xsl:when>
												<xsl:when test="@LINEACTION = '2'"><xsl:text>Rejected</xsl:text></xsl:when>
												<xsl:when test="@LINEACTION = '3'"><xsl:text>Changed</xsl:text></xsl:when>
												<xsl:when test="@LINEACTION = '4'"><xsl:text>Accepted</xsl:text></xsl:when>
												<xsl:when test="@LINEACTION = '5'"><xsl:text>Rejected</xsl:text></xsl:when>
											</xsl:choose>
										</xsl:attribute>
										<!-- line number -->
										<LineNumber>
											<xsl:value-of select="LINENO"/>
										</LineNumber>
										<!-- product code and description -->
										<ProductID>
											<GTIN><xsl:text>55555555555555</xsl:text></GTIN>
											<SuppliersProductCode>
												<xsl:value-of select="PRODUCT[@PRODCODETYPE = 'SPC']/PRODNUM"/>
											</SuppliersProductCode>
										</ProductID>
										<ProductDescription>
											<xsl:choose>
												<xsl:when test="PRODUCT[@PRODCODETYPE = 'SPC']/DESCRIPTION != ''">
													<xsl:value-of select="PRODUCT[@PRODCODETYPE = 'SPC']/DESCRIPTION"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Not Provided</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</ProductDescription>
										<!-- use the confirmed quantity for the original order quantity (see header notes for explanation) -->
										<OrderedQuantity UnitOfMeasure="EA">
											<xsl:value-of select="QUANTITY[@QTYCODE = 'ORD']/QUANTITYAMOUNT"/>
										</OrderedQuantity>
										<ConfirmedQuantity UnitOfMeasure="EA">
											<xsl:value-of select="QUANTITY[@QTYCODE = 'ORD']/QUANTITYAMOUNT"/>
										</ConfirmedQuantity>
										<!-- optional pack size -->
										<xsl:if test="QUANTITY[@QTYCODE = 'ORD']/QTYUOMDESC != ''">
											<PackSize>
												<xsl:value-of select="QUANTITY[@QTYCODE = 'ORD']/QTYUOMDESC"/>
											</PackSize>
										</xsl:if>
										<!-- optional price and line total -->
										<xsl:if test="PRICE[@PRICETYPE = 'SEL']/PRICEAMOUNT != ''">
											<UnitValueExclVAT>
												<xsl:value-of select="PRICE[@PRICETYPE = 'SEL']/PRICEAMOUNT"/>
											</UnitValueExclVAT>
										</xsl:if>
										<xsl:if test="LINETOTAL">
											<LineValueExclVAT>
												<xsl:value-of select="LINETOTAL"/>
											</LineValueExclVAT>							
										</xsl:if>
										<!-- optional line narrative -->
										<xsl:if test="NARRATIVE[1]/TEXT != ''">
											<Narrative>
												<xsl:value-of select="NARRATIVE[1]/TEXT"/>
											</Narrative>
										</xsl:if>
									</PurchaseOrderConfirmationLine>
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>
							<!-- Document totals -->
							<PurchaseOrderConfirmationTrailer>
								<!-- recalculate the number of lines in case the inbound file is incorrect -->
								<NumberOfLines>
									<xsl:value-of select="count(ORDERLINE)"/>						
								</NumberOfLines>
								<TotalExclVAT>
									<xsl:value-of select="ORDERTOTAL/ORDLINETOT"/>						
								</TotalExclVAT>
							</PurchaseOrderConfirmationTrailer>
						</PurchaseOrderConfirmation>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>

	<!--
	 template to fix-up any invalid dates.
	 ensure that dates in yyyy-m-d format come out as yyyy-mm-dd format
	 -->
	<xsl:template match="DATE">
		<xsl:variable name="year" select="substring-before(.,'-')"/>
		<xsl:variable name="temp" select="substring-after(.,'-')"/>
		<xsl:variable name="month" select="substring-before($temp,'-')"/>
		<xsl:variable name="day" select="substring-after($temp,'-')"/>
		<xsl:value-of select="concat($year,'-',format-number($month,'00'),'-',format-number($day,'00'))"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
	//Formats the current system date in XML date format yyyy-mm-dd
	function sTodayAsXMLDate()
	{
		var dtNow = new Date();
		var dd,mm,yyyy;
		yyyy=dtNow.getFullYear().toString();
		mm=(dtNow.getMonth() + 1).toString(); 
		dd=dtNow.getDate().toString();

		if(mm.length == 1) mm = '0' + mm;
		if(dd.length == 1) dd = '0' + dd;
		
		return(yyyy + '-' + mm + '-' + dd);
	}	
	]]></msxsl:script>
	
</xsl:stylesheet>
