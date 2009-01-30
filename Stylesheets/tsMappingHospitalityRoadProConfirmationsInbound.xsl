<?xml version="1.0" encoding="UTF-8"?>
<!--
'*************************************************************************************************
' Module History
'*************************************************************************************************
' Date             | Name              | Description of modification
'*************************************************************************************************
' 30/01/2009  | Moty Dimant		| Created. Adapted from the eParts mapper 
'*************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>
	<xsl:template match="/biztalk_1/header"/>
	<xsl:template match="/biztalk_1/body">
	<BatchRoot>
		<Batch>
			<BatchDocuments>
				<BatchDocument>
					<PurchaseOrderAck>
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:value-of select="Order/Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
							</SendersCodeForRecipient>
							<SendersBranchReference>
								<xsl:value-of select="Order/Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
							</SendersBranchReference>
						</TradeSimpleHeader>
						<PurchaseOrderAckHeader>
							<PurchaseOrderReference>
								<xsl:value-of select="//OrderReferences/BuyersOrderNumber"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="substring-before(//OrderDate,'T')"/>
							</PurchaseOrderDate>
							<ConfirmedDeliveryDate>
								<xsl:value-of select="substring-before(//OrderDate,'T')"/>
							</ConfirmedDeliveryDate>
							<!--DeliveryDetail>
							<DeliveryLocationReference/>
							<DeliveryName/>
							<DeliveryAddress>
								<AddressLine1/>
								<AddressLine2/>
								<AddressLine3/>
								<AddressLine4/>
								<AddressLine5/>
								<PostCode/>
							</DeliveryAddress>
						</DeliveryDetail-->
							<Currency>GBP</Currency>
						</PurchaseOrderAckHeader>
						<PurchaseOrderAckDetail>
							<xsl:for-each select="//OrderLine">
								<PurchaseOrderAckLine>
									<!--LineAction/-->
									<!--ReasonForChange/-->
									<SuppliersProductNumber>
										<xsl:value-of select="Product/SuppliersProductCode"/>
									</SuppliersProductNumber>
									<!--SubstitutedProductNumber/-->
									<ProductDescription>
										<xsl:value-of select="Product/Description"/>
									</ProductDescription>
									<!--ManufacturerCode/-->
									<!--SubstitutedManufacturerCode/-->
									<QuantityOnDelivery>
										<xsl:value-of select="Quantity/Amount"/>
									</QuantityOnDelivery>
									<!--QuantityBackOrdered/-->
									<!--ExpectedDeliveryDate/-->
									<UnitPriceExclVat>
										<xsl:value-of select="Price/UnitPrice"/>
									</UnitPriceExclVat>
									<!--SurchargeValueExclVat/-->
									<LineCostExclVat>
										<xsl:value-of select="LineTotal"/>
									</LineCostExclVat>
								</PurchaseOrderAckLine>
							</xsl:for-each>
						</PurchaseOrderAckDetail>
						<PurchaseOrderAckTrailer>
							<NumberOfLines>
								<xsl:value-of select="/OrderLine[last()]/LineNumber"/>
							</NumberOfLines>
							<NumberOfItems>
								<xsl:value-of select="sum(/OrderLine/Quantity/Amount)"/>
							</NumberOfItems>
							<TotalExclVAT>
								<xsl:value-of select="/OrderTotal/GoodsValue"/>
							</TotalExclVAT>
						</PurchaseOrderAckTrailer>
					</PurchaseOrderAck>
				</BatchDocument>
			</BatchDocuments>
		</Batch>
	</BatchRoot>
</xsl:template>
</xsl:stylesheet>
