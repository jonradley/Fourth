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
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:for-each select="/Invoice">
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
									<DocumentStatus>Original</DocumentStatus>
									<Supplier>
										<SuppliersLocationID>
											<BuyersCode>
												<xsl:value-of select="../Buyer/PricingAccount"/>
											</BuyersCode>
										</SuppliersLocationID>
										<SuppliersName>
											<xsl:value-of select="../Seller/Name"/>
										</SuppliersName>
										<SuppliersAddress>
											<AddressLine1>
												<xsl:value-of select="../Seller/Address/BuildingIdentifier"/>
											</AddressLine1>
											<AddressLine2>
												<xsl:value-of select="../Seller/Address/StreetName"/>
											</AddressLine2>
											<AddressLine3>
												<xsl:value-of select="../Seller/Address/City"/>
											</AddressLine3>
											<PostCode>
												<xsl:value-of select="../Seller/Address/Postcode"/>
											</PostCode>
										</SuppliersAddress>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="BuyingUnit/AccountCode"/>
											</SuppliersCode>
										</ShipToLocationID>
										<ShipToName>
											<xsl:value-of select="BuyingUnit/Name"/>
										</ShipToName>
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
										<xsl:for-each select="InvoiceTotals">
											<VATSubTotal>
												<xsl:attribute name="VATCode"><xsl:value-of select="VatRateTotals/VatDetails/VatCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="VatRateTotals/VatDetails/VatRate"/></xsl:attribute>
												<DocumentTotalExclVATAtRate>
													<xsl:value-of select="format-number(VatRateTotals/TaxableAmount,'0.00')"/>
												</DocumentTotalExclVATAtRate>
												<VATAmountAtRate>
													<xsl:value-of select="format-number(VatRateTotals/VatPayable,'0.00')"/>
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
						</xsl:for-each>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
