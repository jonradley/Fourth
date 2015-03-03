<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview	
'
' © Alternative Business Solutions Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date         | Name         | Description of modification
'******************************************************************************************
' 16/10/2007   | R Cambridge  | 1520 branched from tsMapping_Inbound_EANUCC_Detects_BUYERSCODES_Invoice.xsl 
'													use buyers code for shipto
'******************************************************************************************
' 11/12/2009 |S Sehgal  	| Case 3286 Added back code for VAT rate change from 17.5 to 15 and adapted to handle VAT changing back to 17.5% from 1-Jan-2010
'******************************************************************************************
' 24/07/2012 | M Dimant | 5591 Changes to handle discounts in the trailer.
'******************************************************************************************
' 27/03/2013 | H Robson | 6290 Remove bespoke functionality added ~6 years ago. Reintegrate SSP
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:data="blah">
	<xsl:output method="xml" encoding="utf-8"/>

	<!-- we use constants for default values -->
	<xsl:variable name="defaultTaxCategory" select="'S'"/>
	<xsl:variable name="NewTaxRate" select="'20.0'"/>
	<xsl:variable name="defaultTaxRate" select="'17.5'"/>
	<xsl:variable name="defaultDocumentStatus" select="'Original'"/>
	<xsl:variable name="defaultUnitOfMeasure" select="'EA'"/>
	<xsl:variable name="defaultInvoiceQuantity" select="'1'"/>
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDiscountedLinesTotalExclVAT" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountValue" select="'0'"/>
	<xsl:variable name="creditLineIndicator" select="'2'"/>
	<xsl:variable name="invoiceLineIndicator" select="'1'"/>
	<xsl:variable name="defaultNewTaxRate" select="'15'"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<Invoice>
						
								<!-- 27/03/2013 HR 6290 - DONT check for SSPs GLN in the include file, just tell the mapper its not there (even if it is) -->
								<!-- it does need to be there for other integrations (e.g. BOC) but NOT for Reynolds -->
								<xsl:variable name="sCheckFlag">
									<xsl:text>0</xsl:text>
								</xsl:variable>
						
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
												<xsl:value-of select="normalize-space(/Invoice/Buyer/BuyerGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(/Invoice/Buyer/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>										
										<xsl:if test="string(/Invoice/Buyer/SellerAssigned) != '' or string(/Invoice/Buyer/BuyerGLN != '')">
											<SuppliersCode>
												<xsl:choose>
													<!-- Only use suppliers code for buyer if it is definitely a GLN -->
													<xsl:when test="string(/Invoice/Buyer/SellerAssigned) != '' and (string-length(/Invoice/Buyer/SellerAssigned)=14 and translate(/Invoice/Buyer/SellerAssigned ,'1234567890','')='')" >
														<xsl:value-of select="normalize-space(/Invoice/Buyer/SellerAssigned)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="normalize-space(/Invoice/Buyer/BuyerGLN)"/>
													</xsl:otherwise>
												</xsl:choose>
												
											</SuppliersCode>
										</xsl:if>

										
									</BuyersLocationID>
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(/Invoice/Buyer/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="/Invoice/Buyer/Address/StreetName">
											<AddressLine2>
												<xsl:value-of select="normalize-space(/Invoice/Buyer/Address/StreetName)"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="/Invoice/Buyer/Address/City">
											<AddressLine3>
												<xsl:value-of select="normalize-space(/Invoice/Buyer/Address/City)"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/Invoice/Buyer/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="normalize-space(/Invoice/Buyer/Address/PostCode)"/>
											</PostCode>
										</xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(/Invoice/Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="normalize-space(/Invoice/Seller/SellerGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(/Invoice/Seller/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="normalize-space(/Invoice/Seller/SellerAssigned)"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									<SuppliersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(/Invoice/Seller/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="string(/Invoice/Seller/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="normalize-space(/Invoice/Seller/Address/StreetName)"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(/Invoice/Seller/Address/City)">
											<AddressLine3>
												<xsl:value-of select="normalize-space(/Invoice/Seller/Address/City)"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/Invoice/Seller/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="normalize-space(/Invoice/Seller/Address/PostCode)"/>
											</PostCode>
										</xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(/Invoice/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="normalize-space(/Invoice/ShipTo/ShipToGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/ShipTo/BuyerAssigned)">										
											<BuyersCode>
												<!-- Detect if a SSP invoice -->
												<xsl:choose>
													<xsl:when test="$sCheckFlag ='1' ">
														<!-- SSP amendment - ensure leading country code (usually '8') in 8 character codes are removed -->
														<xsl:value-of select="substring(normalize-space(/Invoice/ShipTo/BuyerAssigned),string-length(normalize-space(/Invoice/ShipTo/BuyerAssigned))-6)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="normalize-space(/Invoice/ShipTo/BuyerAssigned)"/>
													</xsl:otherwise>
												</xsl:choose>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/Invoice/ShipTo/SellerAssigned)">
											<SuppliersCode>
												<!-- Detect if a SSP invoice -->
												<xsl:choose>
													<!-- Buyers Code to be used. -->
													<xsl:when test="$sCheckFlag ='1' ">
														<!-- SSP amendment - ensure leading country code (usually '8') in 8 character codes are removed -->
														<xsl:value-of select="substring(normalize-space(/Invoice/ShipTo/BuyerAssigned),string-length(normalize-space(/Invoice/ShipTo/BuyerAssigned))-6)"/>
													</xsl:when>
													<!-- Sellers code to be used if present. -->
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="string(/Invoice/ShipTo/SellerAssigned)">
																<xsl:value-of select="normalize-space(/Invoice/ShipTo/SellerAssigned)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="normalize-space(/Invoice/Buyer/BuyerGLN)"/>
															</xsl:otherwise>
														</xsl:choose>
														<!--End of IS NOT a SSP Invoice -->
													</xsl:otherwise>
													<!-- End of Detect if a SSP invoice -->
												</xsl:choose>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
									<!-- ShipTo name and address will be populated by subsequent processors -->
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="normalize-space(/Invoice/InvoiceDocumentDetails/InvoiceDocumentNumber)"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="normalize-space(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T'))"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="normalize-space(substring-before(/Invoice/TaxPointDateTime, 'T'))"/>
									</TaxPointDate>
									<xsl:if test="string(/Invoice/Seller/VATRegisterationNumber) !=''">
										<VATRegNo>
											<xsl:value-of select="normalize-space(/Invoice/Seller/VATRegisterationNumber)"/>
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
											<xsl:value-of select="normalize-space(LineItemNumber)"/>
										</LineNumber>
										<xsl:if test="/Invoice/OrderReference or /Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
											<xsl:variable name="sPORef" select="normalize-space(/Invoice/OrderReference/PurchaseOrderNumber)"/>
											<xsl:variable name="sPODate" select="normalize-space(substring-before(/Invoice/OrderReference/PurchaseOrderDate,'T'))"/>
											<xsl:if test="$sPORef !='' and $sPODate !='' ">
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of select="$sPORef"/>
													</PurchaseOrderReference>
													<PurchaseOrderDate>
														<xsl:value-of select="$sPODate"/>
													</PurchaseOrderDate>
													<PurchaseOrderTime>
														<xsl:value-of select="normalize-space(substring-after(/Invoice/OrderReference/PurchaseOrderDate,'T'))"/>
													</PurchaseOrderTime>
												
												<xsl:if test="/Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="normalize-space(/Invoice/TradeAgreementReference/ContractReferenceNumber)"/>
														</ContractReference>
														<xsl:if test="/Invoice/TradeAgreementReference/ContractReferenceDate != ''">
															<ContractDate>
																<xsl:value-of select="normalize-space(substring-before(/Invoice/TradeAgreementReference/ContractReferenceDate, 'T'))"/>
															</ContractDate>
														</xsl:if>
													</TradeAgreement>
												</xsl:if>
												</PurchaseOrderReferences>
											</xsl:if>
										</xsl:if>
										<xsl:if test="/Invoice/OrderConfirmationReference and /Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate">
											<PurchaseOrderConfirmationReferences>
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="normalize-space(/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationNumber)"/>
												</PurchaseOrderConfirmationReference>
												<PurchaseOrderConfirmationDate>
													<xsl:value-of select="normalize-space(substring-before(/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate, 'T'))"/>
												</PurchaseOrderConfirmationDate>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										<xsl:if test="/Invoice/DespatchReference and /Invoice/DespatchReference/DespatchDocumentDate">
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="normalize-space(/Invoice/DespatchReference/DespatchDocumentNumber)"/>
												</DeliveryNoteReference>
												<DeliveryNoteDate>
													<xsl:value-of select="normalize-space(substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T'))"/>
												</DeliveryNoteDate>
												<DespatchDate>
													<xsl:value-of select="normalize-space(substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T'))"/>
												</DespatchDate>
											</DeliveryNoteReferences>
										</xsl:if>
										<xsl:if test="/Invoice/ReceiptAdviceReference and /Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
											<GoodsReceivedNoteReferences>
												<GoodsReceivedNoteReference>
													<xsl:value-of select="normalize-space(/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentNumber)"/>
												</GoodsReceivedNoteReference>
												<GoodsReceivedNoteDate>
													<xsl:value-of select="normalize-space(substring-before(/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate, 'T'))"/>
												</GoodsReceivedNoteDate>
											</GoodsReceivedNoteReferences>
										</xsl:if>
										<ProductID>
											<GTIN>
												<xsl:choose>
													<xsl:when test="string(ItemIdentifier/GTIN) != '' ">
														<xsl:value-of select="normalize-space(ItemIdentifier/GTIN)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>55555555555555</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</GTIN>
											<xsl:if test="ItemIdentifier/AlternateCode">
												<SuppliersProductCode>
													<xsl:value-of select="normalize-space(ItemIdentifier/AlternateCode)"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<xsl:if test="string(ItemIdentifier/Description) !='' ">
											<ProductDescription>
												<xsl:value-of select="ItemIdentifier/Description"/>
											</ProductDescription>	
										</xsl:if>																		
										<!-- Product Description is populated by subsequent processors -->
										<xsl:if test="OrderedQuantity">
											<OrderedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="normalize-space(OrderedQuantity/@unitCode)"/></xsl:attribute>
												<xsl:value-of select="format-number(OrderedQuantity, '0.000')"/>
											</OrderedQuantity>
										</xsl:if>
										<xsl:if test="InvoiceQuantity">
										<InvoicedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="normalize-space(InvoiceQuantity/@unitCode)"/></xsl:attribute>
											<xsl:choose>
												<xsl:when test="InvoiceQuantity">
													<!--if CreditLineIndicator is '2', make the InvoiceQuantity a negative number-->
													<xsl:if test="CreditLineIndicator = '2'"><xsl:text>-</xsl:text></xsl:if>
													<xsl:value-of select="format-number(InvoiceQuantity, '0.000')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="format-number($defaultInvoiceQuantity, '0.000')"/>
												</xsl:otherwise>
											</xsl:choose> 
										</InvoicedQuantity>
										</xsl:if>
										<!-- Pack Size is populated by subsequent processors -->
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(UnitPrice, '0.00')"/>
										</UnitValueExclVAT>
										<!--if CreditLineIndicator is '2', make the lineitemprice a negative number-->
										<LineValueExclVAT>
											<xsl:if test="CreditLineIndicator = '2'"><xsl:text>-</xsl:text></xsl:if>
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
													<xsl:value-of select="normalize-space(VATDetails/TaxCategory)"/>
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
													<xsl:choose>
														<xsl:when test="/Invoice/TaxPointDateTime !=''">
															<xsl:choose>
																	<xsl:when test="translate(normalize-space(substring-before(/Invoice/TaxPointDateTime, 'T')),'-','')  &gt;= translate('2011-01-04','-','')">
																		<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																	</xsl:when>
																	<xsl:when test="translate(substring-before(/Invoice/TaxPointDateTime, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(/Invoice/TaxPointDateTime, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																		 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																	</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate !=''">
														<xsl:choose>
																<xsl:when test="translate(normalize-space(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T')),'-','')  &gt;= translate('2011-01-04','-','')">
																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:when test="translate(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																	<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																</xsl:otherwise>
														</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="translate($CurrentDate,'-','')  &gt;= translate('2011-01-04','-','')">
																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">
																	<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																</xsl:otherwise>
															</xsl:choose>
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
									<xsl:value-of select="sum(//InvoiceItem[not(CreditLineIndicator) or normalize-space(CreditLineIndicator) ='1']/InvoiceQuantity) - sum(//InvoiceItem[normalize-space(CreditLineIndicator) ='2']/InvoiceQuantity)"/>
								</NumberOfItems>
								<!-- EAN.UCC only allows for one delivery per Invoice -->
								<NumberOfDeliveries>
									<xsl:text>1</xsl:text>
								</NumberOfDeliveries>
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/DocumentDiscountRate">
											<xsl:value-of select="format-number(/Invoice/InvoiceTotals/DocumentDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/SettlementDiscountRate">
											<xsl:value-of select="format-number(/Invoice/InvoiceTotals/SettlementDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscountRate>
								<!-- VATRateTotals are not mandatory in EAN.UCC but we have to assume at least some details will exist
					       to stand any chance at all of filling in any of our mandatory details -->
								<VATSubTotals>
									<xsl:for-each select="/Invoice/InvoiceTotals/VATRateTotals[TaxableAmount != 0]">
										<VATSubTotal>
											<!-- store the VATRate and VATCode in variables as we use them more than once below -->
											<xsl:variable name="currentVATCode">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory">
														<xsl:value-of select="normalize-space(VATDetails/TaxCategory)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$defaultTaxCategory"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="currentVATRate">
												<xsl:choose>
													<xsl:when test="VATDetails/TaxRate">
														<xsl:value-of select="normalize-space(VATDetails/TaxRate)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
																<xsl:when test="/Invoice/TaxPointDateTime !=''">
																	<xsl:choose>
																			<xsl:when test="translate(normalize-space(substring-before(/Invoice/TaxPointDateTime, 'T')),'-','')  &gt;= translate('2011-01-04','-','')">
																				<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																			</xsl:when>
																			<xsl:when test="translate(substring-before(/Invoice/TaxPointDateTime, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(/Invoice/TaxPointDateTime, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																				 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																			</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:when test="/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate !=''">
																	<xsl:choose>
																		<xsl:when test="translate(normalize-space(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T')),'-','')  &gt;= translate('2011-01-04','-','')">
																			<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																		</xsl:when>
																		<xsl:when test="translate(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(/Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																			<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:choose>
																		<xsl:when test="translate($CurrentDate,'-','')  &gt;= translate('2011-01-04','-','')">
																			<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																		</xsl:when>
																		<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">
																			<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																		</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																	</xsl:otherwise>
																</xsl:choose>
															   </xsl:otherwise>												
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<!--NumberOfLinesAtRate-->
											<!--xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="count(//InvoiceItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)])"/>
													</xsl:when>
												</xsl:choose-->
											<!--xsl:value-of select="count(//InvoiceItem[VATDetails/TaxCategory=$currentVATCode])"/-->
											<!--/NumberOfLinesAtRate-->
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<!--NumberOfItemsAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00') and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate) and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(//InvoiceItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00') and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="format-number(sum(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)]/InvoiceQuantity) + ($defaultInvoiceQuantity * count(//InvoiceItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate) and not(InvoiceQuantity)])), '0.000')"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfItemsAtRate-->
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
													<xsl:value-of select="format-number(number(DiscountedLineTotals - DocumentDiscountValue) + number(VATPayable),'0.00')"/>
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
									<xsl:value-of select="format-number(/Invoice/InvoiceTotals/InvoiceSubTotal, '0.00')"/>
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
										<xsl:when test="/Invoice/InvoiceTotals/SettlementSubTotal">
											<xsl:value-of select="format-number(/Invoice/InvoiceTotals/SettlementSubTotal, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/TaxableAmount), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalExclVAT>
								<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<VATAmount>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/VATAmount">
											<xsl:value-of select="format-number(/Invoice/InvoiceTotals/VATAmount, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/VATPayable), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT>
									<xsl:value-of select="format-number(/Invoice/InvoiceTotals/TotalPayable, '0.00')"/>
								</DocumentTotalInclVAT>
								<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalInclVAT>
									<xsl:choose>
										<xsl:when test="/Invoice/InvoiceTotals/SettlementInvoiceTotal">
											<xsl:value-of select="format-number(/Invoice/InvoiceTotals/SettlementInvoiceTotal, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/TaxableAmount) + sum (//VATRateTotals/VATPayable),'0.00')"/>
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
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : Rave Tech, 26/11/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
		{
			var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() ;
			
		
			return sYear + '-'+ sMonth +'-'+ sDate;
		}
	]]></msxsl:script>
</xsl:stylesheet>
