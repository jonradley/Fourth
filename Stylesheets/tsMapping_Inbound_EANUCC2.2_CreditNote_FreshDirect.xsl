<!--************************************************************************************************
Date				| Name					| Comments	
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
03/08/2011		|	Koshaughnessy		| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
26/09/2011		|	KOshaughnessy		|Bugfix 4984,4896
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
06/10/2011		| 	KOshaughnessy		|Bugfix 4925
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
13/10/11			|	KOshaughnessy		|Bugfix 4943
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
24/11/11			|	H Robson		|Bugfix 5061
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
13/03/12			|	H Robson		|Bugfix 5312 SuppliersCode for ShipTo to be same as SendersCodeForRecipient to stop credits being suspended.
*************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:pay="urn:ean.ucc:pay:2" xmlns:vat="urn:ean.ucc:pay:vat:2">
	<xsl:output encoding="UTF-8"/> 
	
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<CreditNote>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="substring-before(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
								</SendersCodeForRecipient>
								<SendersBranchReference>
									<xsl:value-of select="substring-after(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
								</SendersBranchReference>
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
										<SuppliersCode>
											<xsl:value-of select="substring-after(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
										</SuppliersCode>
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
											<!-- 2012-03-13 id-5312 get code from same place as Sender's code for recipient -->
											<xsl:value-of select="substring-before(//seller/additionalPartyIdentification/additionalPartyIdentificationValue,'|')"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="//pay:invoice/invoiceLineItem/invoice/documentReference/uniqueCreatorIdentification"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(//pay:invoice/invoiceLineItem/deliveryNote/referenceDateTime, 'T')"/>
									</InvoiceDate>
								</InvoiceReferences>
								<CreditNoteReferences>			
									<CreditNoteReference>
										<xsl:value-of select="//pay:invoice/invoiceIdentification/uniqueCreatorIdentification"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<!-- 24/11/11 - use DN date by order of Chris -->
										<xsl:value-of select="substring-before(//pay:invoice/invoiceLineItem/deliveryNote/referenceDateTime, 'T')"/>
									</CreditNoteDate>
									<TaxPointDate>
										<!-- 24/11/11 - use DN date by order of Chris -->
										<xsl:value-of select="substring-before(//pay:invoice/invoiceLineItem/deliveryNote/referenceDateTime, 'T')"/>
									</TaxPointDate>
									<xsl:if test="//vat:vATInvoicePartyExtension/vATRegistrationNumber !=''">
										<VATRegNo>
											<xsl:value-of select="//vat:vATInvoicePartyExtension/vATRegistrationNumber"/>
										</VATRegNo>
									</xsl:if>
								</CreditNoteReferences>
							</CreditNoteHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							CREDIT NOTE DETAIL
						~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteDetail>
								<xsl:for-each select="//documentCommandOperand/pay:invoice/invoiceLineItem">
									<CreditNoteLine>
										<xsl:if test="string(@number) !=' '">
											<LineNumber>
												<xsl:value-of select="@number"/>
											</LineNumber>
										</xsl:if>
										
										<xsl:if test="//pay:invoice/invoiceLineItem/orderIdentification/documentReference/uniqueCreatorIdentification != ''">
											<PurchaseOrderReferences>
												<PurchaseOrderReference>
													<xsl:value-of select="//pay:invoice/invoiceLineItem/orderIdentification/documentReference/uniqueCreatorIdentification"/>
												</PurchaseOrderReference>
											</PurchaseOrderReferences>
										</xsl:if>
										
										<DeliveryNoteReferences>
											<xsl:if test="string(//pay:invoice/invoiceLineItem/invoice/documentReference/uniqueCreatorIdentification) !=' '">
												<DeliveryNoteReference>
													<!-- 24/11/11 - use INV ref by order of Chris -->
													<xsl:value-of select="//pay:invoice/invoiceLineItem/invoice/documentReference/uniqueCreatorIdentification"/>
												</DeliveryNoteReference>
											</xsl:if>
											<xsl:if test="string(//invoiceLineItem/deliveryNote/referenceDateTime) !=' '">
												<DeliveryNoteDate>
													<xsl:value-of select="substring-before(//invoiceLineItem/deliveryNote/referenceDateTime, 'T')"/>
												</DeliveryNoteDate>
											</xsl:if>
										</DeliveryNoteReferences>
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
								</xsl:for-each>
							</CreditNoteDetail>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
							CREDIT NOTE TRAILER
						~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
							<CreditNoteTrailer>
							
								<NumberOfLines>
									<xsl:value-of select="count(//invoiceLineItem/@number)"/>
								</NumberOfLines>
								
								<NumberOfItems>
									<xsl:value-of select="sum(//pay:invoice/invoiceLineItem/invoicedQuantity/value)"/>
								</NumberOfItems>
								
								
								
									<VATSubTotals>
									
										<xsl:for-each select="//pay:invoice/invoiceTotals/taxSubTotal/extension/vat:vATTaxInformationExtension">
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
															<xsl:value-of select="sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 	'ZERO_RATED_GOODS']/invoicedQuantity/value)"/>
														</xsl:when>
														<xsl:when test="vATCategory = 'STANDARD_RATE'">
															<xsl:value-of select="sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/invoicedQuantity/value)"/>
														</xsl:when>
													</xsl:choose>
												</NumberOfItemsAtRate>
												
												<DocumentTotalExclVATAtRate>
													<xsl:choose>
														<xsl:when test="vATCategory = 'ZERO_RATED_GOODS'">
															<xsl:value-of select="format-number(sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'ZERO_RATED_GOODS']/amountInclusiveAllowancesCharges), '0.00')"/>
														</xsl:when>
														<xsl:when test="vATCategory = 'STANDARD_RATE'">
															<xsl:value-of select="format-number(sum(//pay:invoice/invoiceLineItem[invoiceLineTaxInformation/extension/vat:vATTaxInformationExtension/vATCategory = 'STANDARD_RATE']/amountInclusiveAllowancesCharges), '0.00')"/>
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
												
											</VATSubTotal>
										</xsl:for-each>	
										
									</VATSubTotals>
								
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
		</BatchRoot>
	</xsl:template>
	
</xsl:stylesheet>
