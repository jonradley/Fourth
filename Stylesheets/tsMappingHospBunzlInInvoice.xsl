<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Maps TRADACOMS invoicesinto SPEx internal format

BUNZL HOSP Invoices

 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     	| 
******************************************************************************************
 Date 	     	| Name 				| Description of modification
******************************************************************************************
 23/08/2006 		| Nigel Emsen	|	Created from Bunzl Spicers Mapper.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">

	<xsl:template match="/Document">
	
		<BatchRoot>
		
			<Invoice>
			
				<xsl:variable name="sRecipientID" select="CDT/L2[2]/L3[1]/L4[1]"/>
				
				<xsl:variable name="sDeliveryName" select="CLO/L2[3]/L3[1]/L4"/>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
					
						<!-- xsl:value-of select="concat($sRecipientID, '/', $sDeliveryName)"/ -->
						<xsl:value-of select="concat($sRecipientID)"/>
					</SendersCodeForRecipient>
					
				</TradeSimpleHeader>
				
				<InvoiceHeader>
				
					<BatchInformation>
					
						<FileGenerationNumber>
						
							<xsl:value-of select="FIL/L2[2]/L3[1]/L4"/>
						</FileGenerationNumber>
						
						
						<FileVersionNumber>
						
							<xsl:value-of select="FIL/L2[2]/L3[2]/L4"/>
							
						</FileVersionNumber>
						
						
						<FileCreationDate>
						
							<xsl:call-template name="msFormatDate">
								<xsl:with-param name="vsDate" select="concat('20', FIL/L2[2]/L3[3]/L4)"/>
							</xsl:call-template>
							
						</FileCreationDate>
						
					</BatchInformation>
					
					<Buyer>
					
						<BuyersLocationID>
						
							<GLN>xx</GLN>
							
							<BuyersCode>xx</BuyersCode>
							
							<SuppliersCode>xx</SuppliersCode>
							
						</BuyersLocationID>
						
						<xsl:if test="CDT/L2/L3[2]/L4 != ''">
						
							<BuyersName>
								<xsl:value-of select="CDT/L2/L3[2]/L4"/>
							</BuyersName>
							
						</xsl:if>
						
						<BuyersAddress>
							<!--shuffle up address lines to avoid blanks-->
							<xsl:for-each select="CDT/L2[2]/L3[3]/L4[position() &lt; 5][not(.='')]">
							
								<xsl:if test="position() &lt; 5 ">
								
									<xsl:element name="{concat('AddressLine', position())}">
										<xsl:value-of select="."/>
									</xsl:element>
									
								</xsl:if>
								
							</xsl:for-each>
							
							<xsl:if test="CDT/L2[2]/L3[3]/L4[5] !='' ">
							
								<PostCode>
									<xsl:value-of select="CDT/L2[2]/L3[3]/L4[5]"/>
								</PostCode>
								
							</xsl:if>
							
						</BuyersAddress>
						
					</Buyer>
					
					<Supplier>
					
						<SuppliersLocationID>
						
							<GLN>xx</GLN>
							
							<BuyersCode>xx</BuyersCode>
							
							<SuppliersCode>xx</SuppliersCode>
							
						</SuppliersLocationID>
						
						<xsl:if test="SDT/L2[2]/L3[2]/L4 != ''">
						
							<SuppliersName>
								<xsl:value-of select="SDT/L2[2]/L3[2]/L4"/>
							</SuppliersName>
							
						</xsl:if>
						<!--
							<SuppliersAddress>
								<AddressLine1>xx</AddressLine1>
								<AddressLine2>xx</AddressLine2>
								<AddressLine3>xx</AddressLine3>
								<AddressLine4>xx</AddressLine4>
								<PostCode>String</PostCode>
							</SuppliersAddress>
						-->
						
					</Supplier>
					
					<ShipTo>
					
						<ShipToLocationID>
						
							<GLN>xx</GLN>
							
							<BuyersCode>xx</BuyersCode>
							
							<SuppliersCode>xx</SuppliersCode>
							
						</ShipToLocationID>
						
						<ShipToName>
						
							<xsl:value-of select="CLO/L2/L3[2]/L4"/>
							
						</ShipToName>
						
						<xsl:if test="CLO/L2[2]/L3[3]/L4 != ''">
						
							<ShipToAddress>
							
								<!--shuffle up address lines to avoid blanks-->
								<xsl:for-each select="CLO/L2[2]/L3[3]/L4[position() &lt; 4][not(.='')]">
								
									<xsl:if test="position() &lt; 5 ">
									
										<xsl:element name="{concat('AddressLine', position())}">
											<xsl:value-of select="."/>
											
										</xsl:element>
										
									</xsl:if>
									
								</xsl:for-each>
								
								<PostCode>
									<xsl:value-of select="CLO/L2[2]/L3[3]/L4[5]"/>
								</PostCode>
								
							</ShipToAddress>
							
						</xsl:if>
						
					</ShipTo>
					
					<InvoiceReferences>
					
						<InvoiceReference>
						
							<xsl:value-of select="IRF/L2[2]/L3[1]/L4"/>
							
						</InvoiceReference>
						
						<InvoiceDate>
						
							<xsl:call-template name="msFormatDate">
								<xsl:with-param name="vsDate" select="concat('20', IRF/L2[2]/L3[2]/L4)"/>
							</xsl:call-template>
							
						</InvoiceDate>
						
						<TaxPointDate>
						
							<xsl:call-template name="msFormatDate">
								<xsl:with-param name="vsDate" select="concat('20', IRF/L2[2]/L3[3]/L4)"/>
							</xsl:call-template>
							
						</TaxPointDate>
						
						<!-- Bunzls VAT Reg No. -->
						<VATRegNo>181501390</VATRegNo>
						
						<InvoiceMatchingDetails>
							<!--
								<MatchingStatus>Passed</MatchingStatus>
								<MatchingDate>1967-08-13</MatchingDate>
								<MatchingTime>14:20:00-05:00</MatchingTime>
								<GoodsReceivedNoteReference>xx</GoodsReceivedNoteReference>
								<GoodsReceivedNoteDate>1967-08-13</GoodsReceivedNoteDate>
								<DebitNoteReference>xx</DebitNoteReference>
								<DebitNoteDate>1967-08-13</DebitNoteDate>
								<CreditNoteReference>xx</CreditNoteReference>
								<CreditNoteDate>1967-08-13</CreditNoteDate>
							-->
						</InvoiceMatchingDetails>
						
					</InvoiceReferences>
					
					<!--
						<Currency>xx</Currency>
						<SequenceNumber>2</SequenceNumber>
					-->
					
				</InvoiceHeader>
				
				<InvoiceDetail>
				
					<xsl:for-each select="ILD">
					
						<InvoiceLine>
						
							<LineNumber>
								<xsl:value-of select="position()"/>
							</LineNumber>
							
							<PurchaseOrderReferences>
							
								<PurchaseOrderReference>
									<xsl:value-of select="/Document/ODD/L2[2]/L3[2]/L4[1]"/>
								</PurchaseOrderReference>
								
								<!--PurchaseOrderDate>1967-08-13</PurchaseOrderDate -->
								<!--PurchaseOrderTime>14:20:00-05:00</PurchaseOrderTime-->
								
								<!--
									<TradeAgreement>
										<ContractReference>xx</ContractReference>
										<ContractDate>1967-08-13</ContractDate>
									</TradeAgreement>
								-->
								
								<!--
									<CustomerPurchaseOrderReference>xx</CustomerPurchaseOrderReference>
									<JobNumber>xx</JobNumber>
								-->
								
							</PurchaseOrderReferences>
							
							<!--
								<PurchaseOrderConfirmationReferences>
								<PurchaseOrderConfirmationReference>xx</PurchaseOrderConfirmationReference>
								<PurchaseOrderConfirmationDate>1967-08-13</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
							-->
							
							<DeliveryNoteReferences>
							
								<DeliveryNoteReference>
									<xsl:value-of select="/Document/ODD/L2[2]/L3[3]/L4[1]"/>
								</DeliveryNoteReference>
								
								<DeliveryNoteDate>
								
									<xsl:call-template name="msFormatDate">
										<xsl:with-param name="vsDate" select="concat('20', /Document/ODD/L2[2]/L3[3]/L4[2])"/>
									</xsl:call-template>
									
								</DeliveryNoteDate>
								
								<!--
									<DespatchDate>1967-08-13</DespatchDate>
								-->
								
							</DeliveryNoteReferences>
							
							<!--
								<GoodsReceivedNoteReferences>
								<GoodsReceivedNoteReference>xx</GoodsReceivedNoteReference>
								<GoodsReceivedNoteDate>1967-08-13</GoodsReceivedNoteDate>
								</GoodsReceivedNoteReferences>
							-->
							
							<ProductID>
							
								<GTIN>
									<xsl:value-of select="vbscript:msPopulateBarcode(L2[2]/L3[3]/L4[1], L2[2]/L3[3]/L4[2]) "/>
								</GTIN>
								
								<xsl:if test="L2[2]/L3[3]/L4[2] != ''">
								
									<SuppliersProductCode>
										<xsl:value-of select="L2[2]/L3[3]/L4[2]"/>
									</SuppliersProductCode>
									
								</xsl:if>
								
								<xsl:if test="L2[2]/L3[5]/L4[2] != ''">
								
									<BuyersProductCode>
										<xsl:value-of select="L2[2]/L3[5]/L4[2]"/>
									</BuyersProductCode>
									
								</xsl:if>
								
							</ProductID>
							
							<xsl:choose>
							
								<xsl:when test="L2[2]/L3[14]/L4[1] != ''">
								
									<ProductDescription>
										<xsl:value-of select="L2[2]/L3[14]/L4[1]"/>
									</ProductDescription>
									
								</xsl:when>
								
								<xsl:otherwise>
								
									<ProductDescription>Not Provided</ProductDescription>
								</xsl:otherwise>
								
							</xsl:choose>
							
							<!--
								<OrderedQuantity UnitOfMeasure="Text">3.14159</OrderedQuantity>
								<ConfirmedQuantity UnitOfMeasure="Text">3.14159</ConfirmedQuantity>
								<DeliveredQuantity UnitOfMeasure="Text">3.14159</DeliveredQuantity>
							-->
							
							<InvoicedQuantity UnitOfMeasure="Text">
								<xsl:value-of select="format-number(L2[2]/L3[7]/L4[1],'0')"/>
							</InvoicedQuantity>
							
							<!--
								<PackSize>xx</PackSize>
							-->
							
							<UnitValueExclVAT>
								<xsl:value-of select="format-number(L2[2]/L3[8]/L4[1] div 10000, '0.0000')"/>
							</UnitValueExclVAT>
							
							<LineValueExclVAT>
								<xsl:value-of select="format-number(L2[2]/L3[9]/L4[1] div 10000, '0.00')"/>
							</LineValueExclVAT>
							
							<!--
								<LineDiscountRate>xx</LineDiscountRate>
								<LineDiscountValue>xx</LineDiscountValue>
							-->
							
							<VATCode>
							
								<xsl:choose>
									<xsl:when test="L2[2]/L3[10]/L4[1] = 'S'">Standard</xsl:when>
									<xsl:when test="L2[2]/L3[10]/L4[1] = 'Z'">Zero-Rated</xsl:when>
									<xsl:when test="L2[2]/L3[10]/L4[1] = 'E'">Exempt</xsl:when>
								</xsl:choose>
								
							</VATCode>
							
							<VATRate>
								<xsl:value-of select="format-number(L2[2]/L3[11]/L4[1] div 1000, '0.00')"/>
							</VATRate>
							
							<!--
								<NetPriceFlag>1</NetPriceFlag>
							-->
							
							<!--
								<Measure>
									<UnitsInPack>xx</UnitsInPack>
									<OrderingMeasure>xx</OrderingMeasure>
									<MeasureIndicator>xx</MeasureIndicator>
									<TotalMeasure>xx</TotalMeasure>
									<TotalMeasureIndicator>xx</TotalMeasureIndicator>
								</Measure>
							-->
							
							<!-- LineExtraData/ -->
							
						</InvoiceLine>
						
					</xsl:for-each>
					
				</InvoiceDetail>
				
				<InvoiceTrailer>
				
					<NumberOfLines>
						<xsl:value-of select="count(//ILD)"/>
					</NumberOfLines>
					
					<!--
					<DocumentDiscountRate>xx</DocumentDiscountRate>
					<SettlementDiscountRate SettlementDiscountDays="2">3.14159</SettlementDiscountRate>
					-->
					
					<VATSubTotals>
					
						<xsl:for-each select="STL">
						
							<VATSubTotal>
							
								<xsl:attribute name="VATCode"><xsl:choose><xsl:when test="L2[2]/L3[2]/L4 = 'S'">Standard</xsl:when><xsl:when test="L2[2]/L3[2]/L4 = 'Z'">Zero-Rated</xsl:when><xsl:when test="L2[2]/L3[2]/L4 = 'E'">Exempt</xsl:when></xsl:choose></xsl:attribute>
								<xsl:attribute name="VATRate"><xsl:value-of select="format-number(L2[2]/L3[3]/L4 div 1000, '0.00')"/></xsl:attribute>

								<DocumentTotalExclVATAtRate>
									<xsl:value-of select="format-number(L2[2]/L3[10]/L4 div 100, '0.00')"/>
								</DocumentTotalExclVATAtRate>
								
								<SettlementTotalExclVATAtRate>
									<xsl:value-of select="format-number(L2[2]/L3[12]/L4 div 100, '0.00')"/>
								</SettlementTotalExclVATAtRate>
								
								<VATAmountAtRate>
									<xsl:value-of select="format-number(L2[2]/L3[13]/L4 div 100, '0.00')"/>
								</VATAmountAtRate>
								
								<DocumentTotalInclVATAtRate>
									<xsl:value-of select="format-number(L2[2]/L3[14]/L4 div 100, '0.00')"/>
								</DocumentTotalInclVATAtRate>
								
								<SettlementTotalInclVATAtRate>
									<xsl:value-of select="format-number(L2[2]/L3[15]/L4 div 100, '0.00')"/>
								</SettlementTotalInclVATAtRate>
								
								<VATTrailerExtraData/>
								
							</VATSubTotal>
							
						</xsl:for-each>
						
					</VATSubTotals>

					<VATAmount>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[10]/L4  div 100, '0.00')"/>
					</VATAmount>
					
					<DocumentTotalInclVAT>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[11]/L4 div 100, '0.00')"/>
					</DocumentTotalInclVAT>
					
					<SettlementTotalInclVAT>		
						<xsl:value-of select="format-number(TLR/L2[2]/L3[12]/L4 div 100, '0.00')"/>
					</SettlementTotalInclVAT>
					
					<TrailerExtraData/>
					
				</InvoiceTrailer>

			</Invoice>
			
		</BatchRoot>
		
	</xsl:template>
	
	<xsl:template name="msFormatDate">
		<xsl:param name="vsDate"/>
		<xsl:value-of select="concat(substring($vsDate,1,4), '-', substring($vsDate,5,2), '-', substring($vsDate,7,2))"/>
	</xsl:template>
	
	<xsl:template name="msCalculateVATRate">
		<xsl:param name="vsVATAmount"/>
		<xsl:param name="vsLineCost"/>
		<xsl:value-of select="format-number(($vsVATAmount * 100) div $vsLineCost, '#.0')"/>
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 

	Function msFormatNumber(inputValue, inputValue2, inputValue3)
	Dim vlTotal
	Dim vlDiv
	Dim vlRoundTo
	
		If not IsNumeric(inputValue.item(0).nodeTypedValue) then
			msFormatNumber = "parse error: " & inputValue.item(0).nodeTypedValue
			Exit Function
		End If
		
		vlTotal = CDbl(inputValue.item(0).nodeTypedValue)
		vlDiv = CLng(inputValue2)
		If isnumeric(inputValue3) then
			vlRoundTo = CLng(inputValue3)
			msFormatNumber = round(((vlTotal / vlDiv) + 0.000001), vlRoundTo)
		Else
			msFormatNumber = CStr(vlTotal / vlDiv)
		End If
		
	End Function
	
'	Function msCalculateSettlement(inputValue, inputValue2)
'	Dim vlTotal
'	Dim vlSettDisc
'	Dim vsSettlementDisc
'	
'		vlTotal = CDbl(inputValue.item(0).nodeTypedValue)
'		vsSettlementDisc = inputValue2.item(0).nodeTypedValue
'		
'		If trim(vsSettlementDisc) <> "" Then
'			vlSettDisc = CDbl(0)
'		End If
'		
'		' Assumed 2 dp
'		msCalculateSettlement = CStr(round((vlTotal - vlSettDisc)/100), 2)
'	
'	End Function

	Function msCalculateSettlementRate(inputValue, inputValue2)
	Dim vlTotal
	Dim vlSettDisc
	Dim vlSettlementTotal
	
		vlTotal = inputValue.item(0).nodeTypedValue
		vsSettlementTotal = inputValue2.item(0).nodeTypedValue
		
		' Assumed 2 dp
		msCalculateSettlementRate = CStr(round(((vlTotal - vsSettlementTotal)/vlTotal) * 100, 2))
	
	End Function


	Function msPopulateBarcode(vsBar1, vsBar2)
		
	Dim sBarcode
	
		vsBar1 = vsBar1.item(0).nodeTypedValue
		
		If Trim(vsBar1) <> "" Then
			sBarcode = vsBar1
		Else
			sBarcode = vsBar2.item(0).nodeTypedValue
		End If
		
		msPopulateBarcode = Trim(sBarcode)
		
	End Function
	

	]]></msxsl:script>

</xsl:stylesheet>
