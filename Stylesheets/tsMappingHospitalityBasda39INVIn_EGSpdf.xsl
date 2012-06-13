<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2012-04-26		| 5435 Created Module 
**********************************************************************
				|						|	
**********************************************************************
				|						|	
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	<!-- we use constants for default values -->
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	
	<xsl:template match="/Batch">
	
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
					
						<xsl:for-each select="Invoice">
					
							<Invoice>
	
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
									</SendersCodeForRecipient>
									<xsl:for-each select="InvoiceTo/InvoiceToReferences/SuppliersCodeForInvoiceTo[1]">
										<SendersBranchReference>
											<xsl:value-of select="."/>
										</SendersBranchReference>
									</xsl:for-each>
								</TradeSimpleHeader>
	
								<InvoiceHeader>
									<!-- the document status is always Original -->
									<DocumentStatus>
										<xsl:text>Original</xsl:text>
									</DocumentStatus>
									
									<ShipTo>
										<ShipToLocationID>
	
											<xsl:for-each select="Buyer/BuyerReferences/SuppliersCodeForBuyer[1]">
												<SuppliersCode>
													<xsl:value-of select="."/>
												</SuppliersCode>
											</xsl:for-each>
										</ShipToLocationID>
	
									</ShipTo>
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
										</InvoiceReference>
										<InvoiceDate>
											<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
										</TaxPointDate>
										<xsl:for-each select="Supplier/SupplierReferences/TaxNumber[1]">
											<VATRegNo>
												<xsl:value-of select="translate(., ' ', '')"/>
											</VATRegNo>
										</xsl:for-each>
									</InvoiceReferences>
								</InvoiceHeader>
								
								<InvoiceDetail>
									<xsl:for-each select="InvoiceLine">
										<InvoiceLine>
											<xsl:for-each select="../InvoiceReferences/BuyersOrderNumber[. != ''][1]">
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of select="."/>
													</PurchaseOrderReference>
													<!-- no date provided so use invoice date-->
													<PurchaseOrderDate>
														<xsl:value-of select="substring-before(../../InvoiceDate,'T')"/>
													</PurchaseOrderDate>
												</PurchaseOrderReferences>
											</xsl:for-each>
											<xsl:for-each select="../../InvoiceReferences/SuppliersOrderReference[. != ''][1]">
												<PurchaseOrderConfirmationReferences>
													<PurchaseOrderConfirmationReference>
														<xsl:value-of select="."/>
													</PurchaseOrderConfirmationReference>
													<PurchaseOrderConfirmationDate>
														<xsl:value-of select="substring-before(../../InvoiceDate,'T')"/>
													</PurchaseOrderConfirmationDate>
												</PurchaseOrderConfirmationReferences>
											</xsl:for-each>
											<xsl:for-each select="InvoiceLineReferences/DeliveryNoteNumber[. != ''][1]">
												<DeliveryNoteReferences>
													<DeliveryNoteReference>
														<xsl:value-of select="."/>
													</DeliveryNoteReference>
													<DeliveryNoteDate>
														<xsl:value-of select="substring-before(../../InvoiceDate,'T')"/>
													</DeliveryNoteDate>
												</DeliveryNoteReferences>
											</xsl:for-each>
											
											<ProductID>
												<GTIN>
													<xsl:text>55555555555555</xsl:text>
												</GTIN>
												<!--xsl:for-each select="Product/SuppliersProductCode[. != ''][1]">
													<SuppliersProductCode>
														<xsl:value-of select="."/>
													</SuppliersProductCode>
												</xsl:for-each-->
												<SuppliersProductCode>
													<xsl:choose>
														<xsl:when test="Product/SuppliersProductCode != ''">
															<xsl:value-of select="Product/SuppliersProductCode"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>CHARGE</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</SuppliersProductCode>
											</ProductID>
											
											<ProductDescription>
												<xsl:value-of select="Product/Description"/>
											</ProductDescription>
											<InvoicedQuantity>
												<!--xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoiceQuantity/@unitCode"/></xsl:attribute-->
												<xsl:value-of select="format-number(Quantity/Amount, '0.000')"/>
											</InvoicedQuantity>
											<UnitValueExclVAT>
												<xsl:value-of select="format-number(Price/UnitPrice, '0.00')"/>
											</UnitValueExclVAT>
											
											<!-- Standard BASDA mappings -->
											<!--LineValueExclVAT>
												<xsl:value-of select="format-number(LineTotal, '0.00')"/>
											</LineValueExclVAT-->
											
											<!-- Proof of concept, temp adjustments -->
											<LineValueExclVAT>
												<xsl:value-of select="format-number(Quantity/Amount * Price/UnitPrice, '0.00')"/>
											</LineValueExclVAT>

											<VATCode>
												<xsl:value-of select="LineTax/TaxRate/@Code"/>
											</VATCode>
											<VATRate>
												<xsl:value-of select="format-number(LineTax/TaxRate, '0.00')"/>
											</VATRate>
										</InvoiceLine>
									</xsl:for-each>
								</InvoiceDetail>
	
								<InvoiceTrailer>
									<NumberOfLines>
										<xsl:value-of select="count(//InvoiceLine)"/>
									</NumberOfLines>
									<NumberOfItems>
										<xsl:value-of select="sum(//InvoiceLine/Quantity/Amount)"/>
									</NumberOfItems>
									<!--NumberOfDeliveries>
										<xsl:text>1</xsl:text>
									</NumberOfDeliveries-->
									<DocumentDiscountRate>
										<xsl:choose>
											<xsl:when test="InvoiceTotals/DocumentDiscountRate">
												<xsl:value-of select="format-number(InvoiceTotals/DocumentDiscountRate, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</DocumentDiscountRate>
									<SettlementDiscountRate>
										<xsl:choose>
											<xsl:when test="InvoiceTotals/SettlementDiscountRate">
												<xsl:value-of select="format-number(InvoiceTotals/SettlementDiscountRate, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</SettlementDiscountRate>
	
									<VATSubTotals>
										<xsl:for-each select="TaxSubTotal">
											<VATSubTotal>
												<!-- store the VATRate and VATCode in variables as we use them more than once below -->
												<xsl:variable name="currentVATCode">
													<xsl:value-of select="TaxRate/@Code"/>
												</xsl:variable>
												<xsl:variable name="currentVATRate">
													<xsl:if test="TaxRate">
														<xsl:value-of select="TaxRate"/>
													</xsl:if>
												</xsl:variable>
												<xsl:attribute name="VATCode"><xsl:value-of select="$currentVATCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="format-number($currentVATRate,'0.00')"/></xsl:attribute>
												
												<!-- Standard BASDA mappings -->
												<!--NumberOfLinesAtRate>
													<xsl:value-of select="NumberOfLinesAtRate"/>
												</NumberOfLinesAtRate>
												<xsl:for-each select="TotalValueAtRate[1]">
													<DocumentTotalExclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</DocumentTotalExclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="SettlementDiscountAtRate[1]">
													<SettlementDiscountAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</SettlementDiscountAtRate>
												</xsl:for-each>
												<xsl:for-each select="TaxableValueAtRate[1]">
													<SettlementTotalExclVATAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</SettlementTotalExclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="TaxAtRate[1]">
													<VATAmountAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</VATAmountAtRate>
												</xsl:for-each>
												<xsl:for-each select="NetPaymentAtRate[1]">
													<DocumentTotalInclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</DocumentTotalInclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="GrossPaymentAtRate[1]">
													<SettlementTotalInclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</SettlementTotalInclVATAtRate>
												</xsl:for-each-->
												
												<!-- Proof of concept, temp adjustments -->
												<NumberOfLinesAtRate>
													<xsl:value-of select="NumberOfLinesAtRate"/>
												</NumberOfLinesAtRate>
												<xsl:for-each select="SettlementDiscountAtRate[1]">
													<DocumentTotalExclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</DocumentTotalExclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="SettlementDiscountAtRate[1]">
													<SettlementDiscountAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</SettlementDiscountAtRate>
												</xsl:for-each>
												<xsl:for-each select="TaxableValueAtRate[1]">
													<SettlementTotalExclVATAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</SettlementTotalExclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="TaxAtRate[1]">
													<VATAmountAtRate>
														<xsl:value-of select="format-number(., '0.00')"/>
													</VATAmountAtRate>
												</xsl:for-each>
												<xsl:for-each select="GrossPaymentAtRate[1]">
													<DocumentTotalInclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</DocumentTotalInclVATAtRate>
												</xsl:for-each>
												<xsl:for-each select="GrossPaymentAtRate[1]">
													<SettlementTotalInclVATAtRate>
														<xsl:value-of select="format-number(.,'0.00')"/>
													</SettlementTotalInclVATAtRate>
												</xsl:for-each>

												
												
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									
									<!-- Standard BASDA mappings -->
									<!--DiscountedLinesTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/LineValueTotal, '0.00')"/>
									</DiscountedLinesTotalExclVAT>
									<DocumentDiscount>
										<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
									</DocumentDiscount>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/LineValueTotal, '0.00')"/>
									</DocumentTotalExclVAT>
									<xsl:for-each select="InvoiceTotal/SettlementDiscountTotal[1]">
										<SettlementDiscount>
											<xsl:value-of select="format-number(., '0.00')"/>
										</SettlementDiscount>
									</xsl:for-each>
									<xsl:for-each select="InvoiceTotal/TaxableTotal[1]">
										<SettlementTotalExclVAT>
											<xsl:value-of select="format-number(., '0.00')"/>
										</SettlementTotalExclVAT>
									</xsl:for-each>
									<xsl:for-each select="InvoiceTotal/TaxTotal[1]">
										<VATAmount>
											<xsl:value-of select="format-number(., '0.00')"/>
										</VATAmount>
									</xsl:for-each>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/GrossPaymentTotal, '0.00')"/>
									</DocumentTotalInclVAT>
									<SettlementTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/NetPaymentTotal, '0.00')"/>
									</SettlementTotalInclVAT-->
									
									<!-- Proof of concept, temp adjustments -->
									<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
									<DiscountedLinesTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/TaxableTotal, '0.00')"/>
									</DiscountedLinesTotalExclVAT>
									<!-- DocumentDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
									<DocumentDiscount>
										<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
									</DocumentDiscount>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/TaxableTotal, '0.00')"/>
									</DocumentTotalExclVAT>
									<!-- SettlementDiscount is mandatory in our schema but not EAN.UCC. If we find none then just default the value -->
									<xsl:for-each select="InvoiceTotal/SettlementDiscountTotal[1]">
										<SettlementDiscount>
											<xsl:value-of select="format-number(., '0.00')"/>
										</SettlementDiscount>
									</xsl:for-each>
									<!-- we need a SettlementTotalExclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
									<xsl:for-each select="InvoiceTotal/TaxableTotal[1]">
										<SettlementTotalExclVAT>
											<xsl:value-of select="format-number(., '0.00')"/>
										</SettlementTotalExclVAT>
									</xsl:for-each>
									<!-- we need a VATAmount internally but it is optional in EAN.UCC so we work it out if it is missing -->
									<xsl:for-each select="InvoiceTotal/TaxTotal[1]">
										<VATAmount>
											<xsl:value-of select="format-number(., '0.00')"/>
										</VATAmount>
									</xsl:for-each>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/GrossPaymentTotal, '0.00')"/>
									</DocumentTotalInclVAT>
									<!-- we need a SettlementTotalInclVAT internally but it is optional in EAN.UCC so we work it out if it is missing -->
									<SettlementTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotal/GrossPaymentTotal, '0.00')"/>
									</SettlementTotalInclVAT>

									
									
								</InvoiceTrailer>
							</Invoice>
							
						</xsl:for-each>
							
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
		
	</xsl:template>
	
</xsl:stylesheet>
