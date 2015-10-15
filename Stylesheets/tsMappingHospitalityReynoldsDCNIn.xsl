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
 02/06/2011| K Oshaughnessy			|	Created module 
==========================================================================================
				|							|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="/DespatchAdvice">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>	
						<DeliveryNote>
						
							<TradeSimpleHeader>
							
							<SendersCodeForRecipient>
								<xsl:value-of select="ShipTo/SellerAssigned"/>
							</SendersCodeForRecipient>	
							
							<!-- SBR used to pick out the PL Account code to be used in the trading relationship set up. This could be Buyer or Supplier value. -->
							<xsl:if test="string(/DespatchAdvice/TradeAgreementReference/ContractReferenceNumber) != '' ">
								<SendersBranchReference>
									<xsl:value-of select="/DespatchAdvice/TradeAgreementReference/ContractReferenceNumber"/>
								</SendersBranchReference>
							</xsl:if>					
							<TestFlag>1</TestFlag>
							</TradeSimpleHeader>
							
							<DeliveryNoteHeader>
							
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								
								<Buyer>
									<BuyersLocationID>
										<GLN>
											<xsl:value-of select="Buyer/BuyerGLN"/>
										</GLN>
									</BuyersLocationID>
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="Seller/SellerGLN"/>
										</GLN>
									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode>
											<xsl:value-of select="ShipTo/SellerAssigned"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="OrderReference/PurchaseOrderNumber"/>
									</PurchaseOrderReference>
									
									<PurchaseOrderDate>
										<xsl:value-of select="substring-before(OrderReference/PurchaseOrderDate,'T')"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="OrderConfirmationReference/UniqueCreatorIdentification"/>
									</PurchaseOrderConfirmationReference>
									
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="substring-before(OrderConfirmationReference/CreationDate,'T')"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
								
								<DeliveryNoteReferences>
								
									<DeliveryNoteReference>
										<xsl:value-of select="DespatchAdviceDocumentDetails/DespatchDocumentNumber"/>
									</DeliveryNoteReference>
									
									<DeliveryNoteDate>
										<xsl:value-of select="substring-before(DespatchAdviceDocumentDetails/DespatchDocumentDate,'T')"/>
									</DeliveryNoteDate>
									
									<DespatchDate>
										<xsl:value-of select="substring-before(EstimatedDeliveryDate,'T')"/>
									</DespatchDate>
									
								</DeliveryNoteReferences>
							</DeliveryNoteHeader>
							
							<DeliveryNoteDetail>
							
							<xsl:for-each select="/DespatchAdvice/DespatchItem">
								<DeliveryNoteLine>
									<LineNumber>
										<xsl:value-of select="count(preceding::DespatchItem | self::*)"/>
									</LineNumber>
									<ProductID>
										<SuppliersProductCode>
											<xsl:value-of select="ItemIdentification/GTIN"/>
										</SuppliersProductCode>
									</ProductID>
									<OrderedQuantity>
										<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="RequestedQuantity/@unitCode"/></xsl:attribute>
										<xsl:value-of select="RequestedQuantity"/>
									</OrderedQuantity>
									<DespatchedQuantity>
										<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DespatchedQuantity/@unitCode"/></xsl:attribute>
										<xsl:value-of select="DespatchedQuantity"/>
									</DespatchedQuantity>
								</DeliveryNoteLine>
							</xsl:for-each>	
								
							</DeliveryNoteDetail>
							
							<DeliveryNoteTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(DespatchItem)"/>
								</NumberOfLines>
							</DeliveryNoteTrailer>
							
						</DeliveryNote>
						
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
		
	</xsl:template>
	
</xsl:stylesheet>
