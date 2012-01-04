<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2012-01-04		| 5150 Created Module
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="TradeSimpleHeaderSent">
		<TradeSimpleHeader>
			<xsl:apply-templates select="*"/>
		</TradeSimpleHeader>
	</xsl:template>
	
	<xsl:template match="ConfirmedQuantity">
		<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="."/></OrderedQuantity>
		<ConfirmedQuantity UnitOfMeasure="EA"><xsl:value-of select="."/></ConfirmedQuantity>
	</xsl:template>	

</xsl:stylesheet>