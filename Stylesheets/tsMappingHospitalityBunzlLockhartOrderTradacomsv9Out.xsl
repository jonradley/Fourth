<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 	Version			| 
==========================================================================================
 	Date      	| Name 					| Description of modification
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	13/02/2006	| R Cambridge		| Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	13/03/2006	| Lee Boyton			| H574. Turned into Tradacoms version 9.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	20/10/2006 	| Nigel Emsen  	|	created from standard mapper and CLO(2) activated.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	15/11/2006	|	Nigel Emsen		|	Case: 476 - changes for interagtion with PL 
						|							|	and none PL Accounts. and 3dp mapping changes.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	01/12/2006	|	Nigel Emsen		|	Case: 476 - redelivery due to product description
						|							|	being greater than 40 chars.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	06/05/2007	|	Nigel Emsen		|	Case: 1164 - handle zero priced items. detects if
						|							|	unitvalue is present. if not present zero.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	23/08/2008	| Lee Boyton		|	FB2280 - Map out special delivery instructions.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	14/04/2009	| R Cambridge		|	FB2839 - Sorry branch from tsMappingHospitalityBunzlOrderTradacomsv9Out.xsl 
													to use Lockhart's GLN when supplier's GLN is 5555555555555
													(This affects orders from FnB Manager where inbound order 
													 mapper populates suppliers GLN - if this were fixed then 
													 this branch wouldn't be necessary)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           		|           		|	
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
		
		<xsl:variable name="sSpeakMarks">
			<xsl:text>"</xsl:text>
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
			<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:text>5013546009230</xsl:text>
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
			<xsl:text>+</xsl:text>
			<xsl:text></xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
			<!--xsl:text>5013546009230</xsl:text-->
			<xsl:choose>
				<xsl:when test="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
				</xsl:when>
				<!-- 2839 use BCE GLN -->
				<xsl:otherwise>5019757200002</xsl:otherwise>
			</xsl:choose>
			<xsl:text>:</xsl:text>
			<!-- required to strip before the '/' on the Aramark orders as Bunzl require 'ARAMARK'. But Orchid does not have any '/'
					in the trading relationship so we have to test for it first -->
			<xsl:choose>
				<!-- '/' IS present -->
				<xsl:when test="string(substring-after(/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode,'/')) != '' ">
					<xsl:value-of select="substring-after(/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode,'/')"/>
				</xsl:when>
				<!-- '/' IS NOT present -->
				<xsl:otherwise>
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
				</xsl:otherwise>	
			</xsl:choose>			<xsl:text>+</xsl:text>
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
		
		<xsl:text>CDT=</xsl:text>
			<!-- CIDN (1) -->
			<xsl:text>:</xsl:text>
			<!-- CIDN (2) -->
			<!-- required to strip before the '/' on the Aramark orders as Bunzl require 'ARAMARK'. But Orchid does not have any '/'
					in the trading relationship so we have to test for it first -->
			<xsl:choose>
				<!-- '/' IS present -->
				<xsl:when test="string(substring-before(/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode,'/')) != '' ">
					<!-- the trading relationship value before the divider. This needs to be checked for the value Aramark remapping flag. -->
					<xsl:variable name="sTradingRelationshipValue" select="substring-before(/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode,'/')"/>
					<!-- check value -->
					<xsl:choose>
						<!-- spotting for Aramark -->
						<xsl:when test="contains($sTradingRelationshipValue,'ARAM') ">
							<xsl:text>ARAMARK</xsl:text>
						</xsl:when>
						<!-- Any other value -->
						<xsl:otherwise>
							<xsl:value-of select="$sTradingRelationshipValue"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- '/' IS NOT present -->
				<xsl:otherwise>
					<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
				</xsl:otherwise>	
			</xsl:choose>
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
		
		<!--
		<xsl:text>DNA=</xsl:text>

				???
				
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/FileGenerationNumber"/><xsl:text>+</xsl:text>
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
			<xsl:text>+</xsl:text>
			<xsl:variable name="sDeliveryNotes1">
				<xsl:value-of select="substring(string(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions),1,40)"/>
			</xsl:variable>
			<xsl:variable name="sDeliveryNotes2">
				<xsl:value-of select="substring(string(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions),41,40)"/>
			</xsl:variable>
			<xsl:variable name="sDeliveryNotes3">
				<xsl:value-of select="substring(string(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions),81,40)"/>
			</xsl:variable>
			<xsl:variable name="sDeliveryNotes4">
				<xsl:value-of select="substring(string(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions),121,40)"/>
			</xsl:variable>
			<xsl:value-of select="js:msSafeText(string($sDeliveryNotes1),40)"/>
			<xsl:if test="string-length($sDeliveryNotes2) > 0">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string($sDeliveryNotes2),40)"/>
			</xsl:if>
			<xsl:if test="string-length($sDeliveryNotes3) > 0">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string($sDeliveryNotes3),40)"/>
			</xsl:if>
			<xsl:if test="string-length($sDeliveryNotes4) > 0">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string($sDeliveryNotes4),40)"/>
			</xsl:if>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:if test="PurchaseOrderHeader/ShipTo/ContactName != ''">
		<xsl:text>DNA=</xsl:text>
			<!-- SEQA - M - First Level Sequence Nubmer -->
				<!-- 4141 - M - First Level Sequence Number -->
				<xsl:text>1</xsl:text>
				<xsl:text>+</xsl:text>
			<!-- DNAC - O - Data Narrative Code -->
				<!-- 9140 O - Code Table Number -->
				<!-- 9141 O - Code Value -->
				<xsl:text>+</xsl:text>
			<!-- RTEX - O - Registered Text -->
				<!-- 9130 O - Application Code -->
				<xsl:text>138</xsl:text>
				<xsl:text>:</xsl:text>
				<!-- 9131 O - First Application Text -->
				<xsl:value-of select="js:msSafeText(string(PurchaseOrderHeader/ShipTo/ContactName),35)"/>
			<!-- GNAR - O - General Narrative -->
				<!-- 9040 O - General Narrative Line 1 -->
				<!-- 9040 O - General Narrative Line 2 -->
				<!-- 9040 O - General Narrative Line 3 -->
				<!-- 9040 O - General Narrative Line 4 -->
			<xsl:value-of select="$sRecordSep"/>
			</xsl:if>

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
				<xsl:choose>
					<xsl:when test="string(UnitValueExclVAT) !='' ">
						<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>00000</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<!-- truncate to 40 TDES = 9030 = AN..40-->
				<xsl:variable name="sProductDescription" select="substring(ProductDescription,1,39)"/>
				<!-- 01/12/06 
				<xsl:call-template name="msCheckField">
					<xsl:with-param name="vobjNode" select="$sProductDescription"/>
					<xsl:with-param name="vnLength" select="40"/>
				</xsl:call-template>
				-->
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
	
	
<!-- ==============================================================
		Function: to replace lower case with upcase and take the word
						before the first space
		============================================================== -->
		<xsl:template name="msGetCIDN">
			<xsl:param name="vsXPath"/>
			
			<xsl:variable name="sFirstWord" select="substring-before($vsXPath,' ')"/>
			<xsl:variable name="sToUpperCase" select="translate($sFirstWord,'abcdefghijklmnopqrstuvxwyz','ABCDEFGHIJKLMNOPQRSTUVXWYZ')"/>
			
			<xsl:value-of select="$sToUpperCase"/>
			
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
