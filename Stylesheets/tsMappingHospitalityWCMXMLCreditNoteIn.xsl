<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************************************************************************************************************************************************************************************************
Date				|	Owner					|	Details
**********************************************************************************************************************************************************************************************************************************************************
26/03/2013		|	M Dimant				| 	5943: Created
**********************************************************************************************************************************************************************************************************************************************************
05/06/2013		|	M Dimant				| 	6614: Corrected how we mapp the PO ref and DN ref in a batch.		
**********************************************************************************************************************************************************************************************************************************************************
20/02/2017		|	M Dimant				| 	FB11596: Fixed mapping of Delivery Note reference		
**********************************************************************************************************************************************************************************************************************************************************
-->
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
									<xsl:if test="InvoiceNumber!=''">
										<InvoiceReferences>
											<InvoiceReference><xsl:value-of select="InvoiceNumber"/></InvoiceReference>
											<InvoiceDate><xsl:value-of select="InvoiceDate"/></InvoiceDate>
											<TaxPointDate><xsl:value-of select="InvoiceDate"/></TaxPointDate>
										</InvoiceReferences>
									</xsl:if>
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
									<xsl:for-each select="product_lines/product">
										<CreditNoteLine>
											<LineNumber>
												<xsl:value-of select="@p_count"/>
											</LineNumber>
											<xsl:if test="../../OrderNumber !=''">
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of select="../../OrderNumber"/>
													</PurchaseOrderReference>
												</PurchaseOrderReferences>
											</xsl:if>
											<xsl:if test="../../delivery_note !=''">
												<DeliveryNoteReferences>
													<DeliveryNoteReference>
														<xsl:value-of select="../../delivery_note"/>
													</DeliveryNoteReference>
													<DeliveryNoteDate>
														<xsl:value-of select="../../delivery_date"/>
													</DeliveryNoteDate>
												</DeliveryNoteReferences>
											</xsl:if>	
											<ProductID>
												<SuppliersProductCode>
													<xsl:value-of select="product_code"/>
												</SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:value-of select="product_desc"/>
											</ProductDescription>
											<CreditedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="invoice_qty/@size"/></xsl:attribute>
												<xsl:value-of select="invoice_qty"/>
											</CreditedQuantity>
											<UnitValueExclVAT>
												<xsl:value-of select="format-number(item_price,'0.00')"/>
											</UnitValueExclVAT>
											<LineValueExclVAT>
												<xsl:value-of select="format-number(item_value,'0.00')"/>
											</LineValueExclVAT>
											<VATCode>
												<xsl:value-of select="VATDetails/VatCode"/>
											</VATCode>
											<VATRate>
												<xsl:value-of select="format-number(VATDetails/VatRate,'0.00')"/>
											</VATRate>
										</CreditNoteLine>
									</xsl:for-each>
								</CreditNoteDetail>
								<CreditNoteTrailer>
									<VATSubTotals>
										<xsl:for-each select="CreditTotals/VATRateTotals">
											<VATSubTotal>
												<xsl:attribute name="VATCode"><xsl:value-of select="VATDetails/VATCode"/></xsl:attribute>
												<xsl:attribute name="VATRate"><xsl:value-of select="VATDetails/VATRate"/></xsl:attribute>
												<DocumentTotalExclVATAtRate>
													<xsl:value-of select="format-number(TaxableAmount,'0.00')"/>
												</DocumentTotalExclVATAtRate>
												<VATAmountAtRate>
													<xsl:value-of select="format-number(VATPayable,'0.00')"/>
												</VATAmountAtRate>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(CreditTotals/CreditNoteSubTotal,'0.00')"/>
									</DocumentTotalExclVAT>
									<VATAmount>
										<xsl:value-of select="format-number(CreditTotals/VATTotal,'0.00')"/>
									</VATAmount>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(CreditTotals/CreditTotal,'0.00')"/>
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
