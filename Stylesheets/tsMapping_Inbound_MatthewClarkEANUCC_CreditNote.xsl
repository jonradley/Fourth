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
'26/01/2007  | Nigel Emsen	| Case 710: Fairfax Adoption for Aramark. XPaths adjusted.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'31/01/2007	| Lee Boyton      | Case 767: Cater for an empty ContractReferenceNumber element.
'******************************************************************************************
'26/11/2008	| Rave Tech      |	 Case 2592 Handled vat rate changing from 17.5 to 15 
'******************************************************************************************
' 14/12/2009 |S Sehgal  	| Case 3286 Changed to handle VAT changing back to 17.5% from 1-Jan-2010
'******************************************************************************************
' 21/05/2013    | S Hussain       | Case 6589: Supplier Product Code Formatting + Optimization
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:user="http://mycompany.com/mynamespace" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="MatthewClarkInclude.xsl"/>
	<xsl:output method="xml" indent="no"/>
	<xsl:variable name="CurrentDate" select="user:msGetTodaysDate()"/>
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
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="DateField">InvoiceDate</xsl:with-param>
												<xsl:with-param name="Node" select="/CreditNote/InvoiceReference/InvoiceDocumentDate"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="string(/CreditNote/TaxPointDateTime)">
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="DateField">TaxPointDate</xsl:with-param>
												<xsl:with-param name="Node" select="/CreditNote/TaxPointDateTime"/>
											</xsl:call-template>
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
									<xsl:call-template name="FormatDate">
										<xsl:with-param name="DateField">CreditNoteDate</xsl:with-param>
										<xsl:with-param name="Node" select="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
									</xsl:call-template>
									<xsl:call-template name="FormatDate">
										<xsl:with-param name="DateField">TaxPointDate</xsl:with-param>
										<xsl:with-param name="Node" select="/CreditNote/TaxPointDateTime"/>
									</xsl:call-template>
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
													<xsl:call-template name="FormatDateTime">
														<xsl:with-param name="DateField">PurchaseOrderDate</xsl:with-param>
														<xsl:with-param name="TimeField">PurchaseOrderTime</xsl:with-param>
														<xsl:with-param name="Node" select="/CreditNote/OrderReference/PurchaseOrderDate"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="/CreditNote/TradeAgreementReference/ContractReferenceNumber"/>
														</ContractReference>
														<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceDate">
															<xsl:call-template name="FormatDate">
																<xsl:with-param name="DateField">ContractDate</xsl:with-param>
																<xsl:with-param name="Node" select="/CreditNote/TradeAgreementReference/ContractReferenceDate"/>
															</xsl:call-template>
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
													<xsl:call-template name="FormatDate">
														<xsl:with-param name="DateField">PurchaseOrderConfirmationDate</xsl:with-param>
														<xsl:with-param name="Node" select="/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate"/>
													</xsl:call-template>
												</xsl:if>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										<xsl:if test="/CreditNote/DespatchReference">
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="/CreditNote/DespatchReference/DespatchDocumentNumber"/>
												</DeliveryNoteReference>
												<xsl:if test="/CreditNote/DespatchReference/DespatchDocumentDate">
													<xsl:call-template name="FormatDate">
														<xsl:with-param name="DateField">DeliveryNoteDate</xsl:with-param>
														<xsl:with-param name="Node" select="/CreditNote/DespatchReference/DespatchDocumentDate"/>
													</xsl:call-template>
													<xsl:call-template name="FormatDate">
														<xsl:with-param name="DateField">DespatchDate</xsl:with-param>
														<xsl:with-param name="Node" select="/CreditNote/DespatchReference/DespatchDocumentDate"/>
													</xsl:call-template>
												</xsl:if>
											</DeliveryNoteReferences>
										</xsl:if>
										<xsl:if test="/CreditNote/ReceiptAdviceReference">
											<GoodsReceivedNoteReferences>
												<GoodsReceivedNoteReference>
													<xsl:value-of select="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentNumber"/>
												</GoodsReceivedNoteReference>
												<xsl:if test="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
													<xsl:call-template name="FormatDate">
														<xsl:with-param name="DateField">GoodsReceivedNoteDate</xsl:with-param>
														<xsl:with-param name="Node" select="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate"/>
													</xsl:call-template>
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
											<xsl:apply-templates select="ItemIdentifier/AlternateCode"/>
										</ProductID>
										<!-- Product Description is populated by subsequent processors -->
										<xsl:if test="InvoiceQuantity">
											<InvoicedQuantity><xsl:apply-templates select="InvoiceQuantity"/></InvoicedQuantity>
										</xsl:if>
										<!-- Credited quantity is not mandatory in EAN.UCC but is in our internal format, default it if not found -->
										<CreditedQuantity><xsl:apply-templates select="CreditQuantity"/></CreditedQuantity>
										<!-- Pack Size is populated by subsequent processors -->
										<UnitValueExclVAT><xsl:apply-templates select="UnitPrice"/></UnitValueExclVAT>
										<LineValueExclVAT><xsl:apply-templates select="LineItemPrice"/></LineValueExclVAT>
										<xsl:if test="LineItemDiscount/DiscountRate">
											<LineDiscountRate><xsl:apply-templates select="LineItemDiscount/DiscountRate"/></LineDiscountRate>
										</xsl:if>
										<xsl:if test="LineItemDiscount/DiscountValue">
											<LineDiscountValue><xsl:apply-templates select="LineItemDiscount/DiscountValue"/></LineDiscountValue>
										</xsl:if>
										<!-- we default VATCode and Rate if not found in the EAN.UCC document -->
										<VATCode>
											<xsl:call-template name="decodeVATCode">
												<xsl:with-param name="VATCode" select="VATDetails/TaxCategory"/>
											</xsl:call-template>
										</VATCode>
										<VATRate>
											<xsl:choose>
												<xsl:when test="VATDetails/TaxRate">
													<xsl:apply-templates select="VATDetails/TaxRate"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="/CreditNote/TaxPointDateTime !=''">
															<xsl:apply-templates select="/CreditNote/TaxPointDateTime"/>
														</xsl:when>
														<xsl:when test="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
															<xsl:apply-templates select="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="decodeVATRate">
																<xsl:with-param name="VATRate" select="$CurrentDate"/>
															</xsl:call-template>
														</xsl:otherwise>												
												</xsl:choose>													
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
											<xsl:apply-templates select="/CreditNote/CreditTotals/DocumentDiscountRate"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="$defaultDocumentDiscountRate"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementDiscountRate">
											<xsl:apply-templates select="/CreditNote/CreditTotals/SettlementDiscountRate"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="$defaultSettlementDiscountRate"/>
											</xsl:call-template>
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
												<xsl:call-template name="decodeVATCode">
													<xsl:with-param name="VATCode" select="VATDetails/TaxCategory"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="currentVATRate">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxRate">
														<xsl:apply-templates select="VATDetails/TaxRate"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="/CreditNote/TaxPointDateTime !=''">
																<xsl:apply-templates select="/CreditNote/TaxPointDateTime"/>
															</xsl:when>
															<xsl:when test="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
																<xsl:apply-templates select="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="decodeVATRate">
																	<xsl:with-param name="VATRate" select="$CurrentDate"/>
																</xsl:call-template>
															</xsl:otherwise>												
														</xsl:choose>													
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="currentTAXRate">
												<xsl:value-of select="format-number(VATDetails/TaxRate, '0.00')"/>
											</xsl:variable>
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="$currentVATRate"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfLinesAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate])"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="count(//CreditItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate])"/>
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
														<xsl:value-of select="format-number(sum(//CreditItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate) and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//CreditItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)]/CreditQuantity) + ($defaultCreditQuantity * count(//CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate) and not(CreditQuantity)])), '0.000')"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfItemsAtRate>
											<xsl:if test="DiscountedLineTotals">
												<DiscountedLinesTotalExclVATAtRate><xsl:apply-templates select="DiscountedLineTotals"/></DiscountedLinesTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="DocumentDiscountValue">
												<DocumentDiscountAtRate><xsl:apply-templates select="DocumentDiscountValue"/></DocumentDiscountAtRate>
											</xsl:if>
											<!-- EAN.UCC also doesn't sum the values at a specific rate so we have to work it out. Code and Rate must be the same -->
											<DocumentTotalExclVATAtRate>
												<xsl:call-template name="FormatNumber">
													<xsl:with-param name="NumField" select="DiscountedLineTotals - DocumentDiscountValue"/>
												</xsl:call-template>
											</DocumentTotalExclVATAtRate>
											<xsl:if test="SettlementDiscountValue">
												<SettlementDiscountAtRate><xsl:apply-templates select="SettlementDiscountValue"/></SettlementDiscountAtRate>
											</xsl:if>
											<xsl:if test="TaxableAmount">
												<SettlementTotalExclVATAtRate><xsl:apply-templates select="TaxableAmount"/></SettlementTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="VATPayable">
												<VATAmountAtRate><xsl:apply-templates select="VATPayable"/></VATAmountAtRate>
											</xsl:if>
											<xsl:if test="DiscountedLineTotals and VATPayable">
												<DocumentTotalInclVATAtRate>
													<xsl:call-template name="FormatNumber">
														<xsl:with-param name="NumField" select="number(DiscountedLineTotals) + number(VATPayable)"/>
													</xsl:call-template>
												</DocumentTotalInclVATAtRate>
											</xsl:if>
											<xsl:if test="TaxableAmount and VATPayable">
												<SettlementTotalInclVATAtRate>
													<xsl:call-template name="FormatNumber">
														<xsl:with-param name="NumField" select="number(TaxableAmount) + number(VATPayable)"/>
													</xsl:call-template>
												</SettlementTotalInclVATAtRate>
											</xsl:if>
										</VATSubTotal>
									</xsl:for-each>
								</VATSubTotals>
								<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DiscountedLinesTotalExclVAT>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/DiscountedLineTotals) &gt; 0">
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/DiscountedLineTotals)"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="$defaultDiscountedLinesTotalExclVAT"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</DiscountedLinesTotalExclVAT>
								<!-- DocumentDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DocumentDiscount>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/DocumentDiscountValue) &gt; 0">
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/DocumentDiscountValue)"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="$defaultDocumentDiscountValue"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscount>
								<DocumentTotalExclVAT><xsl:apply-templates select="/CreditNote/CreditTotals/CreditNoteSubTotal"/></DocumentTotalExclVAT>
								<!-- SettlementDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<SettlementDiscount>
									<xsl:choose>
										<xsl:when test="count(//VATRateTotals/SettlementDiscountValue) &gt; 0">
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/SettlementDiscountValue)"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="$defaultSettlementDiscountValue"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscount>
								<!-- we need a SettlementTotalExclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalExclVAT>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementSubTotal">
											<xsl:apply-templates select="/CreditNote/CreditTotals/SettlementSubTotal"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/TaxableAmount)"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalExclVAT>
								<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<VATAmount>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/VATAmount">
											<xsl:apply-templates select="/CreditNote/CreditTotals/VATAmount"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/VATPayable)"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT><xsl:apply-templates select="/CreditNote/CreditTotals/TotalPayable"/></DocumentTotalInclVAT>
								<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalInclVAT>
									<xsl:choose>
										<xsl:when test="/CreditNote/CreditTotals/SettlementCreditTotal">
											<xsl:apply-templates select="/CreditNote/CreditTotals/SettlementCreditTotal"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/TaxableAmount) + sum (//VATRateTotals/VATPayable)"/>
											</xsl:call-template>
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
	
	<xsl:template match="ItemIdentifier/AlternateCode">
		<xsl:if test=".">
			<SuppliersProductCode>
				<xsl:call-template name="FormatCustomerProductCode">
					<xsl:with-param name="sProductCode" select="normalize-space(.)"/>
					<xsl:with-param name="sUOM" select="../../InvoiceQuantity/@unitCode"/>
				</xsl:call-template>
			</SuppliersProductCode>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="InvoiceQuantity | CreditQuantity">
		<xsl:attribute name="UnitOfMeasure">
			<xsl:choose>
				<xsl:when test="."><xsl:value-of select="./@unitCode"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$defaultUnitOfMeasure"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test=". or name() = 'InvoiceQuantity'"><xsl:value-of select="format-number(., '0.000')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="format-number($defaultCreditQuantity, '0.000')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="UnitPrice | LineItemPrice | LineItemDiscount/DiscountRate | LineItemDiscount/DiscountValue | VATDetails/TaxRate |
									 /CreditNote/CreditTotals/DocumentDiscountRate | /CreditNote/CreditTotals/SettlementDiscountRate | DiscountedLineTotals |
									 DocumentDiscountValue | SettlementDiscountValue | TaxableAmount | VATPayable | 
									 /CreditNote/CreditTotals/CreditNoteSubTotal | /CreditNote/CreditTotals/SettlementSubTotal | /CreditNote/CreditTotals/VATAmount |
									 /CreditNote/CreditTotals/TotalPayable">
		<xsl:call-template name="FormatNumber">
			<xsl:with-param name="NumField" select="."/>
		</xsl:call-template>
	</xsl:template>	
	
	<xsl:template match="/CreditNote/TaxPointDateTime | /CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate">
		<xsl:call-template name="decodeVATRate">
			<xsl:with-param name="VATRate" select="."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
