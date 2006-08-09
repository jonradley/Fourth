<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Maps TRADACOMS invoices/credit notes into SPEx internal format

BUNZL Invoices

 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     	| 
******************************************************************************************
 Date 	     	| Name 				| Description of modification
******************************************************************************************
 18/10/02005 	| Nigel Emsen	|	Created from Acco Eastlight mapper.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:template match="/Document">
		<BatchRoot>
			<xsl:element name="Invoice">
				<!-- tradesimple header -->
				<!-- ================== -->
				<xsl:variable name="sRecipientID" select="CDT/L2[2]/L3[1]/L4[1]"/>
				<xsl:variable name="sDeliveryName" select="CLO/L2[2]/L3[1]/L4"/>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="concat($sRecipientID, '/', $sDeliveryName)"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<!-- the invoice or credit note header -->
				<!-- ================================= -->
				<xsl:element name="InvoiceHeader">
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
						<xsl:if test="SDT/L2[2]/L3[2]/L4 != ''">
							<SuppliersName>
								<xsl:value-of select="SDT/L2[2]/L3[2]/L4"/>
							</SuppliersName>
						</xsl:if>
						<SuppliersVATRegNo>181501390</SuppliersVATRegNo>
						<xsl:if test="CDT/L2/L3[2]/L4 != ''">
							<CustomersName>
								<xsl:value-of select="CDT/L2/L3[2]/L4"/>
							</CustomersName>
						</xsl:if>
						<xsl:if test="CDT/L2[2]/L3[3]/L4[1] != ''">
							<CustomersAddress>
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
							</CustomersAddress>
						</xsl:if>
					</BatchInformation>
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
					</InvoiceReferences>
					<xsl:if test="CLO/L2/L3[2]/L4 != ''">
						<DeliveryDetails>
							<DeliveryLocationName>
								<xsl:value-of select="CLO/L2/L3[2]/L4"/>
							</DeliveryLocationName>
							<xsl:if test="CLO/L2[2]/L3[3]/L4 != ''">
								<DeliveryLocationAddress>
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
								</DeliveryLocationAddress>
							</xsl:if>
						</DeliveryDetails>
					</xsl:if>
					<Currency>GBP</Currency>
				</xsl:element>
				<!-- the detail lines -->
				<!-- ================ -->
				<xsl:element name="InvoiceDetail">
					<xsl:for-each select="ILD">
						<xsl:element name="InvoiceLine">
							<DeliveryNoteReferences>
								<DeliveryNoteReference>
									<xsl:value-of select="/Document/ODD/L2[2]/L3[3]/L4[1]"/>
								</DeliveryNoteReference>
								<DeliveryNoteDate>
									<xsl:call-template name="msFormatDate">
										<xsl:with-param name="vsDate" select="concat('20', /Document/ODD/L2[2]/L3[3]/L4[2])"/>
									</xsl:call-template>
								</DeliveryNoteDate>
							</DeliveryNoteReferences>
							<PurchaseOrderReferences>
								<PurchaseOrderReference>
									<xsl:value-of select="/Document/ODD/L2[2]/L3[2]/L4[1]"/>
								</PurchaseOrderReference>
							</PurchaseOrderReferences>
							<ProductID>
								<BarCode>
									<xsl:value-of select="vbscript:msPopulateBarcode(L2[2]/L3[3]/L4[1], L2[2]/L3[3]/L4[2]) "/>
								</BarCode>
								<xsl:if test="L2[2]/L3[5]/L4[2] != ''">
									<BuyersProductCode>
										<xsl:value-of select="L2[2]/L3[5]/L4[2]"/>
									</BuyersProductCode>
								</xsl:if>
								<xsl:if test="L2[2]/L3[3]/L4[2] != ''">
									<SuppliersProductCode>
										<xsl:value-of select="L2[2]/L3[3]/L4[2]"/>
									</SuppliersProductCode>
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
							<QuantityInvoiced>
								<xsl:value-of select="format-number(L2[2]/L3[7]/L4[1],'0')"/>
							</QuantityInvoiced>
							<UnitValueExclVAT>
								<xsl:value-of select="format-number(L2[2]/L3[8]/L4[1] div 10000, '0.0000')"/>
							</UnitValueExclVAT>
							<LineValueExclVAT>
								<xsl:value-of select="format-number(L2[2]/L3[9]/L4[1] div 10000, '0.00')"/>
							</LineValueExclVAT>
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
						</xsl:element>
					</xsl:for-each>
					<xsl:for-each select="STL">
						<!-- If we have the SURA element being non-blank then we have a delivery charge line-->
						<xsl:if test="L2[2]/L3[9]/L4[1] !=''">
							<xsl:element name="InvoiceLine">
								<DeliveryNoteReferences>
									<DeliveryNoteReference>
										<xsl:value-of select="/Document/ODD/L2[2]/L3[3]/L4[1]"/>
									</DeliveryNoteReference>
									<DeliveryNoteDate>
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsDate" select="concat('20', /Document/ODD/L2[2]/L3[3]/L4[2])"/>
										</xsl:call-template>
									</DeliveryNoteDate>
								</DeliveryNoteReferences>
								<ProductID>
									<BarCode>0000000000000</BarCode>
									<BuyersProductCode>DELCHRG</BuyersProductCode>
								</ProductID>
								<ProductDescription>Delivery Charge</ProductDescription>
								<QuantityInvoiced>1</QuantityInvoiced>
								<UnitValueExclVAT>
									<xsl:value-of select="format-number(L2[2]/L3[9]/L4[1] div 10000, '0.0000')"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="format-number(L2[2]/L3[9]/L4[1] div 10000, '0.0000')"/>
								</LineValueExclVAT>
								<VATCode>
									<xsl:choose>
										<xsl:when test="L2[2]/L3[3]/L4[1] = 'S'">Standard</xsl:when>
										<xsl:when test="L2[2]/L3[3]/L4[1] = 'Z'">Zero-Rated</xsl:when>
										<xsl:when test="L2[2]/L3[3]/L4[1] = 'E'">Exempt</xsl:when>
									</xsl:choose>
								</VATCode>
								<VATRate>
									<xsl:value-of select="format-number(L2[2]/L3[4]/L4[1] div 1000, '0.00')"/>
								</VATRate>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
				<!-- the trailer -->
				<!-- =========== -->
				<xsl:element name="InvoiceTrailer">
					<SettlementDiscountRate>
						<xsl:value-of select="vbscript:msCalculateSettlementRate(TLR/L2[2]/L3[7]/L4, TLR/L2[2]/L3[9]/L4)"/>
					</SettlementDiscountRate>
					<DocumentTotalExclVAT>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[7]/L4 div 100, '0.00')"/>
					</DocumentTotalExclVAT>
					<SettlementTotalExclVAT>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[9]/L4 div 100, '0.00')"/>
					</SettlementTotalExclVAT>
					<!--VATSubtotals -->
					<xsl:element name="VATSubtotals">
						<xsl:for-each select="STL">
							<xsl:element name="VATSubtotal">
								<VATCode>
									<xsl:choose>
										<xsl:when test="L2[2]/L3[2]/L4 = 'S'">Standard</xsl:when>
										<xsl:when test="L2[2]/L3[2]/L4 = 'Z'">Zero-Rated</xsl:when>
										<xsl:when test="L2[2]/L3[2]/L4 = 'E'">Exempt</xsl:when>
									</xsl:choose>
								</VATCode>
								<VATRate>
									<xsl:value-of select="format-number(L2[2]/L3[3]/L4 div 1000, '0.00')"/>
								</VATRate>
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
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<VATAmount>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[10]/L4  div 100, '0.00')"/>
					</VATAmount>
					<DocumentTotalInclVAT>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[11]/L4 div 100, '0.00')"/>
					</DocumentTotalInclVAT>
					<SettlementTotalInclVAT>
						<xsl:value-of select="format-number(TLR/L2[2]/L3[12]/L4 div 100, '0.00')"/>
					</SettlementTotalInclVAT>
				</xsl:element>
			</xsl:element>
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
