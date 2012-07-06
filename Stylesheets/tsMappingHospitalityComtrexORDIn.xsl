<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order translation following tradacoms flat file mapping for Comtrex.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Dimant		| 08/11/2011	| 5004: Created. Mapped in UOM from inbound order
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Dimant		| 01/05/2012	| 5448: Mapped in UOM from inbound order
**********************************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>
	</xsl:template>

	<!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
	<xsl:template match="PurchaseOrderDate | DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat('20',substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2))"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="UnitValueExclVAT">
		<xsl:copy>
			<xsl:value-of select="format-number(. div 10000.0, '0.00')"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="OrderedQuantity">
		<xsl:copy>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="@UnitOfMeasure = 'PK'">CS</xsl:when>
					<xsl:when test="@UnitOfMeasure = 'KG'">KGM</xsl:when>
					<xsl:otherwise><xsl:value-of select="@UnitOfMeasure"/></xsl:otherwise>
				</xsl:choose>				
			</xsl:attribute>
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:copy>
	</xsl:template>

	<!-- The quantity value for products ordered in EA will appear in a different location and has been mapped into PackSize -->
	<!-- When this is the case, we map PackSize into OrderedQuantity -->
	<xsl:template match="PackSize">		
			<OrderedQuantity>
				<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
				<xsl:value-of select="."/>
			</OrderedQuantity>		
	</xsl:template>
	
	<xsl:template match="BatchDocument">
		<BatchDocument DocumentTypeNo="2">
			<xsl:apply-templates select="@*|node()"/>
		</BatchDocument>
	</xsl:template>
		
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
