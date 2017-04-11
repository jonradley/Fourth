<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 	version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns:user="http://mycompany.com/mynamespace"
				xmlns:OP="urn:schemas-bossfed-co-uk:OP-Order-v1">
<xsl:output method="xml"/>
	<xsl:template match="/">	
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="88">
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="/Order/@Supplier"/></SendersCodeForRecipient>
								<SendersBranchReference><xsl:value-of select="/Order/@SiteRef"/></SendersBranchReference>
							</TradeSimpleHeader>
							<PurchaseOrderHeader>
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="/Order/@OrderNo"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="/Order/@OrderDate"/></PurchaseOrderDate>
								</PurchaseOrderReferences>
								<OrderedDeliveryDetails>
									<DeliveryType>Delivery</DeliveryType>
									<DeliveryDate><xsl:value-of select="/Order/@DeliveryDate"/></DeliveryDate>
								</OrderedDeliveryDetails>
							</PurchaseOrderHeader>
							<PurchaseOrderDetail>
								<xsl:for-each select="/Order/Line">
									<PurchaseOrderLine>
										<xsl:if test="@LineNo">
											<LineNumber><xsl:value-of select="@LineNo"/></LineNumber>
										</xsl:if>
										<ProductID>
											<GTIN>00000000000000</GTIN>
											<SuppliersProductCode><xsl:value-of select="@ImpExpRef"/></SuppliersProductCode>
										</ProductID>
										<xsl:if test="@Description">
											<ProductDescription><xsl:value-of select="@Description"/></ProductDescription>
										</xsl:if>
										<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="@Quantity"/></OrderedQuantity>
										<xsl:if test="@PackSize">
											<PackSize><xsl:value-of select="@PackSize"/></PackSize>
										</xsl:if>
										<xsl:if test="@UnitCost">
											<UnitValueExclVAT><xsl:value-of select="@UnitCost"/></UnitValueExclVAT>
										</xsl:if>
										<xsl:if test="@LineValue">
											<LineValueExclVAT><xsl:value-of select="@LineValue"/></LineValueExclVAT>
										</xsl:if>
									</PurchaseOrderLine>
								</xsl:for-each>
							</PurchaseOrderDetail>
							<PurchaseOrderTrailer>
								<NumberOfLines><xsl:value-of select="/Order/@Lines"/></NumberOfLines>
								<xsl:if test="/Order/@Value">
									<TotalExclVAT><xsl:value-of select="/Order/@Value"/></TotalExclVAT>
								</xsl:if>
							</PurchaseOrderTrailer>
						</PurchaseOrder>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
