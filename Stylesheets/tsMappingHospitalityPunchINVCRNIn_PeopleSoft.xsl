<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Invoice/credit approval report to Punch's Peoplesoft system

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 01/05/2011	| A Barber				| 4376 Created module
==========================================================================================
 18/05/2011	| R Cambridge			| 4376 system testing changes
==========================================================================================
           	|                 	| 
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:key name="distinctSuppliers_Invoices" 
				match="/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/Buyer/BuyersAddress/AddressLine2='I']" 
				use="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				
	<xsl:key name="distinctSuppliers_Credits" 
				match="/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/Buyer/BuyersAddress/AddressLine2='C']" 
				use="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>

	<xsl:variable name="PUNCH_PREFIX" select="'PUNCH_'"/>

	<xsl:template match="/">
		<BatchRoot>
			
			<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice[generate-id() = generate-id(key('distinctSuppliers_Invoices',InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode)[1])]">
			
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<xsl:for-each select="key('distinctSuppliers_Invoices',InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode)">
								<BatchDocument>
									<Invoice>
										<TradeSimpleHeader>
											<SendersCodeForRecipient>
												<!-- SCR is defined by POunch but need to ensure Punch's codes don not clash with supplier defined codes for other customs -->
												<xsl:value-of select="concat($PUNCH_PREFIX,TradeSimpleHeader/SendersCodeForRecipient)"/>
											</SendersCodeForRecipient>
										</TradeSimpleHeader>
										<InvoiceHeader>
											<!--Buyer>
												<BuyersLocationID>
													<SuppliersCode/>
												</BuyersLocationID>
											</Buyer-->
											<Supplier>
												<SuppliersLocationID>
													<BuyersCode><xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/></BuyersCode>
												</SuppliersLocationID>
											</Supplier>
	
											<ShipTo>
												<!--ShipToLocationID>
													<SuppliersCode>
														<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
													</SuppliersCode>
												</ShipToLocationID-->
											</ShipTo>
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</InvoiceReference>
												<InvoiceDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</InvoiceDate>
												<TaxPointDate>
													<xsl:call-template 	name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</InvoiceReferences>
											<HeaderExtraData>
												<VoucherID>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine1"/>
												</VoucherID>
												<InvoiceType>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine2"/>
												</InvoiceType>												
											</HeaderExtraData>
										</InvoiceHeader>
										<InvoiceDetail>
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<InvoiceLine>
													<PurchaseOrderReferences>
														<PurchaseOrderReference>
															<xsl:value-of select="../*[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
														</PurchaseOrderReference>
														<PurchaseOrderDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
															</xsl:call-template>
														</PurchaseOrderDate>
													</PurchaseOrderReferences>
													<DeliveryNoteReferences>
														<DeliveryNoteReference>
															<xsl:value-of select="../*[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
														</DeliveryNoteReference>
														<DeliveryNoteDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
															</xsl:call-template>
														</DeliveryNoteDate>
													</DeliveryNoteReferences>
													<ProductID>
														<SuppliersProductCode>
															<xsl:value-of select="ProductID/SuppliersProductCode"/>
														</SuppliersProductCode>
													</ProductID>
													<InvoicedQuantity>
														<xsl:value-of select="format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000')"/>
													</InvoicedQuantity>
													<UnitValueExclVAT>
														<xsl:value-of select="format-number(format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00') div format-number	(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000'),'0.0000')"/>
													</UnitValueExclVAT>
													<LineValueExclVAT>
														<xsl:value-of select="format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00')"/>
													</LineValueExclVAT>
													<VATCode>Z</VATCode>
													<VATRate>0.00</VATRate>
												</InvoiceLine>
											</xsl:for-each>
										</InvoiceDetail>
									</Invoice>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			
			</xsl:for-each>
			
			
			<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice[generate-id() = generate-id(key('distinctSuppliers_Credits',InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode)[1])]">
			
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<xsl:for-each select="key('distinctSuppliers_Credits',InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode)">
								<BatchDocument>
									<CreditNote>
										<TradeSimpleHeader>
											<SendersCodeForRecipient>
												<!-- SCR is defined by POunch but need to ensure Punch's codes don not clash with supplier defined codes for other customs -->
												<xsl:value-of select="concat($PUNCH_PREFIX,TradeSimpleHeader/SendersCodeForRecipient)"/>
											</SendersCodeForRecipient>
										</TradeSimpleHeader>
										<CreditNoteHeader>
											<!--Buyer>
												<BuyersLocationID>
													<SuppliersCode/>
												</BuyersLocationID>
											</Buyer-->
											<Supplier>
												<SuppliersLocationID>
													<BuyersCode><xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/></BuyersCode>
												</SuppliersLocationID>
											</Supplier>
	
											<ShipTo>
												<!--ShipToLocationID>
													<SuppliersCode>
														<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
													</SuppliersCode>
												</ShipToLocationID-->
											</ShipTo>
											<InvoiceReferences>
												<InvoiceReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</InvoiceReference>
												<InvoiceDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</InvoiceDate>
												<TaxPointDate>
													<xsl:call-template 	name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</InvoiceReferences>
											<CreditNoteReferences>
												<CreditNoteReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</CreditNoteReference>
												<CreditNoteDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>
												</CreditNoteDate>
												<TaxPointDate>
													<xsl:call-template name="utcDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>
												</TaxPointDate>
											</CreditNoteReferences>
											<HeaderExtraData>
												<VoucherID>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine1"/>
												</VoucherID>
												<InvoiceType>
													<xsl:value-of select="*/Buyer/BuyersAddress/AddressLine2"/>
												</InvoiceType>												
											</HeaderExtraData>											
										</CreditNoteHeader>
										<CreditNoteDetail>
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<CreditNoteLine>
													<PurchaseOrderReferences>
														<PurchaseOrderReference>
															<xsl:value-of select="../*[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
														</PurchaseOrderReference>
														<PurchaseOrderDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
															</xsl:call-template>
														</PurchaseOrderDate>
													</PurchaseOrderReferences>
													<DeliveryNoteReferences>
														<DeliveryNoteReference>
															<xsl:value-of select="../*[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
														</DeliveryNoteReference>
														<DeliveryNoteDate>
															<xsl:call-template name="utcDate">
																<xsl:with-param name="input" select="../*[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
															</xsl:call-template>
														</DeliveryNoteDate>
													</DeliveryNoteReferences>
													<ProductID>
														<SuppliersProductCode>
															<xsl:value-of select="ProductID/SuppliersProductCode"/>
														</SuppliersProductCode>
													</ProductID>
													<CreditedQuantity>
														<xsl:value-of select="format-number(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000')"/>
													</CreditedQuantity>
													<UnitValueExclVAT>
														<xsl:value-of select="format-number(format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00') div format-number	(concat(substring(InvoicedQuantity,2,11),'.',substring(InvoicedQuantity,13,4)),'0.0000'),'0.0000')"/>
													</UnitValueExclVAT>
													<LineValueExclVAT>
														<xsl:value-of select="format-number(concat(substring(LineValueExclVAT,2,13),'.',substring(LineValueExclVAT,15,2)),'0.00')"/>
													</LineValueExclVAT>
													<VATCode>Z</VATCode>
													<VATRate>0.00</VATRate>
													
												</CreditNoteLine>
											</xsl:for-each>
										</CreditNoteDetail>
									</CreditNote>
									
								</BatchDocument>
								
							</xsl:for-each>
							
						</BatchDocuments>
						
					</Batch>
					
				</Document>
				
			</xsl:for-each>
			
		</BatchRoot>
		
	</xsl:template>
	
	<xsl:template 	name="utcDate">
		<xsl:param name="input"/>
		
		<xsl:value-of select="concat(substring($input,1,4),'-',substring($input,5,2),'-',substring($input,7,2))"/>
		
	</xsl:template>
	
</xsl:stylesheet>
