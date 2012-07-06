<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Businesswear Invoice to Internal XML tsmapinghospitalitybusinesswearINVIn
	

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 4/7/2012	| Stephen Bowers		| Created module
==========================================================================================
			| 				| 
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="Invoice">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="86">
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
											<xsl:if test="SupplierAddressLine1 != ''"><AddressLine1><xsl:value-of select="SupplierAddressLine1"/></AddressLine1></xsl:if>
											<xsl:if test="SupplierAddressLine2 != ''"><AddressLine2><xsl:value-of select="SupplierAddressLine2"/></AddressLine2></xsl:if>
											<xsl:if test="SupplierAddressLine3 != ''"><AddressLine3><xsl:value-of select="SupplierAddressLine3"/></AddressLine3></xsl:if>
											<xsl:if test="SupplierAddressLine4 != ''"><AddressLine4><xsl:value-of select="SupplierAddressLine4"/></AddressLine4></xsl:if>
											<xsl:if test="SupplierAddressPostcode != ''"><PostCode><xsl:value-of select="SupplierAddressPostcode"/></PostCode></xsl:if>
										</SendersAddress>
								</TradeSimpleHeader>
								<InvoiceHeader>
									<Supplier>
										<SuppliersName>
											<xsl:value-of select="SupplierName"/>
										</SuppliersName>
										<SuppliersAddress>
											<xsl:if test="SupplierAddressLine1 != ''"><AddressLine1><xsl:value-of select="SupplierAddressLine1"/></AddressLine1></xsl:if>
											<xsl:if test="SupplierAddressLine2 != ''"><AddressLine2><xsl:value-of select="SupplierAddressLine2"/></AddressLine2></xsl:if>
											<xsl:if test="SupplierAddressLine3 != ''"><AddressLine3><xsl:value-of select="SupplierAddressLine3"/></AddressLine3></xsl:if>
											<xsl:if test="SupplierAddressLine4 != ''"><AddressLine4><xsl:value-of select="SupplierAddressLine4"/></AddressLine4></xsl:if>
											<xsl:if test="SupplierAddressPostcode != ''"><PostCode><xsl:value-of select="SupplierAddressPostcode"/></PostCode></xsl:if>
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
											<xsl:if test="DeliveryLocationAddressLine1 != ''"><AddressLine1><xsl:value-of select="DeliveryLocationAddressLine1"/></AddressLine1></xsl:if>
											<xsl:if test="DeliveryLocationAddressLine2 != ''"><AddressLine2><xsl:value-of select="DeliveryLocationAddressLine2"/></AddressLine2></xsl:if>
											<xsl:if test="DeliveryLocationAddressLine3 != ''"><AddressLine3><xsl:value-of select="DeliveryLocationAddressLine3"/></AddressLine3></xsl:if>
											<xsl:if test="DeliveryLocationAddressLine4 != ''"><AddressLine4><xsl:value-of select="DeliveryLocationAddressLine4"/></AddressLine4></xsl:if>
											<xsl:if test="DeliveryLocationAddressPostcode != ''"><PostCode><xsl:value-of select="DeliveryLocationAddressPostcode"/></PostCode></xsl:if>
										</ShipToAddress>
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
												<xsl:value-of select="../Header/PurchaseOrderReference"/>
											</PurchaseOrderReference>
											<PurchaseOrderDate>
												<xsl:value-of select="../Header/PurchaseOrderDate"/>
											</PurchaseOrderDate>
										</PurchaseOrderReferences>
										<DeliveryNoteReferences>
											<DeliveryNoteReference>
											<xsl:value-of select="../Header/DeliveryNoteReference"/>
											</DeliveryNoteReference>
											<DeliveryNoteDate>
											<xsl:value-of select="../Header/DeliveryNoteDate"/>
											</DeliveryNoteDate>
										</DeliveryNoteReferences>
											
											<ProductID>
											<SuppliersProductCode>
												<xsl:value-of select="SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										<ProductDescription/>
										<InvoicedQuantity>
											<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityInvoiced"/>
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
											<xsl:value-of select="VatCode"/>
										</VATCode>
										<VATRate>
											<xsl:value-of select="VatRate"/>
										</VATRate>
									</InvoiceLine>
								</xsl:for-each>
							</InvoiceDetail>
							
							<xsl:for-each select="InvoiceTrailer">
								<InvoiceTrailer>
									<NumberOfLines>
										<xsl:value-of select="NumberOfLines"/>
									</NumberOfLines>
									<NumberOfItems>
										<xsl:value-of select="NumberOfItems"/>
									</NumberOfItems>
									<VATSubTotals>
										<xsl:for-each select="VatSummarys/VatSummary">
											<VATSubTotal>
												<xsl:attribute name="VatCode"><xsl:value-of select="VatCode"/></xsl:attribute>
												<xsl:attribute name="VatRate"><xsl:value-of select="VatRate"/></xsl:attribute>
												<NumberOfLinesAtRate>
													<xsl:value-of select="NumberOfLinesAtRate"/>
												</NumberOfLinesAtRate>
												<NumberOfItemsAtRate>
													<xsl:value-of select="NumberOfItemsAtRate"/>
												</NumberOfItemsAtRate>
												<DocumentTotalExclVATAtRate>
													<xsl:value-of select="DocumentTotalExclVATAtRate"/>
												</DocumentTotalExclVATAtRate>
												<VATAmountAtRate>
													<xsl:value-of select="VatAmountAtRate"/>
												</VATAmountAtRate>
											</VATSubTotal>
										</xsl:for-each>
									</VATSubTotals>
									<DocumentTotalExclVAT>
										<xsl:value-of select="DocumentTotalExclVAT"/>
									</DocumentTotalExclVAT>
									<VATAmount>
										<xsl:value-of select="VATAmount"/>
									</VATAmount>
									<DocumentTotalInclVAT>
										<xsl:value-of select="DocumentTotalInclVAT"/>
									</DocumentTotalInclVAT>
								</InvoiceTrailer>
							</xsl:for-each>
						</Invoice>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
