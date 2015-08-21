<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner			|	details
************************************************************************
16/08/2012	| KOshaughnessy		| Created FB5609
************************************************************************
06/09/2012	|KOshaughnessy		| Bugfix FB 5678 to remove the need for supplier address. this will be picked up in the infiller
************************************************************************
21/08/2015	|J Miguel			| FB 102462 - Support for Back ordering
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output  method="xml" indent="yes"/>
<xsl:template match="/">
<BatchRoot>
	<xsl:attribute name="TypePrefix">DNB</xsl:attribute>
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<xsl:for-each select="/OrderResponse">
						<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
						<DeliveryNote>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							
							<DeliveryNoteHeader>
								<DocumentStatus>Original</DocumentStatus>
								
								<Buyer>
									<BuyersLocationID>
										<SuppliersCode>
											<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
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
									<xsl:if test="OrderResponseReferences/CrossReference">
										<OriginalPurchaseOrderReference>
											<xsl:value-of select="OrderResponseReferences/CrossReference"/>
										</OriginalPurchaseOrderReference>
									</xsl:if>									
								</PurchaseOrderReferences>
								
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="OrderResponseReferences/OrderResponseNumber"/>
									</PurchaseOrderConfirmationReference>
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="substring-before(OrderResponseDate, 'T')"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
													
								<DeliveryNoteReferences>
									<DeliveryNoteReference>
										<xsl:value-of select="Delivery/DeliveryInformation"/>
									</DeliveryNoteReference>
									<DeliveryNoteDate>
										<xsl:value-of select="Delivery/PreferredDate"/>
									</DeliveryNoteDate>
									<DespatchDate>
										<xsl:value-of select="Delivery/PreferredDate"/>
									</DespatchDate>
								</DeliveryNoteReferences>
	
							</DeliveryNoteHeader>
							
							<DeliveryNoteDetail>
								<xsl:for-each select="OrderResponseLine">
									<DeliveryNoteLine>	
																
										<LineNumber>
											<xsl:value-of select="LineNumber"/>
										</LineNumber>
										
										<ProductID>
											<SuppliersProductCode>
												<xsl:value-of select="Product/SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										
										<ProductDescription>
											<xsl:value-of select="Product/Description"/>
										</ProductDescription>
										
										<OrderedQuantity>
											<xsl:value-of select="format-number(OriginalQuantity/Amount,'0.00')"/>
										</OrderedQuantity>
										
										<DespatchedQuantity>
											<xsl:value-of select="format-number(Quantity/Amount,'0.00')"/>
										</DespatchedQuantity>
										
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(Price/UnitPrice,'0.00')"/>
										</UnitValueExclVAT>
										
									</DeliveryNoteLine>
								</xsl:for-each>
									
							</DeliveryNoteDetail>
								
							
							<DeliveryNoteTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(OrderResponseLine)"/>
								</NumberOfLines>
							</DeliveryNoteTrailer>
							
						</DeliveryNote>
						
					</xsl:for-each>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
	</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
