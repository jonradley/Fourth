<?xml version="1.0" encoding="UTF-8"?>
<!--****************************************************************************************
ANSI X12 810 V5 - Outbound Invoice/Credit Note stylesheet 
*******************************************************************************************
Name		| Date    		  | Change
*******************************************************************************************
J Miguel	| 24/11/2015 | FB10620 - ALDI - custom X12 mappers for outbound Invoice/credit note
*******************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/Invoice | /CreditNote">
	
		<xsl:variable name="sFieldSep">			
			<xsl:text>*</xsl:text>			
		</xsl:variable>

		<xsl:variable name="sRecordSep">			
			<xsl:text>!
</xsl:text>
		</xsl:variable>		

		<!-- ISA Interchange Control Header -->
		<xsl:text>ISA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I01 Authorization Information Qualifier -->
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I02 Authorization Information -->
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I03 Security Information Qualifier -->
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I04 Security Information -->
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I05 Interchange ID Qualifier -->
		<xsl:text>07</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I06 Interchange Sender ID -->
		<xsl:value-of select="js:padLeftN(15, ' ', string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersLocationID/GLN))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I05 Interchange ID Qualifier (repeated for some reason) -->
		<xsl:text>07</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I07 Interchange Receiver ID -->
		<xsl:value-of select="js:padLeftN(15, ' ', string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersLocationID/GLN))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I08 Interchange Date -->
		<xsl:value-of select="js:msFileGenerationDate()"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I09 Interchange Time -->
		<xsl:value-of select="js:msFileGenerationTime()"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I65 Repetition Separator -->
		<xsl:text>^</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I11 Interchange Control Version Number -->
		<xsl:text>00501</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I12 Interchange Control Number -->
		<xsl:value-of select="format-number((InvoiceHeader | CreditNoteHeader)/BatchInformation/FileGenerationNo,'000000000')"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I13 Acknowledgment Requested -->
		<xsl:text>0</xsl:text>
		<xsl:value-of select="$sFieldSep"/>	
		<!-- I14 Interchange Usage Indicator -->
		<xsl:value-of select="js:msTestOrLive(TradeSimpleHeader/TestFlag)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I15 Component Element Separator -->
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- GS Functional Group Header -->	
		<xsl:text>GS</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 479 Functional Identifier Code -->
		<xsl:text>IN</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 142 Application Sender's Code -->
		<xsl:value-of select="js:msPad('   ' + string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersLocationID/SuppliersCode),15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 124 Application Receiver's Code -->
		<xsl:value-of select="js:msPad('   ' + string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersLocationID/SuppliersCode),15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 373 Date -->
		<xsl:value-of select="translate(substring-before((InvoiceHeader | CreditNoteHeader)/BatchInformation/SendersTransmissionDate, 'T'),'-','')"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 337 Time -->
		<xsl:value-of select="translate(substring (substring-after((InvoiceHeader | CreditNoteHeader)/BatchInformation/SendersTransmissionDate,'T'), 1, 5), ':', '')"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 28 Group Control Number -->
		<xsl:text>10</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 455 Responsible Agency Code -->
		<xsl:text>X</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 480 Version / Release / Industry Identifier Code -->
		<xsl:text>005010</xsl:text>		
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- ST Transaction Set Header -->
		<xsl:text>ST</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 143 Transaction Set Identifier Code -->
		<xsl:text>810</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 329 Transaction Set Control Number -->
		<xsl:text>0001</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- BIG Beginning Segment for Invoice -->
		<xsl:text>BIG</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 373 Date -->
		<xsl:value-of select="translate(InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'-','')"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 76 Invoice Number -->
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 373 Date - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 324 Purchase Order Number - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 328 Release Number - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 327 Change Order Sequence Number - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 640 Transaction Type Code -->
		<xsl:choose>
			<xsl:when test="InvoiceHeader"><xsl:text>VJ</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>CR</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 353 Transaction Set Purpose Code - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 306 Action Code -->
		<xsl:text>0</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- NTE  4 segments - deleted as they are optional -->
		<!-- CUR - Segment -->
		<xsl:text>CUR</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 98 Entity Identifier Code -->
		<xsl:text>SE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 100 Currency Code -->
		<xsl:value-of select="InvoiceHeader/Currency"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- REF 2 segments - deleted as they are conditional -->
		
		<!-- N1 - Ship to information in N1 N3 N4 REF REF -->
		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 98 Entity Identifier Code -->
		<xsl:text>BY</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 93 Name -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersName), 15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 66 Identification Code Qualifier -->
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 67 Identification Code -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersLocationID/SuppliersCode), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- N3 -->
		<xsl:text>N3</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 166 Address Information -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersAddress/AddressLine1), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>

		<!-- N4 -->
		<xsl:text>N4</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 19 City Name -->
		<xsl:value-of select="js:padLeftN(30, ' ', string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersAddress/AddressLine3))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 156 State or Province Code - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 116 Postal Code -->
		<xsl:value-of select="js:padLeftN(15, ' ', string((InvoiceHeader | CreditNoteHeader)/Buyer/BuyersAddress/PostCode))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 26 Country Code -->
		<xsl:text>UK</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		<!-- REF - 2 segments not added -->
		
		<!-- N1 - Seller information in N1 N3 N4 REF REF -->
		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 98 Entity Identifier Code -->
		<xsl:text>SU</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 93 Name -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersName), 15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 66 Identification Code Qualifier -->
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 67 Identification Code -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersLocationID/SuppliersCode), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- N3 -->
		<xsl:text>N3</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 166 Address Information -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersAddress/AddressLine1), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>

		<!-- N4 -->
		<xsl:text>N4</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 19 City Name -->
		<xsl:value-of select="js:padLeftN(30, ' ', string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersAddress/AddressLine3))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 156 State or Province Code - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 116 Postal Code -->
		<xsl:value-of select="js:padLeftN(15, ' ', string((InvoiceHeader | CreditNoteHeader)/Supplier/SuppliersAddress/PostCode))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 26 Country Code -->
		<xsl:text>UK</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		<!-- REF - 4 segments not added -->
		
		<!-- PER - 1 segment not added -->
		
		<!-- N1 - Buyer information in N1 N3 N4 REF REF -->
		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 98 Entity Identifier Code -->
		<xsl:text>SF</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 93 Name -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToName), 15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 66 Identification Code Qualifier -->
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 67 Identification Code -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToLocationID/SuppliersCode), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		<!-- N3 -->
		<xsl:text>N3</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 166 Address Information -->
		<xsl:value-of select="js:msSafeText(string((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToAddress/AddressLine1), 15)"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		<!-- N4 -->
		<xsl:text>N4</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 19 City Name -->
		<xsl:value-of select="js:padLeftN(30, ' ', string((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToAddress/AddressLine3))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 156 State or Province Code - NOT USED -->
		<xsl:value-of select="$sFieldSep"/>
		<!-- 116 Postal Code -->
		<xsl:value-of select="js:padLeftN(15, ' ', string((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToAddress/PostCode))"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 26 Country Code -->
		<xsl:text>UK</xsl:text>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<xsl:for-each select="InvoiceDetail/InvoiceLine | CreditNoteDetail/CreditNoteLine">
			<xsl:variable name="Quantity">
				<xsl:choose>
					<xsl:when test="CreditedQuantity"><xsl:value-of  select="CreditedQuantity"/></xsl:when>
					<xsl:otherwise><xsl:copy-of select="InvoicedQuantity"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="CreditedQuantity"><xsl:value-of  select="CreditedQuantity/@UnitOfMeasure"/></xsl:when>
					<xsl:otherwise><xsl:copy-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- IT1 Baseline Item Data (Invoice) -->
			<xsl:text>IT1</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 350 Assigned Identification - Invoice Line Item Number -->
			<xsl:value-of select="LineNumber"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 358 Quantity Invoiced -->
			<xsl:if test="CreditedQuantity"><xsl:text>-</xsl:text></xsl:if>
			<xsl:value-of select="format-number(number($Quantity), '##.000')"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 355 Unit or Basis for Measurement Code -->
			<xsl:choose>
				<xsl:when test="$UnitOfMeasure='EA'"><xsl:text>PC</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='CS'"><xsl:text>CA</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='PND'"><xsl:text>PN</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='KG'"><xsl:text>KG</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>PC</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 212 Unit Price -->
			<xsl:value-of select="format-number(number(UnitValueExclVAT), '##.0000')"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 639 Basis of Unit Price Code -->
			<xsl:text>NC</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!--- 235 Product/Service ID Qualifier -->
			<xsl:text>IN</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!--- 234 Product/Service ID -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="js:addSegment($sRecordSep)"/>
						
			<!-- CTP - Pricing Information -->
			<xsl:text>CTP</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 687 Class of Trade Code -->
			<xsl:value-of select="$sFieldSep"/>
			<!-- 236 Price Identifier Code -->
			<xsl:text>NET</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 212 Unit Price -->
			<xsl:value-of select="format-number(number(UnitValueExclVAT), '##.0000')"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 380 Quantity -->
			<xsl:value-of select="format-number(number($Quantity), '##.000')"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 355 Unit or Basis for Measurement Code -->
			<xsl:choose>
				<xsl:when test="$UnitOfMeasure='EA'"><xsl:text>PC</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='CS'"><xsl:text>CA</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='PND'"><xsl:text>PN</xsl:text></xsl:when>
				<xsl:when test="$UnitOfMeasure='KG'"><xsl:text>KG</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>PC</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 782 Monetary Amount -->
			<xsl:value-of select="format-number(number(LineValueExclVAT), '##.000')"/>
			<xsl:value-of select="js:addSegment($sRecordSep)"/>
			
			<!-- PID - Product/Item Description -->
			<xsl:text>PID</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 349 Item Description Type -->
			<xsl:text>F</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 750 Product/Process Characteristic Code -->
			<xsl:value-of select="$sFieldSep"/>
			<!-- 559 Agency Qualifier Code -->
			<xsl:value-of select="$sFieldSep"/>
			<!-- 751 Product Description Code -->
			<xsl:value-of select="$sFieldSep"/>
			<!-- 352 Description -->
			<xsl:value-of select="ProductDescription"/>
			<xsl:value-of select="js:addSegment($sRecordSep)"/>

			<!-- REF - Reference Information - Purchase Order Reference -->
			<xsl:text>REF</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 128 Reference Identification Qualifier -->
			<xsl:text>PO</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 128 Reference Identification Qualifier -->
			<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="js:addSegment($sRecordSep)"/>

			<!-- DTM - Date/Time Reference - Purchase Order Date -->
			<xsl:text>DTM</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 374 Date/Time Qualifier -->
			<xsl:text>004</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- 373 Date -->
			<xsl:value-of select="translate(PurchaseOrderReferences/PurchaseOrderDate, '-', '')"/>
			<xsl:value-of select="js:addSegment($sRecordSep)"/>
			<!-- SAC - Service, Promotion, Allowance, or Charge Information - NOT ADDED -->

		</xsl:for-each>
		
		<!-- TDS - Total Monetary Value Summary -->
		<xsl:text>TDS</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 610 Amount  TDS01 -->
		<xsl:value-of select="(InvoiceTrailer | CreditNoteTrailer)/DocumentTotalInclVAT"/>
		<xsl:value-of select="js:addSegment($sRecordSep)"/>
		
		<!-- CTT - Transaction Totals - Total number of lines in the invoice -->
		<xsl:text>CTT</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 354 Number of Line Items -->
		<xsl:value-of select="(InvoiceTrailer | CreditNoteTrailer)/NumberOfLines"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- SE Transaction Set Trailer -->
		<xsl:text>SE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 96 Number of Included Segments -->
		<xsl:value-of select="js:getTotalSegments()"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>0001</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- GE Functional Group Trailer -->
		<xsl:text>GE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 97 Number of Transaction Sets Included -->
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- 28 Group Control Number -->
		<xsl:text>1</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- IEA Interchange Control Trailer -->
		<xsl:text>IEA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- I16 Number of Included Functional Groups -->
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="format-number((InvoiceHeader | CreditNoteHeader)/BatchInformation/FileGenerationNo,'000000000')"/>
		<xsl:value-of select="$sRecordSep"/>
		
	</xsl:template>
<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
function right (str, count)
{
	return str.substring(str.length - count, str.length);
}

function pad2 (str)
{
	return right('0' + str, 2);
}

/*=========================================================================================
' Routine        : msFileGenerationDate()
' Description    : Gets the date in 'YYMMDD' format and works in all regions and date configurations (UK, US).
' Returns        : A string
' Author         : Jose Miguel
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/
function msFileGenerationDate ()
{
	var today = new Date();
	var year = today.getYear();
	var month = today.getMonth()+1;
	var day = today.getDate();
	
	
	return '' + pad2(year) + pad2(month) + pad2(day);
}

/*=========================================================================================
' Routine        : msFileGenerationTime()
' Description    : Gets the date in 'hhmm' format and works in all regions and time configurations (UK, US).
' Returns        : A string
' Author         : Jose Miguel
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/
function msFileGenerationTime()
{

	var now = new Date();
	var hours = now.getHours();
	var minutes = now.getMinutes();

	return '' + pad2(hours) + pad2(minutes);
}

/*=========================================================================================
' Routine        : msTestOrLive()
' Description  : to check test or live 
' Inputs          : the field, the maximum length
' Outputs       : 
' Returns       : A string
' Author         : Rave Tech
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msTestOrLive(test)
{
	var returnValue;
	
	if (test(0).text == '1' || test(0).text.toLowerCase() == 'true')
		returnValue = "T";
	else
		returnValue = "P";
	
	return returnValue;
}

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

function padLeftN(num, char, str)
{
	var pad = Array(num+1).join(char)
	return (pad + str).slice(-pad.length);
}

var segmentCount = 0;
function addSegment (str)
{
	segmentCount++;
	return str;
}

function getTotalSegments ()
{
	return segmentCount;
}
]]></msxsl:script>
</xsl:stylesheet>
