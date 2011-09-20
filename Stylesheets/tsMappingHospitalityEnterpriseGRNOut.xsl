<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
' Mapper for Enterprise outbound Goods Received Note. 
'
' 
' 
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name    		| Description of modification
'******************************************************************************************
' 02/08/2010 | Steve Hewitt | 3784.Creatd for Enterprise. No nice copy templates used as they want special actions on optional nodes
'******************************************************************************************

'******************************************************************************************

'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>

	<xsl:template match="GoodsReceivedNote">
		<GoodsReceivedNote>	
			<GoodsReceivedNoteHeader>
				<xsl:copy-of select="GoodsReceivedNoteHeader/DocumentStatus"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/Buyer"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/Supplier"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/ShipTo"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/PurchaseOrderConfirmationReferences"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/DeliveryNoteReferences"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences"/>	
				<xsl:copy-of select="GoodsReceivedNoteHeader/InvoiceDates"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/DeliveredDeliveryDetails"/>
				<xsl:copy-of select="GoodsReceivedNoteHeader/ReceivedDeliveryDetails"/>			
				<xsl:copy-of select="GoodsReceivedNoteHeader/SequenceNumber"/>
			</GoodsReceivedNoteHeader>
			
			<GoodsReceivedNoteDetail>
				<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
					<GoodsReceivedNoteLine>
						<xsl:attribute name="LineStatus">
							<xsl:value-of select="@LineStatus"/>
						</xsl:attribute>
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="ProductID"/>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:copy-of select="OrderedQuantity "/>
						<xsl:copy-of select="ConfirmedQuantity "/>
						<xsl:copy-of select="DeliveredQuantity "/>
						<xsl:copy-of select="AcceptedQuantity "/>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>	
						<LineDiscountRate>
							<xsl:choose>
								<xsl:when test="./LineDiscountRate"><xsl:value-of select="LineDiscountRate"/></xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</LineDiscountRate>
						<LineDiscountValue>
							<xsl:choose>
								<xsl:when test="./LineDiscountValue"><xsl:value-of select="LineDiscountValue"/></xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>
						</LineDiscountValue>				
						<xsl:copy-of select="SSCC"/>
						<xsl:copy-of select="Narrative "/>
						<xsl:copy-of select="Breakages"/>
						<xsl:copy-of select="ReturnType"/>
					</GoodsReceivedNoteLine>
				</xsl:for-each>			
			</GoodsReceivedNoteDetail>
			
			<GoodsReceivedNoteTrailer>
				<xsl:copy-of select="GoodsReceivedNoteTrailer/NumberOfLines"/>
				<xsl:copy-of select="GoodsReceivedNoteTrailer/DocumentDiscountRate"/>
				<xsl:copy-of select="GoodsReceivedNoteTrailer/DiscountedLinesTotalExclVAT"/>
				<xsl:copy-of select="GoodsReceivedNoteTrailer/DocumentDiscount"/>
				<xsl:copy-of select="GoodsReceivedNoteTrailer/TotalExclVAT"/>		
			</GoodsReceivedNoteTrailer>
		</GoodsReceivedNote>
	</xsl:template>
</xsl:stylesheet>
