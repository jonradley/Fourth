<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2014.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 		|	Description of modification
==========================================================================================
 20/02/2015	| Jose Miguel	|	FB10127 - Sundance Orders Out integration by SOAP
==========================================================================================
 03/03/2015	| Jose Miguel	|	FB10171 - Sundance integration - fix the mapper to allow description to have the '&'
==========================================================================================
 15/04/2015	| Jose Miguel	|	FB10226 - Sundance integration - fix the mapper to allow customer unit names to have the '&'
==========================================================================================
 30/04/2015	| Jose Miguel	|	FB10246 - Sundance integration - fix the mapper to allow PORef to have the '&' (and other fields)
==========================================================================================
 08/07/2015	| Jose Miguel	|	FB10364 - Sundance - Add temporary mapping to support new product codes
==========================================================================================
 20/07/2015	| Jose Miguel	|	FB10409 - Sundance - Add temporary mapping to support new product codes - II
==========================================================================================
 28/08/2015	| Jose Miguel	|	FB10480 - Sundance - Add temporary mapping to support new product codes - III
==========================================================================================
-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" 
	exclude-result-prefixes="xsl">
	<xsl:output method="text" encoding="utf-8" indent="yes"/>
	<xsl:template match="/PurchaseOrder">
		<xsl:text>&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:platformCore="urn:core_2014_1.platform.webservices.netsuite.com" 
	xmlns:platformMsgs="urn:messages_2014_1.platform.webservices.netsuite.com" 
	xmlns:platformCommon="urn:common_2014_1.platform.webservices.netsuite.com" 
	xmlns:tranSales="urn:sales_2014_1.transactions.webservices.netsuite.com"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
	&lt;soap:Header&gt;
		&lt;platformMsgs:passport&gt;
			&lt;platformCore:email&gt;fnborders@sundancepartners.com&lt;/platformCore:email&gt;
			&lt;platformCore:password&gt;Winter2015&lt;/platformCore:password&gt;
			&lt;platformCore:account&gt;4012414&lt;/platformCore:account&gt;
		&lt;/platformMsgs:passport&gt;
		&lt;platformMsgs:applicationInfo/&gt;
		&lt;platformMsgs:partnerInfo/&gt;
		&lt;platformMsgs:preferences/&gt;
	&lt;/soap:Header&gt;
	&lt;soap:Body&gt;
	&lt;platformMsgs:add>
		&lt;platformMsgs:record xsi:type="tranSales:SalesOrder">
			&lt;tranSales:entity type="customer" internalId="</xsl:text><xsl:value-of select="js:replace_str(string(PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode))"/>"&gt;<xsl:text>
				&lt;platformCore:name&gt;</xsl:text><xsl:value-of select="js:replace_str(string(PurchaseOrderHeader/ShipTo/ShipToName))"/><xsl:text>&lt;/platformCore:name&gt;
			&lt;/tranSales:entity&gt;
			&lt;tranSales:tranDate&gt;</xsl:text><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/><xsl:text>T00:00:00&lt;/tranSales:tranDate&gt;
			&lt;tranSales:otherRefNum&gt;</xsl:text><xsl:value-of select="js:replace_str(string(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference))"/><xsl:text>&lt;/tranSales:otherRefNum&gt;
			&lt;tranSales:itemList&gt;</xsl:text>
			<xsl:apply-templates select="PurchaseOrderDetail/PurchaseOrderLine"/>
			<xsl:text>&lt;/tranSales:itemList&gt;
		&lt;/platformMsgs:record&gt;
	&lt;/platformMsgs:add&gt;	
	&lt;/soap:Body&gt;
&lt;/soap:Envelope&gt;
		</xsl:text>
	</xsl:template>
	<xsl:template match="PurchaseOrderLine">
		<xsl:text>
			&lt;tranSales:item&gt;
				&lt;tranSales:item internalId="</xsl:text><xsl:value-of select="js:getNewProductInternalId(js:replace_str(string(ProductID/SuppliersProductCode)))"/><xsl:text>"&gt;
					&lt;platformCore:name&gt;</xsl:text><xsl:value-of select="js:replace_str(string(ProductDescription))"/><xsl:text>&lt;/platformCore:name&gt;
				&lt;/tranSales:item&gt;
				&lt;tranSales:line&gt;</xsl:text><xsl:value-of select="LineNumber"/><xsl:text>&lt;/tranSales:line&gt;
				&lt;tranSales:quantity&gt;</xsl:text><xsl:value-of select="OrderedQuantity"/><xsl:text>&lt;/tranSales:quantity&gt;
			&lt;/tranSales:item&gt;
		</xsl:text>
	</xsl:template>
<msxsl:script implements-prefix="js" language="javascript">
<![CDATA[
function replace_str(str_text)
{
     return str_text.replace('&','&amp;');
}

var mapProductInternalIds =
{
'3447':'7515',
'3456':'7519',
'3459':'7520',
'3467':'7522',
'3485':'7527',
'1479':'8011',
'2426':'7531',
'2526':'7865',
'2427':'7533',
'2540':'7535',
'3495':'7544',
'3511':'7549',
'3521':'7551',
'3532':'7555',
'1480':'8013',
'3573':'7565',
'2428':'7570',
'1421':'7818',
'3607':'7584',
'3617':'7586',
'7298':'7588',
'1477':'7911',
'3045':'7603',
'3655':'7608',
'1481':'8012',
'1425':'7848',
'7191':'7866',
'1427':'7850',
'1428':'7863',
'1459':'7853',
'1461':'7864',
'3372':'7620',
'2833':'7867',
'2568':'7636',
'2579':'7639',
'2589':'7641',
'1430':'7828',
'1432':'7826',
'7189':'7868',
'1434':'7830',
'2604':'7646',
'2610':'7648',
'1437':'7831',
'1438':'7832',
'7190':'7869',
'1440':'7834',
'3210':'8113',
'3222':'8115',
'3256':'8121',
'1462':'7814',
'1466':'7821',
'2637':'7661',
'2640':'7662',
'2644':'7663',
'2648':'7664',
'2657':'7668',
'2671':'7673',
'1442':'7812',
'1444':'7838',
'1445':'7839',
'1448':'7841',
'1449':'7842',
'1450':'7843',
'3186':'7678',
'3100':'7681',
'3125':'7686',
'1451':'7846',
'1453':'7824',
'3128':'7692',
'2688':'7704',
'2695':'7706',
'2698':'7707',
'2705':'7708',
'3140':'7712',
'1454':'7851',
'1456':'7825',
'3154':'7737',
'3163':'7741',
'1472':'7860',
'1473':'7861',
'1475':'7858',
'7063':'7750',
'2722':'7758',
'2726':'7759',
'3201':'7716',
'3652':'7607'
}

function getNewProductInternalId (nOldInternalId)
{
	var nNewInternalId = mapProductInternalIds[nOldInternalId];
	if (nNewInternalId == null)
	{
		nNewInternalId = nOldInternalId;
	}
	
	return nNewInternalId;
}
]]>
</msxsl:script>
	
</xsl:stylesheet>
