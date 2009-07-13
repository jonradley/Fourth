<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-07		| 2991 Created Module
**********************************************************************
				|						|				
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" encoding="UTF-8" />
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/Transaction">
	
		<Batch>
			
			<BatchDocuments>
				<BatchDocument DocumentTypeNo="86">
					<Invoice>
						<TradeSimpleHeader>
							<SendersCodeForRecipient><xsl:value-of select="Customers/Customer/@SupplierClientID"/></SendersCodeForRecipient>
							<SendersBranchReference><xsl:value-of select="Client/@SupplierClientID"/></SendersBranchReference>					
						</TradeSimpleHeader>
						<InvoiceHeader>
							<Buyer>
								<BuyersLocationID>
									<xsl:for-each select="Client/@ClientID[. != ''][1]">
										<BuyersCode><xsl:value-of select="."/></BuyersCode>
									</xsl:for-each>
									<xsl:for-each select="Client/@SupplierClientID[. != ''][1]">
										<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
									</xsl:for-each>
								</BuyersLocationID>
								<BuyersName><xsl:value-of select="Client/@Company"/></BuyersName>
								<BuyersAddress>
									<AddressLine1><xsl:value-of select="Client/@Address"/></AddressLine1>
									<AddressLine2><xsl:value-of select="Client/@City"/></AddressLine2>
									<AddressLine3><xsl:value-of select="Client/@Province"/></AddressLine3>
									<AddressLine4>ESP</AddressLine4>
									<PostCode><xsl:value-of select="Client/@PC"/></PostCode>
								</BuyersAddress>
							</Buyer>
							
							<!-- Registry? -->
							
							<Supplier>
								<SuppliersLocationID>
									<BuyersCode><xsl:value-of select="Supplier/@CustomerSupplierID"/></BuyersCode>
									<SuppliersCode><xsl:value-of select="Supplier/@SupplierID"/></SuppliersCode>
								</SuppliersLocationID>
								<SuppliersName><xsl:value-of select="Supplier/@Company"/></SuppliersName>
								<SuppliersAddress>
									<AddressLine1><xsl:value-of select="Supplier/@Address"/></AddressLine1>
									<AddressLine2><xsl:value-of select="Supplier/@City"/></AddressLine2>
									<AddressLine3><xsl:value-of select="Supplier/@Province"/></AddressLine3>
									<AddressLine4>ESP</AddressLine4>
									<PostCode><xsl:value-of select="Supplier/@PC"/></PostCode>
								</SuppliersAddress>
							</Supplier>
							
							<!-- Registry? -->
							
							<ShipTo>
								<ShipToLocationID>
									<BuyersCode><xsl:value-of select="Customers/Customer/@CustomerID"/></BuyersCode>
									<SuppliersCode><xsl:value-of select="Customers/Customer/@SupplierClientID"/></SuppliersCode>
								
									<!-- Secondary codes? -->
								
								</ShipToLocationID>
								<ShipToName><xsl:value-of select="Customers/Customer/@Customer"/></ShipToName>
								<ShipToAddress>
									<AddressLine1><xsl:value-of select="Customers/Customer/@Address"/></AddressLine1>
									<AddressLine2><xsl:value-of select="Customers/Customer/@City"/></AddressLine2>
									<AddressLine3><xsl:value-of select="Customers/Customer/@Province"/></AddressLine3>
									<AddressLine4>ESP</AddressLine4>
									<PostCode><xsl:value-of select="Customers/Customer/@PC"/></PostCode>
								</ShipToAddress>
								<ContactName/>
							</ShipTo>
							<InvoiceReferences>
								<InvoiceReference><xsl:value-of select="GeneralData/@Ref"/></InvoiceReference>
								<InvoiceDate><xsl:value-of select="GeneralData/@Date"/></InvoiceDate>
								<xsl:for-each select="GeneralData/@BeginDate[. != ''][1]">
									<TaxPointDate><xsl:value-of select="."/></TaxPointDate>
								</xsl:for-each>
								<VATRegNo><xsl:value-of select="Supplier/@CIF"/></VATRegNo>
							</InvoiceReferences>
							<Currency>
								<xsl:choose>
									<xsl:when test="GeneralData/@Currency"><xsl:value-of select="GeneralData/@Currency"/></xsl:when>
									<xsl:otherwise>EUR</xsl:otherwise>
								</xsl:choose>
							</Currency>
						
						</InvoiceHeader>
						
						<InvoiceDetail>
						
							<xsl:for-each select="ProductList/Product">
						
								<InvoiceLine>
									
									<xsl:if test="References/Reference/@PORef[. != ''] or References/Reference/@PORefDate[. != '']">
										<PurchaseOrderReferences>
											<xsl:for-each select="References/Reference/@PORef[. != ''][1]">
												<PurchaseOrderReference><xsl:value-of select="."/></PurchaseOrderReference>
											</xsl:for-each>
											<xsl:for-each select="References/Reference/@PORefDate[. != ''][1]">
												<PurchaseOrderDate><xsl:value-of select="."/></PurchaseOrderDate>
											</xsl:for-each>
										</PurchaseOrderReferences>
									</xsl:if>
									
									<xsl:if test="References/Reference/@DNRef[. != ''] or References/Reference/@DNRefDate[. != '']">
										<DeliveryNoteReferences>
											<xsl:for-each select="References/Reference/@DNRef[. != ''][1]">
												<DeliveryNoteReference><xsl:value-of select="."/></DeliveryNoteReference>
											</xsl:for-each>
											<xsl:for-each select="References/Reference/@DNRefDate[. != ''][1]">
												<DeliveryNoteDate><xsl:value-of select="."/></DeliveryNoteDate>
											</xsl:for-each>
										</DeliveryNoteReferences>
									</xsl:if>
									
									<ProductID>
										<SuppliersProductCode><xsl:value-of select="@SupplierSKU"/></SuppliersProductCode>
									</ProductID>
									
									<ProductDescription><xsl:value-of select="@Item"/></ProductDescription>
									
									<InvoicedQuantity>
										<xsl:attribute name="UnitOfMeasure">
												<xsl:call-template name="transUoM">
													<xsl:with-param name="voxelUoM" select="@MU"/>
												</xsl:call-template>										
										</xsl:attribute>
										<xsl:value-of select="@Qty"/>
									</InvoicedQuantity>
									
									<UnitValueExclVAT><xsl:value-of select="@UP"/></UnitValueExclVAT>
									<LineValueExclVAT><xsl:value-of select="@Total"/></LineValueExclVAT>
									<xsl:for-each select="Discounts/Discount/@Rate[. != ''][1]">
										<LineDiscountRate><xsl:value-of select="."/></LineDiscountRate>
									</xsl:for-each>
									<xsl:for-each select="@NetAmount[. != ''][1]">
										<LineDiscountValue><xsl:value-of select="."/></LineDiscountValue>
									</xsl:for-each>
									<VATCode><xsl:value-of select="Taxes/Tax/@Type"/></VATCode>
									<VATRate><xsl:value-of select="Taxes/Tax/@Rate"/></VATRate>
									
									<!-- Fees -->
									
									<!-- live level doc refs same as header level references? -->
									
								</InvoiceLine>
								
							</xsl:for-each>
								
						</InvoiceDetail>
						<InvoiceTrailer>
							
							<VATSubTotals>
								
								<xsl:for-each select="/Transaction/TaxSummary/Tax">
								
									<VATSubTotal>
										<xsl:attribute name="VATCode">
											<xsl:value-of select="@Type"/>
										</xsl:attribute>
										<xsl:attribute name="VATRate">
											<xsl:value-of select="@Rate"/>
										</xsl:attribute>
										<DocumentTotalExclVATAtRate><xsl:value-of select="@Base"/></DocumentTotalExclVATAtRate>
										<VATAmountAtRate><xsl:value-of select="@Amount"/></VATAmountAtRate>
									</VATSubTotal>
									
								</xsl:for-each>
									
							</VATSubTotals>
							<DiscountedLinesTotalExclVAT><xsl:value-of select="TotalSummary/@NetAmount"/></DiscountedLinesTotalExclVAT>
							<xsl:for-each select="TotalSummary/@Discounts[. != ''][1]">
								<DocumentDiscount><xsl:value-of select="."/></DocumentDiscount>
							</xsl:for-each>
							<DocumentTotalExclVAT><xsl:value-of select="TotalSummary/@GrossAmount"/></DocumentTotalExclVAT>
							<SettlementTotalExclVAT><xsl:value-of select="TotalSummary/@SubTotal"/></SettlementTotalExclVAT>
							<VATAmount><xsl:value-of select="TotalSummary/@Tax"/></VATAmount>
							<SettlementTotalInclVAT><xsl:value-of select="TotalSummary/@Total"/></SettlementTotalInclVAT>
							
							<!-- Greene Dot? -->
							
						</InvoiceTrailer>
					</Invoice>
				</BatchDocument>
			</BatchDocuments>
		</Batch>

	
	</xsl:template>

	<xsl:template name="transUoM">
		<xsl:param name="voxelUoM"/>
	
		<xsl:choose>
			<xsl:when test="$voxelUoM = 'Unidades'">EA</xsl:when>
			<xsl:when test="$voxelUoM = 'Cajas'">CS</xsl:when>
			<xsl:when test="$voxelUoM = 'Kgs'">KGM</xsl:when>
		</xsl:choose>
	
	</xsl:template>

</xsl:stylesheet>
