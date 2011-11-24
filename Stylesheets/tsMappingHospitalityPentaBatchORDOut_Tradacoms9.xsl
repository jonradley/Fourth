<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2009
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 18/04/2011| K Oshaughnessy			|	Created module 4394
==========================================================================================
				|							|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:import href="tsMappingHospitalityPentaFoodsOrderTradacomsv9Out.xsl"/>

	<xsl:output method="text" encoding="utf-8"/>

	<!-- This is a place holder for the batching out processor to complete. -->
	<xsl:param name="nBatchID">Not Provided</xsl:param>
	<xsl:key name="DistinctProductCode" match="/BatchRoot/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine" use="ProductID/SuppliersProductCode"/>
		
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
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
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
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/>
			<xsl:text>+</xsl:text>
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
			<!--<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>-->
			<xsl:text>1+ORDHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>	
			<xsl:text>0430</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
			<xsl:text>5555555555555</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>ITS999</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 SNAM = 3060 = AN..40-->
			<xsl:text>Penta Foods (chilled)(P2P)</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
			<xsl:text>No. 30 Wellington Road</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>Berkshire</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
			<xsl:text>GU47 9AY'</xsl:text>		
			<!--xsl:text>+</xsl:text>
			<xsl:value-of select=""/-->
		<!--xsl:value-of select="$sRecordSep"/-->
		
		<xsl:text>CDT=</xsl:text>
			
			<xsl:text>:</xsl:text>
			<xsl:text>ITS999</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:text>itsu</xsl:text>
			<xsl:text>+</xsl:text> 
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<!-- Hard coded for Itsu batch orders-->
			<xsl:text>8 DEBEN MILL BUSINESS CENTRE</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>WOODBRIDGE</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>SUFFOLK</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>UK</xsl:text><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:text>IP12 1BL</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=</xsl:text>

				???
				
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
			<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/><xsl:text>+</xsl:text>
			<xsl:text>1+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>
			<xsl:text>6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	

	
		<!--xsl:value-of select="HelperObj:ResetCounter('DataNarativeA')"/-->
	
		<xsl:text>MHD=</xsl:text>	
			<!--xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/-->
			<xsl:text>2+</xsl:text>
			<xsl:text>ORDERS:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		
		<xsl:text>CLO=</xsl:text>
			<!--xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/-->
			<xsl:text>:</xsl:text>
			<!--xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/-->
			<xsl:text>:</xsl:text>
			<xsl:text>ITS999</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:text>itsu</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:text>1st Floor Dorland House</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>18-20 Lower Regent Street</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>London</xsl:text><xsl:text>:</xsl:text>
			<xsl:text>London</xsl:text><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:text>SW1Y 4PH</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>ORD=</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="//PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="//PurchaseOrderHeader/FileGenerationNumber"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>
			<xsl:text>:</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>N+</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>DIN=</xsl:text>
			<!-- Get earliest delivery date -->
			<xsl:for-each select="//OrderedDeliveryDetails/DeliveryDate">
				<xsl:sort select="."/>
				
				<xsl:if test="position() = 1">
					<xsl:call-template name="msFormateDate">
						<xsl:with-param name="vsUTCDate" select="."/>
					</xsl:call-template>
				</xsl:if>
				
			</xsl:for-each>
			
			<xsl:text>+</xsl:text>
			<!--xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/-->
			<!-- Get latest delivery date -->
			<xsl:for-each select="//OrderedDeliveryDetails/DeliveryDate">
				<xsl:sort select="."/>
				
				<xsl:if test="position() = last()">
					<xsl:call-template name="msFormateDate">
						<xsl:with-param name="vsUTCDate" select="."/>
					</xsl:call-template>
				</xsl:if>
				
			</xsl:for-each>
			<xsl:text>+</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=</xsl:text>

				???
				
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<!--xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/-->
		<xsl:for-each select="/BatchRoot/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine[generate-id() = generate-id(key('DistinctProductCode',ProductID/SuppliersProductCode)[1])]">
		
			<xsl:text>OLD=</xsl:text>
				<!--xsl:value-of select="HelperObj:GetNextCounterValue('OrderLineDetails')"/-->
				<xsl:value-of select="count(preceding::PurchaseOrderLine[generate-id() = generate-id(key('DistinctProductCode',ProductID/SuppliersProductCode)[1])] | self::*)"/>
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
					<xsl:value-of select="(key('DistinctProductCode',ProductID/SuppliersProductCode)/OrderedQuantity/@UnitOfMeasure)"/>	
				<xsl:text>+</xsl:text>
					<xsl:value-of select="sum(key('DistinctProductCode',ProductID/SuppliersProductCode)/OrderedQuantity)"/>
				<xsl:text>:</xsl:text>
					<xsl:value-of select="translate(format-number(sum(key('DistinctProductCode',ProductID/SuppliersProductCode)/OrderedQuantity),'#.000'),'.','')"/>
				<xsl:text>+</xsl:text>
					<xsl:value-of select="translate(format-number(sum(key('DistinctProductCode',ProductID/SuppliersProductCode)/UnitValueExclVAT),'#.000'),'.','')"/><xsl:text>00</xsl:text>	
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<!-- truncate to 40 TDES = 9030 = AN..40-->
				<!-- 1556 Just truncate, don't raise an error for values greater than 40 chars -->
				<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>

			<xsl:value-of select="$sRecordSep"/>
			
			<!--
			<xsl:text>DNB=</xsl:text>
	
					???
					
			<xsl:text>'</xsl:text>
			<xsl:value-of select="$sLineBreak"/>
			-->
			
		</xsl:for-each>
		
		<!-- FogBuz 972 - Marstons Promotions, NE, May 2007 -->
		<!-- Check if Promotions element present -->
		<xsl:for-each select="/PurchaseOrder/PromotionsDetail/PurchaseOrderLine">
							
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
					
		</xsl:for-each>		
		
		<xsl:text>OTR=</xsl:text>	
			<!-- 24 May 2007, FB: 972 - NE - Order count to include promotional lines -->
			<xsl:value-of select="count(//PurchaseOrderLine)"/>
			
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=</xsl:text>
			<xsl:value-of select="6 + count(PurchaseOrderDetail/PurchaseOrderLine)"/>
		<xsl:value-of select="$sRecordSep"/>
		
				
		<xsl:text>MHD=</xsl:text>	
			<!--xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text-->
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
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''),3)"/>
	
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
