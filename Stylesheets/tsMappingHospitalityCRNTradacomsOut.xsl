<?xml version="1.0" encoding="UTF-8"?>
<!--====================================================================================
 Date      		| Name 					| Description of modification
=======================================================================================
 11/06/2018		| M Dimant				| FB12884: Created.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
					xmlns:fo="http://www.w3.org/1999/XSL/Format"
					xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
					xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
					xmlns:msxsl="urn:schemas-microsoft-com:xslt">

<xsl:output method="text"/>

	<xsl:variable name="sRecordSep">
		<xsl:text>'&#13;&#10;</xsl:text>
	</xsl:variable>
	
	<xsl:template match="/CreditNote">
	
	<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
	<xsl:text>STX=</xsl:text>
		<xsl:text>ANA:1+</xsl:text>
		<!--Our mailbox reference-->
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>5013546145710</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>5013546164209</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersName), 35)"/>
		<xsl:text>+</xsl:text>
		<!--Your mailbox reference-->
		<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersName), 35)"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="vb:msFileGenerationTime()"/>
		<xsl:text>+</xsl:text>
		<!-- if a new file generation number has been generated for this message use it, otherwise
			 use the file generation number sent by the original message sender -->
		<xsl:variable name="FGN">
			<xsl:choose>
				<xsl:when test="CreditNoteHeader/FileGenerationNo != ''">
					<xsl:value-of select="CreditNoteHeader/FileGenerationNo"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CreditNoteHeader/BatchInformation/FileGenerationNo"/>				
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>CREHDR</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>MHD=1+CREHDR:9</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>TYP=0740</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>SDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="CreditNoteHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SIDN 1 = 3050 must be a number (ANA) -->
				<xsl:if test="string(number(CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
					<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 SIDN 2 = 3051 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Supplier/SuppliersAddress/PostCode),8)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 17 (if an alphanumeric value) VATN 2 = 308A = AN..17 -->
		<xsl:choose>
			<xsl:when test="string(number(CreditNoteHeader/InvoiceReferences/VATRegNo)) != 'NaN'">
				<xsl:value-of select="CreditNoteHeader/InvoiceReferences/VATRegNo"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/InvoiceReferences/VATRegNo),17)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
	
	<xsl:text>CDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="CreditNoteHeader/Buyer/BuyersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- CIDN 1 = 3020 must be a number (ANA) -->
				<xsl:if test="string(number(CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode)) != 'NaN'">
					<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CIDN 2 = 3021 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>FIL=</xsl:text>
		<xsl:variable name="length" select="string-length($FGN)"/>
		 <xsl:value-of select="substring($FGN,($length - 3))"/>
		<xsl:text>+1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
	<xsl:value-of select="$sRecordSep"/>		
	
	<xsl:text>MTR=6</xsl:text>
	<xsl:value-of select="$sRecordSep"/>		
	
	<xsl:text>MHD=</xsl:text>
		<xsl:text>2+CREDIT:9</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	

	
	<xsl:text>CLO=</xsl:text>
		<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/GLN != '5555555555555'">
			<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CLOC 2 = 3001 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode),17)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CLOC 3 = 300A = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
	
	<xsl:text>CRF=</xsl:text>
		<xsl:if test="CreditNoteHeader/CreditNoteReferences/CreditNoteReference != ''">
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		</xsl:if>
		<xsl:text>+</xsl:text>	
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
		</xsl:call-template>		
		<xsl:text>++++</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>OIR=1+</xsl:text>
		<xsl:if test="CreditNoteHeader/InvoiceReferences/InvoiceReference != '' ">
			<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
		</xsl:if>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/InvoiceReferences/TaxPointDate"/>
		</xsl:call-template>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:for-each select="CreditNoteDetail/CreditNoteLine">	
		<xsl:text>CLD=</xsl:text>
			<xsl:value-of select="LineNumber"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="ProductID/GTIN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>+++1+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditedQuantity,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(LineValueExclVAT,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="VATCode"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(VATRate,'#.0000'),'.','')"/>
			<xsl:text>+::+++</xsl:text>
			<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>	
		<xsl:value-of select="$sRecordSep"/>	
	</xsl:for-each>
		
		<xsl:for-each select="CreditNoteTrailer/VATSubTotals">
			<xsl:text>CST=1+</xsl:text>
				<!--VAT Rate Category Code-->
				<xsl:value-of select="VATSubTotal/@VATCode"/>
				<xsl:text>+</xsl:text>
				<!--VAT Rate Percentage-->
				<xsl:value-of select="VATSubTotal/@VATRate"/>
				<xsl:text>+</xsl:text>
				<!--Number of Item Lines-->
				<xsl:value-of select="VATSubTotal/NumberOfLinesAtRate"/>
				<xsl:text>+</xsl:text>
				<!--Line Sub-Total Amount (before VAT)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DiscountedLinesTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+++</xsl:text>
				<!--Extended Sub-Total Amount (before Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DocumentTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Sub-Total Settlement Discount Amount-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementDiscountAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Extended Sub-Total Amount (after Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--VAT Amount Payable-->
				<xsl:value-of select="translate(format-number(VATSubTotal/VATAmountAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Payable Sub-Total Amount (before Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DocumentTotalInclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Payable Sub-Total Amount (after Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementTotalInclVATAtRate,'#.00'),'.','')"/>
			<xsl:value-of select="$sRecordSep"/>	
		</xsl:for-each>
		
		<xsl:text>CTR=1+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DiscountedLinesTotalExclVAT,'#.00'),'.','')"/>	
			<xsl:text>+++</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
		<xsl:value-of select="$sRecordSep"/>	
		
		<xsl:text>MTR=</xsl:text>
		<xsl:value-of select="5 + number(CreditNoteTrailer/NumberOfDeliveries) + count(CreditNoteTrailer/InvoiceLine) + count(CreditNoteTrailer/VATSubTotals/VATSubTotal)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=</xsl:text>			
		<xsl:value-of select="format-number(count(/BatchRoot/CreditNote) + 2,'0')"/>		
		<xsl:text>+</xsl:text>	
		<xsl:text>VATTLR:9</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:variable name="VATRatesInBatch">
			<xsl:copy-of select="/"/>
			<xsl:for-each select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal/@VATRate">
				<xsl:sort select="."/>
				<VAT>
					<VATRate>
						<xsl:value-of select="."/>
					</VATRate>
				</VAT>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:for-each select="msxsl:node-set($VATRatesInBatch)/VAT">
			<xsl:variable name="VATRate">
				<xsl:value-of select="VATRate"/>
			</xsl:variable>
			<xsl:text>VRS=</xsl:text>
			<!-- SEQA -->
			<xsl:value-of select="format-number(count(preceding-sibling::* | self::*) + 1,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VATC -->
			<xsl:choose>
				<xsl:when test="/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/VATCode = 'S'">S</xsl:when>
				<xsl:when test="/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/VATCode = 'Z'">Z</xsl:when>
			</xsl:choose>
			<xsl:text>+</xsl:text>
			<!-- VATP -->
			<xsl:value-of select="format-number($VATRate * 1000,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDE -->
			<xsl:value-of select="format-number(sum(/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDI -->
			<xsl:value-of select="format-number(sum(/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VVAT -->
			<xsl:value-of select="format-number(sum(/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/VATAmountAtRate) * 100,'0')"/>
			<!-- VPSE -->
			<xsl:text>++</xsl:text>
			<!-- VPSI -->
			<xsl:value-of select="format-number((sum(/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/DocumentTotalInclVATAtRate) ) * 100,'0')"/>
			<xsl:value-of select="$sRecordSep"/>				
	
	</xsl:for-each>
	
		<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="2 + count(msxsl:node-set($VATRatesInBatch)/VAT)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=</xsl:text>
		<xsl:value-of select="format-number(count(/CreditNote) + 3,'0')"/>
		<xsl:text>+</xsl:text>
		<xsl:text>CRETLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TOT=</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/VATAmount),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
	
	
		<!-- END = number of message headers (MHD) -->
		<xsl:text>END=</xsl:text>
		<xsl:value-of select="format-number(count(/CreditNote) + 3,'0')"/>
		<xsl:value-of select="$sRecordSep"/>
		
	
	
	</xsl:template>
	
	<!--=======================================================================================
  Routine        : msFormateDate()
  Description    : Converts a date in the format YYYY-MM-DD to the format YYMMDD 
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : K Oshaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormateDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''), 3)"/>
	
	</xsl:template>

<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[

'==========================================================================================
' Routine        : msFileGenerationDate()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationDate()

Dim sNow

	sNow = CStr(Date)

	msFileGenerationDate = Right(sNow,2) & Mid(sNow,4,2) & Left(sNow,2)
		
End Function

'==========================================================================================
' Routine        : msFileGenerationTime()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : K Oshaughnessy
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationTime()

Dim sNow

	sNow = CStr(Time)

	msFileGenerationTime = Replace(sNow,":","")
			
End Function

]]></msxsl:script>

<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 

/*=========================================================================================
' Routine        : msSafeText()
' Description    : escapes and then truncates a string 
' Inputs         : the field, the maximum length
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msSafeText(vsField, nLength){
	
	return msTruncate(msEscape(vsField),nLength);
	
}


/*=========================================================================================
' Routine        : msTruncate()
' Description    : truncates a string in an escape-char-aware manner
' Inputs         : the field, the maximum length
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msTruncate(vsField, nLength){

var sText;
var objRegExp = new RegExp("[?]*$");

	//truncate the string
	sText = vsField.substring(0,nLength);
	
	//capture any sequence of '?' at the end of the string
	objRegExp.exec(sText);
	
	//length of a sequence of '?' is odd the last one 
	//is acting as an escape character and should be removed
	if((RegExp.lastMatch.length % 2) == 1){
		sText = sText.substring(0,nLength-1)
	}
	
	return sText;
	
}


/*=========================================================================================
' Routine        : msEscape()
' Description    : escapes reserved characters
' Inputs         : the field 
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/


function msEscape(vsField){

	//match all reserved characters in the string and put and ? in fornt of it
	return vsField.replace(/([?+=:'])/g, "?$1");
	
}


   
]]></msxsl:script>

</xsl:stylesheet>