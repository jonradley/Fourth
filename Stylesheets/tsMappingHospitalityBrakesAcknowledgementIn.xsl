<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2007-11-28		| FB1626
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" />	
	
	
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="@* | node()"/>
		</BatchRoot>
	</xsl:template>
	
	
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">84</xsl:attribute>			
			<xsl:apply-templates select="@* | node()"/>			
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="BuyersLocationID">
	
		<xsl:copy>
			<GLN><xsl:value-of select="GLN"/></GLN>
			<SuppliersCode><xsl:value-of select="GLN"/></SuppliersCode>
		</xsl:copy>
	
	</xsl:template>
	
	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderAcknowledgementDate | DeliveryDate">
	
		<xsl:copy>
		
			<xsl:choose>
				<xsl:when test="string-length(.)=6">
					<xsl:text>20</xsl:text>
					<xsl:value-of select="substring(.,5,2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(.,5,4)"/>				
				</xsl:otherwise>				
			</xsl:choose>
			
			<xsl:text>-</xsl:text>
			
			<xsl:value-of select="substring(.,3,2)"/>
			
			<xsl:text>-</xsl:text>
							
			<xsl:value-of select="substring(.,1,2)"/>

		</xsl:copy>
	
	</xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	
</xsl:stylesheet>
