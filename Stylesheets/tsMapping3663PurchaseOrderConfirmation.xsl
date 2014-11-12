<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************'******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation pre-mapper
'  3663/MyMarket (OFSCI) format Product Code Translation.
'  3663 have specific split pack handling of product codes that is non-generic
'  and needs to catered for before the document is processed by the generic OFSCI mapper.
'
' © ABS Ltd., 2005.
'******************************************************************************************'******************************************************************************************
' Module History
'******************************************************************************************'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************'******************************************************************************************
' 21/02/2005  | Lee Boyton   | Created
'******************************************************************************************'******************************************************************************************
' 28/02/2013  | A Barber       | 6118 Added logic not to apply an 'S' to split lines for Tragus.
'******************************************************************************************'******************************************************************************************
' 12/11/2014  | M Dimant      | 10081 Added logic not to apply an 'S' to split lines for Strada.
'******************************************************************************************'******************************************************************************************
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

	   If the UoM is set to 'EA' then the product code should have a capital S added to the end, else (UoM will be 'CS') the product code remains unchanged.		   
	   However, Bidvest are an exception and already put an S on the end of the product codes, so we will not do this if the confimation is for Tragus or Strada!
	-->
	<xsl:template match="ItemIdentification">
		<ItemIdentification>
			<GTIN scheme="GTIN">
				<xsl:value-of select="GTIN"/>	
			</GTIN>
			<xsl:if test="AlternateCode and AlternateCode != ''">
				<AlternateCode scheme="OTHER">
					<xsl:value-of select="AlternateCode"/>
					<xsl:if test="substring(../RequestedQuantity/@unitCode,1,2) = 'EA' and not(//Buyer/BuyerGLN = '5060166761189' or '5060166761301')">
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
