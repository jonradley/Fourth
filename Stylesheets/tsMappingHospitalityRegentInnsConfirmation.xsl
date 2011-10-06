<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="PurchaseOrderConfirmation">

		<iPOS>
			<xsl:attribute name="version">1.0</xsl:attribute>
			<Orders>
				<Order>
					<Company>REG</Company>
					<OrderNo>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</OrderNo>
					<OrderedBy>IPOS</OrderedBy>
					<DateOrdered>
						<xsl:value-of select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
					</DateOrdered>
					<OrderDeliveryBy>email</OrderDeliveryBy>
					<Supplier>
						<SuppAcctCode>
							<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
						</SuppAcctCode>
						<!--SuppAddrCode>PAULE</SuppAddrCode-->
					</Supplier>
					<OrderItems>
						<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
						<OrderItem>
							<!--RequisitionRef>
								<Doc>
									<DocNo>124373</DocNo>
									<DocLineNo>1</DocLineNo>
								</Doc>
							</RequisitionRef-->
							<Reference>IPOS</Reference>
							<DeliveryAddressCode>
								<xsl:value-of select="//PurchaseOrderConfirmation/TradeSimpleHeader/RecipientsBranchReference"/>
							</DeliveryAddressCode>
							<DeliveryDate>
								<xsl:value-of select="//PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
							</DeliveryDate>
							<ItemCode>
								<xsl:value-of select="ProductID/BuyersProductCode"/>
							</ItemCode>
							<Description>
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</Description>
							<SuppItemCode>
								<xsl:value-of select="ProductID/SuppliersProductCode"/>
							</SuppItemCode>
							<IsReceiptRequired>True</IsReceiptRequired>
							<GoodsOrService>goods</GoodsOrService>
							<IsConfirmed>
								<xsl:choose>
									<xsl:when test="@LineStatus = 'Accepted'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</IsConfirmed>
							<UnitCost>
								<xsl:value-of select="UnitValueExclVAT"/>
							</UnitCost>
							<Quantity>
								<xsl:value-of select="ConfirmedQuantity"/>
							</Quantity>
							<Value>
								<xsl:value-of select="LineValueExclVAT"/>
							</Value>
							<!--TaxValue>0</TaxValue-->
							<ItemUOM>
								<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
							</ItemUOM>
							<!--PurchAcctCode>0220</PurchAcctCode-->
							<!--TaxCode>Z</TaxCode-->
							<Analysis>
								<Category>T1</Category>
								<Code>
									<xsl:value-of select="//TradeSimpleHeader/RecipientsBranchReference"/>
								</Code>
							</Analysis>
							<!--Analysis>
								<Category>T2</Category>
								<Code>zFOOD</Code>
							</Analysis-->
							<!--Analysis>
								<Category>T3</Category>
								<Code>-</Code>
							</Analysis-->
							<!--Analysis>
								<Category>T4</Category>
								<Code>Z</Code>
							</Analysis-->
							<!--Analysis>
								<Category>T6</Category>
								<Code>-</Code>
							</Analysis-->
							<!--Analysis>
								<Category>T8</Category>
								<Code>0NA</Code>
							</Analysis-->
						</OrderItem>
						</xsl:for-each>
					</OrderItems>
				</Order>
			</Orders>
		</iPOS>
	</xsl:template>
</xsl:stylesheet>
