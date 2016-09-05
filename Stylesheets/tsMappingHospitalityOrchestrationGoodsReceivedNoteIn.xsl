<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
	Converts MGR PendingDeliverySubmitted XML into initial version of TS GRN internal XML

==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 2016-09-02	| R Cambridge		| US13171 FB11284 Created
==========================================================================================
           	|            		| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/*">
	
		<BatchRoot>
	
			<GoodsReceivedNote>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient><xsl:value-of select="'####'"/></SendersCodeForRecipient>
					
					<SendersBranchReference><xsl:value-of select="LocationId"/></SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<GoodsReceivedNoteHeader>
				
					<ShipTo>
						<ShipToName><xsl:value-of select="Lines/*/Outlets/OutletName"/></ShipToName>
					</ShipTo>					
				
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference><xsl:value-of select="PendingDeliveryId"/></PurchaseOrderReference>
						<PurchaseOrderDate><xsl:value-of select="'##??##'"/></PurchaseOrderDate>
							
					</PurchaseOrderReferences>
					
					
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="'##missing##'"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="'##system date??##'"/></DeliveryNoteDate>
					</DeliveryNoteReferences>					
					
					<GoodsReceivedNoteReferences>
						<GoodsReceivedNoteReference><xsl:value-of select="'##missing##'"/></GoodsReceivedNoteReference>
						<GoodsReceivedNoteDate><xsl:value-of select="'##system date??##'"/></GoodsReceivedNoteDate>
					</GoodsReceivedNoteReferences>
					
					<DeliveredDeliveryDetails>
						<DeliveryDate><xsl:value-of select="'ActualDeliveryDate##ticks_to_date'"/></DeliveryDate>
					</DeliveredDeliveryDetails>
					
					<ReceivedDeliveryDetails>
						<DeliveryDate><xsl:value-of select="'ActualDeliveryDate##ticks_to_date'"/></DeliveryDate>
					</ReceivedDeliveryDetails>
	
				</GoodsReceivedNoteHeader>
				
				
				<GoodsReceivedNoteDetail>
				
					<xsl:for-each select="Lines/*">
				
						<GoodsReceivedNoteLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="ProductNumber"/></SuppliersProductCode>
							</ProductID>
							
							<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>						
							
							<OrderedQuantity>
								<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="'OrderUnit##translation'"/></xsl:attribute>
								<xsl:value-of select="OrderedQuantity"/>							
							</OrderedQuantity>
							
							<AcceptedQuantity>
								<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="'ReceivedUnit##translation'"/></xsl:attribute>
								<xsl:value-of select="ReceivedQuantity"/>
							</AcceptedQuantity>
													
							<PackSize>Pack</PackSize>
													
							<UnitValueExclVAT>
								<xsl:value-of select="format-number(ReceivedUnitPrice, '0.##')"/>
							</UnitValueExclVAT>
							
						</GoodsReceivedNoteLine>
						
					</xsl:for-each>
						
				</GoodsReceivedNoteDetail>
				
				
				<GoodsReceivedNoteTrailer>
					<TotalExclVAT><xsl:value-of select="Cost"/></TotalExclVAT>
				</GoodsReceivedNoteTrailer>				
				
			</GoodsReceivedNote>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
