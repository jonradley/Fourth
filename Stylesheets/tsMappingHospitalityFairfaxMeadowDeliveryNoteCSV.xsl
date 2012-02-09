<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd., 2000.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
     ?     	|        ?				| ?
==========================================================================================
 2011-09-12	| R Cambridge     	| 4828 Added customer PO ref (sent in original order and passed on Fairfax Meadow, who return it in their delivery data)
==========================================================================================
 2012-02-09	| R Cambridge     	| 5193 Adjustments to accomdate the fact that " text delimiters are now removed in the flat file mapper
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
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

	<!-- strip quotes from text fields -->
	<xsl:template match="SendersCodeForRecipient">
	
		<xsl:copy>
			<xsl:call-template name="stripQuotes">
				<xsl:with-param name="sInput" select="."/>	
			</xsl:call-template>
			
			<xsl:variable name="sAdd1">
				<xsl:call-template name="stripQuotes">
					<xsl:with-param name="sInput" select="normalize-space(../SendersAddress/AddressLine1)"/>	
				</xsl:call-template>
			</xsl:variable>

			<xsl:if test="$sAdd1 != ''">
				
				<xsl:text>/</xsl:text>
				<xsl:call-template name="stripQuotes">
					<xsl:with-param name="sInput" select="normalize-space(../SendersAddress/AddressLine1)"/>	
				</xsl:call-template>
			
			</xsl:if>
				
		</xsl:copy>		

	</xsl:template>
	
	<xsl:template match="TradeSimpleHeader/SendersAddress"/>

	<xsl:template match="DeliveryNoteHeader">
		<DeliveryNoteHeader>
			<xsl:apply-templates/>
			<HeaderExtraData>
				<NumberOfBoxes><xsl:value-of select="normalize-space(../TradeSimpleHeader/SendersAddress/AddressLine2)"/></NumberOfBoxes>
			</HeaderExtraData>	
		</DeliveryNoteHeader>	
	</xsl:template>

	<!-- strip quotes from text fields -->
	<xsl:template match="BuyersLocationID/SuppliersCode |
	                     ShipToLocationID/SuppliersCode |
	                     PurchaseOrderReference |
	                     CustomerPurchaseOrderReference |
	                     DeliveryNoteReference |
	                     SuppliersProductCode |
	                     ProductDescription">
	
		<xsl:variable name="sTemp">
			<xsl:call-template name="stripQuotes">
				<xsl:with-param name="sInput">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="tagName">
			<xsl:value-of select="name()"/>
		</xsl:variable>

		<xsl:if test="$sTemp != ''">
			<xsl:element name="{$tagName}">
				<xsl:call-template name="stripQuotes">
					<xsl:with-param name="sInput">
						<xsl:value-of select="."/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!-- sort some dates -->
	<xsl:template match="PurchaseOrderDate |
	                     DeliveryNoteDate |
	                     DeliveryDate">
	
		<xsl:element name="{name()}"	>
			<xsl:call-template name="formatDates">
				<xsl:with-param name="sInput">
					<xsl:call-template name="stripQuotes">
						<xsl:with-param name="sInput">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	
	</xsl:template>

	<xsl:template match="OrderedQuantity |
	                     DespatchedQuantity">
		<xsl:element name="{name()}">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:call-template name="decodePacksize">
					<xsl:with-param name="sInput">
						<xsl:value-of select="../PackSize"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>


	<!-- remove the packsize element -->
	<xsl:template match="PackSize"></xsl:template>



	<!-- sort the customer orderline ref -->
	<xsl:template match="UnitValueExclVAT">
		<LineExtraData>
			<CustomerOrderLineNumber>
				<xsl:value-of select="."/>
			</CustomerOrderLineNumber>
		</LineExtraData>
	</xsl:template>

	<!-- sort the price -->
	<xsl:template match="SSCC">
		<xsl:variable name="sUnitVal">
			<xsl:call-template name="stripQuotes">
				<xsl:with-param name="sInput">
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$sUnitVal != ''">
			<UnitValueExclVAT>
				<xsl:value-of select="."/>
			</UnitValueExclVAT>
		</xsl:if>
	</xsl:template>

	<xsl:template name="formatDates">
		<xsl:param name="sInput"/>
		<xsl:value-of select="concat(substring($sInput,7,4),'-',substring($sInput,4,2),'-',substring($sInput,1,2))"/>
	</xsl:template>

	<xsl:template match="BatchDocument">
		<BatchDocument>
			<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
			<!--xsl:copy-of select="DeliveryNote"/-->
			<xsl:apply-templates/>
		</BatchDocument>
	</xsl:template>


	<xsl:template name="stripQuotes">
		<xsl:param name="sInput"/>
	
		<xsl:choose>
			<xsl:when test="starts-with($sInput,'&quot;') and substring($sInput,string-length($sInput),1) = '&quot;'">
				<xsl:value-of select="substring($sInput,2,string-length($sInput)-2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sInput"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

	<xsl:template name="decodePacksize">
		<xsl:param name="sInput"/>
		<xsl:choose>
			<xsl:when test="$sInput = 'EACH'">EA</xsl:when>
			<xsl:when test="$sInput = 'KG'">KGM</xsl:when>
			<xsl:when test="$sInput = '&quot;EACH&quot;'">EA</xsl:when>
			<xsl:when test="$sInput = '&quot;KG&quot;'">KGM</xsl:when>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
