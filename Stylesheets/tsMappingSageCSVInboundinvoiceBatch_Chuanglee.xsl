<?xml version="1.0" encoding="UTF-8"?>
<!-- 
'******************************************************************************************
' Overview
'		
' Translation of inbound flat file invoice batch for Chuanglee
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002,2003.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name            | Description of modification
'******************************************************************************************
' 16/07/2007 | Moty Dimant     | FB: - Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 28/09/2007 | Lee Boyton      | FB1424. Cope with more than 1 document in the batch.
'                              |         Corrected VAT sub total translation for standard rate.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>


	<xsl:template match="/">

		<BatchRoot>
			
			<Batch>
			
				<BatchDocuments>
									
						<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice">

							<BatchDocument>
		
							<Invoice>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>								
								</TradeSimpleHeader>
								
								<InvoiceHeader>
								
									<DocumentStatus>Original</DocumentStatus>
									
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
									</ShipTo>
									
									<InvoiceReferences>
										<InvoiceReference><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/></InvoiceReference>
										<InvoiceDate>
											<xsl:call-template name="sFormatDate">
												<xsl:with-param name="vsDDoMMoYYYY" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
											</xsl:call-template>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:call-template name="sFormatDate">
												<xsl:with-param name="vsDDoMMoYYYY" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
											</xsl:call-template>
										</TaxPointDate>
									</InvoiceReferences>
									
								</InvoiceHeader>
								
								<InvoiceDetail>
								
								
									<xsl:variable name="sPORef" select="string(../../../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference)"/>
									<xsl:variable name="sPODate">
										<xsl:call-template name="sFormatDate">
											<xsl:with-param name="vsDDoMMoYYYY" select="../../../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
										</xsl:call-template>
									</xsl:variable>
								
									<xsl:for-each select="InvoiceDetail/InvoiceLine">
								
										<InvoiceLine>
										
											<xsl:if test="$sPORef != '' and $sPODate != ''">
										
												<PurchaseOrderReferences>
													<PurchaseOrderReference><xsl:value-of select="$sPORef"/></PurchaseOrderReference>
													<PurchaseOrderDate><xsl:value-of select="$sPODate"/></PurchaseOrderDate>
												</PurchaseOrderReferences>
												
											</xsl:if>
											
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<ProductDescription>Not Provided</ProductDescription>
											
											<InvoicedQuantity><xsl:value-of select="InvoicedQuantity"/></InvoicedQuantity>
											
											<UnitValueExclVAT><xsl:value-of select="UnitValueExclVAT"/></UnitValueExclVAT>
											
											<LineValueExclVAT><xsl:value-of select="LineValueExclVAT"/></LineValueExclVAT>
											
											<VATCode>
												<xsl:choose>
													<xsl:when test="VATCode='1'">S</xsl:when>
													<xsl:otherwise>Z</xsl:otherwise>
												</xsl:choose>
											</VATCode>
		
										</InvoiceLine>
										
									</xsl:for-each>	
										
								</InvoiceDetail>
								
								<InvoiceTrailer>
								
									<VATSubTotals>

										<!-- The following fields populated from the flat file mapper are used as place holders and contain values as below  -->
										<!-- NumberOfLinesAtRate = VAT AMOUNT Z -->
										<!-- NumberOfItemsAtRate = GOODS AMOUNT Z -->
										<!-- DocumentTotalExclVATAtRate = VAT AMOUNT S -->
										<!-- SettlementDiscountAtRate = GOODS AMOUNT S -->
									
								
										<!--COLUMN ONE-->
										<xsl:if test="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentDiscountAtRate[.='2'] and InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate[.!=0]">									
											<VATSubTotal>
												<xsl:attribute name="VATCode">Z</xsl:attribute>
												<xsl:attribute name="VATRate">0</xsl:attribute>
												<DocumentTotalExclVATAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate"/></DocumentTotalExclVATAtRate>
												<VATAmountAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate"/></VATAmountAtRate>
											</VATSubTotal>					
										</xsl:if>
										
										<xsl:if test="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentDiscountAtRate[.='1'] and InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate[.!=0]">
											<VATSubTotal>
												<xsl:attribute name="VATCode">S</xsl:attribute>
												<xsl:attribute name="VATRate">17.5</xsl:attribute>
												<DocumentTotalExclVATAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate"/></DocumentTotalExclVATAtRate>
												<VATAmountAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfItemsAtRate"/></VATAmountAtRate>
											</VATSubTotal>	
										</xsl:if>	
										
										<!--COLUMN TWO-->
										<xsl:if test="InvoiceTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate[.='2'] and InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate[.!=0]">									
											<VATSubTotal>
												<xsl:attribute name="VATCode">Z</xsl:attribute>
												<xsl:attribute name="VATRate">0</xsl:attribute>
												<DocumentTotalExclVATAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate"/></DocumentTotalExclVATAtRate>
												<VATAmountAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/SettlementDiscountAtRate"/></VATAmountAtRate>
											</VATSubTotal>					
										</xsl:if>
										
										<xsl:if test="InvoiceTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate[.='1'] and InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate[.!=0]">
											<VATSubTotal>
												<xsl:attribute name="VATCode">S</xsl:attribute>
												<xsl:attribute name="VATRate">17.5</xsl:attribute>
												<DocumentTotalExclVATAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate"/></DocumentTotalExclVATAtRate>
												<VATAmountAtRate><xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/SettlementDiscountAtRate"/></VATAmountAtRate>
											</VATSubTotal>	
										</xsl:if>											


												
									</VATSubTotals>
									
								</InvoiceTrailer>
								
							</Invoice>

							</BatchDocument>
	
						</xsl:for-each>
			
				</BatchDocuments>
				
			</Batch>
			
		</BatchRoot>

	</xsl:template>
	
	<xsl:template name="sFormatDate">
		<xsl:param name="vsDDoMMoYYYY"/>
		<xsl:if test="$vsDDoMMoYYYY != ''">
			<xsl:value-of select="concat(substring($vsDDoMMoYYYY,7,4),'-',substring($vsDDoMMoYYYY,4,2),'-',substring($vsDDoMMoYYYY,1,2))"/>
		</xsl:if>	
	</xsl:template>
	
	
</xsl:stylesheet>