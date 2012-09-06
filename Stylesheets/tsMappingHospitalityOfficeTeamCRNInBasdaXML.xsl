<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
16/08/2012| KOshaughnessy	| Created FB5609
************************************************************************
			|						| 	
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="UTF-8"/>

<xsl:template match="/InvoiceBatch">
	<BatchRoot>
		<xsl:attribute name="TypePrefix">CRN</xsl:attribute>
		<Batch>
			<BatchDocuments>
			
				<xsl:for-each select="Invoice">
					<BatchDocument>
						<xsl:attribute name="DocumentTypeNo">87</xsl:attribute>
						
						<CreditNote>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							
							<CreditNoteHeader>
								<!--This is always Original-->
								<DocumentStatus>Original</DocumentStatus>
								
								<Buyer>
									<BuyersLocationID>
										<SuppliersCode>
											<xsl:value-of select="Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
										</SuppliersCode>
									</BuyersLocationID>
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="Supplier/SupplierReferences/GLN"/>
										</GLN>
									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
									<SuppliersCode>
										<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
									</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								
								<xsl:if test="InvoiceReferences/ResponseTo">
									<InvoiceReferences>
										<InvoiceReference>
											<xsl:value-of select="InvoiceReferences/ResponseTo"/>
										</InvoiceReference>
										<InvoiceDate>
											<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
										</InvoiceDate>
										<TaxPointDate>
											<xsl:value-of select="substring-before(TaxPointDate,'T')"/>
										</TaxPointDate>
									</InvoiceReferences>
								</xsl:if>
								
								<CreditNoteReferences>
									<CreditNoteReference>
										<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
									</CreditNoteReference>
									<CreditNoteDate>
										<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
									</CreditNoteDate>
									<TaxPointDate>
										<xsl:value-of select="substring-before(TaxPointDate,'T')"/>
									</TaxPointDate>
								</CreditNoteReferences>
								
							</CreditNoteHeader>
							
							<CreditNoteDetail>
							
								<xsl:for-each select="InvoiceLine">
									<CreditNoteLine>
									
										<LineNumber>
											<xsl:value-of select="LineNumber"/>
										</LineNumber>
										
										<PurchaseOrderReferences>
											<PurchaseOrderReference>
												<xsl:value-of select="InvoiceLineReferences/BuyersOrderNumber"/>
											</PurchaseOrderReference>
										</PurchaseOrderReferences>	
																																														<DeliveryNoteReferences>
											<DeliveryNoteReference>
												<xsl:value-of select="../InvoiceReferences/ResponseTo"/>
											</DeliveryNoteReference>
										</DeliveryNoteReferences>
										
										<ProductID>
											<SuppliersProductCode>
												<xsl:value-of select="Product/SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										
										<ProductDescription>
											<xsl:value-of select="Product/Description"/>
										</ProductDescription>
										
										<CreditedQuantity>
											<xsl:value-of select="format-number(Quantity/Amount,'0.00')"/>
										</CreditedQuantity>
										
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(Price/UnitPrice,'0.00')"/>
										</UnitValueExclVAT>
										
										<LineValueExclVAT>
											<xsl:value-of select="format-number(LineTotal,'0.00')"/>
										</LineValueExclVAT>
										
										<VATCode>
											<xsl:call-template name="VATDecode">
												<xsl:with-param name="Translate" select="LineTax/TaxRate/@Code"/>
											</xsl:call-template>
										</VATCode>
										
										<VATRate>
											<xsl:value-of select="LineTax/TaxRate"/>
										</VATRate>
										
									</CreditNoteLine>
								</xsl:for-each>
								
							</CreditNoteDetail>
													
						</CreditNote>
					</BatchDocument>
				</xsl:for-each>
			</BatchDocuments>
		</Batch>
	</BatchRoot>
</xsl:template>
	
<xsl:template name="VATDecode">
	<xsl:param name="Translate"/>
		<xsl:choose>
			<xsl:when test="$Translate = 'A' ">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>Z</xsl:otherwise>
		</xsl:choose>
</xsl:template>

</xsl:stylesheet>
