<?xml version="1.0" encoding="UTF-8"?>
<!--
/***********************************************************************************************************************************************************************************
 Overview 

 XSL Goods Received Note mapper'  Hospitality iXML to Zonal XML format.
************************************************************************************************************************************************************************************
 Module History
************************************************************************************************************************************************************************************
 Date       | Name         | Description of modification
************************************************************************************************************************************************************************************
17/08/2017  | M Dimant     | FB 12096: Created based on standard Zonal GRN mapper. Added 'ADJ' onto PO reference when an adjustment GRN     
************************************************************************************************************************************************************************************

************************************************************************************************************************************************************************************
-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="ISO-8859-1"/>
	<!-- store the Aztec Compressed Output product code in a local variable
	     this is an optional field and if non-blank will result in only a single product line being output -->
	<xsl:variable name="CompressedOutput">
		<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/CompressedAztecOutput"/>
	</xsl:variable>
	<xsl:template match="/">	
		<DeliveryNote>
			<xsl:attribute name="SiteCode"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/AztecSiteID"/></xsl:attribute>
			<!-- The location of the SiteRef depends on the buyer.
			     H&H have an additional element (HardysSiteID) added by the zonal pre mapper, where as
			     Urbium use the value in the branch reference (proxy relationship) -->
			<xsl:attribute name="SiteRef">
				<xsl:choose>
					<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/HardysSiteID != ''">
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/HardysSiteID"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- Note that you would expect the branch reference to be the SendersBranchReference, as
						     the sender of a goods received note is the buyer, however this has been cc-ed back to the
						     buyer and so the branch reference ends up in the recipient section -->
						<xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/RecipientsBranchReference"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="Supplier"><xsl:value-of select="/GoodsReceivedNote/TradeSimpleHeader/SendersCodeForRecipient"/></xsl:attribute>
			<!-- Add 'ADJ' to PO reference for adjustment GRNs to make them unique -->
			<xsl:attribute name="OrderNo">
				<xsl:choose>
					<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/HeaderExtraData/AdjustmentDocument='1'">
						<xsl:value-of select="concat(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference,'-ADJ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</xsl:otherwise>
				</xsl:choose>							
			</xsl:attribute>
			<!-- If the compressed Aztec output product code exists then there will only be a single line -->
			<xsl:attribute name="Lines">
				<xsl:choose>
					<xsl:when test="$CompressedOutput != ''">
						<xsl:value-of select="1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT">
				<xsl:attribute name="Value"><xsl:value-of select="format-number((sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineValueExclVAT) - sum(/GoodsReceivedNote/GoodsReceivedNoteDetail/GoodsReceivedNoteLine/LineDiscountValue)) * (100 - /GoodsReceivedNote/GoodsReceivedNoteTrailer/DocumentDiscountRate) div 100, '0.00')"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$CompressedOutput != ''">
					<Line>
						<xsl:attribute name="LineNo">1</xsl:attribute>
						<xsl:attribute name="ImpExpRef"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
						<xsl:attribute name="Description"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
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
