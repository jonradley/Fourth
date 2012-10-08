<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/BatchRoot">
		<!-- Invoices -->
		<xsl:for-each select="Invoice">
			<!-- INVOICE DETAIL -->
			<xsl:for-each select="InvoiceDetail/InvoiceLine">
				<!-- Company Code -->
				<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
				<!-- Transaction Type -->
				<xsl:value-of select="script:msPad('PINEDI', 12)"/>
				<!-- Transaction Number - {blank}-->
				<xsl:value-of select="script:msPad('', 12)"/>
				<!-- Transaction Date -->
				<xsl:value-of select="concat(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,9,2), substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,6,2), substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,4))"/>
				<!-- Reference 1 - Invoice Reference -->
				<xsl:value-of select="script:msPad(../../InvoiceHeader/InvoiceReferences/InvoiceReference, 32)"/>
				<!-- Reference 2 - {blank} -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 3 - Original Invoice Number (CRN only) -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 4 - Delivery Date -->
				<xsl:value-of select="script:msPad(concat(substring(DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(DeliveryNoteReferences/DeliveryNoteDate[1],1,4)), 32)"/>
				<!-- Reference 5 - File Sequence Number -->
				<xsl:value-of select="script:msPad(../../InvoiceHeader/BatchInformation/FileGenerationNo, 32)"/>
				<!-- Reference 6 - File Transmission Date -->
				<xsl:value-of select="script:msPad(concat(substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,9,2),substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,6,2),substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
				<!-- Line Type -->
				<xsl:text>158</xsl:text>
				<!-- Account Code String -->
				<xsl:value-of select="script:msPad(concat('+.',../../TradeSimpleHeader/RecipientsBranchReference,'.',LineExtraData/AccountCode), 79)"/>
				<!-- Value -->
				<xsl:value-of select="script:msPadNumber(LineValueExclVAT, 15, 2)"/>
				<!-- Vat Code -->
				<xsl:choose>
					<xsl:when test="VATCode = 'S'">
						<xsl:text>VISTD</xsl:text>
					</xsl:when>
					<xsl:when test="VATCode = 'Z'">
						<xsl:text>VIZER</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>VIEXP</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Line description -->
				<xsl:value-of select="script:msPad(concat('EDI/',../../InvoiceHeader/Supplier/SuppliersName), 36)"/>
				<!-- VAT Value - {blank} -->
				<xsl:value-of select="script:msPad('', 15)"/>
				<!-- LF/CR -->
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			<!-- VAT SUMMARIES -->
			<xsl:for-each select="InvoiceTrailer/VATSubTotals">
				<xsl:variable name="VATCode">
					<xsl:choose>
						<xsl:when test="VATSubTotal/@VATCode = 'S'">
							<xsl:text>VISTD</xsl:text>
						</xsl:when>
						<xsl:when test="VATSubTotal/@VATCode = 'Z'">
							<xsl:text>VIZER</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>VIEXP</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Company Code -->
				<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
				<!-- Transaction Type -->
				<xsl:value-of select="script:msPad('PINEDI', 12)"/>
				<!-- Transaction Number - {blank}-->
				<xsl:value-of select="script:msPad('', 12)"/>
				<!-- Transaction Date -->
				<xsl:value-of select="concat(substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,9,2), substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,6,2), substring(../../InvoiceHeader/InvoiceReferences/InvoiceDate,1,4))"/>
				<!-- Reference 1 - Invoice Reference -->
				<xsl:value-of select="script:msPad(../../InvoiceHeader/InvoiceReferences/InvoiceReference, 32)"/>
				<!-- Reference 2 - {blank} -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 3 - Original Invoice Number (CRN only) -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 4 - Delivery Date -->
				<xsl:value-of select="script:msPad(concat(substring(../../InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(../../InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(../../InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],1,4)), 32)"/>
				<!-- Reference 5 - File Sequence Number -->
				<xsl:value-of select="script:msPad(../../InvoiceHeader/BatchInformation/FileGenerationNo, 32)"/>
				<!-- Reference 6 - File Transmission Date -->
				<xsl:value-of select="script:msPad(concat(substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,9,2),substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,6,2),substring(../../InvoiceHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
				<!-- Line Type -->
				<xsl:text>159</xsl:text>
				<!-- Account Code String -->
				<!--xsl:value-of select="script:msPad(concat('+.000RR53.',../../InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode,'.',$VATCode), 79)"/-->
				<xsl:value-of select="script:msPad(concat('+.000RR53.124200.',$VATCode), 79)"/>
				<!-- Value -->
				<xsl:value-of select="script:msPadNumber(VATSubTotal/VATAmountAtRate, 15, 2)"/>
				<!-- Vat Code -->
				<xsl:value-of select="$VATCode"/>
				<!-- Line description -->
				<xsl:value-of select="script:msPad(concat('EDI/',../../InvoiceHeader/Supplier/SuppliersName), 36)"/>
				<!-- VAT Value - {blank} -->
				<xsl:value-of select="script:msPad('', 15)"/>
				<!-- LF/CR -->
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			<!-- HEADER RECORD -->
			<!-- Company Code -->
			<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
			<!-- Transaction Type -->
			<xsl:value-of select="script:msPad('PINEDI', 12)"/>
			<!-- Transaction Number - {blank}-->
			<xsl:value-of select="script:msPad('', 12)"/>
			<!-- Transaction Date -->
			<xsl:value-of select="concat(substring(InvoiceHeader/InvoiceReferences/InvoiceDate,9,2), substring(InvoiceHeader/InvoiceReferences/InvoiceDate,6,2), substring(InvoiceHeader/InvoiceReferences/InvoiceDate,1,4))"/>
			<!-- Reference 1 - Invoice Reference -->
			<xsl:value-of select="script:msPad(InvoiceHeader/InvoiceReferences/InvoiceReference, 32)"/>
			<!-- Reference 2 - {blank} -->
			<xsl:value-of select="script:msPad('', 32)"/>
			<!-- Reference 3 - Original Invoice Number (CRN only) -->
			<xsl:value-of select="script:msPad('', 32)"/>
			<!-- Reference 4 - Delivery Date -->
			<xsl:value-of select="script:msPad(concat(substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate[1],1,4)), 32)"/>
			<!-- Reference 5 - File Sequence Number -->
			<xsl:value-of select="script:msPad(InvoiceHeader/BatchInformation/FileGenerationNo, 32)"/>
			<!-- Reference 6 - File Transmission Date -->
			<xsl:value-of select="script:msPad(concat(substring(InvoiceHeader/BatchInformation/SendersTransmissionDate,9,2),substring(InvoiceHeader/BatchInformation/SendersTransmissionDate,6,2),substring(InvoiceHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
			<!-- Line Type -->
			<xsl:text>157</xsl:text>
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('+.000RR53.',InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode,'.S',InvoiceHeader/InvoiceReferences/VATRegNo,'000'), 79)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(InvoiceTrailer/DocumentTotalInclVAT, 15, 2)"/>
			<!-- Vat Code -->
			<xsl:value-of select="script:msPad('', 5)"/>
			<!-- Line description -->
			<xsl:value-of select="script:msPad(concat('EDI/',InvoiceHeader/Supplier/SuppliersName), 36)"/>
			<!-- VAT Value - {blank} -->
			<xsl:value-of select="script:msPad('', 15)"/>
			<!-- LF/CR -->
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
		<!-- Credit Notes -->
		<xsl:for-each select="CreditNote">
			<!-- INVOICE DETAIL -->
			<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
				<!-- Company Code -->
				<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
				<!-- Transaction Type -->
				<xsl:value-of select="script:msPad('PCREDI', 12)"/>
				<!-- Transaction Number - {blank}-->
				<xsl:value-of select="script:msPad('', 12)"/>
				<!-- Transaction Date -->
				<xsl:value-of select="concat(substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,9,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,6,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,1,4))"/>
				<!-- Reference 1 - Invoice Reference -->
				<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference, 32)"/>
				<!-- Reference 2 - {blank} -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 3 - Original Invoice Number (CRN only) -->
				<xsl:value-of select="script:msPad(//CreditNoteHeader/InvoiceReferences/InvoiceReference, 32)"/>
				<!-- Reference 4 - Delivery Date -->
				<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],1,4)), 32)"/>
				<!-- Reference 5 - File Sequence Number -->
				<xsl:value-of select="script:msPad(//CreditNoteHeader/SequenceNumber, 32)"/>
				<!-- Reference 6 - File Transmission Date -->
				<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,9,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,6,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
				<!-- Line Type -->
				<xsl:text>158</xsl:text>
				<!-- Account Code String -->
				<xsl:value-of select="script:msPad(concat('+.',//TradeSimpleHeader/RecipientsBranchReference,'.',LineExtraData/AccountCode), 79)"/>
				<!-- Value -->
				<xsl:value-of select="script:msPadNumber(-1 * LineValueExclVAT, 15, 2)"/>
				<!-- Vat Code -->
				<xsl:choose>
					<xsl:when test="VATCode = 'S'">
						<xsl:text>VISTD</xsl:text>
					</xsl:when>
					<xsl:when test="VATCode = 'Z'">
						<xsl:text>VIZER</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>VIEXP</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Line description -->
				<xsl:value-of select="script:msPad(concat('EDI/',/CreditNote/CreditNoteHeader/Supplier/SuppliersName), 36)"/>
				<!-- VAT Value - {blank} -->
				<xsl:value-of select="script:msPad('', 15)"/>
				<!-- LF/CR -->
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			<!-- VAT SUMMARIES -->
			<xsl:for-each select="CreditNoteTrailer/VATSubTotals">
				<xsl:variable name="VATCode">
					<xsl:choose>
						<xsl:when test="VATSubTotal/@VATCode = 'S'">
							<xsl:text>VISTD</xsl:text>
						</xsl:when>
						<xsl:when test="VATSubTotal/@VATCode = 'Z'">
							<xsl:text>VIZER</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>VIEXP</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Company Code -->
				<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
				<!-- Transaction Type -->
				<xsl:value-of select="script:msPad('PCREDI', 12)"/>
				<!-- Transaction Number - {blank}-->
				<xsl:value-of select="script:msPad('', 12)"/>
				<!-- Transaction Date -->
				<xsl:value-of select="concat(substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,9,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,6,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,1,4))"/>
				<!-- Reference 1 - Invoice Reference -->
				<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference, 32)"/>
				<!-- Reference 2 - {blank} -->
				<xsl:value-of select="script:msPad('', 32)"/>
				<!-- Reference 3 - Original Invoice Number (CRN only) -->
				<xsl:value-of select="script:msPad(//CreditNoteHeader/InvoiceReferences/InvoiceReference, 32)"/>
				<!-- Reference 4 - Delivery Date -->
				<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],1,4)), 32)"/>
				<!-- Reference 5 - File Sequence Number -->
				<xsl:value-of select="script:msPad(//CreditNoteHeader/SequenceNumber, 32)"/>
				<!-- Reference 6 - File Transmission Date -->
				<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,9,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,6,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
				<!-- Line Type -->
				<xsl:text>159</xsl:text>
				<!-- Account Code String -->
				<xsl:value-of select="script:msPad(concat('+.000RR53.',//CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode,'.',$VATCode), 79)"/>
				<!-- Value -->
				<xsl:value-of select="script:msPadNumber(-1 * VATSubTotal/VATAmountAtRate, 15, 2)"/>
				<!-- Vat Code -->
				<xsl:value-of select="$VATCode"/>
				<!-- Line description -->
				<xsl:value-of select="script:msPad(concat('EDI/',/CreditNote/CreditNoteHeader/Supplier/SuppliersName), 36)"/>
				<!-- VAT Value - {blank} -->
				<xsl:value-of select="script:msPad('', 15)"/>
				<!-- LF/CR -->
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			<!-- HEADER RECORD -->
			<!-- Company Code -->
			<xsl:value-of select="script:msPad('TRAGUS1', 12)"/>
			<!-- Transaction Type -->
			<xsl:value-of select="script:msPad('PCREDI', 12)"/>
			<!-- Transaction Number - {blank}-->
			<xsl:value-of select="script:msPad('', 12)"/>
			<!-- Transaction Date -->
			<xsl:value-of select="concat(substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,9,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,6,2), substring(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,1,4))"/>
			<!-- Reference 1 - Invoice Reference -->
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference, 32)"/>
			<!-- Reference 2 - {blank} -->
			<xsl:value-of select="script:msPad('', 32)"/>
			<!-- Reference 3 - Original Invoice Number (CRN only) -->
			<xsl:value-of select="script:msPad(CreditNoteHeader/InvoiceReferences/InvoiceReference, 32)"/>
			<!-- Reference 4 - Delivery Date -->
			<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],9,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],6,2),substring(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate[1],1,4)) , 32)"/>
			<!-- Reference 5 - File Sequence Number -->
			<xsl:value-of select="script:msPad(CreditNoteHeader/SequenceNumber, 32)"/>
			<!-- Reference 6 - File Transmission Date -->
			<xsl:value-of select="script:msPad(concat(substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,9,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,6,2),substring(/CreditNote/CreditNoteHeader/BatchInformation/SendersTransmissionDate,1,4)), 32)"/>
			<!-- Line Type -->
			<xsl:text>157</xsl:text>
			<!-- Account Code String -->
			<xsl:value-of select="script:msPad(concat('+.000RR53.',CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode,'.S',CreditNoteHeader/CreditNoteReferences/VATRegNo,'000'), 79)"/>
			<!-- Value -->
			<xsl:value-of select="script:msPadNumber(-1 * CreditNoteTrailer/DocumentTotalInclVAT, 15, 2)"/>
			<!-- Vat Code -->
			<xsl:value-of select="script:msPad('', 5)"/>
			<!-- Line description -->
			<xsl:value-of select="script:msPad(concat('EDI/',/CreditNote/CreditNoteHeader/Supplier/SuppliersName), 36)"/>
			<!-- VAT Value - {blank} -->
			<xsl:value-of select="script:msPad('', 15)"/>
			<!-- LF/CR -->
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
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
		'========================================================================================*/
		function msPadNumber(vvNumber, vlLength, vlDPs)
		{
			var sNumber = '';
			var neg = false;
			
			try
			{
				sNumber = vvNumber(0).text;
			}
			catch(e)
			{
				sNumber = vvNumber.toString();
			}
			
			
			if(sNumber.search(/-/)!=-1)
			{
				sNumber = sNumber.replace(/-/,'');
				neg=true;
			}		

			
			if(sNumber.indexOf('.') != -1)
			{
				var lDPs;
				if(neg) 
				{
				     lDPs = sNumber.length - sNumber.indexOf('.') - 2;
				 }
				 else
				 {
				     lDPs = sNumber.length - sNumber.indexOf('.') - 1;
				 } 
				
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
			
			if(neg) 
			{
				sNumber = '-' + sNumber;
			}
			return sNumber.substr(0, vlLength);
				
		}

	]]></msxsl:script>
</xsl:stylesheet>
