<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************
Date		|	Name				|	Comment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
08/11/2011|	KOshaughnessy	| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			|						|
***************************************************************************-->	
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">
			<Document>	
				<xsl:attribute name="TypePrefix">INV</xsl:attribute>
				<xsl:apply-templates/>
			</Document>
	</xsl:template>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<!--Reformating Date to Trade|Simple format-->
	<xsl:template match="InvoiceHeader/InvoiceReferences/TaxPointDate |
							   InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:call-template name="DateFormat"/>
	</xsl:template>
	
	<xsl:template name="DateFormat">
		<xsl:param name="sDateFormat" select="."/>
		<xsl:copy>
			<xsl:value-of select="concat(substring($sDateFormat,7,2),'-',substring($sDateFormat,5,2),'-',substring($sDateFormat,1,4))"/>
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

</xsl:stylesheet>
