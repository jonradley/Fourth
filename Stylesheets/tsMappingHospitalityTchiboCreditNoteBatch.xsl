<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:blah="http://blah.blah.blah" 
										 xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://blah.blah.blah"
										 exclude-result-prefixes="blah msxsl vbscript">
	
	<xsl:variable name="defaultTaxRate" select="'17.5'"/>
	<xsl:variable name="defaultTaxRateNew" select="'15'"/>

	<xsl:template match="/">
	
		<BatchRoot>
	
			<Batch>
					
				<BatchDocuments>
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument">
				
						<BatchDocument>
							<CreditNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="CreditNote/TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
								</TradeSimpleHeader>
								<CreditNoteHeader>
									<BatchInformation>
										<FileCreationDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="CreditNote/CreditNoteHeader/BatchInformation/FileCreationDate"/>
											</xsl:call-template>
										</FileCreationDate>
										<SendersTransmissionReference><xsl:value-of select="CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionReference"/></SendersTransmissionReference>
										<SendersTransmissionDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate"/>
											</xsl:call-template>
											<xsl:text>T00:00:00</xsl:text>
										</SendersTransmissionDate>
									</BatchInformation>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode><xsl:value-of select="CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/></SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
									</ShipTo>
									<CreditNoteReferences>
										<CreditNoteReference><xsl:value-of select="CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/></CreditNoteReference>
										<CreditNoteDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
											</xsl:call-template>
										</CreditNoteDate>
										<TaxPointDate>
											<xsl:call-template name="formatDate">
												<xsl:with-param name="sDate" select="CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
											</xsl:call-template>
										</TaxPointDate>
									</CreditNoteReferences>
								</CreditNoteHeader>
								
								<CreditNoteDetail>
									<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/CreditNote/CreditNoteDetail/CreditNoteLine">
										<CreditNoteLine>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											<CreditedQuantity><xsl:value-of select="CreditedQuantity"/></CreditedQuantity>
											<UnitValueExclVAT><xsl:value-of select="UnitValueExclVAT"/></UnitValueExclVAT>
											<LineValueExclVAT><xsl:value-of select="LineValueExclVAT"/></LineValueExclVAT>
											<xsl:choose>
												<xsl:when test="VATCode = 'V'">
													<VATCode>S</VATCode>
												</xsl:when>
												<xsl:otherwise><VATCode><xsl:value-of select="VATCode"/></VATCode></xsl:otherwise>
											</xsl:choose>
											<VATRate>
												<xsl:choose>
															<xsl:when test="translate(substring(CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate,1,10),'-','')  &lt;= translate('2008-11-30','-','')  and translate(substring(CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate,1,10),'-','') &gt;=translate('2009-11-30','-','')">
																<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="format-number($defaultTaxRateNew, '0.00')"/>
															</xsl:otherwise>
														</xsl:choose>
											</VATRate>
										</CreditNoteLine>	
									</xsl:for-each>								
								</CreditNoteDetail>
								
								<CreditNoteTrailer>
									<SettlementDiscountRate><xsl:value-of select="CreditNote/CreditNoteTrailer/SettlementDiscountRate"/></SettlementDiscountRate> 
									<VATSubTotals>	
										<xsl:for-each select="CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
											<VATSubTotal>
												<xsl:if test="@VATCode = 'V'">
													<xsl:attribute name="VATCode"><xsl:text>S</xsl:text></xsl:attribute>
													<xsl:choose>
														<xsl:when test="translate(substring(CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate,1,10),'-','')  &lt;= translate('2008-11-30','-','')  and translate(substring(CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate,1,10),'-','') &gt;=translate('2009-11-30','-','')">
															<xsl:attribute name="VATRate"><xsl:value-of select="format-number($defaultTaxRate, '0.00')"/></xsl:attribute>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="VATRate"><xsl:value-of select="format-number($defaultTaxRateNew, '0.00')"/></xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>
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
									<DocumentTotalExclVAT><xsl:value-of select="CreditNote/CreditNoteTrailer/DocumentTotalExclVAT"/></DocumentTotalExclVAT>
									<VATAmount><xsl:value-of select="CreditNote/CreditNoteTrailer/VATAmount"/></VATAmount>
								</CreditNoteTrailer>
							</CreditNote>
							
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
