<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="CONFIRMATIONS/ORDER_IMPORT_CONFIRMATION/COMPANY_CODE"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<BatchDocuments>
					<BatchDocument>
						<PurchaseOrderAcknowledgement>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="CONFIRMATIONS/ORDER_IMPORT_CONFIRMATION/COMPANY_CODE"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderAcknowledgementHeader>
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="CONFIRMATIONS/ORDER_IMPORT_CONFIRMATION/PURCHASE_ORDER_NUMBER"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="substring-before(CONFIRMATIONS/ORDER_IMPORT_CONFIRMATION/ORDER_DATE,'T')"/></PurchaseOrderDate>
								</PurchaseOrderReferences>				
							</PurchaseOrderAcknowledgementHeader>
						</PurchaseOrderAcknowledgement>
					</BatchDocument>	
				</BatchDocuments>	
			</Batch>		
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
