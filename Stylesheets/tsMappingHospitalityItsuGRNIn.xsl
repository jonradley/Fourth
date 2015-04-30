<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
itsu mapper for goods received notes from Caterwide 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge		| FB1400 Created module (based on tsMappingHospitalityTCGOrderIn.xsl)
==========================================================================================
 21/10/2008	| R Cambridge     	| 2524 temporary fix to ignore split pack info for some suppliers
==========================================================================================
 13/05/2009	| Rave Tech 		| 2878 Removed MaxSplits logic to implement CaseSize logic in processor.
==========================================================================================
 16/03/2011	| Andrew Barber	| 4243 Copied TRG Caterwide map for itsu GRN's.
 ==========================================================================================
 27/03/2012	| Andrew Barber	| 5361 Added logic to use DN ref as order ref where OrderID = 0.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template 	match="/Delivery">
	
		<BatchRoot>
	
			<GoodsReceivedNote>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient><xsl:value-of select="@SupplierCode"/></SendersCodeForRecipient>
					
					<SendersBranchReference>
						<xsl:choose>
							<xsl:when test="substring-before(substring-after(@LocationCode,'ITSU'),'/') != ''">
								<xsl:value-of select="substring-before(substring-after(@LocationCode,'ITSU'),'/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@LocationCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<GoodsReceivedNoteHeader>
					
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference>
							<xsl:choose>
								<xsl:when test="@OrderID = 0">
									<xsl:value-of select="@SupplierReference"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@OrderID"/>
								</xsl:otherwise>
							</xsl:choose>
						</PurchaseOrderReference>
						
						<PurchaseOrderDate>
							<xsl:choose>
								<xsl:when test="@OrderID = 0">
									<xsl:value-of select="substring-before(@DateEntered,'T')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before(@OrderDateTime,'T')"/>
								</xsl:otherwise>
							</xsl:choose>
						</PurchaseOrderDate>
							
					</PurchaseOrderReferences>
					
					
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="@SupplierReference"/></DeliveryNoteReference>
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
								<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
								<xsl:value-of select="@Quantity"/>
							</AcceptedQuantity>
													
							<!--<PackSize>Pack</PackSize>-->
													
							<UnitValueExclVAT>
								<xsl:value-of select="@MajorUnitPrice"/>
							</UnitValueExclVAT>
							
						</GoodsReceivedNoteLine>
						
					</xsl:for-each>
						
				</GoodsReceivedNoteDetail>
				
				
			</GoodsReceivedNote>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
