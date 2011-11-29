<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps iXML purchase orders into Holdsworh order format.
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  12/07/2004 | A Sheppard   | Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			 |                        |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:template match="/">START_TRACT_EDI_ORDERS_FILE
VERSION~1.43
START_ORDER_HEADER
ORDERNO~<xsl:value-of select="script:msRemoveTildes(substring(/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,1,12))"/>
FROMACC~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender)"/>
TOTAL-LINES~<xsl:value-of select="/PurchaseOrder/PurchaseOrderTrailer/NumberOfLines"/>
<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine"><xsl:value-of select="script:mCalculateTotalUnits(OrderedQuantity)"/></xsl:for-each>
TOTAL-UNITS~<xsl:value-of select="script:msGetTotalUnits()"/>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName">
FROMNAME~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToName)"/>
</xsl:if>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1">
FROMADD1~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1)"/>
</xsl:if>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2">
FROMADD2~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2)"/>
</xsl:if>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3">
FROMADD3~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3)"/>
</xsl:if>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4">
FROMADD4~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4)"/>
</xsl:if>
<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode">
POSTCODE~<xsl:value-of select="script:msRemoveTildes(/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode)"/>
</xsl:if>
DELIVDATE~<xsl:value-of select="script:msFormatDate(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate)"/>
CONTACT~<xsl:if test="/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"><xsl:value-of select="script:msSplitUpDeliveryInstructions(/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions)"/></xsl:if>
CONFIRMATION~ABSEDI
END_ORDER_HEADER
START_ORDER_DETAIL<xsl:for-each select="/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
<xsl:value-of select="script:msGetCarriageReturn()"/><xsl:value-of select="script:msRemoveTildes(ProductID/SuppliersProductCode)"/>~<xsl:value-of select="script:msConvertQuantity(OrderedQuantity)"/>~<xsl:if test="ProductID/BuyersProductCode"><xsl:value-of select="script:msRemoveTildes(ProductID/BuyersProductCode)"/></xsl:if>~<xsl:value-of select="script:msRemoveTildes(ProductDescription)"/>~<xsl:if test="PackSize"><xsl:value-of select="script:msRemoveTildes(PackSize)"/></xsl:if>~<xsl:value-of select="format-number(UnitValueExclVAT, '#.00')"/>
</xsl:for-each>
END_ORDER_DETAIL
END_TRACT_EDI_ORDERS_FILE
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[
		function msRemoveTildes(vsString)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(exception)
			{}
			
			while(vsString.indexOf('~') != -1)
			{
				vsString = vsString.replace('~',' ');
			}
			
			return vsString;
		}
		function msFormatDate(vsString)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(exception)
			{}
			
			return vsString.substr(0,4) + '' + vsString.substr(5,2) + '' + vsString.substr(8,2);
		}
		var mdTotalUnits = 0;
		function mCalculateTotalUnits(vsQuantity)
		{
		var dCompleteQuantity = 0;
		var dRoundedQuantity = 0;
			try
			{
				vsQuantity = vsQuantity(0).text;
			}
			catch(exception)
			{}
			
			dCompleteQuantity = parseFloat(vsQuantity);
			dRoundedQuantity = Math.round(vsQuantity * 100)/100;

			if(dRoundedQuantity<dCompleteQuantity)
			{
				dRoundedQuantity += 0.01;
			}
			mdTotalUnits += dRoundedQuantity;
			return '';
		}
		function msGetTotalUnits()
		{
		var sTotalUnits = (Math.round(mdTotalUnits * 100)/100).toString();
		
			if(sTotalUnits.indexOf('.') == -1)
			{
				sTotalUnits += '.';
			}
			
			while(sTotalUnits.indexOf('.') > (sTotalUnits.length - 3))
			{
				sTotalUnits += '0';
			}
			
			return sTotalUnits;
		}
		function msSplitUpDeliveryInstructions(vsDeliveryInstructions)
		{
		var lCounter = 0;
		var sReturn = '';
			
			try
			{
				vsDeliveryInstructions = vsDeliveryInstructions(0).text;
			}
			catch(exception)
			{}
			
			while(vsDeliveryInstructions != '')
			{
				lCounter += 1;
				sReturn += '\nCOMMENTS' + lCounter.toString() + '~' + vsDeliveryInstructions.substr(0,200);
				vsDeliveryInstructions = vsDeliveryInstructions.substr(200, vsDeliveryInstructions.length);
			}
			return sReturn;
		}
		function msConvertQuantity(vsQuantity)
		{
		var dCompleteQuantity = 0;
		var dRoundedQuantity = 0;
		var sRoundedQuantity = '';
		
			try
			{
				vsQuantity = vsQuantity(0).text;
			}
			catch(exception)
			{}
			
			dCompleteQuantity = parseFloat(vsQuantity);
			dRoundedQuantity = Math.round(vsQuantity * 100)/100;

			if(dRoundedQuantity<dCompleteQuantity)
			{
				dRoundedQuantity += 0.01;
			}

			sRoundedQuantity = (Math.round(dRoundedQuantity * 100)/100).toString();
		
			if(sRoundedQuantity.indexOf('.') == -1)
			{
				sRoundedQuantity += '.';
			}
			
			while(sRoundedQuantity.indexOf('.') > (sRoundedQuantity.length - 3))
			{
				sRoundedQuantity += '0';
			}
			
			return sRoundedQuantity;
		}
		function msGetCarriageReturn()
		{
			return '\n';
		}
]]></msxsl:script>
</xsl:stylesheet>
