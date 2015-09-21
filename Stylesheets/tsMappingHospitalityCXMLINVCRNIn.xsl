<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date			| Change
**********************************************************************
J Miguel	| 14/10/2014	| 10051 - Staples - Setup and Mappers
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1" indent="yes"/>
	<xsl:template match="cXML">
		<xsl:apply-templates select="Request/InvoiceDetailRequest"/>
	</xsl:template>
	<!-- Process the invoice by creating the whole body and the tradesimple header -->
	<xsl:template match="InvoiceDetailRequest[InvoiceDetailRequestHeader/@purpose = 'standard']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="86">
						<Invoice>
							<xsl:call-template name="insertTradeSimpleHeaderData"/>
							<InvoiceHeader>
								<xsl:call-template name="insertHeaderData"/>
								<InvoiceReferences>
									<InvoiceReference>
										<xsl:value-of select="InvoiceDetailRequestHeader/@invoiceID"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
									</InvoiceDate>
									<xsl:if test="InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate">
										<TaxPointDate>
											<xsl:value-of select="substring-before(InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate, 'T')"/>
										</TaxPointDate>
									</xsl:if>
									<VATRegNo>
										<xsl:value-of select="InvoiceDetailRequestHeader/Extrinsic[@name='supplierVatID']"/>
									</VATRegNo>
									<xsl:if test="InvoiceDetailRequestHeader/Extrinsic[@name='buyerVatID']">
										<BuyersVATRegNo>
											<xsl:value-of select="InvoiceDetailRequestHeader/Extrinsic[@name='buyerVatID']"/>
										</BuyersVATRegNo>
									</xsl:if>
								</InvoiceReferences>
								<Currency>
									<xsl:value-of select="InvoiceDetailSummary/GrossAmount/Money/@currency"/>
								</Currency>
							</InvoiceHeader>
							<InvoiceDetail>
								<xsl:apply-templates select="InvoiceDetailOrder/InvoiceDetailItem" mode="invoice"/>
							</InvoiceDetail>
							<InvoiceTrailer>
								<xsl:apply-templates select="InvoiceDetailSummary"/>
							</InvoiceTrailer>
						</Invoice>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- Process the credit memos by creating the whole body and the tradesimple header -->
	<xsl:template match="InvoiceDetailRequest[InvoiceDetailRequestHeader/@purpose = 'creditMemo']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="87">
						<CreditNote>
							<xsl:call-template name="insertTradeSimpleHeaderData"/>
							<CreditNoteHeader>
								<xsl:call-template name="insertHeaderData"/>
								<InvoiceReferences>
									<InvoiceReference>
									<xsl:value-of select="InvoiceDetailRequestHeader/DocumentReference"/>
									</InvoiceReference>
									<InvoiceDate>
										<xsl:value-of select="substring-before(InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
									</InvoiceDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
									</TaxPointDate>									
								</InvoiceReferences>
								<CreditNoteReferences>
									<CreditNoteReference>
										<xsl:value-of select="InvoiceDetailRequestHeader/@invoiceID"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<xsl:value-of select="substring-before(InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
									</CreditNoteDate>
									<xsl:if test="InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate">
										<TaxPointDate>
											<xsl:value-of select="substring-before(InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate, 'T')"/>
										</TaxPointDate>
									</xsl:if>
									<VATRegNo>
										<xsl:value-of select="InvoiceDetailRequestHeader/Extrinsic[@name='supplierVatID']"/>
									</VATRegNo>
									<xsl:if test="InvoiceDetailRequestHeader/Extrinsic[@name='buyerVatID']">
										<BuyersVATRegNo>
											<xsl:value-of select="InvoiceDetailRequestHeader/Extrinsic[@name='buyerVatID']"/>
										</BuyersVATRegNo>
									</xsl:if>
								</CreditNoteReferences>
								<Currency>
									<xsl:value-of select="InvoiceDetailSummary/GrossAmount/Money/@currency"/>
								</Currency>
							</CreditNoteHeader>
							<CreditNoteDetail>
								<xsl:apply-templates select="InvoiceDetailOrder/InvoiceDetailItem" mode="credit"/>
							</CreditNoteDetail>
							<CreditNoteTrailer>
								<xsl:apply-templates select="InvoiceDetailSummary"/>
							</CreditNoteTrailer>
						</CreditNote>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- Process each invoice line -->
	<xsl:template match="InvoiceDetailItem" mode="invoice">
		<InvoiceLine>
			<LineNumber>
				<xsl:value-of select="@invoiceLineNumber"/>
			</LineNumber>
			<PurchaseOrderReferences>
				<xsl:for-each select="../InvoiceDetailOrderInfo/OrderReference">
					<PurchaseOrderReference>
						<xsl:value-of select="@orderID"/>
					</PurchaseOrderReference>
				</xsl:for-each>
				<PurchaseOrderDate>
					<xsl:value-of select="substring-before(../../InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:value-of select="../../InvoiceDetailRequestHeader/InvoiceDetailShipping/DocumentReference"/>
				</DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:value-of select="substring-before(../../InvoiceDetailRequestHeader/InvoiceDetailShipping/DocumentReference/@payloadID, 'T')"/>
				</DeliveryNoteDate>
			</DeliveryNoteReferences>			
			<ProductID>
				<!--<GTIN></GTIN>-->
				<SuppliersProductCode>
					<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>
				</SuppliersProductCode>
			</ProductID>
			<ProductDescription>
				<xsl:value-of select="InvoiceDetailItemReference/Description"/>
			</ProductDescription>
			<InvoicedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:text>EA</xsl:text></xsl:attribute>
				<xsl:value-of select="@quantity"/>
			</InvoicedQuantity>
			<UnitValueExclVAT>
				<xsl:value-of select="UnitPrice/Money"/>
			</UnitValueExclVAT>
			<LineValueExclVAT>
				<xsl:value-of select="SubtotalAmount/Money"/>
			</LineValueExclVAT>
			<VATCode>
				<xsl:choose>
					<xsl:when test="Tax/TaxDetail/@category='GBSTD20'">S</xsl:when>
					<xsl:otherwise>Z</xsl:otherwise>
				</xsl:choose>
			</VATCode>
			<VATRate>
				<xsl:value-of select="format-number(Tax/TaxDetail/@percentageRate, '00.00')"/>
			</VATRate>
		</InvoiceLine>
	</xsl:template>
	<!-- Process each invoice line -->
	<xsl:template match="InvoiceDetailItem" mode="credit">
		<CreditNoteLine>
			<LineNumber>
				<xsl:value-of select="@invoiceLineNumber"/>
			</LineNumber>
			<PurchaseOrderReferences>
				<xsl:for-each select="../InvoiceDetailOrderInfo/OrderReference">
					<PurchaseOrderReference>
						<xsl:value-of select="@orderID"/>
					</PurchaseOrderReference>
				</xsl:for-each>
				<PurchaseOrderDate>
					<xsl:value-of select="substring-before(../../InvoiceDetailRequestHeader/@invoiceDate, 'T')"/>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			<ProductID>
				<!--<GTIN></GTIN>-->
				<SuppliersProductCode>
					<xsl:value-of select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>
				</SuppliersProductCode>
			</ProductID>
			<ProductDescription>
				<xsl:value-of select="InvoiceDetailItemReference/Description"/>
			</ProductDescription>
			<CreditedQuantity>
				<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
				<xsl:value-of select="- number(@quantity)"/>
			</CreditedQuantity>
			<UnitValueExclVAT>
				<xsl:value-of select="UnitPrice/Money"/>
			</UnitValueExclVAT>
			<LineValueExclVAT>
				<xsl:value-of select="SubtotalAmount/Money"/>
			</LineValueExclVAT>
			<VATCode>
				<xsl:choose>
					<xsl:when test="Tax/TaxDetail/@category='GBSTD20'">S</xsl:when>
					<xsl:otherwise>Z</xsl:otherwise>
				</xsl:choose>
			</VATCode>
			<VATRate>
				<xsl:value-of select="format-number(Tax/TaxDetail/@percentageRate, '00.00')"/>
			</VATRate>
		</CreditNoteLine>
	</xsl:template>
	<!-- Process the footer of the invoice -->
	<xsl:template match="InvoiceDetailSummary">
		<VATSubTotals>
			<xsl:apply-templates select="Tax"/>
		</VATSubTotals>
	</xsl:template>
	<!-- Process the totals -->
	<xsl:template match="InvoiceDetailSummary">
		<DocumentTotalExclVAT>
			<xsl:value-of select="translate(SubtotalAmount/Money, '-', '')"/>
		</DocumentTotalExclVAT>
		<SettlementTotalExclVAT>
			<xsl:value-of select="translate(SubtotalAmount/Money, '-', '')"/>
		</SettlementTotalExclVAT>
		<VATAmount>
			<xsl:value-of select="Tax/Money"/>
		</VATAmount>
		<DocumentTotalInclVAT>
			<xsl:value-of select="translate(GrossAmount/Money, '-', '')"/>
		</DocumentTotalInclVAT>
		<SettlementTotalInclVAT>
			<xsl:value-of select="translate(DueAmount/Money, '-', '')"/>
		</SettlementTotalInclVAT>
	</xsl:template>
	<!-- Process the taxes -->
	<xsl:template match="Tax">
		<xsl:for-each select="/Transaction/TaxSummary/Tax">
			<VATSubTotal>
			</VATSubTotal>
		</xsl:for-each>
	</xsl:template>
	<!-- helper templates - common to both types of docs-->
	<xsl:template name="insertTradeSimpleHeaderData">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role='shipTo']/@addressID"/>
			</SendersCodeForRecipient>
			<TestFlag>
				<xsl:choose>
					<xsl:when test="@deploymentMode='production'">0</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</TestFlag>
		</TradeSimpleHeader>
	</xsl:template>
	<xsl:template name="insertHeaderData">
		<Buyer>
			<BuyersLocationID>
				<SuppliersCode>
					<xsl:value-of select="../../Header/To/Credential/Identity"/>
				</SuppliersCode>
			</BuyersLocationID>
		</Buyer>
		<Supplier>
			<SuppliersLocationID>
				<BuyersCode>
					<xsl:value-of select="../../Header/From/Credential/Identity"/>
				</BuyersCode>
			</SuppliersLocationID>
		</Supplier>
		<ShipTo>
			<ShipToLocationID>
				<SuppliersCode>
					<xsl:value-of select="InvoiceDetailRequestHeader/InvoiceDetailShipping/Contact[@role='shipTo']/@addressID"/>
				</SuppliersCode>
			</ShipToLocationID>
		</ShipTo>
	</xsl:template>
</xsl:stylesheet>
