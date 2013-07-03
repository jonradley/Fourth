<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2012 (http://www.altova.com) by Fourth Hospitality (Fourth Hospitality) -->
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					|	Description of modification
==========================================================================================
 13/02/2006	| R Cambridge			|	Created module
==========================================================================================
 13/03/2006	| Lee Boyton      	|	H574. Turned into Tradacoms version 9.
==========================================================================================
 23/05/2007	|Nigel Emsen			|	FB 972: Amendments to handle Marstons promotions.
==========================================================================================
 07/01/2008	| R Cambridge			|	1556 don't truncate product description
==========================================================================================
 31/03/2010	| H Mahbub   			|	3440 Adding special delivery instuctions
==========================================================================================
 15/11/2010	| R Cambridge			|	3956 Product code manipulation (remove UoM indicator if present)
 													  If UoM indicator is present use UoM inplace of PackSize (Bibendum's system will lookup pack size)
==========================================================================================
 15/05/2013	| S Hussain			|	6496 Optimization
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>
	 
	 <xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
	</xsl:variable>
	
	<xsl:template match="/PurchaseOrder">
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
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersName"/>
		<xsl:text>+</xsl:text>
		<!--Your mailbox reference-->
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersName"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="vb:msFileGenerationTime()"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
				<xsl:text>ORDHDR</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>ORDTES</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>+</xsl:text>
		<xsl:text>B</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MHD=</xsl:text>
		<xsl:text>1+ORDHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>TYP=</xsl:text>
		<xsl:text>0430</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>SDT=</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>CDT=</xsl:text>
		<!--xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/-->
		<xsl:text>:</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/SendersAddress/PostCode"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
		<xsl:text>+</xsl:text>
		<xsl:text>1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MTR=</xsl:text>
		<xsl:text>6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MHD=</xsl:text>
		<xsl:text>2+</xsl:text>
		<xsl:text>ORDERS:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>CLO=</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
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
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<!--Below is because stirling have a 60 character limit/-->
		<xsl:value-of select="js:msSafeText(substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,1,30),40)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,31,30),40)"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
		<xsl:apply-templates select="PurchaseOrder/PromotionsDetail/PurchaseOrderLine"/>
        <xsl:text>OTR=</xsl:text>
		<!-- 24 May 2007, FB: 972 - NE - Order count to include promotional lines -->
		<xsl:value-of select="count(//PurchaseOrderLine)"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MTR=</xsl:text>
		<xsl:value-of select="6 + count(PurchaseOrderDetail/PurchaseOrderLine)"/>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MHD=</xsl:text>
		<xsl:text>3+ORDTLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>OFT=</xsl:text>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>MTR=</xsl:text>
		<xsl:text>3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		<xsl:text>END=</xsl:text>
		<xsl:text>3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	</xsl:template>

	<xsl:template match="PurchaseOrderHeader/Buyer/BuyersName | PurchaseOrderHeader/Supplier/SuppliersName |
									 PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1 | PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2 | 
									 PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3 | PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4 |
									 PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1 | PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2 |
									 PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3 | PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1 | PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2 |
									 PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3 | PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4">
		<xsl:value-of select="js:msSafeText(string(.),35)"/>
	</xsl:template>
		
	<xsl:template match="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode | PurchaseOrderHeader/Buyer/SendersAddress/PostCode |
									 PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode">
		<xsl:value-of select="js:msSafeText(string(.),8)"/>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDetail/PurchaseOrderLine">
		<xsl:text>OLD=</xsl:text>
		<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
		<xsl:text>+</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:call-template name="msCheckField">
			<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="vnLength" select="30"/>
			<xsl:with-param name="vsModifiedValue">
				<xsl:choose>
					<xsl:when test="contains(ProductID/SuppliersProductCode,'-E')">
						<xsl:value-of select="substring-before(ProductID/SuppliersProductCode,'-E')"/>
					</xsl:when>
					<xsl:when test="contains(ProductID/SuppliersProductCode,'-C')">
						<xsl:value-of select="substring-before(ProductID/SuppliersProductCode,'-C')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:call-template name="msCheckField">
			<xsl:with-param name="vobjNode" select="ProductID/BuyersProductCode"/>
			<xsl:with-param name="vnLength" select="30"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(ProductID/SuppliersProductCode,'-E')">EA</xsl:when>
			<xsl:when test="contains(ProductID/SuppliersProductCode,'-C')">CS</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="PackSize"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>::</xsl:text>
		<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="translate(format-number(OrderedQuantity,'#.000'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.00'),'.','')"/>
		<xsl:text>00</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 TDES = 9030 = AN..40-->
		<!-- 1556 Just truncate, don't raise an error for values greater than 40 chars -->
		<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>
		<xsl:value-of select="$sRecordSep"/>
	</xsl:template>

	<xsl:template match="PurchaseOrder/PromotionsDetail/PurchaseOrderLine">
		<!-- FogBuz 972 - Marstons Promotions, NE, May 2007 -->
		<!-- Check if Promotions element present -->
		<xsl:text>OLD=</xsl:text>
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
		<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.00'),'.','')"/>
		<xsl:text>00</xsl:text>
		<xsl:text>+</xsl:text>
		<!-- IS a Promotion line and price is zero -->
		<xsl:if test="format-number(UnitValueExclVAT,'0') = 0 ">
			<xsl:text>F</xsl:text>
		</xsl:if>
		<!-- IS a Promotion line and price is not zero -->
		<xsl:if test="format-number(UnitValueExclVAT,'0') &gt; 0">
			<xsl:text>P</xsl:text>
		</xsl:if>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 TDES = 9030 = AN..40-->
		<xsl:call-template name="msCheckField">
			<xsl:with-param name="vobjNode" select="ProductDescription"/>
			<xsl:with-param name="vnLength" select="40"/>
		</xsl:call-template>
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
						  vsModifiedValue, optional string containing modified version of contents of vobjNode
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msCheckField">
		<xsl:param name="vobjNode"/>
		<xsl:param name="vnLength"/>
		<xsl:param name="vsModifiedValue"/>
		<xsl:variable name="sEscapedField">
			<xsl:choose>
				<xsl:when test="$vsModifiedValue != ''">
					<xsl:value-of select="js:msEscape(string($vsModifiedValue))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="js:msEscape(string($vobjNode))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
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
