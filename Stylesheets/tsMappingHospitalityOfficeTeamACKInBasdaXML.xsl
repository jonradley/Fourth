<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
16/08/2012| KOshaughnessy	| Created FB5609
************************************************************************
			|						| 	
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">

	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/OrderResponse">
	<BatchRoot>
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<xsl:for-each select="/OrderResponse">
					
						<PurchaseOrderAcknowledgement>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Delivery/DeliverFrom/DeliverFromReferences/SuppliersCodeForLocation"/>
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
									<BuyersName>
										<xsl:value-of select="Buyer/Party"/>
									</BuyersName>
									<BuyersAddress>
										<AddressLine1>
											<xsl:value-of select="Buyer/Address/AddressLine[1]"/>
										</AddressLine1>
										<AddressLine2>
											<xsl:value-of select="Buyer/Address/AddressLine[2]"/>
										</AddressLine2>
										<AddressLine3>
											<xsl:value-of select="Buyer/Address/AddressLine[3]"/>
										</AddressLine3>
										<AddressLine4>
											<xsl:value-of select="Buyer/Address/AddressLine[4]"/>
										</AddressLine4>
										<PostCode>
											<xsl:value-of select="Buyer/Address/PostCode"/>
										</PostCode>
									</BuyersAddress>
								</Buyer>
								
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="Delivery/DeliverFrom/DeliverFromReferences/SuppliersCodeForLocation"/>
										</SuppliersCode>
									</ShipToLocationID>
									<ShipToName>
										<xsl:value-of select="Delivery/DeliverTo/Party"/>
									</ShipToName>
									<ShipToAddress>
										<AddressLine1>
											<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[1]"/>
										</AddressLine1>
										<AddressLine2>
											<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[2]"/>
										</AddressLine2>
										<AddressLine3>
											<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[3]"/>
										</AddressLine3>
										<AddressLine4>
											<xsl:value-of select="Delivery/DeliverTo/Address/AddressLine[4]"/>
										</AddressLine4>
										<PostCode>
											<xsl:value-of select="Delivery/DeliverTo/Address/PostCode"/>
										</PostCode>
									</ShipToAddress>
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
									<xsl:value-of select="sum(OrderResponseLine/LineTotal)"/>
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
