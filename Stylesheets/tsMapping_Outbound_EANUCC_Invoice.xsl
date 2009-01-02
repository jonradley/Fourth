<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
 Overview

 Maps Hospitality internal Invoices into the EAN UCC format (OFSCI)
 
 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date      	| Name          | Description of modification
******************************************************************************************
 28/05/2008	| R Cambridge   | 2257 copied from King/trunk/Stylesheets/tsMapping_Outbound_EANUCC_Invoice.xsl and then modified
******************************************************************************************
 30/06/2008	| R Cambridge   | 2257 temporary buyer GLN translation. 3663's dummy code needs to be translated to Moto's own code (issued by Freeway)
******************************************************************************************
30/06/2008	| M Dimant        | 2257 'IInvoice' changed to 'Invoice' within XPaths throughout mapper
******************************************************************************************
 02/01/2009 | Lee Boyton    | 2664. Removed time element from reference dates as failing Freeway validation.
******************************************************************************************
			  	|               |
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.eanucc.org/2002/Pay/FoodService/FoodService/UK/EanUcc/Pay">
	<xsl:output method="xml" encoding="utf-8"/>

	<!-- we use constants for default values -->
	<xsl:variable name="creditLineIndicator" select="'2'"/>
	<xsl:variable name="invoiceLineIndicator" select="'1'"/>
	
	<xsl:template match="/">
		<Invoice>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      INVOICE DOCUMENT DETAILS 
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<InvoiceDocumentDetails>
				<InvoiceDocumentDate format="YYYY-MM-DD">
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
				</InvoiceDocumentDate>
				
				<InvoiceDocumentNumber scheme="OTHER">
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</InvoiceDocumentNumber>
				
				<!-- Document Status is always going to be 7 - original -->
				<!-- ??should this be 9?? -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>7</xsl:text>
				</DocumentStatus>
			</InvoiceDocumentDetails>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TRADE AGREEMENT REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- if TradeAgreement exists then TradeAgreement/ContractReference must also exist -->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement">	
						      
 				<TradeAgreementReference>
			      
				   <xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate">
						<ContractReferenceDate format="YYYY-MM-DD">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
						</ContractReferenceDate>
					</xsl:if>
					
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
					</ContractReferenceNumber>				
				</TradeAgreementReference> 			
			</xsl:if>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate or /Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference">
				<OrderReference>
			
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate">
						<PurchaseOrderDate format="YYYY-MM-DD">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate>
					</xsl:if>
	
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference">
						<PurchaseOrderNumber scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
						</PurchaseOrderNumber>
					</xsl:if>				
				</OrderReference> 
			</xsl:if>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER CONFIRMATION REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate or /Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference">
				<OrderConfirmationReference>
				
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate">
						<PurchaseOrderConfirmationDate format="YYYY-MM-DD">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
						</PurchaseOrderConfirmationDate>
					</xsl:if>
					
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference">
						<PurchaseOrderConfirmationNumber scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						</PurchaseOrderConfirmationNumber>	
					</xsl:if>			
				</OrderConfirmationReference> 			
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    DESPATCH REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate or /Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference">

				<DespatchReference>
				
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate">
						<DespatchDocumentDate format="YYYY-MM-DD">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
						</DespatchDocumentDate>
					</xsl:if>
	
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference">
						<DespatchDocumentNumber scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
						</DespatchDocumentNumber>				
					</xsl:if>
				</DespatchReference> 
			</xsl:if>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    RECEIPT ADVICE REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate or /Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference">
   
				<ReceiptAdviceReference>

					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate">
						<ReceiptAdviceDocumentDate format="YYYY-MM-DD">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
						</ReceiptAdviceDocumentDate>
					</xsl:if>
	
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference">
						<ReceiptAdviceDocumentNumber scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
						</ReceiptAdviceDocumentNumber>
					</xsl:if>
				</ReceiptAdviceReference> 
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    BUYER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Buyer>
				<BuyerGLN scheme="GLN">
					<!-- 2257 temp translation while Moto suppliers are migrated to the correct GLN (...0004)
							from the dummy on created by 3663 (...0022)
					 -->
					<xsl:choose>
						<xsl:when test="string(/Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN) = '5027615900022'">5029224000004</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:otherwise>
					</xsl:choose>					
				</BuyerGLN>
			
				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>

				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
				
				<!-- check for BuyersAddress - if we have that we must at least have AddressLine1 -->
				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress">
					<Address>
						<BuildingIdentifier scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
						</BuildingIdentifier>
						
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2">
							<StreetName scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
							</StreetName>
						</xsl:if>
						
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3">
							<City scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
							</City>
						</xsl:if>
						
						<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode">						
							<PostCode scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
							</PostCode>
						</xsl:if>
						
						<Country codeList="ISO">
							<xsl:text>GB</xsl:text>
						</Country>
					</Address>
				</xsl:if>
			</Buyer>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SELLER
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<Seller>
				<SellerGLN scheme="GLN">
					<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
				</SellerGLN>
			
				<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
				
				<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>

				<!-- check for SellersAddress - if we have that we must at least have AddressLine1 -->
				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress">	
					<Address>
						<BuildingIdentifier scheme="OTHER">
							<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
						</BuildingIdentifier>
						
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2">
							<StreetName scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
							</StreetName>
						</xsl:if>
						
						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3">
							<City scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
							</City>
						</xsl:if>

						<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode">						
							<PostCode scheme="OTHER">
								<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
							</PostCode>
						</xsl:if>
							
						<Country codeList="ISO">
							<xsl:text>GB</xsl:text>
						</Country>
					</Address>					
				</xsl:if>				
									
				<VATRegisterationNumber scheme="OTHER">
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
				</VATRegisterationNumber>
				
			</Seller>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SHIPTO
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
				</ShipToGLN>
			
				<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">				
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
				
				<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode">				
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</SellerAssigned>			
				</xsl:if>
			</ShipTo>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TAX POINT DATE TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<TaxPointDateTime format="YYYY-MM-DD">
				<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
			</TaxPointDateTime>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    INVOICE ITEM
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">
				<xsl:sort select="LineNumber"/>
				
				<InvoiceItem>
									
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
				
					<ItemIdentifier>
						<GTIN scheme="GTIN">
							<xsl:value-of select="ProductID/GTIN"/>
						</GTIN>
						
						<!-- we always use Supplier's code for the alternate -->
						<xsl:if test="ProductID/SuppliersProductCode">
							<AlternateCode scheme="OTHER">
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</AlternateCode>
						</xsl:if>
					</ItemIdentifier>
					
					<!-- Invoice Quantity is mandatory in EAN.UCC so we default to a UOM of 'EA' and a quantity of 0 if missing from the internal document -->
					<InvoiceQuantity>
						<xsl:choose>
							<xsl:when test="InvoicedQuantity">
								<xsl:attribute name="unitCode">
									<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
								</xsl:attribute>
								
								<!-- if this is a negative line value we make it positive and set the credit line indicator accordingly -->
								<xsl:choose>
									<xsl:when test="number(LineValueExclVAT) >= 0">
										<xsl:value-of select="format-number(InvoicedQuantity, '0.000')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(InvoicedQuantity * -1, '0.000')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="unitCode">
									<xsl:text>EA</xsl:text>
								</xsl:attribute>				
								
								<xsl:text>0.000</xsl:text>				
							</xsl:otherwise>
						</xsl:choose>
					</InvoiceQuantity>

					<xsl:if test="OrderedQuantity">
						<OrderedQuantity>
							<xsl:attribute name="unitCode">
								<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
							</xsl:attribute>
							
							<xsl:value-of select="format-number(OrderedQuantity, '0.000')"></xsl:value-of>				
						</OrderedQuantity>			
					</xsl:if>
					
					<UnitPrice Amount="GBP">
						<xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/>
					</UnitPrice>		
					
					<LineItemPrice Amount="GBP">
						<!-- if this is a negative line value we make it positive and set the credit line indicator accordingly -->
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0">
								<xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(LineValueExclVAT * -1, '0.00')"/>
							</xsl:otherwise>
						</xsl:choose>								
					</LineItemPrice>
					
					<xsl:if test="LineDiscountValue or LineDiscountRate">
						<LineItemDiscount>
						
							<xsl:if test="LineDiscountValue">
								<DiscountValue Amount="GBP">
									<xsl:value-of select="format-number(LineDiscountValue, '0.00')"/>
								</DiscountValue>
							</xsl:if>
							
							<xsl:if test="LineDiscountRate">								
								<DiscountRate Format="PERCENT">
									<xsl:value-of select="format-number(LineDiscountRate, '0.00')"/>
								</DiscountRate>
							</xsl:if>
						</LineItemDiscount>
					</xsl:if>
					
					<VATDetails>
						<TaxCategory codeList="EANCOM">
							<xsl:value-of select="VATCode"/>
						</TaxCategory>
					
						<TaxRate Format="PERCENT">
							<xsl:value-of select="format-number(VATRate, '0.00')"/>						
						</TaxRate>
					</VATDetails>
					
					<!-- we base this upon whether we had a negative or positive line value -->					
					<CreditLineIndicator codeList="OFSCI">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) &lt; 0">
								<xsl:value-of select="$creditLineIndicator"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$invoiceLineIndicator"/>
							</xsl:otherwise>
						</xsl:choose>
					</CreditLineIndicator>	
				</InvoiceItem>			
			</xsl:for-each>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    INVOICE TOTALS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<InvoiceTotals>
				<DocumentDiscountRate Format="PERCENT">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentDiscountRate, '0.00')"/>
				</DocumentDiscountRate>

				<SettlementDiscountRate Format="PERCENT">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementDiscountRate, '0.00')"/>
				</SettlementDiscountRate>
				
				<!-- loop through the VATSubTotal nodes -->	
				<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
					<VATRateTotals>
						<VATDetails>
							<TaxCategory codeList="EANCOM">
								<xsl:value-of select="@VATCode"/>
							</TaxCategory>
							
							<TaxRate Format="PERCENT">
								<xsl:value-of select="format-number(@VATRate, '0.00')"/>
							</TaxRate>
						</VATDetails>
						
						<DiscountedLineTotals Amount="GBP">
							<xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/>	
						</DiscountedLineTotals>
						
						<DocumentDiscountValue Amount="GBP">	
							<xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/>
						</DocumentDiscountValue>
						
						<SettlementDiscountValue Amount="GBP">
							<xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/>
						</SettlementDiscountValue>
						
						<TaxableAmount Amount="GBP">
							<xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/>
						</TaxableAmount>
						
						<VATPayable Amount="GBP">
							<xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/>
						</VATPayable>
					</VATRateTotals>
				</xsl:for-each>
				
				<SettlementSubTotal Amount="GBP">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementTotalExclVAT, '0.00')"/>
				</SettlementSubTotal>
				
				<InvoiceSubTotal Amount="GBP">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalExclVAT, '0.00')"/>
				</InvoiceSubTotal>
				
				<VATTotal Amount="GBP">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/VATAmount, '0.00')"/>
				</VATTotal>
				
				<SettlementInvoiceTotal Amount="GBP">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementTotalInclVAT, '0.00')"/>
				</SettlementInvoiceTotal>
				
				<TotalPayable Amount="GBP">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalInclVAT, '0.00')"/>
				</TotalPayable>
				
			</InvoiceTotals>
		</Invoice>
	</xsl:template>
</xsl:stylesheet>