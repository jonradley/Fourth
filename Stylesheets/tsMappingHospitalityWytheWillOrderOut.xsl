<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2009.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 19/05/2009	| Rave Tech					|	Created module.FB 2890
==========================================================================================
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:template match="/PurchaseOrder">
	
		<xsl:variable name="sFieldSep">			
			<xsl:text>*</xsl:text>			
		</xsl:variable>

		<xsl:variable name="sRecordSep">			
			<xsl:text>~&#13;&#10;</xsl:text>			
		</xsl:variable>		

		<!-- ISA Interchange Control Header -->
		<xsl:text>ISA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA01 -->
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<!-- ISA02 -->
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA03 -->
		<xsl:text>00</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<!-- ISA04 -->
		<xsl:value-of select="js:msPad('',10)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA05 -->
		<xsl:text>ZZ</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA06 -->
		<xsl:text>SSPAMERICA     </xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA07 -->
		<xsl:text>01</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA08 -->
		<xsl:value-of select="js:msPad(PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode,15)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA09 -->
		<xsl:value-of select="vb:msFileGenerationDate()"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA10 -->
		<xsl:value-of select="vb:msFileGenerationTime()"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA11 -->
		<xsl:text>U</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA12 -->
		<xsl:text>00401</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA13 -->
		<xsl:value-of select="substring(concat('000000000',PurchaseOrderHeader/FileGenerationNumber),string-length(PurchaseOrderHeader/FileGenerationNumber)+1,9)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA14 -->
		<xsl:text>0</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<!-- ISA15 -->
		<xsl:value-of select="js:msTestOrLive(TradeSimpleHeader/TestFlag)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- ISA16 -->
		<xsl:text>></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- GS Functional Group Header -->	
		<xsl:text>GS</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS01 -->
		<xsl:text>PO</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS02 -->
		<xsl:text>SSPAMERICA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS03 -->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode),15)"/>		
		<!--xsl:value-of select="js:msSafeText(string(TradeSimpleHeader/RecipientsBranchReference),15)"/-->		
		<xsl:value-of select="$sFieldSep"/>		
		<!-- GS04 -->
		<xsl:value-of select="translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate,'-','')"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS05 -->
		<xsl:value-of select="js:msSafeText(translate(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderTime,':',''),4)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS06 -->
		<xsl:value-of select="substring(concat('000000000',PurchaseOrderHeader/FileGenerationNumber),string-length(PurchaseOrderHeader/FileGenerationNumber)+1,9)"/>
		<xsl:value-of select="$sFieldSep"/>
		<!-- GS07 -->
		<xsl:text>X</xsl:text>
		<xsl:value-of select="$sFieldSep"/>		
		<!-- GS08 -->
		<xsl:text>004010VICS</xsl:text>		
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
		<xsl:if test="PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference != ''">
			<xsl:value-of select="$sFieldSep"/>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/PurchaseOrderReferences/TradeAgreement/ContractReference),30)"/>				
		</xsl:if>
		<xsl:value-of select="$sRecordSep"/>
		
		
		<!--xsl:text>REF*IA*050634~</xsl:text>
		<xsl:value-of select="$sRecordSep"/-->

		<!-- DTM Date/Time Reference -->
		<xsl:text>DTM</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>010</xsl:text>
		<xsl:value-of select="$sFieldSep"/>						
		<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>						
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- N1 Name -->
		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>BY</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>92</xsl:text>
		<xsl:value-of select="$sFieldSep"/>					
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode),7)"/>					
		<xsl:value-of select="$sRecordSep"/>
		
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<!-- PO1 Baseline Item Data -->
			<xsl:text>PO1</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO101 -->
			<!--xsl:value-of select="LineNumber"/-->
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO102 -->
			<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO103 -->
			<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO104 -->
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO105 -->
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO106 -->
			<xsl:text>UP</xsl:text>
			<xsl:value-of select="$sFieldSep"/>	
			<!-- PO107 -->
			<xsl:text></xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO108 -->
			<xsl:text>VA</xsl:text>
			<xsl:value-of select="$sFieldSep"/>
			<!-- PO109 -->
			<xsl:value-of select="js:msSafeText(string(ProductID/SuppliersProductCode),7)"/>
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
		<xsl:value-of select="6 + 1 * PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>0001</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- GE Functional Group Trailer -->
		<xsl:text>GE</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="substring(concat('000000000',PurchaseOrderHeader/FileGenerationNumber),string-length(PurchaseOrderHeader/FileGenerationNumber)+1,9)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- IEA Interchange Control Trailer -->
		<xsl:text>IEA</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sFieldSep"/>
		<xsl:value-of select="substring(concat('000000000',PurchaseOrderHeader/FileGenerationNumber),string-length(PurchaseOrderHeader/FileGenerationNumber)+1,9)"/>
		<xsl:value-of select="$sRecordSep"/>
		
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
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationTime()

Dim sNow

	sNow = CStr(Time)

	msFileGenerationTime = Replace(Left(sNow,5),":","")
			
End Function

]]></msxsl:script>


<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 

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
