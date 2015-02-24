<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2014.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 		|	Description of modification
==========================================================================================
 12/02/2015	| Jose Miguel	|	FB10134 Created
==========================================================================================
 24/02/2015	| Jose Miguel	|	FB10149 Remove mapping to the UoM to use catalogue's
==========================================================================================
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/PurchaseOrder">
	
		<xsl:variable name="sFieldSep">			
			<xsl:text>*</xsl:text>			
		</xsl:variable>

		<xsl:variable name="sRecordSep">			
			<xsl:text>~</xsl:text>
		</xsl:variable>		

		<!-- ISA Interchange Control Header -->
		<xsl:text>ISA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>501354614571   </xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msPad(string(PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode),15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msFileGenerationDate()"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msFileGenerationTime()"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>U</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>00401</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="format-number(PurchaseOrderHeader/FileGenerationNumber,'000000000')"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>0</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<xsl:value-of select="js:msTestOrLive(TradeSimpleHeader/TestFlag)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- GS Functional Group Header -->	
		<xsl:text>GS</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>PO</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode),15)"/>		
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode),15)"/>		
		<xsl:value-of select="$sFieldSep"/>		
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,':',''),4)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="format-number(PurchaseOrderHeader/FileGenerationNumber,'000000000')"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>X</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<xsl:text>004010</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- ST Transaction Set Header -->
		<xsl:text>ST</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>850</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>0001</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- BEG Beginning Segment for Purchase Order -->
		<xsl:text>BEG</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>SA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference),20)"/>		
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="$sFieldSep"/>				
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference),30)"/>				
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- DTM Date/Time Reference -->
		<xsl:text>DTM</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>002</xsl:text>
		<xsl:value-of select="$sFieldSep"/>						
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>						
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- N1 Name -->
		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>ST</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>91</xsl:text>
		<xsl:value-of select="$sFieldSep"/>					
		<xsl:value-of select="js:msSafeText(string(TradeSimpleHeader/RecipientsCodeForSender),48)"/>					
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- N2 Ship to Name -->
		<xsl:text>N2</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToName),35)"/>				
		<xsl:value-of select="$sRecordSep"/>		
		
		<!-- N3 Ship to Address -->
		<xsl:text>N3</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1),35)"/>
		<xsl:value-of select="$sRecordSep"/>

		<!-- N4 Ship To City*State Code*Postal Code -->
		<xsl:text>N4</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2),30)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="substring(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4, 1, 2)"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- PER*AA*Contact Name*TE*Contact Phone~ -->
		<xsl:text>PER</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>AA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>TE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>555-555-5555</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<!-- PO1 Baseline Item Data -->
			<xsl:text>PO1</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="LineNumber"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="number(OrderedQuantity)"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="js:msSafeText(string(UnitValueExclVAT),20)"/>	
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:text>VC</xsl:text>
			<xsl:value-of select="$sFieldSep"/>				
			<xsl:value-of select="js:msSafeText(string(ProductID/SuppliersProductCode),48)"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>							
			<xsl:value-of select="$sRecordSep"/>
			
			<!-- PID Product/Item Description -->
			<xsl:text>PID</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:text>F</xsl:text>
			<xsl:value-of select="$sFieldSep"/>			
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="$sFieldSep"/>							
			<xsl:value-of select="js:msSafeText(string(concat(ProductDescription,' ',PackSize)),80)"/>										
			<xsl:value-of select="$sRecordSep"/>
					
		</xsl:for-each>
		
		<!-- CTT Transaction Totals -->
		<xsl:text>CTT</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- SE Transaction Set Trailer -->
		<xsl:text>SE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="10 + 2 * PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>0001</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- GE Functional Group Trailer -->
		<xsl:text>GE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="format-number(PurchaseOrderHeader/FileGenerationNumber,'000000000')"/>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- IEA Interchange Control Trailer -->
		<xsl:text>IEA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="format-number(PurchaseOrderHeader/FileGenerationNumber,'000000000')"/>
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
	
   
]]></msxsl:script>







</xsl:stylesheet>
