
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
K Oshaughnessy| 2011-03-30		|  Created Modele
**********************************************************************
				|						|				
*******************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:eanucc="urn:ean.ucc:2" xmlns:pay="urn:ean.ucc:pay:2" xmlns:vat="urn:ean.ucc:pay:vat:2">
	<xsl:template match="/CreditNote">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<CreditNote>
							<TradeSimpleHeader>
							
								<SendersCodeForRecipient>
									<xsl:value-of select="ShipTo/SellerAssigned"/>
								</SendersCodeForRecipient>
								
								<xsl:if test="TradeAgreementReference/ContractReferenceNumber !='' ">
									<SendersBranchReference>
										<xsl:value-of select="TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if>
								
							</TradeSimpleHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~~
							CREDIT NOTE HEADER
							~~~~~~~~~~~~~~~~~~~~~~~~~ -->
							<CreditNoteHeader>
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
															
								<Buyer>
									<BuyersLocationID>
										<xsl:if test="string(Buyer/BuyerGLN) !='' ">
											<GLN>
												<xsl:value-of select="Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
									</BuyersLocationID>
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<xsl:if test="string(Seller/SellerGLN) !='' ">
											<GLN>
												<xsl:value-of select="Seller/SellerGLN"/>
											</GLN>
										</xsl:if>
									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="ShipTo/SellerAssigned"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								
								<InvoiceReferences>
								
									<InvoiceReference>
										<xsl:value-of select="InvoiceReference/InvoiceDocumentNumber"/>
									</InvoiceReference>
									
									<InvoiceDate>
										<xsl:value-of select="InvoiceReference/InvoiceDocumentDate"/>
									</InvoiceDate>
									
								</InvoiceReferences>
								
								<CreditNoteReferences>
								
									<CreditNoteReference>
										<xsl:value-of select="CreditNoteDocumentDetails/CreditNoteDocumentNumber"/>
									</CreditNoteReference>
									
									<CreditNoteDate>
										<xsl:value-of select="substring-before(CreditNoteDocumentDetails/CreditNoteDocumentDate, 'T')"/>
									</CreditNoteDate>
	
								</CreditNoteReferences>
								
								<xsl:if test="string(DespatchReference/DespatchDocumentNumber) !=''">
								<DeliveryNoteReferences>
								
									<xsl:if test="string(DespatchReference/DespatchDocumentNumber) !=''">
										<DeliveryNoteReference>
											<xsl:value-of select="DespatchReference/DespatchDocumentNumber"/>
										</DeliveryNoteReference>
									</xsl:if>	
								
									<xsl:if test="string(DespatchReference/DespatchDocumentDate) !=''">
										<DeliveryNoteDate>
											<xsl:value-of select="substring-before(DespatchReference/DespatchDocumentDate, 'T')"/>
										</DeliveryNoteDate>
									</xsl:if>
									
								</DeliveryNoteReferences>
								</xsl:if>
								
							</CreditNoteHeader>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~
								CREDIT NOTE DETAIL
							~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
							<xsl:for-each select="CreditItem">
							
								<CreditNoteDetail>
								
									<CreditNoteLine>
										
										<ProductID>
											<SuppliersProductCode>
												<xsl:choose>
													<xsl:when test="ItemIdentifier/AlternateCode != ''">
														<xsl:value-of select="ItemIdentifier/AlternateCode"/>
													</xsl:when>
													</xsl:choose>
											</SuppliersProductCode>
										</ProductID>
										
										<CreditedQuantity>
											<xsl:value-of select="format-number(CreditQuantity, '0.00')"/>
										</CreditedQuantity>
										
										<UnitValueExclVAT>
											<xsl:value-of select="format-number(UnitPrice, '0.00')"/>
										</UnitValueExclVAT>
										
										<LineValueExclVAT>
											<xsl:value-of select="format-number(LineItemPrice, '0.00')"/>
										</LineValueExclVAT>
										
										<VATCode>
											<xsl:value-of select="VATDetails/TaxCategory"/>
										</VATCode>
										
										<VATRate>
											<xsl:value-of select="format-number(VATDetails/TaxRate, '0.00')"/>
										</VATRate>
										
									</CreditNoteLine>
								</CreditNoteDetail>
							</xsl:for-each>
							<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
								CREDIT NOTE TRAILER
							~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
							<CreditNoteTrailer>
														
									<NumberOfLines>
										<xsl:value-of select="count(CreditItem/LineItemNumber)"/>
									</NumberOfLines>
									
									<NumberOfItems>
										<xsl:value-of select="sum(CreditItem/CreditQuantity)"/>
									</NumberOfItems>
	
									<VATAmount>
										<xsl:value-of select="CreditTotals/VATTotal"/>
									</VATAmount>
									
									<DocumentTotalInclVAT>
										<xsl:value-of select="CreditTotals/TotalPayable"/>
									</DocumentTotalInclVAT>
	
							</CreditNoteTrailer>
							
						</CreditNote>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>	
	</xsl:template>
</xsl:stylesheet>
