<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
K Oshaughnessy| 2011-03-30		|  Created Modele
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:pay="urn:ean.ucc:pay:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:vat="urn:ean.ucc:pay:vat:2">
	<!--xsi:schemaLocation="urn:ean.ucc:pay:vat:2 ../Schemas/Invoice_VATExtensionProxy.xsd" xsi:schemaLocation="urn:ean.ucc:2 ../Schemas/InvoiceProxy.xsd"-->
	<xsl:output method="xml"/>
	<xsl:template match="sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<Invoice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="//pay:invoice/shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
								</SendersCodeForRecipient>
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
										<GLN>
											<xsl:value-of select="//pay:invoice/buyer/partyIdentification/gln"/>
										</GLN>
									</BuyersLocationID>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="//pay:invoice/seller/partyIdentification/gln"/>
										</GLN>
									</SuppliersLocationID>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="//pay:invoice/shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:CreationDateAndTime,'T')"/>
									</InvoiceDate>
								</InvoiceReferences>
							</InvoiceHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~
								INVOICE LINE DETAIL
						~~~~~~~~~~~~~~~~~~~~~~~~~-->
							<InvoiceDetail>
								<xsl:for-each select="//pay:invoice/invoiceLineItem">
								
									<InvoiceLine>
										<xsl:if test="string(@number) !=' '">
											<LineNumber>
												<xsl:value-of select="format-number(@number,'0')"/>
											</LineNumber>
										</xsl:if>
										
										<PurchaseOrderReferences>
											<PurchaseOrderReference>
												<xsl:value-of select="//pay:invoice/invoiceLineItem/@PurchaseOrderNum"/>
											</PurchaseOrderReference>
											<PurchaseOrderDate>
												<xsl:value-of select="//pay:invoice/invoiceLineItem/@PurchaseOrderDate"/>
											</PurchaseOrderDate>
										</PurchaseOrderReferences>

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
											<xsl:value-of select="itemPriceExclusiveAllowancesCharges"/>
										</UnitValueExclVAT>
										
										<xsl:if test="string(amountInclusiveAllowancesCharges) !=' '">
											<LineValueExclVAT>
												<xsl:value-of select="amountExclusiveAllowancesCharges"/>
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
									<xsl:value-of select="count(//pay:invoice/invoiceLineItem/@number)"/>
									
								</NumberOfLines>
								
								<NumberOfItems>
									<xsl:value-of select="sum(//pay:invoice/invoiceLineItem/invoicedQuantity/value)"/>
								</NumberOfItems>

								<VATAmount>
									<xsl:value-of select="//pay:invoice/invoiceTotals/totalTaxAmount"/>
								</VATAmount>
								
								<DocumentTotalInclVAT>
									<xsl:value-of select="//pay:invoice/invoiceTotals/totalInvoiceAmount"/>
								</DocumentTotalInclVAT>
								
							</InvoiceTrailer>
						</Invoice>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
