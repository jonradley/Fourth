<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="OrderAcknowledgement">
		<BatchRoot>
			<PurchaseOrderConfirmation>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="ShipTo/ShipToGLN"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<PurchaseOrderConfirmationHeader>
					<DocumentStatus>
						<xsl:if test="OrderAcknowledgementDetails/DocumentStatus = '9'">
							<xsl:text>Original</xsl:text>
						</xsl:if>
					</DocumentStatus>
					<PurchaseOrderReferences>
						<PurchaseOrderReference>
							<xsl:value-of select="OrderReference/PurchaseOrderNumber"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="substring-before(OrderReference/PurchaseOrderDate,'T')"/>
						</PurchaseOrderDate>
					</PurchaseOrderReferences>
					<PurchaseOrderConfirmationReferences>
						<PurchaseOrderConfirmationReference>
							<xsl:value-of select="OrderAcknowledgementDetails/PurchaseOrderAcknowledgementNumber"/>
						</PurchaseOrderConfirmationReference>
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="substring-before(OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate,'T')"/>
						</PurchaseOrderConfirmationDate>
					</PurchaseOrderConfirmationReferences>
					<ConfirmedDeliveryDetails>
						<DeliveryDate>
							<xsl:value-of select="substring-before(MovementDateTime,'T')"/>
						</DeliveryDate>
						<DeliverySlot>
							<SlotStart>
								<xsl:value-of select="substring-before(substring-after(SlotTime/SlotStartTime,'T'),'T')"/>
							</SlotStart>
							<SlotEnd>
								<xsl:value-of select="substring-before(substring-after(SlotTime/SlotEndTime,'T'),'T')"/>
							</SlotEnd>
						</DeliverySlot>
					</ConfirmedDeliveryDetails>
				</PurchaseOrderConfirmationHeader>
			</PurchaseOrderConfirmation>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
