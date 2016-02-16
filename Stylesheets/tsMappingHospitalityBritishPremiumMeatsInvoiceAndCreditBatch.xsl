<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:template match="Report">
		<BatchRoot>
			<xsl:if test="count(table1/Detail_Collection/Detail[substring(./@order_no,1,2) != 'CN']) != 0">
			<Document>
				<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
				<Batch>
					<BatchDocuments>
						<xsl:variable name="nsInvRefs">
							<xsl:copy-of select="*"/>
							<xsl:for-each select="table1/Detail_Collection/Detail[substring(./@order_no,1,2) != 'CN']">
								<xsl:sort select="./@invoice_1"/>
								<Line>
									<InvoiceRef>
										<xsl:value-of select="./@invoice_1"/>
									</InvoiceRef>
									<SCR>
										<xsl:value-of select="./@customer_1"/>
									</SCR>
									<Name>
										<xsl:value-of select="./@name_1"/>
									</Name>
									<InvDate>
										<xsl:value-of select="./@dated_1"/>
									</InvDate>
								</Line>
							</xsl:for-each>
						</xsl:variable>
						<xsl:for-each select="msxsl:node-set($nsInvRefs)/Line[position() = 1 or ./InvoiceRef != preceding-sibling::*[1]/InvoiceRef]">
							<xsl:variable name="invref">
								<xsl:value-of select="InvoiceRef"/>
							</xsl:variable>
							<BatchDocument>
								<Invoice>
									<TradeSimpleHeader>
										<SendersCodeForRecipient>
											<xsl:value-of select="SCR"/>
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
													<xsl:value-of select="SCR"/>
												</SuppliersCode>
											</ShipToLocationID>
											<ShipToName>
												<xsl:value-of select="Name"/>
											</ShipToName>
										</ShipTo>
										<InvoiceReferences>
											<InvoiceReference>
												<xsl:value-of select="$invref"/>
											</InvoiceReference>
											<InvoiceDate>
												<xsl:value-of select="substring-before(InvDate,'T')"/>
											</InvoiceDate>
											<TaxPointDate>
												<xsl:value-of select="substring-before(InvDate,'T')"/>
											</TaxPointDate>
										</InvoiceReferences>
									</InvoiceHeader>
									<InvoiceDetail>
										<xsl:for-each select="/table1/Detail_Collection/Detail[./@invoice_1 = $invref]">
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
													<xsl:if test="normalize-space(./@pricing_unit_1) != ' '">
														<xsl:attribute name="UnitOfMeasure"><xsl:choose><xsl:when test="normalize-space(./@pricing_unit_1) = 'KG'">KGM</xsl:when><xsl:when test="normalize-space(./@pricing_unit_1) = 'EACH'">EA</xsl:when></xsl:choose></xsl:attribute>
													</xsl:if>
													<xsl:value-of select="format-number(./@trans_desp_qty_1,'0.0000')"/>
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
							</BatchDocument>
						</xsl:for-each>
					</BatchDocuments>
				</Batch>
			</Document>
			</xsl:if>
			<xsl:if test="count(table1/Detail_Collection/Detail[substring(./@order_no,1,2) = 'CN']) != 0">
			<Document>
				<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
				<Batch>
					<BatchDocuments>
						<xsl:variable name="nsInvRefs">
							<xsl:copy-of select="*"/>
							<xsl:for-each select="table1/Detail_Collection/Detail[substring(./@order_no,1,2) = 'CN']">
								<xsl:sort select="./@invoice_1"/>
								<Line>
									<InvoiceRef>
										<xsl:value-of select="./@invoice_1"/>
									</InvoiceRef>
									<SCR>
										<xsl:value-of select="./@customer_1"/>
									</SCR>
									<Name>
										<xsl:value-of select="./@name_1"/>
									</Name>
									<InvDate>
										<xsl:value-of select="./@dated_1"/>
									</InvDate>
								</Line>
							</xsl:for-each>
						</xsl:variable>
						<xsl:for-each select="msxsl:node-set($nsInvRefs)/Line[position() = 1 or ./InvoiceRef != preceding-sibling::*[1]/InvoiceRef]">
							<xsl:variable name="invref">
								<xsl:value-of select="InvoiceRef"/>
							</xsl:variable>
							<BatchDocument>
								<CreditNote>
									<TradeSimpleHeader>
										<SendersCodeForRecipient>
											<xsl:value-of select="SCR"/>
										</SendersCodeForRecipient>
									</TradeSimpleHeader>
									<CreditNoteHeader>
										<Buyer>
											<BuyersLocationID>
												<SuppliersCode>BRITISH</SuppliersCode>
											</BuyersLocationID>
										</Buyer>
										<ShipTo>
											<ShipToLocationID>
												<SuppliersCode>
													<xsl:value-of select="SCR"/>
												</SuppliersCode>
											</ShipToLocationID>
											<ShipToName>
												<xsl:value-of select="Name"/>
											</ShipToName>
										</ShipTo>
										<CreditNoteReferences>
											<CreditNoteReference>
												<xsl:value-of select="$invref"/>
											</CreditNoteReference>
											<CreditNoteDate>
												<xsl:value-of select="substring-before(InvDate,'T')"/>
											</CreditNoteDate>
											<TaxPointDate>
												<xsl:value-of select="substring-before(InvDate,'T')"/>
											</TaxPointDate>
										</CreditNoteReferences>
									</CreditNoteHeader>
									<CreditNoteDetail>
										<xsl:for-each select="/table1/Detail_Collection/Detail[./@invoice_1 = $invref]">
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
													<xsl:if test="normalize-space(./@pricing_unit_1) != ''">
														<xsl:attribute name="UnitOfMeasure"><xsl:choose><xsl:when test="normalize-space(./@pricing_unit_1) = 'KG'">KGM</xsl:when><xsl:when test="normalize-space(./@pricing_unit_1) = 'EACH'">EA</xsl:when></xsl:choose></xsl:attribute>
													</xsl:if>
													<xsl:value-of select="format-number(./@trans_desp_qty_1,'0.000')"/>
												</CreditedQuantity>
												<UnitValueExclVAT>
													<xsl:value-of select="./@pricing_price_1"/>
												</UnitValueExclVAT>
												<LineValueExclVAT>
													<xsl:value-of select="format-number(./@val_1 * -1,'0.00')"/>
												</LineValueExclVAT>
												<VATRate>
													<xsl:value-of select="./@vat_rate_1"/>
												</VATRate>
											</CreditNoteLine>
										</xsl:for-each>
									</CreditNoteDetail>
								</CreditNote>
							</BatchDocument>
						</xsl:for-each>
					</BatchDocuments>
				</Batch>
			</Document>
			</xsl:if>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
