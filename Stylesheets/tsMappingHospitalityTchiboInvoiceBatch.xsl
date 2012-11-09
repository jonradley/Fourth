<?xml version="1.0" encoding="UTF-8"?>
<!--
Name			| Date			| Change
************************************************************************************************************************
M Emanuel	| 03/10/2012 | FB Case No 5735: Made changes to include branch reference and PO Reference
************************************************************************************************************************
M Emanuel	| 09/11/2012 | FB Case No 5839: Mapping in Order Reference as the Delivery note reference
************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:blah="http://blah.blah.blah" 
										 xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://blah.blah.blah"
										 exclude-result-prefixes="blah msxsl vbscript">
	
	<xsl:template match="/">
	
		<BatchRoot>
	
			<Batch>
					
				<BatchDocuments>
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument">
				
						<BatchDocument>
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="Invoice/TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
							
									<SendersBranchReference>
										<xsl:value-of select="Invoice/TradeSimpleHeader/SendersBranchReference"/>
									</SendersBranchReference>
								
								</TradeSimpleHeader>
								<InvoiceHeader>
									<BatchInformation>
										<FileCreationDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/BatchInformation/FileCreationDate"/>
											</xsl:call-template>
										</FileCreationDate>
										<SendersTransmissionReference><xsl:value-of select="Invoice/InvoiceHeader/BatchInformation/SendersTransmissionReference"/></SendersTransmissionReference>
										<SendersTransmissionDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
											</xsl:call-template>
											<xsl:text>T00:00:00</xsl:text>
										</SendersTransmissionDate>
									</BatchInformation>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode><xsl:value-of select="Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
									</ShipTo>
									<InvoiceReferences>
										<InvoiceReference><xsl:value-of select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/></InvoiceReference>
										<InvoiceDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
											</xsl:call-template>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
											</xsl:call-template>
										</TaxPointDate>
									</InvoiceReferences>
								</InvoiceHeader>
								
								<InvoiceDetail>
									<xsl:for-each select="Invoice/InvoiceDetail/InvoiceLine">
										<InvoiceLine>
											<xsl:choose>
												<xsl:when test="//PurchaseOrderReferences/PurchaseOrderReference!=''">
													<PurchaseOrderReferences>
														<PurchaseOrderReference>
															<xsl:value-of select="//PurchaseOrderReferences/PurchaseOrderReference"/>	
														</PurchaseOrderReference>																													</PurchaseOrderReferences>
												</xsl:when>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="//DeliveryNoteReferences/DeliveryNoteReference !=''">
													<DeliveryNoteReferences>
														<DeliveryNoteReference>
															<xsl:value-of select="//DeliveryNoteReferences/DeliveryNoteReference"/>
														</DeliveryNoteReference>
													</DeliveryNoteReferences>
												</xsl:when>
											</xsl:choose>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											<!--Added ProductDescription-->
											<xsl:if test="ProductDescription != ''">
												<ProductDescription>
													<xsl:value-of select="ProductDescription"/>
												</ProductDescription>
											</xsl:if>
											<InvoicedQuantity><xsl:value-of select="InvoicedQuantity"/></InvoicedQuantity>
											<UnitValueExclVAT><xsl:value-of select="UnitValueExclVAT"/></UnitValueExclVAT>
											<LineValueExclVAT><xsl:value-of select="LineValueExclVAT"/></LineValueExclVAT>
											<xsl:choose>
												<xsl:when test="VATCode = 'V'">
													<VATCode>S</VATCode>
												</xsl:when>
												<xsl:otherwise><VATCode><xsl:value-of select="VATCode"/></VATCode></xsl:otherwise>
											</xsl:choose>
											<VATRate>
												<xsl:value-of select="format-number(format-number(number(../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode  = current()/VATCode]/VATAmountAtRate) div number(../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode  = current()/VATCode]/DocumentTotalExclVATAtRate) * 100,'0.0'),'0.00')"/>
											</VATRate>
										</InvoiceLine>	
									</xsl:for-each>								
								</InvoiceDetail>
								
								<InvoiceTrailer>
									<SettlementDiscountRate><xsl:value-of select="Invoice/InvoiceTrailer/SettlementDiscountRate"/></SettlementDiscountRate> 
									<VATSubTotals>	
										<xsl:for-each select="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
											<VATSubTotal>
												<xsl:if test="@VATCode = 'V'">
													<xsl:attribute name="VATCode"><xsl:text>S</xsl:text></xsl:attribute>
														<xsl:attribute name="VATRate"><xsl:value-of select="format-number(format-number(number(VATAmountAtRate) div number(DocumentTotalExclVATAtRate) * 100, '0.0'),'0.00')"/></xsl:attribute>
													</xsl:if>
												<xsl:if test="@VATCode = 'Z'">
													<xsl:attribute name="VATCode"><xsl:text>Z</xsl:text></xsl:attribute>
													<xsl:attribute name="VATRate">0.00</xsl:attribute>
												</xsl:if>
												<NumberOfLinesAtRate><xsl:value-of select="format-number(NumberOfLinesAtRate, '0')"/></NumberOfLinesAtRate>
												<DocumentTotalExclVATAtRate><xsl:value-of select="DocumentTotalExclVATAtRate"/></DocumentTotalExclVATAtRate>
												<VATAmountAtRate><xsl:value-of select="VATAmountAtRate"/></VATAmountAtRate>
											</VATSubTotal>
										</xsl:for-each>			
									</VATSubTotals>
									<DocumentTotalExclVAT><xsl:value-of select="Invoice/InvoiceTrailer/DocumentTotalExclVAT"/></DocumentTotalExclVAT>
									<VATAmount><xsl:value-of select="Invoice/InvoiceTrailer/VATAmount"/></VATAmount>
								</InvoiceTrailer>
							</Invoice>
							
						</BatchDocument>
	
					</xsl:for-each>
	
				</BatchDocuments>
				
			</Batch>
			
		</BatchRoot>
	
	</xsl:template>
	
	
	
			
	<xsl:template name="formatDate">
		<xsl:param name="sDate"/>
	
		<xsl:value-of select="concat(substring($sDate,5,4), '-', substring($sDate,3,2), '-', substring($sDate,1,2))"/>
	
	</xsl:template>
	


	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Function addDays(sDate, nDaysToAdd)
		
			addDays = DateAdd("d", nDaysToAdd, sDate)
			addDays = Right(addDays , 4) & "-" & Mid(addDays , 4, 2) & "-" & Left(addDays , 2)
		
		End Function		
	]]></msxsl:script>

</xsl:stylesheet>
