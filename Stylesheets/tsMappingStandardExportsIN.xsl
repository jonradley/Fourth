<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Stylesheet to map in the Standard Exports from R9/FnB

******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 05/07/2013  | S Sehgal  | 6715 /6625 Created
*****************************************************************************************

***************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" encoding="utf-8"/>
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
		<!-- Copy the attribute unchanged -->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	<xsl:template match="OrganisationCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="//AccountingSystemCode !=''">
					<xsl:value-of select="//AccountingSystemCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//OrganisationCode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="AccountingSystemCode"/>
</xsl:stylesheet>
