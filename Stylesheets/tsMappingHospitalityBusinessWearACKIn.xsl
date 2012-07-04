<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="PurchaseOrderAcknowledgement">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
						<PurchaseOrderAcknowledgement>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="SendersCodeforUnit"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderAcknowledgementHeader>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="PurchaseOrderReference"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="PurchaseOrderDate"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
							</PurchaseOrderAcknowledgementHeader>
						</PurchaseOrderAcknowledgement>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
