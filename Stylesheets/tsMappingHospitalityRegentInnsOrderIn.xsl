<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
		?		|			?			| Created Module
**********************************************************************
R Cambridge	| 2010-11-10		| 4019 trasnslate "EACH" UoMs into EA
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="iPOS/Orders">
		<BatchRoot>
			<xsl:for-each select="Order">
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>
							<xsl:value-of select="Supplier/SuppAcctCode"/>
						</SendersCodeForRecipient>
						<SendersBranchReference>
							<xsl:value-of select="OrderItems/OrderItem[1]/Analysis[./Category = 'T1']/Code"/>
						</SendersBranchReference>
					</TradeSimpleHeader>
					<PurchaseOrderHeader>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="OrderNo"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="DateOrdered"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<OrderedDeliveryDetails>
							<DeliveryDate>
								<xsl:value-of select="OrderItems/OrderItem[1]/DeliveryDate"/>
							</DeliveryDate>
						</OrderedDeliveryDetails>
					</PurchaseOrderHeader>
					<PurchaseOrderDetail>
						<xsl:for-each select="OrderItems/OrderItem">
							<PurchaseOrderLine>
								<LineNumber>
									<xsl:value-of select="RequisitionRef/Doc/DocLineNo"/>
								</LineNumber>
								<ProductID>
									<SuppliersProductCode>
										<xsl:value-of select="SuppItemCode"/>
									</SuppliersProductCode>
									<BuyersProductCode>
										<xsl:value-of select="ItemCode"/>
									</BuyersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="Description"/>
								</ProductDescription>
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure">
										<xsl:choose>
											<xsl:when test="ItemUOM = ''">EA</xsl:when>
											<xsl:when test="ItemUOM = 'EACH'">EA</xsl:when>
											<xsl:when test="ItemUOM = 'PACK'">CS</xsl:when>
											<xsl:when test="ItemUOM = 'CASE'">CS</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="ItemUOM"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="Quantity"/>
								</OrderedQuantity>
								<UnitValueExclVAT>
									<xsl:value-of select="format-number(UnitCost,'0.00')"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="format-number(Value - TaxValue,'0.00')"/>
								</LineValueExclVAT>
							</PurchaseOrderLine>
						</xsl:for-each>
					</PurchaseOrderDetail>
					<PurchaseOrderTrailer>
						<NumberOfLines>
							<xsl:value-of select="count(OrderItems/OrderItem)"/>
						</NumberOfLines>
						<TotalExclVAT>
							<xsl:value-of select="format-number(sum(OrderItems/OrderItem/Value) - sum(OrderItems/OrderItem/TaxValue),'0.00')"/>
						</TotalExclVAT>
					</PurchaseOrderTrailer>
				</PurchaseOrder>
			</xsl:for-each>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
