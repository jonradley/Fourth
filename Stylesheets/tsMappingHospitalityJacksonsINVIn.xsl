<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-10-19		| 4958 Created Module
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
										<!-- BuyersNameAndAddress -===========================================-->
										<!-- the first line of INVOICE_TO_ADDRESS (from the input document) contains the buyers name -->
										<!-- the second line of INVOICE_TO_ADDRESS contains the first actual address line -->
										<!-- the last line of INVOICE_TO_ADDRESS contains the post code (we assume) -->
										<xsl:variable name="numberOfLines">
											<xsl:call-template name="countLinesInText">
												<xsl:with-param name="text" select="INVOICE_TO_ADDRESS" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$numberOfLines &gt;= 1">
											<BuyersName>
												<xsl:call-template name="outputLineFromText">
													<xsl:with-param name="text" select="INVOICE_TO_ADDRESS" />
													<xsl:with-param name="requestedLine" select="1" />
												</xsl:call-template>
											</BuyersName>
										</xsl:if>
										<xsl:if test="$numberOfLines &gt;= 2">
											<BuyersAddress>
												<xsl:call-template name="createAddressNodes">
													<xsl:with-param name="text" select="INVOICE_TO_ADDRESS" />
													<xsl:with-param name="numberOfLines" select="$numberOfLines" />
												</xsl:call-template>
											</BuyersAddress>
										</xsl:if>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="ACCOUNT_NO_1"/></SuppliersCode>
										</ShipToLocationID>
										<!-- ShipToNameAndAddress -===========================================-->
										<!-- the first line of DELIVER_TO_ADDRESS (from the input document) contains the 'ShipTo' name -->
										<!-- the second line of DELIVER_TO_ADDRESS contains the first actual address line -->
										<!-- the last line of DELIVER_TO_ADDRESS contains the post code (we assume) -->
										<xsl:variable name="ShipToAddress_numberOfLines">
											<xsl:call-template name="countLinesInText">
												<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$ShipToAddress_numberOfLines &gt;= 1">
											<ShipToName>
												<xsl:call-template name="outputLineFromText">
													<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
													<xsl:with-param name="requestedLine" select="1" />
												</xsl:call-template>
											</ShipToName>
										</xsl:if>
										<xsl:if test="$ShipToAddress_numberOfLines &gt;= 2">
											<ShipToAddress>
												<xsl:call-template name="createAddressNodes">
													<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
													<xsl:with-param name="numberOfLines" select="$ShipToAddress_numberOfLines" />
												</xsl:call-template>
											</ShipToAddress>
										</xsl:if>
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
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="PRODUCT_CODE"/></SuppliersProductCode>
											</ProductID>
											<ProductDescription><xsl:value-of select="DESCRIPTION"/></ProductDescription>
											<OrderedQuantity>
												<xsl:call-template name="jacksonsUoMLookup"/>
												<xsl:value-of select="format-number(QTY_ORD,'#')"/>
											</OrderedQuantity>
											<xsl:if test="QTY_DEL != ''">
												<DeliveredQuantity>
													<xsl:call-template name="jacksonsUoMLookup"/>
													<xsl:value-of select="format-number(QTY_DEL,'#')"/>
												</DeliveredQuantity>
												<InvoicedQuantity>
													<xsl:call-template name="jacksonsUoMLookup"/>
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