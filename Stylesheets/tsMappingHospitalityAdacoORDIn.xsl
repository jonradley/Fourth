<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Inbound orders from Adaco.Net (basically internal format)
 
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         	| Description of modification
******************************************************************************************
 2013-02-21  | R Cambridge 	| FB6038 Created Module (from FnB inbound order mapper)
******************************************************************************************
		        |            	| 
******************************************************************************************
             |            	| 
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:include href="./tsMappingHospitalityAdacoCommon.xsl"/>
	
	<xsl:variable name="LINE_BREAK_STRING" select="'&amp;lt;br&amp;gt;'"/>

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="2">
						<xsl:apply-templates/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
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

	
	<!-- Determine SBR (also used as buyer's code for ship to -->
	<xsl:variable name="SendersBranchReference">
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Property/BuyersCode"/>
		<xsl:value-of select="$HOTEL_SUBDIVISION_SEPERATOR"/>
		<xsl:value-of select="/PurchaseOrder/PurchaseOrderHeader/Outlet/BuyersCode"/>
	</xsl:variable>

	
	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="SendersCodeForRecipient"/>
			</SendersCodeForRecipient>
			<SendersBranchReference>
				<xsl:value-of select="$SendersBranchReference"/>
			</SendersBranchReference>
		</TradeSimpleHeader>
	</xsl:template>

	
	<!-- Buyer GLN -->
	<xsl:template match="BuyersLocationID">
		<BuyersLocationID>
			<!--xsl:element name="GLN">5555555555555</xsl:element-->
			<xsl:copy-of select="BuyersCode"/>
		</BuyersLocationID>
	</xsl:template>
	
	<!-- Seller GLN -->
	<xsl:template match="SuppliersLocationID">
		<SuppliersLocationID>
			<!--xsl:element name="GLN">5555555555555</xsl:element-->
			<xsl:copy-of select="BuyersCode"/>
		</SuppliersLocationID>
	</xsl:template>
	
	
	
	<xsl:template match="Property | Outlet"/>
	
	<xsl:template match="ShipTo">
		<ShipTo>
			<ShipToLocationID>
				<BuyersCode>
					<xsl:value-of select="$SendersBranchReference"/>
				</BuyersCode>
			</ShipToLocationID>
			<ContactName>
				<xsl:value-of select="ContactName"/>
			</ContactName>
		</ShipTo>
	</xsl:template>
	
	<!-- Ensure line elements are in the correct order -->
	<xsl:template match="PurchaseOrderLine">
	
		<PurchaseOrderLine>
		
			<xsl:copy-of select="LineNumber"/>
			<xsl:copy-of select="ProductID"/>
			<xsl:copy-of select="ProductDescription"/>
			<xsl:copy-of select="OrderedQuantity"/>
			<xsl:copy-of select="PackSize"/>
			<xsl:copy-of select="UnitValueExclVAT"/>
			<xsl:copy-of select="LineValueExclVAT"/>	
			
		</PurchaseOrderLine>
	
	</xsl:template>
	
		
</xsl:stylesheet>
