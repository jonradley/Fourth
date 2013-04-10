<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="OrderAcknowledgement">
	
		<BatchRoot>
		
			<!-- PurchaseOrderConfirmation -->
			<PurchaseOrderConfirmation>
			
				<!-- TradeSimpleHeader -->
				<TradeSimpleHeader>
				
					<!-- SendersCodeForRecipient -->
					<SendersCodeForRecipient>
						<xsl:value-of select="ShipTo/ShipToGLN"/>
					</SendersCodeForRecipient>
					
				</TradeSimpleHeader>
				
				<!-- PurchaseOrderConfirmationHeader -->
				<PurchaseOrderConfirmationHeader>
				
					<!-- DocumentStatus -->
					<DocumentStatus>
						<xsl:if test="OrderAcknowledgementDetails/DocumentStatus = '9'">
							<xsl:text>Original</xsl:text>
						</xsl:if>
					</DocumentStatus>
					
					<!-- PurchaseOrderReferences -->
					<PurchaseOrderReferences>
					
						<!-- PurchaseOrderReference -->
						<PurchaseOrderReference>
							<xsl:value-of select="OrderReference/PurchaseOrderNumber"/>
						</PurchaseOrderReference>
						
						<!-- PurchaseOrderDate -->
						<PurchaseOrderDate>
							<xsl:value-of select="substring-before(OrderReference/PurchaseOrderDate,'T')"/>
						</PurchaseOrderDate>
						
					</PurchaseOrderReferences>
					
					<!-- PurchaseOrderConfirmationReferences -->
					<PurchaseOrderConfirmationReferences>
					
						<!-- PurchaseOrderConfirmationReference -->
						<PurchaseOrderConfirmationReference>
							<xsl:value-of select="OrderAcknowledgementDetails/PurchaseOrderAcknowledgementNumber"/>
						</PurchaseOrderConfirmationReference>
						
						<!-- PurchaseOrderConfirmationDate -->
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="substring-before(OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate,'T')"/>
						</PurchaseOrderConfirmationDate>
						
					</PurchaseOrderConfirmationReferences>
					
					<!-- ConfirmedDeliveryDetails -->
					<ConfirmedDeliveryDetails>
					
						<!-- DeliveryDate -->
						<DeliveryDate>
							<xsl:value-of select="substring-before(MovementDateTime,'T')"/>
						</DeliveryDate>
						
						<!-- DeliverySlot -->
						<DeliverySlot>
							
							<!-- SlotStart -->
							<SlotStart>
								<xsl:value-of select="substring(substring-before(substring-after(SlotTime/SlotStartTime,'T'),'T'),1,5)"/>
							</SlotStart>
							
							<!-- SlotEnd -->
							<SlotEnd>
								<xsl:value-of select="substring(substring-before(substring-after(SlotTime/SlotEndTime,'T'),'T'),1,5)"/>
							</SlotEnd>
							
						</DeliverySlot>
						
					</ConfirmedDeliveryDetails>
					
				</PurchaseOrderConfirmationHeader>
				
			</PurchaseOrderConfirmation>
			
		</BatchRoot>
		
	</xsl:template>
</xsl:stylesheet>
