<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Perform transformations on the XML version of the flat file
******************************************************************************************
 Module History
******************************************************************************************
 Date			| Name					| Description of modification
******************************************************************************************
 05/03/2013	| Harold Robson		| FB6189 Created module 
******************************************************************************************
				| 							|
***************************************************************************************-->
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
	<xsl:template match="InvoiceDate | TaxPointDate | PurchaseOrderDate">
		<xsl:element name="{name()}">
			<xsl:call-template name="formatDates">
				<xsl:with-param name="sInput" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

	<xsl:template name="formatDates">
		<xsl:param name="sInput"/>
		<xsl:value-of select="concat(substring($sInput,1,4),'-',substring($sInput,5,2),'-',substring($sInput,7,2))"/>
	</xsl:template>
	
</xsl:stylesheet>
