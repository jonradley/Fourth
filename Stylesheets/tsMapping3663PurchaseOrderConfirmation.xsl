<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation pre-mapper
'  3663/MyMarket (OFSCI) format Product Code Translation.
'  3663 have specific split pack handling of product codes that is non-generic
'  and needs to catered for before the document is processed by the generic OFSCI mapper.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 21/02/2005  | Lee Boyton   | Created
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
	
	<!--
	   3663 specific split pack handling:
	   If the UoM is set to 'EA' then the product code should have a capital S added to the end,
	   else (UoM will be 'CS') the product code remains unchanged
	-->
	<xsl:template match="ItemIdentification">
		<ItemIdentification>
			<GTIN scheme="GTIN">
				<xsl:value-of select="GTIN"/>	
			</GTIN>
			<xsl:if test="AlternateCode and AlternateCode != ''">
				<AlternateCode scheme="OTHER">
					<xsl:value-of select="AlternateCode"/>
					<xsl:if test="substring(../RequestedQuantity/@unitCode,1,2) = 'EA'">
						<xsl:text>S</xsl:text>
					</xsl:if>
				</AlternateCode>
			</xsl:if>
		</ItemIdentification>
	</xsl:template>

	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
