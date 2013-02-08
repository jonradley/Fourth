<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
06/09/2012|KOshaughnessy	| 	Created FB 5948
************************************************************************
			|						| 	
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0"/>
	<xsl:template match="Buyer"/>
	<xsl:template match="Seller"/>
	<xsl:template match="/Invoices">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="Invoice">
						<BatchDocument>
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="BuyingUnit/AccountCode"/>
									</SendersCodeForRecipient>
									<SendersBranchReference>
										<xsl:value-of select="../Buyer/PricingAccount"/>
									</SendersBranchReference>
								</TradeSimpleHeader>
								<InvoiceHeader>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode>
												<xsl:value-of select="../Buyer/PricingAccount"/>
											</SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									<Supplier>
										<xsl:if test="../Seller/Name !=''">
											<SuppliersName>
												<xsl:value-of select="../Seller/Name"/>
											</SuppliersName>
										</xsl:if>
										<xsl:if test="../Seller/Address/BuildingIdentifier !=''">
											<SuppliersAddress>
												<AddressLine1>
													<xsl:value-of select="../Seller/Address/BuildingIdentifier"/>
												</AddressLine1>
												<xsl:if test="../Seller/Address/StreetName !=''">
													<AddressLine2>
														<xsl:value-of select="../Seller/Address/StreetName"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="../Seller/Address/City !=''">
												<AddressLine3>
													<xsl:value-of select="../Seller/Address/City"/>
												</AddressLine3>
												</xsl:if>
												<xsl:if test="../Seller/Address/Postcode !=''">
												<PostCode>
													<xsl:value-of select="../Seller/Address/Postcode"/>
												</PostCode>
												</xsl:if>
											</SuppliersAddress>
										</xsl:if>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="BuyingUnit/AccountCode"/>
											</SuppliersCode>
										</ShipToLocationID>
										<xsl:if test="BuyingUnit/Name !=''">
											<ShipToName>
												<xsl:value-of select="BuyingUnit/Name"/>
											</ShipToName>
										</xsl:if>
									</ShipTo>
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceNumber"/>
										</InvoiceReference>
										<InvoiceDate>
											<xsl:value-of select="InvoiceDate"/>
										</InvoiceDate>
									</InvoiceReferences>
								</InvoiceHeader>
								<InvoiceDetail>
									<xsl:for-each select="product_lines">
										<InvoiceLine>
											<LineNumber>
												<xsl:value-of select="product/@p_count"/>
											</LineNumber>
											<PurchaseOrderReferences>
												<PurchaseOrderReference>
													<xsl:value-of select="../OrderNumber"/>
												</PurchaseOrderReference>
											</PurchaseOrderReferences>
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="../delivery_note"/>
												</DeliveryNoteReference>
												<DeliveryNoteDate>
													<xsl:value-of select="../delivery_date"/>
												</DeliveryNoteDate>
											</DeliveryNoteReferences>
											<ProductID>
												<SuppliersProductCode>
													<xsl:value-of select="product/product_code"/>
												</SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:value-of select="product/product_desc"/>
											</ProductDescription>
											<InvoicedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="product/Invoice_qty/@size"/></xsl:attribute>
												<xsl:value-of select="product/Invoice_qty"/>
											</InvoicedQuantity>
											<UnitValueExclVAT>
												<xsl:value-of select="format-number(product/item_price,'0.00')"/>
											</UnitValueExclVAT>
											<LineValueExclVAT>
												<xsl:value-of select="format-number(product/item_value,'0.00')"/>
											</LineValueExclVAT>
											<VATCode>
												<xsl:value-of select="product/VatDetails/VatCode"/>
											</VATCode>
											<VATRate>
												<xsl:value-of select="format-number(product/VatDetails/VatRate,'0.00')"/>
											</VATRate>
										</InvoiceLine>
									</xsl:for-each>
								</InvoiceDetail>
								<InvoiceTrailer>
									<VATSubTotals>
										<xsl:for-each select="InvoiceTotals/VatRateTotals">
											<VATSubTotal>
												<xsl:attribute name="VATCode"><xsl:value-of select="VatDetails/VatCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="VatDetails/VatRate"/></xsl:attribute>
												<DocumentTotalExclVATAtRate>
													<xsl:value-of select="format-number(TaxableAmount,'0.00')"/>
												</DocumentTotalExclVATAtRate>
												<VATAmountAtRate>
													<xsl:value-of select="format-number(VatPayable,'0.00')"/>
												</VATAmountAtRate>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/InvoiceSubTotal,'0.00')"/>
									</DocumentTotalExclVAT>
									<VATAmount>
										<xsl:value-of select="format-number(InvoiceTotals/VatTotal,'0.00')"/>
									</VATAmount>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/InvoiceTotal,'0.00')"/>
									</DocumentTotalInclVAT>
								</InvoiceTrailer>
							</Invoice>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
