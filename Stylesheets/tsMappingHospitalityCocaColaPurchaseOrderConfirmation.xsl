<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Overview 
'  XSL Purchase Order Confirmation pre-mapper
'  Coca Cola Enterprices Ltd OFSCI format translation.
'  CCE use GTINs and these need to be copied to the AlternateCode field as the 
'  Hospitality OFSCI confirmation mapper expects the codes to tbe in the this field.
'  The trade agreement reference also needs to be copied to the Seller/SellerAssigned field.
'
' © ABS Ltd., 2007.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 30/09/2007  | Lee Boyton   | Created
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
	<xsl:output method="xml"/>

	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()" />
		</BatchRoot>
	</xsl:template>

	<!-- copy the trade agreement reference to the Seller/SellerAssigned element if it exists
	     otherwise remove the Seller/SellerAssigned element if not -->
	<xsl:template match="Seller[not(SellerAssigned)]">
		<SellerGLN scheme="GLN">
			<xsl:value-of select="SellerGLN"/>
		</SellerGLN>
		<xsl:if test="//TradeAgreementReference/ContractReferenceNumber != ''">
			<SellerAssigned scheme="OTHER">
				<xsl:value-of select="//TradeAgreementReference/ContractReferenceNumber"/>
			</SellerAssigned>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Seller/SellerAssigned">
		<xsl:if test="//TradeAgreementReference/ContractReferenceNumber != ''">
			<SellerAssigned scheme="OTHER">
				<xsl:value-of select="//TradeAgreementReference/ContractReferenceNumber"/>
			</SellerAssigned>
		</xsl:if>
	</xsl:template>
	
	<!-- copy the GTIN to the AlternateCode element (removing any leading zeros if present) -->	
	<xsl:template match="ItemIdentification">
		<ItemIdentification>
			<GTIN scheme="GTIN">
				<xsl:value-of select="string(number(GTIN))"/>
			</GTIN>
			<AlternateCode scheme="OTHER">
				<xsl:value-of select="string(number(GTIN))"/>	
			</AlternateCode>
		</ItemIdentification>
	</xsl:template>

	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
