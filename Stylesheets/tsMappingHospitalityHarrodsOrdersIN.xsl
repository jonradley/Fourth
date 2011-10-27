<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************
Date		|	Name				|	Comment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27/10/2011|	KOshaughnessy	| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			|						|
***************************************************************************-->			
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">
			<Document>	
				<xsl:attribute name="TypePrefix">ORD</xsl:attribute>
				<xsl:apply-templates/>
			</Document>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDetail/PurchaseOrderLine/LineNumber">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>		
	
	<xsl:template name="copyCurrentNodeExplicit2DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 10.0, '0.0')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate | 
							   PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate">
		<xsl:call-template name="DateFormat"/>
	</xsl:template>
	
	<xsl:template name="DateFormat">
		<xsl:param name="rejig" select="."/>
			<xsl:copy>
			<xsl:value-of select="concat(substring($rejig,7,2),'-',substring($rejig,5,2),'-',substring($rejig,1,4))"/>
			</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
