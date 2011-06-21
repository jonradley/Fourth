<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:pay="urn:ean.ucc:pay:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:vat="urn:ean.ucc:pay:vat:2">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<Invoice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<TradeSimpleHeader>
							
								<SendersCodeForRecipient>
									<xsl:value-of select="substring-before(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
								</SendersCodeForRecipient>
								
								<SendersBranchReference>
									<xsl:value-of select="substring-after(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
								</SendersBranchReference>
								
							</TradeSimpleHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~
							 INVOICE HEADER
							~~~~~~~~~~~~~~~~~~~-->
							<InvoiceHeader>
								<xsl:if test="string(//pay:invoice/@documentStatus) ='ORIGINAL'">
									<DocumentStatus>
										<xsl:text>Original</xsl:text>
									</DocumentStatus>
								</xsl:if>
								<Buyer>
									<BuyersLocationID>
										<xsl:if test="string(//sh:Receiver/sh:Identifier) !=' '">
											<GLN>
												<xsl:value-of select="//sh:Receiver/sh:Identifier"/>
											</GLN>
										</xsl:if>
									</BuyersLocationID>
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(//sh:Sender/sh:Identifier) !=' '">
											<GLN>
												<xsl:value-of select="//sh:Sender/sh:Identifier"/>
											</GLN>
										</xsl:if>
										<!--BuyerAssigned>
											<xsl:value-of select="//pay:invoice/seller/BuyerAssigned"/>
										</BuyerAssigned-->	
									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<!--BuyersCode>
											<xsl:value-of select="//shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
										</BuyersCode-->
										<SuppliersCode>
											<xsl:value-of select="//shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="//eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceLineItem/orderIdentification/documentReference/uniqueCreatorIdentification"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(//eanucc:documentCommand/documentCommandOperand/pay:invoice/@creationDateTime,'T')"/>
									</InvoiceDate>
								</InvoiceReferences>
							</InvoiceHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~
								INVOICE LINE DETAIL
						~~~~~~~~~~~~~~~~~~~~~~~~~-->
						<InvoiceDetail>
						
							<xsl:for-each select="//documentCommandOperand/pay:invoice/invoiceLineItem">
									<InvoiceLine>
										<xsl:if test="string(@number) !=' '">
											<LineNumber>
												<xsl:value-of select="@number"/>
											</LineNumber>
										</xsl:if>
										<PurchaseOrderReferences>
											<PurchaseOrderReference>
												<xsl:value-of select="//eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceLineItem/orderIdentification/documentReference/uniqueCreatorIdentification"/>
											</PurchaseOrderReference>
											<!--PurchaseOrderDate>
												<xsl:value-of select="substring-before(//eanucc:documentCommand/documentCommandOperand/pay:invoice/@creationDateTime,'T')"/>
											</PurchaseOrderDate-->
										</PurchaseOrderReferences>
										
										<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:value-of select="//eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceLineItem/deliveryNote/referenceIdentification"/>
												</DeliveryNoteReference>
												<DeliveryNoteDate>
													<xsl:value-of select="substring-before(//eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceLineItem/deliveryNote/referenceDateTime,'T')"/>
												</DeliveryNoteDate>
										</DeliveryNoteReferences>
										
										<ProductID>
											<GTIN>
												<xsl:choose>
													<xsl:when test="tradeItemIdentification/gtin = ''">
														<xsl:text>5555555555555</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="tradeItemIdentification/gtin"/>
													</xsl:otherwise>
												</xsl:choose>
											</GTIN>
											<xsl:if test="string(tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue !=' ')">
												<SuppliersProductCode>
													<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
												</SuppliersProductCode>
											</xsl:if>
										</ProductID>
										<xsl:if test="string(itemDescription/text) !=' '">
											<ProductDescription>
												<xsl:value-of select="itemDescription/text"/>
											</ProductDescription>
										</xsl:if>
										<InvoicedQuantity>
											<xsl:value-of select="invoicedQuantity/value"/>
										</InvoicedQuantity>
										<UnitValueExclVAT>
											<xsl:value-of select="itemPriceInclusiveAllowancesCharges"/>
										</UnitValueExclVAT>
										<xsl:if test="string(amountInclusiveAllowancesCharges) !=' '">
											<LineValueExclVAT>
												<xsl:value-of select="amountInclusiveAllowancesCharges"/>
											</LineValueExclVAT>
										</xsl:if>
										<VATCode>
											<xsl:choose>
												<xsl:when test="invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:text>Z</xsl:text>
												</xsl:when>
												<xsl:when test="invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
													<xsl:text>S</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Unrecognised</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</VATCode>
										<VATRate>
											<xsl:value-of select="format-number(invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/rate, '0.00')"/>
										</VATRate>
									</InvoiceLine>
							</xsl:for-each>
							
						</InvoiceDetail>
							<!--~~~~~~~~~~~~~~~~~~~~~~~
								INVOICE TRAILER
						~~~~~~~~~~~~~~~~~~~~~~~~-->
							<InvoiceTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(//invoiceLineItem/@number)"/>
								</NumberOfLines>
								<NumberOfItems>
									<xsl:value-of select="sum(//pay:invoice/invoiceLineItem/invoicedQuantity/value)"/>
								</NumberOfItems>
								<VATSubTotals>
									<xsl:for-each select="sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/taxSubTotal">
										<VATSubTotal>
											<xsl:attribute name="VATCode"><xsl:choose><xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory ='ZERO_RATED_GOODS'"><xsl:text>Z</xsl:text></xsl:when><xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'"><xsl:text>S</xsl:text></xsl:when><xsl:otherwise>Error</xsl:otherwise></xsl:choose></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number(extension/vat:vATTaxInformationExtension/rate, '0.00')"/></xsl:attribute>
											<NumberOfLinesAtRate>
												<xsl:choose>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
														<xsl:value-of select="count(//pay:invoice/invoiceLineItem/invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension[vATCategory = 'ZERO_RATED_GOODS'])"/>
													</xsl:when>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
														<xsl:value-of select="count(//pay:invoice/invoiceLineItem/invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension[vATCategory='STANDARD_RATE'])"/>
													</xsl:when>
												</xsl:choose>
											</NumberOfLinesAtRate>
											<NumberOfItemsAtRate>
												<xsl:choose>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
														<xsl:value-of select="sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory='ZERO_RATED_GOODS']/invoicedQuantity/value)"/>
													</xsl:when>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
														<xsl:value-of select="sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory='STANDARD_RATE']/invoicedQuantity/value)"/>
													</xsl:when>
													<xsl:otherwise>error</xsl:otherwise>
												</xsl:choose>
											</NumberOfItemsAtRate>
											<DocumentTotalExclVATAtRate>
												<xsl:choose>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
														<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory='ZERO_RATED_GOODS']/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
													</xsl:when>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
														<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory='STANDARD_RATE']/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
													</xsl:when>
													<xsl:otherwise>Error</xsl:otherwise>
												</xsl:choose>
											</DocumentTotalExclVATAtRate>
											<VATAmountAtRate>
												<xsl:value-of select="format-number(taxAmount, '0.00')"/>
											</VATAmountAtRate>
											<DocumentTotalInclVATAtRate>
												<xsl:choose>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
														<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory='ZERO_RATED_GOODS']/totalInvoiceAmount, '0.00')"/>
													</xsl:when>
													<xsl:when test="extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
														<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory='STANDARD_RATE']/totalInvoiceAmount,'0.00')"/>
													</xsl:when>
													<xsl:otherwise>Error</xsl:otherwise>
												</xsl:choose>
											</DocumentTotalInclVATAtRate>
										</VATSubTotal>
									</xsl:for-each>
								</VATSubTotals>
								<DocumentTotalExclVAT>
									<xsl:choose>
										<xsl:when test="count(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalLineAmountInclusiveAllowancesCharges > 1])">
											<xsl:value-of select="format-number(sum(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalLineAmountInclusiveAllowancesCharges),'0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentTotalExclVAT>
								<VATAmount>
									<xsl:choose>
										<xsl:when test="count(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalTaxAmount > 1])">
											<xsl:value-of select="format-number(sum(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalTaxAmount), '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalTaxAmount, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</VATAmount>
								<DocumentTotalInclVAT>
									<xsl:choose>
										<xsl:when test="count(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalInvoiceAmount > 1])">
											<xsl:value-of select="format-number(sum(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalInvoiceAmount), '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number(sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalInvoiceAmount, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentTotalInclVAT>
							</InvoiceTrailer>
						</Invoice>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
