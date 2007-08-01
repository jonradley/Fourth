<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Invoice mapper (Chuanglee)
'  Hospitality post Tradacoms flat file mapping to iXML format.
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 18/06/2007  | Nigel Emsen  | Created. FB: 1310.
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">


	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/Document">
		<BatchRoot>
			<BatchDocuments>
				<BatchDocument DocumentTypeNo="4">
				
					<xsl:for-each select="L1[@Name='H']">
				
						<Invoice>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="L2[2]"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							
							<InvoiceHeader>

								<ShipTo>
									<ShipToLocationID>
									
										<SuppliersCode>
											<xsl:value-of select="L2[2]"/>
										</SuppliersCode>
										
									</ShipToLocationID>

								</ShipTo>
								
								<InvoiceReferences>
								
									<InvoiceReference>
										<xsl:value-of select="L2[3]"/>
									</InvoiceReference>
									
									<InvoiceDate>
									
										<xsl:call-template name="sdRemapDate">
											<xsl:with-param name="sDate" select="L2[4]"/>
										</xsl:call-template>
										
									</InvoiceDate>
									
									<TaxPointDate>
										
										<xsl:call-template name="sdRemapDate">
											<xsl:with-param name="sDate" select="L2[5]"/>
										</xsl:call-template>
																			
									</TaxPointDate>
									
								</InvoiceReferences>
							</InvoiceHeader>
							
							<InvoiceDetail>
							
								<xsl:for-each select="L1[@Name='D']">
									<InvoiceLine>
									
										<LineNumber>
											<xsl:value-of select="position()"/>
										</LineNumber>
										
										<PurchaseOrderReferences>
										
											<PurchaseOrderReferemce>
											</PurchaseOrderReferemce>
											
											<PurchaseOrderDate>
											
											</PurchaseOrderDate>
										
										</PurchaseOrderReferences>
										
										<ProductID>
											<SuppliersCode>
											</SuppliersCode>
										</ProductID>
										
										<ProductDescription>
											<xsl:text>Not Provided</xsl:text>
										</ProductDescription>
										
										<InvoicedQuantity UnitOfMeasure="Text">3.14159</InvoicedQuantity>
										
										<UnitValueExclVAT>3.14159</UnitValueExclVAT>
										
										<LineValueExclVAT>3.14159</LineValueExclVAT>
										
										<VATCode>S</VATCode>
										
										<VATRate>xx</VATRate>
										
									</InvoiceLine>
									
								</xsl:for-each>
							</InvoiceDetail>
							<InvoiceTrailer>
								<NumberOfLines>2</NumberOfLines>
								<NumberOfItems>3.14159</NumberOfItems>
								<NumberOfDeliveries>0</NumberOfDeliveries>
								<DocumentDiscountRate>xx</DocumentDiscountRate>
								<SettlementDiscountRate SettlementDiscountDays="2">3.14159</SettlementDiscountRate>
								<VATSubTotals>
									<VATSubTotal VATCode="Text" VATRate="Text">
										<NumberOfLinesAtRate>2</NumberOfLinesAtRate>
										<NumberOfItemsAtRate>3.14159</NumberOfItemsAtRate>
										<DiscountedLinesTotalExclVATAtRate>3.14159</DiscountedLinesTotalExclVATAtRate>
										<DocumentDiscountAtRate>3.14159</DocumentDiscountAtRate>
										<DocumentTotalExclVATAtRate>3.14159</DocumentTotalExclVATAtRate>
										<SettlementDiscountAtRate>3.14159</SettlementDiscountAtRate>
										<SettlementTotalExclVATAtRate>3.14159</SettlementTotalExclVATAtRate>
										<VATAmountAtRate>3.14159</VATAmountAtRate>
										<DocumentTotalInclVATAtRate>3.14159</DocumentTotalInclVATAtRate>
										<SettlementTotalInclVATAtRate>3.14159</SettlementTotalInclVATAtRate>
									</VATSubTotal>
								</VATSubTotals>
								<DiscountedLinesTotalExclVAT>3.14159</DiscountedLinesTotalExclVAT>
								<DocumentDiscount>3.14159</DocumentDiscount>
								<DocumentTotalExclVAT>3.14159</DocumentTotalExclVAT>
								<SettlementDiscount>3.14159</SettlementDiscount>
								<SettlementTotalExclVAT>3.14159</SettlementTotalExclVAT>
								<VATAmount>3.14159</VATAmount>
								<DocumentTotalInclVAT>3.14159</DocumentTotalInclVAT>
								<SettlementTotalInclVAT>3.14159</SettlementTotalInclVAT>
							</InvoiceTrailer>
						</Invoice>
					
					</xsl:for-each>
					
				</BatchDocument>
			</BatchDocuments>
		</BatchRoot>
		
	</xsl:template>

	<!-- date reformating -->
	<xsl:template name="sdRemapDate">
	
		<xsl:param name="sDate" select="sDate"/>
		<xsl:variable name="sDate2" select="translate($sDate,' ','')"/>
		
			<xsl:copy>
				<xsl:value-of select="concat(substring($sDate2,7,4),'-',substring($sDate2,4,2),'-',substring($sDate2,1,2))"/>
			</xsl:copy>
			
	</xsl:template>

	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 

		'	------------------------------------------------------------------
		' FUNCTION:	To return the SystemDate in Internal XML format.
		'					Nigel Emsen, May 2007
		'	------------------------------------------------------------------
		Function sGetTodaysDate()
		
			Dim dToday
			Dim sDay, sMonth, sYear
			
			dToday=date
			
			sDay=Day(dToday)
			if CInt(sDay)<10 then sDay="0" & sDay
			
			sMonth=Month(dToday)
			if CInt(sMonth)<10 then sMonth="0" & sMonth
			
			sYear=Year(dToday)
			
			sGetTodaysDate=sYear & "-" & sMonth & "-" & sDay

		End Function
		
		'	------------------------------------------------------------------
		' FUNCTION:	To rreturn the confirmed qty by calculating from the 
		'					ALD:OQTY and the ALD:OUBA.
		'					Nigel Emsen, June 2007
		'	------------------------------------------------------------------
		Function sGetConfirmedQty(vsOQTY,vsOUBA)
		
			Dim sResult
			Dim lOQTY
			Dim lOUBA
			Dim lResult
			
			if vsOQTY="" Then vsOQTY="0"
			lOQTY=CLng(vsOQTY)

			if vsOUBA="" then vsOUBA="0"
			lOUBA=CLng(vsOUBA)

			lResult=lOQTY-lOUBA
			sResult=CStr(lResult)

			sGetConfirmedQty=sResult
			
		End Function
		
		

	]]></msxsl:script>
</xsl:stylesheet>
