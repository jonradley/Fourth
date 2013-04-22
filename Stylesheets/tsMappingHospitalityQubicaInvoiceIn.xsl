<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
							<!--xsl:copy-of select="."/-->
								<Invoice>
									<TradeSimpleHeader>
										<SendersCodeForRecipient>
											<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
										</SendersCodeForRecipient>
										<xsl:if test="TradeSimpleHeader/SendersBranchReference != ''">
											<SendersBranchReference>
												<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
											</SendersBranchReference>
										</xsl:if>
										<xsl:if test="TradeSimpleHeader/TestFlag != ''">
											<TestFlag>
												<xsl:choose>
													<xsl:when test="TradeSimpleHeader/TestFlag = 'Y'">true</xsl:when>
													<xsl:when test="TradeSimpleHeader/TestFlag = 'y'">true</xsl:when>
													<xsl:when test="TradeSimpleHeader/TestFlag = '1'">true</xsl:when>
													<xsl:when test="TradeSimpleHeader/TestFlag = 'True'">true</xsl:when>
													<xsl:when test="TradeSimpleHeader/TestFlag = 'TRUE'">true</xsl:when>
													<xsl:otherwise>false</xsl:otherwise>
												</xsl:choose>
											</TestFlag>
										</xsl:if>
									</TradeSimpleHeader>
									<InvoiceHeader>
										<DocumentStatus>Original</DocumentStatus>
										<Buyer>
											<BuyersLocationID>
												<GLN>
													<xsl:text>5555555555555</xsl:text>
												</GLN>
											</BuyersLocationID>
										</Buyer>
										<Supplier>
											<SuppliersLocationID>
												<GLN>
													<xsl:text>5555555555555</xsl:text>
												</GLN>
											</SuppliersLocationID>
										</Supplier>
										<ShipTo>
											<ShipToLocationID>
												<GLN>
													<xsl:text>5555555555555</xsl:text>
												</GLN>
											</ShipToLocationID>
									<!--		
											<ShipToAddress>
												<AddressLine1>xx</AddressLine1>
											</ShipToAddress>  
									-->		
										</ShipTo>

										<InvoiceReferences>
											<InvoiceReference>
												<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
											</InvoiceReference>
											<xsl:variable name="sInvDate">
												<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
											</xsl:variable>
											<InvoiceDate>
												<xsl:value-of select="concat(substring($sInvDate,7,4),'-',substring($sInvDate,4,2),'-',substring($sInvDate,1,2))"/>
											</InvoiceDate>
											<xsl:variable name="sTaxDate">
												<xsl:choose>
													<xsl:when test="InvoiceHeader/InvoiceReferences/TaxPointDate != ''">
														<xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<TaxPointDate>
												<xsl:value-of select="concat(substring($sTaxDate,7,4),'-',substring($sTaxDate,4,2),'-',substring($sTaxDate,1,2))"/>
											</TaxPointDate>

									<!--		<VATRegNo>
												<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
											</VATRegNo>
									-->		
										</InvoiceReferences>
										<Currency>
											<xsl:value-of select="InvoiceHeader/Currency"/>
										</Currency>
										
									</InvoiceHeader>
									<InvoiceDetail>
										<xsl:for-each select="InvoiceDetail/InvoiceLine">
											<InvoiceLine>
												<PurchaseOrderReferences>
													<xsl:if test="PurchaseOrderReferences/PurchaseOrderReference != ''">
														<PurchaseOrderReference>
															<xsl:value-of select="substring-before(substring-after(PurchaseOrderReferences/PurchaseOrderReference,'SP/'),'/')"/>
														</PurchaseOrderReference>
													</xsl:if>	
												<xsl:variable name="sPODate">
													<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
												</xsl:variable>
												<xsl:if test="PurchaseOrderReferences/PurchaseOrderDate != ''">
													<PurchaseOrderDate>
														<xsl:value-of select="concat(substring($sPODate,7,4),'-',substring($sPODate,4,2),'-',substring($sPODate,1,2))"/>
													</PurchaseOrderDate>
												</xsl:if>	
												</PurchaseOrderReferences>
												<DeliveryNoteReferences>
													<xsl:if test="DeliveryNoteReferences/DeliveryNoteReference != ''">
														<DeliveryNoteReference>
															<xsl:value-of select="substring-before(substring-after(DeliveryNoteReferences/DeliveryNoteReference,'SP/'),'/')"/>
														</DeliveryNoteReference>
													</xsl:if>
													<xsl:variable name="sDelNoteDate">
														<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
													</xsl:variable>
													<xsl:if test="DeliveryNoteReferences/DeliveryNoteDate != ''">
														<DeliveryNoteDate>
															<xsl:value-of select="concat(substring($sDelNoteDate,7,4),'-',substring($sDelNoteDate,4,2),'-',substring($sDelNoteDate,1,2))"/>
														</DeliveryNoteDate>
													</xsl:if>	
												</DeliveryNoteReferences>
												<ProductID>
													<SuppliersProductCode>
														<xsl:value-of select="ProductID/SuppliersProductCode"/>
													</SuppliersProductCode>
												</ProductID>
												<xsl:copy-of select="ProductDescription"/>
												<!--
												<InvoicedQuantity>
													<xsl:value-of select="InvoicedQuantity"/>
												</InvoicedQuantity>
												-->
												<InvoicedQuantity>
													<xsl:attribute name="UnitOfMeasure">
														<xsl:call-template name="decodeUoM">
															<xsl:with-param name="sInput">
																<xsl:value-of select="PackSize"/>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:attribute>
													<xsl:value-of select="format-number(InvoicedQuantity,'0.000')"/>
												</InvoicedQuantity>
												
												<xsl:if test="PackSize != ''">
													<PackSize>
														<xsl:value-of select="PackSize"/>
													</PackSize>
												</xsl:if>
												<UnitValueExclVAT>
													<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
												</UnitValueExclVAT>
												<xsl:if test="LineValueExclVAT != ''">
													<LineValueExclVAT>
														<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
													</LineValueExclVAT>
												</xsl:if>
												<VATCode>
													<xsl:choose>
														<xsl:when test="VATCode ='NLICS'">Z</xsl:when>
														<!--<xsl:when test="VATCode ='UKDOM'">S</xsl:when>-->
														<xsl:otherwise>S</xsl:otherwise>
													</xsl:choose>	
												</VATCode>
												<VATRate>
													<xsl:choose>
														<xsl:when test="VATRate = 'NLICS'">0</xsl:when>
														<!--<xsl:when test="VATRate = 'UKDOM'">20</xsl:when>-->
														<xsl:otherwise>20</xsl:otherwise>
													</xsl:choose>	
												</VATRate>
											</InvoiceLine>
										</xsl:for-each>
									</InvoiceDetail>
									<InvoiceTrailer>
										<xsl:if test="InvoiceTrailer/NumberOfLines != ''">
											<NumberOfLines>
												<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
											</NumberOfLines>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/NumberOfItems">
											<NumberOfItems>
												<xsl:value-of select="InvoiceTrailer/NumberOfItems"/>
											</NumberOfItems>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/NumberOfDeliveries">
											<NumberOfDeliveries>
												<xsl:value-of select="InvoiceTrailer/NumberOfDeliveries"/>
											</NumberOfDeliveries>
										</xsl:if>
										<VATSubTotals>
											<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
												<VATSubTotal>
													<xsl:attribute name="VATCode">
														<xsl:value-of select="./@VATCode"/>
													</xsl:attribute>
													<xsl:attribute name="VATRate">
														<xsl:value-of select="./@VATRate"/>
													</xsl:attribute>
													<xsl:if test="NumberOfLinesAtRate != ''">
														<NumberOfLinesAtRate>
															<xsl:value-of select="NumberOfLinesAtRate"/>
														</NumberOfLinesAtRate>
													</xsl:if>
													<xsl:if test="NumberOfItemsAtRate != ''">
														<NumberOfItemsAtRate>
															<xsl:value-of select="NumberOfItemsAtRate"/>
														</NumberOfItemsAtRate>
													</xsl:if>
													<xsl:if test="DocumentTotalExclVATAtRate != ''">
														<DocumentTotalExclVATAtRate>
															<xsl:value-of select="format-number(DocumentTotalExclVATAtRate,'0.00')"/>
														</DocumentTotalExclVATAtRate>
													</xsl:if>
													<xsl:if test="SettlementDiscountAtRate != ''">
														<SettlementDiscountAtRate>
															<xsl:value-of select="SettlementDiscountAtRate"/>
														</SettlementDiscountAtRate>
													</xsl:if>
													<xsl:if test="SettlementTotalExclVATAtRate != ''">
														<SettlementTotalExclVATAtRate>
															<xsl:value-of select="format-number(SettlementTotalExclVATAtRate,'0.00')"/>
														</SettlementTotalExclVATAtRate>
													</xsl:if>
													<xsl:if test="VATAmountAtRate != ''">
														<VATAmountAtRate>
															<xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/>
														</VATAmountAtRate>
													</xsl:if>
													<xsl:if test="DocumentTotalInclVATAtRate != ''">
														<DocumentTotalInclVATAtRate>
															<xsl:value-of select="format-number(DocumentTotalInclVATAtRate,'0.00')"/>
														</DocumentTotalInclVATAtRate>
													</xsl:if>
													<xsl:if test="SettlementTotalInclVATAtRate">
														<SettlementTotalInclVATAtRate>
															<xsl:value-of select="format-number(SettlementTotalInclVATAtRate,'0.00')"/>
														</SettlementTotalInclVATAtRate>
													</xsl:if>
												</VATSubTotal>
											</xsl:for-each>
										</VATSubTotals>
										<xsl:if test="InvoiceTrailer/DocumentTotalExclVAT != ''">
											<DocumentTotalExclVAT>
												<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalExclVAT,'0.00')"/>
											</DocumentTotalExclVAT>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/SettlementDiscount != ''">
											<SettlementDiscount>
												<xsl:value-of select="InvoiceTrailer/SettlementDiscount"/>
											</SettlementDiscount>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/SettlementTotalExclVAT != ''">
											<SettlementTotalExclVAT>
												<xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalExclVAT,'0.00')"/>
											</SettlementTotalExclVAT>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/VATAmount != ''">
											<VATAmount>
												<xsl:value-of select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
											</VATAmount>
										</xsl:if>
										<xsl:if test="InvoiceTrailer/DocumentTotalInclVAT != ''">
											<DocumentTotalInclVAT>
												<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
											</DocumentTotalInclVAT>
										</xsl:if>
									</InvoiceTrailer>
								</Invoice>
							</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>

	</xsl:template>
	
	<xsl:template name="decodeUoM">
		<xsl:param name="sInput"/>
		<xsl:choose>
			<xsl:when test="$sInput = 'BG'">EA</xsl:when>
			<xsl:when test="$sInput = 'BX'">CS</xsl:when>
			<xsl:when test="$sInput = 'CS'">CS</xsl:when>
			<xsl:when test="$sInput = 'DZ'">DZN</xsl:when>
			<xsl:when test="$sInput = 'FT'">EA</xsl:when>
			<xsl:when test="$sInput = 'GA'">EA</xsl:when>
			<xsl:when test="$sInput = 'LB'">PND</xsl:when>
			<xsl:when test="$sInput = 'LF'">EA</xsl:when>
			<xsl:when test="$sInput = 'LG'">EA</xsl:when>
			<xsl:when test="$sInput = 'MT'">EA</xsl:when>
			<xsl:when test="$sInput = 'PD'">EA</xsl:when>
			<xsl:when test="$sInput = 'PK'">EA</xsl:when>
			<xsl:when test="$sInput = 'PR'">PR</xsl:when>
			<xsl:when test="$sInput = 'PT'">PTI</xsl:when>
			<xsl:when test="$sInput = 'QT'">EA</xsl:when>
			<xsl:when test="$sInput = 'RL'">EA</xsl:when>
			<xsl:when test="$sInput = 'SH'">EA</xsl:when>
			<xsl:when test="$sInput = 'ST'">EA</xsl:when>
			<xsl:when test="$sInput = 'TB'">EA</xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Dim lLineNumber
		
		Function resetLineNumber()
			lLineNumber = 1
			resetLineNumber = 1
		End Function
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
	]]></msxsl:script>
</xsl:stylesheet>
