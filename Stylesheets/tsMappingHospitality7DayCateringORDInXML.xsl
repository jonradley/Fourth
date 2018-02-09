<?xml version="1.0" encoding="UTF-8"?>
<!--
***************************************************************************************
Name			| Date 			|	Description
***************************************************************************************
M Dimant		| 25/06/2013	| 6692: Created inbound order mapper.
***************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
<xsl:output method="xml" encoding="utf-8"/>
	<xsl:template match="/FDHOrders">
		<BatchRoot>
				<Batch>
				<TradeSimpleHeader>
					<SendersCodeForRecipient><xsl:value-of select="SupplierCode"/></SendersCodeForRecipient>
				</TradeSimpleHeader>
					<BatchDocuments>
						<BatchDocument>
							<PurchaseOrder>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="SupplierCode"/></SendersCodeForRecipient>				
								</TradeSimpleHeader>
								<PurchaseOrderHeader>		
									<Buyer>
										<BuyersLocationID>
											<BuyersCode><xsl:value-of select="Order/CustomerCode"/></BuyersCode>
										</BuyersLocationID>
									</Buyer>
									<Supplier>
										<SuppliersLocationID>
											<BuyersCode><xsl:value-of select="SupplierCode"/></BuyersCode>
										</SuppliersLocationID>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<BuyersCode><xsl:value-of select="Order/UnitCode"/></BuyersCode>
											<SuppliersCode><xsl:value-of select="Order/SuppliersLocationCode"/></SuppliersCode>
										</ShipToLocationID>					
									</ShipTo>
									<PurchaseOrderReferences>
										<PurchaseOrderReference><xsl:value-of select="Order/CustomersOrderNumber"/></PurchaseOrderReference>
										<xsl:variable name="OrdDate" select="Order/CustomersOrderDate"/>
										<PurchaseOrderDate><xsl:value-of select="concat(substring($OrdDate,1,4),'-',substring($OrdDate,5,2),'-',substring($OrdDate,7,2))"/></PurchaseOrderDate>
									</PurchaseOrderReferences>
									<OrderedDeliveryDetails>
										<DeliveryType>Delivery</DeliveryType>
										<xsl:variable name="DelDate" select="Order/LatestDeliveryDateTime"/>
										<DeliveryDate><xsl:value-of select="concat(substring($DelDate,1,4),'-',substring($DelDate,5,2),'-',substring($DelDate,7,2))"/></DeliveryDate>
									</OrderedDeliveryDetails>
								</PurchaseOrderHeader>
								<PurchaseOrderDetail>
								<xsl:for-each select="Order/LineList/Line">
										<PurchaseOrderLine>					
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="SuppliersProductCode"></xsl:value-of></SuppliersProductCode>
											</ProductID>					
											<OrderedQuantity><xsl:value-of select="QuantityOrdered"/></OrderedQuantity>
										</PurchaseOrderLine>
									</xsl:for-each>
								</PurchaseOrderDetail>
								<PurchaseOrderTrailer>
									<NumberOfLines><xsl:value-of select="count(Order/LineList/Line)"/></NumberOfLines>
								</PurchaseOrderTrailer>
							</PurchaseOrder>
						</BatchDocument>
				</BatchDocuments>
			</Batch>				
		</BatchRoot>					
	</xsl:template>
</xsl:stylesheet>