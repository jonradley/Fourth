<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************
Date		|	Name				|	Comment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
15/11/2011|	KOshaughnessy	| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			|						|
***************************************************************************-->	
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" encoding="UTF-8"/>

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
				<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<!--Reformating Date to Trade|Simple format-->
	<xsl:template match="CreditNoteDate | TaxPointDate | PurchaseOrderDate">
		<xsl:call-template name="DateFormat"/>
	</xsl:template>
	
	<xsl:template name="DateFormat">
		<xsl:param name="sDateFormat" select="."/>
		<xsl:copy>
			<xsl:value-of select="concat(substring($sDateFormat,1,4),'-',substring($sDateFormat,5,2),'-',substring($sDateFormat,7,2))"/>
		</xsl:copy>
	</xsl:template>
	
	<!--Sorting out the VAT codes-->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="VATDecode">
				<xsl:with-param name="Translate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:call-template name="VATDecode">
				<xsl:with-param name="Translate" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="VATDecode">
		<xsl:param name="Translate"/>
			<xsl:choose>
				<xsl:when test="$Translate = 'ZERO' ">
					<xsl:text>Z</xsl:text>
				</xsl:when>
				<xsl:otherwise>S</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<xsl:template name="UOMDECODE">
		<xsl:param name="TranslateUOM"/>
			<xsl:choose>
				<xsl:when test="$TranslateUOM = 'CA' ">
					<xsl:text>CS</xsl:text>
				</xsl:when>
				<xsl:when test="$TranslateUOM = 'CASE' ">
					<xsl:text>CS</xsl:text>
				</xsl:when>
				<xsl:when test="$TranslateUOM = 'CL' ">
					<xsl:text>CS</xsl:text>
				</xsl:when>
				<xsl:when test="$TranslateUOM = 'KG' ">
					<xsl:text>KGM</xsl:text>
				</xsl:when>
				<xsl:when test="$TranslateUOM = 'LITRES' ">
					<xsl:text>LTR</xsl:text>
				</xsl:when>
				<xsl:otherwise>EA</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure">
			<xsl:call-template name="UOMDECODE">
				<xsl:with-param name="TranslateUOM" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
