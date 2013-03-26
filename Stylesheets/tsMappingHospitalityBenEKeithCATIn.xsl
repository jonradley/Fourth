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
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:apply-templates/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template match="PriceCatalog">
		<PriceCatalog>
			<xsl:attribute name="CatType">Complete</xsl:attribute>
			<xsl:attribute name="CatSpecificPrices">Yes</xsl:attribute>
			<xsl:apply-templates/>
		</PriceCatalog>
	</xsl:template>
	
	<xsl:template match="PriceCatHeader">
		<PriceCatHeader>
			<!-- format dates for catalogue loader DD/MM/YYYY -->
			<ValidStartDate><xsl:value-of select="concat(substring(ValidStartDate,7,2),'/',substring(ValidStartDate,5,2),'/',substring(ValidStartDate,1,4))"/></ValidStartDate>
			<ListOfDescription_Header>
				<Description_Header>Ben E Keith product catalogue</Description_Header>
			</ListOfDescription_Header>
			<CatHdrRef>
				<PriceCat>
					<RefNum>bekcat</RefNum>
				</PriceCat>
			</CatHdrRef>
			<SupplierParty>
				<Party>
					<NameAddress>
						<Name1>.</Name1>
					</NameAddress>
				</Party>
			</SupplierParty>
		</PriceCatHeader>
	</xsl:template>
	
	<xsl:template match="PriceCatDetail">
		<PriceCatDetail>
			<PriceAction>Add</PriceAction>
			<xsl:apply-templates/>	
		</PriceCatDetail>
	</xsl:template>
	
	<xsl:template match="ListOfKeyVal">
		<ListOfKeyVal>
			<KeyVal Keyword="PackSize"><xsl:value-of select="KeyVal_PackSize"/></KeyVal>
			<KeyVal Keyword="Group">products</KeyVal>
			<KeyVal Keyword="StockItem">1</KeyVal>
			<KeyVal Keyword="IgnorePriceChange">0</KeyVal>
			<!-- convert UoM codes MUST BE DONE BEFORE PRODUCT CODE LOGIC which depends on T|S UoMs -->
			<KeyVal Keyword="UOM">
				<xsl:choose>
					<xsl:when test="KeyVal_UOM = 'CA'">CS</xsl:when>
					<xsl:when test="KeyVal_UOM = 'EA'">EA</xsl:when>
					<xsl:when test="KeyVal_UOM = 'LB'">PND</xsl:when>
				</xsl:choose>
			</KeyVal>
		</ListOfKeyVal>
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
