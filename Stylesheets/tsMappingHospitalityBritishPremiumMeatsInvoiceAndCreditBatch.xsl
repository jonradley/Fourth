<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="Report">
	<BatchRoot>
		<Batch>
			<BatchDocuments>
				<xsl:for-each select="table1/Detail_Collection/Detail[position() = 1 or ./@invoice_1 != preceding-sibling::*[1]/@invoice_1]">
					<xsl:variable name="invref">
						<xsl:value-of select="./@invoice_1"/>
					</xsl:variable>
					<BatchDocument>
						<xsl:if test="substring(./@order_no,1,2) != 'CN'">
						<Invoice>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="./@customer_1"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<InvoiceHeader>
								<Buyer>
									<BuyersLocationID>
										<SuppliersCode>BRITISH</SuppliersCode>
									</BuyersLocationID>
								</Buyer>
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="./@customer_1"/>
										</SuppliersCode>
									</ShipToLocationID>
									<ShipToName>
										<xsl:value-of select="./@name_1"/>
									</ShipToName>
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="./@invoice_1"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(./@dated_1,'T')"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(./@dated_1,'T')"/>
									</TaxPointDate>
								</InvoiceReferences>
							</InvoiceHeader>
							<InvoiceDetail>
								<xsl:for-each select="//Report/table1/Detail_Collection/Detail[./@invoice_1 = $invref]">
										<InvoiceLine>
											<ProductID>
												<SuppliersProductCode>
													<xsl:value-of select="./@product_1"/>
												</SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:value-of select="./@long_description_1"/>
											</ProductDescription>
											<InvoicedQuantity>
												<xsl:attribute name="UnitOfMeasure">
													<xsl:choose>
														<xsl:when test="normalize-space(./@pricing_unit_1) = 'KG'">KGM</xsl:when>
														<xsl:when test="normalize-space(./@pricing_unit_1) = 'EACH'">EA</xsl:when>
													</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="./@trans_desp_qty_1"/>
											</InvoicedQuantity>
											<UnitValueExclVAT>
												<xsl:value-of select="./@pricing_price_1"/>
											</UnitValueExclVAT>
											<LineValueExclVAT>
												<xsl:value-of select="./@val_1"/>
											</LineValueExclVAT>
											<VATRate>
												<xsl:value-of select="./@vat_rate_1"/>
											</VATRate>
										</InvoiceLine>

								</xsl:for-each>
							</InvoiceDetail>
						</Invoice>
						</xsl:if>
						<xsl:if test="substring(./@order_no,1,2) = 'CN'">
					<CreditNote>
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:value-of select="./@customer_1"/>
							</SendersCodeForRecipient>
						</TradeSimpleHeader>
						<CreditNoteHeader>
								<Buyer>
									<BuyersLocationID>
										<SuppliersCode>HARDCODETHIS</SuppliersCode>
									</BuyersLocationID>
								</Buyer>
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="./@customer_1"/>
										</SuppliersCode>
									</ShipToLocationID>
									<ShipToName>
										<xsl:value-of select="./@name_1"/>
									</ShipToName>
								</ShipTo>
							<CreditNoteReferences>
								<CreditNoteReference>
									<xsl:value-of select="./@invoice_1"/>
								</CreditNoteReference>
								<CreditNoteDate>
									<xsl:value-of select="./@dated_1"/>
								</CreditNoteDate>
								<TaxPointDate>
									<xsl:value-of select="./@dated_1"/>
								</TaxPointDate>
							</CreditNoteReferences>
						</CreditNoteHeader>
						<CreditNoteDetail>
							<CreditNoteLine>
								<ProductID>
									<SuppliersProductCode>
										<xsl:value-of select="./@product_1"/>
									</SuppliersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="./@long_description_1"/>
								</ProductDescription>
								<CreditedQuantity>
									<xsl:attribute name="UnitOfMeasure">
										<xsl:value-of select="./@pricing_unit_1"/>
									</xsl:attribute>
									<xsl:value-of select="./@trans_desp_qty_1"/>
								</CreditedQuantity>
								<UnitValueExclVAT>
									<xsl:value-of select="./@pricing_price_1"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="./@val_1"/>
								</LineValueExclVAT>
								<VATRate>
									<xsl:value-of select="./@vat_rate_1"/>
								</VATRate>
							</CreditNoteLine>
						</CreditNoteDetail>
					</CreditNote>
						</xsl:if>
					</BatchDocument>
				</xsl:for-each>
			</BatchDocuments>
		</Batch>
</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
