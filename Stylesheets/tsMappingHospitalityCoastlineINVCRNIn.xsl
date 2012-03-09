<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
R Cambridge		| 14/08/2007		| 1336 Created module
**********************************************************************
         Steve Bowers	  		| 27-2-2012           		|    5260  New stylesheet for Coastline                            
**********************************************************************
Steve Bowers					28-2-2012					`	5260 mapped UOM on CreditedQuantity
**********************************************************************
H Robson	| 09-3-2012           		|  5260  filename changed             
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<xsl:element name="TradeSimpleHeader">
			<xsl:copy-of select="./*"/>
		</xsl:element>
	</xsl:template>
	<!--17-2-2012 Mapping Packsize to Unitofmeasure-->
	<xsl:template match="InvoicedQuantity">
		<InvoicedQuantity>
			<xsl:choose>
				<xsl:when test="../PackSize = 'E'">
					<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
				</xsl:when>
				<xsl:when test="../PackSize = 'B'">
					<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
				</xsl:when>
				<xsl:when test="../PackSize = 'K'">
					<xsl:attribute name="UnitOfMeasure">KGM</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="."/>
		</InvoicedQuantity>
	</xsl:template>
	<xsl:template match="CreditedQuantity">
		<CreditedQuantity>
			<xsl:choose>
				<xsl:when test="../PackSize = 'E'">
					<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
				</xsl:when>
				<xsl:when test="../PackSize = 'B'">
					<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
				</xsl:when>
				<xsl:when test="../PackSize = 'K'">
					<xsl:attribute name="UnitOfMeasure">KGM</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:value-of select="."/>
		</CreditedQuantity>
	</xsl:template>

</xsl:stylesheet>

