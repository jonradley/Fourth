<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2009
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 						|	Description of modification
==========================================================================================
 09/05/2011| K Oshaughnessy			|	Created module 
==========================================================================================
				|							|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/Invoice">
		<Invoice>
		
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="ShipTo/SellerAssigned"/>
				</SendersCodeForRecipient>
				
				<SendersName>
					<xsl:value-of select="Seller/Address/BuildingIdentifier"/>
				</SendersName>
				
				<RecipientsCodeForSender>xx</RecipientsCodeForSender>
	
				<RecipientsName>
					<xsl:value-of select="Buyer/BuyerAssigned"/>
				</RecipientsName>
				
				<TestFlag>1</TestFlag>
			</TradeSimpleHeader>
			
			<InvoiceHeader>
			
				<DocumentStatus>
					<xsl:text>Original</xsl:text>
				</DocumentStatus>
				
				<Buyer>
					<BuyersLocationID>
						<GLN>
							<xsl:value-of select="Buyer/BuyerGLN"/>
						</GLN>
						<BuyersCode>
							<xsl:value-of select="Buyer/BuyerAssigned"/>
						</BuyersCode>
						<SuppliersCode>
							<xsl:value-of select="Buyer/SellerAssigned"/>
						</SuppliersCode>
					</BuyersLocationID>
					<BuyersName>
						<xsl:value-of select="Buyer/BuyerAssigned"/>
					</BuyersName>
				</Buyer>
				
				<Supplier>
					<SuppliersLocationID>
						<GLN>
							<xsl:value-of select="Seller/SellerGLN"/>
						</GLN>
						<BuyersCode>xx</BuyersCode>
						<SuppliersCode>
							<xsl:value-of select="Seller/SellerAssigned"/>
						</SuppliersCode>
					</SuppliersLocationID>
					<SuppliersName>
						<xsl:value-of select="Seller/SellerAssigned"/>
					</SuppliersName>
				</Supplier>
				
				<ShipTo>
					<ShipToLocationID>
						<BuyersCode>
							<xsl:value-of select="ShipTo/BuyerAssigned"/>
						</BuyersCode>
						<SuppliersCode>
							<xsl:value-of select="ShipTo/SellerAssigned"/>
						</SuppliersCode>
					</ShipToLocationID>
				</ShipTo>
				
				<InvoiceReferences>
					<InvoiceReference>
						<xsl:value-of select="InvoiceDocumentDetails/InvoiceDocumentNumber"/>
					</InvoiceReference>
					<InvoiceDate>
						<xsl:value-of select="substring-before(//InvoiceDocumentDetails/InvoiceDocumentDate,'T')"/>
					</InvoiceDate>
					<TaxPointDate>
						<xsl:value-of select="substring-before(//InvoiceDocumentDetails/InvoiceDocumentDate,'T')"/>
					</TaxPointDate>
					<VATRegNo>
						<xsl:value-of select="Seller/VATRegisterationNumber"/>
					</VATRegNo>
				</InvoiceReferences>
			</InvoiceHeader>
			
			
			<InvoiceDetail>
			
				<xsl:for-each select="InvoiceItem">
					<InvoiceLine>
						<LineNumber>
							<xsl:value-of select="LineItemNumber"/>
						</LineNumber>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="../OrderReference/PurchaseOrderNumber"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="substring-before(../OrderReference/PurchaseOrderDate,'T')"/>
							</PurchaseOrderDate>
							<PurchaseOrderTime>
								<xsl:value-of select="substring-after(../OrderReference/PurchaseOrderDate,'T')"/>
							</PurchaseOrderTime>
						</PurchaseOrderReferences>
						<DeliveryNoteReferences>
							<DeliveryNoteReference>
								<xsl:value-of select="../DespatchReference/DespatchDocumentNumber"/>
							</DeliveryNoteReference>
							<DeliveryNoteDate>
								<xsl:value-of select="substring-before(../DespatchReference/DespatchDocumentDate,'T')"/>
							</DeliveryNoteDate>
							<DespatchDate>
								<xsl:value-of select="substring-before(../DespatchReference/DespatchDocumentDate,'T')"/>
							</DespatchDate>
						</DeliveryNoteReferences>
						<ProductID>
							<SuppliersProductCode>
								<xsl:value-of select="ItemIdentifier/AlternateCode"/>
							</SuppliersProductCode>
						</ProductID>
						<InvoicedQuantity>
							<xsl:attribute name="UnitOfMeasure">
								<xsl:value-of select="InvoiceQuantity/@unitCode"/>
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
							<xsl:call-template name="VATCode">
								<xsl:with-param name="sInput" select="VATDetails/TaxCategory"/>
							</xsl:call-template>
						</VATCode>
						<VATRate>
							<xsl:value-of select="VATDetails/TaxRate"/>
						</VATRate>
					</InvoiceLine>
				</xsl:for-each>
					
			</InvoiceDetail>
						
			<InvoiceTrailer>
				<NumberOfLines>
					<xsl:value-of select="count(InvoiceItem)"/>
				</NumberOfLines>
				<NumberOfItems>
					<xsl:value-of select="count(InvoiceItem/LineItemNumber/@scheme)"/>
				</NumberOfItems>
				
				<VATSubTotals>
					<xsl:for-each select="InvoiceTotals/VATRateTotals">
						<VATSubTotal><xsl:attribute name="VATCode"><xsl:call-template name="VATCode"><xsl:with-param name="sInput" select="/Invoice/InvoiceTotals/VATRateTotals/VATDetails/TaxCategory"/></xsl:call-template></xsl:attribute><xsl:attribute name="VATRate"><xsl:value-of select="VATDetails/TaxRate"/></xsl:attribute>
							<NumberOfLinesAtRate>
								<xsl:choose>
									<xsl:when test="//InvoiceItem/VATDetails/TaxCategory=//VATDetails/TaxCategory">
										<xsl:value-of select="count(/Invoice/InvoiceItem)"/>
									</xsl:when>
								</xsl:choose>
							</NumberOfLinesAtRate>
							<NumberOfItemsAtRate>
								<xsl:choose>
									<xsl:when test="//InvoiceItem/VATDetails/TaxCategory=//VATDetails/TaxCategory">
										<xsl:value-of select="count(//InvoiceItem/LineItemNumber)"/>
									</xsl:when>
								</xsl:choose>
							</NumberOfItemsAtRate>
							<DiscountedLinesTotalExclVATAtRate>
								<xsl:value-of select="DiscountedLineTotals"/>
							</DiscountedLinesTotalExclVATAtRate>
							<DocumentDiscountAtRate>
								<xsl:value-of select="DocumentDiscountValue"/>
							</DocumentDiscountAtRate>
							<DocumentTotalExclVATAtRate>
								<xsl:value-of select="/Invoice/InvoiceTotals/InvoiceSubTotal"/>
							</DocumentTotalExclVATAtRate>
							<SettlementDiscountAtRate>
								<xsl:value-of select="SettlementDiscountValue"/>
							</SettlementDiscountAtRate>
							<VATAmountAtRate>
								<xsl:value-of select="VATPayable"/>
							</VATAmountAtRate>
							<DocumentTotalInclVATAtRate>
								<xsl:value-of select="/Invoice/InvoiceTotals/TotalPayable"/>
							</DocumentTotalInclVATAtRate>
						</VATSubTotal>
					</xsl:for-each>
				</VATSubTotals>
				
				<DocumentTotalExclVAT>
					<xsl:value-of select="/Invoice/InvoiceTotals/InvoiceSubTotal"/>
				</DocumentTotalExclVAT>
				<VATAmount>
					<xsl:value-of select="InvoiceTotals/VATTotal"/>
				</VATAmount>
				<DocumentTotalInclVAT>
					<xsl:value-of select="InvoiceTotals/TotalPayable"/>
				</DocumentTotalInclVAT>
			</InvoiceTrailer>
		</Invoice>
	</xsl:template>
	
	<xsl:template name="VATCode">
		<xsl:param name="sInput"/>
			<xsl:choose>
				<xsl:when test="$sInput = 'C'">Z</xsl:when>
				<xsl:when test="$sInput = 'E'">Z</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/Invoice/InvoiceItem/VATDetails/TaxCategory"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
