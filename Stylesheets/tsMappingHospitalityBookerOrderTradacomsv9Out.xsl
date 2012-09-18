<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 13/04/2010	| M Dimant			|	Created module based on standard tradacoms mapper. Added line comments in DNA segment.
==========================================================================================
11/01/2012	| M Emanuel			| Created Order out mapper for Booker
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>

<!--xsl:param name="nBatchID">Not Provided</xsl:param-->
	
	<xsl:template match="/PurchaseOrder">
	
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
			<xsl:text>:FOURTH HOSPITALITY</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- Your mailbox reference, Text inserted by me -->
			<xsl:text>5011295000016</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/><xsl:text>:</xsl:text><xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
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
			<xsl:text></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
			<!--xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/-->
			<xsl:text>5011295000016</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName),17)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 SNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName),17)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->	

			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
			<xsl:text>:</xsl:text>

			<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		

			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode),8)"/>	

		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersName),40)"/>
			<xsl:text>+</xsl:text> 
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/SendersAddress/PostCode),8)"/>
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
			<!--xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/-->
			<xsl:text>2+</xsl:text>
			<xsl:text>ORDERS:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		
		<xsl:text>CLO=</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>:</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
			<xsl:text>+</xsl:text>
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
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>DIN=</xsl:text>
			<!--xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/-->
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
			</xsl:call-template>
			
		<xsl:value-of select="$sRecordSep"/>
		
		
		<!--xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/-->
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:text>OLD=</xsl:text>
				<!--xsl:value-of select="HelperObj:GetNextCounterValue('OrderLineDetails')"/-->
				<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
				<xsl:text>+9999999999999:</xsl:text>
				<xsl:call-template name="msCheckField">
					<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
					<xsl:with-param name="vnLength" select="30"/>
				</xsl:call-template>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>1::</xsl:text>
				<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="format-number(OrderedQuantity,'0')"/>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<!-- truncate to 40 TDES = 9030 = AN..40-->
				<!-- 1556 Just truncate, don't raise an error for values greater than 40 chars -->
				<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>

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
	
<!--=======================================================================================
  Routine        : writeDelInstruct()
  Description    : Takes xml fragment of the form
    			
								<Field Group="1">blah</Field>
								<Field Group="1">rhubarb</Field>
								<Field Group="1">yadder</Field>
								<Field Group="1">yak</Field>
								<Field Group="2">guff</Field>
	
							and writes all <Field/> elements in the same group into one record
							recusring until noi more records are required
				  
  Inputs         : 
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="writeDelInstruct">
		<xsl:param name="vnCount"/>
		<xsl:param name="vobjSplitText"/>
		<xsl:param name="sRecordSep"/>

		<xsl:choose>
			<!-- No work left ot do -->
			<xsl:when test="count($vobjSplitText/Field[@Group = $vnCount]) = 0"/>
			
			<!-- Write this group into a sequence of subfields of field 4 -->
			<xsl:otherwise>
				<xsl:text>DNA=</xsl:text>
					<xsl:value-of select="string($vnCount + 1)"/>
					<xsl:text>+++</xsl:text>
					
					<xsl:for-each select="$vobjSplitText/Field[@Group = $vnCount]">
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">
							<xsl:text>:</xsl:text>			
						</xsl:if>
					</xsl:for-each>
						
					<xsl:value-of select="$sRecordSep"/>
				
					<!-- Check for another group by recursing -->
					<xsl:call-template name="writeDelInstruct">
						<xsl:with-param name="vnCount" select="$vnCount + 1"/>
						<xsl:with-param name="vobjSplitText" select="$vobjSplitText"/>
						<xsl:with-param name="sRecordSep" select="$sRecordSep"/>

					</xsl:call-template>
					
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	
<!--=======================================================================================
  Routine        : mobjGroupText()
  Description    : Escapes vsText and passes it to msSplitText_EscapeAware()
				  
  Inputs         : 
  Outputs        : 
  Returns        : A string that will be passed into msxsl:node-set()
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="mobjGroupText">
		<xsl:param name="vsText"/>
		<xsl:param name="vnFieldLength"/>
		<xsl:param name="vnGroupSize"/>

		<xsl:call-template name="msSplitText_EscapeAware">
			<xsl:with-param name="vsText" select="js:msEscape($vsText)"/>
			<xsl:with-param name="vnFieldLength" select="$vnFieldLength"/>
			<xsl:with-param name="vnGroupSize" select="$vnGroupSize"/>
		</xsl:call-template>	
	
	</xsl:template>
	

<!--=======================================================================================
  Routine        : msSplitText_EscapeAware()
  Description    : Creates and xml fragment of the form
    			
								<Field Group="1">blah</Field>
								<Field Group="1">rhubarb</Field>
								<Field Group="1">yadder</Field>
								<Field Group="1">yak</Field>
								<Field Group="2">guff</Field>
	
							The content of <Field/> is controlled by vnFieldLength
							@Group relates <Field/> elements together, the number in each groups is controlled by vnGroupSize
				  
  Inputs         : 
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="msSplitText_EscapeAware">
		<xsl:param name="vsText"/>
		<xsl:param name="vnFieldLength"/>
		<xsl:param name="vnGroupSize"/>
		<xsl:param name="vnCurrentGroup" select="0"/>
		<xsl:param name="vnCount" select="0"/>
		
		<!-- the next group of characters, shorted if necessary so as not to break an escape sequences -->
		<xsl:variable name="sFirstField" select="js:msTruncate($vsText, $vnFieldLength)"/>
		
		<xsl:choose>
		
			<!-- Base case, no text left to process -->
			<xsl:when test="$sFirstField = ''"/>
			
			<xsl:otherwise>
			
				<!-- Write out this group of characters -->			
				<Field>
					<xsl:attribute name="Group">
						<xsl:value-of select="$vnCurrentGroup"/>
					</xsl:attribute>
					
					<xsl:value-of select="$sFirstField"/>
				
				</Field>
				
				<!-- Process the rest of the input -->
				<xsl:call-template name="msSplitText_EscapeAware">
					<xsl:with-param name="vsText" select="substring-after($vsText, $sFirstField)"/>
					<xsl:with-param name="vnFieldLength" select="$vnFieldLength"/>
					<xsl:with-param name="vnGroupSize" select="$vnGroupSize"/>
					<xsl:with-param name="vnCurrentGroup">
						<xsl:choose>
							<xsl:when test="$vnCount + 1 = $vnGroupSize">
								<xsl:value-of select="$vnCurrentGroup + 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$vnCurrentGroup"/>
							</xsl:otherwise>
						</xsl:choose>					
					</xsl:with-param>
					<xsl:with-param name="vnCount">
						<xsl:choose>
							<xsl:when test="$vnCount + 1 = $vnGroupSize">0</xsl:when>							
							<xsl:otherwise>
								<xsl:value-of select="$vnCount + 1"/>
							</xsl:otherwise>
						</xsl:choose>
					
					</xsl:with-param>
				</xsl:call-template>
			
			</xsl:otherwise>
			
		</xsl:choose>
	
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
