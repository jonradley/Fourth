<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:pay="urn:ean.ucc:pay:2" xmlns:vat="urn:ean.ucc:pay:vat:2">
	<xsl:template match="/">
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<CreditNote>
						<TradeSimpleHeader>
						
							<SendersCodeForRecipient>
								<xsl:value-of select="//shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
							</SendersCodeForRecipient>
							
						</TradeSimpleHeader>
						<!--~~~~~~~~~~~~~~~~~~~~~~~~~
						CREDIT NOTE HEADER
						~~~~~~~~~~~~~~~~~~~~~~~~~ -->
						<CreditNoteHeader>
							
							<xsl:if test="//documentCommandOperand/pay:invoice/@documentStatus ='ORIGINAL'">
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
							</xsl:if>
							
							<Buyer>
								<BuyersLocationID>
									<xsl:if test="string(//sh:Receiver/sh:Identifier) !='' ">
										<GLN>
											<xsl:value-of select="//sh:Receiver/sh:Identifier"/>
										</GLN>
									</xsl:if>
								</BuyersLocationID>
							</Buyer>
							
							<Supplier>
								<SuppliersLocationID>
									<xsl:if test="string(//sh:Sender/sh:Identifier) !='' ">
										<GLN>
											<xsl:value-of select="//sh:Sender/sh:Identifier"/>
										</GLN>
									</xsl:if>
								</SuppliersLocationID>
							</Supplier>
							
							<ShipTo>
								<ShipToLocationID>
									<BuyersCode>
										<xsl:value-of select="//shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
									</BuyersCode>
									<SuppliersCode>
										<xsl:value-of select="//shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
									</SuppliersCode>
								</ShipToLocationID>
							</ShipTo>
							
							<InvoiceReferences>
							
								<InvoiceReference>
									<xsl:value-of select="//eanucc:message/eanucc:transaction/entityIdentification/uniqueCreatorIdentification"/>
								</InvoiceReference>
								
							</InvoiceReferences>
							
							<CreditNoteReferences>
							
								<CreditNoteReference>
									<xsl:value-of select="//sh:DocumentIdentification/sh:InstanceIdentifier"/>
								</CreditNoteReference>
								
								<CreditNoteDate>
									<xsl:value-of select="substring-before(//sh:DocumentIdentification/sh:CreationDateAndTime, 'T')"/>
								</CreditNoteDate>
								
								<xsl:if test="//vat:vATInvoicePartyExtension/vATRegistrationNumber !=''">
									<VATRegNo>
										<xsl:value-of select="//vat:vATInvoicePartyExtension/vATRegistrationNumber"/>
									</VATRegNo>
								</xsl:if>
								
							</CreditNoteReferences>
							
							<DeliveryNoteReferences>
								<xsl:if test="string(//invoiceLineItem/deliveryNote/referenceIdentification) !=' '">
									<DeliveryNoteReference>
										<xsl:value-of select="//invoiceLineItem/deliveryNote/referenceIdentification"/>
									</DeliveryNoteReference>
								</xsl:if>
								<xsl:if test="string(//invoiceLineItem/deliveryNote/referenceDateTime) !=' '">
									<DeliveryNoteDate>
										<xsl:value-of select="substring-before(//invoiceLineItem/deliveryNote/referenceDateTime, 'T')"/>
									</DeliveryNoteDate>
								</xsl:if>
							</DeliveryNoteReferences>
							
						</CreditNoteHeader>
						<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							CREDIT NOTE DETAIL
						~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
						<xsl:for-each select="//documentCommandOperand/pay:invoice/invoiceLineItem">
							<CreditNoteDetail>
								<CreditNoteLine>
								
									<xsl:if test="string(@number) !=' '">
										<LineNumbe>
											<xsl:value-of select="@number"/>
										</LineNumbe>
									</xsl:if>
									
									<ProductID>
										<xsl:if test="string(tradeItemIdentification/gtin) !='00000000000000'">
											<GTIN>
												<xsl:value-of select="tradeItemIdentification/gtin"/>
											</GTIN>
										</xsl:if>
										<xsl:if test="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue !=''"/>
										<SuppliersProductCode>
											<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
										</SuppliersProductCode>
									</ProductID>
									
									<xsl:if test="string(itemDescription/text) !=''">
										<ProductDescription>
											<xsl:value-of select="itemDescription/text"/>
										</ProductDescription>
									</xsl:if>
									
									<CreditedQuantity>
										<xsl:value-of select="format-number(invoicedQuantity/value, '0.00')"/>
									</CreditedQuantity>
									
									<UnitValueExclVAT>
										<xsl:value-of select="format-number(itemPriceInclusiveAllowancesCharges, '0.00')"/>
									</UnitValueExclVAT>
									
									<LineValueExclVAT>
										<xsl:value-of select="format-number(amountInclusiveAllowancesCharges, '0.00')"/>
									</LineValueExclVAT>
									
									<VATCode>
										<xsl:choose>
											<xsl:when test="invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS'">
												<xsl:text>Z</xsl:text>
											</xsl:when>
											<xsl:when test="invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE'">
												<xsl:text>S</xsl:text>
											</xsl:when>
											<xsl:otherwise>Unrecognised</xsl:otherwise>
										</xsl:choose>
									</VATCode>
									
									<VATRate>
										<xsl:value-of select="format-number(invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/rate, '0.00')"/>
									</VATRate>
									
								</CreditNoteLine>
							</CreditNoteDetail>
						</xsl:for-each>
						<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							CREDIT NOTE TRAILER
						~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
						<CreditNoteTrailer>
							
							<NumberOfLines>
								<xsl:value-of select="count(//invoiceLineItem/@number)"/>
							</NumberOfLines>
							
							<NumberOfItems>
								<xsl:value-of select="count(//pay:invoice/invoiceLineItem/invoicedQuantity/value)"/>
							</NumberOfItems>
							
							<xsl:for-each select="//pay:invoice/invoiceTotals/taxSubTotal/extension/vat:vATTaxInformationExtension">
								<VATSubTotals>
							
									<VATSubTotal>
										<xsl:attribute name="VATCode">
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:text>Z</xsl:text>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:text>S</xsl:text>
												</xsl:when>
												<xsl:otherwise>Unrecognised</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										
										<xsl:attribute name="VATRate">
											<xsl:value-of select="format-number(rate, '0.00')"/>
										</xsl:attribute>
										
										<NumberOfLinesAtRate>
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:value-of select="count(//pay:invoice/invoiceLineItem/invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension[vATCategory = 'ZERO_RATED_GOODS'])"/>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:value-of select="count(//pay:invoice/invoiceLineItem/invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension[vATCategory = 'STANDARD_RATE'])"/>
												</xsl:when>
											</xsl:choose>
										</NumberOfLinesAtRate>
										
										<NumberOfItemsAtRate>
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:value-of select="count(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS']/invoicedQuantity/value)"/>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:value-of select="count(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/invoicedQuantity/value)"/>
												</xsl:when>
											</xsl:choose>
										</NumberOfItemsAtRate>
										
										<DocumentTotalExclVATAtRate>
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS']/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
												</xsl:when>
												<xsl:otherwise>Error</xsl:otherwise>
											</xsl:choose>
										</DocumentTotalExclVATAtRate>
										
										<VATAmountAtRate>
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals/taxSubTotal[extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS']/taxAmount, '0.00')"/>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals/taxSubTotal[extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/taxAmount, '0.00')"/>
												</xsl:when>
												<xsl:otherwise>Error</xsl:otherwise>
											</xsl:choose>
										</VATAmountAtRate>
										
										<DocumentTotalInclVATAtRate>
											<xsl:choose>
												<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS']/totalInvoiceAmount, '0.00')"/>
												</xsl:when>
												<xsl:when test="vATCategory = 'STANDARD_RATE'">
													<xsl:value-of select="format-number(//pay:invoice/invoiceTotals[taxSubTotal/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/totalInvoiceAmount, '0.00')"/>
												</xsl:when>
												<xsl:otherwise>Error</xsl:otherwise>
											</xsl:choose>
										</DocumentTotalInclVATAtRate>
										
									</VATSubTotal>
								</VATSubTotals>
							</xsl:for-each>
							
							<DocumentTotalExclVAT>
								<xsl:choose>
									<xsl:when test="count(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalLineAmountInclusiveAllowancesCharges > 1])">
										<xsl:value-of select="format-number(sum(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalLineAmountInclusiveAllowancesCharges),'0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalLineAmountInclusiveAllowancesCharges, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</DocumentTotalExclVAT>
							
							<VATAmount>
								<xsl:choose>
									<xsl:when test="count(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalTaxAmount > 1])">									
										<xsl:value-of select="format-number(sum(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalTaxAmount), '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
											<xsl:value-of select="format-number(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalTaxAmount, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</VATAmount>
							
							<DocumentTotalInclVAT>
								<xsl:choose>
									<xsl:when test="count(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals[totalInvoiceAmount > 1])">
										<xsl:value-of select="format-number(sum(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalInvoiceAmount), '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/pay:invoice/invoiceTotals/totalInvoiceAmount, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</DocumentTotalInclVAT>
							
						</CreditNoteTrailer>
					</CreditNote>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
	</xsl:template>
</xsl:stylesheet>