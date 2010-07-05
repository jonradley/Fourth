<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality, 2010
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					|	Description of modification
==========================================================================================
     ?     	|        ?      		|	?
==========================================================================================
 05/07/2010	| R Cambridge			|	3586 Hard code EternalID as partnercode with FnB member will no longer appear in internal XML (in SCB).
 														In future SCB will be Merret's code for organisation member (HN UK, Ireland or Test)
 														(Maybe seperate codes would be an adavantage to the recipient but there ins't time to ask them)
==========================================================================================
           	|               		|	 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="PurchaseOrder">
		<!-- Requested Delivery Date YYYYMMDD -->
		<xsl:variable name="DelDate">
			<xsl:value-of select="translate(PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate,'-','')"/>
		</xsl:variable>
		<!-- Harvey Nicks' Site Code-->
		<xsl:variable name="SiteCode">
			<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		</xsl:variable>
		<!-- External Identifier-->
		<xsl:variable name="ExternalID" select="'FOURTH'"/>

		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<xsl:value-of select="$ExternalID"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DelDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$SiteCode"/>
			<xsl:text>,,,</xsl:text>
			<!-- Merret Style-->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,,,,,,,</xsl:text>
			<!-- Qty Requested-->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:text>&#13;&#10;</xsl:text>

		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
