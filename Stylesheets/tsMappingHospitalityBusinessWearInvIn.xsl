<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="Invoice">
		<Invoice>
			<xsl:for-each select="Header">
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="SendersCodeforUnit"/>
					</SendersCodeForRecipient>
					<SendersName>
						<xsl:value-of select="SupplierName"/>
					</SendersName>
					<SendersAddress>
						<AddressLine1>
							<xsl:value-of select="SupplierAddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select="SupplierAddressLine2"/>
						</AddressLine2>
						<AddressLine3>
							<xsl:value-of select="SupplierAddressLine3"/>
						</AddressLine3>
						<AddressLine4>
							<xsl:value-of select="SupplierAddressLine4"/>
						</AddressLine4>
						<PostCode>
							<xsl:value-of select="SupplierAddressPostcode"/>
						</PostCode>
					</SendersAddress>
				</TradeSimpleHeader>
				<InvoiceHeader>
					<Supplier>
						<SuppliersName>
							<xsl:value-of select="SupplierName"/>
						</SuppliersName>
						<SuppliersAddress>
							<AddressLine1>
								<xsl:value-of select="SupplierAddressLine1"/>
							</AddressLine1>
							<AddressLine2>
								<xsl:value-of select="SupplierAddressLine2"/>
							</AddressLine2>
							<AddressLine3>
								<xsl:value-of select="SupplierAddressLine3"/>
							</AddressLine3>
							<AddressLine4>
								<xsl:value-of select="SupplierAddressLine4"/>
							</AddressLine4>
							<PostCode>
								<xsl:value-of select="SupplierAddressPostcode"/>
							</PostCode>
						</SuppliersAddress>
					</Supplier>
					<ShipTo>
						<ShipToLocationID>
							<SuppliersCode>
								<xsl:value-of select="SendersCodeforUnit"/>
							</SuppliersCode>
						</ShipToLocationID>
						<ShipToName>
							<xsl:value-of select="DeliveryLocationName"/>
						</ShipToName>
						<ShipToAddress>
							<AddressLine1>
								<xsl:value-of select="DeliveryLocationAddressLine1"/>
							</AddressLine1>
							<AddressLine2>
								<xsl:value-of select="DeliveryLocationAddressLine2"/>
							</AddressLine2>
							<AddressLine3>
								<xsl:value-of select="DeliveryLocationAddressLine3"/>
							</AddressLine3>
							<AddressLine4>
								<xsl:value-of select="DeliveryLocationAddressLine4"/>
							</AddressLine4>
							<PostCode>
								<xsl:value-of select="DeliveryLocationAddressPostcode"/>
							</PostCode>
						</ShipToAddress>
						<ContactName/>
					</ShipTo>
					<InvoiceReferences>
						<InvoiceReference>
							<xsl:value-of select="InvoiceNumber"/>
						</InvoiceReference>
						<InvoiceDate>
							<xsl:value-of select="InvoiceDate"/>
						</InvoiceDate>
						<TaxPointDate>
							<xsl:value-of select="TaxpointDate"/>
						</TaxPointDate>
					</InvoiceReferences>
				</InvoiceHeader>
			</xsl:for-each>
			<InvoiceDetail>
				<xsl:for-each select="Detail">
					<InvoiceLine>
						<LineNumber>
							<xsl:value-of select="position()"/>
						</LineNumber>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="PurchaseOrderReference"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="PurchaseOrderDate"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<ProductID>
							<SuppliersProductCode>
								<xsl:value-of select="SuppliersProductCode"/>
							</SuppliersProductCode>
						</ProductID>
						<ProductDescription/>
						<InvoicedQuantity>
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="QuantityInvoiced"/></xsl:attribute>
						</InvoicedQuantity>
						<PackSize>
							<xsl:value-of select="PackSize"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select="UnitValueExVAT"/>
						</UnitValueExclVAT>
						<LineValueExclVAT>
							<xsl:value-of select="LineValueExVAT"/>
						</LineValueExclVAT>
						<VATCode>
							<xsl:value-of select="VATCode"/>
						</VATCode>
						<VATRate>
							<xsl:value-of select="VATRate"/>
						</VATRate>
					</InvoiceLine>
				</xsl:for-each>
			</InvoiceDetail>
			
			<InvoiceTrailer>
				<NumberOfLines/>
				<NumberOfItems/>
				<VATSubTotals>
				<xsl:for-each select="VatSummary">
								<VATSubTotal>
						<xsl:attribute name="VatCode"><xsl:value-of select="VatCode"/></xsl:attribute>
						<xsl:attribute name="VatRate"><xsl:value-of select="VatRate"/></xsl:attribute>
						<NumberOfLinesAtRate><xsl:value-of select="NumberOfLinesAtRate"/></NumberOfLinesAtRate>
						<NumberOfItemsAtRate><xsl:value-of select="NumberOfItemsAtRate"/></NumberOfItemsAtRate>
						<DocumentTotalExclVATAtRate/>
						<SettlementTotalExclVATAtRate/>
						<VATAmountAtRate/>
						<DocumentTotalInclVATAtRate/>
						<SettlementTotalInclVATAtRate/>
						<VATTrailerExtraData/>
					</VATSubTotal>
				</xsl:for-each>
				</VATSubTotals>
				<DocumentTotalExclVAT/>
				<SettlementTotalExclVAT/>
				<VATAmount/>
				<DocumentTotalInclVAT/>
				<SettlementTotalInclVAT/>
			</InvoiceTrailer>
		</Invoice>
	</xsl:template>
</xsl:stylesheet>
