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
 29/06/2006	| Nigel Emsen		| Created module from Cabury Tradacoms V6 mapper
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 28/07/2006 | Nigel Emsen		|	Amend CLO to include Suppliers unit code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 21/08/2006	|	Nigel Emsen		| Case 258: Britvic order mapper changes for implied 3dp.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 08/09/2006	|	Nigel Emsen		| Case 341: Addin Spiecal delivery instructions.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 29/09/2006	|	Nigel Emsen		|	Case 398: spiceal delivery address
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 03/01/2008	|	R Cambridge		|	1687 move from SKU in OLD/SPRO to EAN in SACU
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 05/11/2009| K O'Shaughnessy	| 3224 Amend STX to include the GLN code
==========================================================================================
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="utf-8"/>

<!--xsl:param name="nBatchID">Not Provided</xsl:param-->
	
	<xsl:template match="/PurchaseOrder">
	
		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
			<!--xsl:text>&#13;&#10;</xsl:text-->
			<xsl:text></xsl:text>
		</xsl:variable>
		
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<!-- STX -->
		<xsl:text>STX=</xsl:text>
		
			<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++ -->
			
			<xsl:text>ANA:1+</xsl:text>
			<!-- 
			
					Needs to be the Britvic internal account code for 
					Novus Leisure etc.
					
					Britvic use this code to indentify the head office buyer
					
					Therefore to create a unquie trading relationship, we will 
					use a concatation of 'ABS' & Britvic account code for the buyer.
					
					Account codes:
					==============
					
					Ordering Company		Britvic Acc Code		
					~~~~~~~~~~~~~~~~		~~~~~~~~~~~~~~~~		
					Novus:						402696						
					
					
					Nigel Emsen, 7th July 2006.
										
			-->
			
			<!-- Britvic Account Code -->
			<xsl:variable name="sSuppliersCodeForBuyer" select="translate(/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode,' ','')"/>

			<xsl:choose>
							
				<!-- Acc Code Set in Trading relationship -->
				<xsl:when test="$sSuppliersCodeForBuyer !=''">
					<xsl:value-of select="concat('ABS',$sSuppliersCodeForBuyer)"/>
				</xsl:when>
				
				<!-- No Code Set -->
				<xsl:otherwise>
					<xsl:text>ABSErrMsg_No_SuppliersCodeForBuyer_Set</xsl:text>
				</xsl:otherwise>	
				
			</xsl:choose>
		
			<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++ -->
			
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ShipToName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/><xsl:text>:</xsl:text><xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>		
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">
					<xsl:text>ORDHDR</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>ORDTES</xsl:text></xsl:otherwise>
			</xsl:choose>
		<xsl:text>+</xsl:text>			
		<xsl:text>B</xsl:text>			
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- MHD -->
		<xsl:text>MHD=</xsl:text>	
			<!--<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>-->
			<xsl:text>1+ORDHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- TYP -->
		<xsl:text>TYP=</xsl:text>	
			<xsl:text>0430</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- SDT -->
		<xsl:text>SDT=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 SNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Supplier/SuppliersName),40)"/>
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
			<!--xsl:text>+</xsl:text>
			<xsl:value-of select=""/-->
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- CDT -->
		<xsl:text>CDT=</xsl:text>
			<!-- normally ANA here. Novus do not use ANA's -->
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
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- FIL -->	
		<xsl:text>FIL=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/><xsl:text>+</xsl:text>
			<xsl:text>1+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- MTR -->
		<xsl:text>MTR=</xsl:text>
			<xsl:text>6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<!-- MHD -->
		<xsl:text>MHD=</xsl:text>	
			<!--xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/-->
			<xsl:text>2+</xsl:text>
			<xsl:text>ORDERS:8</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<!-- CLO -->
		<xsl:text>CLO=</xsl:text>
			<xsl:text>:</xsl:text>
			
			<!-- britvic unit account code -->
			<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/> 			
			<xsl:text>:</xsl:text>
			
			<!-- britvic unit account code -->
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
	
		<!-- ORD -->
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
		
		<!-- DIN -->
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
			<xsl:text>++</xsl:text>
			
			<!--
					DIN-DINS-1394 (40 Characters long)
					DIN-DINS-1395 (29 Characters long)

					Please note that whilst the Tradacoms element is 40 characters long, our destination for the data is 70 characters long i.e. 40 characters + 1 					character space + 29 characters)

					DIN=060907+060907++abcdefghijklmnopqrstuvwxyzabcdefghijklmn:opqrstuvwxyzabcdefghijklmnopq’
			-->			

			<xsl:variable name="sSplitDelInstruct">
			
				<xsl:call-template name="mobjGroupText">
					<xsl:with-param name="vsText" select="string(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions)"/>
					<xsl:with-param name="vnFieldLength" select="40"/>
					<xsl:with-param name="vnGroupSize" select="2"/>
				</xsl:call-template>
			
			</xsl:variable>
			
			<!-- Write delivery instructions, 4 sub fields per record -->		
			<xsl:call-template name="writeDelInstruct">
				<xsl:with-param name="vnCount" select="0"/>
				<xsl:with-param name="vobjSplitText" select="msxsl:node-set($sSplitDelInstruct)"/>
				<xsl:with-param name="sRecordSep" select="$sRecordSep"/>
			</xsl:call-template>
			
		<xsl:value-of select="$sRecordSep"/>
				
		
		<!--
		<xsl:text>DNA=</xsl:text>

				???
				
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<!--xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/-->
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<!-- OLD -->
			<xsl:text>OLD=</xsl:text>
			
				<!-- ITEM  SEQA   { First level sequence number             } -->
				<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
				<xsl:text>+</xsl:text>
				
				<!-- ITEM  SPRO   { Supplier's product number               } -->
				<!--xsl:call-template name="msCheckField">
					<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
					<xsl:with-param name="vnLength" select="30"/>
				</xsl:call-template-->
				
				
				<!-- ITEM  SACU   { Supplier's EAN number               } -->
				<xsl:call-template name="msCheckField">
					<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
					<xsl:with-param name="vnLength" select="30"/>
				</xsl:call-template>
				
				<xsl:text>+++::</xsl:text>
				<xsl:value-of select="js:msSafeText(string(OrderedQuantity/@UnitOfMeasure),6)"/>
				<xsl:text>+</xsl:text>
				
				<!-- 23 Aug 2006 - NE - Bunzl can not apply 3dp to the QTY -->
				<xsl:value-of select="format-number(OrderedQuantity,'#0')"/>
				<xsl:text>::</xsl:text>
				
				<xsl:value-of select="js:msSafeText(string(OrderedQuantity/@UnitOfMeasure),6)"/>
				<xsl:text>+</xsl:text>
				
				<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.00'),'.','')"/><xsl:text>00</xsl:text>
				<xsl:text>+++</xsl:text>
				
				<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>
			<!-- End of OLD Segment -->
			<xsl:value-of select="$sRecordSep"/>
			
		<!-- END OF ORDER LINES -->
		</xsl:for-each>
		
		<!-- OTR -->
		<xsl:text>OTR=</xsl:text>	
			<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- MTR -->
		<xsl:text>MTR=</xsl:text>
			<xsl:value-of select="6 + count(PurchaseOrderDetail/PurchaseOrderLine)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- MHD -->	
		<xsl:text>MHD=</xsl:text>	
			<!--xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text-->
			<xsl:text>3+ORDTLR:4</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- OFT -->
		<xsl:text>OFT=</xsl:text>	
			<xsl:text>1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- MTR -->
		<xsl:text>MTR=</xsl:text>	
			<xsl:text>3</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
	
		<!-- END -->
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
				
					<xsl:text>[[tradesimple defined XSLT error]]&#13;&#10;</xsl:text>
				
					<xsl:text>This message contains data that would be truncated when mapped to the appropriate tradacoms field.&#13;&#10;&#13;&#10;</xsl:text>
					
					<xsl:text>THE RECIPIENT MUST BE INFORMED THAT THEY NEED TO PROCESS THIS ORDER MANUALLY </xsl:text>
					<xsl:text>(by reading it from the website or by obtaining a fax from the buyer).&#13;&#10;&#13;&#10;</xsl:text>
					
					<xsl:text>Technical information:&#13;&#10;&#13;&#10;</xsl:text>					
					
					<xsl:text>1)&#13;&#10;</xsl:text>
					<xsl:text>Error raised by tsMappingHospitalityOrderTradacomsv6Out.xsl.&#13;&#10;&#13;&#10;</xsl:text>
					
					<xsl:text>2)&#13;&#10;</xsl:text>
					<xsl:text>The problem element is </xsl:text>
					<xsl:call-template name="msWriteXPath">
						<xsl:with-param name="vobjNode" select="$vobjNode"/>					
					</xsl:call-template>
					<xsl:text>[. = '</xsl:text>
					<xsl:value-of select="$vobjNode"/>
					<xsl:text>'].&#13;&#10;&#13;&#10;</xsl:text>
					
					<xsl:text>3)&#13;&#10;</xsl:text>
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
  Inputs         :  ;  ;  ;  
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
				
					<xsl:for-each select="$vobjSplitText/Field[@Group = $vnCount]">
						<xsl:value-of select="."/>
						<xsl:if test="position() != last()">
							<xsl:text>:</xsl:text>			
						</xsl:if>
					</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>


</xsl:stylesheet>
