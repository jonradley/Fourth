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
 30/04/2009	| Rave Tech			   	| Created. FB 2870
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>	
		
	<xsl:template match="/DeliveryNote">

		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>			
		</xsl:variable>		
		
		<xsl:variable name="FGN">
			<!-- if a new file generation number has been generated for this message use it, otherwise
			     use the file generation number sent by the original message sender -->
			<xsl:variable name="atLeast4DigitFGN">						
				<xsl:choose>
					<xsl:when test="DeliveryNoteHeader/FileGenerationNumber != ''">
						<xsl:value-of select="format-number(DeliveryNoteHeader/FileGenerationNumber,'0000')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(DeliveryNoteHeader/BatchInformation/FileGenerationNo,'0000')"/>				
					</xsl:otherwise>
				</xsl:choose>						
			</xsl:variable>		
			<!-- Only get 4 right hand digits -->
			<xsl:value-of select="substring($atLeast4DigitFGN, string-length($atLeast4DigitFGN)-3)"/>			
		</xsl:variable>			
			
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<xsl:text>STX=</xsl:text>
			<xsl:text>ANA:1+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(DeliveryNoteHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>			
			<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(DeliveryNoteHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>			
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$FGN"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>DELIVR9</xsl:text>			
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=1+DELHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>
			<xsl:text>0600</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
			<xsl:choose>
				<xsl:when test="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN != ''">
					<xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:value-of select="js:msSafeText(string(DeliveryNoteHeader/Supplier/SuppliersLocationID/SuppliersCode),17)"/>			
				</xsl:otherwise>
			</xsl:choose>		
		<xsl:value-of select="$sRecordSep"/>
				
		<xsl:text>CDT=</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>		
			<xsl:text>:</xsl:text>		
			<xsl:value-of select="js:msSafeText(string(DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=1</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>Code Table Number</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Code Value</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		-->
				
		<xsl:text>FIL=</xsl:text>
			<xsl:value-of select="$FGN"/>
			<xsl:text>+1+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>	
		
		<xsl:text>MHD=2</xsl:text>				
			<xsl:text>+</xsl:text>
			<xsl:text>DELIVR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>CLO=</xsl:text>			
			<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/GLN"/>			
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 2 = 3001 = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(DeliveryNoteHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 3 = 300A = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode),17)"/>			
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>DEL=</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>
			<xsl:text>:</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveryNoteReferences/DespatchDate"/>
			</xsl:call-template>
			<!-- <xsl:text>+</xsl:text>
			<xsl:text>Nodu</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
			</xsl:call-template> -->				
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>ORF=</xsl:text>
			<xsl:variable name="DeliveryNumber" select="1"/>					
			<xsl:value-of select="$DeliveryNumber"/>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>				
			<xsl:text>:</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="DeliveryNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>				
			<xsl:text>:</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:call-template>
			<xsl:text>:</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="DeliveryNoteHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
			</xsl:call-template>
		<xsl:value-of select="$sRecordSep"/>
				
		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
		
				<xsl:text>DLD=</xsl:text>
					<xsl:value-of select="$DeliveryNumber"/>			
					<xsl:text>+</xsl:text>			
					<xsl:variable name="DLDNumber" select="position()"/>					
					<xsl:value-of select="$DLDNumber"/>
					<xsl:text>+</xsl:text>
					<!-- use GTIN here if 13 dig it EAN number -->
					<xsl:if test="string-length(ProductID/GTIN) = 13 and ProductID/GTIN != '5555555555555'">
						<xsl:value-of select="ProductID/GTIN"/>
					</xsl:if>
					<xsl:text>:</xsl:text>
					<!-- truncate to 30 SPRO 2 = 3071 = AN..30-->
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
						<xsl:with-param name="vnLength" select="30"/>
					</xsl:call-template>	
					<xsl:text>:</xsl:text>
					<xsl:text>+</xsl:text>			
					<xsl:text>+</xsl:text>
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="ProductID/BuyersProductCode"/>
						<xsl:with-param name="vnLength" select="30"/>
					</xsl:call-template>
					<xsl:text>+</xsl:text>			
					<xsl:text>1</xsl:text>
					<xsl:text>:</xsl:text>
					<xsl:text>+</xsl:text>
					<xsl:value-of select="format-number(DespatchedQuantity,'0')"/>
					<xsl:text>:</xsl:text>
					<xsl:text>:</xsl:text>
					<xsl:text>+</xsl:text>
					<xsl:if test="string-length(ProductID/GTIN) = 0">
						<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>	
					</xsl:if>	
					<xsl:text>:</xsl:text>				
				<xsl:value-of select="$sRecordSep"/>
				
				<!-- <xsl:text>DLS=</xsl:text>
				??
				-->
								
				<xsl:text>DNC=</xsl:text>
					<xsl:value-of select="$DeliveryNumber"/>			
					<xsl:text>+</xsl:text>											
					<xsl:value-of select="$DLDNumber"/>
					<xsl:text>+</xsl:text>										
					<!-- <xsl:value-of select="position()"/> -->
					<xsl:text>1</xsl:text>
					<!-- RTEX -->
					<xsl:text>+</xsl:text>
					<xsl:text><!--082--></xsl:text>
					<xsl:text>:</xsl:text>
					<!--<xsl:text> Application Text </xsl:text>-->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>2nd Application Code </xsl:text>-->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>Application Text</xsl:text> -->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>3rd Application Code</xsl:text> -->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>Application Text </xsl:text>-->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>4th Application Code</xsl:text> -->
					<xsl:text>:</xsl:text>
					<!-- <xsl:text>Application Text</xsl:text>-->										
				<xsl:value-of select="$sRecordSep"/>				
								
		
		</xsl:for-each>	
				
		<xsl:text>DTR=</xsl:text>
			<xsl:value-of select="DeliveryNoteTrailer/NumberOfLines"/>					
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>	
			<xsl:value-of select="DeliveryNoteTrailer/NumberOfLines * 2 + 6"/>					
		<xsl:value-of select="$sRecordSep"/>			
	
		
		<xsl:text>MHD=3</xsl:text>			
			<xsl:text>+</xsl:text>
			<xsl:text>DELTLR</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>9</xsl:text>			
		<xsl:value-of select="$sRecordSep"/>
			
		<xsl:text>DFT=</xsl:text>
			<xsl:text>1</xsl:text>			
		<xsl:value-of select="$sRecordSep"/>	
	
		<xsl:text>MTR=3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=4+RSGRSG:2</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>RSG=</xsl:text>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+</xsl:text>
		<xsl:text>BORDERS</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
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
					<xsl:text>Error raised by tsMappingHospitalityInvoiceTradacomsv9BatchOut.xsl.&#13;&#10;</xsl:text>
					
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

