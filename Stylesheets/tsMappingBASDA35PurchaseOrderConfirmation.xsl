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
	
	<xsl:template match="/biztalk_1/header"/>
	
	<xsl:template match="/biztalk_1/body/OrderResponse">
	
		<!-- BatchRoot is required by the Inbound XSL Transform processor-->
		<BatchRoot>
		
			<!-- The actual mapped document starts here -->
			<Batch>

				<BatchDocuments>
				
					<BatchDocument>
					
						<PurchaseOrderConfirmation>
							<!-- Routing information -->
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							
							<!-- Purchase order confirmation header information -->
							<PurchaseOrderConfirmationHeader>
								
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								
								<!-- Trading partner and coding information -->
								<Buyer>
									
									<BuyersLocationID>
										<xsl:if test="Buyer/BuyerReferences/SuppliersCodeForBuyer != ''">
											<SuppliersCode>
												<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>						
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									
									<xsl:if test="Buyer/Party != ''">
										<BuyersName>
											<xsl:value-of select="Buyer/Party"/>				
										</BuyersName>
									</xsl:if>		
									
									<xsl:if test="Buyer/Address/Street != ''">
										<BuyersAddress>										
										
											<xsl:for-each select="(Buyer/Address/Street | Buyer/Address/City)[. != ''][position() &lt; 5]">
												<xsl:element name="{concat('AddressLine',string(position()))}">
													<xsl:value-of select="."/>
												</xsl:element>										
											</xsl:for-each>
										
											<xsl:if test="Buyer/Address/PostCode != ''">
												<PostCode>
													<xsl:value-of select="Buyer/Address/PostCode"/>
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
											<xsl:value-of select="Supplier/SupplierReferences/BuyersCodeForSupplier"/>					
										</BuyersCode>
									</SuppliersLocationID>	
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences"/>						
										</SuppliersCode>
									</ShipToLocationID>
									<xsl:if test="Delivery/DeliverTo/Party != ''">
										<ShipToName>
											<xsl:value-of select="Delivery/DeliverTo/Party"/>				
										</ShipToName>
									</xsl:if>
									<!-- ShipToAddress and AddressLine1 are mandatory -->		
									<ShipToAddress>
										
										<xsl:for-each select="(Delivery/DeliverTo/Address/Street | Delivery/DeliverTo/Address/City)[. != ''][position() &lt; 5]">
											<xsl:element name="{concat('AddressLine',string(position()))}">
												<xsl:value-of select="."/>
											</xsl:element>										
										</xsl:for-each>
									
										<xsl:if test="Delivery/DeliverTo/Address/PostCode != ''">
											<PostCode>
												<xsl:value-of select="Delivery/DeliverTo/Address/PostCode"/>
											</PostCode>
										</xsl:if>
										
									</ShipToAddress>
								</ShipTo>
								
								<!-- Purchase order number and date -->
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="OrderResponseReferences/BuyersOrderNumber"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="OriginalOrderDate"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								
								<!-- Purchase order confirmation number and date -->
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="OrderResponseReferences/SuppliersOrderReference"/>
									</PurchaseOrderConfirmationReference>
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="substring-before(OrderResponseDate, 'T')"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
								
								<!-- Original order delivery date - copy the confirmed delivery date (see header notes for explanation) -->
								<!--OrderedDeliveryDetails>
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
								<= Confirmed delivery date =>
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
									<= optional confirmation narrative text =>
									<xsl:if test="NARRATIVE[1]/TEXT != ''">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="NARRATIVE[1]/TEXT"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</ConfirmedDeliveryDetails-->
							
							</PurchaseOrderConfirmationHeader>			
							
							<!-- Order line details -->							
							<PurchaseOrderConfirmationDetail>
							
								<xsl:for-each select="OrderResponseLine">
								
									<PurchaseOrderConfirmationLine>
										
										<!-- product code and description -->
										<ProductID>
											<GTIN><xsl:text>55555555555555</xsl:text></GTIN>
											<SuppliersProductCode>
												<xsl:value-of select="Product/SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										<ProductDescription>
											<xsl:choose>
												<xsl:when test="Product/Description != ''">
													<xsl:value-of select="Product/Description"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Not Provided</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</ProductDescription>
										
										<!-- use the confirmed quantity for the original order quantity (see header notes for explanation) -->										
										<ConfirmedQuantity UnitOfMeasure="EA">
											<xsl:attribute name="UnitOfMeasure">
												<xsl:value-of select="Quantity/@UOMCode"/>
											</xsl:attribute>
											<xsl:value-of select="Quantity/Amount"/>
										</ConfirmedQuantity>


										<!-- optional price and line total -->
										<xsl:if test="Price/UnitPrice != ''">
											<UnitValueExclVAT>
												<xsl:value-of select="Price/UnitPrice"/>
											</UnitValueExclVAT>
										</xsl:if>
										
										<!-- optional line narrative -->
										<xsl:if test="OrderLineInformation != ''">
											<Narrative>
												<xsl:value-of select="OrderLineInformation"/>
											</Narrative>
										</xsl:if>
									</PurchaseOrderConfirmationLine>
									
								</xsl:for-each>
								
							</PurchaseOrderConfirmationDetail>
							
							<!-- Document totals -->
							<PurchaseOrderConfirmationTrailer>
								<TotalExclVAT>
									<xsl:value-of select="OrderResponseTotal/GoodsValue"/>						
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
