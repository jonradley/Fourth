<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

TRG R9 mapper for confirmations and delivery notes.
tsMappingHospitalityTRGR9ORCDLNOut.xsl

This mapper splits the order lines depending on the CaseSize.

For each line with UoM equal to 'EA' and CaseSize greather than 1:
	Calculate the remainder of Quantity / CaseSize.
	If it is 0 then
		Change the product code to just the prefix.
		Change the UOM to CS
		Change the quantity to Quantity / CaseSize.
		No need to create a new line.
	if it is greater than 0 then:
		Amend the quantity to the remainder. Recalculate the line total.
		Create a new line at the bottom of the document, cloning the line but:
			Set the LineNumber to NumberLines + 1
			Set the quantity to floor of Quantity / CaseSize.
			Recalculate the line total as Previous existing line LineTotal - New exiting line LineTotal

==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 14/04/2016	| Jose Miguel	| FB11341 - Created
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"  exclude-result-prefixes="msxsl">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
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

	<xsl:template match="PurchaseOrderConfirmationDetail">
		<PurchaseOrderConfirmationDetail>
			<xsl:apply-templates select="PurchaseOrderConfirmationLine"/>
			<xsl:apply-templates select="PurchaseOrderConfirmationLine" mode="new-lines-for-whole-cases"/>
		</PurchaseOrderConfirmationDetail>
	</xsl:template>
	
	<!-- Create a confirmation line, with the remainder of the Confirmed Quantity / CaseSize = 0 -->
	<xsl:template match="PurchaseOrderConfirmationLine[(LineExtraData/CaseSize &gt; 1) and (ConfirmedQuantity mod LineExtraData/CaseSize = 0)]">
		<xsl:variable name="CaseSize" select="LineExtraData/CaseSize"/>
		<xsl:variable name="LineNumber" select="js:getCurrentLineNumber()"/>
		<xsl:call-template name="createConfirmationLine">
			<xsl:with-param name="LineStatus" select="@LineStatus"/>
			<xsl:with-param name="LineNumber" select="$LineNumber"/>
			<xsl:with-param name="GTIN" select="ProductID/GTIN"/>
			<xsl:with-param name="SuppliersProductCode" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="ProductDescription" select="ProductDescription"/>
			<xsl:with-param name="OrdererQuantityUoM" select="'CS'"/>
			<xsl:with-param name="OrderedQuantity" select="floor(OrderedQuantity div $CaseSize)"/>
			<xsl:with-param name="ConfirmedQuantityUoM" select="'CS'"/>
			<xsl:with-param name="ConfirmedQuantity" select="floor(ConfirmedQuantity div $CaseSize)"/>
			<xsl:with-param name="PackSize" select="PackSize"/>
			<xsl:with-param name="UnitValueExclVAT" select="format-number(UnitValueExclVAT * $CaseSize, '0.00')"/>
			<xsl:with-param name="LineValueExclVAT" select="LineValueExclVAT"/>
			<xsl:with-param name="CaseSize" select="$CaseSize"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Create an extra confirmation line, with Confirmed Quantity / CaseSize > 0 . This line keeps the extra eaches but the cases go to an extra line created in a different template  -->
	<xsl:template match="PurchaseOrderConfirmationLine[(LineExtraData/CaseSize &gt; 1) and (ConfirmedQuantity mod LineExtraData/CaseSize > 0)]">
		<xsl:variable name="CaseSize" select="LineExtraData/CaseSize"/>
		<xsl:variable name="LineNumber" select="js:getCurrentLineNumber()"/>
		<xsl:call-template name="createConfirmationLine">
			<xsl:with-param name="LineStatus" select="@LineStatus"/>
			<xsl:with-param name="LineNumber" select="$LineNumber"/>
			<xsl:with-param name="GTIN" select="ProductID/GTIN"/>
			<xsl:with-param name="SuppliersProductCode" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="ProductDescription" select="ProductDescription"/>
			<xsl:with-param name="OrdererQuantityUoM" select="'EA'"/>
			<xsl:with-param name="OrderedQuantity" select="floor(OrderedQuantity mod $CaseSize)"/>
			<xsl:with-param name="ConfirmedQuantityUoM" select="'EA'"/>
			<xsl:with-param name="ConfirmedQuantity" select="floor(ConfirmedQuantity mod $CaseSize)"/>
			<xsl:with-param name="PackSize" select="PackSize"/>
			<xsl:with-param name="UnitValueExclVAT" select="UnitValueExclVAT"/>
			<xsl:with-param name="LineValueExclVAT" select="LineValueExclVAT"/>
			<xsl:with-param name="CaseSize" select="$CaseSize"/>
		</xsl:call-template>
	</xsl:template>
	
		<!-- Create an extra confirmation line, with Confirmed Quantity / CaseSize > 0  with the whole cases -->
	<xsl:template match="PurchaseOrderConfirmationLine[(LineExtraData/CaseSize &gt; 1) and (ConfirmedQuantity mod LineExtraData/CaseSize > 0)]" mode="new-lines-for-whole-cases">
		<xsl:variable name="CaseSize" select="LineExtraData/CaseSize"/>
		<xsl:variable name="LineNumber" select="js:getCurrentLineNumber()"/>
		<xsl:call-template name="createConfirmationLine">
			<xsl:with-param name="LineStatus" select="@LineStatus"/>
			<xsl:with-param name="LineNumber" select="$LineNumber"/>
			<xsl:with-param name="GTIN" select="ProductID/GTIN"/>
			<xsl:with-param name="SuppliersProductCode" select="ProductID/SuppliersProductCode"/>
			<xsl:with-param name="ProductDescription" select="ProductDescription"/>
			<xsl:with-param name="OrdererQuantityUoM" select="'CS'"/>
			<xsl:with-param name="OrderedQuantity" select="floor(OrderedQuantity div $CaseSize)"/>
			<xsl:with-param name="ConfirmedQuantityUoM" select="'CS'"/>
			<xsl:with-param name="ConfirmedQuantity" select="floor(ConfirmedQuantity div $CaseSize)"/>
			<xsl:with-param name="PackSize" select="PackSize"/>
			<xsl:with-param name="UnitValueExclVAT" select="format-number(UnitValueExclVAT * $CaseSize, '0.00')"/>
			<xsl:with-param name="LineValueExclVAT" select="LineValueExclVAT"/>
			<xsl:with-param name="CaseSize" select="$CaseSize"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Any lines with no case size will be output as they are -->
	<xsl:template match="PurchaseOrderConfirmationLine">
		<PurchaseOrderConfirmationLine>
			<xsl:apply-templates/>
		</PurchaseOrderConfirmationLine>
	</xsl:template>
	
	<xsl:template match="NumberOfLines">
		<NumberOfLines>
			<xsl:value-of select="js:getNumberOfLines()"/>
		</NumberOfLines>
	</xsl:template>
	
	<!-- Create a line based on the basic data -->
	<xsl:template name="createConfirmationLine">
		<xsl:param name="LineStatus"/>
		<xsl:param name="LineNumber"/>
		<xsl:param name="GTIN"/>
		<xsl:param name="SuppliersProductCode"/>
		<xsl:param name="ProductDescription"/>
		<xsl:param name="OrdererQuantityUoM"/>
		<xsl:param name="OrderedQuantity"/>
		<xsl:param name="ConfirmedQuantityUoM"/>
		<xsl:param name="ConfirmedQuantity"/>
		<xsl:param name="PackSize"/>
		<xsl:param name="UnitValueExclVAT"/>
		<xsl:param name="LineValueExclVAT"/>
		<xsl:param name="CaseSize"/>
		<PurchaseOrderConfirmationLine>
			<xsl:attribute name="LineStatus"><xsl:value-of select="$LineStatus"/></xsl:attribute>
			<LineNumber><xsl:value-of select="$LineNumber"/></LineNumber>
			<ProductID>
				<GTIN><xsl:value-of select="$GTIN"/></GTIN>
				<SuppliersProductCode><xsl:value-of select="$SuppliersProductCode"/></SuppliersProductCode>
			</ProductID>
			<ProductDescription><xsl:value-of select="$ProductDescription"/></ProductDescription>
			<OrderedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$OrdererQuantityUoM"/></xsl:attribute>
				<xsl:value-of select="$OrderedQuantity"/>
			</OrderedQuantity>
			<ConfirmedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$ConfirmedQuantityUoM"/></xsl:attribute>
				<xsl:value-of select="$ConfirmedQuantity"/>
			</ConfirmedQuantity>
			<PackSize><xsl:value-of select="$PackSize"/></PackSize>
			<UnitValueExclVAT><xsl:value-of select="$UnitValueExclVAT"/></UnitValueExclVAT>
			<LineValueExclVAT><xsl:value-of select="$LineValueExclVAT"/></LineValueExclVAT>
			<LineExtraData>
				<CaseSize><xsl:value-of select="$CaseSize"/></CaseSize>
			</LineExtraData>
		</PurchaseOrderConfirmationLine>
    </xsl:template>
<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
var currentLineNumber =  0;
function getCurrentLineNumber ()
{
	return ++currentLineNumber;
}

function getNumberOfLines ()
{	
	return currentLineNumber;
}
]]></msxsl:script>    
</xsl:stylesheet>
