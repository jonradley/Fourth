<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">

	<xsl:template match="Document">

	<xsl:variable name="sPODate" select="concat('20', substring(ORD/L2[2]/L3/L4[3], 1, 2), '-', substring(ORD/L2[2]/L3/L4[3], 3, 2), '-', substring(ORD/L2[2]/L3/L4[3], 5, 2))"/>
	<xsl:variable name="sReqDate" select="concat('20', substring(DIN/L2[2]/L3[2]/L4[1], 1, 2), '-', substring(DIN/L2[2]/L3[2]/L4[1], 3, 2), '-',  substring(DIN/L2[2]/L3[2]/L4[1], 5, 2))"/>


		<BatchRoot>
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>
							<xsl:value-of select="SDT/L2/L3[1]/L4[2]"/>
						</SendersCodeForRecipient>
					</TradeSimpleHeader>
					<PurchaseOrderHeader>
						<ShipTo>
							<ShipToAddress>
								<xsl:variable name="addlines">
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[1]/L4[2]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[1]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[2]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[3]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[5]"/>
									</addline>
								</xsl:variable>
								
								<AddressLine1>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][1]"/>
								</AddressLine1>
								<AddressLine2>.</AddressLine2>
								<AddressLine3>Manchester</AddressLine3>
								<AddressLine4>.</AddressLine4>
								<PostCode>M60 4ES</PostCode>
							</ShipToAddress>
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="ORD/L2[2]/L3/L4[1]"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="$sPODate"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<OrderedDeliveryDetails>
							<DeliveryDate>
								<xsl:value-of select="$sReqDate"/>
							</DeliveryDate>
						</OrderedDeliveryDetails>
					</PurchaseOrderHeader>
					<PurchaseOrderDetail>
						<xsl:for-each select="OLD">
							<PurchaseOrderLine>
								<LineNumber>
									<xsl:value-of select="L2[2]/L3[1]/L4[1]"/>
								</LineNumber>
								<ProductID>
									<SuppliersProductCode>
										<xsl:choose>
											<xsl:when test="L2[2]/L3[2]/L4[3] != ''">
												<xsl:value-of select="L2[2]/L3[2]/L4[3]"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="L2[2]/L3[2]/L4[1]"/>
											</xsl:otherwise>
										</xsl:choose>
									</SuppliersProductCode>
									<BuyersProductCode>
										<xsl:value-of select="L2[2]/L3[4]/L4[2]"/>
									</BuyersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="L2[2]/L3[10]/L4[1]"/>
								</ProductDescription>
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure">
										<xsl:choose>
											<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">EA</xsl:when>
											<xsl:otherwise>CS</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="L2[2]/L3[6]/L4[1]"/>
								</OrderedQuantity>
								<PackSize>
									<xsl:choose>
										<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">Each</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('Case',L2[2]/L3[5]/L4[1])"/>
										</xsl:otherwise>
									</xsl:choose>
								</PackSize>
								<UnitValueExclVAT>0.00</UnitValueExclVAT>
								<LineValueExclVAT>0.00</LineValueExclVAT>
							</PurchaseOrderLine>
						</xsl:for-each>
					</PurchaseOrderDetail>
					<PurchaseOrderTrailer>
						<NumberOfLines>
							<xsl:value-of select="count(OLD)"/>
						</NumberOfLines>
						<TotalExclVAT>0.00</TotalExclVAT>
					</PurchaseOrderTrailer>
				</PurchaseOrder>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
