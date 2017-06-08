<?xml version="1.0" encoding="UTF-8"?>
<!--
'**********************************************************************************************************************
' Overview
'
' Maps Nigel Fredericks outbound purchase orders 
'
'**********************************************************************************************************************
' Module History
'**********************************************************************************************************************
' Date             | Name              | Description of modification
'**********************************************************************************************************************
' 10/05/2011  | M Dimant | Created
'**********************************************************************************************************************
' 01/05/2012  | M Dimant | 5448: Added UOM conversion
'**********************************************************************************************************************
' 04/02/2013  | M Dimant | 5983: Map SuppliersCode into BuyersCode, as per NF's requirenments
'**********************************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">	
		<PurchaseOrders>	
				<xsl:apply-templates/>					
		</PurchaseOrders>		
	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>

			
	<xsl:template match="TradeSimpleHeader"/>

	
	<xsl:template match="ShipTo/ShipToLocationID">	
		<ShipToLocationID>
			<GLN>
				<xsl:value-of select="GLN"/>
			</GLN>
			<BuyersCode><xsl:value-of select="SuppliersCode"/></BuyersCode>
			<SuppliersCode>
				<xsl:value-of select="/PurchaseOrder/TradeSimpleHeader/RecipientsCodeForSender"/>
			</SuppliersCode>
		</ShipToLocationID>
	</xsl:template>

	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure">
			<xsl:choose>
				<xsl:when test=".='CS'">PK</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			
		</xsl:attribute>
	</xsl:template>

	
</xsl:stylesheet>
