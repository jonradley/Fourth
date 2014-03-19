<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Module History
'******************************************************************************************
' Date		    | Name				   | Description of modification
'******************************************************************************************
' 10/03/2014	    | Jose Miguel			   | FB7741. Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:output method="xml" indent="no" encoding="UTF-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
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
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="PurchaseOrderDate | DeliveryDate">
		<xsl:element name="{name()}">
			<xsl:call-template name="fixDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SlotStart | SlotEnd">
		<xsl:element name="{name()}">
			<xsl:call-template name="fixTime">
				<xsl:with-param name="sTime" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@LineStatus">
		<xsl:attribute name="{name()}">
			<xsl:choose>
				<xsl:when test=". = 'A'"><xsl:text>Accepted</xsl:text></xsl:when>
				<xsl:when test=". = 'C'"><xsl:text>Changed</xsl:text></xsl:when>
				<xsl:when test=". = 'R'"><xsl:text>Rejected</xsl:text></xsl:when>
				<xsl:when test=". = 'S'"><xsl:text>Added</xsl:text></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
