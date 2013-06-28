<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations

	Bibendum confirmations

**********************************************************************
Name			| Date				| Change
**********************************************************************
     ?     	|       ?    		| Created Module
**********************************************************************
H Mahbub		|	2010-05-17		| Created file
**********************************************************************
R Cambridge	|	2011-08-24		| 4743 change product code manipulation to be default (hard code a list of customer that will no require it)
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*********************************************************************
K Oshaughnessy|2012-08-29| Additional customer added (Mitie) FB 5664
*********************************************************************
A Barber		|	2012-08-29		| 5709 Added no UOM append product code handling for PBR.	
*********************************************************************
H Robson		|	2013-03-26		| 6285 Added Creative Events	
*********************************************************************
H Robson		|	2013-05-07		| 6496 PBR append UoM to product code	
*********************************************************************
S Hussain		|	2013-05-15		| 6496 Optimization
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:import href="BibendumInclude.xsl"/>	
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
		
	<!-- The structure of the interal XML varries depending on who the customer is -->
	<!-- UoM may not be added to product codes for these customers -->
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates />
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

	<xsl:template match="PurchaseOrderConfirmationHeader">
		<PurchaseOrderConfirmationHeader>
			<DocumentStatus>Original</DocumentStatus>
			<Buyer><xsl:apply-templates select="Buyer/*"/></Buyer>
			<Supplier><xsl:apply-templates select="Supplier/*"/></Supplier>
			<ShipTo><xsl:apply-templates select="ShipTo/*"/></ShipTo>
			<PurchaseOrderReferences><xsl:apply-templates select="PurchaseOrderReferences/*"/></PurchaseOrderReferences>
			<PurchaseOrderConfirmationReferences><xsl:apply-templates select="PurchaseOrderConfirmationReferences/*"/></PurchaseOrderConfirmationReferences>
			<OrderedDeliveryDetails><xsl:apply-templates select="OrderedDeliveryDetails/DeliveryDate"/></OrderedDeliveryDetails>
			<ConfirmedDeliveryDetails><xsl:apply-templates select="ConfirmedDeliveryDetails/DeliveryDate"/></ConfirmedDeliveryDetails>
		</PurchaseOrderConfirmationHeader>
	</xsl:template>

	<xsl:template match="TradeSimpleHeader | BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
		<PurchaseOrderConfirmationLine>
			<LineNumber>
				<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
			</LineNumber>
			<xsl:apply-templates select="ProductID/SuppliersProductCode"/>
			<xsl:copy-of select="ProductDescription" />
			<ConfirmedQuantity>
				<xsl:copy-of select="ConfirmedQuantity/@UnitOfMeasure"/>
				<xsl:value-of select="format-number(ConfirmedQuantity div 1000,'0.00')"/>
			</ConfirmedQuantity>
			<xsl:for-each select="PackSize[1]">
				<PackSize><xsl:value-of select="."/></PackSize>
			</xsl:for-each>
		</PurchaseOrderConfirmationLine>
	</xsl:template>

	<xsl:template match="ProductID/SuppliersProductCode">
		<ProductID>
			<SuppliersProductCode>
			<xsl:call-template name="FormatSupplierProductCode">
				<xsl:with-param name="sUOM" select="../../ConfirmedQuantity/@UnitOfMeasure"/>
				<xsl:with-param name="sProductCode" select="."/>
			</xsl:call-template>
			</SuppliersProductCode>
		</ProductID>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
		<xsl:copy>
				<xsl:call-template name="fixDateYY">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
