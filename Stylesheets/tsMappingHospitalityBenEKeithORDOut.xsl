<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
Map Out to the BEK Order format (V16)
==========================================================================================
 Module History
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 01/03/2013	| Harold Robson		| Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:variable name="delimiter" select="'|'"/> <!-- pipe or comma allowed by BEKv16 spec -->

	<xsl:template match="/PurchaseOrder">
	
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">

			<!-- Branch Indicator -->
			<!-- TO DO ONCE CONFIRMED LOGIC -->
			<xsl:value-of select="$delimiter"/>
			<!-- Security Access code -->
			<!-- TO DO ONCE CONFIRMED LOGIC -->
			<xsl:value-of select="$delimiter"/>
			<!-- BEK Customer number -->
			<!-- TO DO ONCE CONFIRMED LOGIC -->
			<xsl:value-of select="$delimiter"/>
			<!-- BEK Item number -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:value-of select="$delimiter"/>
			<!-- Delivery Date -->
			<xsl:value-of select="OrderedDeliveryDetailsLineLevel/DeliveryDate"/>
			<xsl:value-of select="$delimiter"/>
			<!-- Order quantity -->
			<xsl:value-of select="OrderedQuantity"/>
			<xsl:value-of select="$delimiter"/>
			<!-- Item UOM -Format (C=case, E=each) -->
			<xsl:choose>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'EA'"><xsl:text>E</xsl:text></xsl:when>
				<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CS'"><xsl:text>C</xsl:text></xsl:when>
			</xsl:choose>
			<xsl:value-of select="$delimiter"/>
			<!-- This field is intentionally left blank -->
			<xsl:value-of select="$delimiter"/>
			<!-- PO Number -->
			<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<!-- new line -->
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
