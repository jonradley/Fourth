<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Overview

 SIBA invoice and confirmation translator
 
 On processing, lines should be grouped by Purchase Order reference.  
 If ALL lines for a Purchase Order Reference have zero Delivered Quantity and no Invoice number then map as a Confirmation
 Otherwise, map as an Invoice
 
 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date 			| Name           | Description of modification
******************************************************************************************
 31/10/2007	| R Cambridge    | 1558 Created Module
******************************************************************************************
 26/02/2008	| M Dimant       | Maps as confirmation when *Delivered* Quantity is zero
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			
			<xsl:if test="/Batch/BatchDocuments/BatchDocument/Invoice[string(InvoiceHeader/InvoiceReferences/InvoiceReference) != '' and sum(InvoiceDetail/InvoiceLine/DeliveredQuantity) != 0]">
			
				<Document>
					<xsl:attribute name="TypePrefix">INV</xsl:attribute>
				
					<Batch>
						<BatchDocuments>				
				
							<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice[string(InvoiceHeader/InvoiceReferences/InvoiceReference) != '' and sum(InvoiceDetail/InvoiceLine/InvoicedQuantity) != 0]">
									
								<BatchDocument>
									<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
									
									<Invoice>
									
										<TradeSimpleHeader>
											<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
										</TradeSimpleHeader>
										
										<InvoiceHeader>
											
											<ShipTo>
												<ShipToLocationID>
													<SuppliersCode><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
												</ShipToLocationID>
												<ShipToName><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></ShipToName>
											</ShipTo>
											
											<InvoiceReferences>
												
												<InvoiceReference><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/></InvoiceReference>
												
												<InvoiceDate>
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
													</xsl:call-template>								
												</InvoiceDate>
												
												<TaxPointDate>
													<xsl:call-template name="formatDate">
														<xsl:with-param name="input" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
													</xsl:call-template>								
												</TaxPointDate>
												
											</InvoiceReferences>
											
										</InvoiceHeader>
										
										<InvoiceDetail>
										
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
											
												<xsl:if test="(LineValueExclVAT) !='0'">
										
													<InvoiceLine>
														<PurchaseOrderReferences>
														
															<PurchaseOrderReference><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderReference>
														
															<PurchaseOrderDate>
																<xsl:call-template name="formatDate">
																	<xsl:with-param name="input" select="PurchaseOrderReferences/PurchaseOrderDate"/>
																</xsl:call-template>										
															</PurchaseOrderDate>
														
														</PurchaseOrderReferences>
													
													
														<xsl:if test="string(DeliveryNoteReferences/DeliveryNoteReference) != '' and string(DeliveryNoteReferences/DeliveryNoteDate) != '' and string(DeliveryNoteReferences/DespatchDate) != ''">
														
															<DeliveryNoteReferences>
															
																<DeliveryNoteReference><xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
															
																<DeliveryNoteDate>										
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="input" select="DeliveryNoteReferences/DeliveryNoteDate"/>
																	</xsl:call-template>										
																</DeliveryNoteDate>
															
																<DespatchDate>
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="input" select="DeliveryNoteReferences/DespatchDate"/>
																	</xsl:call-template>										
																</DespatchDate>
																
															</DeliveryNoteReferences>

														</xsl:if>
													
														<ProductID>
															<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
														</ProductID>
													
														<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
														<DeliveredQuantity><xsl:value-of select="DeliveredQuantity"/></DeliveredQuantity>
														<InvoicedQuantity><xsl:value-of select="InvoicedQuantity"/></InvoicedQuantity>
														<UnitValueExclVAT><xsl:value-of select="UnitValueExclVAT"/></UnitValueExclVAT>
														<LineValueExclVAT><xsl:value-of select="LineValueExclVAT"/></LineValueExclVAT>
													
														<xsl:choose>
															<xsl:when test="VATRate != 0">
																<VATCode>S</VATCode>
																<VATRate>17.5</VATRate>														
															</xsl:when>
															<xsl:otherwise>
																<VATCode>Z</VATCode>
																<VATRate>0</VATRate>
															</xsl:otherwise>
														</xsl:choose>
													
												
													</InvoiceLine>
												</xsl:if>
											</xsl:for-each>
												
										</InvoiceDetail>
									</Invoice>
									
								</BatchDocument>
									
							</xsl:for-each>
				
						</BatchDocuments>
			
					</Batch>
					
				</Document>
	
			
			</xsl:if>
			
			<xsl:if test="/Batch/BatchDocuments/BatchDocument/Invoice[string(InvoiceHeader/InvoiceReferences/InvoiceReference) = '' and sum(InvoiceDetail/InvoiceLine/DeliveredQuantity) = 0]">

			
				<Document>
					<xsl:attribute name="TypePrefix">OCB</xsl:attribute>
					
					
								
						<Batch>
							<BatchDocuments>				
					
								<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/Invoice[string(InvoiceHeader/InvoiceReferences/InvoiceReference) = '' and sum(InvoiceDetail/InvoiceLine/DeliveredQuantity) = 0]">										
									<BatchDocument>
										<xsl:attribute name="DocumentTypeNo">3</xsl:attribute>
										
										<PurchaseOrderConfirmation>
										
											<TradeSimpleHeader>
												<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
											</TradeSimpleHeader>
											
											<PurchaseOrderConfirmationHeader>
												
												<ShipTo>
													<ShipToLocationID>
														<SuppliersCode><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
													</ShipToLocationID>
													<ShipToName><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></ShipToName>
												</ShipTo>
												
												
												<PurchaseOrderReferences>
													
													<PurchaseOrderReference><xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderReference>
													
													<PurchaseOrderDate>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="input" select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/>
														</xsl:call-template>										
													</PurchaseOrderDate>
													
												</PurchaseOrderReferences>												

												
												<PurchaseOrderConfirmationReferences>
													
													<PurchaseOrderConfirmationReference><xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderConfirmationReference>
													
													<PurchaseOrderConfirmationDate>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="input" select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/>
														</xsl:call-template>								
													</PurchaseOrderConfirmationDate>

												</PurchaseOrderConfirmationReferences>
												
											</PurchaseOrderConfirmationHeader>
											
											<PurchaseOrderConfirmationDetail>
											
												<xsl:for-each select="InvoiceDetail/InvoiceLine">
											
													<PurchaseOrderConfirmationLine>
														<xsl:attribute name="LineStatus">Rejected</xsl:attribute>
														
														<ProductID>
															<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
														</ProductID>
														
														<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
														<ConfirmedQuantity>0</ConfirmedQuantity>
														<UnitValueExclVAT><xsl:value-of select="UnitValueExclVAT"/></UnitValueExclVAT>
														<LineValueExclVAT>0.00</LineValueExclVAT>
													
													</PurchaseOrderConfirmationLine>
													
												</xsl:for-each>
													
											</PurchaseOrderConfirmationDetail>
										</PurchaseOrderConfirmation>
										
									</BatchDocument>
										
								</xsl:for-each>
					
							</BatchDocuments>
				
						</Batch>
						
					</Document>

		
			
			</xsl:if>
			
			
		</BatchRoot>
		
	</xsl:template>
	
	
	<xsl:template name="formatDate">
		<xsl:param name="input"/>
	
		<xsl:value-of select="concat(substring($input,7,4),'-',substring($input,4,2),'-',substring($input,1,2))"/>
	
	</xsl:template>
	
	
</xsl:stylesheet>