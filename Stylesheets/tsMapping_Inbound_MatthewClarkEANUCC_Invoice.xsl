<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps EAN UCC format (OFSCI) Invoices into the King internal format
' The following details must be populated by subsequent processors:
' 	TradeSimpleHeader : 
'						Senders Name, Address1-4 and PostCode
'						RecipientsCodeForSender, RecipientsBranchReference, RecipientsName, Address1-4
'						TestFlag
'	InvoiceLine :
'						ProductDescription
'						Pack Size
'						OrderedQuantity (if not present)
'						ConfirmedQuantity
'						DeliveredQuantity
'
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name             | Description of modification
'******************************************************************************************
'21/05/2013    | S Hussain       | Case 6589: Supplier Product Code Formatting + Optimization
'******************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="MatthewClarkInclude.xsl"/>
	<xsl:output method="xml" indent="no"/>
	<xsl:variable name="CurrentDate" select="user:msGetTodaysDate()"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<Invoice>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							  TRADESIMPLE HEADER
						  ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<TradeSimpleHeader>
								<!-- SCR comes from Sellers code for buyer if there, else it comes from Buyer GLN -->
								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="string(/Invoice/ShipTo/SellerAssigned)">
											<xsl:value-of select="/Invoice/ShipTo/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/Invoice/Buyer/BuyerGLN"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>
								<!-- SBR used to pick out the PL Account code to be used in the trading relationship set up. This could be Buyer or Supplier value. -->
								<xsl:if test="string(/Invoice/TradeAgreementReference/ContractReferenceNumber) != '' ">
									<SendersBranchReference>
										<xsl:value-of select="/Invoice/TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if>
								<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors  -->
								<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode will be populated by subsequent 	processors -->
								<!-- the TestFlag will be populated by subsequent processors -->
							</TradeSimpleHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							  INVOICE HEADER
						  ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceHeader>
								<!-- the document status is always Original -->
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								<Buyer>
									<BuyersLocationID>
										<xsl:if test="string(/Invoice/Buyer/BuyerGLN) != '' ">
											<GLN>
												<xsl:value-of select="/Invoice/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(/Invoice/Buyer/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/Invoice/Buyer/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/Invoice/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="/Invoice/Buyer/Address/BuildingIdentifier"/>
										</AddressLine1>
										<xsl:if test="string(/Invoice/Buyer/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="/Invoice/Buyer/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(/Invoice/Buyer/Address/City)">
											<AddressLine3>
												<xsl:value-of select="/Invoice/Buyer/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/Invoice/Buyer/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="/Invoice/Buyer/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(/Invoice/Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="/Invoice/Seller/SellerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/Invoice/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/Invoice/Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									<SuppliersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(/Invoice/Seller/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="string(/Invoice/Seller/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="/Invoice/Seller/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/Address/City)">
											<AddressLine3>
												<xsl:value-of select="/Invoice/Seller/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/Invoice/Seller/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="/Invoice/Seller/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(/Invoice/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="/Invoice/ShipTo/ShipToGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/ShipTo/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/Invoice/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/Invoice/ShipTo/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="/Invoice/ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
									<!-- ShipTo name and address will be populated by subsequent processors -->
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="/Invoice/InvoiceDocumentDetails/InvoiceDocumentNumber"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T')"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(/Invoice/TaxPointDateTime, 'T')"/>
									</TaxPointDate>
									<xsl:if test="string(/Invoice/Seller/VATRegisterationNumber)">
										<VATRegNo>
											<xsl:value-of select="/Invoice/Seller/VATRegisterationNumber"/>
										</VATRegNo>
									</xsl:if>
								</InvoiceReferences>
							</InvoiceHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							  INVOICE DETAIL
						  ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceDetail>
								<xsl:for-each select="/Invoice/InvoiceItem">
									<xsl:sort select="LineItemNumber"/>
									<InvoiceLine>
										<LineNumber>
											<xsl:value-of select="LineItemNumber"/>
										</LineNumber>
										<xsl:if test="(/Invoice/OrderReference and normalize-space(/Invoice/OrderReference/PurchaseOrderNumber) != '') or /Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
											<PurchaseOrderReferences>
												<xsl:if test="/Invoice/OrderReference/PurchaseOrderNumber and normalize-space(/Invoice/OrderReference/PurchaseOrderNumber) != ''">
													<PurchaseOrderReference>
														<xsl:value-of select="normalize-space(/Invoice/OrderReference/PurchaseOrderNumber)"/>
													</PurchaseOrderReference>
												</xsl:if>
												<xsl:if test="/Invoice/OrderReference/PurchaseOrderNumber and /Invoice/OrderReference/PurchaseOrderNumber != ''">
													<xsl:call-template name="FormatDateTime">
														<xsl:with-param name="DateField">PurchaseOrderDate</xsl:with-param>
														<xsl:with-param name="TimeField">PurchaseOrderTime</xsl:with-param>
														<xsl:with-param name="Node" select="/Invoice/OrderReference/PurchaseOrderDate"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="/Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="/Invoice/TradeAgreementReference/ContractReferenceNumber"/>
														</ContractReference>
														<xsl:call-template name="FormatDate">
															<xsl:with-param name="DateField">ContractDate</xsl:with-param>
															<xsl:with-param name="Node" select="/Invoice/TradeAgreementReference/ContractReferenceNumber"/>
														</xsl:call-template>
													</TradeAgreement>
												</xsl:if>
											</PurchaseOrderReferences>
										</xsl:if>
										<xsl:if test="/Invoice/OrderConfirmationReference">
											<PurchaseOrderConfirmationReferences>
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationNumber"/>
												</PurchaseOrderConfirmationReference>
												<xsl:call-template name="FormatDate">
													<xsl:with-param name="DateField">PurchaseOrderConfirmationDate</xsl:with-param>
													<xsl:with-param name="Node" select="/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate"/>
												</xsl:call-template>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										<xsl:if test="/Invoice/DespatchReference">
											<DeliveryNoteReferences>
												<xsl:if test="/Invoice/DespatchReference/DespatchDocumentNumber">
													<DeliveryNoteReference>
														<xsl:value-of select="/Invoice/DespatchReference/DespatchDocumentNumber"/>
													</DeliveryNoteReference>
												</xsl:if>
												<xsl:call-template name="FormatDate">
													<xsl:with-param name="DateField">DeliveryNoteDate</xsl:with-param>
													<xsl:with-param name="Node" select="/Invoice/DespatchReference/DespatchDocumentDate"/>
												</xsl:call-template>
												<xsl:call-template name="FormatDate">
													<xsl:with-param name="DateField">DespatchDate</xsl:with-param>
													<xsl:with-param name="Node" select="/Invoice/DespatchReference/DespatchDocumentDate"/>
												</xsl:call-template>
											</DeliveryNoteReferences>
										</xsl:if>
										<xsl:if test="/Invoice/ReceiptAdviceReference">
											<GoodsReceivedNoteReferences>
												<GoodsReceivedNoteReference>
													<xsl:value-of select="/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentNumber"/>
												</GoodsReceivedNoteReference>
												<xsl:call-template name="FormatDate">
													<xsl:with-param name="DateField">GoodsReceivedNoteDate</xsl:with-param>
													<xsl:with-param name="Node" select="/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate"/>
												</xsl:call-template>
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
										<xsl:if test="OrderedQuantity">
											<OrderedQuantity><xsl:apply-templates select="OrderedQuantity"/></OrderedQuantity>
										</xsl:if>
										<InvoicedQuantity><xsl:apply-templates select="InvoiceQuantity"/></InvoicedQuantity>
										<xsl:if test="CreditQuantity">
											<CreditedQuantity><xsl:apply-templates select="CreditQuantity"/></CreditedQuantity>
										</xsl:if>
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
											<xsl:apply-templates select="VATDetails/TaxCategory"/>
										</VATCode>
										<VATRate>
											<xsl:choose>
												<xsl:when test="VATDetails/TaxRate">
													<xsl:apply-templates select="VATDetails/TaxRate"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="/Invoice/TaxPointDateTime !=''">
															<xsl:apply-templates select="/Invoice/TaxPointDateTime"/>
														</xsl:when>
														<xsl:when test="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate !=''">
															<xsl:apply-templates select="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate"/>
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
									</InvoiceLine>
								</xsl:for-each>
							</InvoiceDetail>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							  INVOICE TRAILER
						  ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(//InvoiceItem)"/>
								</NumberOfLines>
								<NumberOfItems>
									<xsl:value-of select="sum(//InvoiceItem/InvoiceQuantity)"/>
								</NumberOfItems>
								<!-- EAN.UCC only allows for one delivery per Invoice -->
								<NumberOfDeliveries>
									<xsl:text>1</xsl:text>
								</NumberOfDeliveries>
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/DocumentDiscountRate">
											<xsl:apply-templates select="/Invoice/InvoiceTotals/DocumentDiscountRate"/>
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
										<xsl:when test="/Invoice/InvoiceTotals/SettlementDiscountRate">
											<xsl:apply-templates select="/Invoice/InvoiceTotals/SettlementDiscountRate"/>
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
									<xsl:for-each select="/Invoice/InvoiceTotals/VATRateTotals">
										<VATSubTotal>
											<!-- store the VATRate and VATCode in variables as we use them more than once below -->
											<xsl:variable name="currentVATCode">
												<xsl:apply-templates select="VATDetails/TaxCategory"/>
											</xsl:variable>
											<xsl:variable name="currentVATRate">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxRate">
														<xsl:apply-templates select="VATDetails/TaxRate"/>
													</xsl:when>
													<xsl:otherwise>	
														<xsl:choose>
															<xsl:when test="/Invoice/TaxPointDateTime !=''">
																<xsl:apply-templates select="/Invoice/TaxPointDateTime"/>
															</xsl:when>
															<xsl:when test="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate !=''">
																<xsl:apply-templates select="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate"/>
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
												<xsl:apply-templates select="VATDetails/TaxRate"/>
											</xsl:variable>
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="$currentVATRate"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfLinesAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate])"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="count(//InvoiceItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)])"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfLinesAtRate>
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfItemsAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and $currentTAXRate = $currentVATRate and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate) and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//InvoiceItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[not(VATDetails/TaxCategory) and $currentTAXRate = $currentVATRate and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate) and not(InvoiceQuantity)])), '0.000')"/>
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
								<DocumentTotalExclVAT><xsl:apply-templates select="/Invoice/InvoiceTotals/InvoiceSubTotal"/></DocumentTotalExclVAT>
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
										<xsl:when test="/Invoice/InvoiceTotals/SettlementSubTotal">
											<xsl:apply-templates select="/Invoice/InvoiceTotals/SettlementSubTotal"/>
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
										<xsl:when test="/Invoice/InvoiceTotals/VATAmount">
											<xsl:apply-templates select="/Invoice/InvoiceTotals/VATAmount"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/VATPayable)"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT>
									<xsl:apply-templates select="/Invoice/InvoiceTotals/TotalPayable"/>
								</DocumentTotalInclVAT>
								<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalInclVAT>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/SettlementInvoiceTotal">
											<xsl:apply-templates select="/Invoice/InvoiceTotals/SettlementInvoiceTotal"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="FormatNumber">
												<xsl:with-param name="NumField" select="sum(//VATRateTotals/TaxableAmount) + sum (//VATRateTotals/VATPayable)"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalInclVAT>
							</InvoiceTrailer>
						</Invoice>
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
	
	<xsl:template match="OrderedQuantity | InvoiceQuantity | DespatchQuantity">
		<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="./@unitCode"/></xsl:attribute>
		<xsl:value-of select="format-number(., '0.000')"/>
	</xsl:template>
	
	<xsl:template match="UnitPrice | LineItemPrice | LineItemDiscount/DiscountRate | LineItemDiscount/DiscountValue | VATDetails/TaxRate |
									 /Invoice/InvoiceTotals/DocumentDiscountRate | /Invoice/InvoiceTotals/SettlementDiscountRate | DiscountedLineTotals | DocumentDiscountValue |
									 SettlementDiscountValue | TaxableAmount | VATPayable | /Invoice/InvoiceTotals/InvoiceSubTotal | /Invoice/InvoiceTotals/SettlementSubTotal | 
									 /Invoice/InvoiceTotals/VATAmount | /Invoice/InvoiceTotals/TotalPayable | /Invoice/InvoiceTotals/SettlementInvoiceTotal">
		<xsl:call-template name="FormatNumber">
			<xsl:with-param name="NumField" select="."/>
		</xsl:call-template>
	</xsl:template>	

	<xsl:template match="VATDetails/TaxCategory">
		<xsl:call-template name="decodeVATCode">
			<xsl:with-param name="VATCode" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="/Invoice/TaxPointDateTime | /Invoice/InvoiceDocumentDetails/InvoiceDocumentDate">
		<xsl:call-template name="decodeVATRate">
			<xsl:with-param name="VATRate" select="."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
