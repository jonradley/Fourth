<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************************************************************
21/06/2012	| Mark Emanuel	| FB 5529 New Invoice and Delivery Note Mapper for John Sheppard
14/01/2014	| Jose Miguel	| FB 7615 Optimise John Sheppard invoice/credits/delivery notes mapper changes
*******************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- we use constants for default values -->
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	
	<xsl:template match="/Invoices">
	
		<BatchRoot> 
		
			<Document>
			
			<xsl:attribute name="TypePrefix">INV</xsl:attribute>
		
				<Batch>
				
					<BatchDocuments>
		
						<xsl:for-each select="Invoice">
						
							<BatchDocument> <!-- moved from outside the for-each to inside it, as each Invoice is a new BatchDocument 2012-06-11 HR -->
								<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
							
								<Invoice>
							
									<!--Tradesimple Header -->
								
									<TradeSimpleHeader>
										<SendersCodeForRecipient>
											<xsl:value-of select="ShipTo/BuyerAssigned"/>
										</SendersCodeForRecipient>
										
			
												<SendersBranchReference>
													<xsl:value-of select="Buyer/BuyerAssigned"/>
												</SendersBranchReference>
										
									</TradeSimpleHeader>
									
									<!--Invoice Header -->
								
									<InvoiceHeader>
										
										<DocumentStatus>
											<xsl:text>Original</xsl:text>
										</DocumentStatus>
										
										<ShipTo>
										
											<ShipToLocationID>
											
												<xsl:if test="string(ShipTo/BuyerAssigned)">
													<SuppliersCode>
														<xsl:value-of 	select="ShipTo/BuyerAssigned"/>
													</SuppliersCode>
												</xsl:if>
												
											</ShipToLocationID>
										
										</ShipTo>
										
										<InvoiceReferences>
											<InvoiceReference>
												<xsl:value-of 	select="InvoiceDocumentDetails/InvoiceDocumentNumber"/>
											</InvoiceReference>
											<InvoiceDate>
												<xsl:value-of 	select="InvoiceDocumentDetails/InvoiceDocumentDate"/>
											</InvoiceDate>
											<TaxPointDate>
												<xsl:value-of 	select="InvoiceDocumentDetails/InvoiceDocumentDate"/>
											</TaxPointDate>
											<xsl:if test="Seller/VATRegisterationNumber">
												<VATRegNo>
													<xsl:value-of select="translate	(Seller/VATRegisterationNumber,' ','')"/>
												</VATRegNo>
											</xsl:if>
											
										</InvoiceReferences>
										
									</InvoiceHeader>	
									
									<!-- Invoice Detail Line -->
									
									<InvoiceDetail>
										
										<xsl:for-each select="InvoiceItem">
										
											<InvoiceLine>
											
												<LineNumber>
													<xsl:value-of select="LineItemNumber"/>
												</LineNumber>
										
												<PurchaseOrderReferences>
													<PurchaseOrderReference>
														<xsl:value-of 	select="../OrderReference/PurchaseOrderNumber"/>
													</PurchaseOrderReference>	
													
													<PurchaseOrderDate>
														<xsl:value-of 	select="../OrderReference/PurchaseOrderDate"/>
													</PurchaseOrderDate>
																
												</PurchaseOrderReferences>
												
												
												
												<DeliveryNoteReferences>
													<DeliveryNoteReference>
														<xsl:value-of 	select="../InvoiceDocumentDetails/InvoiceDocumentNumber"/>
													</DeliveryNoteReference>
												</DeliveryNoteReferences>
												
												<ProductID>
												
													<GTIN>
														<xsl:text>55555555555555</xsl:text>
													</GTIN>
													
													<SuppliersProductCode>
														<xsl:value-of 	select="ItemIdentifier/AlternateCode"/>
													</SuppliersProductCode>
												
												</ProductID>
											
												<ProductDescription>
													<xsl:value-of select="LineItemDescription"/>
												</ProductDescription>
												
												<InvoicedQuantity>
													<xsl:attribute name="UnitOfMeasure">
														<xsl:choose>
															<xsl:when test="InvoiceQuantity/@unitCode='KILO'">KGM</xsl:when>
															<xsl:when test="InvoiceQuantity/@unitCode='PCS'">EA</xsl:when>
														</xsl:choose>
													</xsl:attribute>
													<xsl:value-of select="InvoiceQuantity"/>
												</InvoicedQuantity>
												
												<UnitValueExclVAT>
													<xsl:value-of select="UnitPrice"/>
												</UnitValueExclVAT>
												
												<LineValueExclVAT>
													<xsl:value-of select="LineItemPrice"/>
												</LineValueExclVAT>
												
												<VATCode>
													<xsl:value-of 	select="VATDetails/TaxCategory"/>
												</VATCode>
												
												<VATRate>
													<xsl:value-of select="VATDetails/TaxRate"/>
												</VATRate>
												
											</InvoiceLine>
											
										</xsl:for-each>
									
									</InvoiceDetail>
									
									<!-- Invoice Trailer -->
									
									<InvoiceTrailer>
										<NumberOfLines>
											<xsl:value-of select="count(InvoiceItem)"/>
										</NumberOfLines>
										<NumberOfItems>
											<xsl:value-of select="format-number(sum(InvoiceItem/InvoiceQuantity),'0.00')"/>
										</NumberOfItems>
										
									<DocumentDiscountRate>
										<xsl:choose>
											<xsl:when test="InvoiceTotals/DocumentDiscountRate">
												<xsl:value-of select="format-number(InvoiceTotals/DocumentDiscountRate, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</DocumentDiscountRate>
									
									<SettlementDiscountRate>
										<xsl:choose>
											<xsl:when 	test="InvoiceTotals/SettlementDiscountRate">
												<xsl:value-of select="format-number(InvoiceTotals/SettlementDiscountRate, '0.00')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
											</xsl:otherwise>
										</xsl:choose>
									</SettlementDiscountRate>
									
												
									<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not John Sheppard. If we find none then just default the value -->
									<DiscountedLinesTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/InvoiceSubTotal, '0.00')"/>
									</DiscountedLinesTotalExclVAT>
									<!-- DocumentDiscount is mandatory in our schema but not John Sheppard. If we find none then just default the value -->
									<DocumentDiscount>
										<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
									</DocumentDiscount>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/InvoiceSubTotal, '0.00')"/>
									</DocumentTotalExclVAT>
									<!-- SettlementDiscount is mandatory in our schema but not John Sheppard. If we find none then just default the value -->
									<xsl:if test="InvoiceTotals/SettlementDiscountTotal">
										<SettlementDiscount>
											<xsl:value-of select="format-number(InvoiceTotals/SettlementDiscountTotal, '0.00')"/>
										</SettlementDiscount>
									</xsl:if>
									<!-- we need a SettlementTotalExclVAT internally but it is optional in John Sheppard so we work it out if it is missing -->
									<xsl:if test="InvoiceTotals/SettlementSubTotal">
										<SettlementTotalExclVAT>
											<xsl:value-of select="format-number(InvoiceTotals/SettlementSubTotal, '0.00')"/>
										</SettlementTotalExclVAT>
									</xsl:if>
									<!-- we need a VATAmount internally but it is optional in John Sheppard so we work it out if it is missing -->
									<xsl:if test="InvoiceTotals/VATTotal">
										<VATAmount>
											<xsl:value-of select="format-number(InvoiceTotals/VATTotal, '0.00')"/>
										</VATAmount>
									</xsl:if>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/TotalPayable, '0.00')"/>
									</DocumentTotalInclVAT>
									<!-- we need a SettlementTotalInclVAT internally but it is optional in John Sheppard so we work it out if it is missing -->
									<SettlementTotalInclVAT>
										<xsl:value-of select="format-number(InvoiceTotals/TotalPayable, '0.00')"/>
									</SettlementTotalInclVAT>
	
										
									</InvoiceTrailer>
									
								</Invoice>
								
								</BatchDocument> <!-- moved from outside the for-each to inside it, as each Invoice is a new BatchDocument 2012-06-11 HR -->
							
							</xsl:for-each>
				
					</BatchDocuments>
			
				</Batch>

			</Document>			
			<!-- Build a Delivery Note on the back of the invoice -->
	
			
			<Document>
	      
	      <xsl:attribute name="TypePrefix">DNB</xsl:attribute>
					
				<Batch>
				
					<BatchDocuments>
						
						<xsl:for-each select="Invoice">
							
							<BatchDocument>
							
								<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
								
								<DeliveryNote>
								
									<TradeSimpleHeader>
										
										<SendersCodeForRecipient>
											<xsl:value-of select="ShipTo/BuyerAssigned"/>
										</SendersCodeForRecipient>
										
												<SendersBranchReference>
													<xsl:value-of select="Buyer/BuyerAssigned"/>
												</SendersBranchReference>
										
									</TradeSimpleHeader>
									
									<DeliveryNoteHeader>
									
										<DocumentStatus>Original</DocumentStatus>
									
										<ShipTo>
											<ShipToLocationID>
												<xsl:if test="string(ShipTo/BuyerAssigned)">
													<SuppliersCode>
														<xsl:value-of 	select="ShipTo/BuyerAssigned"/>
													</SuppliersCode>
												</xsl:if>
											</ShipToLocationID>
									
										</ShipTo>
										
										<PurchaseOrderReferences>
											<PurchaseOrderReference>
												<xsl:value-of 	select="OrderReference/PurchaseOrderNumber"/>
											</PurchaseOrderReference>
											<PurchaseOrderDate>
												<xsl:value-of 	select="OrderReference/PurchaseOrderDate"/>
											</PurchaseOrderDate>
										</PurchaseOrderReferences>
										
							
										
										<DeliveryNoteReferences>
											<DeliveryNoteReference>
												<xsl:value-of 	select="InvoiceDocumentDetails/InvoiceDocumentNumber"/>
											</DeliveryNoteReference>
											<DeliveryNoteDate>
												<xsl:value-of 	select="InvoiceDocumentDetails/InvoiceDocumentDate"/>
											</DeliveryNoteDate>
											
									
										</DeliveryNoteReferences>
										
							
										</DeliveryNoteHeader>
										
										<DeliveryNoteDetail>
										
											<xsl:for-each select="InvoiceItem">
												
												<DeliveryNoteLine>
													
													<LineNumber>
														<xsl:value-of select="LineItemNumber"/>
													</LineNumber>
													
													<ProductID>
														<GTIN>
															<xsl:text>55555555555555</xsl:text>
														</GTIN>
														<xsl:if 	test="ItemIdentifier/AlternateCode">
															<SuppliersProductCode>
																<xsl:value-of 	select="ItemIdentifier/AlternateCode"/>
															</SuppliersProductCode>
														</xsl:if>
													</ProductID>
													
													<ProductDescription>
														<xsl:value-of 	select="LineItemDescription"/>
													</ProductDescription>
													
													<DespatchedQuantity>
														<xsl:attribute name="UnitOfMeasure">
															<xsl:choose>
																<xsl:when test="InvoiceQuantity/@unitCode='KILO'">KGM</xsl:when>
																<xsl:when test="InvoiceQuantity/@unitCode='PCS'">EA</xsl:when>
															</xsl:choose>
														</xsl:attribute>
														<xsl:value-of select="format-number	(InvoiceQuantity, '0.000')"/>
													</DespatchedQuantity>
															
													<PackSize>
														<xsl:value-of select="InvoiceQuantity/@unitCode"/>
													</PackSize>	
													
												</DeliveryNoteLine>
											
											</xsl:for-each>
										
										</DeliveryNoteDetail>
										
										<DeliveryNoteTrailer>
										
											<NumberOfLines>
												<xsl:value-of select="count(InvoiceItem)"/>
											</NumberOfLines>
											
										</DeliveryNoteTrailer>
								
								</DeliveryNote>
								
							</BatchDocument>
						
						</xsl:for-each>
					
				</BatchDocuments>
			
			</Batch>
			
			</Document>
		

		</BatchRoot>
				
	</xsl:template>
</xsl:stylesheet>
