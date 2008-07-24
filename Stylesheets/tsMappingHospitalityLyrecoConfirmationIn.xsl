<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************

Maps Lyreco's attempt at tsXML into tsXML (it's about 1000000 times 
quicker to write this mapper than get Lyreco to change their output)

Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
R Cambridge		| 14/08/2007		| 1746 Created module (copied from tsMappingHospitalityInternalXMLInbound.xsl)
**********************************************************************
           		|            		|                                 
**********************************************************************

*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="3">		
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
	
	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<xsl:element name="TradeSimpleHeader">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- Ensure SCR is Lyreco's code for ship-to -->
	<xsl:template match="SendersCodeForRecipient">
		<xsl:element name="SendersCodeForRecipient">
			<xsl:value-of select="../../PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		</xsl:element>
	</xsl:template>

	<!-- Lyreco's total ex VAT invlucdes VAT -->
	<xsl:template match="TotalExclVAT"/>


</xsl:stylesheet>
