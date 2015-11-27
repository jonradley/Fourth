<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Hospitality Credit Note
 into a Coda Credit Note XML file for TCG

 © Alternative Business Solutions Ltd., 2015.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 28/10/2015 | J Miguel   | FB 10531 - Created
******************************************************************************************
 13/11/2015 | J Miguel   | FB 10602 - Amend code mapping
******************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct credit note line information (note the '::' literal is simply used as a convenient separator for the 2 values that make up the second key)-->
	<xsl:key name="keyCreditLinesByLedgerCode" match="CreditNoteLine" use="LineExtraData/CodaLedgerCode"/>
	<xsl:key name="keyCreditLinesByLedgerAndVATCode" match="CreditNoteDetail/CreditNoteLine" use="concat(LineExtraData/CodaLedgerCode,'::',LineExtraData/CodaVATCode)"/>
	
	<xsl:template match="/CreditNote">
		<xsl:variable name="HouseNumber" select="user:translateCustomersUnitCode(string(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode))"/>
		<xsl:variable name="SupplierAccount" select="user:translateCustomersSupplierCode(string(TradeSimpleHeader/RecipientsCodeForSender))"/>
		
		<!--Check for missing fields-->
		<xsl:if test="not(CreditNoteHeader/HeaderExtraData/CodaPLAccount1) or not(TradeSimpleHeader/RecipientsCodeForSender) or not(CreditNoteHeader/HeaderExtraData/CodaPLAccount2)">
			<xsl:value-of select="user:mRaiseError()"/>
		</xsl:if>
		<ABSformatEDIdocument>
			<coda-document-code>PCEDI</coda-document-code>
			<supplier-invoice-date>
				<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</supplier-invoice-date>
			<year>
				<xsl:value-of select="substring(CreditNoteHeader/HeaderExtraData/FinancialPeriod,1,4)"/>
			</year>
			<period>
				<xsl:value-of select="substring(CreditNoteHeader/HeaderExtraData/FinancialPeriod,5,2)"/>
			</period>
			<supplier-invoice-number>
				<xsl:text>C</xsl:text>
				<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			</supplier-invoice-number>
			<file-generation-and-version>
				<xsl:value-of select="CreditNoteHeader/BatchInformation/FileGenerationNo"/>
				<xsl:text>.</xsl:text>
				<xsl:value-of select="CreditNoteHeader/BatchInformation/FileVersionNo"/>
			</file-generation-and-version>
			<edi-sequence>
				<xsl:value-of select="CreditNoteHeader/SequenceNumber"/>
			</edi-sequence>
			<delivery-date>
				<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
			</delivery-date>
			<batch-reference>
				<xsl:value-of select="CreditNoteHeader/HeaderExtraData/CodaBatchID"/>
			</batch-reference>
			<summary-line>
				<pl-control-account>
					<xsl:value-of select="CreditNoteHeader/HeaderExtraData/CodaPLAccount1"/>
				</pl-control-account>
				<supplier-account>
					<xsl:value-of select="$SupplierAccount"/>
				</supplier-account>
				<house-number>
					<xsl:value-of select="CreditNoteHeader/HeaderExtraData/CodaPLAccount2"/>
				</house-number>
				<summary-line-description>EDI Credit Note</summary-line-description>
				<summary-line-value>
					<xsl:value-of select="format-number(CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
				</summary-line-value>
				<summary-line-type>Debit</summary-line-type>
				<tax-summary-value>
					<xsl:value-of select="format-number(CreditNoteTrailer/VATAmount,'0.00')"/>
				</tax-summary-value>
			</summary-line>
			<analysis-lines>
				<!-- use the Muenchian method (i.e. uses keys) for grouping Credit Note Lines by Coda Ledger Code and then by Coda VAT Code -->
				<!-- the first loop will match the first credit line in each set of lines grouped by Coda Ledger Code -->
				<xsl:for-each select="CreditNoteDetail/CreditNoteLine[generate-id() = generate-id(key('keyCreditLinesByLedgerCode',LineExtraData/CodaLedgerCode)[1])]">
					<xsl:sort select="LineExtraData/CodaLedgerCode" data-type="text"/>
					<xsl:variable name="LedgerCode" select="LineExtraData/CodaLedgerCode"/>
					<!-- now, given we can find all credit lines for the current Coda Ledger Code, loop through and match the first line for each unique Coda VAT code -->
					<xsl:for-each select="key('keyCreditLinesByLedgerCode',$LedgerCode)[generate-id() = generate-id(key('keyCreditLinesByLedgerAndVATCode',concat($LedgerCode,'::',LineExtraData/CodaVATCode))[1])]">
						<xsl:sort select="LineExtraData/CodaVATCode" data-type="text"/>
						<xsl:variable name="VATCode" select="LineExtraData/CodaVATCode"/>
						<!-- now that we have our distinct and sorted list of lines we can output the required analysis lines -->
						<xsl:variable name="LineValue" select="sum(key('keyCreditLinesByLedgerAndVATCode',concat($LedgerCode,'::',$VATCode))/LineValueExclVAT)"/>
						<analysis-line>
							<nominal-account>
								<xsl:value-of select="$LedgerCode"/>
							</nominal-account>
							<house-number>
								<xsl:value-of select="$HouseNumber"/>
							</house-number>
							<detail-line-description>
								<xsl:choose>
									<xsl:when test="not(DeliveryNoteReferences/DeliveryNoteDate)">Unknown Delivery Date EDI</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="DeliveryNoteReferences/DeliveryNoteDate"/>
										<xsl:text> EDI</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-description>
							<detail-line-value>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">
										<xsl:value-of select="format-number(-1 * $LineValue, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number($LineValue, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-value>
							<detail-line-type>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">Debit</xsl:when>
									<xsl:otherwise>Credit</xsl:otherwise>
								</xsl:choose>
							</detail-line-type>
							<detail-line-tax-code>
								<xsl:value-of select="$VATCode"/>
							</detail-line-tax-code>
							<detail-line-tax-value>
								<xsl:choose>
									<xsl:when test="$LineValue &lt; 0">
										<xsl:value-of select="format-number(-1 * VATRate * $LineValue div 100, '0.00')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(VATRate * $LineValue div 100, '0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</detail-line-tax-value>
						</analysis-line>
					</xsl:for-each>
				</xsl:for-each>
			</analysis-lines>
			<tax-lines>
				<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
					<tax-line>
						<tax-account-element-1>
							<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/CodaVATNominalCode"/>
						</tax-account-element-1>
						<tax-account-element-2>
							<xsl:value-of select="VATTrailerExtraData/CodaVATCode"/>
						</tax-account-element-2>
						<tax-line-description>EDI Credit Note</tax-line-description>
						<tax-line-value>
							<xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/>
						</tax-line-value>
						<tax-line-type>Credit</tax-line-type>
						<tax-line-tax-code>
							<xsl:value-of select="VATTrailerExtraData/CodaVATCode"/>
						</tax-line-tax-code>
						<tax-line-tax-turnover>
							<xsl:value-of select="format-number(DocumentTotalExclVATAtRate,'0.00')"/>
						</tax-line-tax-turnover>
					</tax-line>
				</xsl:for-each>
			</tax-lines>
		</ABSformatEDIdocument>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteDate">
		<xsl:value-of select="substring(.,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
		var mapCustomerCodeTCGtoST =
		{
			'5004' : '3500701',
			'3010' : '3500702',
			'5640' : '3500703',
			'2768' : '3500704',
			'6047' : '3500705',
			'2825' : '3500706',
			'5576' : '3500707',
			'948' : '3500708',
			'2618' : '3500709',
			'3813' : '3500710',
			'691' : '3500711',
			'5153' : '3500712',
			'562' : '3500713',
			'3953' : '3500714',
			'1672' : '3500715',
			'6213' : '3500716',
			'1691' : '3500717',
			'1277' : '3500718',
			'949' : '3500719',
			'151' : '3500720',
			'895' : '3500721',
			'887' : '3500722',
			'890' : '3500723',
			'4814' : '3500724',
			'894' : '3500725',
			'1823' : '3500726',
			'1557' : '3500727',
			'1794' : '3500728',
			'6536' : '3500729',
			'2741' : '3500730',
			'6597' : '3500731',
			'1165' : '3500732',
			'3070' : '3500733',
			'777' : '3500734',
			'6605' : '3500735',
			'921' : '3500736',
			'3086' : '3500737',
			'1774' : '3500738',
			'953' : '3500739',
			'789' : '3500740',
			'955' : '3500741',
			'381' : '3500742',
			'1093' : '3500743',
			'966' : '3500744',
			'737' : '3500745',
			'3976' : '3500746',
			'577' : '3500747',
			'3074' : '3500748',
			'925' : '3500749',
			'764' : '3500750',
			'1467' : '3500751',
			'975' : '3500752',
			'2204' : '3500753'
		};
		
		function translateCustomersUnitCode (strOriginalUnitCode)
		{
			var strSTCustomersUnitCode = mapCustomerCodeTCGtoST[strOriginalUnitCode];
			if (strSTCustomersUnitCode == null)
			{
				strSTCustomersUnitCode = strOriginalUnitCode;
			}
			return strSTCustomersUnitCode;
		}
				
		var mapCustomersSupplierCodeTCGToST =
		{
			'BRA010':'S20293538800',
			'BRA008':'S20293538800',  
			'BRA015':'S20293538800',
			'MJS001':'S34824145700',
			'CLA012':'S52470764800',
			'CAR019':'S67900581201',
			'ZEN003':'S67907300600'		
		};
		
		function translateCustomersSupplierCode (strOriginalSupplierCode)
		{
			var strSTCustomersSupplierCode = mapCustomersSupplierCodeTCGToST[strOriginalSupplierCode];
			if (strSTCustomersSupplierCode == null)
			{
				strSTCustomersSupplierCode = strOriginalSupplierCode;
			}
			return strSTCustomersSupplierCode;
		}

		function mRaiseError()
		{}
	]]></msxsl:script>
</xsl:stylesheet>
