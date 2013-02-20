<?xml version="1.0" encoding="UTF-8"?>
<!--
'**********************************************************************************************
' Overview
'
' Maps iXML purchase orders into BUNZL order tradacoms order format. (Tradacomms V4)
' VIA INTER CONNECT
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002.
'*********************************************************************************************
' Module History
'*********************************************************************************************
' Date        	| Name    	| Description of modification
'*********************************************************************************************
'  18/10/2005 	| N Emsen	| Created from Fellows PO Mapper
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'  02/11/2005 	| N Emsen	| Copied in STX line from ND's Kores changes, amending to Bunzl
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'	23/11/2005	| N Emsen	| change STX line do that it is set for live
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'	09/08/2006	| N Emsen	|	Case 213 Bunzl Order changes due to change of back office system
'
'*********************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="text"/>
	
	<!--
			To detect which VAN GLN to use depending whether live or the test enviroment
	-->
	<xsl:variable name="sEDI_STX_Code">
		<xsl:choose>

			<!--	5013546167446 (test EDI) -->
			<xsl:when test="/PurchaseOrder/TradeSimpleHeader/TestFlag =1 or /PurchaseOrder/TradeSimpleHeader/TestFlag =true">5013546167446</xsl:when>

			<!-- 5013546167101 LIVE -->
			<xsl:otherwise>5013546167101</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:variable>
	
	<xsl:template match="/">
	<!-- generate output -->STX=ANA:1+<xsl:value-of select="$sEDI_STX_Code"/>:ALTERNATIVE BUSINESS SOLUTIONS+<xsl:value-of select="PurchaseOrder/TradeSimpleHeader/SendersCodeForRecipient"/>:BUNZL OUTSOURCING+<xsl:value-of select="user:msGetDate()"/>:<xsl:value-of select="user:msGetTime()"/>+<xsl:value-of select="//PurchaseOrderHeader/FileGenerationNumber"/>++CORHDR+B'
MHD=1+CORHDR:4'
TYP=0430+'
SDT=<xsl:value-of select="PurchaseOrder/TradeSimpleHeader/SendersCodeForRecipient"/>+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsName)"/>+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsAddress/AddressLine1)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsAddress/AddressLine2)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsAddress/AddressLine3)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsAddress/AddressLine4)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/RecipientsAddress/PostCode)"/>+356449722'
CDT=5018206000008+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SenderName)"/>+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SendersAddress/AddressLine1)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SendersAddress/AddressLine2)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SendersAddress/AddressLine3)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SendersAddress/AddressLine4)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/TradeSimpleHeader/SendersAddress/PostCode)"/>'
DNA='
FIL=<xsl:value-of select="PurchaseOrder/PurchaseOrderHeader/FileGenerationNumber"/>+1+<xsl:value-of select="user:msGetDate()"/>+'
MTR=7'
MHD=2+CORDER:4'
CLO=<xsl:value-of select="substring-after(PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender,'/' )"/>+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationName)"/>+<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationAddress/AddressLine1)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationAddress/AddressLine2)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationAddress/AddressLine3)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationAddress/AddressLine4)"/>:<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/DeliveryDetails/DeliveryLocationAddress/PostCode)"/>'
ORD=<xsl:value-of select="user:msTranslateForEDI(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference)"/>::<xsl:value-of select="user:msFormatDate(PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate)"/>'
OOL='
ITD='
<xsl:variable name="MinimumReqDelDate">
			<xsl:for-each select="//PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine/RequiredDeliveryDate">
				<xsl:sort data-type="text" order="ascending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="user:msFormatDate(.)"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>DIN=<xsl:value-of select="$MinimumReqDelDate"/>'
DNA='<xsl:for-each select="//PurchaseOrderLine">
COD=<xsl:variable name="LineNumber"><xsl:value-of select="position()"/></xsl:variable><xsl:value-of select="$LineNumber"/>+<xsl:value-of select="user:displayBarcode(ProductID/BarCode,13)"/>++:<xsl:value-of select="user:msTranslateForEDI(ProductID/BuyersProductCode)"/>+<xsl:value-of select="PackSize"/>+<xsl:value-of select="QuantityOrdered"/>+<xsl:value-of select="vbscript:msFormatNumber(UnitValueExclVAT, 10000)"/>+++<xsl:value-of select="user:msTranslateForEDI(ProductDescription)"/>'</xsl:for-each>
OTR=<xsl:value-of select="count(/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine)"/>+<xsl:value-of select="sum(//PurchaseOrderLine/QuantityOrdered)"/>'
DNB='
RDQ=<xsl:value-of select="count(//PurchaseOrderLine)"/>+1+<xsl:value-of select="RequiredDeliveryDate"/>+<xsl:value-of select="QuantityOrdered"/>::'
PVD='
OTR=<xsl:value-of select="count(//PurchaseOrderLine)"/>+'
MTR=<xsl:value-of select="format-number((count(/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine) * 4) + 9,'#')"/>'
MHD=3+CORTLR:4'
OFT=1'
MTR=3'
END=3'
</xsl:template>
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[
	
	Function msFormatNumber(vsNumber, mlMultiplier)
	Dim sNumber
		
		sNumber = vsNumber.item(0).nodeTypedValue
		
		If isNumeric(sNumber) then
			msFormatNumber = clng(sNumber * clng(mlMultiplier))
		Else
			msFormatNumber = "parse error: " & sNumber
		End If
		
	End Function

]]></msxsl:script>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[

/*=============================================================================================*/
/*5018206000008/81 gets the first part of the trading relationship*/

function getCustomerANA(TextIn){
var sTextIn = '';
var sTextOut = '';
var lPos;
var s='';

	sTextIn= TextIn(0).text;
	lPos = sTextIn.indexOf('\/')
	
	sTextOut = sTextIn.substring(0, lPos);
	
	return sTextOut;
	
}

/*=============================================================================================*/
/*5018206000008/81 gets the second part of the trading relationship*/

function getLocationANA(TextIn){
var sTextIn = '';
var sTextOut = '';
var lLength;
var lPos;

	sTextIn= TextIn(0).text;
	lLength = sTextIn.length;
	lPos = sTextIn.indexOf('\/')
	
	sTextOut = sTextIn.substring(lPos + 1, lLength);
	
	return sTextOut ;
}

/*=============================================================================================*/        

function displayBarcode(TextIn,TextLength){
	var newText = "";
	if(TextIn.length>0){
		newText=TextIn(0).text;}
	
	if (newText.length!=TextLength){
		newText="";
	}
	
	return newText;
}


/*=============================================================================================*/



		function msGetDate()
		{
			var dtDate = new Date();
			return dtDate.getYear().toString().substr(2,2) + msPadTo2((dtDate.getMonth() + 1).toString()) + msPadTo2(dtDate.getDate().toString());
		}
		function msGetTime()
		{
			var dtDate = new Date();
			return msPadTo2(dtDate.getHours().toString()) + '' + msPadTo2(dtDate.getMinutes().toString()) + '' + msPadTo2(dtDate.getSeconds().toString());
		}
		function msPadTo2(vsString)
		{
			while(vsString.length < 2)
			{
				vsString = '0' + vsString;
			}
			return vsString;
		}
		function msFormatDate(vsDate)
		{
		if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(2,2) + vsDate.substr(5,2) + vsDate.substr(8,2);
			}
			else
			{
				return '';
			}
				
		}
		
		var mlCurrentLineNumber = 0;
		function mlGetLineNumber()
		{
			mlCurrentLineNumber += 1;
			return mlCurrentLineNumber;
		}
		
		function msTranslateForEDI(vsString)
		{
			if(vsString.length > 0)
			{
				vsString= vsString(0).text;
				vsString = vsString.toUpperCase();

				while(vsString.indexOf('?') != -1)
				{
					vsString = vsString.replace('?','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','??');
				}
				
				while(vsString.indexOf('\'') != -1)
				{
					vsString = vsString.replace('\'','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','?\'');
				}
				
				while(vsString.indexOf('+') != -1)
				{
					vsString = vsString.replace('+','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','?+');
				}
				
				while(vsString.indexOf(':') != -1)
				{
					vsString = vsString.replace(':','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','?:');
				}
				
				while(vsString.indexOf('=') != -1)
				{
					vsString = vsString.replace('=','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','?=');
				}
				
				while(vsString.indexOf('.') != -1)
				{
					vsString = vsString.replace('.','¬');
				}
				while(vsString.indexOf('¬') != -1)
				{
					vsString = vsString.replace('¬','?.');
				}


			}
		
			if(vsString.length > 34)
			{
				vsString=vsString.substring(0,34);
			}
			
			return vsString;
			
		}
]]></msxsl:script>
</xsl:stylesheet>
