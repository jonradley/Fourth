<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for goods received notes from Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge			| FB1400 Created module (based on tsMappingHospitalityTCGOrderIn.xsl)
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template 	match="/Delivery">
	
		<BatchRoot>
	
			<GoodsReceivedNote>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient><xsl:value-of select="@SupplierCode"/></SendersCodeForRecipient>
					
					<SendersBranchReference>						
						<xsl:choose>
							<xsl:when test="substring-before(substring-after(@LocationCode,'/'),'/') != ''">
								<xsl:value-of select="substring-before(substring-after(@LocationCode,'/'),'/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@LocationCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<GoodsReceivedNoteHeader>
					
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference><xsl:value-of select="@OrderID"/></PurchaseOrderReference>
						<xsl:variable name="sDateTimeSeperator" select="substring(@OrderDateTime,11,1)"/>
						<PurchaseOrderDate><xsl:value-of select="substring-before(@OrderDateTime,$sDateTimeSeperator)"/></PurchaseOrderDate>
						<PurchaseOrderTime><xsl:value-of select="substring-after(@OrderDateTime,$sDateTimeSeperator)"/></PurchaseOrderTime>
	
					</PurchaseOrderReferences>
					
					
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="@UserReference"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="@DateEntered"/></DeliveryNoteDate>
					</DeliveryNoteReferences>					
					
					<GoodsReceivedNoteReferences>
						<GoodsReceivedNoteReference><xsl:value-of select="@UserReference"/></GoodsReceivedNoteReference>
						<GoodsReceivedNoteDate><xsl:value-of select="@DateEntered"/></GoodsReceivedNoteDate>
					</GoodsReceivedNoteReferences>
					
					<DeliveredDeliveryDetails>
						<DeliveryDate><xsl:value-of select="@DeliveryDateTime"/></DeliveryDate>
					</DeliveredDeliveryDetails>
					
					<ReceivedDeliveryDetails>
						<DeliveryDate><xsl:value-of select="@DeliveryDateTime"/></DeliveryDate>
					</ReceivedDeliveryDetails>
	
				</GoodsReceivedNoteHeader>
				
				
				<GoodsReceivedNoteDetail>
				
					<xsl:for-each select="/OrderHeader/OrderItem">
				
						<GoodsReceivedNoteLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="@SupplierProductCode"/></SuppliersProductCode>
							</ProductID>
							
							<AcceptedQuantity>
								<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>									
								<xsl:value-of select="@Quantity"/>								
							</AcceptedQuantity>
													
							<PackSize>Pack</PackSize>
													
							<UnitValueExclVAT><xsl:value-of select="@MajorUnitPrice"/></UnitValueExclVAT>
							
						</GoodsReceivedNoteLine>
						
					</xsl:for-each>
						
				</GoodsReceivedNoteDetail>
				
				
			</GoodsReceivedNote>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
