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
 02/04/2013	| Harold Robson		| FB6292 Created module 
******************************************************************************************
 02/05/2013	| R Cambridge  		| FB6490 Remove product code manipulation with UoM and strip leading zeros
******************************************************************************************
           	|              		| 
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
		
	<!-- convert UoM codes MUST BE DONE BEFORE PRODUCT CODE LOGIC which depends on T|S UoMs -->
	<xsl:template match="node()[@UnitOfMeasure]">
		<xsl:element name="{name()}">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="./@UnitOfMeasure = 'CA'">CS</xsl:when>
					<xsl:when test="./@UnitOfMeasure = 'EA'">EA</xsl:when>
					<xsl:when test="./@UnitOfMeasure = 'LB'">PND</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0.00')"/>
		</xsl:element>
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

	
	<!-- Product Code logic ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		The way this works is if we’re out of the original item ordered and the customer has approved having substitute or replacement 
		items then in the item number field is the substitute or replacement we plan on shipping and the original item is placed in the 
		original ordered item number field and the indicator is a ‘S’ or ‘R’.  
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		
	<!-- case: ProductID and SubstitutedProductID are populated with different numbers		action: swap them -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<SuppliersProductCode>
			<xsl:value-of select="format-number(../../SubstitutedProductID/SuppliersProductCode,'#')"/>
		</SuppliersProductCode>
	</xsl:template>		
		
	<!-- case: ProductID and SubstitutedProductID are populated with the same number		action: remove SubstitutedProductID -->
	<xsl:template match="SubstitutedProductID">
		<xsl:if test=". != ../ProductID/SuppliersProductCode">
			<SubstitutedProductID>
				<SuppliersProductCode>
					<xsl:value-of select="format-number(../ProductID/SuppliersProductCode,'#')"/>
				</SuppliersProductCode>
			</SubstitutedProductID>
		</xsl:if>
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
