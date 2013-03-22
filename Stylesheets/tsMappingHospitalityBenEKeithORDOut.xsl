<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
Map Out to the BEK Order format (V16)
==========================================================================================
 Module History
==========================================================================================
 Date			| Name 					| Description of modification
==========================================================================================
 01/03/2013	| Harold Robson		| FB6189 Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:output method="text" encoding="utf-8"/>
	
	<xsl:variable name="delimiter" select="'|'"/> <!-- pipe or comma allowed by BEKv16 spec -->

	<xsl:template match="/PurchaseOrder">
		
		<!-- BEK Branch indicator and BEK Customer number are concatenated to the TR code with a hyphen -->
		<xsl:variable name="branchIndicator" select="substring-before(PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode,'-')"/>
		<xsl:variable name="deliveryDate" select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/> <!-- YYYY-MM-DD -->
	
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">

			<!-- Branch Indicator -->
			<xsl:value-of select="$branchIndicator"/>
			<xsl:value-of select="$delimiter"/>
			<!-- Security Access code -->
			<xsl:choose>
				<xsl:when test="$branchIndicator= 'FDF'"><xsl:text>19000</xsl:text></xsl:when>
				<xsl:when test="$branchIndicator= 'FSA'"><!--<xsl:text>19000</xsl:text>--></xsl:when>
				<xsl:when test="$branchIndicator= 'FOK'"><!--<xsl:text>19000</xsl:text>--></xsl:when>
				<xsl:when test="$branchIndicator= 'FAM'"><!--<xsl:text>19000</xsl:text>--></xsl:when>
				<xsl:when test="$branchIndicator= 'FLR'"><!--<xsl:text>19000</xsl:text>--></xsl:when>
				<xsl:when test="$branchIndicator= 'FAQ'"><!--<xsl:text>19000</xsl:text>--></xsl:when>
			</xsl:choose>
			<xsl:value-of select="$delimiter"/>
			<!-- BEK Customer number -->
			<xsl:value-of select="substring-after(../../PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode,'-')"/>
			<xsl:value-of select="$delimiter"/>
			<!-- BEK Item number -->
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:value-of select="$delimiter"/>
			<!-- Delivery Date MMDDYYYY -->
			<xsl:if test="$deliveryDate != ''">
				<xsl:value-of select="substring($deliveryDate,6,2)"/>
				<xsl:value-of select="substring($deliveryDate,9,2)"/>
				<xsl:value-of select="substring($deliveryDate,1,4)"/>
			</xsl:if>
			<xsl:value-of select="$delimiter"/>
			<!-- Order quantity, no decimal places - padded to 5 digits-->
			<xsl:value-of select="format-number(OrderedQuantity,'00000')"/>
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
			<xsl:value-of select="/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			<!-- new line -->
			<xsl:if test="position() != last()"><xsl:text>&#13;&#10;</xsl:text></xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
