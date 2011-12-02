<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-10-19		| 4958 Created Module
**********************************************************************
H Robson	| 2011-12-02		| 4958 Jacksons changed address format
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="tsMappingHospitalityJacksonsIncludes.xsl"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="DOCUMENT">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="INVOICE">
						<BatchDocument DocumentTypeNo="86">
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<!-- Jacksons also supply an ACCOUNT_NO_2 for what reason I do not know -->
										<xsl:value-of select="ACCOUNT_NO_1"/>
									</SendersCodeForRecipient>
								</TradeSimpleHeader>
								<InvoiceHeader>
									<Buyer>
										<BuyersName><xsl:value-of select="INVOICE_TO_NAME"/></BuyersName>
										<BuyersAddress>
											<xsl:if test="INVOICE_TO_ADDRESS_LINE1 != ''"><AddressLine1><xsl:value-of select="INVOICE_TO_ADDRESS_LINE1"/></AddressLine1></xsl:if>
											<xsl:if test="INVOICE_TO_ADDRESS_LINE2 != ''"><AddressLine2><xsl:value-of select="INVOICE_TO_ADDRESS_LINE2"/></AddressLine2></xsl:if>
											<xsl:if test="INVOICE_TO_ADDRESS_LINE3 != ''"><AddressLine3><xsl:value-of select="INVOICE_TO_ADDRESS_LINE3"/></AddressLine3></xsl:if>
											<xsl:if test="INVOICE_TO_ADDRESS_LINE4 != ''"><AddressLine4><xsl:value-of select="INVOICE_TO_ADDRESS_LINE4"/></AddressLine4></xsl:if>
											<xsl:if test="INVOICE_TO_ADDRESS_POSTCODE != ''"><PostCode><xsl:value-of select="INVOICE_TO_ADDRESS_POSTCODE"/></PostCode></xsl:if>
										</BuyersAddress>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="ACCOUNT_NO_1"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="DELIVER_TO_NAME"/></ShipToName>
										<ShipToAddress>
											<xsl:if test="DELIVER_TO_ADDRESS_LINE1 != ''"><AddressLine1><xsl:value-of select="DELIVER_TO_ADDRESS_LINE1"/></AddressLine1></xsl:if>
											<xsl:if test="DELIVER_TO_ADDRESS_LINE2 != ''"><AddressLine2><xsl:value-of select="DELIVER_TO_ADDRESS_LINE2"/></AddressLine2></xsl:if>
											<xsl:if test="DELIVER_TO_ADDRESS_LINE3 != ''"><AddressLine3><xsl:value-of select="DELIVER_TO_ADDRESS_LINE3"/></AddressLine3></xsl:if>
											<xsl:if test="DELIVER_TO_ADDRESS_LINE4 != ''"><AddressLine4><xsl:value-of select="DELIVER_TO_ADDRESS_LINE4"/></AddressLine4></xsl:if>
											<xsl:if test="DELIVER_TO_ADDRESS_POSTCODE != ''"><PostCode><xsl:value-of select="DELIVER_TO_ADDRESS_POSTCODE"/></PostCode></xsl:if>
										</ShipToAddress>
									</ShipTo>
									<InvoiceReferences>
										<InvoiceReference><xsl:value-of select="INVOICE_NO"/></InvoiceReference>
										<InvoiceDate>
											<xsl:call-template name="jacksonsDateToInternal">
												<xsl:with-param name="inputDate" select="INVOICE_DATE"/>
											</xsl:call-template>
										</InvoiceDate>
									</InvoiceReferences>
								</InvoiceHeader>
								
								<!-- InvoiceDetail section -->
								<InvoiceDetail>
									<xsl:for-each select="LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC != '']">
										<InvoiceLine>
											<LineNumber><xsl:value-of select="position()"/></LineNumber>
											<PurchaseOrderReferences>
												<PurchaseOrderReference><xsl:value-of select="../YOUR_ORDER_NUMBER"/></PurchaseOrderReference>
											</PurchaseOrderReferences>
											<DeliveryNoteReferences>
												<DeliveryNoteReference><xsl:value-of select="../OUR_ORDER_NO"/></DeliveryNoteReference>
												<DeliveryNoteDate>
													<xsl:call-template name="jacksonsDateToInternal">
														<xsl:with-param name="inputDate" select="../DATE_DESPATCHED"/>
													</xsl:call-template>
												</DeliveryNoteDate>
												<DespatchDate>
													<xsl:call-template name="jacksonsDateToInternal">
														<xsl:with-param name="inputDate" select="../DATE_DESPATCHED"/>
													</xsl:call-template>
												</DespatchDate>
											</DeliveryNoteReferences>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="PRODUCT_CODE"/></SuppliersProductCode>
											</ProductID>
											<ProductDescription><xsl:value-of select="DESCRIPTION"/></ProductDescription>
											<OrderedQuantity>
												<xsl:call-template name="jacksonsUoMLookup">
													<xsl:with-param name="PER" select="PER"/>
												</xsl:call-template>
												<xsl:value-of select="format-number(QTY_ORD,'#')"/>
											</OrderedQuantity>
											<xsl:if test="QTY_DEL != ''">
												<DeliveredQuantity>
													<xsl:call-template name="jacksonsUoMLookup">
														<xsl:with-param name="PER" select="PER"/>
													</xsl:call-template>
													<xsl:value-of select="format-number(QTY_DEL,'#')"/>
												</DeliveredQuantity>
												<InvoicedQuantity>
													<xsl:call-template name="jacksonsUoMLookup">
														<xsl:with-param name="PER" select="PER"/>
													</xsl:call-template>
													<xsl:value-of select="format-number(QTY_DEL,'#')"/>
												</InvoicedQuantity>
											</xsl:if>
											<UnitValueExclVAT><xsl:value-of select="format-number(LIST_PRICE,'#.00')"/></UnitValueExclVAT>
											<xsl:if test="NETT_VALUE != ''">
												<LineValueExclVAT><xsl:value-of select="format-number(NETT_VALUE,'#.00')"/></LineValueExclVAT>
											</xsl:if>
											<xsl:if test="DISCOUNT != ''">
												<LineDiscountRate><xsl:value-of select="format-number(DISCOUNT,'#.00')"/></LineDiscountRate>
											</xsl:if>
											<!-- discount value needs attention -->
											<xsl:if test="DISCOUNT != ''">
												<LineDiscountValue><xsl:value-of select="format-number(DISCOUNT,'#.00')"/></LineDiscountValue>
											</xsl:if>
											<VATCode>
												<xsl:call-template name="jacksonsVatCodeLookup">
													<xsl:with-param name="vatCode" select="VC"/>
												</xsl:call-template>
											</VATCode>
										</InvoiceLine>
									</xsl:for-each>
								</InvoiceDetail>
								
								<InvoiceTrailer>
									<NumberOfLines><xsl:value-of select="count(LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC != ''])"/></NumberOfLines>
									<NumberOfItems><xsl:value-of select="sum(LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC != '']/QTY_DEL)"/></NumberOfItems>
									<VATSubTotals>
										<xsl:for-each select="VAT_CODE_LINE[VCE != ''][VAT_RATE != ''][GOODS_AMOUNT != '']">
											<VATSubTotal VATRate="{format-number(VAT_RATE,'#.##')}">
												<xsl:attribute name="VATCode">
													<xsl:call-template name="jacksonsVatCodeLookup">
														<xsl:with-param name="vatCode" select="VCE"/>
													</xsl:call-template>
												</xsl:attribute>
												<NumberOfLinesAtRate>
													<xsl:value-of select="count(../LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC = current()/VCE])"/>
												</NumberOfLinesAtRate>
												<NumberOfItemsAtRate>
													<xsl:value-of select="sum(../LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC = current()/VCE]/QTY_DEL)"/>
												</NumberOfItemsAtRate>
												<!-- -->
												<VATAmountAtRate><xsl:value-of select="format-number(VAT_AMOUNT,'#.00')" /></VATAmountAtRate>
												<VATTrailerExtraData>	
													<SuppliersOriginalVATCode><xsl:value-of select="VCE" /></SuppliersOriginalVATCode>
												</VATTrailerExtraData>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<!-- 
									<DiscountedLinesTotalExclVAT/>
									<DocumentDiscount/>-->
									<DocumentTotalExclVAT><xsl:value-of select="format-number(TOTAL_VALUE,'#.00')" /></DocumentTotalExclVAT>
									<!--
									<SettlementDiscount/>
									-->
									<SettlementTotalExclVAT><xsl:value-of select="format-number(TOTAL_VALUE,'#.00')" /></SettlementTotalExclVAT>
									<VATAmount><xsl:value-of select="format-number(TOTAL_VAT,'#.00')" /></VATAmount>
									<DocumentTotalInclVAT><xsl:value-of select="format-number(TOTAL_DUE,'#.00')" /></DocumentTotalInclVAT>
									<SettlementTotalInclVAT><xsl:value-of select="format-number(TOTAL_DUE,'#.00')" /></SettlementTotalInclVAT>
								</InvoiceTrailer>
							</Invoice>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>