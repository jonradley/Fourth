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
	
	<xsl:template match="PriceCatalog">
		<PriceCatalog>
			<xsl:attribute name="CatType">Complete</xsl:attribute>
			<xsl:attribute name="CatSpecificPrices">Yes</xsl:attribute>
			<xsl:apply-templates/>
		</PriceCatalog>
	</xsl:template>
	
	<!-- format dates for catalogue loader DD/MM/YYYY -->
    <xsl:variable name ="MaxStartDate">
      <xsl:for-each select="//KeyVal_StockItem">
        <xsl:sort select="KeyVal_StockItem" data-type="number" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="." />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name ="MinEndDate">
      <xsl:for-each select="//KeyVal_IgnorePriceChange">
        <xsl:sort select="." data-type="number" order="ascending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="." />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable> 
    
	<xsl:template match="ValidStartDate">
		<ValidStartDate><xsl:value-of select="concat(substring($MaxStartDate,7,2),'/',substring($MaxStartDate,5,2),'/',substring($MaxStartDate,1,4))"/></ValidStartDate>
		<ValidEndDate><xsl:value-of select="concat(substring($MinEndDate,7,2),'/',substring($MinEndDate,5,2),'/',substring($MinEndDate,1,4))"/></ValidEndDate>
	</xsl:template>
	
	<xsl:template match="PriceCatHeader">
		<PriceCatHeader>
			<xsl:apply-templates/>
			<SupplierParty>
				<Party>
					<NameAddress>
						<Name1>.</Name1>
					</NameAddress>
				</Party>
			</SupplierParty>
		</PriceCatHeader>
	</xsl:template>
	
	<xsl:template match="ListOfDescription_Header">
		<ListOfDescription>
			<Description><xsl:value-of select="Description_Header"/></Description>
		</ListOfDescription>
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
			<KeyVal Keyword="Group"><xsl:value-of select="translate(KeyVal_Group,'*','')"/></KeyVal>
			<KeyVal Keyword="StockItem">1</KeyVal>
			<KeyVal Keyword="IgnorePriceChange">0</KeyVal>
			<KeyVal Keyword="UOM">
				<xsl:choose>
					<xsl:when test="KeyVal_UOM = 'CA'"><xsl:text>CS</xsl:text></xsl:when>
					<xsl:when test="KeyVal_UOM = 'EA'"><xsl:text>EA</xsl:text></xsl:when>
					<xsl:when test="KeyVal_UOM = 'LB'"><xsl:text>PND</xsl:text></xsl:when>
				</xsl:choose>
			</KeyVal>
		</ListOfKeyVal>
	</xsl:template>

	<!-- Product code logic -->
	<xsl:template match="PartID">
		<xsl:element name="PartID">
			<xsl:call-template name="CompoundProductCodeOperations">
				<xsl:with-param name="ProductCode" select="."/>
				<xsl:with-param name="UoM" select="../../ListOfKeyVal/KeyVal_UOM"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
