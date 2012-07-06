<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-10-19		| 4958 Created Module
**********************************************************************
H Robson	| 2011-12-02		| 4958 Jacksons changed address format
**********************************************************************
S Bowers	| 2012-04-11		| 5402 Jacksons Credit Note alteration with Fullers
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
										<!--| 2012-04-11		| 5402 Jacksons Credit Note alteration with Fullers-->
											<InvoiceReference><xsl:value-of select="INVOICEREFNO"/></InvoiceReference>
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
											<!--| 2012-04-11		| 5402 Jacksons Credit Note alteration with Fullers-->
											<PurchaseOrderReferences>
												<PurchaseOrderReference><xsl:value-of select="../YOUR_ORDER_NUMBER"/></PurchaseOrderReference>
												<PurchaseOrderDate><xsl:call-template name="jacksonsDateToInternal">
												<xsl:with-param name="inputDate" select="../CREDIT_DATE"/>
											</xsl:call-template>
											</PurchaseOrderDate>
											</PurchaseOrderReferences>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="PRODUCT_CODE"/></SuppliersProductCode>
											</ProductID>
											<xsl:if test="DESCRIPTION != ''">
												<ProductDescription><xsl:value-of select="DESCRIPTION"/></ProductDescription>
											</xsl:if>
											<OrderedQuantity>
												<xsl:call-template name="jacksonsUoMLookup">
													<xsl:with-param name="PER" select="PER"/>
												</xsl:call-template>
												<xsl:value-of select="format-number(QTY_ORD,'#')"/>
											</OrderedQuantity>
											<xsl:if test="QTY_DEL != ''">
												<CreditedQuantity>
													<xsl:call-template name="jacksonsUoMLookup">
														<xsl:with-param name="PER" select="PER"/>
													</xsl:call-template>
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