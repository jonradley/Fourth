<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Inbound orders from FnB Manager 
 
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         	| Description of modification
******************************************************************************************
    ?        |      ?      	|           ?
******************************************************************************************
  23/09/2009 | R Cambridge 	| 2839 Don't create elements that can be reasonably added by the infiller
******************************************************************************************
             |             	|           
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
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

	
	<!-- Buyer GLN -->
	<xsl:template match="BuyersLocationID">
		<xsl:element name="BuyersLocationID">
			<xsl:element name="GLN">5555555555555</xsl:element>
			<xsl:copy-of select="BuyersCode"/>
		</xsl:element>
	</xsl:template>	
	
	
	<!-- remove any weird characters from text fields -->
	<xsl:template match="SpecialDeliveryInstructions | BuyersName | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | PostCode | SuppliersName | ShipToName | ContactName |  ProductDescription | OrderedDeliveryDetailsLineLevel">
		<xsl:element name="{name()}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>

	<!-- Remove Customer Order REf -->
	<xsl:template match="CustomerPurchaseOrderReference">
	</xsl:template>
	
	<!-- Remove OrderID -->
	<xsl:template match="OrderID">
	</xsl:template>
	

	<!-- Remove Line Value and Total Value-->
	<xsl:template match="LineValueExclVAT">
	</xsl:template>
	
	<xsl:template match="PurchaseOrderTrailer">
	</xsl:template>
	
</xsl:stylesheet>
