<?xml version="1.0" encoding="UTF-8"?>
<!--********************************************************************
Date		|	owner				|	details
************************************************************************
06/09/2012|KOshaughnessy	| 	Created FB 5678
************************************************************************
			|						| 	
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" encoding="UTF-8"/>

<xsl:template match="/InvoiceBatch">
<BatchRoot>
<xsl:attribute name="TypePrefix">INV</xsl:attribute>
	<Batch>
		<BatchDocuments>
		<xsl:for-each select="Invoice">
			<BatchDocument>
				<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
					<Invoice>
					
						<TradeSimpleHeader>
							<SendersCodeForRecipient>
								<xsl:value-of select="Delivery/DeliverTo/DeliverToReferences/BuyersCodeForDelivery"/>
							</SendersCodeForRecipient>
						</TradeSimpleHeader>
						
						<InvoiceHeader>
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
							
							<InvoiceReferences>
								<InvoiceReference>
									<xsl:value-of select="InvoiceReferences/SuppliersInvoiceNumber"/>
								</InvoiceReference>
								<InvoiceDate>
									<xsl:value-of select="substring-before(InvoiceDate,'T')"/>
								</InvoiceDate>
								<TaxPointDate>
									<xsl:value-of select="substring-before(TaxPointDate,'T')"/>
								</TaxPointDate>
								<VATRegNo>
									<xsl:value-of select="Supplier/SupplierReferences/TaxNumber"/>
								</VATRegNo>
							</InvoiceReferences>

						</InvoiceHeader>
						
						<InvoiceDetail>
						
							<xsl:for-each select="InvoiceLine">
								<InvoiceLine>
								
									<LineNumber>
										<xsl:value-of select="LineNumber"/>
									</LineNumber>
									
									<PurchaseOrderReferences>
										<PurchaseOrderReference>
											<xsl:value-of select="InvoiceLineReferences/BuyersOrderNumber"/>
										</PurchaseOrderReference>
										<PurchaseOrderDate>
											<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
										</PurchaseOrderDate>
									</PurchaseOrderReferences>
									
									<DeliveryNoteReferences>
										<DeliveryNoteReference>
											<xsl:value-of select="InvoiceLineReferences/DeliveryNoteNumber"/>
										</DeliveryNoteReference>
										<DeliveryNoteDate>
											<xsl:value-of select="substring-before(../InvoiceDate,'T')"/>
										</DeliveryNoteDate>
									</DeliveryNoteReferences>
									
									<ProductID>
										<SuppliersProductCode>
											<xsl:value-of select="Product/SuppliersProductCode"/>
										</SuppliersProductCode>
									</ProductID>
									
									<ProductDescription>
										<xsl:value-of select="Product/Description"/>
									</ProductDescription>
									
									<InvoicedQuantity>
										<xsl:value-of select="format-number(Quantity/Amount,'0.00')"/>
									</InvoicedQuantity>
									
									<PackSize>
										<xsl:value-of select="Quantity/Packsize"/>
									</PackSize>
									
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
									
								</InvoiceLine>
							</xsl:for-each>
							
						</InvoiceDetail>
						
					</Invoice>
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
