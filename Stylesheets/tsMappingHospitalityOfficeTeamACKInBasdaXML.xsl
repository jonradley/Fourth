<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
16/08/2012| KOshaughnessy	| Created FB5609
************************************************************************
06/09/2012|KOshaughnessy	| 	Bugfix FB 5678
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">

	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/OrderResponse">
	<BatchRoot>
	<xsl:attribute name="TypePrefix">ACB</xsl:attribute>
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<xsl:for-each select="/OrderResponse">
						<xsl:attribute name="DocumentTypeNo">84</xsl:attribute>
						<PurchaseOrderAcknowledgement>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							
							<PurchaseOrderAcknowledgementHeader>
							
								<DocumentStatus>Original</DocumentStatus>
								
								<Buyer>
									<BuyersLocationID>
										<SuppliersCode>
											<xsl:value-of select="//Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
										</SuppliersCode>
									</BuyersLocationID>
								</Buyer>
								
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="OrderResponseReferences/BuyersOrderNumber"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="OriginalOrderDate"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								
								<PurchaseOrderAcknowledgementReferences>
									<PurchaseOrderAcknowledgementReference>
										<xsl:value-of select="OrderResponseReferences/SuppliersOrderReference"/>
									</PurchaseOrderAcknowledgementReference>
									<PurchaseOrderAcknowledgementDate>
										<xsl:value-of select="substring-before(OrderResponseDate,'T')"/>
									</PurchaseOrderAcknowledgementDate>
								</PurchaseOrderAcknowledgementReferences>
								
							</PurchaseOrderAcknowledgementHeader>
							
							<PurchaseOrderAcknowledgementTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(OrderResponseLine/LineNumber)"/>
								</NumberOfLines>
								<TotalExclVAT>
									<xsl:value-of select="format-number(sum(OrderResponseLine/LineTotal),'0.00')"/>
								</TotalExclVAT>
							</PurchaseOrderAcknowledgementTrailer>
							
						</PurchaseOrderAcknowledgement>
						
					</xsl:for-each>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
		</BatchRoot>	
	</xsl:template>
</xsl:stylesheet>
