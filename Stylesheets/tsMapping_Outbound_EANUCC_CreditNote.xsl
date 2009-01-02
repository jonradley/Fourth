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
 02/01/2009	| Lee Boyton    | 2257 'ICreditNoteLine' corrected to 'CreditNoteLine' within XPaths.
******************************************************************************************
 02/01/2009 | Lee Boyton    | 2664. Removed time element from reference dates as failing Freeway validation.
******************************************************************************************
			  	|               |
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns="http://www.eanucc.org/2002/Pay/FoodService/FoodService/UK/EanUcc/Pay"
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				exclude-result-prefixes="fo script msxsl">
	<xsl:output method="xml"/>
	
	<!-- we use constants for default values -->
	<xsl:variable name="creditLineIndicator" select="'2'"/>
	<xsl:variable name="invoiceLineIndicator" select="'1'"/>
	
	<xsl:template match="/">
		<CreditNote>
		
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			      CREDIT NOTE DOCUMENT DETAILS 
			      ~~~~~~~~~~~~~~~~~~~~~~~ -->
			<CreditNoteDocumentDetails>
				<CreditNoteDocumentDate format="YYYY-MM-DD">
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
				</CreditNoteDocumentDate>
				
				<CreditNoteDocumentNumber scheme="OTHER">
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</CreditNoteDocumentNumber>
				
				<!-- Document Status is always going to be 7 - original -->
				<!-- ??should this be 9?? -->
				<DocumentStatus codeList="EANCOM">
					<xsl:text>7</xsl:text>
				</DocumentStatus>
			</CreditNoteDocumentDetails>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    INVOICE REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- if we have an InvoiceReferences tag the others must be there -->
			<xsl:if test="/CreditNote/CreditNoteHeader/InvoiceReferences">
				<InvoiceReference>
					<InvoiceDocumentDate format="YYYY-MM-DD">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
					</InvoiceDocumentDate>
	
					<InvoiceDocumentNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
					</InvoiceDocumentNumber>				
				</InvoiceReference> 
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TRADE AGREEMENT REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- If TradeAgreement exists then TradeAgreement/ContractReference must also exist -->	      
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement">
				<TradeAgreementReference>
				
					<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate">
						<ContractReferenceDate format="YYYY-MM-DD">
							<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractDate"/>
						</ContractReferenceDate>
					</xsl:if>
					
					<ContractReferenceNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/>
					</ContractReferenceNumber>				
				</TradeAgreementReference> 
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- If PurchaseOrderReferences exists then both date and reference must also exist -->	      			
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences">
				<OrderReference>
					<PurchaseOrderDate format="YYYY-MM-DD">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
					</PurchaseOrderDate>
	
					<PurchaseOrderNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
					</PurchaseOrderNumber>				
				</OrderReference> 
			</xsl:if>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    ORDER CONFIRMATION REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- If PurchaseOrderConfirmationReferences exists then both date and reference must also exist -->	      			
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences">
				<OrderConfirmationReference>
					<PurchaseOrderConfirmationDate format="YYYY-MM-DD">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
					</PurchaseOrderConfirmationDate>
	
					<PurchaseOrderConfirmationNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</PurchaseOrderConfirmationNumber>				
				</OrderConfirmationReference> 
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    DESPATCH REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- If DeliveryNoteReferences exists then both date and reference must also exist -->	      			
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences">
				<DespatchReference>
					<DespatchDocumentDate format="YYYY-MM-DD">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
					</DespatchDocumentDate>
	
					<DespatchDocumentNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
					</DespatchDocumentNumber>				
				</DespatchReference> 
			</xsl:if>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    RECEIPT ADVICE REFERENCE
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<!-- If GoodsReceivedNoteReferencesexists then both date and reference must also exist -->	      			
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences">			      
				<ReceiptAdviceReference>
					<ReceiptAdviceDocumentDate format="YYYY-MM-DD">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
					</ReceiptAdviceDocumentDate>
	
					<ReceiptAdviceDocumentNumber scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
					</ReceiptAdviceDocumentNumber>				
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
						<xsl:when test="string(/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN) = '5027615900022'">5029224000004</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
						</xsl:otherwise>
					</xsl:choose>					
				</BuyerGLN>
			
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
				
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>

				<!-- check for BuyersAddress - if we have that we must at least have AddressLine1 -->
				<!-- If not then the output from this mapper will be invalid against the schema -->
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress">								
					<Address>
						<BuildingIdentifier scheme="OTHER">
							<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
						</BuildingIdentifier>
	
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
							<StreetName scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
							</StreetName>
						</xsl:if>
						
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
							<City scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
							</City>
						</xsl:if>
						
						<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode">
							<PostCode scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode"/>
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
					<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
				</SellerGLN>
			
				<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</SellerAssigned>
				</xsl:if>
				
				<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>

				<!-- check for SuppliersAddress - if we have that we must at least have AddressLine1 -->
				<!-- If not then the output from this mapper will be invalid against the schema -->
				<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress">	
					<Address>
						<BuildingIdentifier scheme="OTHER">
							<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
						</BuildingIdentifier>
	
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
							<StreetName scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
							</StreetName>
						</xsl:if>
								
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
							<City scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
							</City>
						</xsl:if>
						
						<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode">
							<PostCode scheme="OTHER">
								<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/>
							</PostCode>
						</xsl:if>
						
						<Country codeList="ISO">
							<xsl:text>GB</xsl:text>
						</Country>
					</Address>
				</xsl:if>
					
				<VATRegisterationNumber scheme="OTHER">
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
				</VATRegisterationNumber>
				
			</Seller>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    SHIPTO
			      ~~~~~~~~~~~~~~~~~~~~~~~-->			
			<ShipTo>
				<ShipToGLN scheme="GLN">
					<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
				</ShipToGLN>
				
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
					</BuyerAssigned>
				</xsl:if>
				
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<SellerAssigned scheme="OTHER">
						<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</SellerAssigned>			
				</xsl:if>
			</ShipTo>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    TAX POINT DATE TIME
			      ~~~~~~~~~~~~~~~~~~~~~~~-->		
			<TaxPointDateTime format="YYYY-MM-DD">
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
			</TaxPointDateTime>
			
			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    CREDIT ITEM
			      ~~~~~~~~~~~~~~~~~~~~~~~-->					
			<xsl:for-each select="/CreditNote/CreditNoteDetail/CreditNoteLine">
				<xsl:sort select="LineNumber"/>
				
				<CreditItem>

					<!-- the reason code is omitted if not one af a load of valid values -->
					<xsl:if test="Narrative/@Code= '1' or Narrative/@Code = '2' or Narrative/@Code = '3' or Narrative/@Code = '4' or 
								Narrative/@Code = '5' or Narrative/@Code = '9' or Narrative/@Code = '14' or  Narrative/@Code = '16' or  
								Narrative/@Code = '17' or  Narrative/@Code = '18' or Narrative/@Code = '19' or Narrative/@Code = '20' or  
								Narrative/@Code = '32' or  Narrative/@Code = '35' or  Narrative/@Code = '52' or  Narrative/@Code = '56' or 
								Narrative/@Code = '57' or  Narrative/@Code = '66' or  Narrative/@Code = '68' or  Narrative/@Code = '69' or
								Narrative/@Code = '70' or Narrative/@Code = '11E'">
									
						<xsl:attribute name="ChangeReasonCoded">
							<xsl:value-of select="Narrative/@Code"/>
						</xsl:attribute>
					</xsl:if>
										
					<LineItemNumber scheme="OTHER">
						<xsl:value-of select="LineNumber"/>
					</LineItemNumber>
				
					<ItemIdentifier>
						<GTIN scheme="GTIN">
							<xsl:value-of select="ProductID/GTIN"/>
						</GTIN>
						
						<!-- we always use SuppliersProductCode as the alternate -->
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
								
								<xsl:value-of select="format-number(InvoicedQuantity,'0.000')"></xsl:value-of>						
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="unitCode">
									<xsl:text>EA</xsl:text>
								</xsl:attribute>				
								
								<xsl:text>0.000</xsl:text>				
							</xsl:otherwise>
						</xsl:choose>
					</InvoiceQuantity>
										
					<CreditQuantity>
						<xsl:attribute name="unitCode">
							<xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/>
						</xsl:attribute>
						
						<!-- if this is a negative line value we make it positive and set the credit line indicator accordingly -->
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0">
								<xsl:value-of select="format-number(CreditedQuantity, '0.000')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(CreditedQuantity * -1, '0.000')"/>
							</xsl:otherwise>
						</xsl:choose>						
											
					</CreditQuantity>			
					
					<UnitPrice Amount="GBP">
						<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
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
									<xsl:value-of select="format-number(LineDiscountValue,'0.00')"/>
								</DiscountValue>
							</xsl:if>
							
							<xsl:if test="LineDiscountRate">	
								<DiscountRate Format="PERCENT">
									<xsl:value-of select="format-number(LineDiscountRate,'0.00')"/>
								</DiscountRate>
							</xsl:if>
						</LineItemDiscount>
					</xsl:if>
					
					<VATDetails>
						<TaxCategory codeList="EANCOM">
							<xsl:value-of select="VATCode"/>
						</TaxCategory>
					
						<TaxRate Format="PERCENT">
							<xsl:value-of select="VATRate"/>						
						</TaxRate>
					</VATDetails>
					
					<!-- we base this upon whether we had a negative or positive line value -->					
					<CreditLineIndicator codeList="OFSCI">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) &lt; 0">
								<xsl:value-of select="$invoiceLineIndicator"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$creditLineIndicator"/>
							</xsl:otherwise>
						</xsl:choose>
					</CreditLineIndicator>	
				</CreditItem>			
			</xsl:for-each>

			<!-- ~~~~~~~~~~~~~~~~~~~~~~~
			    CREDIT TOTALS
			      ~~~~~~~~~~~~~~~~~~~~~~~-->
			<CreditTotals>
				<DocumentDiscountRate Format="PERCENT">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentDiscountRate, '0.00')"/>
				</DocumentDiscountRate>

				<SettlementDiscountRate Format="PERCENT">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementDiscountRate, '0.00')"/>
				</SettlementDiscountRate>
				
				<!-- loop through the VATSubTotal nodes -->	
				<xsl:for-each select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
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
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT, '0.00')"/>
				</SettlementSubTotal>
				
				<CreditNoteSubTotal Amount="GBP">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT, '0.00')"/>
				</CreditNoteSubTotal>
				
				<VATTotal Amount="GBP">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/VATAmount, '0.00')"/>
				</VATTotal>
				
				<SettlementCreditTotal Amount="GBP">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT, '0.00')"/>
				</SettlementCreditTotal>
				
				<TotalPayable Amount="GBP">
					<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/>
				</TotalPayable>					
									
			</CreditTotals>
		</CreditNote>
	</xsl:template>
</xsl:stylesheet>