<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order Batch Transform for Rail Gourmet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       		| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber	| 08/10/2012		| 5761 Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber	| 22/11/2012		| 5871 Addition of UOM mapping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Emanuel	| 14/12/2012		| 5909 Changed how test flag is mapped in from FF
**************************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>
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
	
	<!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:element name="PurchaseOrderDate">
		<xsl:call-template name="DateConversion">
			<xsl:with-param name="FormatDate" select="."/>
		</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="DeliveryDate">
		<xsl:element name="DeliveryDate">
		<xsl:call-template name="DateConversion">
			<xsl:with-param name="FormatDate" select="."/>
		</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="DateConversion">
		<xsl:param name="FormatDate"/>
		<xsl:value-of select="concat('20',substring($FormatDate, 3, 2), '-', substring($FormatDate, 5, 2), '-', substring($FormatDate, 7, 2))"/>
	</xsl:template>

	<xsl:template match="TestFlag">
		<xsl:call-template name="TestFlag">
			<xsl:with-param name="Translate" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="TestFlag">
		<xsl:param name="Translate"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$Translate='N' ">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:when test="$Translate='Y' ">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:otherwise>error</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure">
			<xsl:choose>
				<xsl:when test="'CA'">
					<xsl:text>CS</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>EA</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>