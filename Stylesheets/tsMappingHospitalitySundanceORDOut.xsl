<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality Ltd, 2014.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 			|	Description of modification
==========================================================================================
 20/02/2015	| Jose Miguel	|	FB10127 - Sundance Orders Out integration by SOAP
==========================================================================================
-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
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
			&lt;tranSales:entity type="customer" internalId="</xsl:text><xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>"&gt;<xsl:text>
				&lt;platformCore:name&gt;</xsl:text><xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/><xsl:text>&lt;/platformCore:name&gt;
			&lt;/tranSales:entity&gt;
			&lt;tranSales:tranDate&gt;</xsl:text><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/><xsl:text>T00:00:00&lt;/tranSales:tranDate&gt;
			&lt;tranSales:otherRefNum&gt;</xsl:text><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/><xsl:text>&lt;/tranSales:otherRefNum&gt;
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
				&lt;tranSales:item internalId="</xsl:text><xsl:value-of select="ProductID/SuppliersProductCode"/><xsl:text>"&gt;
					&lt;platformCore:name&gt;</xsl:text><xsl:value-of select="ProductDescription"/><xsl:text>&lt;/platformCore:name&gt;
				&lt;/tranSales:item&gt;
				&lt;tranSales:line&gt;</xsl:text><xsl:value-of select="LineNumber"/><xsl:text>&lt;/tranSales:line&gt;
				&lt;tranSales:quantity&gt;</xsl:text><xsl:value-of select="OrderedQuantity"/><xsl:text>&lt;/tranSales:quantity&gt;
			&lt;/tranSales:item&gt;
		</xsl:text>
	</xsl:template>
</xsl:stylesheet>
