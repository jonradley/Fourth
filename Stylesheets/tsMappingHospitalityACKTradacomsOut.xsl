<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 Maps internal XML into an EDI Tradacoms v9 format.
 
 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================

=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>

	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note 1) the '::' literal is simply used as a convenient separator for the 2 values that make up the second key.
	     note 2) the extra ¬ character is needed because PO and DN references are optional. -->
	<xsl:key name="keyLinesByPO" match="PurchaseOrderAcknowledgementLine" use="concat('¬',PurchaseOrderReferences/PurchaseOrderReference)"/>
	<xsl:key name="keyLinesByPOAndDN" match="PurchaseOrderAcknowledgementDetail/PurchaseOrderAcknowledgementLine" use="concat('¬',PurchaseOrderReferences/PurchaseOrderReference,'::¬',DeliveryNoteReferences/DeliveryNoteReference)"/>
	
	<xsl:template match="/PurchaseOrderAcknowledgement">

		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
			<!--xsl:text>'&#13;&#10;</xsl:text-->
		</xsl:variable>
			
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
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<!-- if a new file generation number has been generated for this message use it, otherwise
			     use the file generation number sent by the original message sender -->
			<xsl:variable name="FGN">
				<xsl:choose>
					<xsl:when test="PurchaseOrderAcknowledgementHeader/FileGenerationNumber != ''">
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/FileGenerationNumber"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PurchaseOrderAcknowledgementHeader/BatchInformation/FileGenerationNo"/>				
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:variable>
			<xsl:value-of select="$FGN"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>ACKFIL</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>ACKTES</xsl:text></xsl:otherwise>
			</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=1+ACKFIL:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>
		<xsl:text>0700</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SIDN 1 = 3050 must be a number (ANA) -->
				<xsl:if test="string(number(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
					<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 SIDN 2 = 3051 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Supplier/SuppliersAddress/PostCode),8)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 17 (if an alphanumeric value) VATN 2 = 308A = AN..17 -->
		<xsl:choose>
			<xsl:when test="string(number(PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/VATRegNo)) != 'NaN'">
				<xsl:value-of select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/VATRegNo"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/VATRegNo),17)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- CIDN 1 = 3020 must be a number (ANA) -->
				<xsl:if test="string(number(PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/BuyersCode)) != 'NaN'">
					<xsl:value-of select="PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/BuyersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CIDN 2 = 3021 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=</xsl:text>
		<xsl:text>1++073:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/Currency),3)"/>
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=</xsl:text>	
		<xsl:text>2+:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>CLO=</xsl:text>
		<xsl:if test="PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/GLN != '5555555555555'">
			<xsl:value-of select="PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/GLN"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CLOC 2 = 3001 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/BuyersCode),17)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CLOC 3 = 300A = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderAcknowledgementHeader/ShipTo/ShipToAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>AOR=</xsl:text>
		<xsl:call-template name="msCheckField">
			<xsl:with-param name="vobjNode" select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementReference"/>
			<xsl:with-param name="vnLength" select="17"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="PurchaseOrderAcknowledgementHeader/PurchaseOrderAcknowledgementReferences/TaxPointDate"/>
		</xsl:call-template>
		<xsl:value-of select="$sRecordSep"/>

				
		
		
			
		<xsl:text>MHD=4+ACKTLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

	
		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- END = number of message headers (MHD) -->
		<xsl:text>END=4</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
	</xsl:template>
	

<!--=======================================================================================
  Routine        : msFormateDate()
  Description    : Converts a date in the format YYYY-MM-DD to the format YYMMDD 
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormateDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''), 3)"/>
	
	</xsl:template>
	
<!--=======================================================================================
  Routine        : msCheckField()
  Description    : Checks the (escaped) value of the given element won't be truncated
  						  Raises an error if it will.
  Inputs         : vobjNode, the element, 
						  vnLength, the length of the tradacoms field
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msCheckField">
		<xsl:param name="vobjNode"/>
		<xsl:param name="vnLength"/>
		
		<xsl:variable name="sEscapedField" select="js:msEscape(string($vobjNode))"/>
		
		<xsl:choose>
		
			<xsl:when test="string-length($sEscapedField) &gt; $vnLength">
				<xsl:message terminate="yes">
					<xsl:text>Error raised by tsMappingHospitalityOrderTradacomsv6Out.xsl.&#13;&#10;</xsl:text>
					
					<xsl:text>The internal format of this message contains a field that would be truncated when mapped to a corresponding tradacoms field.&#13;&#10;</xsl:text>
					<xsl:text>The element is </xsl:text>
					<xsl:call-template name="msWriteXPath">
						<xsl:with-param name="vobjNode" select="$vobjNode"/>					
					</xsl:call-template>
					<xsl:text>[. = '</xsl:text>
					<xsl:value-of select="$vobjNode"/>
					<xsl:text>'].&#13;&#10;</xsl:text>
					
					<xsl:text>The maximum length after escaping is </xsl:text>
					<xsl:value-of select="$vnLength"/>
					<xsl:text> characters.</xsl:text>
				</xsl:message>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$sEscapedField"/>
			</xsl:otherwise>
			
		</xsl:choose>		
	
	</xsl:template>

<!--=======================================================================================
  Routine        : msWriteXPath()
  Description    : Writes out the Xpath to the given element 
  Inputs         : 
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="msWriteXPath">
		<xsl:param name="vobjNode"/>		
		
		<xsl:if test="$vobjNode != /*">
			<xsl:call-template name="msWriteXPath">
				<xsl:with-param name="vobjNode" select="$vobjNode/ancestor::*[1]"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:text>/</xsl:text>
		<xsl:value-of select="name($vobjNode)"/>
		
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
