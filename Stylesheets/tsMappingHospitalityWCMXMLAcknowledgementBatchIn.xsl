<?xml version="1.0" encoding="UTF-8"?>
<!--****************************************************************
Date			| Created				| Description
*******************************************************************
07/02/2013| K Oshaughnessy	| Created FB 5943
*****************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml"/>
	<xsl:template match="/order_batch_ack">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="passed_orders/order">
						<BatchDocument>
							<PurchaseOrderAcknowledgement>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="buying_unit/account_code"/>
									</SendersCodeForRecipient>
									<SendersBranchReference>
										<xsl:value-of select="/order_batch_ack/header/Buyer/PricingAccount"/>
									</SendersBranchReference>
								</TradeSimpleHeader>
								<PurchaseOrderAcknowledgementHeader>
									<Buyer>
										<BuyersLocationID>
											<SuppliersCode>
												<xsl:value-of select="/order_batch_ack/header/Buyer/PricingAccount"/>
											</SuppliersCode>
										</BuyersLocationID>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<SuppliersCode>
												<xsl:value-of select="buying_unit/account_code"/>
											</SuppliersCode>
										</ShipToLocationID>
										<ShipToName>
											<xsl:value-of select="buying_unit/name"/>
										</ShipToName>
									</ShipTo>
									<PurchaseOrderReferences>
										<PurchaseOrderReference>
											<xsl:value-of select="order_ref"/>
										</PurchaseOrderReference>
									</PurchaseOrderReferences>
									<PurchaseOrderAcknowledgementReferences>
										<PurchaseOrderAcknowledgementReference>
											<xsl:value-of select="order_ref"/>
										</PurchaseOrderAcknowledgementReference>
										<PurchaseOrderAcknowledgementDate>
											<xsl:value-of select="date_created"/>
										</PurchaseOrderAcknowledgementDate>
									</PurchaseOrderAcknowledgementReferences>
									<OrderedDeliveryDetails>
										<DeliveryType>
											<xsl:text>Delivery</xsl:text>
										</DeliveryType>
										<DeliveryDate>
											<xsl:value-of select="delivery_date"/>
										</DeliveryDate>
									</OrderedDeliveryDetails>
								</PurchaseOrderAcknowledgementHeader>
							</PurchaseOrderAcknowledgement>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
