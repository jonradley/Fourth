<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Tragus map for invoices and credits to Coda in consolidated format.

 © Fourth Hospitality, 2013.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 					| Description of modification
 ==========================================================================================
 01/10/2012	| A Barber				| FB5749	Created module 
 ==========================================================================================
 08/10/2012	| A Barber				| FB5749	Updates to XPath start positions to be referenced in output.
 ==========================================================================================
 15/01/2013	| A Barber				| FB5749	Updated for output each doc to batch queue, significant logic changes.
==========================================================================================
 17/01/2013	| A Barber				| FB5749	Update credit record line identifier.
==========================================================================================
 31/10/2014	| J Miguel				| FB10072   Strada: New mapper for Invoices and credits 
=======================================================================================
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyInvoiceLinesByAccount" match="InvoiceLine | CreditNoteLine" use="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode)"/>

	<!-- INVOICE -->

	<xsl:template match="/Invoice">
			
		<!-- Store the Company Code -->
		<xsl:variable name="varCompanyCode">
			<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
		</xsl:variable>
		
		<!-- Store the Transaction Type -->
		<xsl:variable name="varTransactionType">
			<xsl:value-of select="script:msPad('PINEDI', 12)"/>
		</xsl:variable>

		<!-- Store the Transaction Number - {blank}-->
		<xsl:variable name="varTransactionNumber">
			<xsl:value-of select="script:msPad('', 12)"/>
		</xsl:variable>
		
		<!-- Store the Transaction Date-->
		<xsl:variable name="varTransactionDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Reference 1 - Invoice Reference -->
		
		<xsl:variable name="varTransactionReference1">
			<xsl:value-of select="script:msPad(concat(InvoiceHeader/InvoiceReferences/InvoiceReference,substring(InvoiceHeader/InvoiceReferences/InvoiceDate,3,2)), 32)"/>
		</xsl:variable>

		<!-- Store the Reference 2 - {blank} -->
		<xsl:variable name="varTransactionReference2">
			<xsl:value-of select="script:msPad('', 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 3 - Original Invoice Number (CRN only) -->
		<xsl:variable name="varTransactionReference3">
			<xsl:value-of select="script:msPad('', 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 4 - Delivery Date-->
		<xsl:variable name="varTransactionReference4">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1]"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Reference 5 - File Sequence Number -->
		<xsl:variable name="varTransactionReference5">
			<xsl:value-of select="script:msPad(InvoiceHeader/BatchInformation/FileGenerationNo, 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 6 - File Transmission Date -->
		<xsl:variable name="varTransactionReference6">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="InvoiceHeader/BatchInformation/SendersTransmissionDate"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Line description -->
		<xsl:variable name="varLineDescription">
			<xsl:value-of select="script:msPad(concat('EDI/',InvoiceHeader/Supplier/SuppliersName), 36)"/>
		</xsl:variable>
		
		<!-- Store the VAT Value - {blank} -->
		<xsl:variable name="varVATValue">
			<xsl:value-of select="script:msPad('', 15)"/>
		</xsl:variable>
		
		<!-- Store Recipient's Branch Reference -->
		<xsl:variable name="varRecipientsBranchReference">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
		</xsl:variable>
		
		<!-- Store Ledger Code -->
		<xsl:variable name="varLedgerCode">
			<xsl:value-of select="InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
		</xsl:variable>
		
		<!-- LF/CR -->
		<xsl:variable name="varNewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!-- INVOICE DETAIL -->			
		<xsl:for-each select="(InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyInvoiceLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode))[1])]">
			
			<xsl:sort select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode)" data-type="text"/>
			
			<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode)"/>
			
			<xsl:value-of select="$varCompanyCode"/>
			<xsl:value-of select="$varTransactionType"/>
			<xsl:value-of select="$varTransactionNumber"/>
			<xsl:value-of select="$varTransactionDate"/>
			<xsl:value-of select="$varTransactionReference1"/>
			<xsl:value-of select="$varTransactionReference2"/>
			<xsl:value-of select="$varTransactionReference3"/>
			<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
			<xsl:value-of select="$varTransactionReference5"/>
			<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>
			
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('158','+.',$varRecipientsBranchReference,'.',substring-before($AccountCode,'+')), 82)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(format-number(sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode) = $AccountCode]/LineDiscountValue),'0.00'),15,2)"/>
			<!-- Vat Code -->
			<xsl:choose>
				<xsl:when test="VATCode='S'">
					<xsl:text>VISTD</xsl:text>
				</xsl:when>
				<xsl:when test="VATCode='Z'">
					<xsl:text>VIZER</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:value-of select="$varLineDescription"/>
			<xsl:value-of select="$varVATValue"/>
			<xsl:value-of select="$varNewLine"/>
			
		</xsl:for-each>
		
		<!-- VAT SUMMARIES -->
		<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
		
			<!-- VAT Code -->
			<xsl:variable name="VATCode">
				<xsl:choose>
					<xsl:when test="@VATCode='S'">
						<xsl:text>VISTD</xsl:text>
					</xsl:when>
					<xsl:when test="@VATCode='Z'">
						<xsl:text>VIZER</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>VIEXP</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<xsl:value-of select="$varCompanyCode"/>
			<xsl:value-of select="$varTransactionType"/>
			<xsl:value-of select="$varTransactionNumber"/>
			<xsl:value-of select="$varTransactionDate"/>
			<xsl:value-of select="$varTransactionReference1"/>
			<xsl:value-of select="$varTransactionReference2"/>
			<xsl:value-of select="$varTransactionReference3"/>
			<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
			<xsl:value-of select="$varTransactionReference5"/>
			<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>
			
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('159','+.000RR53.124200','.',$VATCode), 82)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(VATAmountAtRate, 15, 2)"/>
			<!-- Vat Code -->
			<xsl:value-of select="$VATCode"/>

			<xsl:value-of select="$varLineDescription"/>
			<xsl:value-of select="$varVATValue"/>
			<xsl:value-of select="$varNewLine"/>
				
		</xsl:for-each>
		
		<!-- HEADER RECORD -->
		<xsl:value-of select="$varCompanyCode"/>
		<xsl:value-of select="$varTransactionType"/>
		<xsl:value-of select="$varTransactionNumber"/>
		<xsl:value-of select="$varTransactionDate"/>
		<xsl:value-of select="$varTransactionReference1"/>
		<xsl:value-of select="$varTransactionReference2"/>
		<xsl:value-of select="$varTransactionReference3"/>
		<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
		<xsl:value-of select="$varTransactionReference5"/>
		<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>

		<!-- Account Code String -->
		<xsl:value-of select="script:msPad(concat('157','+.000RR53.122001','.',$varLedgerCode), 82)"/>
		<!-- Value -->
		<xsl:value-of select="script:msPadNumber(InvoiceTrailer/DocumentTotalInclVAT, 15, 2)"/>

		<xsl:value-of select="script:msPad('', 5)"/>
		<xsl:value-of select="$varLineDescription"/>
		<xsl:value-of select="$varVATValue"/>
		<xsl:value-of select="$varNewLine"/>
			
	</xsl:template>
	
	<!-- CREDIT NOTE -->
	
	<xsl:template match="/CreditNote">
			
		<!-- Store the Company Code -->
		<xsl:variable name="varCompanyCode">
			<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
		</xsl:variable>
		
		<!-- Store the Transaction Type -->
		<xsl:variable name="varTransactionType">
			<xsl:value-of select="script:msPad('PCREDI', 12)"/>
		</xsl:variable>

		<!-- Store the Transaction Number - {blank}-->
		<xsl:variable name="varTransactionNumber">
			<xsl:value-of select="script:msPad('', 12)"/>
		</xsl:variable>
		
		<!-- Store the Transaction Date-->
		<xsl:variable name="varTransactionDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Reference 1 - Invoice Reference -->
		
		<xsl:variable name="varTransactionReference1">
			<xsl:value-of select="script:msPad(concat(CreditNoteHeader/CreditNoteReferences/CreditNoteReference,substring(CreditNoteHeader/CreditNoteReferences/CreditNoteDate,3,2)), 32)"/>
		</xsl:variable>

		<!-- Store the Reference 2 - {blank} -->
		<xsl:variable name="varTransactionReference2">
			<xsl:value-of select="script:msPad('', 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 3 - Original Invoice Number (CRN only) -->
		<xsl:variable name="varTransactionReference3">
			<xsl:value-of select="script:msPad(concat(CreditNoteHeader/InvoiceReferences/InvoiceReference,substring(CreditNoteHeader/InvoiceReferences/InvoiceDate,3,2)), 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 4 - Delivery Date-->
		<xsl:variable name="varTransactionReference4">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Reference 5 - File Sequence Number -->
		<xsl:variable name="varTransactionReference5">
			<xsl:value-of select="script:msPad(CreditNoteHeader/BatchInformation/FileGenerationNo, 32)"/>
		</xsl:variable>
		
		<!-- Store the Reference 6 - File Transmission Date -->
		<xsl:variable name="varTransactionReference6">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="ddmmyyyyFormat" select="CreditNoteHeader/BatchInformation/SendersTransmissionDate"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Store the Line description -->
		<xsl:variable name="varLineDescription">
			<xsl:value-of select="script:msPad(concat('EDI/',CreditNoteHeader/Supplier/SuppliersName), 36)"/>
		</xsl:variable>
		
		<!-- Store the VAT Value - {blank} -->
		<xsl:variable name="varVATValue">
			<xsl:value-of select="script:msPad('', 15)"/>
		</xsl:variable>
		
		<!-- Store Recipient's Branch Reference -->
		<xsl:variable name="varRecipientsBranchReference">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
		</xsl:variable>
		
		<!-- Store Ledger Code -->
		<xsl:variable name="varLedgerCode">
			<xsl:value-of select="CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
		</xsl:variable>
		
		<!-- LF/CR -->
		<xsl:variable name="varNewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!-- CREDIT NOTE DETAIL -->			
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine)[generate-id() = generate-id(key('keyInvoiceLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode))[1])]">
			
			<xsl:sort select="translate(LineExtraData/AccountCode,'&quot;','')" data-type="text"/>
			
			<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode)"/>
			
			<xsl:value-of select="$varCompanyCode"/>
			<xsl:value-of select="$varTransactionType"/>
			<xsl:value-of select="$varTransactionNumber"/>
			<xsl:value-of select="$varTransactionDate"/>
			<xsl:value-of select="$varTransactionReference1"/>
			<xsl:value-of select="$varTransactionReference2"/>
			<xsl:value-of select="$varTransactionReference3"/>
			<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
			<xsl:value-of select="$varTransactionReference5"/>
			<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>
			
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('158','+.',$varRecipientsBranchReference,'.',substring-before($AccountCode,'+')), 82)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(-1 * format-number(sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode) = $AccountCode]/LineDiscountValue),'0.00'),15,2)"/>
			<!-- Vat Code -->
			<xsl:choose>
				<xsl:when test="VATCode='S'">
					<xsl:text>VISTD</xsl:text>
				</xsl:when>
				<xsl:when test="VATCode='Z'">
					<xsl:text>VIZER</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:value-of select="$varLineDescription"/>
			<xsl:value-of select="$varVATValue"/>
			<xsl:value-of select="$varNewLine"/>
			
		</xsl:for-each>
		
		<!-- VAT SUMMARIES -->
		<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
		
			<!-- VAT Code -->
			<xsl:variable name="VATCode">
				<xsl:choose>
					<xsl:when test="@VATCode='S'">
						<xsl:text>VISTD</xsl:text>
					</xsl:when>
					<xsl:when test="@VATCode='Z'">
						<xsl:text>VIZER</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>VIEXP</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<xsl:value-of select="$varCompanyCode"/>
			<xsl:value-of select="$varTransactionType"/>
			<xsl:value-of select="$varTransactionNumber"/>
			<xsl:value-of select="$varTransactionDate"/>
			<xsl:value-of select="$varTransactionReference1"/>
			<xsl:value-of select="$varTransactionReference2"/>
			<xsl:value-of select="$varTransactionReference3"/>
			<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
			<xsl:value-of select="$varTransactionReference5"/>
			<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>
			
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('159','+.000RR53.140000','.',$VATCode), 82)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(-1 * VATAmountAtRate, 15, 2)"/>
			<!-- Vat Code -->
			<xsl:value-of select="$VATCode"/>

			<xsl:value-of select="$varLineDescription"/>
			<xsl:value-of select="$varVATValue"/>
			<xsl:value-of select="$varNewLine"/>
				
		</xsl:for-each>
		
		<!-- HEADER RECORD -->
		<xsl:value-of select="$varCompanyCode"/>
		<xsl:value-of select="$varTransactionType"/>
		<xsl:value-of select="$varTransactionNumber"/>
		<xsl:value-of select="$varTransactionDate"/>
		<xsl:value-of select="$varTransactionReference1"/>
		<xsl:value-of select="$varTransactionReference2"/>
		<xsl:value-of select="$varTransactionReference3"/>
		<xsl:value-of select="script:msPad($varTransactionReference4, 32)"/>
		<xsl:value-of select="$varTransactionReference5"/>
		<xsl:value-of select="script:msPad($varTransactionReference6, 32)"/>

		<!-- Account Code String -->
		<xsl:value-of select="script:msPad(concat('157','+.000RR53.122001','.',$varLedgerCode), 82)"/>
		<!-- Value -->
		<xsl:value-of select="script:msPadNumber(-1 * CreditNoteTrailer/DocumentTotalInclVAT, 15, 2)"/>

		<xsl:value-of select="script:msPad('', 5)"/>
		<xsl:value-of select="$varLineDescription"/>
		<xsl:value-of select="$varVATValue"/>
		<xsl:value-of select="$varNewLine"/>
			
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="ddmmyyyyFormat"/>
		<xsl:value-of select="concat(substring($ddmmyyyyFormat,9,2),substring($ddmmyyyyFormat,6,2),substring($ddmmyyyyFormat,1,4))"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		var mbIsFirstLine = true;
		function mbIsNotFirstLine()
		{
			var bIsFirstLine = mbIsFirstLine;
			mbIsFirstLine = false;
			return (!bIsFirstLine);
		}
		
		/*=========================================================================================
		' Routine       	 : msPad
		' Description 	 : Pads the string to the appropriate length
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msPad(vsString, vlLength)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			
			try
			{
				vsString = vsString.substr(0, vlLength);
			}
			catch(e)
			{
				vsString = '';
			}
			
			while(vsString.length < vlLength)
			{
				vsString = vsString + ' ';
			}
			
			return vsString
				
		}

		function msAddPaddingPrefix(vsString, vlLength, vsPrefix)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			while(vsString.length<vlLength)
			{
				vsString = vsPrefix + vsString;
			}
			return vsString.substring(vsString.length - vlLength)
		}
		
		/*=========================================================================================
		' Routine       	 : msPadNumber
		' Description 	 : Pads the number to the appropriate length with appropriate number of implied dps
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : Rave Tech,   18/08/2009 FB3047 Handle negative value totals.
		'						 : R Cambridge, 10/01/2013   5159 For negatives, put minus sign immediately before numeric characters, not at left hand end of the padding
		'========================================================================================*/
		function msPadNumber(vvNumber, vlLength, vlDPs)
		{
			var sNumber = '';
						
			try
			{
				sNumber = vvNumber(0).text;
			}
			catch(e)
			{
				sNumber = vvNumber.toString();
			}
			
			if(sNumber.indexOf('.') != -1)
			{
				var lDPs;
		 
				lDPs = sNumber.length - sNumber.indexOf('.') - 1;
				
				if(lDPs > vlDPs)
				{
					sNumber = sNumber.substr(0, sNumber.length + vlDPs - lDPs);
					vlDPs = 0;
				}
				else
				{
					vlDPs -= lDPs;
				} 
			}
			
			for(var i=0; i<vlDPs; i++)
			{
				sNumber += '0';
			}
			
			sNumber = sNumber.replace('.','');
			
			
			while(sNumber.length < vlLength)
			{
				sNumber = ' ' + sNumber;
			}
			
			
			return sNumber.substr(0, vlLength);
				
		}

	]]></msxsl:script>
	
</xsl:stylesheet>
