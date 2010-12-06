<?xml version="1.0" encoding="UTF-8"?>
<!--
'*************************************************************************************************
' © Alternative Business Solutions Ltd., 2005.
'*************************************************************************************************
' Module History
'*************************************************************************************************
' Date             | Name              | Description of modification
'*************************************************************************************************
' 22/07/2008  | Moty Dimant		| Created. Adapted from the BASDA invoice mapper 
'*************************************************************************************************
' 26/11/2008 | Rave Tech  | 2592 - Handled VAT rate change from 17.5% to 15%.
'*************************************************************************************************
' 15/12/2009 |S Sehgal  	| Case 3286 Changed to handle VAT changing back to 17.5% from 1-Jan-2010
'******************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	<!-- we use constants for default values -->
	<xsl:variable name="defaultTaxCategory" select="'S'"/>
	<xsl:variable name="NewTaxRate" select="'20.0'"/>
	<xsl:variable name="defaultTaxRate" select="'17.5'"/>
	<xsl:variable name="defaultTaxRateNew" select="'15'"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
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
	<xsl:template match="/biztalk_1/header"/>
	<xsl:template match="/biztalk_1/body">
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
									<xsl:value-of select="Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
								</SendersCodeForRecipient>
								<!-- SendersBranchReference not used for Inverarity yet (if ever) -->
								<!-- SBR used to pick out the PL Account code to be used in the trading relationship set up. This could be Buyer or Supplier value. -->
								<!--xsl:if test="string(/Invoice/TradeAgreementReference/ContractReferenceNumber) != '' ">
									<SendersBranchReference>
										<xsl:value-of select="/Invoice/TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if-->
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
								<!--Buyer>
									<BuyersLocationID>
										<xsl:if test="string(/Invoice/Buyer/BuyerGLN) != '' ">
											<GLN>
												<xsl:value-of select="/Invoice/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/Invoice/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(concat(/Invoice/Buyer/SellerAssigned,/Invoice/Buyer/BuyerGLN))">
											<SuppliersCode>
												<xsl:value-of select="/Invoice/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if-->
								<!--
										<xsl:for-each select="(/Invoice/Buyer/BuyerGLN | /Invoice/Buyer/SellerAssigned )[1]">
											<SuppliersCode>
												<xsl:value-of select="."/>
											</SuppliersCode>
										</xsl:for-each>
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
											<xsl:value-of select="/Invoice/Seller/Address/BuildingIdentifier"/>
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
								</Supplier-->
								<ShipTo>
									<ShipToLocationID>
										<!--xsl:if test="string(/Invoice/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="/Invoice/ShipTo/ShipToGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(/Invoice/ShipTo/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="/Invoice/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if-->
										<xsl:if test="string(Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery)">
											<SuppliersCode>
												<xsl:value-of select="Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
									<!-- ShipTo name and address will be populated by subsequent processors -->
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="Invoice/InvoiceReferences/SuppliersInvoiceNumber"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring(Invoice/InvoiceDate, 1,10)"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="substring(Invoice/InvoiceDate, 1,10)"/>
									</TaxPointDate>
									<xsl:if test="translate(Invoice/Supplier/SupplierReferences/TaxNumber, ' ', '')">
										<VATRegNo>
											<xsl:value-of select="translate(Invoice/Supplier/SupplierReferences/TaxNumber, ' ', '')"/>
										</VATRegNo>
									</xsl:if>
								</InvoiceReferences>
							</InvoiceHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      INVOICE DETAIL
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceDetail>
								<xsl:for-each select="Invoice/InvoiceLine">
									<InvoiceLine>
										<xsl:if test="/biztalk_1/body/Invoice/InvoiceReferences/BuyersOrderNumber != ''">
											<PurchaseOrderReferences>
												<xsl:if test="/biztalk_1/body/Invoice/InvoiceReferences/BuyersOrderNumber">
													<PurchaseOrderReference>
														<xsl:value-of select="/biztalk_1/body/Invoice/InvoiceReferences/BuyersOrderNumber"/>
													</PurchaseOrderReference>
												</xsl:if>
												<!-- no date provided so use invoice date-->
												<xsl:if test="/biztalk_1/body/Invoice/InvoiceReferences/BuyersOrderNumber">
													<PurchaseOrderDate>
														<xsl:value-of select="substring(/biztalk_1/body/Invoice/InvoiceDate,1,10)"/>
													</PurchaseOrderDate>
												</xsl:if>
											</PurchaseOrderReferences>
										</xsl:if>
										<xsl:if test="/biztalk_1/body/Invoice/InvoiceReferences/SuppliersOrderReference">
											<PurchaseOrderConfirmationReferences>
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="/biztalk_1/body/Invoice/InvoiceReferences/SuppliersOrderReference"/>
												</PurchaseOrderConfirmationReference>
												<PurchaseOrderConfirmationDate>
													<xsl:value-of select="substring(/biztalk_1/body/Invoice/InvoiceDate,1,10)"/>
												</PurchaseOrderConfirmationDate>
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										<xsl:if test="/biztalk_1/body/Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery">
											<DeliveryNoteReferences>
												<xsl:if test="/biztalk_1/body/Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery">
													<DeliveryNoteReference>
														<xsl:value-of select="/biztalk_1/body/Invoice/Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
													</DeliveryNoteReference>
												</xsl:if>
												<!--xsl:if test="/Invoice/DespatchReference/DespatchDocumentDate">
													<DeliveryNoteDate>
														<xsl:value-of select="substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T')"/>
													</DeliveryNoteDate>
													<DespatchDate>
														<xsl:value-of select="substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T')"/>
													</DespatchDate>
												</xsl:if-->
											</DeliveryNoteReferences>
										</xsl:if>
										<ProductID>
											<GTIN>
												<xsl:text>55555555555555</xsl:text>
											</GTIN>
											<xsl:if test="Product/SuppliersProductCode">
												<SuppliersProductCode>
													<xsl:value-of select="Product/SuppliersProductCode"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<!-- Product Description is populated by subsequent processors -->
										<ProductDescription>
											<xsl:value-of select="Product/Description"/>
										</ProductDescription>
										<InvoicedQuantity>
											<!--xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:attribute-->
											<xsl:value-of select="format-number(Quantity/Amount, '0.000')"/>
										</InvoicedQuantity>
										<!-- Pack Size is populated by subsequent processors -->
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(Price/UnitPrice, '0.00')"/>
										</UnitValueExclVAT>
										<LineValueExclVAT>
											<xsl:value-of select="format-number(LineTotal, '0.00')"/>
										</LineValueExclVAT>
										<!-- we default VATCode and Rate if not found in the EAN.UCC document -->
										<VATCode>
											<xsl:choose>
												<xsl:when test="LineTax/TaxRate/@Code = 'N'">
													<xsl:text>S</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="LineTax/TaxRate/@Code"/>
												</xsl:otherwise>
											</xsl:choose>
										</VATCode>
										<VATRate>
											<xsl:choose>
												<xsl:when test="LineTax/TaxRate">
													<xsl:value-of select="format-number(LineTax/TaxRate, '0.00')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="/biztalk_1/body/Invoice/TaxPointDateTime !=''">
															<xsl:choose>
																<xsl:when test="translate(substring(/biztalk_1/body/Invoice/TaxPointDateTime,1,10),'-','')  &gt; translate('2011-01-03','-','')">
																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:when test="translate(substring(/biztalk_1/body/Invoice/TaxPointDateTime,1,10),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring(/biztalk_1/body/Invoice/TaxPointDateTime,1,10),'-','')  &gt;= translate('2010-01-01','-','')">
																	<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number($defaultTaxRateNew, '0.00')"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="/biztalk_1/body/Invoice/InvoiceDate !=''">
															<xsl:choose>
																<xsl:when test="translate(substring(/biztalk_1/body/Invoice/InvoiceDate,1,10),'-','')  &gt; translate('2011-01-03','-','')">
																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:when test="translate(substring(/biztalk_1/body/Invoice/InvoiceDate,1,10),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring(/biztalk_1/body/Invoice/InvoiceDate,1,10),'-','')  &gt;= translate('2010-01-01','-','')">
																	<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number($defaultTaxRateNew, '0.00')"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">
																	<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">
																	<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="format-number($defaultTaxRateNew, '0.00')"/>
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
									<xsl:value-of select="count(//InvoiceLine)"/>
								</NumberOfLines>
								<NumberOfItems>
									<xsl:value-of select="sum(//InvoiceLine/Quantity/Amount)"/>
								</NumberOfItems>
								<!-- EAN.UCC only allows for one delivery per Invoice -->
								<NumberOfDeliveries>
									<xsl:text>1</xsl:text>
								</NumberOfDeliveries>
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="Invoice/InvoiceTotal/DocumentDiscountRate">
											<xsl:value-of select="format-number(Invoice/InvoiceTotal/DocumentDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="Invoice/InvoiceTotal/SettlementDiscountRate">
											<xsl:value-of select="format-number(Invoice/InvoiceTotal/SettlementDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscountRate>
								<!-- VATRateTotals are not mandatory in EAN.UCC but we have to assume at least some details will exist
					       to stand any chance at all of filling in any of our mandatory details -->
								<VATSubTotals>
									<xsl:for-each select="Invoice/TaxSubTotal">
										<VATSubTotal>
											<!-- store the VATRate and VATCode in variables as we use them more than once below -->
											<xsl:variable name="currentVATCode">
												<xsl:choose>
													<xsl:when test="TaxRate/@Code = 'N'">
														<xsl:text>S</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="TaxRate/@Code"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="currentVATRate">
												<xsl:if test="TaxRate">
													<xsl:value-of select="TaxRate"/>
												</xsl:if>
											</xsl:variable>
											<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>
											<!-- EAN.UCC does not count the lines at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfLinesAtRate>
												<xsl:value-of select="NumberOfLinesAtRate"/>
											</NumberOfLinesAtRate>
											<!-- EAN.UCC also doesn't sum the quantities at a specific rate so we have to work it out. Code and Rate must be the same -->
											<NumberOfItemsAtRate>
												<xsl:value-of select="sum(/biztalk_1/body/Invoice/InvoiceLine/Quantity/Amount)"/>
											</NumberOfItemsAtRate>
											<!-- EAN.UCC also doesn't sum the values at a specific rate so we have to work it out. Code and Rate must be the same -->
											<xsl:if test="TotalValueAtRate">
												<DocumentTotalExclVATAtRate>
													<xsl:value-of select="format-number(TotalValueAtRate,'0.00')"/>
												</DocumentTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="SettlementDiscountAtRate">
												<SettlementDiscountAtRate>
													<xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/>
												</SettlementDiscountAtRate>
											</xsl:if>
											<xsl:if test="TaxableValueAtRate">
												<SettlementTotalExclVATAtRate>
													<xsl:value-of select="format-number(TaxableValueAtRate, '0.00')"/>
												</SettlementTotalExclVATAtRate>
											</xsl:if>
											<xsl:if test="TaxAtRate">
												<VATAmountAtRate>
													<xsl:value-of select="format-number(TaxAtRate, '0.00')"/>
												</VATAmountAtRate>
											</xsl:if>
											<xsl:if test="NetPaymentAtRate">
												<DocumentTotalInclVATAtRate>
													<xsl:value-of select="format-number(NetPaymentAtRate,'0.00')"/>
												</DocumentTotalInclVATAtRate>
											</xsl:if>
											<xsl:if test="GrossPaymentAtRate">
												<SettlementTotalInclVATAtRate>
													<xsl:value-of select="format-number(GrossPaymentAtRate,'0.00')"/>
												</SettlementTotalInclVATAtRate>
											</xsl:if>
										</VATSubTotal>
									</xsl:for-each>
								</VATSubTotals>
								<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DiscountedLinesTotalExclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotal/LineValueTotal, '0.00')"/>
								</DiscountedLinesTotalExclVAT>
								<!-- DocumentDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<DocumentDiscount>
									<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
								</DocumentDiscount>
								<DocumentTotalExclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotal/LineValueTotal, '0.00')"/>
								</DocumentTotalExclVAT>
								<!-- SettlementDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
								<xsl:if test="/Invoice/InvoiceTotal/SettlementDiscountTotal">
									<SettlementDiscount>
										<xsl:value-of select="format-number(Invoice/InvoiceTotal/SettlementDiscountTotal, '0.00')"/>
									</SettlementDiscount>
								</xsl:if>
								<!-- we need a SettlementTotalExclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<xsl:if test="/Invoice/InvoiceTotal/TaxableTotal">
									<SettlementTotalExclVAT>
										<xsl:value-of select="format-number(Invoice/InvoiceTotal/TaxableTotal, '0.00')"/>
									</SettlementTotalExclVAT>
								</xsl:if>
								<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<xsl:if test="/Invoice/InvoiceTotal/TaxTotal">
									<VATAmount>
										<xsl:value-of select="format-number(Invoice/InvoiceTotal/TaxTotal, '0.00')"/>
									</VATAmount>
								</xsl:if>
								<DocumentTotalInclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotal/GrossPaymentTotal, '0.00')"/>
								</DocumentTotalInclVAT>
								<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
								<SettlementTotalInclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotal/GrossPaymentTotal, '0.00')"/>
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
