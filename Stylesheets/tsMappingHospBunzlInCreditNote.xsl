<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Maps TRADACOMS credit notes into SPEx internal format

BUNZL CreditNotes

 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     	| 
******************************************************************************************
 Date 	     	| Name 				| Description of modification
******************************************************************************************
 18/10/02005 	| Nigel Emsen	|	Created from Bunzl Invoice mapper.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:template match="/Document">
		<BatchRoot>
			<xsl:element name="CreditNote">
				<!-- tradesimple header -->
				<!-- ================== -->
				<xsl:variable name="sRecipientID" select="CDT/L2[2]/L3[1]/L4[1]"/>
				<xsl:variable name="sDeliveryName" select="CLO/L2[2]/L3[1]/L4"/>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="concat($sRecipientID, '/', $sDeliveryName)"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<!-- the CreditNote or credit note header -->
				<!-- ================================= -->
				<xsl:element name="CreditNoteHeader">
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
					<CreditNoteReferences>
						<CreditNoteReference>
							<xsl:value-of select="translate(CRF/L2[2]/L3[1],' ','')"/>
						</CreditNoteReference>
						<CreditNoteDate>
							<xsl:call-template name="msFormatDate">
								<xsl:with-param name="vsDate" select="concat('20', translate(CRF/L2[2]/L3[2],' ',''))"/>
							</xsl:call-template>
						</CreditNoteDate>
						<TaxPointDate>
							<xsl:call-template name="msFormatDate">
								<xsl:with-param name="vsDate" select="concat('20',translate( CRF/L2[2]/L3[3],' ',''))"/>
							</xsl:call-template>
						</TaxPointDate>
					</CreditNoteReferences>
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
									<xsl:if test="CLO/L2[2]/L3[3]/L4[5] != '' ">
										<PostCode>
											<xsl:value-of select="CLO/L2[2]/L3[3]/L4[5]"/>
										</PostCode>
									</xsl:if>
								</DeliveryLocationAddress>
							</xsl:if>
						</DeliveryDetails>
					</xsl:if>
					<Currency>GBP</Currency>
				</xsl:element>
				<!-- the detail lines -->
				<!-- ================ -->
				<xsl:element name="CreditNoteDetail">
					<xsl:for-each select="CLD">
						<xsl:element name="CreditNoteLine">
							<DeliveryNoteReferences>
								<DeliveryNoteReference>
									<xsl:value-of select=" translate(//OIR[position()]/L2[2]/L3[2],' ','')"/>
								</DeliveryNoteReference>
								<DeliveryNoteDate>
									<xsl:call-template name="msFormatDate">
										<xsl:with-param name="vsDate" select="concat('20', translate(//OIR[position()]/L2[2]/L3[3],' ',''))"/>
									</xsl:call-template>
								</DeliveryNoteDate>
							</DeliveryNoteReferences>
							<!-- none mandatory elements -->
							<xsl:variable name="msBarCode" select="translate(L2[2]/L3[2]/L4[1],' ','')"/>
							<xsl:variable name="msBuyersProductCode" select="translate(L2[2]/L3[2]/L4[2],' ','')"/>
							<xsl:variable name="msSuppliersProductCode" select="translate(L2[2]/L3[2]/L4[3],' ','')"/>
							<xsl:variable name="msProductDescription" select="translate(L2[2]/L3[14]/L4[1] ,' ','') "/>
							<xsl:variable name="msQuantityCredited" select="translate(L2[2]/L3[6]/L4[1] ,' ','') "/>
							<xsl:variable name="msUnitValueExclVAT" select="translate(L2[2]/L3[7]/L4[1] ,' ','') "/>
							<xsl:if test="$msBarCode !='' and $msBuyersProductCode  !='' and $msSuppliersProductCode  !='' ">
								<ProductID>
									<xsl:if test="$msBarCode!= '' ">
										<BarCode>
											<xsl:value-of select="$msBarCode"/>
										</BarCode>
									</xsl:if>
									<xsl:if test="$msBuyersProductCode !='' ">
										<BuyersProductCode>
											<xsl:value-of select="$msBuyersProductCode"/>
										</BuyersProductCode>
									</xsl:if>
									<xsl:if test="$msSuppliersProductCode !='' ">
										<SuppliersProductCode>
											<xsl:value-of select="$msSuppliersProductCode"/>
										</SuppliersProductCode>
									</xsl:if>
								</ProductID>
							</xsl:if>
							<xsl:if test="$msProductDescription != ''">
								<ProductDescription>
									<xsl:value-of select="$msProductDescription"/>
								</ProductDescription>
							</xsl:if>
							<xsl:if test="$msQuantityCredited !='' ">
								<QuantityCredited>
									<xsl:value-of select="format-number($msQuantityCredited,'0')"/>
								</QuantityCredited>
							</xsl:if>
							<xsl:if test="$msUnitValueExclVAT !='' ">
								<UnitValueExclVAT>
									<xsl:value-of select="format-number($msUnitValueExclVAT div 10000, '0.0000')"/>
								</UnitValueExclVAT>
							</xsl:if>
							<LineValueExclVAT>
								<xsl:value-of select="format-number(L2[2]/L3[8]/L4[1] div 10000, '0.00')"/>
							</LineValueExclVAT>
							<VATCode>
								<xsl:variable name="msVATCodeValue" select="translate(L2[2]/L3[9],' ','')"/>
								<xsl:choose>
									<xsl:when test="$msVATCodeValue = 'S'">Standard</xsl:when>
									<xsl:when test="$msVATCodeValue = 'Z'">Zero-Rated</xsl:when>
									<xsl:when test="$msVATCodeValue = 'E'">Exempt</xsl:when>
								</xsl:choose>
							</VATCode>
							<VATRate>
								<xsl:value-of select="format-number(L2[2]/L3[10]/L4[1] div 1000, '0.00')"/>
							</VATRate>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<!-- the trailer -->
				<!-- =========== -->
				<xsl:element name="CreditNoteTrailer">
					<DocumentTotalExclVAT>
						<xsl:value-of select="format-number(CTR/L2[2]/L3[5]/L4 div 100, '0.00')"/>
					</DocumentTotalExclVAT>
					<SettlementTotalExclVAT>
						<xsl:value-of select="format-number(CTR/L2[2]/L3[7]/L4 div 100, '0.00')"/>
					</SettlementTotalExclVAT>
					<!-- Filler-In to complete SubTotals -->
					<VATAmount>
						<xsl:value-of select="format-number(CTR/L2[2]/L3[8] div 100, '0.00')"/>
					</VATAmount>
					<DocumentTotalInclVAT>
						<xsl:value-of select="format-number(CTR/L2[2]/L3[9]/L4 div 100, '0.00')"/>
					</DocumentTotalInclVAT>
					<SettlementTotalInclVAT>
						<xsl:value-of select="format-number(CTR/L2[2]/L3[10]/L4 div 100, '0.00')"/>
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
