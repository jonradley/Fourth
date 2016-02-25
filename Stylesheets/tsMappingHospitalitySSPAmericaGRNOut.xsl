<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      		| Name 					| Description of modification
==========================================================================================
27/05/2009	| R Cambridge			| Created module. Copies the buyers code for shipto in the suppliers code field
==========================================================================================
           		|                 				|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
		<xsl:copy>
			<xsl:value-of select="../BuyersCode"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Remove zero qty lines -->
	<xsl:template match="GoodsReceivedNoteDetail">
		<GoodsReceivedNoteDetail>
			<xsl:for-each select="GoodsReceivedNoteLine">
				<xsl:if test="number(AcceptedQuantity) != 0">
					<GoodsReceivedNoteLine>
						<LineNumber>
							<xsl:value-of select="count(preceding-sibling::*[number(AcceptedQuantity) != 0]) + 1"/>
						</LineNumber>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="PurchaseOrderConfirmationReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<xsl:copy-of select="GoodsReceivedNoteReferences"/>
						<xsl:copy-of select="ProductID"/>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:copy-of select="OrderedQuantity"/>
						<xsl:copy-of select="ConfirmedQuantity"/>
						<xsl:copy-of select="DeliveredQuantity"/>
						<xsl:copy-of select="AcceptedQuantity"/>
						<xsl:copy-of select="InvoicedQuantity"/>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="LineDiscountRate"/>
						<xsl:copy-of select="LineDiscountValue"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
						<xsl:copy-of select="NetPriceFlag"/>
						<xsl:copy-of select="Measure"/>
						<xsl:copy-of select="LineExtraData"/>
					</GoodsReceivedNoteLine>
				</xsl:if>
			</xsl:for-each>
		</GoodsReceivedNoteDetail>
	</xsl:template>
	
	<xsl:template match="NumberOfLines">
		<NumberOfLines>
			<xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[number(AcceptedQuantity) != 0])"/>
		</NumberOfLines>
	</xsl:template>
	
	<xsl:template match="DiscountedLinesTotalExclVAT">
		<DiscountedLinesTotalExclVAT>
			<xsl:value-of select="format-number(sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[number(AcceptedQuantity) != 0]/LineValueExclVAT),'0.00')"/>
		</DiscountedLinesTotalExclVAT>
	</xsl:template>
	
	<xsl:template match="TotalExclVAT">
		<TotalExclVAT>
			<xsl:value-of select="format-number(sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine[number(AcceptedQuantity) != 0]/LineValueExclVAT),'0.00')"/>
		</TotalExclVAT>
	</xsl:template>
	
</xsl:stylesheet>