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
							<xsl:when test="substring-before(substring-after(@LocationCode,'RG'),'/') != ''">
								<xsl:value-of select="substring-before(substring-after(@LocationCode,'RG'),'/')"/>
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
						<PurchaseOrderDate><xsl:value-of select="substring-before(@OrderDateTime,'T')"/></PurchaseOrderDate>
							
					</PurchaseOrderReferences>
					
					
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="@UserReference"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="substring-before(@DateEntered,'T')"/></DeliveryNoteDate>
					</DeliveryNoteReferences>					
					
					<GoodsReceivedNoteReferences>
						<GoodsReceivedNoteReference><xsl:value-of select="@UserReference"/></GoodsReceivedNoteReference>
						<GoodsReceivedNoteDate><xsl:value-of select="substring-before(@DateEntered,'T')"/></GoodsReceivedNoteDate>
					</GoodsReceivedNoteReferences>
					
					<DeliveredDeliveryDetails>
						<DeliveryDate><xsl:value-of select="substring-before(@DeliveryDateTime,'T')"/></DeliveryDate>
					</DeliveredDeliveryDetails>
					
					<ReceivedDeliveryDetails>
						<DeliveryDate><xsl:value-of select="substring-before(@DeliveryDateTime,'T')"/></DeliveryDate>
					</ReceivedDeliveryDetails>
	
				</GoodsReceivedNoteHeader>
				
				
				<GoodsReceivedNoteDetail>
				
					<xsl:for-each select="DeliveryItem">
				
						<GoodsReceivedNoteLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="@SupplierProductCode"/></SuppliersProductCode>
							</ProductID>
							
							<AcceptedQuantity>
								<xsl:choose>
									<xsl:when test="@MaxSplits = '1'">
										<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
										<xsl:value-of select="@Quantity"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
										<xsl:value-of select="format-number(number(@Quantity) * number(@MaxSplits),'0.0000')"/>
									</xsl:otherwise>
								</xsl:choose>							
							</AcceptedQuantity>
													
							<PackSize>Pack</PackSize>
													
							<UnitValueExclVAT>
								<xsl:choose>
									<xsl:when test="@MaxSplits = '1'">
										<xsl:value-of select="@MajorUnitPrice"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number(number(@MajorUnitPrice) div number(@MaxSplits),'0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</UnitValueExclVAT>
							
						</GoodsReceivedNoteLine>
						
					</xsl:for-each>
						
				</GoodsReceivedNoteDetail>
				
				
			</GoodsReceivedNote>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
