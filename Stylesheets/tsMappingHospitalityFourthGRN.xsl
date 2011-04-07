<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
S Sehgal		| 06/04/2011		| 4369 Created
**********************************************************************
           		|            		|                                 
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>	
	<xsl:variable name="LINE_BREAK_STRING" select="'&amp;lt;br&amp;gt;'"/>
	
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
	
	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<xsl:element name="TradeSimpleHeader">
			<xsl:copy-of select="./*"/>
		</xsl:element>
	</xsl:template>

	<!-- Change TradeSimpleHeaderSent to TradeSimpleHeader -->
	<xsl:template match="TradeSimpleHeaderSent">
		<xsl:element name="TradeSimpleHeader">
			<xsl:copy-of select="./*"/>
		</xsl:element>
	</xsl:template>

	
	<!-- Buyer GLN -->
	<xsl:template match="BuyersLocationID">
		<xsl:element name="BuyersLocationID">
			<!--xsl:element name="GLN">5555555555555</xsl:element-->
			<xsl:copy-of select="BuyersCode"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Seller GLN -->
	<xsl:template match="SuppliersLocationID">
		<xsl:element name="SuppliersLocationID">
			<!--xsl:element name="GLN">5555555555555</xsl:element-->
			<xsl:copy-of select="BuyersCode"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Ship-to GLN -->
	<xsl:template match="ShipToLocationID">
		<xsl:element name="ShipToLocationID">
			<!--xsl:element name="GLN">5555555555555</xsl:element-->
			<xsl:copy-of select="BuyersCode"/>
		</xsl:element>
	</xsl:template>
	
	<!-- remove any weird characters from text fields -->
	<xsl:template match="SpecialDeliveryInstructions | BuyersName | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | PostCode | SuppliersName | ShipToName | ContactName |  ProductDescription">
		<xsl:element name="{name()}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>

	<!-- remove any weird characters from text fields -->
	<xsl:template match="BuyersName | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4">
		<xsl:element name="{name()}">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>
	
	<!-- remove line break character sequences -->
	<xsl:template match="SpecialDeliveryInstructions | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 ">
		<xsl:copy>
			<xsl:call-template name="msReplace">
				<xsl:with-param name="vsInput" select="normalize-space(.)" />
				<xsl:with-param name="vsTarget" select="$LINE_BREAK_STRING" />
				<xsl:with-param name="vsNewValue" select="', '" />
			</xsl:call-template>	
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="GoodsReceivedNoteTrailer">
	</xsl:template>
	
	<xsl:template name="msReplace">
		<xsl:param name="vsInput" />
		<xsl:param name="vsTarget" />
		<xsl:param name="vsNewValue" />
		<xsl:choose>
			<xsl:when test='contains($vsInput,$vsTarget)'>
				<xsl:value-of select="substring-before($vsInput,$vsTarget)"/>
				<xsl:value-of select="$vsNewValue"/>
				<xsl:call-template name="msReplace">
					<xsl:with-param name="vsInput" select="substring-after($vsInput,$vsTarget)" />
					<xsl:with-param name="vsTarget" select="$vsTarget" />
					<xsl:with-param name="vsNewValue" select="$vsNewValue" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$vsInput" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
