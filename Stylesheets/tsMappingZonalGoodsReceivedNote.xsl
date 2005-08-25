<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml"/>
	<xsl:template match="/">	
		<DeliveryNote>
			<xsl:attribute name="SiteCode"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/AztecSiteID"/></xsl:attribute>
			<xsl:attribute name="SiteRef"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HardysSiteID"/></xsl:attribute>
			<xsl:attribute name="Supplier"><xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/></xsl:attribute>
			<xsl:attribute name="OrderNo"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
			<xsl:attribute name="Lines"><xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine)"/></xsl:attribute>
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT">
				<xsl:attribute name="Value"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/CompressedAztecOutput and /GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/CompressedAztecOutput != ''">
					<Line>
						<xsl:attribute name="LineNo">1</xsl:attribute>
						<xsl:attribute name="ImpExpRef"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/CompressedAztecOutput"/></xsl:attribute>
						<xsl:attribute name="Quantity">1</xsl:attribute>
						<xsl:attribute name="UnitCost"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
					</Line>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
						<Line>
							<xsl:attribute name="LineNo"><xsl:value-of select="LineNumber"/></xsl:attribute>
							<xsl:attribute name="ImpExpRef"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
							<xsl:if test="ProductDescription">
								<xsl:attribute name="Description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="Quantity"><xsl:value-of select="AcceptedQuantity"/></xsl:attribute>
							<xsl:if test="UnitValueExclVAT">
								<xsl:attribute name="UnitCost"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>
							</xsl:if>
							<xsl:for-each select="Breakages/Breakage">
								<Breakage>
									<xsl:attribute name="Quantity"><xsl:value-of select="BreakageQuantity"/></xsl:attribute>
									<xsl:attribute name="BaseUnit"><xsl:value-of select="BaseUnit"/></xsl:attribute>
									<xsl:attribute name="BaseAmount"><xsl:value-of select="BaseAmount"/></xsl:attribute>
								</Breakage>
							</xsl:for-each>
						</Line>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</DeliveryNote>
	</xsl:template>
</xsl:stylesheet>
