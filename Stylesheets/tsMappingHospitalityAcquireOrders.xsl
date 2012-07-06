<?xml version="1.0" encoding="UTF-8"?>
<!-- 
'******************************************************************************************
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name            | Description of modification
'******************************************************************************************
' 22/04/2003 | C Scott         | Created
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 18/08/2011 | K Oshaughnessy  | Delivery instructions to be mapped 
'******************************************************************************************
' 2012-06-25 | H Robson        | Strip Carriage Returns out of Delivery Instructions
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="Document">
		<xsl:variable name="sPODate">
			<xsl:value-of select="concat(substring(H/L2[3],1,4),'-',substring(H/L2[3],5,2),'-',substring(H/L2[3],7,2))"/>
		</xsl:variable>
		<xsl:variable name="sReqDate">
			<xsl:value-of select="concat(substring(H/L2[4],1,4),'-',substring(H/L2[4],5,2),'-',substring(H/L2[4],7,2))"/>
		</xsl:variable>
		<BatchRoot>
			<PurchaseOrder>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="H/L2[6]"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<PurchaseOrderHeader>
					<ShipTo>
						<ShipToLocationID>
							<BuyersCode>
								<xsl:value-of select="H/L2[9]"/>
							</BuyersCode>
							<SuppliersCode>
								<xsl:value-of select="H/L2[9]"/>
							</SuppliersCode>
						</ShipToLocationID>
					</ShipTo>
					<PurchaseOrderReferences>
						<PurchaseOrderReference>
							<xsl:value-of select="H/L2[2]"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="$sPODate"/>
						</PurchaseOrderDate>
					</PurchaseOrderReferences>
					<OrderedDeliveryDetails>
						<DeliveryDate>
							<xsl:value-of select="$sReqDate"/>
						</DeliveryDate>
						<!-- 2012-06-25 HR -->
						<SpecialDeliveryInstructions>
							<xsl:value-of select="normalize-space(N/L2[2])"/>
						</SpecialDeliveryInstructions>
					</OrderedDeliveryDetails>
				</PurchaseOrderHeader>
				<PurchaseOrderDetail>
					<xsl:for-each select="L">
						<PurchaseOrderLine>
							<ProductID>
								<SuppliersProductCode>
									<xsl:value-of select="L2[2]"/>
								</SuppliersProductCode>
							</ProductID>
							<ProductDescription>
								<xsl:value-of select="L2[3]"/>
							</ProductDescription>
							<OrderedQuantity>
								<xsl:value-of select="L2[5]"/>
							</OrderedQuantity>
							<UnitValueExclVAT>
								<xsl:value-of select="format-number(L2[4],'0.00')"/>
							</UnitValueExclVAT>
							<LineValueExclVAT>
								<xsl:value-of select="format-number(L2[4],'0.00') * L2[5]"/>
							</LineValueExclVAT>
						</PurchaseOrderLine>
					</xsl:for-each>
				</PurchaseOrderDetail>
			</PurchaseOrder>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
