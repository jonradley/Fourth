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
' 26/11/2008 | Rave Tech  	   | 2592 - Handled VAT rate change from 17.5% to 15%.
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 15/12/2009 |S Sehgal  	| Case 3286 Changed to handle VAT changing back to 17.5% from 1-Jan-2010
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 19/01/2011 |J Cahilll  	| Case 4124 Drop decimal part of VAT rate. Make it "20" instead of "20.0"
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:script="http://mycompany.com/mynamespace">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:variable name="CurrentDate" select="script:msGetTodaysDate()"/>
	<xsl:template match="/">

		<BatchRoot>
			
			<Batch>
			
				<BatchDocuments>
									
						<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice">

							<BatchDocument>
		
							<Invoice>
								<xsl:variable name="TaxPointDate">	
									<xsl:call-template name="sFormatDate">
										<xsl:with-param name="vsDDoMMoYYYY" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="InvoiceDate">	
									<xsl:call-template name="sFormatDate">
										<xsl:with-param name="vsDDoMMoYYYY" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
									</xsl:call-template>
								</xsl:variable>							

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
								
								
									<xsl:variable name="sPORef" select="string(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference)"/>
									<xsl:variable name="sPODate">
										<xsl:call-template name="sFormatDate">
											<xsl:with-param name="vsDDoMMoYYYY" select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
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
											
											<DeliveryNoteReferences>
												<DeliveryNoteReference><xsl:value-of select="../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
												<DeliveryNoteDate>
													<xsl:call-template name="sFormatDate">
														<xsl:with-param name="vsDDoMMoYYYY" select="../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
													</xsl:call-template>
												</DeliveryNoteDate>
												<DespatchDate>
													<xsl:call-template name="sFormatDate">
														<xsl:with-param name="vsDDoMMoYYYY" select="../InvoiceLine[1]/DeliveryNoteReferences/DespatchDate"/>
													</xsl:call-template>
												</DespatchDate> 
											</DeliveryNoteReferences>
											
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
												<xsl:choose>
													<xsl:when test="$TaxPointDate !=''">
														<xsl:choose>
															<xsl:when test="translate($TaxPointDate,'-','') &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($TaxPointDate,'-','') &lt;= translate('2008-11-30','-','') or translate($TaxPointDate,'-','') &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:when test="$InvoiceDate !=''">
														<xsl:choose>
															<xsl:when test="translate($InvoiceDate,'-','') &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($InvoiceDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($InvoiceDate,'-','')  &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
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
												<xsl:choose>
													<xsl:when test="$TaxPointDate !=''">
														<xsl:choose>
															<xsl:when test="translate($TaxPointDate,'-','') &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($TaxPointDate,'-','') &lt;= translate('2008-11-30','-','') or translate($TaxPointDate,'-','') &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:when test="$InvoiceDate !=''">
														<xsl:choose>
															<xsl:when test="translate($InvoiceDate,'-','') &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($InvoiceDate,'-','') &lt;= translate('2008-11-30','-','') or translate($InvoiceDate,'-','') &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="translate($CurrentDate,'-','')  &gt; translate('2011-01-03','-','')">
																<xsl:attribute name="VATRate">20</xsl:attribute>
															</xsl:when>
															<xsl:when test="translate($CurrentDate,'-','')  &lt;= translate('2008-11-30','-','') or translate($CurrentDate,'-','')  &gt;= translate('2010-01-01','-','')">
																<xsl:attribute name="VATRate">17.5</xsl:attribute>
															</xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="VATRate">15</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
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
	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to yyyy-mm-dd
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : Rave Tech, 26/11/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
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
