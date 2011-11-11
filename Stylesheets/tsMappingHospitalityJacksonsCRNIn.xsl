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
					<xsl:for-each select="CREDIT">
						<BatchDocument DocumentTypeNo="87">
							<CreditNote>
								<!-- TradeSimpleHeader -======================================================-->
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="ACCOUNT_NO_1"/></SendersCodeForRecipient>
								</TradeSimpleHeader>

								<CreditNoteHeader>
									<Buyer>
										<xsl:variable name="numberOfLines_creditto">
											<xsl:call-template name="countLinesInText">
												<xsl:with-param name="text" select="CREDIT_TO_ADDRESS" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$numberOfLines_creditto &gt;= 1">
											<BuyersName>
												<xsl:call-template name="outputLineFromText">
													<xsl:with-param name="text" select="CREDIT_TO_ADDRESS" />
													<xsl:with-param name="requestedLine" select="1" />
												</xsl:call-template>
											</BuyersName>
										</xsl:if>
										<xsl:if test="$numberOfLines_creditto &gt;= 2">
											<BuyersAddress>
												<xsl:call-template name="createAddressNodes">
													<xsl:with-param name="text" select="CREDIT_TO_ADDRESS" />
													<xsl:with-param name="numberOfLines" select="$numberOfLines_creditto" />
													<xsl:with-param name="suppressPostCode" select="true()" />
												</xsl:call-template>
												<xsl:if test="CREDIT_TO_POSTCODE != ''">
													<PostCode><xsl:value-of select="CREDIT_TO_POSTCODE"/></PostCode>
												</xsl:if>
											</BuyersAddress>
										</xsl:if>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="ACCOUNT_NO_1"/></SuppliersCode>
										</ShipToLocationID>
										<xsl:variable name="numberOfLines_deliverto">
											<xsl:call-template name="countLinesInText">
												<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="$numberOfLines_deliverto &gt;= 1">
											<ShipToName>
												<xsl:call-template name="outputLineFromText">
													<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
													<xsl:with-param name="requestedLine" select="1" />
												</xsl:call-template>
											</ShipToName>
										</xsl:if>
										<xsl:if test="$numberOfLines_deliverto &gt;= 2">
											<ShipToAddress>
												<xsl:call-template name="createAddressNodes">
													<xsl:with-param name="text" select="DELIVER_TO_ADDRESS" />
													<xsl:with-param name="numberOfLines" select="$numberOfLines_deliverto" />
												</xsl:call-template>
											</ShipToAddress>
										</xsl:if>
									</ShipTo>
									
									<InvoiceReferences>
										<xsl:if test="translate(YOUR_ORDER_NUMBER,'RE.INV ',' ') != ''">
											<InvoiceReference><xsl:value-of select="translate(YOUR_ORDER_NUMBER,'RE.INV ',' ')"/></InvoiceReference>
										</xsl:if>
										<!-- for now we will just use the credit note date but need to ask Jacksons for real invoice dates -->
										<InvoiceDate>
											<xsl:call-template name="jacksonsDateToInternal">
												<xsl:with-param name="inputDate" select="CREDIT_DATE"/>
											</xsl:call-template>
										</InvoiceDate>
										<!--<TaxPointDate/>-->
									</InvoiceReferences>
									<CreditNoteReferences>
										<CreditNoteReference><xsl:value-of select="CREDIT_NO"/></CreditNoteReference>
										<CreditNoteDate>
											<xsl:call-template name="jacksonsDateToInternal">
												<xsl:with-param name="inputDate" select="CREDIT_DATE"/>
											</xsl:call-template>
										</CreditNoteDate>
										<TaxPointDate>
											<xsl:call-template name="jacksonsDateToInternal">
												<xsl:with-param name="inputDate" select="CREDIT_DATE"/>
											</xsl:call-template>
										</TaxPointDate>
										<!--
										<VATRegNo/>-->
									</CreditNoteReferences>
								</CreditNoteHeader>
								
								
								<CreditNoteDetail>
									<xsl:for-each select="LINE[PRODUCT_CODE != ''][QTY_ORD != ''][LIST_PRICE != ''][VC != '']">
										<CreditNoteLine>
											<LineNumber><xsl:value-of select="position()"/></LineNumber>
											<PurchaseOrderReferences>
												<PurchaseOrderReference>test</PurchaseOrderReference>
												<PurchaseOrderDate>2011-10-21</PurchaseOrderDate>
											</PurchaseOrderReferences>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="PRODUCT_CODE"/></SuppliersProductCode>
											</ProductID>
											<xsl:if test="DESCRIPTION != ''">
												<ProductDescription><xsl:value-of select="DESCRIPTION"/></ProductDescription>
											</xsl:if>
											<OrderedQuantity>
												<xsl:call-template name="jacksonsUoMLookup"/>
												<xsl:value-of select="format-number(QTY_ORD,'#')"/>
											</OrderedQuantity>
											<xsl:if test="QTY_DEL != ''">
												<CreditedQuantity>
													<xsl:call-template name="jacksonsUoMLookup"/>
													<xsl:value-of select="format-number(QTY_DEL,'#')"/>
												</CreditedQuantity>
											</xsl:if>
											<UnitValueExclVAT><xsl:value-of select="format-number(LIST_PRICE,'0.00')"/></UnitValueExclVAT>
											<xsl:if test="NETT_VALUE != ''">
												<LineValueExclVAT><xsl:value-of select="format-number(NETT_VALUE,'0.00')"/></LineValueExclVAT>
											</xsl:if>
											<xsl:if test="DISCOUNT != ''">
												<LineDiscountRate><xsl:value-of select="format-number(translate(DISCOUNT,'- %',''),'0.00')"/></LineDiscountRate>
											</xsl:if>
											<VATCode>
												<xsl:call-template name="jacksonsVatCodeLookup">
													<xsl:with-param name="vatCode" select="VC"/>
												</xsl:call-template>
											</VATCode>
											<LineExtraData>
												<SuppliersOriginalVATCode><xsl:value-of select="VC"/></SuppliersOriginalVATCode>
											</LineExtraData>
										</CreditNoteLine>
									</xsl:for-each>
								</CreditNoteDetail>
								
								
								<!-- CreditNoteTrailer -===============================================-->
								<CreditNoteTrailer>
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
												<VATAmountAtRate><xsl:value-of select="format-number(VAT_AMOUNT,'0.00')" /></VATAmountAtRate>
												<VATTrailerExtraData>	
													<SuppliersOriginalVATCode><xsl:value-of select="VCE" /></SuppliersOriginalVATCode>
												</VATTrailerExtraData>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<DocumentTotalExclVAT><xsl:value-of select="format-number(TOTAL_VALUE,'0.00')" /></DocumentTotalExclVAT>
									<SettlementTotalExclVAT><xsl:value-of select="format-number(TOTAL_VALUE,'0.00')" /></SettlementTotalExclVAT>
									<VATAmount><xsl:value-of select="format-number(TOTAL_VAT,'0.00')" /></VATAmount>
									<DocumentTotalInclVAT><xsl:value-of select="format-number(TOTAL_DUE,'0.00')" /></DocumentTotalInclVAT>
									<SettlementTotalInclVAT><xsl:value-of select="format-number(TOTAL_DUE,'0.00')" /></SettlementTotalInclVAT>
								</CreditNoteTrailer>
							</CreditNote>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>	
</xsl:stylesheet>