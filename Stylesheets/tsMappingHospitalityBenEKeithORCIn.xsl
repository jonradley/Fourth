<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Perform transformations on the XML version of the flat file
******************************************************************************************
 Module History
******************************************************************************************
 Date			| Name					| Description of modification
******************************************************************************************
 06/03/2013	| Harold Robson		| FB6189 Created module 
******************************************************************************************
				| 							|
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
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

	<!-- concatenate SendersBranchReference and SendersCodeForRecipient fields to SendersCodeForRecipient-->
	<xsl:template match="SendersCodeForRecipient">
		<SendersCodeForRecipient>
			<xsl:value-of select="concat(../SendersBranchReference,'-',.)"/>
		</SendersCodeForRecipient>
	</xsl:template>
	
	<!-- remove SBR -->
	<xsl:template match="SendersBranchReference"/>
	
	<!-- convert UoM codes -->
	<xsl:template match="@UnitOfMeasure">
		<xsl:choose>
			<xsl:when test=". = 'CA'"><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test=". = 'EA'"><xsl:text>EA</xsl:text></xsl:when>
			<xsl:when test=". = 'LB'"><xsl:text>PND</xsl:text></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- convert LineStatus codes -->
	<xsl:template match="PurchaseOrderConfirmationLine/@LineStatus">
		<xsl:choose>
			<xsl:when test=". = ' '"><xsl:text>Accepted</xsl:text></xsl:when>
			<xsl:when test=". = 'O'"><xsl:text>Rejected</xsl:text></xsl:when>
			<xsl:when test=". = 'P'"><xsl:text>QuantityChanged</xsl:text></xsl:when>
			<xsl:when test=". = 'S'"><xsl:text>Changed</xsl:text></xsl:when>
			<xsl:when test=". = 'R'"><xsl:text>Changed</xsl:text></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- format dates-->
	<xsl:template match="PurchaseOrderConfirmationDate | DeliveryDate">
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
