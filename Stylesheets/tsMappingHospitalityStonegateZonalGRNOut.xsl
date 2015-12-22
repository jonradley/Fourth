<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
' Overview 
'  XSL Goods Received Note mapper
'  Hospitality iXML to Zonal XML format.
' © Fourth, 2013
'******************************************************************************************
' Module History
'******************************************************************************************
' Date			| Name				| Description of modification
'******************************************************************************************
' 13/08/2013	| Andrew Barber | 6863 Created [branched from 'tsMappingZonalGoodsReceivedNote.xsl']
'***************************************************************************************-->

<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/">	
		<DeliveryNote>
			<xsl:attribute name="SiteCode">
				<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:attribute>
			<xsl:attribute name="SiteRef">
				<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:attribute>
			<xsl:attribute name="Supplier">
				<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/>
			</xsl:attribute>
			<xsl:attribute name="OrderNo">
				<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:attribute>
			<xsl:attribute name="Lines">
				<xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine)"/>
			</xsl:attribute>
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT">
				<xsl:attribute name="Value">
					<xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
				<Line>
					<xsl:attribute name="LineNo">
						<xsl:value-of select="LineNumber"/>
					</xsl:attribute>
					<xsl:attribute name="ImpExpRef">
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</xsl:attribute>
					<xsl:if test="ProductDescription">
						<xsl:attribute name="Description">
							<xsl:value-of select="ProductDescription"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="Quantity">
						<xsl:value-of select="AcceptedQuantity"/>
					</xsl:attribute>
					<xsl:if test="UnitValueExclVAT">
						<xsl:attribute name="UnitCost">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="Breakages/Breakage">
						<Breakage>
							<xsl:attribute name="Quantity">
								<xsl:value-of select="BreakageQuantity"/>
							</xsl:attribute>
							<xsl:attribute name="BaseUnit">
								<xsl:value-of select="BaseUnit"/>
							</xsl:attribute>
							<xsl:attribute name="BaseAmount">
								<xsl:value-of select="BaseAmount"/>
							</xsl:attribute>
						</Breakage>
					</xsl:for-each>
				</Line>
			</xsl:for-each>
		</DeliveryNote>
	</xsl:template>
</xsl:stylesheet>
