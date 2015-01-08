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
'27/11/2008	  | Rave Tech     | 2592 Handled vat rate changing from 17.5 to 15 
'******************************************************************************************
' 05/10/2009   | R Cambridge  | 3155 Handle PL accounts for customers other than SSP (logic copied from tsMapping_Inbound_EANUCC_Detects_BUYERSCODES_Invoice_Reynolds.xsl)
'******************************************************************************************
' 14/12/2009 |S Sehgal  	| Case 3286 Changed to handle VAT changing back to 17.5% from 1-Jan-2010
'******************************************************************************************
' 19/04/2012 | H Robson  	| 5422 When a UOM of PC is sent convert to EA for all customers.
'******************************************************************************************
' 24/07/2012 | M Dimant | 5591 Changes to handle discounts in the trailer.
'******************************************************************************************
' 27/03/2013 | H Robson | 6291 Remove bespoke functionality added ~6 years ago. Reintegrate SSP
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	
	<!-- we use constants for most default values -->
	<xsl:variable name="defaultTaxCategory" select="'S'"/>
	<xsl:variable name="NewTaxRate" select="'20.0'"/>
	<xsl:variable name="defaultTaxRate" select="'17.5'"/>
	<xsl:variable name="defaultDocumentStatus" select="'Original'"/>
	<xsl:variable name="defaultUnitOfMeasure" select="'EA'"/>
	<xsl:variable name="defaultCreditQuantity" select="'1'"/>
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDiscountedLinesTotalExclVAT" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountValue" select="'0'"/>
	<xsl:variable name="defaultNewTaxRate" select="'15'"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<CreditNote>
						
								<!-- 27/03/2013 HR 6291 - DONT check for SSPs GLN in the include file, just tell the mapper its not there (even if it is) -->
								<!-- it does need to be there for other integrations (e.g. BOC) but NOT for Reynolds -->
								<xsl:variable name="sCheckFlag">
									<xsl:text>0</xsl:text>
								</xsl:variable>
						<xsl:variable name="taxDate">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/TaxPointDateTime, 'T'))"/>
								</xsl:call-template>
						</xsl:variable>
			      			<xsl:variable name="docDate">
							<xsl:call-template name="formatDate">
								<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'))"/>
							</xsl:call-template>
						</xsl:variable>						
						
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
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/BuyerGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>
										<!--xsl:if test="string(/CreditNote/Buyer/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/SellerAssigned)"/>
											</SuppliersCode>
										</xsl:if-->
										
										<xsl:if test="string(/CreditNote/Buyer/SellerAssigned) != '' or string(/CreditNote/Buyer/BuyerGLN != '')">
											<SuppliersCode>
												<xsl:choose>
													<!-- Only use suppliers code for buyer if it is definitely a GLN -->
													<xsl:when test="string(/CreditNote/Buyer/SellerAssigned) != '' and (string-length(/CreditNote/Buyer/SellerAssigned)=14 and translate(/CreditNote/Buyer/SellerAssigned ,'1234567890','')='')" >
														<xsl:value-of select="normalize-space(/CreditNote/Buyer/SellerAssigned)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="normalize-space(/CreditNote/Buyer/BuyerGLN)"/>
													</xsl:otherwise>
												</xsl:choose>												
											</SuppliersCode>
										</xsl:if>
										
									</BuyersLocationID>
									
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(/CreditNote/Buyer/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="/CreditNote/Buyer/Address/StreetName">
											<AddressLine2>
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/Address/StreetName)"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="/CreditNote/Buyer/Address/City">
											<AddressLine3>
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/Address/City)"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/CreditNote/Buyer/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="normalize-space(/CreditNote/Buyer/Address/PostCode)"/>
											</PostCode>
										</xsl:if>
									</BuyersAddress>
									
								</Buyer>
								
								<Supplier>
								
									<SuppliersLocationID>
										<xsl:if test="string(/CreditNote/Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/SellerGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/SellerAssigned)"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									
									<SuppliersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(/CreditNote/Seller/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="string(/CreditNote/Seller/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/Address/StreetName)"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/Address/City)">
											<AddressLine3>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/Address/City)"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(/CreditNote/Seller/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/Address/PostCode)"/>
											</PostCode>
										</xsl:if>
									</SuppliersAddress>
									
								</Supplier>
								
								
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(/CreditNote/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="normalize-space(/CreditNote/ShipTo/ShipToGLN)"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/CreditNote/ShipTo/BuyerAssigned)">
											<BuyersCode>
												<!-- Detect if a SSP invoice -->
												<xsl:choose>
													<xsl:when test="$sCheckFlag ='1' ">
														<!-- SSP amendment - ensure leading country code (usually '8') in 8 character codes are removed -->
														<xsl:value-of select="substring(normalize-space(/CreditNote/ShipTo/BuyerAssigned),string-length(normalize-space(/CreditNote/ShipTo/BuyerAssigned))-6)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="normalize-space(/CreditNote/ShipTo/BuyerAssigned)"/>
													</xsl:otherwise>
												</xsl:choose>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(/CreditNote/ShipTo/SellerAssigned)">
											<SuppliersCode>

												<!-- Detect if a SSP invoice -->
												<xsl:choose>
													<!-- Buyers Code to be used. -->
													<xsl:when test="$sCheckFlag ='1' ">
														<!-- SSP amendment - ensure leading country code (usually '8') in 8 character codes are removed -->
														<xsl:value-of select="substring(normalize-space(/CreditNote/ShipTo/BuyerAssigned),string-length(normalize-space(/CreditNote/ShipTo/BuyerAssigned))-6)"/>										
													</xsl:when>
													<!-- Sellers code to be used if present. -->
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="string(/CreditNote/ShipTo/SellerAssigned)">
																<xsl:value-of select="normalize-space(/CreditNote/ShipTo/SellerAssigned)"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="normalize-space(/CreditNote/Buyer/BuyerGLN)"/>
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
								
								
								<xsl:if test="/CreditNote/InvoiceReference or /CreditNote/TaxPointDateTime or /CreditNote/Seller/VATRegisterationNumber">
									<InvoiceReferences>
										<xsl:if test="string(/CreditNote/InvoiceReference/InvoiceDocumentNumber)">
											<InvoiceReference>
												<xsl:value-of select="normalize-space(/CreditNote/InvoiceReference/InvoiceDocumentNumber)"/>
											</InvoiceReference>
										</xsl:if>
										<xsl:if test="string(/CreditNote/InvoiceReference/InvoiceDocumentDate)">
											<InvoiceDate>
												<!--xsl:value-of select="normalize-space(substring-before(/CreditNote/InvoiceReference/InvoiceDocumentDate, 'T'))"/-->
												<xsl:call-template name="formatDate">
													<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/InvoiceReference/InvoiceDocumentDate, 'T'))"/>
												</xsl:call-template>

											</InvoiceDate>
										</xsl:if>
										<xsl:if test="string(/CreditNote/TaxPointDateTime)">
											<TaxPointDate>
												<!--xsl:value-of select="normalize-space(substring-before(/CreditNote/TaxPointDateTime, 'T'))"/-->
												<xsl:call-template name="formatDate">
													<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/TaxPointDateTime, 'T'))"/>
												</xsl:call-template>

											</TaxPointDate>
											
										</xsl:if>
										<xsl:if test="string(/CreditNote/Seller/VATRegisterationNumber)">
											<VATRegNo>
												<xsl:value-of select="normalize-space(/CreditNote/Seller/VATRegisterationNumber)"/>
											</VATRegNo>
										</xsl:if>
									</InvoiceReferences>
								</xsl:if>
								
								
								<CreditNoteReferences>
									<CreditNoteReference>
										<xsl:value-of select="normalize-space(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentNumber)"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<!--xsl:value-of select="normalize-space(substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'))"/-->
										
										<xsl:call-template name="formatDate">
											<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'))"/>
										</xsl:call-template>
										
									</CreditNoteDate>
									<TaxPointDate>
										<!--xsl:value-of select="normalize-space(substring-before(/CreditNote/TaxPointDateTime, 'T'))"/-->
										<xsl:call-template name="formatDate">
											<xsl:with-param name="value" select="normalize-space(substring-before(/CreditNote/TaxPointDateTime, 'T'))"/>
										</xsl:call-template>

									</TaxPointDate>
									<xsl:if test="string(/CreditNote/Seller/VATRegisterationNumber)">
										<VATRegNo>
											<xsl:value-of select="normalize-space(/CreditNote/Seller/VATRegisterationNumber)"/>
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
											<xsl:value-of select="normalize-space(LineItemNumber)"/>
										</LineNumber>
										
										<xsl:if test="/CreditNote/OrderReference or /CreditNote/TradeAgreementReference/ContractReferenceNumber != ''">
										
											<xsl:variable name="sPORef" select="normalize-space(/CreditNote/OrderReference/PurchaseOrderNumber)"/>
											<xsl:variable name="sPODate" select="normalize-space(substring-before(/CreditNote/OrderReference/PurchaseOrderDate,'T'))"/>
											<xsl:if test="$sPORef !='' and $sPODate !='' ">
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of select="$sPORef"/>
													</PurchaseOrderReference>
													<PurchaseOrderDate>
														<xsl:value-of select="$sPODate"/>
													</PurchaseOrderDate>
													<PurchaseOrderTime>
														<xsl:value-of select="normalize-space(substring-after(/CreditNote/OrderReference/PurchaseOrderDate,'T'))"/>
													</PurchaseOrderTime>

												
												<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="normalize-space(/CreditNote/TradeAgreementReference/ContractReferenceNumber)"/>
														</ContractReference>
														<xsl:if test="/CreditNote/TradeAgreementReference/ContractReferenceDate">
															<ContractDate>
																<xsl:value-of select="normalize-space(substring-before(/CreditNote/TradeAgreementReference/ContractReferenceDate, 'T'))"/>
															</ContractDate>
														</xsl:if>
													</TradeAgreement>
												</xsl:if>
											</PurchaseOrderReferences>
										</xsl:if>
										</xsl:if>
										<xsl:if test="/CreditNote/OrderConfirmationReference and /CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate">

											<PurchaseOrderConfirmationReferences>
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="normalize-space(/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationNumber)"/>
												</PurchaseOrderConfirmationReference>
												<xsl:if test="/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate">
													<PurchaseOrderConfirmationDate>
														<xsl:value-of select="normalize-space(substring-before(/CreditNote/OrderConfirmationReference/PurchaseOrderConfirmationDate, 'T'))"/>
													</PurchaseOrderConfirmationDate>
												</xsl:if>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										
										<xsl:if test="/CreditNote/DespatchReference and /CreditNote/DespatchReference/DespatchDocumentDate">
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="normalize-space(/CreditNote/DespatchReference/DespatchDocumentNumber)"/>
												</DeliveryNoteReference>
												<xsl:if test="/CreditNote/DespatchReference/DespatchDocumentDate">
													<DeliveryNoteDate>
														<xsl:value-of select="normalize-space(substring-before(/CreditNote/DespatchReference/DespatchDocumentDate,'T'))"/>
													</DeliveryNoteDate>
													<DespatchDate>
														<xsl:value-of select="normalize-space(substring-before(/CreditNote/DespatchReference/DespatchDocumentDate,'T'))"/>
													</DespatchDate>
												</xsl:if>
											</DeliveryNoteReferences>
										</xsl:if>
										
										<xsl:if test="/CreditNote/ReceiptAdviceReference and /CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
											<GoodsReceivedNoteReferences>
												<GoodsReceivedNoteReference>
													<xsl:value-of select="normalize-space(/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentNumber)"/>
												</GoodsReceivedNoteReference>
												<xsl:if test="/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
													<GoodsReceivedNoteDate>
														<xsl:value-of select="normalize-space(substring-before(/CreditNote/ReceiptAdviceReference/ReceiptAdviceDocumentDate, 'T'))"/>
													</GoodsReceivedNoteDate>
												</xsl:if>
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
										
										<!-- Product Description is populated by subsequent processors -->
										<xsl:if test="InvoiceQuantity">
											<InvoicedQuantity>
												<!-- 2012-04-19 5422 When a UOM of PC is sent convert to EA for all customers.-->
												<xsl:attribute name="UnitOfMeasure">
													<xsl:variable name="InvoiceUoM" select="normalize-space(InvoiceQuantity/@unitCode)"/>
													<xsl:choose>
														<xsl:when test="$InvoiceUoM = 'PC'">EA</xsl:when>
														<xsl:otherwise><xsl:value-of select="$InvoiceUoM"/></xsl:otherwise>
													</xsl:choose>	
												</xsl:attribute>
												<xsl:value-of select="format-number(InvoiceQuantity, '0.000')"/>
											</InvoicedQuantity>
										</xsl:if>
										
										<!-- Credited quantity is not mandatory in EAN.UCC but is in our internal format, default it if not found -->
										<CreditedQuantity>
											<!-- 2012-04-19 5422 When a UOM of PC is sent convert to EA for all customers.-->
											<xsl:attribute name="UnitOfMeasure">
												<xsl:choose>
													<xsl:when test="CreditQuantity">
														<xsl:variable name="CreditUoM" select="normalize-space(CreditQuantity/@unitCode)"/>
														<xsl:choose>
															<xsl:when test="$CreditUoM= 'PC'">EA</xsl:when>
															<xsl:otherwise><xsl:value-of select="$CreditUoM"/></xsl:otherwise>
														</xsl:choose>	
													</xsl:when>
													<xsl:otherwise><xsl:value-of select="$defaultUnitOfMeasure"/></xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="CreditQuantity">
													<!--if CreditLineIndicator is '1', make the CreditQuantity a negative number-->
													<xsl:if test="CreditLineIndicator = '1'"><xsl:text>-</xsl:text></xsl:if>
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
										
										<!--if CreditLineIndicator is '1', make the lineitemprice a negative number-->
										<LineValueExclVAT>
											<xsl:if test="CreditLineIndicator = '1'"><xsl:text>-</xsl:text></xsl:if>
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
															<xsl:when test="/CreditNote/TaxPointDateTime !=''">
																<xsl:choose>
																	<xsl:when test="translate(substring-before(/CreditNote/TaxPointDateTime, 'T'),'-','')  &gt;= translate('2011-01-04','-','')">
	 																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/> 								
																	</xsl:when>
																	<xsl:when test="translate($taxDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($taxDate,'-','')  &gt;= translate('2010-01-01','-','')">
																		 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:when>
															<xsl:when test="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
																<xsl:choose>
																	<xsl:when test="translate(substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &gt;= translate('2011-01-04','-','')">
																		<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																	</xsl:when>
																	<xsl:when test="translate($docDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($docDate,'-','')  &gt;= translate('2010-01-01','-','')">
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
									<xsl:value-of select="sum(//CreditItem[not(CreditLineIndicator) or normalize-space(CreditLineIndicator) ='2']/CreditQuantity) - sum(//CreditItem[normalize-space(CreditLineIndicator) ='1']/CreditQuantity)"/>
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
																<xsl:when test="/CreditNote/TaxPointDateTime !=''">
																	<xsl:choose>
																		<xsl:when test="translate(substring-before(/CreditNote/TaxPointDateTime, 'T'),'-','')  &gt;= translate('2011-01-04','-','')">
																			<xsl:value-of select="format-number($NewTaxRate, '0.00')"/> 								
																		</xsl:when>
																		<xsl:when test="translate($taxDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($taxDate,'-','')  &gt;= translate('2010-01-01','-','')">
																			 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:when>
																<xsl:when test="/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
																	<xsl:choose>
																		<xsl:when test="translate(substring-before(/CreditNote/CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &gt;= translate('2011-01-04','-','')">
																			<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																		</xsl:when>
																		<xsl:when test="translate($docDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($docDate,'-','')  &gt;= translate('2010-01-01','-','')">
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
											<!--NumberOfLinesAtRate>
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
											</NumberOfLinesAtRate-->
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<!--NumberOfItemsAtRate>
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
	
	<xsl:template name="formatDate">
		<xsl:param name="value"/>
		<xsl:param name="format" select="'0000'"/>
		<xsl:param name="seperator" select="''"/>
		
		<xsl:choose>
		
			<xsl:when test="string-length($value) = 0"/>
			
			<xsl:otherwise>
			
				<xsl:value-of select="$seperator"/>
				<xsl:value-of select="format-number(substring-before(concat($value,'-'),'-'),$format)"/>
				
				<xsl:call-template name="formatDate">
					<xsl:with-param name="value" select="substring-after($value,'-')"/>
					<xsl:with-param name="format" select="'00'"/>
					<xsl:with-param name="seperator" select="'-'"/>
				</xsl:call-template>
				
			</xsl:otherwise>
			
		</xsl:choose>
	
		
	
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
