<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************************************************************************************
Date			|	owner				|	details
**********************************************************************************************************************************************
15/08/2012	| KOshaughnessy	| Created FB 5649
**********************************************************************************************************************************************
06/03/2013	| M Dimant			| 6116 Map quantity and UOM from a different location. Translate catch-weight UOMs.	
**********************************************************************************************************************************************
2013-03-20	| M Dimant			| 6274 Additional UOM conversions 
**********************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:for-each select="Invoice">
					
							<CreditNote>
							
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
									</SendersCodeForRecipient>
									<SendersBranchReference>
										<xsl:value-of select="Supplier/Contact/Department"/>
									</SendersBranchReference>
								</TradeSimpleHeader>
								
								<CreditNoteHeader>
									<!-- the document status is always Original -->
									<DocumentStatus>
										<xsl:text>Original</xsl:text>
									</DocumentStatus>
	
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode>
												<xsl:value-of select="Supplier/Contact/Department"/>
											</SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
											</SuppliersCode>
										</ShipToLocationID>
									</ShipTo>
									
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceReferences/BuyersOrderNumber"/>
										</InvoiceReference>
										<InvoiceDate>
											<xsl:value-of select="InvoiceDate"/>
										</InvoiceDate>
										<xsl:for-each select="TaxPointDate[. != ''][1]">
											<TaxPointDate>
												<xsl:value-of select="."/>
											</TaxPointDate>
										</xsl:for-each>
										<xsl:for-each select="Supplier/SupplierReferences/TaxNumber[. != ''][1]">
											<VATRegNo>
												<xsl:value-of select="."/>
											</VATRegNo>
										</xsl:for-each>
									</InvoiceReferences>
									
									<CreditNoteReferences>
										<CreditNoteReference>
											<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
										</CreditNoteReference>
										<CreditNoteDate>
											<xsl:value-of select="InvoiceDate"/>
										</CreditNoteDate>
										<xsl:for-each select="TaxPointDate[. != ''][1]">
											<TaxPointDate>
												<xsl:value-of select="."/>
											</TaxPointDate>
										</xsl:for-each>
										<xsl:for-each select="Supplier/SupplierReferences/TaxNumber[. != ''][1]">
											<VATRegNo>
												<xsl:value-of select="."/>
											</VATRegNo>
										</xsl:for-each>
									</CreditNoteReferences>
								</CreditNoteHeader>
								
								<CreditNoteDetail>
								
									<xsl:for-each select="InvoiceLine">
										<CreditNoteLine>
										
											<xsl:for-each select="LineNumber[. != ''][1]">
												<LineNumber>
													<xsl:value-of select="."/>
												</LineNumber>
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
												<xsl:attribute name="UnitOfMeasure">
													<xsl:call-template name="decodeUoM">
														<xsl:with-param name="sInput">
														<xsl:value-of select="Quantity/@UOMDescription"/>
														</xsl:with-param>
													</xsl:call-template>
												</xsl:attribute>
												<xsl:value-of select="format-number(Quantity/Amount, '0.000')"/>
											</CreditedQuantity>
																		
											<UnitValueExclVAT>
												<xsl:value-of select="Price/UnitPrice"/>
											</UnitValueExclVAT>
											
											<xsl:for-each select="LineTotal[. != ''][1]">
												<LineValueExclVAT>
													<xsl:value-of select="."/>
												</LineValueExclVAT>
											</xsl:for-each>
											
											<VATCode>
												<xsl:value-of select="LineTax/TaxRate/@Code"/>
											</VATCode>
											
											<VATRate>
												<xsl:value-of select="format-number(LineTax/TaxRate,'0.00')"/>
											</VATRate>
											
										</CreditNoteLine>
									</xsl:for-each>
									
								</CreditNoteDetail>
								
								<CreditNoteTrailer>
	
									<VATSubTotals>
										<xsl:for-each select="TaxSubTotal">
										
											<VATSubTotal>
											<xsl:attribute name="VATCode"><xsl:value-of select="TaxRate/@Code"/></xsl:attribute>
											<xsl:attribute name="VATRate"><xsl:value-of select="format-number(TaxRate,'0.00')"/></xsl:attribute>
											
												<xsl:for-each select="NumberOfLinesAtRate[. != ''][1]">
													<NumberOfLinesAtRate>
														<xsl:value-of select="."/>
													</NumberOfLinesAtRate>
												</xsl:for-each>
												
												<xsl:for-each select="TaxableValueAtRate[. != ''][1]">
													<DocumentTotalExclVATAtRate>
														<xsl:value-of select="."/>
													</DocumentTotalExclVATAtRate>
												</xsl:for-each>
												
												<xsl:for-each select="TaxAtRate[. != ''][1]">
													<VATAmountAtRate>
														<xsl:value-of select="."/>
													</VATAmountAtRate>
												</xsl:for-each>
												
												<xsl:for-each select="NetPaymentAtRate[. != ''][1]">
													<DocumentTotalInclVATAtRate>
														<xsl:value-of select="."/>
													</DocumentTotalInclVATAtRate>
												</xsl:for-each>
	
											</VATSubTotal>
											
										</xsl:for-each>
									</VATSubTotals>
									
									<xsl:for-each select="InvoiceTotal/TaxableTotal[. != ''][1]">
										<DocumentTotalExclVAT>
											<xsl:value-of select="."/>
										</DocumentTotalExclVAT>
									</xsl:for-each>
	
									<xsl:for-each select="InvoiceTotal/TaxTotal[. != ''][1]">
										<VATAmount>
											<xsl:value-of select="."/>
										</VATAmount>
									</xsl:for-each>
									
									<xsl:for-each select="InvoiceTotal/NetPaymentTotal[. != ''][1]">
										<DocumentTotalInclVAT>
											<xsl:value-of select="."/>
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
	
	
	<xsl:template name="decodeUoM">
	<xsl:param name="sInput"/>

		 <xsl:choose>
		 	<xsl:when test="$sInput ='CASE'">CS</xsl:when>
			<xsl:when test="$sInput ='EACH'">EA</xsl:when>
			<xsl:when test="$sInput ='BLOCK'">EA</xsl:when>
			<xsl:when test="$sInput ='BOX'">CS</xsl:when>
			<xsl:when test="$sInput ='BUCKE'">EA</xsl:when>
			<xsl:when test="$sInput ='PACK'">CS</xsl:when>
			<xsl:when test="$sInput ='TRAY'">EA</xsl:when>
			<xsl:when test="$sInput ='TUB'">EA</xsl:when>
			<xsl:when test="$sInput ='KG'">KGM</xsl:when>
			<xsl:when test="$sInput ='KILO'">KGM</xsl:when>
			<xsl:when test="$sInput ='Kg'">KGM</xsl:when>
			<xsl:when test="$sInput ='kg'">KGM</xsl:when>
			
			<xsl:otherwise>
					<xsl:value-of select="$sInput"></xsl:value-of>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>
