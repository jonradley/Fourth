<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>
	<xsl:template match="Buyer"/>
	<xsl:template match="Seller"/>
	<xsl:template match="/CreditNotes">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="CreditNote">
						<BatchDocument>
							<CreditNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="BuyingUnit/AccountCode"/>
									</SendersCodeForRecipient>
									<SendersBranchReference>
										<xsl:value-of select="../Buyer/PricingAccount"/>
									</SendersBranchReference>
								</TradeSimpleHeader>
								<CreditNoteHeader>
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
												<xsl:if test="../Seller/Address/Postcode">
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
										<InvoiceReference> </InvoiceReference>
										<InvoiceDate>1967-08-13</InvoiceDate>
										<TaxPointDate>1967-08-13</TaxPointDate>
									</InvoiceReferences>
									<CreditNoteReferences>
										<CreditNoteReference>
											<xsl:value-of select="CreditNoteNumber"/>
										</CreditNoteReference>
										<CreditNoteDate>
											<xsl:value-of select="CreditNoteDate"/>
										</CreditNoteDate>
										<TaxPointDate>
											<xsl:value-of select="CreditNoteDate"/>
										</TaxPointDate>
									</CreditNoteReferences>
								</CreditNoteHeader>
								<CreditNoteDetail>
									<xsl:for-each select="product_lines">
										<CreditNoteLine>
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
											<CreditedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="product/CreditNote_qty/@size"/></xsl:attribute>
												<xsl:value-of select="product/CreditNote_qty"/>
											</CreditedQuantity>
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
										</CreditNoteLine>
									</xsl:for-each>
								</CreditNoteDetail>
								<CreditNoteTrailer>
									<VATSubTotals>
										<xsl:for-each select="CreditNoteTotals/VatRateTotals">
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
										<xsl:value-of select="format-number(CreditNoteTotals/Credit_NotesubTotal,'0.00')"/>
									</DocumentTotalExclVAT>
									<VATAmount>
										<xsl:value-of select="format-number(CreditNoteTotals/VatTotal,'0.00')"/>
									</VATAmount>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(CreditNoteTotals/CreditNoteTotal,'0.00')"/>
									</DocumentTotalInclVAT>
								</CreditNoteTrailer>
							</CreditNote>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
