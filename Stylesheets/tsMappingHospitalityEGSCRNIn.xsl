<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
27/06/2012| KOshaughnessy	| Created FB5542
************************************************************************
05/06/2012|KOshaughnessy	| FB 5562 - bugfix to PO reference
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">
	<xsl:output method="xml"/>
	<xsl:template match="Batch">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:for-each select="Invoice">
							<CreditNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="Delivery/DeliverTo/Location"/>
									</SendersCodeForRecipient>
								</TradeSimpleHeader>
								<CreditNoteHeader>
									<!--Always Original-->
									<DocumentStatus>
										<xsl:text>Original</xsl:text>
									</DocumentStatus>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode>
												<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
											</SuppliersCode>
										</BuyersLocationID>
										<xsl:if test="Buyer/Party !=''">
											<BuyersName>
												<xsl:value-of select="Buyer/Party"/>
											</BuyersName>
										</xsl:if>
										<xsl:if test="Buyer/Address/AddressLine[1] != '' ">
											<BuyersAddress>
												<xsl:if test="Buyer/Address/AddressLine[1] != ''">
													<AddressLine1>
														<xsl:value-of select="Buyer/Address/AddressLine[1]"/>
													</AddressLine1>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[2] != ''">
													<AddressLine2>
														<xsl:value-of select="Buyer/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[3] != ''">
													<AddressLine3>
														<xsl:value-of select="Buyer/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="Buyer/Address/AddressLine[4] != ''">
													<AddressLine4>
														<xsl:value-of select="Buyer/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<xsl:if test="Buyer/Address/PostCode !='' ">
													<PostCode>
														<xsl:value-of select="Buyer/Address/PostCode"/>
													</PostCode>
												</xsl:if>
											</BuyersAddress>
										</xsl:if>
									</Buyer>
									<Supplier>
										<SuppliersLocationID>
											<SuppliersCode>
												<xsl:value-of select="Supplier/SupplierReferences/BuyersCodeForSupplier"/>
											</SuppliersCode>
										</SuppliersLocationID>
										<SuppliersName>
											<xsl:value-of select="Supplier/Party"/>
										</SuppliersName>
										<xsl:if test="Supplier/Address/AddressLine[1] !='' ">
											<SuppliersAddress>
												<AddressLine1>
													<xsl:value-of select="Supplier/Address/AddressLine[1]"/>
												</AddressLine1>
												<xsl:if test="Supplier/Address/AddressLine[2] !='' ">
													<AddressLine2>
														<xsl:value-of select="Supplier/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="Supplier/Address/AddressLine[3] !='' ">
													<AddressLine3>
														<xsl:value-of select="Supplier/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="Supplier/Address/AddressLine[4] !='' ">
													<AddressLine4>
														<xsl:value-of select="Supplier/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<PostCode>
													<xsl:value-of select="Supplier/Address/PostCode"/>
												</PostCode>
											</SuppliersAddress>
										</xsl:if>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="Delivery/DeliverTo/Location"/>
											</SuppliersCode>
										</ShipToLocationID>
										<xsl:if test="Delivery/DeliverTo/Party !='' ">
											<ShipToName>
												<xsl:value-of select="Delivery/DeliverTo/Party"/>
											</ShipToName>
										</xsl:if>
										<xsl:if test="Delivery/DeliverTo/Address/AddressLine[1] !='' ">
											<ShipToAddress>
												<AddressLine1>
													<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[1]"/>
												</AddressLine1>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[2] !='' ">
													<AddressLine2>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[3] !='' ">
													<AddressLine3>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/AddressLine[4] !='' ">
													<AddressLine4>
														<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<xsl:if test="Delivery/DeliverTo/Address/PostCode !='' ">
													<PostCode>
														<xsl:value-of select="Delivery/DeliverTo/Address/PostCode"/>
													</PostCode>
												</xsl:if>
											</ShipToAddress>
										</xsl:if>
									</ShipTo>
									<xsl:if test="Extensions/egs:Extension/egs:Extrinsic[@name = 'OriginalInvoiceNumber'] !='' ">
										<InvoiceReferences>
											<InvoiceReference>
												<xsl:value-of select="Extensions/egs:Extension/egs:Extrinsic[@name = 'OriginalInvoiceNumber']"/>
											</InvoiceReference>
											<InvoiceDate>
												<xsl:choose>
													<xsl:when test="Extensions/egs:Extension/egs:Extrinsic[@name = 'OriginalInvoiceDate'] ">
														<xsl:value-of select="substring-before(Extensions/egs:Extension/egs:Extrinsic[@name = 'OriginalInvoiceDate'],'T')"/>
													</xsl:when>
													<xsl:when test="InvoiceReferences/DeliveryNoteNumber ='' ">
														<xsl:value-of select="substring-before(InvoiceReferences/DeliveryNoteNumber,'T')"/>
													</xsl:when>
													<xsl:when test="InvoiceLineReferenes/OriginaOrderDate">
														<xsl:value-of select="substring-before(InvoiceLineReferenes/OriginaOrderDate,'T')"/>
													</xsl:when>
													<xsl:when test="InvoiceDate">
														<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
													</xsl:when>
												</xsl:choose>
											</InvoiceDate>
										</InvoiceReferences>
									</xsl:if>
									<CreditNoteReferences>
										<CreditNoteReference>
											<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
										</CreditNoteReference>
										<CreditNoteDate>
											<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
										</CreditNoteDate>
										<TaxPointDate>
											<xsl:choose>
												<xsl:when test="TaxPointDate !='' ">
													<xsl:value-of select="substring-before(TaxPointDate,'T')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
												</xsl:otherwise>
											</xsl:choose>
										</TaxPointDate>
									</CreditNoteReferences>
								</CreditNoteHeader>
								<!--***********************************************************************************************************************************************************************************************************************************-->
								<!--credit note details-->
								<CreditNoteDetail>
									<xsl:if test="not(InvoiceLine)">
										<CreditNoteLine>
											<ProductID>
												<SuppliersProductCode>No lines on Credit Note</SuppliersProductCode>
											</ProductID>
											<ProductDescription>No lines on Credit Note</ProductDescription>
											<InvoicedQuantity>0</InvoicedQuantity>
											<UnitValueExclVAT>0</UnitValueExclVAT>
											<LineValueExclVAT>0</LineValueExclVAT>
											<VATCode>No lines on Credit Note</VATCode>
											<VATRate>0</VATRate>
										</CreditNoteLine>
									</xsl:if>
									<!--This is to filter out any lines that do not have a product code and the line value is 0 -->
									<xsl:for-each select="InvoiceLine[Product/SuppliersProductCode !='' and NetLineTotal &gt;= 0]">
										<xsl:variable name="VATCode">
											<xsl:choose>
												<xsl:when test="LineTax/TaxRate/@Code = 'S'">
													<xsl:value-of select="LineTax/TaxRate/@Code"/>
												</xsl:when>
												<xsl:when test="LineTax/TaxRate/@Code = 'Z'">
													<xsl:value-of select="LineTax/TaxRate/@Code"/>
												</xsl:when>
												<xsl:when test="LineTax/TaxRate/@Code = 'P'">
													<xsl:value-of select="LineTax/TaxRate/@Code"/>
												</xsl:when>
												<xsl:when test="LineTax/TaxRate/@Code = 'E'">
													<xsl:value-of select="LineTax/TaxRate/@Code"/>
												</xsl:when>
												<xsl:when test="LineTax/TaxRate/@Code = ''">
													<xsl:text>Z</xsl:text>
												</xsl:when>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="VATRate">
											<xsl:choose>
												<xsl:when test="LineTax/TaxRate = ''">
													<xsl:text>0.00</xsl:text>
												</xsl:when>
												<xsl:when test="LineTax/TaxRate/@Code = ''">
													<xsl:text>0.00</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="LineTax/TaxRate"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="Product/SuppliersProductCode !='' and NetLineTotal &gt;= 0"/>
										</xsl:choose>
										<CreditNoteLine>
											<xsl:for-each select="../InvoiceReferences/BuyersOrderNumber[. != ''][1]">
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of select="."/>
													</PurchaseOrderReference>
													<PurchaseOrderDate>
														<xsl:choose>
															<xsl:when test="/InvoiceLineReferenes/OriginaOrderDate !=''">
																<xsl:value-of select="substring-before(../../InvoiceLineReferenes/OriginaOrderDate,'T')"/>
															</xsl:when>
															<xsl:when test="/Batch/Invoice/InvoiceDate !=''">
																<xsl:value-of select="substring-before(/Batch/Invoice/InvoiceDate,'T')"/>
															</xsl:when>
														</xsl:choose>
													</PurchaseOrderDate>
												</PurchaseOrderReferences>
											</xsl:for-each>
											<xsl:for-each select="../InvoiceReferences/DeliveryNoteNumber[. != ''][1]">
												<DeliveryNoteReferences>
													<DeliveryNoteReference>
														<xsl:value-of select="."/>
													</DeliveryNoteReference>
													<DeliveryNoteDate>
														<xsl:choose>
															<xsl:when test="../../Delivery/ActualDeliveryDate != '' ">
																<xsl:value-of select="substring-before(../../Delivery/ActualDeliveryDate,'T')"/>
															</xsl:when>
															<xsl:when test="/Batch/Invoice/InvoiceDate != '' ">
																<xsl:value-of select="substring-before(/Batch/Invoice/InvoiceDate,'T')"/>
															</xsl:when>
														</xsl:choose>
													</DeliveryNoteDate>
												</DeliveryNoteReferences>
											</xsl:for-each>
											<ProductID>
												<SuppliersProductCode>
													<xsl:value-of select="Product/SuppliersProductCode"/>
												</SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:value-of select="Product/Description"/>
											</ProductDescription>
											<CreditedQuantity>
												<xsl:value-of select="Quantity/Amount"/>
											</CreditedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="Quantity/UOMCode"/></xsl:attribute>
											<UnitValueExclVAT>
												<xsl:value-of select="Price/UnitPrice"/>
											</UnitValueExclVAT>
											<LineValueExclVAT>
												<xsl:value-of select="NetLineTotal"/>
											</LineValueExclVAT>
											<!--VATCode-->
											<VATCode>
												<xsl:value-of select="$VATCode"/>
											</VATCode>
											<!--VATRate-->
											<VATRate>
												<xsl:value-of select="$VATRate"/>
											</VATRate>
											<!--Reason for credit-->
											<xsl:choose>
												<xsl:when test="../Extensions/egs:Extension/egs:Extrinsic/@name = 'ReasonsForCredit'">
													<Narrative>
														<xsl:value-of select="../Extensions/egs:Extension/egs:Extrinsic[@name = 'ReasonsForCredit']"/>
													</Narrative>
												</xsl:when>
												<xsl:when test="../Extensions/egs:Extension[4] !=''">
													<Narrative>
														<xsl:value-of select="../Extensions/egs:Extension[4]"/>
													</Narrative>
												</xsl:when>
											</xsl:choose>
										</CreditNoteLine>
									</xsl:for-each>
								</CreditNoteDetail>
								<CreditNoteTrailer>
									<xsl:if test="TaxSubTotal">
										<VATSubTotals>
											<xsl:for-each select="TaxSubTotal">
												<!--To work out VAT code-->
												<xsl:variable name="TotalCode">
													<xsl:choose>
														<xsl:when test="TaxRate/@Code = 'S'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'Z'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'P'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = 'E'">
															<xsl:value-of select="TaxRate/@Code"/>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = ''">
															<xsl:text>Z</xsl:text>
														</xsl:when>
														<xsl:otherwise>Unrecognised VAT code:<xsl:value-of select="TaxRate/@Code"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<!--To work out VAT rates-->
												<xsl:variable name="TotalRate">
													<xsl:choose>
														<xsl:when test="TaxRate = ''">
															<xsl:text>0.00</xsl:text>
														</xsl:when>
														<xsl:when test="TaxRate/@Code = ''">
															<xsl:text>0.00</xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="TaxRate"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<!--This is to remove VAT subtrailors that contain VAT codes that do not match mapped line VAT codes-->
												<xsl:if test="../InvoiceLine[LineTax/TaxRate/@Code=$TotalCode and LineTax/TaxRate=$TotalRate][Product/SuppliersProductCode !='' and NetLineTotal = 0]">
													<VATSubTotal>
														<xsl:attribute name="VATCode"><xsl:value-of select="$TotalCode"/></xsl:attribute>
														<xsl:attribute name="VATRate"><xsl:value-of select="$TotalRate"/></xsl:attribute>
														<xsl:for-each select="TaxablTotalAtRate[. != ''][1]">
															<DiscountedLinesTotalExclVATAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DiscountedLinesTotalExclVATAtRate>
														</xsl:for-each>
														<xsl:for-each select="AmountDiscount/Amount[. != ''][1]">
															<DocumentDiscountAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DocumentDiscountAtRate>
														</xsl:for-each>
														<xsl:for-each select="TaxableValueAtRate[. != ''][1]">
															<DocumentTotalExclVATAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DocumentTotalExclVATAtRate>
														</xsl:for-each>
														<xsl:for-each select="TaxAtRate[. != ''][1]">
															<VATAmountAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</VATAmountAtRate>
														</xsl:for-each>
														<xsl:for-each select="GrossPaymentAtRate[. != ''][1]">
															<DocumentTotalInclVATAtRate>
																<xsl:value-of select="format-number(.,'0.00')"/>
															</DocumentTotalInclVATAtRate>
														</xsl:for-each>
													</VATSubTotal>
												</xsl:if>
											</xsl:for-each>
										</VATSubTotals>
									</xsl:if>
									<xsl:for-each select="InvoiceTotal/TaxableTotal[. != ''][1]">
										<DiscountedLinesTotalExclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DiscountedLinesTotalExclVAT>
									</xsl:for-each>
									<xsl:for-each select="AmountDiscount/Amount[. != ''][1]">
										<DocumentDiscount>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentDiscount>
									</xsl:for-each>
									<xsl:for-each select="InvoiceTotal/NetPaymentTotal[. != ''][1]">
										<DocumentTotalExclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentTotalExclVAT>
									</xsl:for-each>
									<xsl:for-each select="InvoiceTotal/TaxTotal[. != ''][1]">
										<VATAmount>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</VATAmount>
									</xsl:for-each>
									<xsl:for-each select="InvoiceTotal/GrossPaymentTotal[. != ''][1]">
										<DocumentTotalInclVAT>
											<xsl:value-of select="format-number(.,'0.00')"/>
										</DocumentTotalInclVAT>
									</xsl:for-each>
								</CreditNoteTrailer>
							</CreditNote>
						</xsl:for-each>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
