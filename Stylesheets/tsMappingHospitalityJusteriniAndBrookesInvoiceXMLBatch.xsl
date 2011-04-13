<?xml version="1.0" encoding="UTF-8"?>
<!--Sample XML file generated by XML Spy v4.4 U (http://www.xmlspy.com)-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
<xsl:template match="/">
<BatchRoot>
	<Batch>
		<BatchDocuments>
			<BatchDocument>
				<Invoice>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>
							<xsl:value-of select="SalesInvoicePrint/Invoice/CustomerDetails/Customer/@Account"/>
						</SendersCodeForRecipient>
					</TradeSimpleHeader>
					<InvoiceHeader>
						<InvoiceReferences>
							<InvoiceReference>  
								<xsl:value-of select="SalesInvoicePrint/Invoice/@OurReference"/>
							</InvoiceReference>
							<InvoiceDate>
								<xsl:variable name="invdate"><xsl:value-of select="/SalesInvoicePrint/Invoice/Dates/InvoiceDate/@Date"/></xsl:variable>
								<xsl:value-of select="concat(substring($invdate,7,4),'-',substring($invdate,4,2),'-',substring($invdate,1,2))"/>
							</InvoiceDate>
						</InvoiceReferences>
					</InvoiceHeader>
					<InvoiceDetail>
						<xsl:for-each select="SalesInvoicePrint/Despatches/Despatch/SalesOrders/SalesOrder/Items/Item">
						<InvoiceLine>
							<LineNumber><xsl:value-of select="@ItemNumber"/></LineNumber>
							
							<PurchaseOrderReferences>
								<PurchaseOrderReference><xsl:value-of select="//SalesOrderDetails/@CustomerOrderNo"/></PurchaseOrderReference>								
								<PurchaseOrderDate>
									<xsl:variable name="orddate"><xsl:value-of select="//SalesOrderDetails/Dates/Document/@Date"/></xsl:variable>
									<xsl:value-of select="concat(substring($orddate,7,4),'-',substring($orddate,4,2),'-',substring($orddate,1,2))"/>
								</PurchaseOrderDate>								
							</PurchaseOrderReferences>
												
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="Product/@Code"/></SuppliersProductCode>
								
							</ProductID>
							<ProductDescription><xsl:value-of select="Product/@Description1"/></ProductDescription>
							<InvoicedQuantity>	
										<xsl:attribute name="UnitOfMeasure">
											<xsl:choose>
												<xsl:when test="substring(Quantities/PriceQuantity/@Quantity,1,4) = 'CASE'">CS</xsl:when>
												<xsl:otherwise>EA</xsl:otherwise>
											</xsl:choose>										
										</xsl:attribute>
										<xsl:value-of select="Quantities/PriceQuantity/@Quantity"/>								
							</InvoicedQuantity>								
							<UnitValueExclVAT><xsl:value-of select="Prices/NetPrice/@DocumentPrice"/></UnitValueExclVAT>
							<LineValueExclVAT><xsl:value-of select="LineValues/NetLineValue/@DocumentValue"/></LineValueExclVAT>
							<VATCode>
								<xsl:if test="VAT/@Code = 'STD'">
									<xsl:text>S</xsl:text>
								</xsl:if>
							</VATCode>
							<VATRate><xsl:value-of select="VAT/@Rate"/></VATRate>
						</InvoiceLine>
						</xsl:for-each>
					</InvoiceDetail>
					<InvoiceTrailer>
						<xsl:for-each select="SalesInvoicePrint/VATDetails/VAT">
							<VATSubTotals>
								<VATSubTotal>
									<xsl:attribute name="VATCode">
										<xsl:if test="@Code = 'STD'">
											<xsl:text>S</xsl:text>
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="VATRate">
										<xsl:value-of select="//@Rate"/>
									</xsl:attribute>
									<!--NumberOfLinesAtRate><xsl:value-of select="count(//Despatches/Despatch/SalesOrders/SalesOrder/Items/Item[VAT/@Code = 'STD'])"/></NumberOfLinesAtRate>
									<NumberOfItemsAtRate><xsl:value-of select="sum(//Despatches/Despatch/SalesOrders/SalesOrder/Items/Item/Quantities/PriceQuantity/@Quantity)"/></NumberOfItemsAtRate-->
									<DocumentTotalExclVATAtRate><xsl:value-of select="VATPrinciple/@DocumentValue"/></DocumentTotalExclVATAtRate>
									<!--<SettlementTotalExclVATAtRate><xsl:value-of select="//VATPrinciple/@DocumentValue"/></SettlementTotalExclVATAtRate>-->
									<VATAmountAtRate><xsl:value-of select="VATValue/@DocumentValue"/></VATAmountAtRate>
									<DocumentTotalInclVATAtRate>						
											<xsl:value-of select="format-number(VATPrinciple/@DocumentValue + VATValue/@DocumentValue,'#.##')"/>						
									</DocumentTotalInclVATAtRate>
									<!--<SettlementTotalInclVATAtRate/>-->
								</VATSubTotal>
							</VATSubTotals>
						</xsl:for-each>
						<!--
						<DiscountedLinesTotalExclVAT/>
						<DocumentDiscount/>
						<DocumentTotalExclVAT/>
						<SettlementDiscount/>
						<SettlementTotalExclVAT/>
						<VATAmount/>
						<DocumentTotalInclVAT/>
						<SettlementTotalInclVAT/>
						-->
					</InvoiceTrailer>
				</Invoice>
			</BatchDocument>
		</BatchDocuments>
	</Batch>
</BatchRoot>
</xsl:template>	
</xsl:stylesheet>