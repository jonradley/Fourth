<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2009
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 09/05/2011| K Oshaughnessy			|	Created module 
==========================================================================================
				|							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
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

								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="string(Invoice/ShipTo/SellerAssigned)">
											<xsl:value-of select="Invoice/ShipTo/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="Invoice/Buyer/BuyerGLN"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>

								<xsl:if test="string(Invoice/Seller/BuyerAssigned) != '' ">
									<SendersBranchReference>
										<xsl:value-of select="Invoice/Seller/BuyerAssigned"/>
									</SendersBranchReference>
								</xsl:if>
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
										<xsl:if test="string(Invoice/Buyer/BuyerGLN) != '' ">
											<GLN>
												<xsl:value-of select="Invoice/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(Invoice/Buyer/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="Invoice/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<!--xsl:if test="string(concat(/Invoice/Buyer/SellerAssigned,/Invoice/Buyer/BuyerGLN))">
											<SuppliersCode>
												<xsl:value-of select="/Invoice/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if-->
										<xsl:for-each select="(Invoice/Buyer/BuyerGLN | /Invoice/Buyer/SellerAssigned )[1]">
											<SuppliersCode>
												<xsl:value-of select="."/>
											</SuppliersCode>
										</xsl:for-each>
									</BuyersLocationID>
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="Invoice/Buyer/Address/BuildingIdentifier"/>
										</AddressLine1>
										<xsl:if test="string(Invoice/Buyer/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="Invoice/Buyer/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(Invoice/Buyer/Address/City)">
											<AddressLine3>
												<xsl:value-of select="Invoice/Buyer/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(Invoice/Buyer/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="Invoice/Buyer/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(Invoice/Seller/SellerGLN)">
											<GLN>
												<xsl:value-of select="Invoice/Seller/SellerGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(Invoice/Seller/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="Invoice/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(Invoice/Seller/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="Invoice/Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</SuppliersLocationID>
									<SuppliersAddress>
										<AddressLine1>
											<xsl:value-of select="Invoice/Seller/Address/BuildingIdentifier"/>
										</AddressLine1>
										<xsl:if test="string(Invoice/Seller/Address/StreetName)">
											<AddressLine2>
												<xsl:value-of select="Invoice/Seller/Address/StreetName"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="string(Invoice/Seller/Address/City)">
											<AddressLine3>
												<xsl:value-of select="Invoice/Seller/Address/City"/>
											</AddressLine3>
										</xsl:if>
										<AddressLine4>
											<xsl:text>GB</xsl:text>
										</AddressLine4>
										<xsl:if test="string(Invoice/Seller/Address/PostCode)">
											<PostCode>
												<xsl:value-of select="Invoice/Seller/Address/PostCode"/>
											</PostCode>
										</xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<xsl:if test="string(Invoice/ShipTo/ShipToGLN)">
											<GLN>
												<xsl:value-of select="Invoice/ShipTo/ShipToGLN"/>
											</GLN>
										</xsl:if>
										<xsl:if test="string(Invoice/ShipTo/BuyerAssigned)">
											<BuyersCode>
												<xsl:value-of select="Invoice/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										<xsl:if test="string(Invoice/ShipTo/SellerAssigned)">
											<SuppliersCode>
												<xsl:value-of select="Invoice/ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="Invoice/InvoiceDocumentDetails/InvoiceDocumentNumber"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(Invoice/InvoiceDocumentDetails/InvoiceDocumentDate, 'T')"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(Invoice/TaxPointDateTime, 'T')"/>
									</TaxPointDate>
									<xsl:if test="string(Invoice/Seller/VATRegisterationNumber)">
										<VATRegNo>
											<xsl:value-of select="Invoice/Seller/VATRegisterationNumber"/>
										</VATRegNo>
									</xsl:if>
								</InvoiceReferences>
							</InvoiceHeader>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      INVOICE DETAIL
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceDetail>
							
								<xsl:for-each select="Invoice/InvoiceItem">
								
									<xsl:sort select="LineItemNumber" data-type="number"/>
									<InvoiceLine>
										<xsl:if test="LineItemNumber!=0">
											<LineNumber>
												<!-- Brakes sometimes sends lines with duplicate line numbers. This causes a problem if the document suspends and needs to be edited, so we generate our own unique line number. -->
												<xsl:value-of select="position()"/>
											</LineNumber>
										</xsl:if>
										
										<xsl:if test="/Invoice/OrderReference or /Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
											<PurchaseOrderReferences>
											
												<xsl:if test="/Invoice/OrderReference/PurchaseOrderNumber">
													<PurchaseOrderReference>
														<xsl:value-of select="/Invoice/OrderReference/PurchaseOrderNumber"/>
													</PurchaseOrderReference>
												</xsl:if>
												
												<xsl:variable name="purchaseOrderDate">
													<xsl:for-each select="(/Invoice/OrderReference/PurchaseOrderDate | /Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate)[1]">
														<xsl:value-of select="string(.)"/>
													</xsl:for-each>
												</xsl:variable>
												
												<xsl:if test="$purchaseOrderDate != ''">
													<PurchaseOrderDate>
														<xsl:value-of select="substring-before($purchaseOrderDate,'T')"/>
													</PurchaseOrderDate>
													<PurchaseOrderTime>
														<xsl:value-of select="substring-after($purchaseOrderDate,'T')"/>
													</PurchaseOrderTime>
												</xsl:if>
												
												<xsl:if test="/Invoice/TradeAgreementReference/ContractReferenceNumber != ''">
													<TradeAgreement>
														<ContractReference>
															<xsl:value-of select="/Invoice/TradeAgreementReference/ContractReferenceNumber"/>
														</ContractReference>
														<xsl:if test="/Invoice/TradeAgreementReference/ContractReferenceDate">
															<ContractDate>
																<xsl:value-of select="substring-before(/Invoice/TradeAgreementReference/ContractReferenceDate, 'T')"/>
															</ContractDate>
														</xsl:if>
													</TradeAgreement>
												</xsl:if>
												
											</PurchaseOrderReferences>
										</xsl:if>
										
										<xsl:if test="/Invoice/OrderConfirmationReference">
											<PurchaseOrderConfirmationReferences>
											
												<PurchaseOrderConfirmationReference>
													<xsl:value-of select="/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationNumber"/>
												</PurchaseOrderConfirmationReference>
												
												<xsl:if test="/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate">
													<PurchaseOrderConfirmationDate>
														<xsl:value-of select="substring-before(/Invoice/OrderConfirmationReference/PurchaseOrderConfirmationDate, 'T')"/>
													</PurchaseOrderConfirmationDate>
												</xsl:if>
												
											</PurchaseOrderConfirmationReferences>
										</xsl:if>
										
										<xsl:if test="/Invoice/DespatchReference">
											<DeliveryNoteReferences>
											
												<xsl:if test="/Invoice/DespatchReference/DespatchDocumentNumber">
													<DeliveryNoteReference>
														<xsl:value-of select="/Invoice/DespatchReference/DespatchDocumentNumber"/>
													</DeliveryNoteReference>
												</xsl:if>
												
												<xsl:if test="/Invoice/DespatchReference/DespatchDocumentDate">
													<DeliveryNoteDate>
														<xsl:value-of select="substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T')"/>
													</DeliveryNoteDate>
													
													<DespatchDate>
														<xsl:value-of select="substring-before(/Invoice/DespatchReference/DespatchDocumentDate, 'T')"/>
													</DespatchDate>
													
												</xsl:if>
												
											</DeliveryNoteReferences>
										</xsl:if>
										
										<xsl:if test="/Invoice/ReceiptAdviceReference[translate(ReceiptAdviceDocumentNumber,' ','')!='' and string(/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate)!='']">
											<GoodsReceivedNoteReferences>
											
												<GoodsReceivedNoteReference>
													<xsl:value-of select="/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentNumber"/>
												</GoodsReceivedNoteReference>
												
												<xsl:if test="/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate">
													<GoodsReceivedNoteDate>
														<xsl:value-of select="substring-before(/Invoice/ReceiptAdviceReference/ReceiptAdviceDocumentDate, 'T')"/>
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
										
										<xsl:if test="OrderedQuantity">
											<OrderedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderedQuantity/@unitCode"/></xsl:attribute>
												<xsl:value-of select="format-number(OrderedQuantity, '0.000')"/>
											</OrderedQuantity>
										</xsl:if>
										
										<InvoicedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:attribute>
											<xsl:value-of select="format-number(InvoiceQuantity, '0.000')"/>
										</InvoicedQuantity>
										
										<xsl:if test="CreditQuantity">
											<CreditedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="CreditQuantity/@unitCode"/></xsl:attribute>
												<xsl:value-of select="format-number(CreditQuantity, '0.000')"/>
											</CreditedQuantity>
										</xsl:if>
										
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
										
										<!-- we default VATCode and Rate if not found in the EAN.UCC document -->
										
										<VATCode>
											<xsl:choose>
												<xsl:when test="VATDetails/TaxCategory  = 'C' ">Z</xsl:when>
												<xsl:otherwise>S</xsl:otherwise>
											</xsl:choose>
										</VATCode>
										
										<VATRate>
											<xsl:value-of select="VATDetails/TaxRate"/>
										</VATRate>
										
									</InvoiceLine>
								</xsl:for-each>
							</InvoiceDetail>
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      INVOICE TRAILER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<InvoiceTrailer>
							
								<NumberOfLines>
									<xsl:value-of select="count(Invoice/InvoiceItem/LineItemNumber)"/>
								</NumberOfLines>
								
								<NumberOfItems>
									<xsl:value-of select="sum(Invoice/InvoiceItem/InvoiceQuantity)"/>
								</NumberOfItems>
								
								<NumberOfDeliveries>
									<xsl:text>1</xsl:text>
								</NumberOfDeliveries>
								
								<VATSubTotals>

										<VATSubTotal>
										
											<xsl:attribute name="VATCode">
												<xsl:choose>
													<xsl:when test="Invoice/InvoiceItem/VATDetails/TaxCategory= 'C' ">Z</xsl:when>
													<xsl:otherwise>S</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											
											<xsl:attribute name="VATRate">
												<xsl:value-of select="format-number(Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxRate, '0.00')"/>
											</xsl:attribute>
											
											<NumberOfLinesAtRate>
													<xsl:choose>
														<xsl:when test="/Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxCategory = 'C' ">
															<xsl:value-of select="count(/Invoice/InvoiceItem/LineItemNumber)"/>
														</xsl:when>
														<xsl:when test="/Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxCategory != 'C' ">
															<xsl:value-of select="count(/Invoice/InvoiceItem/LineItemNumber)"/>
														</xsl:when>
														<xsl:otherwise>error</xsl:otherwise>
													</xsl:choose>
										
											</NumberOfLinesAtRate>
											
											<NumberOfItemsAtRate>
										
												<xsl:choose>
													<xsl:when test="/Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxCategory = 'C' ">
														<xsl:value-of select="sum(/Invoice[InvoiceTotals/VATRateTotals/VATDetails/TaxCategory = 'C']/InvoiceItem/InvoiceQuantity)"/>
													</xsl:when>
													<xsl:when test="/Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxCategory != 'C' ">
														<xsl:value-of select="sum(/Invoice[InvoiceTotals/VATRateTotals/VATDetails/TaxCategory != 'C']/InvoiceItem/InvoiceQuantity)"/>
													</xsl:when>
													<xsl:otherwise>error</xsl:otherwise>
												</xsl:choose>
												
											</NumberOfItemsAtRate>
											
											<DocumentTotalExclVATAtRate>
												<xsl:value-of select="Invoice/InvoiceTotals/InvoiceSubTotal"/>
											</DocumentTotalExclVATAtRate>
											
											<VATAmountAtRate>
												<xsl:value-of select="Invoice/InvoiceTotals/VATTotal"/>
											</VATAmountAtRate>
											
											<DocumentTotalInclVATAtRate>
												<xsl:value-of select="Invoice/InvoiceTotals/TotalPayable"/>
											</DocumentTotalInclVATAtRate>

										</VATSubTotal>

								</VATSubTotals>
								
								<DiscountedLinesTotalExclVAT>
										<xsl:value-of select="sum(Invoice/InvoiceItem/LineItemPrice)"/>
								</DiscountedLinesTotalExclVAT>
								
								<DocumentDiscount>
									<xsl:value-of select="Invoice/InvoiceTotals/VATRateTotals/DocumentDiscountValue"/>
								</DocumentDiscount>
								
								<DocumentTotalExclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotals/InvoiceSubTotal, '0.00')"/>
								</DocumentTotalExclVAT>
								
								<SettlementDiscount>
									<xsl:value-of select="Invoice/InvoiceTotals/VATRateTotals/SettlementDiscountValue"/>
								</SettlementDiscount>
								
								<SettlementTotalExclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotals/InvoiceSubTotal, '0.00')"/>
								</SettlementTotalExclVAT>
								
								<VATAmount>
									<xsl:choose>
										<xsl:when test="Invoice/InvoiceTotals/VATAmount">
											<xsl:value-of select="format-number(Invoice/InvoiceTotals/VATAmount, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sum(//VATRateTotals/VATPayable), '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								
								<DocumentTotalInclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotals/TotalPayable, '0.00')"/>
								</DocumentTotalInclVAT>
								
								<SettlementTotalInclVAT>
									<xsl:value-of select="format-number(Invoice/InvoiceTotals/TotalPayable, '0.00')"/>
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
