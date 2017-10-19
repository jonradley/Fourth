<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps EAN UCC format (OFSCI) Credit Notes into the King internal format
' The following details must be populated by subsequent processors:
' 	TradeSimpleHeader : 
'						Senders Name, Address1-4 and PostCode
'						RecipientsCodeForSender, RecipientsBranchReference, RecipientsName, Address1-4
'						TestFlag
'	CreditNoteHeader :
'						Buyer/BuyersName, Address1-4 and PostCode
'						Seller/SellersName, Address1-4 and PostCode
'						ShipTo/ShipToName, Address1-4 and PostCode
'	CreditNoteLine :
' 						ProductDescription
'						PackSize
'
'
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name              | Description of modification
'******************************************************************************************
' 20/04/2005  | Steven Hewitt | Created
'******************************************************************************************
' 26/07/2005  | A Sheppard    | 2344. Bug fix.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'	26/01/2007	|	Nigel Emsen	|	Case 710: Fairfax Adoption for Aramark. XPaths adjusted.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'	31/01/2007	| Lee Boyton   |	Case 767: Cater for an empty ContractReferenceNumber element.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'	06/12/2007 | Mark Emanuel | Changed Default Tax Rate to 20%	
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	<!-- we use constants for most default values -->
	<xsl:variable name="defaultTaxCategory" select="'S'"/>
	<xsl:variable name="defaultTaxRate" select="'20.0'"/>
	<xsl:variable name="defaultDocumentStatus" select="'Original'"/>
	<xsl:variable name="defaultUnitOfMeasure" select="'EA'"/>
	<xsl:variable name="defaultCreditQuantity" select="'1'"/>
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDiscountedLinesTotalExclVAT" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountValue" select="'0'"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<CreditNote>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      TRADESIMPLE HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<TradeSimpleHeader>
								<!-- SCR comes from Sellers code for buyer if there, else it comes from Buyer GLN -->
								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="string(/CreditNote/ShipTo/SellerAssigned)">
											<xsl:value-of select="/CreditNote/ShipTo/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/CreditNote/Buyer/BuyerGLN"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>
								<!-- SBR used to pick out the PL Account code to be used in the trading relationship set up. This could be Buyer or Supplier value. -->
								<xsl:if test="string(/CreditNote/TradeAgreementReference/ContractReferenceNumber) != '' ">
									<SendersBranchReference>
										<xsl:value-of select="/CreditNote/TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if>
								<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors  -->
								<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode will be populated by subsequent 	processors -->
								<!-- the TestFlag will be populated by subsequent processors -->
							</TradeSimpleHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CREDIT NOTE HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteHeader>
								<!-- the document status is always Original -->
								<DocumentStatus>
									<xsl:value-of select="$defaultDocumentStatus"/>
								</DocumentStatus>
								<Buyer>
									<BuyersLocationID>
										<xsl:if test="string(/CreditNote/Buyer/BuyerGLN) !='' ">
											<GLN>
												<xsl:value-of select="/CreditNote/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/CreditNote/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Buyer/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/CreditNote/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									<!-- Buyers name and address will be populated by subsequent processors -->
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(/CreditNote/Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="/CreditNote/Seller/SellerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/CreditNote/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/CreditNote/Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									<!-- Suppliers name and address will be populated by subsequent processors -->
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(/CreditNote/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="/CreditNote/ShipTo/ShipToGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/ShipTo/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/CreditNote/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/CreditNote/ShipTo/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/CreditNote/ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
									<!-- ShipTo name and address will be populated by subsequent processors -->
								</ShipTo>
								<xsl:if test="/CreditNote/InvoiceReference or /CreditNote/TaxPointDateTime or /CreditNote/Seller/VATRegisterationNumber">
									<InvoiceReferences>
										<xsl:if test="string(/CreditNote/InvoiceReference/InvoiceDocumentNumber)">
											<InvoiceReference>
												<xsl:value-of select="/CreditNote/InvoiceReference/InvoiceDocumentNumber"/>
											</InvoiceReference>
										</xsl:if>
										<xsl:if test="string(/CreditNote/InvoiceReference/InvoiceDocumentDate)">
											<InvoiceDate>
												<xsl:value-of select="substring-before(/CreditNote/InvoiceReference/InvoiceDocumentDate, 'T')"/>
											</InvoiceDate>
										</xsl:if>
										<xsl:if test="string(/CreditNote/TaxPointDateTime)">
											<TaxPointDate>
												<xsl:value-of select="substring-before(/CreditNote/TaxPointDateTime, 'T')"/>
											</TaxPointDate>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/VATRegisterationNumber)">
											<VATRegNo>
												<xsl:value-of select="/CreditNote/Seller/VATRegisterationNumber"/>
											</VATRegNo>
										</xsl:if>
									</InvoiceReferences>
								</xsl:if>
								<CreditNoteReferences>
									<CreditNoteReference>
										<xsl:value-of select="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentNumber"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<xsl:value-of select="substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T')"/>
									</CreditNoteDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(/CreditNote/TaxPointDateTime, 'T')"/>
									</TaxPointDate>
									<xsl:if test="string(/CreditNote/Seller/VATRegisterationNumber)">
										<VATRegNo>
											<xsl:value-of select="/CreditNote/Seller/VATRegisterationNumber"/>
										</VATRegNo>
									</xsl:if>
								</CreditNoteReferences>
							</CreditNoteHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CREDIT NOTE DETAIL
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteDetail>
								<xsl:for-each select="/CreditNote/CreditItem">
									<xsl:sort select="LineItemNumber"/>
									<CreditNoteLine>
										<LineNumber>
											<xsl:value-of select="LineItemNumber"/>
										</LineNumber>
										<xsl:if test="/CreditNote/OrderReference or /CreditNote/TradeAgreementReference/ContractReferenceNumber != ''">
											<PurchaseOrderReferences>
												<xsl:if test="/CreditNote/OrderReference/PurchaseOrderNumber">
													<PurchaseOrderReference>
														<xsl:value-of select="/CreditNote/OrderReference/PurchaseOrderNumber"/>
													</PurchaseOrderReference>
												</xsl:if>
												<xsl:if test="/CreditNote/OrderReference/PurchaseOrderNumber">
													<PurchaseOrderDate>
														<xsl:value-of select="substring-before(/CreditNote/OrderReference/PurchaseOrderDate,'T')"/>
													</PurchaseOrderDate>
													<PurchaseOrderTime>
														<xsl:value-of select="substring-after(/CreditNote/OrderReference/PurchaseOrderDate,'T')"/>
													</PurchaseOrderTime>
												</xsl:if>
												<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="/CreditNote/TradeAgreementReference/ContractReferenceNumber"/>
														</ContractReference>
														<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceDate">
															<ContractDate>
																<xsl:value-of select="substring-before(/CreditNote/TradeAgreementReference/ContractReferenceDate, 'T')"/>
															</ContractDate>
														</xsl:if>
													</TradeAgreement>
												</xsl:if>
											</PurchaseOrderReferences>
										</xsl:if>
										<xsl:if test="/CreditNote/OrderConfirmationReference">
											<PurchaseOrderConfirmationReferences>
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationNumber"/>
												</PurchaseOrderConfirmationReference>
												<xsl:if test="/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate">
													<PurchaseOrderConfirmationDate>
														<xsl:value-of select="substring-before(/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate, 'T')"/>
													</PurchaseOrderConfirmationDate>
												</xsl:if>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										<xsl:if test="/CreditNote/DespatchReference">
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="/CreditNote/DespatchReference/DespatchDocumentNumber"/>
												</DeliveryNoteReference>
												<xsl:if test="/CreditNote/DespatchReference/DespatchDocumentDate">
													<DeliveryNoteDate>
														<xsl:value-of select="substring-before(/CreditNote/DespatchReference/DespatchDocumentDate,'T')"/>
													</DeliveryNoteDate>
													<DespatchDate>
														<xsl:value-of select="substring-before(/CreditNote/DespatchReference/DespatchDocumentDate,'T')"/>
													</DespatchDate>
												</xsl:if>
											</DeliveryNoteReferences>
										</xsl:if>
										<xsl:if test="/CreditNote/ReceiptAdviceReference">
											<GoodsReceivedNoteReferences>
												<GoodsReceivedNoteReference>
													<xsl:value-of select="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentNumber"/>
												</GoodsReceivedNoteReference>
												<xsl:if test="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
													<GoodsReceivedNoteDate>
														<xsl:value-of select="substring-before(/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate, 'T')"/>
													</GoodsReceivedNoteDate>
												</xsl:if>
											</GoodsReceivedNoteReferences>
										</xsl:if>
										<ProductID>
											<GTIN>
												<xsl:choose>
													<xsl:when test="string(ItemIdentifier/GTIN) != '' ">
														<xsl:value-of select="ItemIdentifier/GTIN"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>55555555555555</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</GTIN>
											<xsl:if test="ItemIdentifier/AlternateCode">
												<SuppliersProductCode>
													<xsl:value-of select="ItemIdentifier/AlternateCode"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<ProductDescription>
											<xsl:choose>
												<xsl:when test="string(ItemDescription) != '' ">
													<xsl:value-of select="ItemDescription"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Helen</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</ProductDescription>
										<!-- Product Description is populated by subsequent processors -->
										<xsl:if test="InvoiceQuantity">
											<InvoicedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:attribute>
												<xsl:value-of select="format-number(InvoiceQuantity, '0.000')"/>
											</InvoicedQuantity>
										</xsl:if>
										<!-- Credited quantity is not mandatory in EAN.UCC but is in our internal format, default it if not found -->
										<CreditedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:choose><xsl:when test="CreditQuantity"><xsl:value-of select="CreditQuantity/@unitCode"/></xsl:when><xsl:otherwise><xsl:value-of select="$defaultUnitOfMeasure"/></xsl:otherwise></xsl:choose></xsl:attribute>
											<xsl:choose>
												<xsl:when test="CreditQuantity">
													<xsl:value-of select="format-number(CreditQuantity, '0.000')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number($defaultCreditQuantity, '0.000')"/>
												</xsl:otherwise>
											</xsl:choose>
										</CreditedQuantity>
										<!-- Pack Size is populated by subsequent processors -->
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(UnitPrice, '0.00')"/>
										</UnitValueExclVAT>
										<LineValueExclVAT>
											<xsl:value-of select="format-number(LineItemPrice, '0.00')"/>
										</LineValueExclVAT>
										<xsl:if test="LineItemDiscount/DiscountRate">
											<LineDiscountRate>
												<xsl:value-of select="format-number(LineItemDiscount/DiscountRate, '0.00')"/>
											</LineDiscountRate>
										</xsl:if>
										<xsl:if test="LineItemDiscount/DiscountValue">
											<LineDiscountValue>
												<xsl:value-of select="format-number(LineItemDiscount/DiscountValue, '0.00')"/>
											</LineDiscountValue>
										</xsl:if>
										<!-- we default VATCode and Rate if not found in the EAN.UCC document -->
										<VATCode>
											<xsl:choose>
												<xsl:when test="VATDetails/TaxCategory">
													<xsl:value-of select="VATDetails/TaxCategory"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$defaultTaxCategory"/>
												</xsl:otherwise>
											</xsl:choose>
										</VATCode>
										<VATRate>
											<xsl:choose>
												<xsl:when test="VATDetails/TaxRate">
													<xsl:value-of select="format-number(VATDetails/TaxRate, '0.00')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
												</xsl:otherwise>
											</xsl:choose>
										</VATRate>
										<!-- the reason code is omitted if not one af a load of valid numbers -->
										<xsl:if test="@ChangeReasonCoded = '1' or @ChangeReasonCoded = '2' or @ChangeReasonCoded = '3' or 	@ChangeReasonCoded = '4' or @ChangeReasonCoded = '5' or 
										 @ChangeReasonCoded = '9' or @ChangeReasonCoded = '14' or  @ChangeReasonCoded = '16' or @ChangeReasonCoded = '17' or @ChangeReasonCoded = '18' or  
										 @ChangeReasonCoded = '19' or @ChangeReasonCoded = '20' or  @ChangeReasonCoded = '32' or @ChangeReasonCoded = '35' or @ChangeReasonCoded = '52' or  
										 @ChangeReasonCoded = '56' or @ChangeReasonCoded = '57' or  @ChangeReasonCoded = '66' or @ChangeReasonCoded = '68' or @ChangeReasonCoded = '69' or
										 @ChangeReasonCoded = '70' or @ChangeReasonCoded = '11E'">
											<Narrative>
												<xsl:attribute name="Code"><xsl:value-of select="@ChangeReasonCoded"/></xsl:attribute>
											</Narrative>
										</xsl:if>
									</CreditNoteLine>
								</xsl:for-each>
							</CreditNoteDetail>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CREDIT NOTE TRAILER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(//CreditItem)"/>
								</NumberOfLines>
								<NumberOfItems>
									<xsl:value-of select="sum(//CreditItem/CreditQuantity)"/>
								</NumberOfItems>
								<!-- EAN.UCC only allows for one delivery per credit -->
								<NumberOfDeliveries>
									<xsl:text>1</xsl:text>
								</NumberOfDeliveries>
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/DocumentDiscountRate">
											<xsl:value-of select="format-number(/CreditNote/CreditTotals/DocumentDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementDiscountRate">
											<xsl:value-of select="format-number(/CreditNote/CreditTotals/SettlementDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscountRate>
								<!-- VATRateTotals are not mandatory in EAN.UCC but we have to assume at least some details will exist
					       to stand any chance at all of filling in any of our mandatory details -->
								<VATSubTotals>
									<xsl:for-each select="/CreditNote/CreditTotals/VATRateTotals">
										<VATSubTotal>
											<!-- store the VATRate and VATCode in variables as we use them more than once below -->
											<xsl:variable name="currentVATCode">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory">
														<xsl:value-of select="VATDetails/TaxCategory"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$defaultTaxCategory"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="currentVATRate">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxRate">
														<xsl:value-of select="VATDetails/TaxRate"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$defaultTaxRate"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfLinesAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="count(//CreditItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)])"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfLinesAtRate>
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfItemsAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//CreditItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00') and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate) and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//CreditItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00') and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate) and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfItemsAtRate>
											<xsl:if test="DiscountedLineTotals">
												<DiscountedLinesTotalExclVATAtRate>
													<xsl:value-of select="format-number(DiscountedLineTotals , '0.00')"/>
												</DiscountedLinesTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="DocumentDiscountValue">
												<DocumentDiscountAtRate>
													<xsl:value-of select="format-number(DocumentDiscountValue, '0.00')"/>
												</DocumentDiscountAtRate>
											</xsl:if>
											<!-- EAN.UCC also doesn't sum the values at a specific rate so we have to work it out. Code and Rate must be the same -->
											<DocumentTotalExclVATAtRate>
												<xsl:value-of select="format-number(DiscountedLineTotals - DocumentDiscountValue,'0.00')"/>
											</DocumentTotalExclVATAtRate>
											<xsl:if test="SettlementDiscountValue">
												<SettlementDiscountAtRate>
													<xsl:value-of select="format-number(SettlementDiscountValue, '0.00')"/>
												</SettlementDiscountAtRate>
											</xsl:if>
											<xsl:if test="TaxableAmount">
												<SettlementTotalExclVATAtRate>
													<xsl:value-of select="format-number(TaxableAmount, '0.00')"/>
												</SettlementTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="VATPayable">
												<VATAmountAtRate>
													<xsl:value-of select="format-number(VATPayable, '0.00')"/>
												</VATAmountAtRate>
											</xsl:if>
											<xsl:if test="DiscountedLineTotals and VATPayable">
												<DocumentTotalInclVATAtRate>
													<xsl:value-of select="format-number(number(DiscountedLineTotals) + number(VATPayable),'0.00')"/>
												</DocumentTotalInclVATAtRate>
											</xsl:if>
											<xsl:if test="TaxableAmount and VATPayable">
												<SettlementTotalInclVATAtRate>
													<xsl:value-of select="format-number(number(TaxableAmount) + number(VATPayable),'0.00')"/>
												</SettlementTotalInclVATAtRate>
											</xsl:if>
										</VATSubTotal>
									</xsl:for-each>
								</VATSubTotals>
								<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DiscountedLinesTotalExclVAT>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/DiscountedLineTotals) &gt; 0">
											<xsl:value-of select="format-number(sum(//VATRateTotals/DiscountedLineTotals),'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDiscountedLinesTotalExclVAT,'0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DiscountedLinesTotalExclVAT>
								<!-- DocumentDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DocumentDiscount>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/DocumentDiscountValue) &gt; 0">
											<xsl:value-of select="format-number(sum(//VATRateTotals/DocumentDiscountValue),'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscount>
								<DocumentTotalExclVAT>
									<xsl:value-of select="format-number(/CreditNote/CreditTotals/CreditNoteSubTotal, '0.00')"/>
								</DocumentTotalExclVAT>
								<!-- SettlementDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<SettlementDiscount>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/SettlementDiscountValue) &gt; 0">
											<xsl:value-of select="format-number(sum(//VATRateTotals/SettlementDiscountValue),'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountValue,'0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscount>
								<!-- we need a SettlementTotalExclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalExclVAT>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementSubTotal">
											<xsl:value-of select="format-number(/CreditNote/CreditTotals/SettlementSubTotal, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/TaxableAmount), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalExclVAT>
								<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<VATAmount>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/VATAmount">
											<xsl:value-of select="format-number(/CreditNote/CreditTotals/VATAmount, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/VATPayable), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT>
									<xsl:value-of select="format-number(/CreditNote/CreditTotals/TotalPayable, '0.00')"/>
								</DocumentTotalInclVAT>
								<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalInclVAT>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementCreditTotal">
											<xsl:value-of select="format-number(/CreditNote/CreditTotals/SettlementCreditTotal, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/TaxableAmount) + sum (//VATRateTotals/VATPayable),'0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalInclVAT>
							</CreditNoteTrailer>
						</CreditNote>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
