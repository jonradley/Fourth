<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************************************************************************
21/06/2012	| Mark Emanuel	| FB 5529 New Credit Note Mapper for John Sheppard
================================================================================
14/01/2014	| Jose Miguel		| FB 7615 Optimise John Sheppard invoice/credits/delivery notes mapper changes
================================================================================
22/01/2016	| Moty Dimant	| FB 10773 Added mapping of supplier's code for buyer. 
**********************************************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- we use constants for most default values -->
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	
	<xsl:template match="/CreditNotes">
	
		<BatchRoot>
		
			<Batch>
			
				<BatchDocuments>
				
					<xsl:for-each select="CreditNote">
				
						<BatchDocument>
		
							<CreditNote>
						
								<!--Tradesimple Header -->
							
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:value-of select="ShipTo/BuyerAssigned"/>
									</SendersCodeForRecipient>
									
									<SendersBranchReference>
										<xsl:value-of select="Buyer/BuyerAssigned"/>
									</SendersBranchReference>	
									
								</TradeSimpleHeader>
								
								<!--CreditNote Header -->
							
									<CreditNoteHeader>
										
										<DocumentStatus><xsl:text>Original</xsl:text></DocumentStatus>
										<Buyer>
											<BuyersLocationID>						
												<SuppliersCode>
													<xsl:value-of select="Buyer/BuyerAssigned"/>
												</SuppliersCode>
											</BuyersLocationID>	
										</Buyer>
										
										<ShipTo>										
											<ShipToLocationID>											
												<xsl:if test="string(ShipTo/BuyerAssigned)">
													<SuppliersCode>
														<xsl:value-of select="ShipTo/BuyerAssigned"/>
													</SuppliersCode>
												</xsl:if>												
											</ShipToLocationID>										
										</ShipTo>
										
										<InvoiceReferences>
											<InvoiceReference>
												<xsl:value-of select="OrderReference/PurchaseOrderNumber"/>
											</InvoiceReference>
											<InvoiceDate>
												<xsl:value-of select="OrderReference/PurchaseOrderDate"/>
											</InvoiceDate>										
										</InvoiceReferences>
										
										<CreditNoteReferences>
											<CreditNoteReference>
												<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentNumber"/>
											</CreditNoteReference>
											<CreditNoteDate>
												<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
											</CreditNoteDate>
											<TaxPointDate>
												<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentDate"/>
											</TaxPointDate>
											
											<!-- HR 2012-06-11 moved <VATRegNo> inside <CreditNoteReferences> -->
											<xsl:if test="Seller/VATRegisterationNumber">
												<VATRegNo>
													<xsl:value-of select="translate(Seller/VATRegisterationNumber,' ','')"/>
												</VATRegNo>
											</xsl:if>
											
										</CreditNoteReferences>
										
									</CreditNoteHeader>	
								
								<!-- CreditNote Detail Line -->
								
									<CreditNoteDetail>
										
										<xsl:for-each select="CreditItem">
										
											<CreditNoteLine>
											
											<LineNumber>
												<xsl:value-of select="LineItemNumber"/>
											</LineNumber>
											
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<xsl:text>Not Provided</xsl:text>
												</DeliveryNoteReference>
											</DeliveryNoteReferences>
											
											<ProductID>
											
												<GTIN>
													<xsl:text>55555555555555</xsl:text>
												</GTIN>
												
												<SuppliersProductCode>
													<xsl:value-of select="ItemIdentifier/AlternateCode"/>
												</SuppliersProductCode>
											
											</ProductID>
										
											<ProductDescription>
												<xsl:value-of select="LineItemDescription"/>
											</ProductDescription>
											
											<CreditedQuantity>
												<xsl:attribute name="UnitOfMeasure">
													<xsl:choose>
														<xsl:when test="InvoiceQuantity/@unitCode='KILO'">KGM</xsl:when>
														<xsl:when test="InvoiceQuantity/@unitCode='PCS'">EA</xsl:when>
													</xsl:choose>
												</xsl:attribute>
												<xsl:value-of select="InvoiceQuantity"/>
											</CreditedQuantity>
											
											<UnitValueExclVAT>
												<xsl:value-of select="UnitPrice"/>
											</UnitValueExclVAT>
											
											<LineValueExclVAT>
												<xsl:value-of select="LineItemPrice"/>
											</LineValueExclVAT>
											
											<VATCode>
												<xsl:value-of select="VATDetails/TaxCategory"/>
											</VATCode>
											
											<VATRate>
												<xsl:value-of select="VATDetails/TaxRate"/>
											</VATRate>
											
										</CreditNoteLine>
										
									</xsl:for-each>
								
								</CreditNoteDetail>
							
							<!-- CreditNote Trailer -->
							
								<CreditNoteTrailer>
									<NumberOfLines>
										<xsl:value-of select="count(CreditItem)"/>
									</NumberOfLines>
									<NumberOfItems>
										<xsl:value-of select="format-number(sum(CreditItem/InvoiceQuantity),'0.00')"/>
									</NumberOfItems>
									
								<DocumentDiscountRate>
									<xsl:choose>
										<xsl:when test="CreditTotals/DocumentDiscountRate">
											<xsl:value-of select="format-number(CreditTotals/DocumentDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultDocumentDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentDiscountRate>
							
								<SettlementDiscountRate>
									<xsl:choose>
										<xsl:when test="CreditTotals/SettlementDiscountRate">
											<xsl:value-of select="format-number(CreditTotals/SettlementDiscountRate, '0.00')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="format-number($defaultSettlementDiscountRate, '0.00')"/>
										</xsl:otherwise>
									</xsl:choose>
								</SettlementDiscountRate>
							
									<!-- DiscountedLinesTotalExclVAT is mandatory in our schema but not John Sheppard If we find none then just default the value -->
									<DiscountedLinesTotalExclVAT>
										<xsl:value-of select="format-number(CreditTotals/CreditNoteSubTotal, '0.00')"/>
									</DiscountedLinesTotalExclVAT>
									<!-- DocumentDiscount is mandatory in our schema but not John Sheppard If we find none then just default the value -->
									<DocumentDiscount>
										<xsl:value-of select="format-number($defaultDocumentDiscountValue,'0.00')"/>
									</DocumentDiscount>
									<DocumentTotalExclVAT>
										<xsl:value-of select="format-number(CreditTotals/CreditNoteSubTotal, '0.00')"/>
									</DocumentTotalExclVAT>
									<!-- SettlementDiscount is mandatory in our schema but not John Sheppard If we find none then just default the value -->
									<xsl:if test="InvoiceTotals/SettlementDiscountTotal">
										<SettlementDiscount>
											<xsl:value-of select="format-number(CreditTotals/SettlementDiscountTotal, '0.00')"/>
										</SettlementDiscount>
									</xsl:if>
									<!-- we need a SettlementTotalExclVAT internally but it is optional in John Sheppard so we work it out if it is missing -->
									<xsl:if test="InvoiceTotals/SettlementSubTotal">
										<SettlementTotalExclVAT>
											<xsl:value-of select="format-number(CreditTotals/SettlementSubTotal, '0.00')"/>
										</SettlementTotalExclVAT>
									</xsl:if>
									<!-- we need a VATAmount internally but it is optional in John Sheppard so we work it out if it is missing -->
									<xsl:if test="InvoiceTotals/VATTotal">
										<VATAmount>
											<xsl:value-of select="format-number(CreditTotals/VATTotal, '0.00')"/>
										</VATAmount>
									</xsl:if>
									<DocumentTotalInclVAT>
										<xsl:value-of select="format-number(CreditTotals/TotalPayable, '0.00')"/>
									</DocumentTotalInclVAT>
									<!-- we need a SettlementTotalInclVAT internally but it is optional in John Sheppard so we work it out if it is missing -->
									<SettlementTotalInclVAT>
										<xsl:value-of select="format-number(CreditTotals/TotalPayable, '0.00')"/>
									</SettlementTotalInclVAT>

								
								</CreditNoteTrailer>
									
							</CreditNote>
							
						</BatchDocument>	
							
					</xsl:for-each>
					
				</BatchDocuments>
				
			</Batch>
		
		</BatchRoot>
	
	</xsl:template>	

</xsl:stylesheet>
