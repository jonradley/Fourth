<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Suggested order stylesheet for Aramark orders from OpX.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber	| 22/11/2012	| 5856: Created map.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber	| 26/11/2012	| 5856: Generic map for order batches and SO's.
*************************************************************************************************-->
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
	
	<xsl:template match="PurchaseOrderLine">
		<PurchaseOrderLine>
		
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="SuppliersProductCode"/>
			<xsl:apply-templates select="ProductDescription"/>
			
			<OrderedQuantity>
				<xsl:attribute name="UnitOfMeasure">
					<xsl:choose>
						<xsl:when test="OrderedQuantity/@UnitOfMeasure = 'CA' ">
							<xsl:text>CS</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="QuantityMath">
					<xsl:with-param name="sQuantityMath" select="OrderedQuantity"/>
				</xsl:call-template>
			</OrderedQuantity>
	
			<xsl:apply-templates select="UnitValueExclVAT"/>

		</PurchaseOrderLine>
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
	
	<xsl:template name="QuantityMath">
		<xsl:param name="sQuantityMath"/>
			<xsl:choose>
				<xsl:when test="substring($sQuantityMath,1,2) = '00'">
					<xsl:value-of select="substring($sQuantityMath,3)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sQuantityMath"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>