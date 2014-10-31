<?xml version="1.0" encoding="UTF-8"?>
<!--
'*************************************************************************************************************************************
' Overview
'
' Maps Nigel Fredericks inbound CreditNotes 
'
'*************************************************************************************************************************************
' Module History
'*************************************************************************************************************************************
' Date             | Name              | Description of modification
'*************************************************************************************************************************************
' 10/05/2011  | M Dimant | Created Changes to accomodate inclusion of UOM by Comtrex
'*************************************************************************************************************************************
' 11/06/2012  | M Dimant | 5532: Changes to include correct UOM
'************************************************************************************************************************************
' 14/05/2013  | M Dimant | 6540: Changed mapping of SCR so we can handle Comtrex and FnB customers.
'*************************************************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	<!-- we use constants for default values -->
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
	<xsl:variable name="creditLineIndicator" select="'2'"/>
	<xsl:variable name="CreditNoteLineIndicator" select="'1'"/>
	<xsl:variable name="defaultNewTaxRate" select="'15'"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="CreditNotes/CreditNote">
					<BatchDocument>						
						<CreditNote>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      TRADESIMPLE HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<TradeSimpleHeader>
								<!-- SCR comes from Sellers code for buyer if there, else it comes from Buyer GLN -->
								<SendersCodeForRecipient>
									<xsl:choose>
										<!-- We do not hold shipto details for Comtrex cutomers so we use a different SCR if the credit is for Cote, Prezzo or Bills -->
										<xsl:when test="Buyer/BuyerAssigned = 'COTE' or Buyer/BuyerAssigned = 'PREZZO' or Buyer/BuyerAssigned = 'BILLS'">
											<xsl:value-of select="Seller/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="ShipTo/BuyerAssigned"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>
								<!-- SBR used to pick out the PL Account code to be used in the trading relationship set up. This could be Buyer or Supplier value. -->
								<xsl:if test="string(TradeAgreementReference/ContractReferenceNumber) != '' ">
									<SendersBranchReference>
										<xsl:value-of select="TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if>
								<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors  -->
								<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode will be populated by subsequent 	processors -->
								<!-- the TestFlag will be populated by subsequent processors -->
							</TradeSimpleHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CreditNote HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteHeader>
								<!-- the document status is always Original -->
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								<Buyer>
									<BuyersLocationID>
										<xsl:if test="string(Buyer/BuyerGLN) != '' ">
											<GLN>
												<xsl:value-of select="Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="normalize-space(Buyer/BuyerAssigned)"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(Buyer/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="Buyer/Address/BuildingIdentifier"/>
										</AddressLine1>
										<xsl:if test="string(Buyer/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="Buyer/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(Buyer/Address/City)">
											<AddressLine3>
												<xsl:value-of select="Buyer/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(Buyer/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="Buyer/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="Seller/SellerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									<SuppliersAddress>
										<AddressLine1>
											<xsl:value-of select="normalize-space(Seller/Address/BuildingIdentifier)"/>
										</AddressLine1>
										<xsl:if test="string(Seller/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="Seller/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(Seller/Address/City)">
											<AddressLine3>
												<xsl:value-of select="Seller/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(Seller/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="Seller/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="ShipTo/ShipToGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(ShipTo/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(ShipTo/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
									<!-- ShipTo name and address will be populated by subsequent processors -->
								</ShipTo>
								<CreditNoteReferences>
									<CreditNoteReference>
										<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentNumber"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
									</CreditNoteDate>
									<TaxPointDate>
										<xsl:value-of select="TaxPointDateTime"/>
									</TaxPointDate>
									<xsl:if test="string(Seller/VATRegisterationNumber)">
										<VATRegNo>
											<xsl:value-of select="Seller/VATRegisterationNumber"/>
										</VATRegNo>
									</xsl:if>
								</CreditNoteReferences>
							</CreditNoteHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CreditNote DETAIL
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteDetail>
								<xsl:for-each select="CreditItem">
									<xsl:sort select="LineItemNumber"/>
									<CreditNoteLine>
										<LineNumber>
											<xsl:value-of select="LineItemNumber"/>
										</LineNumber>
										<xsl:if test="(../OrderReference and normalize-space(../OrderReference/PurchaseOrderNumber) != '') or ../TradeAgreementReference/ContractReferenceNumber != ''">
											<PurchaseOrderReferences>
												<xsl:if test="../OrderReference/PurchaseOrderNumber and normalize-space(../OrderReference/PurchaseOrderNumber) != ''">
													<PurchaseOrderReference>
														<xsl:value-of select="normalize-space(../OrderReference/PurchaseOrderNumber)"/>
													</PurchaseOrderReference>
												</xsl:if>
												<xsl:if test="../OrderReference/PurchaseOrderNumber and ../OrderReference/PurchaseOrderNumber != ''">
													<PurchaseOrderDate>
														<xsl:value-of select="../OrderReference/PurchaseOrderDate"/>
													</PurchaseOrderDate>													
												</xsl:if>
												<xsl:if test="../TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="../TradeAgreementReference/ContractReferenceNumber"/>
														</ContractReference>
														<xsl:if test="../TradeAgreementReference/ContractReferenceDate">
															<ContractDate>
																<xsl:value-of select="substring-before(../TradeAgreementReference/ContractReferenceDate, 'T')"/>
															</ContractDate>
														</xsl:if>
													</TradeAgreement>
												</xsl:if>
											</PurchaseOrderReferences>
										</xsl:if>
										<xsl:if test="InvoiceReferences">
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="InvoiceReference/InvoiceDocumentNumber"/>
												</InvoiceReference>
												<xsl:if test="InvoiceReference/InvoiceDocumentDate">
													<InvoiceDocumentDate>
														<xsl:value-of select="substring-before(InvoiceReference/InvoiceDocumentDate, 'T')"/>
													</InvoiceDocumentDate>
												</xsl:if>
											</InvoiceReferences>
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
													<xsl:value-of select="normalize-space(ItemIdentifier/AlternateCode)"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<ProductDescription>
											<xsl:value-of select="LineItemDescription"/>
										</ProductDescription>
										<InvoicedQuantity>
											<xsl:attribute name="UnitOfMeasure">											
												<xsl:choose>
													<xsl:when test="InvoiceQuantity/@unitCode = 'KG'">KGM</xsl:when>
													<xsl:when test="InvoiceQuantity/@unitCode = 'NO'">EA</xsl:when>
													<xsl:when test="InvoiceQuantity/@unitCode = 'DZ'">DZN</xsl:when>
													<xsl:when test="InvoiceQuantity/@unitCode = 'PK'">CS</xsl:when>
													<xsl:when test="InvoiceQuantity/@unitCode = 'BX'">CS</xsl:when>																									<xsl:otherwise><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:otherwise>	
												</xsl:choose>		
											</xsl:attribute>
											<xsl:value-of select="format-number(InvoiceQuantity, '0.000')"/>
										</InvoicedQuantity>
										<xsl:if test="CreditQuantity">
											<CreditedQuantity>
												<xsl:attribute name="UnitOfMeasure">											
													<xsl:choose>
														<xsl:when test="InvoiceQuantity/@unitCode = 'KG'">KGM</xsl:when>
														<xsl:when test="InvoiceQuantity/@unitCode = 'NO'">EA</xsl:when>
														<xsl:when test="InvoiceQuantity/@unitCode = 'DZ'">DZN</xsl:when>
														<xsl:when test="InvoiceQuantity/@unitCode = 'PK'">CS</xsl:when>
														<xsl:when test="InvoiceQuantity/@unitCode = 'BX'">CS</xsl:when>																										<xsl:otherwise><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:otherwise>	
													</xsl:choose>		
												</xsl:attribute>
												<xsl:value-of select="format-number(CreditQuantity, '0.000')"/>
											</CreditedQuantity>
										</xsl:if>
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
													<xsl:when test="VATDetails/TaxCategory=1">S</xsl:when>
													<xsl:when test="VATDetails/TaxCategory=2">Z</xsl:when>
													<xsl:when test="VATDetails/TaxCategory=3">E</xsl:when>
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
														<xsl:when test="TaxPointDateTime !=''">
															<xsl:choose>
																	<xsl:when test="translate(substring-before(TaxPointDateTime, 'T'),'-','') &gt;= translate('2011-01-04','-','')">
																		 <xsl:value-of select="format-number($NewTaxRate, '0.00')"/> 								
																	</xsl:when>
																	<xsl:when test="translate(substring-before(TaxPointDateTime, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(TaxPointDateTime, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																		 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																	</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
															<xsl:choose>
																	<xsl:when test="translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','') &gt;= translate('2011-01-04','-','')">
																		<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																	</xsl:when>
																	<xsl:when test="translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
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
									</CreditNoteLine>
								</xsl:for-each>
							</CreditNoteDetail>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      CreditNote TRAILER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(CreditItem)"/>
								</NumberOfLines>
								<NumberOfItems>
									<xsl:value-of select="sum(CreditItem/CreditQuantity)"/>
								</NumberOfItems>								
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="CreditTotals/DocumentDiscountRate">
											<xsl:value-of select="format-number(CreditTotals/DocumentDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="CreditTotals/SettlementDiscountRate">
											<xsl:value-of select="format-number(CreditTotals/SettlementDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscountRate>
								<!-- VATRateTotals are not mandatory in EAN.UCC but we have to assume at least some details will exist
					       to stand any chance at all of filling in any of our mandatory details -->
								<VATSubTotals>
									<xsl:for-each select="CreditTotals/VATRateTotals">
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
														<xsl:choose>
															<xsl:when test="TaxPointDateTime !=''">
																<xsl:choose>
																		<xsl:when test="translate(substring-before(TaxPointDateTime, 'T'),'-','') &gt;= translate('2011-01-04','-','')">
																			 <xsl:value-of select="format-number($NewTaxRate, '0.00')"/> 								
																		</xsl:when>
																		<xsl:when test="translate(substring-before(TaxPointDateTime, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(TaxPointDateTime, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
																			 <xsl:value-of select="format-number($defaultTaxRate, '0.00')"/> 								
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
																		</xsl:otherwise>
																</xsl:choose>
															</xsl:when>
															<xsl:when test="CreditNoteDocumentDetails/CreditNoteDocumentDate !=''">
																<xsl:choose>
																	<xsl:when test="translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','') &gt;= translate('2011-01-04','-','')">
																		<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																	</xsl:when>
																	<xsl:when test="translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
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
											<xsl:attribute name="VATCode">
												<!--translate the VAT code into tradesimple format-->
												<xsl:choose>													
													<xsl:when test="VATDetails/TaxCategory=1">S</xsl:when>
													<xsl:when test="VATDetails/TaxCategory=2">Z</xsl:when>
													<xsl:when test="VATDetails/TaxCategory=3">E</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$defaultTaxCategory"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfLinesAtRate>
												<xsl:choose>
													<xsl:when test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="count(../../CreditItem[VATDetails/TaxCategory = $currentVATCode and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="VATDetails/TaxCategory and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(../../CreditItem[VATDetails/TaxCategory = $currentVATCode and not(VATDetails/TaxRate)])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and VATDetails/TaxRate">
														<xsl:value-of select="count(../../CreditItem[not(VATDetails/TaxCategory) and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')])"/>
													</xsl:when>
													<xsl:when test="not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)">
														<xsl:value-of select="count(../../CreditItem[not(VATDetails/TaxCategory) and not(VATDetails/TaxRate)])"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfLinesAtRate>
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfItemsAtRate>	
													<xsl:if test="VATDetails/TaxCategory and VATDetails/TaxRate">
														<xsl:value-of select="format-number(sum(../../CreditItem[VATDetails/TaxCategory=$currentVATCode  and format-number(VATDetails/TaxRate, '0.00') = format-number($currentVATRate, '0.00')]/CreditQuantity), '0.000')"/>
													</xsl:if>
											</NumberOfItemsAtRate>											
											<xsl:if test="DocumentDiscountValue">
												<DocumentDiscountAtRate>
													<xsl:value-of select="format-number(DocumentDiscountValue, '0.00')"/>
												</DocumentDiscountAtRate>
											</xsl:if>											
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
										<xsl:when test="CreditTotals/SettlementSubTotal">
											<xsl:value-of select="format-number(CreditTotals/SettlementSubTotal, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/TaxableAmount), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementTotalExclVAT>
								<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<VATAmount>
									<xsl:choose>
										<xsl:when test="CreditTotals/VATAmount">
											<xsl:value-of select="format-number(CreditTotals/VATAmount, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/VATPayable), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT>
									<xsl:value-of select="format-number(CreditTotals/TotalPayable, '0.00')"/>
								</DocumentTotalInclVAT>								
							</CreditNoteTrailer>
						</CreditNote>						
					</BatchDocument>
					</xsl:for-each>
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
