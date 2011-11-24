<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'
' 
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 28/01/2008  | R Cambridge  | Created        
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
									<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>
								</SendersCodeForRecipient>
								<SendersBranchReference>
									<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
								</SendersBranchReference>
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
											<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>						
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
												<!--xsl:value-of select="Quantity/@UOMCode"/-->
												<xsl:call-template name="transUoM">
													<xsl:with-param name="supplierUoM" select="Quantity/@UOMCode"/>
												</xsl:call-template>
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
							
							<!-- Document totals >
							<PurchaseOrderConfirmationTrailer>
								<TotalExclVAT>
									<xsl:value-of select="OrderResponseTotal/GoodsValue"/>						
								</TotalExclVAT>
							</PurchaseOrderConfirmationTrailer-->
							
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
	
	
	<xsl:template name="transUoM">
		<xsl:param name="supplierUoM"/>
	
		<xsl:choose>
			
			<!-- Guesses based on values seen during testing -->
			<xsl:when test="$supplierUoM = 'EA'">EA</xsl:when>
			<xsl:when test="$supplierUoM = 'KG'">KGM</xsl:when>
			
			<!-- Office Depot's list -->
			<!-- Bag -->
			<xsl:when test="$supplierUoM = 'BAG'">EA</xsl:when>
			<!-- Bottle -->
			<xsl:when test="$supplierUoM = 'BOT'">EA</xsl:when>
			<!-- Box -->
			<xsl:when test="$supplierUoM = 'BOX'">CS</xsl:when>
			<!-- Can -->
			<xsl:when test="$supplierUoM = 'CAN'">EA</xsl:when>
			<!-- Case -->
			<xsl:when test="$supplierUoM = 'CS'">CS</xsl:when>
			<!-- Case -->
			<xsl:when test="$supplierUoM = 'CS1'">CS</xsl:when>
			<!-- Case -->
			<xsl:when test="$supplierUoM = 'CSE'">CS</xsl:when>
			<!-- Degree -->
			<xsl:when test="$supplierUoM = 'DEG'">EA</xsl:when>
			<!-- Drum -->
			<xsl:when test="$supplierUoM = 'DR'">EA</xsl:when>
			<!-- Dozen -->
			<xsl:when test="$supplierUoM = 'DZ'">DZN</xsl:when>
			<!-- Each -->
			<xsl:when test="$supplierUoM = 'EA'">EA</xsl:when>
			<!-- Gram Gold -->
			<xsl:when test="$supplierUoM = 'GAU'">GRM</xsl:when>
			<!-- Large -->
			<xsl:when test="$supplierUoM = 'GRO'">EA</xsl:when>
			<!-- Inner -->
			<xsl:when test="$supplierUoM = 'INN'">CS</xsl:when>
			<!-- Item -->
			<xsl:when test="$supplierUoM = 'ITM'">EA</xsl:when>
			<!-- Canister -->
			<xsl:when test="$supplierUoM = 'KAN'">EA</xsl:when>
			<!-- Carton -->
			<xsl:when test="$supplierUoM = 'KAR'">CS</xsl:when>
			<!-- Crate -->
			<xsl:when test="$supplierUoM = 'KI'">CS</xsl:when>
			<!-- Crate -->
			<xsl:when test="$supplierUoM = 'KI1'">CS</xsl:when>
			<!-- Kit -->
			<xsl:when test="$supplierUoM = 'KIT'">CS</xsl:when>
			<!-- Carton -->
			<xsl:when test="$supplierUoM = 'KT1'">EA</xsl:when>
			<!-- Perf. unit -->
			<xsl:when test="$supplierUoM = 'LE'">EA</xsl:when>
			<!-- Outer -->
			<xsl:when test="$supplierUoM = 'OUT'">CS</xsl:when>
			<!-- Pair -->
			<xsl:when test="$supplierUoM = 'PAA'">CS</xsl:when>
			<!-- Pack -->
			<xsl:when test="$supplierUoM = 'PAK'">CS</xsl:when>
			<!-- Pallet -->
			<xsl:when test="$supplierUoM = 'PAL'">PF</xsl:when>
			<!-- Wholesaler -->
			<xsl:when test="$supplierUoM = 'PER'">CS</xsl:when>
			<!-- Pack -->
			<xsl:when test="$supplierUoM = 'PK'">CS</xsl:when>
			<!-- Pack -->
			<xsl:when test="$supplierUoM = 'PK1'">CS</xsl:when>
			<!-- Packet -->
			<xsl:when test="$supplierUoM = 'PKT'">EA</xsl:when>
			<!-- Pallet -->
			<xsl:when test="$supplierUoM = 'PLT'">PF</xsl:when>
			<!-- Pair -->
			<xsl:when test="$supplierUoM = 'PR'">CS</xsl:when>
			<!-- Quire -->
			<xsl:when test="$supplierUoM = 'QR'">CS</xsl:when>
			<!-- Roll -->
			<xsl:when test="$supplierUoM = 'RL'">EA</xsl:when>
			<!-- Ream -->
			<xsl:when test="$supplierUoM = 'RM'">EA</xsl:when>
			<!-- Role -->
			<xsl:when test="$supplierUoM = 'ROL'">CS</xsl:when>
			<!-- Set -->
			<xsl:when test="$supplierUoM = 'SET'">CS</xsl:when>
			<!-- Sheet -->
			<xsl:when test="$supplierUoM = 'SHT'">EA</xsl:when>
			<!-- items -->
			<xsl:when test="$supplierUoM = 'ST'">CS</xsl:when>
			<!-- Base -->
			<xsl:when test="$supplierUoM = 'STK'">CS</xsl:when>
			<!-- Tube -->
			<xsl:when test="$supplierUoM = 'TBE'">EA</xsl:when>
			<!-- Thousand -->
			<xsl:when test="$supplierUoM = 'TH'">EA</xsl:when>
			<!-- tube -->
			<xsl:when test="$supplierUoM = 'TUB'">EA</xsl:when>
			<!-- Wallet -->
			<xsl:when test="$supplierUoM = 'WLT'">CS</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$supplierUoM"/>
			</xsl:otherwise>
		</xsl:choose>
	
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
