<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Overview 
'  XSL Purchase Order Confirmation mapper
'  Hospitality iXML to Zonal XML format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' ??/??/????  | ?            | Created        
'******************************************************************************************
' 02/09/2005  | Lee Boyton   | H488. Cater for the SiteRef for Urbium messages being in the
'                            | recipient's branch reference field.
'                            | Only output a compressed line if they are not all rejected.
'******************************************************************************************
' 20/08/2007  | Lee Boyton   | 1390. Cater for extended characters.
'******************************************************************************************
'             |              | 
'******************************************************************************************
-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="ISO-8859-1"/>
	<!-- store the Aztec Compressed Output product code in a local variable
	     this is an optional field and if non-blank will result in only a single product line being output -->
	<xsl:variable name="CompressedOutput">
		<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/HeaderExtraData/CompressedAztecOutput"/>
	</xsl:variable>
	<xsl:template match="/">	
		<Order>
			<xsl:attribute name="SiteCode"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/AztecSiteID"/></xsl:attribute>
			<!-- The location of the SiteRef depends on the buyer.
			     H&H have an additional element (HardysSiteID) added by the zonal pre mapper, where as
			     Urbium use the value in the branch reference (proxy relationship) -->
			<xsl:attribute name="SiteRef">
				<xsl:choose>
					<xsl:when test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/HardysSiteID != ''">
						<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/HardysSiteID"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="Supplier"><xsl:value-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
			<xsl:attribute name="OrderNo"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
			<xsl:attribute name="OrderDate"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:attribute>
			<xsl:attribute name="DeliveryDate"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/></xsl:attribute>
			<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart">
				<xsl:attribute name="DeliveryTime"><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliverySlot/SlotStart"/></xsl:attribute>
			</xsl:if>
			<!-- If the compressed Aztec output product code exists then there will at most be a single line,
			     otherwise it will be the count of the non-rejected lines -->
			<xsl:attribute name="Lines">
				<xsl:choose>
					<xsl:when test="$CompressedOutput != ''">
						<!-- check at least 1 non-rejected line exists
						     (and would have been written out if the output was not compressed) -->
						<xsl:choose>
							<xsl:when test="count(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected']) > 0">
								<xsl:value-of select="1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="0"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected'])"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT">
				<xsl:attribute name="Value"><xsl:value-of select="sum(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT)"/></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$CompressedOutput != ''">
					<xsl:if test="count(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected']) > 0">
						<Line>
							<xsl:attribute name="LineNo">1</xsl:attribute>
							<xsl:attribute name="ImpExpRef"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
							<xsl:attribute name="Description"><xsl:value-of select="$CompressedOutput"/></xsl:attribute>
							<xsl:attribute name="Quantity">1</xsl:attribute>
							<xsl:if test="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT">
								<xsl:attribute name="UnitCost"><xsl:value-of select="sum(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine/LineValueExclVAT)"/></xsl:attribute>
							</xsl:if>
						</Line>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus != 'Rejected']">
						<Line>
							<xsl:attribute name="LineNo"><xsl:value-of select="LineNumber"/></xsl:attribute>
							<xsl:attribute name="ImpExpRef"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
							<xsl:if test="ProductDescription">
								<xsl:attribute name="Description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="PackSize">
								<xsl:attribute name="PackSize"><xsl:value-of select="PackSize"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="Quantity"><xsl:value-of select="ConfirmedQuantity"/></xsl:attribute>
							<xsl:if test="UnitValueExclVAT">
								<xsl:attribute name="UnitCost"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>
							</xsl:if>
						</Line>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</Order>
	</xsl:template>
</xsl:stylesheet>
