<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview
============================lo==============================================================
 24/05/2013	| S Hussain 				|	Created
==========================================================================================
 17/07/2013	| S Hussain 				|	FB 6793 - Incorporate changes to inclue a : before the product code
=======================================================================================--
>15/10/2013	| B Oliver & J MIguel	|	FB 7153 - Changes in CLO segment as requested by supplier.
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:variable name="sRecordSep"><xsl:text>'</xsl:text></xsl:variable>
	<xsl:template match="/PurchaseOrder">
		<xsl:variable name="sFileGenerationDate" select="js:msFileGenerationDate()"/>
		<xsl:text>STX=</xsl:text>
		<xsl:text>ANAA:1+</xsl:text>
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
		<xsl:value-of select="$sFileGenerationDate"/><xsl:text>:</xsl:text><xsl:value-of select="js:msFileGenerationTime()"/>
		<xsl:text>+</xsl:text>
		<xsl:choose>
			<xsl:when test="PurchaseOrderHeader/FileGenerationNumber">
				<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>55555</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>+</xsl:text>
		<xsl:text>       </xsl:text>
		<xsl:text>+</xsl:text>		
		<xsl:choose>
			<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
				<xsl:text>ORDHDR</xsl:text>
			</xsl:when>
			<xsl:otherwise><xsl:text>ORDTES</xsl:text></xsl:otherwise>
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
		<xsl:text>NEW-ORDERS</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/><xsl:text>:</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/><xsl:text>+</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Supplier/SuppliersName"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/Buyer/BuyersName"/> 
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/><xsl:text>+</xsl:text>
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
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/><xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/><xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/><xsl:text>:</xsl:text>
		<xsl:apply-templates select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/><xsl:text>:</xsl:text>
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
		<xsl:text>+</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
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
		<xsl:text>SHIP AS ORDERED-NO BACK ORDERS:RING RDC WITH ORDER CHANGES:BOOK IN 3 DAYS IN ADVANCE:ORDER TO COMPLY WITH SUPPLIERS GUIDE</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
		
		<xsl:apply-templates select="/PurchaseOrder/PromotionsDetail/PurchaseOrderLine"/>
		
		<xsl:text>OTR=</xsl:text>	
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
	
		<xsl:text>MHD=</xsl:text>	
		<xsl:text>4+RSGRSG:2</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>RSG=</xsl:text>	
		<xsl:text>+</xsl:text>
		<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>	
		<xsl:text>3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>END=</xsl:text>
		<xsl:text>4</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDetail/PurchaseOrderLine | /PurchaseOrder/PromotionsDetail/PurchaseOrderLine">
		<xsl:text>OLD=</xsl:text>
		<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
		<xsl:text>+</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:call-template name="msCheckField">
			<xsl:with-param name="vobjNode" select="./ProductID/SuppliersProductCode"/>
			<xsl:with-param name="vnLength" select="30"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="format-number(./OrderedQuantity,'0')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(./UnitValueExclVAT,'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
			
		<!-- IS a Promotion line -->
		<xsl:choose>
			<xsl:when test="name(..) = 'PromotionsDetail'">
				<xsl:if test="format-number(UnitValueExclVAT,'0') = 0 ">
					<xsl:text>F</xsl:text>
				</xsl:if>
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
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:apply-templates select="./ProductDescription"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="./PackSize"/>
		<xsl:value-of select="$sRecordSep"/>
	</xsl:template>

	<xsl:template match="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1 | PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2 |
									 PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3 | PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4 |
									 PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1 | PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2 |
									 PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3 | PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4">
		<xsl:value-of select="js:msSafeText(string(.), 35)"/>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderHeader/Supplier/SuppliersName | PurchaseOrderHeader/Buyer/BuyersName |  PurchaseOrderHeader/ShipTo/ShipToName |
									 ProductDescription">
		<xsl:value-of select="js:msSafeText(string(.), 40)"/>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode | PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode | 
									 PurchaseOrderHeader/Buyer/SendersAddress/PostCode">
		<xsl:value-of select="js:msSafeText(string(.), 8)"/>
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
	
<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
/*==========================================================================================
' Routine        : msFileGenerationDate()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
'==========================================================================================*/
function msFileGenerationDate(){
	var dtDate = new Date();
	var sDate = dtDate.getDate();
	if(sDate<10)
	{
		sDate = '0' + sDate;
	}
	var sMonth = dtDate.getMonth() + 1;
	if(sMonth<10)
	{
		sMonth = '0' + sMonth;
	}
	var sYear  = dtDate.getYear()  + '';
	sYear = sYear.substr(2,2)
	return sYear + ''+ sMonth +''+ sDate;
}
/*==========================================================================================
' Routine        : msFileGenerationTime()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
'==========================================================================================*/
function msFileGenerationTime(){
	var dtDate = new Date();
	return dtDate.getHours() + '' + dtDate.getMinutes() + '' + dtDate.getSeconds();
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
]]></msxsl:script>
</xsl:stylesheet>
