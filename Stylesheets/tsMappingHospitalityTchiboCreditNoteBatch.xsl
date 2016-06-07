<?xml version="1.0" encoding="UTF-8"?>
<!--
Name			| Date			| Change
************************************************************************************************************************************
M Emanuel	| 03/10/2012 | FB Case No 5735: Made changes to include branch reference, Invoice Reference and added a get date JScript
************************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:blah="http://blah.blah.blah" 
										 xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://blah.blah.blah"
										 exclude-result-prefixes="blah msxsl vbscript" xmlns:user="http://mycompany.com/mynamespace">
	
	<xsl:template match="/">
	
		<BatchRoot>
	
			<Batch>
					
				<BatchDocuments>
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument">
				
						<BatchDocument>
							<CreditNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="CreditNote/TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
	
									<SendersBranchReference>
										<xsl:value-of select="CreditNote/TradeSimpleHeader/SendersBranchReference"/>
									</SendersBranchReference>
									
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
									<xsl:choose>
										<xsl:when test="CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference!=''">
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
												</InvoiceReference>
												<InvoiceDate>
													<xsl:value-of select="user:msGetDate()"/>
												</InvoiceDate>
												<TaxPointDate>
													<xsl:value-of select="user:msGetDate()"/>
												</TaxPointDate>
											</InvoiceReferences>
										</xsl:when>
									</xsl:choose>
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
									<xsl:for-each select="CreditNote/CreditNoteDetail/CreditNoteLine">
										<CreditNoteLine>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											<!--Added ProductDescription-->
											<xsl:if test="ProductDescription != ''">
												<ProductDescription>
													<xsl:value-of select="ProductDescription"/>
												</ProductDescription>
											</xsl:if>
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
												<xsl:value-of select="format-number(format-number(number(../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode  = current()/VATCode]/VATAmountAtRate) div number(../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode  = current()/VATCode]/DocumentTotalExclVATAtRate) * 100,'0.0'),'0.00')"/>
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
	
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[

		function msGetDate()
		{
		var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() ;
			
		
			return sYear + '-'+ sMonth +'-'+ sDate;
		}
		
]]></msxsl:script>

</xsl:stylesheet>
