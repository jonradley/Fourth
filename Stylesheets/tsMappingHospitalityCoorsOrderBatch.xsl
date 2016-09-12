<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd., 2000.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
     ?     	|        ?				| ?
==========================================================================================
 2008-09-11	| R Cambridge     	| 2459 override any ship-to ANA/GLN provided
==========================================================================================
J Miguel	| 24/08/2016		| FB11254 - Adapt mapper to change in their backend
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:HelperObj="urn:XSLHelper" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text" encoding="utf-8"/>

<xsl:param name="sDocumentDate">Not Provided</xsl:param>
<xsl:param name="sDocumentTime">Not Provided</xsl:param>
<xsl:param name="nBatchID">Not Provided</xsl:param>

<xsl:template match="/BatchRoot[PurchaseOrder]">

	<xsl:variable name="sLineBreak">
		<!--xsl:text>&#13;&#10;</xsl:text-->
		<xsl:text></xsl:text>
	</xsl:variable>

	<xsl:value-of select="HelperObj:ResetCounter('MessageHeader')"/>
	<xsl:value-of select="HelperObj:ResetCounter('DataNarativeA')"/>
	<xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/>

	<xsl:text>STX=</xsl:text>
		<xsl:text>ANA:1+</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="$sDocumentDate"/><xsl:text>:</xsl:text><xsl:value-of select="$sDocumentTime"/><xsl:text>+</xsl:text>
		<xsl:value-of select="$nBatchID"/><xsl:text>+</xsl:text>		
		<xsl:text>+</xsl:text>		
		<xsl:choose>
			<xsl:when test="/BatchRoot/PurchaseOrder/TradeSimpleHeader/TestFlag = 'false'">
				<xsl:text>ORDHDR</xsl:text>
			</xsl:when>
			<xsl:otherwise><xsl:text>ORDTES</xsl:text></xsl:otherwise>
		</xsl:choose>
	<xsl:text>+</xsl:text>			
	<xsl:text>B</xsl:text>			
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>MHD=</xsl:text>	
		<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>
		<xsl:text>ORDHDR:9</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>TYP=</xsl:text>	
		<xsl:text>0430</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>NEW-ORDERS</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>SDT=</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/TradeSimpleHeader/SendersCodeForRecipient"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode),8)"/>		
		<!--xsl:text>+</xsl:text>
		<xsl:value-of select=""/-->
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>CDT=</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/BatchRoot/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/PurchaseOrder/PurchaseOrderHeader/Buyer/SendersAddress/PostCode),8)"/>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="$nBatchID"/><xsl:text>+</xsl:text>
		<xsl:text>1+</xsl:text>
		<xsl:value-of select="$sDocumentDate"/>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>MTR=</xsl:text>
		<xsl:text>6</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>

	<xsl:for-each select="/BatchRoot/PurchaseOrder">
	
		<xsl:value-of select="HelperObj:ResetCounter('DataNarativeA')"/>
	
		<xsl:text>MHD=</xsl:text>	
			<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/>
			<xsl:text>+</xsl:text>
			<xsl:text>ORDERS:9</xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>

		
		<xsl:text>CLO=</xsl:text>
			<xsl:text>5555555555555</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToName),40)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msTruncate(string(PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode),8)"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>
	
		<xsl:text>ORD=</xsl:text>
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>:</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate))"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>
		
		<xsl:text>DIN=</xsl:text>
			<xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="HelperObj:FormatDate(string(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate))"/>
			<xsl:text>+</xsl:text>
			<!-- NOTE: The second part of this is position 5 due to the escaping of the ":" in the time in the XML...  
			           as in "10:00" becomes "10?:00" before the transform step. -->
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart,1,2)"/>
			<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart,5,2)"/>
			<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd != ''">
				<xsl:text>:</xsl:text>
			<!-- NOTE: The second part of this is position 5 due to the escaping of the ":" in the time in the XML...  
			           as in "10:00" becomes "10?:00" before the transform step. -->
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd,1,2)"/>
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd,5,2)"/>
			</xsl:if>
			<xsl:text>+</xsl:text>
			<xsl:if test="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,1,40) != ''">
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,1,40)"/>
			</xsl:if>
			<xsl:if test="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,41,40) != ''">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,41,40)"/>
			</xsl:if>
			<xsl:if test="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,81,40) != ''">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,81,40)"/>
			</xsl:if>
			<xsl:if test="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,121,40) != ''">
				<xsl:text>:</xsl:text>
				<xsl:value-of select="substring(PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions,121,40)"/>
			</xsl:if>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>
		
		<xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/>
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
		
			<xsl:text>OLD=</xsl:text>
				<xsl:value-of select="HelperObj:GetNextCounterValue('OrderLineDetails')"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="ProductID/BuyersProductCode"/>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="OrderedQuantity"/><xsl:text>+</xsl:text>
				<xsl:value-of select="format-number(UnitValueExclVAT * 10000,'0')"/>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<xsl:text>+</xsl:text>
				<!-- truncate to 40 TDES = 9030 = AN..40-->
				<xsl:value-of select="js:msTruncate(string(ProductDescription),40)"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msTruncate(string(PackSize),40)"/>
			<xsl:text>'</xsl:text>
			<xsl:value-of select="$sLineBreak"/>
			
		</xsl:for-each>
		
		<xsl:text>OTR=</xsl:text>	
			<xsl:value-of select="PurchaseOrderTrailer/NumberOfLines"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>
		
		<xsl:text>MTR=</xsl:text>
			<xsl:value-of select="6 + count(PurchaseOrderDetail/PurchaseOrderLine)"/>
		<xsl:text>'</xsl:text>		
		<xsl:value-of select="$sLineBreak"/>
		
	</xsl:for-each>
	
	<xsl:text>MHD=</xsl:text>	
		<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>
		<xsl:text>ORDTLR:9</xsl:text>		
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>OFT=</xsl:text>	
		<xsl:value-of select="count(/BatchRoot/PurchaseOrder)"/>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>MTR=</xsl:text>	
		<xsl:text>3</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>

	<xsl:text>END=</xsl:text>
		<xsl:value-of select="2 + count(/BatchRoot/PurchaseOrder)"/>	
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
</xsl:template>

<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 

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

	//truncate the string
	sText = vsField.substring(0,nLength);
	
	if(sText.substr(nLength - 1) == '?' && sText.substr(nLength - 2) != '??')
	{
		sText = sText.substring(0, nLength - 1);
	}
	
	return sText;
	
}


   
]]></msxsl:script>


</xsl:stylesheet>
