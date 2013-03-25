<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Perform transformations on the XML version of the flat file
******************************************************************************************
 Module History
******************************************************************************************
 Date			| Name					| Description of modification
******************************************************************************************
 25/03/2013	| Harold Robson		| FB 6273 Created module 
******************************************************************************************
				| 							|
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="tsMappingHospitalityBenEKeithIncludes.xsl"/>
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">
		<BatchRoot>
			<Document>
				<xsl:attribute name="TypePrefix"><xsl:text>CAT</xsl:text></xsl:attribute>
				<Batch>
					<BatchDocuments>
						<BatchDocument>
							<xsl:apply-templates/>
						</BatchDocument>
					</BatchDocuments>
				</Batch>
			</Document>
		</BatchRoot>
	</xsl:template>

	<xsl:template match="/PriceCatHeader">
		<PriceCatHeader>
			<ValidStartDate><xsl:value-of select="ValidStartDate"/></ValidStartDate>
			<ListOfDescription>
				<Description>Ben E Keith product catalogue</Description>
			</ListOfDescription>
			<CatHdrRef>
				<PriceCat>
					<RefNum>bekcat</RefNum>
				</PriceCat>
			</CatHdrRef>
		</PriceCatHeader>
	</xsl:template>
	
	<xsl:template match="PriceCatDetail">
		<PriceCatDetail>
			<PriceAction>Add</PriceAction>
			<xsl:apply-templates/>	
		</PriceCatDetail>
	</xsl:template>
	
	<!-- convert UoM codes MUST BE DONE BEFORE PRODUCT CODE LOGIC which depends on T|S UoMs -->
	<xsl:template match="KeyVal_UOM">
		<xsl:element name="{name()}">
			<xsl:choose>
				<xsl:when test=". = 'CA'">CS</xsl:when>
				<xsl:when test=". = 'EA'">EA</xsl:when>
				<xsl:when test=". = 'LB'">PND</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<!-- format dates for catalogue loader DD/MM/YYYY -->
	<xsl:template match="ValidStartDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,7,2),'/',substring(.,5,2),'/',substring(.,1,4))"/>
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

</xsl:stylesheet>
