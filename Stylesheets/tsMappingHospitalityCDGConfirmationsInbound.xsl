<?xml version="1.0" encoding="UTF-8"?>
<!--
'**************************************************************************************************************************************************************
' Module History
'**************************************************************************************************************************************************************
' Date             | Name              | Description of modification
'**************************************************************************************************************************************************************
' 18/06/2009  | Moty Dimant		| Copied across from RoadPro mapper. Swaps round supplier's product code and buyer's product code.
'**************************************************************************************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>
	<xsl:template match="/biztalk_1/header"/>
	<xsl:template match="/biztalk_1/body">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<PurchaseOrderConfirmation>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="//Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderConfirmationHeader>
								<xsl:if test="//Supplier/SupplierReferences/GLN !='' or //Supplier/SupplierReferences/BuyersCodeForSupplier !=''">
									<Supplier>
										<SuppliersLocationID>
											<xsl:if test="//Supplier/SupplierReferences/GLN !=''">
												<GLN><xsl:value-of select="//Supplier/SupplierReferences/GLN"/></GLN>
											</xsl:if>
											<xsl:if test="//Supplier/SupplierReferences/BuyersCodeForSupplier !=''">
												<BuyersCode><xsl:value-of select="//Supplier/SupplierReferences/BuyersCodeForSupplier"/></BuyersCode>
											</xsl:if>
										</SuppliersLocationID>
									</Supplier>
								</xsl:if>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="//OrderReferences/BuyersOrderNumber"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="substring-before(//OrderDate,'T')"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="//OrderReferences/BuyersOrderNumber"/>
									</PurchaseOrderConfirmationReference>
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="substring-before(//OrderDate,'T')"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>				
							</PurchaseOrderConfirmationHeader>
							<PurchaseOrderConfirmationDetail>
								<xsl:for-each select="//OrderLine">
									<PurchaseOrderConfirmationLine>
										<LineNumber>
											<xsl:value-of select="LineNumber"/>
										</LineNumber>
										<ProductID>
											<xsl:if test="Product/BuyersProductCode !=''">
												<SuppliersProductCode>
													<xsl:value-of select="Product/BuyersProductCode "/>
												</SuppliersProductCode>	
											</xsl:if>
											<xsl:if test="Product/SuppliersProductCode!=''">										
												<BuyersProductCode>
													<xsl:value-of select="Product/SuppliersProductCode"/>
												</BuyersProductCode>	
											</xsl:if>									
										</ProductID>
										<ProductDescription>
											<xsl:value-of select="Product/Description"/>
										</ProductDescription>
										<ConfirmedQuantity>
											<xsl:value-of select="Quantity/Amount"/>
										</ConfirmedQuantity>
										<UnitValueExclVAT>
											<xsl:value-of select="Price/UnitPrice"/>
										</UnitValueExclVAT>
										<LineValueExclVAT>
											<xsl:value-of select="LineTotal"/>
										</LineValueExclVAT>
									</PurchaseOrderConfirmationLine>
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>
							<PurchaseOrderConfirmationTrailer>
								<NumberOfLines>
									<xsl:value-of select="//OrderLine[last()]/LineNumber"/>
								</NumberOfLines>
								<TotalExclVAT>
									<xsl:value-of select="//OrderTotal/GoodsValue"/>
								</TotalExclVAT>
							</PurchaseOrderConfirmationTrailer>
						</PurchaseOrderConfirmation>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
