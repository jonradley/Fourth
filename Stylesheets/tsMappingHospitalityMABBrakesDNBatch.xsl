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
     ?     	|        ?				| Branched from something 
==========================================================================================
 2011-09-12	| R Cambridge     	| 4828 Added customer PO ref (sent in original order and passed on Fairfax Meadow, who return it in their delivery data)
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:HelperObj="urn:XSLHelper" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text" encoding="utf-8"/>

<xsl:param name="sDocumentDate">Not Provided</xsl:param>
<xsl:param name="sDocumentTime">Not Provided</xsl:param>
<xsl:param name="nBatchID">Not Provided</xsl:param>

<xsl:template match="/BatchRoot[DeliveryNote]">

	<xsl:variable name="sLineBreak">
		<xsl:text>&#13;&#10;</xsl:text>
		<!--xsl:text></xsl:text-->
	</xsl:variable>

	<xsl:value-of select="HelperObj:ResetCounter('MessageHeader')"/>
	<xsl:value-of select="HelperObj:ResetCounter('DataNarativeA')"/>
	<xsl:value-of select="HelperObj:ResetCounter('OrderLineDetails')"/>

	<xsl:text>STX=</xsl:text>
		<xsl:text>ANA:1+</xsl:text>
		<xsl:choose>
			<xsl:when test="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN = '5050085091287'">5013546012078</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="$sDocumentDate"/><xsl:text>:</xsl:text><xsl:value-of select="$sDocumentTime"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="$nBatchID"/>
		<xsl:text>+</xsl:text>		
		<xsl:text>ARGENT</xsl:text>
		<xsl:text>+</xsl:text>			
		<xsl:text>DELIVERY</xsl:text>			
		<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>MHD=</xsl:text>	
		<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/><xsl:text>+</xsl:text>
		<xsl:text>DELHDR:9</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>
	
	<xsl:text>TYP=</xsl:text>	
		<xsl:text>0630</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>


	<xsl:text>SDT=</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:choose>
			<xsl:when test="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN = '5050085091287'">5013546012078</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<xsl:text>:</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>

	<xsl:text>CDT=</xsl:text>
		<xsl:value-of select="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msTruncate(string(/BatchRoot/DeliveryNote/DeliveryNoteHeader/Buyer/SendersAddress/PostCode),8)"/>
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

	<xsl:for-each select="/BatchRoot/DeliveryNote">
	
		<xsl:text>MHD=</xsl:text>	
			<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/>
			<xsl:text>+</xsl:text>
			<xsl:text>DELIVR:9</xsl:text>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>

		<xsl:text>CLO=</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/GLN"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToName),40)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msTruncate(string(DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode),8)"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>

		<xsl:text>DEL=</xsl:text>
			<xsl:text>+</xsl:text>
			<!-- 4828 R Cambridge, number of delivery units -->
			<xsl:value-of select="DeliveryNoteHeader/HeaderExtraData/NumberOfBoxes"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="HelperObj:FormatDate(string(DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate))"></xsl:value-of>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>0000</xsl:text>
			<xsl:text>:</xsl:text>
			<xsl:text>0000</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:text>TH</xsl:text>
			<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>


		<xsl:text>ORF=</xsl:text>
			<xsl:text>1</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>:</xsl:text>
			<!-- 4828 R Cambridge, Place original Brakes PO ref here 
			 (even though this it the supplier's PO ref sub-field it's the locaiton requested by Brakes) -->
			<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="HelperObj:FormatDate(string(DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate))"></xsl:value-of>
			<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>


		<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">
		
			<xsl:text>DLD=</xsl:text>
			<xsl:text>1</xsl:text>			
			<xsl:text>+</xsl:text>			
			<xsl:value-of select="HelperObj:GetNextCounterValue('OrderLineDetails')"/>
			<xsl:text>+</xsl:text>			
			<xsl:text>:</xsl:text>			
			<xsl:value-of select="format-number(LineExtraData/CustomerOrderLineNumber,'0000')"/>
			<xsl:text>+</xsl:text>			
			<xsl:text>+</xsl:text>			
			<xsl:text>:</xsl:text>			
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>+</xsl:text>			
			<xsl:text>1</xsl:text>			
			<xsl:text>:</xsl:text>			
			<xsl:text>1</xsl:text>			
			<xsl:text>:</xsl:text>			
			<xsl:choose>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'KGM'">G</xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'">CS</xsl:when>
				<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'EA'">CS</xsl:when>
			</xsl:choose>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>:</xsl:text>
			<xsl:choose>
				<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'KGM'">
					<xsl:value-of select="format-number(DespatchedQuantity * 1000,'0')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="DespatchedQuantity"/>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>:</xsl:text>
			<xsl:choose>
				<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'KGM'">G</xsl:when>
				<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'CS'">CS</xsl:when>
				<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'EA'">CS</xsl:when>
			</xsl:choose>
			<xsl:text>+</xsl:text>			
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>'</xsl:text>	
		<xsl:value-of select="$sLineBreak"/>

		</xsl:for-each>
	
		<xsl:text>DTR=</xsl:text>
		<xsl:value-of select="DeliveryNoteTrailer/NumberOfLines"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>

		<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="DeliveryNoteTrailer/NumberOfLines + 6"/>
		<xsl:text>'</xsl:text>
		<xsl:value-of select="$sLineBreak"/>

	
	</xsl:for-each>

	<xsl:text>MHD=</xsl:text>
	<xsl:value-of select="HelperObj:GetNextCounterValue('MessageHeader')"/>
	<xsl:text>+</xsl:text>
	<xsl:text>DELTLR</xsl:text>
	<xsl:text>:</xsl:text>
	<xsl:text>9</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>

	<xsl:text>DFT=</xsl:text>
	<xsl:text>1</xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>


	<xsl:text>MTR=3'</xsl:text>
	<xsl:value-of select="$sLineBreak"/>

	<xsl:text>END=</xsl:text>
	<xsl:value-of select="HelperObj:GetCurrentCounterValue('MessageHeader')"/>
	<xsl:text>'</xsl:text>


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
