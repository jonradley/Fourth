<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************************************************************************************
Date		|	owner	|	details
************************************************************************************************************************************************
10/09/2013	| M Dimant	| 7152: Created. 
************************************************************************************************************************************************
07/11/2013	| M Dimant	| 7362: Removed Line Total so we derive it ourselves.	
************************************************************************************************************************************************
23/03/2015	|J Miguel	| FB 10200 - Support for Back ordering
**********************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:egs="urn:eGS:marketplace:eBIS:Extension:1.0">

	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/OrderResponse">
	<BatchRoot>
	<xsl:attribute name="TypePrefix">ORC</xsl:attribute>
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<xsl:for-each select="/OrderResponse">
						<xsl:attribute name="DocumentTypeNo">3</xsl:attribute>
						<PurchaseOrderConfirmation>						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForLocation"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>							
							<PurchaseOrderConfirmationHeader>							
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
										<xsl:value-of select="substring-before(OrderResponseDate,'T')"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>								
							</PurchaseOrderConfirmationHeader>							
							<PurchaseOrderConfirmationDetail>
								<xsl:for-each select="OrderResponseLine">									
									<PurchaseOrderConfirmationLine>
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
											<xsl:value-of select="OriginalQuantity/Amount"/>
										</OrderedQuantity>
										<ConfirmedQuantity>
											<xsl:value-of select="Quantity/Amount"/>
										</ConfirmedQuantity>
										<xsl:if test="Delivery/Quantity/Amount">
											<BackOrderQuantity>
												<xsl:value-of select="Delivery/Quantity/Amount"/>
											</BackOrderQuantity>
										</xsl:if>
										<xsl:if test="Quantity/Packsize != ''">
											<PackSize>
												<xsl:value-of select="Quantity/Packsize"/>
											</PackSize>
										</xsl:if>										
										<xsl:if test="Price/UnitPrice != ''">
											<UnitValueExclVAT>
												<xsl:value-of select="Price/UnitPrice"/>
											</UnitValueExclVAT>
										</xsl:if>
										<xsl:if test="LineTotal">
											<LineValueExclVAT>
												<xsl:value-of select="LineTotal"/>
											</LineValueExclVAT>							
										</xsl:if>
									</PurchaseOrderConfirmationLine>
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>							
							<PurchaseOrderConfirmationTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(OrderResponseLine/LineNumber)"/>
								</NumberOfLines>
								<TotalExclVAT>
									<xsl:value-of select="format-number(sum(OrderResponseLine/LineTotal),'0.00')"/>
								</TotalExclVAT>
							</PurchaseOrderConfirmationTrailer>							
						</PurchaseOrderConfirmation>						
					</xsl:for-each>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
		</BatchRoot>	
	</xsl:template>
</xsl:stylesheet>
