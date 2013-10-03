<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 13/02/2006	| R Cambridge			| Created module
==========================================================================================
 13/03/2006	| Lee Boyton      	| H574. Turned into Tradacoms version 9.
==========================================================================================
 19/10/2006	| R Cambridge      	| FB235: Converted to a batch processor for S&N UK 
 												Adoption for Orchid Pubs and TCG
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:HelperObj="urn:XSLHelper" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:param name="sDocumentDate">Not Provided</xsl:param>
	<xsl:param name="sDocumentTime">Not Provided</xsl:param>
	<xsl:param name="nBatchID">Not Provided</xsl:param>
	
	<xsl:template match="/BatchRoot[PurchaseOrder]">
	
		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
			<!--<xsl:text>&#13;&#10;</xsl:text>-->
			<xsl:text></xsl:text>
		</xsl:variable>
		
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<xsl:text>STX=</xsl:text>
			<xsl:text>ANA:1+</xsl:text>
			<!--Our mailbox reference-->
			<xsl:choose>
				<xsl:when test="PurchaseOrder/TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>5013546145710</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>5013546164209</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/><xsl:text>:</xsl:text><xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$nBatchID"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>		
			<xsl:choose>
				<xsl:when test="PurchaseOrder/TradeSimpleHeader/TestFlag = 'false' or PurchaseOrder/TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>ORDHDR</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>ORDTES</xsl:text></xsl:otherwise>
			</xsl:choose>
		<xsl:text>+</xsl:text>			
		<xsl:text>B</xsl:text>			
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=</xsl:text>	
			<!--<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>-->
			<xsl:text>1+ORDHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>	
			<xsl:text>0430</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 SNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName),40)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
			<xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode),8)"/>		
			<!--xsl:text>+</xsl:text>
			<xsl:value-of select=""/-->
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName),40)"/>
			<xsl:text>+</xsl:text> 
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrder/PurchaseOrderHeader/Buyer/SendersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=</xsl:text>

				???
				
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
			<xsl:value-of select="$nBatchID"/><xsl:text>+</xsl:text>
			<xsl:text>1+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>
			<xsl:text>6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	

	
		<xsl:for-each select="PurchaseOrder">
	
			<xsl:text>MHD=</xsl:text>	
				<xsl:value-of select="format-number(count(preceding-sibling::* | self::*) + 1,'0')"/>
				<xsl:text>+</xsl:text>
				<xsl:text>ORDERS:9</xsl:text>
			<xsl:value-of select="$sRecordSep"/>
	
			
			<xsl:text>CLO=</xsl:text>
				<!--xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/-->
				<xsl:text>:</xsl:text>
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
				<xsl:text>+</xsl:text>
				<!-- truncate to 40 CNAM = 3060 = AN..40-->
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToName),40)"/>
				<xsl:text>+</xsl:text>
				<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
				<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode),8)"/>
			<xsl:value-of select="$sRecordSep"/>
		
			<xsl:text>ORD=</xsl:text>
				<xsl:call-template name="msCheckField">
					<xsl:with-param name="vobjNode" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					<xsl:with-param name="vnLength" select="17"/>
				</xsl:call-template>
				<xsl:text>:</xsl:text>
				<xsl:text>:</xsl:text>
				<xsl:call-template name="msFormateDate">
					<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</xsl:call-template>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>N+</xsl:text>
			<xsl:value-of select="$sRecordSep"/>
			
			<xsl:text>DIN=</xsl:text>
				<!--xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/-->
				<xsl:call-template name="msFormateDate">
					<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				</xsl:call-template>
				<xsl:text>+</xsl:text>
				<!--xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/-->
				<xsl:call-template name="msFormateDate">
					<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				</xsl:call-template>
				<xsl:text>+</xsl:text>
			<xsl:value-of select="$sRecordSep"/>
			
			<!--
			<xsl:text>DNA=</xsl:text>
	
					???
					
			<xsl:value-of select="$sRecordSep"/>
			-->
			
			<!--xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/-->
			<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
				<xsl:text>OLD=</xsl:text>
					<!--xsl:value-of select="HelperObj:GetNextCounterValue('OrderLineDetails')"/-->
					<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
					<xsl:text>+</xsl:text>
					<xsl:text>:</xsl:text>
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
						<xsl:with-param name="vnLength" select="30"/>
					</xsl:call-template>
					<xsl:text>+</xsl:text>
					<xsl:text>+</xsl:text>
					<xsl:text>:</xsl:text>
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="ProductID/BuyersProductCode"/>
						<xsl:with-param name="vnLength" select="30"/>
					</xsl:call-template>
					<xsl:text>+::</xsl:text>
					<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
					<xsl:text>+</xsl:text>
					<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
					<xsl:text>:</xsl:text>
					<xsl:value-of select="translate(format-number(OrderedQuantity,'#.000'),'.','')"/>
					<xsl:text>+</xsl:text>
					<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.00'),'.','')"/><xsl:text>00</xsl:text>
					<xsl:text>+</xsl:text>
					<xsl:text>+</xsl:text>
					<xsl:text>+</xsl:text>
					<!-- truncate to 40 TDES = 9030 = AN..40-->
					<!--xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="ProductDescription"/>
						<xsl:with-param name="vnLength" select="40"/>
					</xsl:call-template-->
					<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>
					
					
					
				<xsl:value-of select="$sRecordSep"/>
				
				<!--
				<xsl:text>DNB=</xsl:text>
		
						???
						
				<xsl:text>'</xsl:text>
				<xsl:value-of select="$sLineBreak"/>
				-->
				
			</xsl:for-each>
			
			<xsl:text>OTR=</xsl:text>	
				<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
			<xsl:value-of select="$sRecordSep"/>
			
			<xsl:text>MTR=</xsl:text>
				<xsl:value-of select="6 + count(PurchaseOrderDetail/PurchaseOrderLine)"/>
			<xsl:value-of select="$sRecordSep"/>
			
		</xsl:for-each>
		
				
		<xsl:text>MHD=</xsl:text>	
			<xsl:value-of select="format-number(count(/BatchRoot/PurchaseOrder) + 2,'0')"/>
			<xsl:text>+ORDTLR:9</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>OFT=</xsl:text>	
			<xsl:value-of select="format-number(count(/BatchRoot/PurchaseOrder),'0')"/>			
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>	
			<xsl:text>3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>END=</xsl:text>
			<xsl:text>3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
	</xsl:template>
	

<!--=======================================================================================
  Routine        : msFormateDate()
  Description    :  
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
