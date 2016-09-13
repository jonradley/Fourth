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

	<xsl:param name="sSendersBranchReference" select="'0'"/>
	<xsl:param name="sBuyersCodeForSupplier" select="'0'"/>
	<xsl:param name="sPOReference" select="'0'"/>
	<xsl:param name="sPODate" select="'0'"/>
	<xsl:param name="sGRNReference" select="'0'"/>
	<xsl:param name="sGRNDate" select="'0'"/>
	
	<xsl:template match="/PendingDeliverySubmitted">
	
		<BatchRoot>
	
			<GoodsReceivedNote>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient><xsl:value-of select="$sBuyersCodeForSupplier"/></SendersCodeForRecipient>
					
					<SendersBranchReference><xsl:value-of select="$sSendersBranchReference"/></SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<GoodsReceivedNoteHeader>
				
					<ShipTo>
						<ShipToName><xsl:value-of select="Lines/Outlets/OutletName"/></ShipToName>
					</ShipTo>					
				
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference><xsl:value-of select="$sPOReference"/></PurchaseOrderReference>
						<PurchaseOrderDate><xsl:value-of select="$sPODate"/></PurchaseOrderDate>
							
					</PurchaseOrderReferences>
					
					
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="$sPOReference"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="$sPODate"/></DeliveryNoteDate>
					</DeliveryNoteReferences>					
					
					<GoodsReceivedNoteReferences>
						<GoodsReceivedNoteReference><xsl:value-of select="$sGRNReference"/></GoodsReceivedNoteReference>
						<GoodsReceivedNoteDate><xsl:value-of select="$sGRNDate"/></GoodsReceivedNoteDate>
					</GoodsReceivedNoteReferences>
					
					<DeliveredDeliveryDetails>
						<DeliveryDate><xsl:value-of select="PlannedDeliveryDate"/></DeliveryDate>
					</DeliveredDeliveryDetails>
					
					<ReceivedDeliveryDetails>
						<DeliveryDate><xsl:value-of select="ActualDeliveryDate"/></DeliveryDate>
					</ReceivedDeliveryDetails>
	
				</GoodsReceivedNoteHeader>
				
				
				<GoodsReceivedNoteDetail>
				
					<xsl:for-each select="Lines">
				
						<GoodsReceivedNoteLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="ProductNumber"/></SuppliersProductCode>
							</ProductID>
							
							<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>						
							
							<OrderedQuantity>
								<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderUnit"/></xsl:attribute>
								<xsl:value-of select="OrderedQuantity"/>							
							</OrderedQuantity>
							
							<AcceptedQuantity>
								<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="ReceivedUnit"/></xsl:attribute>
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
