<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="SalesAcknowledgementOrQuote">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<PurchaseOrderConfirmation>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="/SalesAcknowledgementOrQuote/SalesOrderOrQuote/CustomerDetails/Customer/@Account"/></SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderConfirmationHeader>
								<!--
								<Buyer>
									<BuyersLocationID>
										<GLN/>
									</BuyersLocationID>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN/>
									</SuppliersLocationID>
								</Supplier>
								-->
								<ShipTo>
									<!--
									<ShipToLocationID>
										<GLN/>
									</ShipToLocationID>
									-->
									<ShipToName><xsl:value-of select="SalesOrderOrQuote/CustomerDetails/DeliverTo/@Name"/></ShipToName>
									<!--
									<ShipToAddress>
										<AddressLine1/>
									</ShipToAddress>
									-->
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="SalesOrderOrQuote/@CustomerOrderNo"/></PurchaseOrderReference>
									<!--PurchaseOrderDate/-->
								</PurchaseOrderReferences>
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference><xsl:value-of select="SalesOrderOrQuote/@Number"/></PurchaseOrderConfirmationReference>					
									<!--PurchaseOrderConfirmationDate><xsl:value-of select="SalesOrderOrQuote/Dates/Document/@Date"/></PurchaseOrderConfirmationDate-->
								</PurchaseOrderConfirmationReferences>
								<!--OrderedDeliveryDetails>
									<DeliveryType/>
									<DeliveryDate/>
								</OrderedDeliveryDetails-->
								<ConfirmedDeliveryDetails>
									<DeliveryType>Delivery</DeliveryType>										
									<DeliveryDate>
										<xsl:variable name="orcdate"><xsl:value-of select="/SalesAcknowledgementOrQuote/Items/Item/Dates/Promised/@Date"/></xsl:variable>
										<xsl:variable name="formorcdate"><xsl:value-of select="format-number(translate($orcdate,translate($orcdate,'0123456789',''),''),'00000000')"/></xsl:variable>
										<xsl:value-of select="concat(substring($formorcdate,5,4),'-',substring($formorcdate,3,2),'-',substring($formorcdate,1,2))"/>
									</DeliveryDate>
								</ConfirmedDeliveryDetails>
							</PurchaseOrderConfirmationHeader>
							<PurchaseOrderConfirmationDetail>
							<xsl:for-each select="Items/Item">
								<PurchaseOrderConfirmationLine LineStatus="">
									<LineNumber><xsl:value-of select="@ItemNumber"/></LineNumber>
									<ProductID>
										<SuppliersProductCode><xsl:value-of select="Product/@Code"/></SuppliersProductCode>
									</ProductID>
									<ProductDescription><xsl:value-of select="Product/@Description1"/></ProductDescription>
									<OrderedQuantity>	
										<xsl:attribute name="UnitOfMeasure">
											<xsl:choose>
												<xsl:when test="substring(Quantities/OrderQuantity/@UOM,1,4) = 'CASE'">CS</xsl:when>
												<xsl:otherwise>EA</xsl:otherwise>
											</xsl:choose>										
										</xsl:attribute>
										<xsl:value-of select="Quantities/OrderQuantity/@Quantity"/>								
									</OrderedQuantity>									
									<ConfirmedQuantity>	
										<xsl:attribute name="UnitOfMeasure">
											<xsl:choose>
												<xsl:when test="substring(Quantities/PriceQuantity/@UOM,1,4) = 'CASE'">CS</xsl:when>
												<xsl:otherwise>EA</xsl:otherwise>
											</xsl:choose>										
										</xsl:attribute>
										<xsl:value-of select="Quantities/PriceQuantity/@Quantity"/>								
									</ConfirmedQuantity>								
								</PurchaseOrderConfirmationLine>
							</xsl:for-each>
							</PurchaseOrderConfirmationDetail>
							<PurchaseOrderConfirmationTrailer>
								<NumberOfLines><xsl:value-of select="count(Items/Item)"/></NumberOfLines>
								<TotalExclVAT><xsl:value-of select="Items/Item/VAT/VATPrinciple/@DocumentValue"/></TotalExclVAT>
							</PurchaseOrderConfirmationTrailer>
						</PurchaseOrderConfirmation>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>