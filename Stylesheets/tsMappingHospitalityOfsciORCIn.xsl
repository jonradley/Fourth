<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Maps OFSCI Purchase Order Confirmations into tradesimple internal format

******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name				| Description of modification
******************************************************************************************
 06/08/2014  	| M Dimant 	| 7748: Created
******************************************************************************************

******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/">

		<BatchRoot>		
			<Batch>			
				<BatchDocuments>
					<BatchDocument>
						<xsl:attribute name="DocumentTypeNo">3</xsl:attribute>						
						<PurchaseOrderConfirmation>
							<TradeSimpleHeader>		
								<SendersCodeForRecipient>			
									<xsl:value-of select="/OrderConfirmation/ShipTo/SellerAssigned"/>								
								</SendersCodeForRecipient>								
								<xsl:if test="/OrderConfirmation/TradeAgreementReference/ContractReferenceNumber != '' ">
									<SendersBranchReference>
										<xsl:value-of select="/OrderConfirmation/TradeAgreementReference/ContractReferenceNumber"/>
									</SendersBranchReference>
								</xsl:if>								
								<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors -->					
								<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode and testflag are populated by 	subsequent processors -->								
								<!-- TestFlag is populated by subsequent processors -->												
							</TradeSimpleHeader>															
							<PurchaseOrderConfirmationHeader>				
								<!-- DocumentStatus is always Original as copies are invalid-->
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>								
								<Buyer>
									<BuyersLocationID>										
										<xsl:if test="string(/OrderConfirmation/Buyer/BuyerGLN) != ''">
											<GLN>
												<xsl:value-of select="/OrderConfirmation/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>										
										<xsl:if test="/OrderConfirmation/Buyer/BuyerAssigned != ''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>										
										<xsl:if test="/OrderConfirmation/Buyer/SellerAssigned != ''">	
											<SuppliersCode>
												<xsl:value-of select="/OrderConfirmation/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>									
									<!-- Buyers name and address will be populated by the in-filler -->
								</Buyer>								
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="/OrderConfirmation/Seller/SellerGLN"/>
										</GLN>				
										<xsl:if test="/OrderConfirmation/Seller/BuyerAssigned != ''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>										
										<xsl:if test="/OrderConfirmation/Seller/SellerAssigned != ''">
											<SuppliersCode>
												<xsl:value-of select="/OrderConfirmation/Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>						
									</SuppliersLocationID>								
									<!-- Suppliers name and address will be populated by the in-filler -->
								</Supplier>								
								<ShipTo>
									<ShipToLocationID>
										<GLN>
											<xsl:value-of select="/OrderConfirmation/ShipTo/ShipToGLN"/>
										</GLN>										
										<xsl:if test="/OrderConfirmation/ShipTo/BuyerAssigned != ''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>										
										<xsl:if test="/OrderConfirmation/ShipTo/SellerAssigned != ''">
											<SuppliersCode>
												<xsl:value-of select="/OrderConfirmation/ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>		
								</ShipTo>												
								<PurchaseOrderReferences>				
									<PurchaseOrderReference>
										<xsl:value-of select="/OrderConfirmation/OrderReference/PurchaseOrderNumber"/>
									</PurchaseOrderReference>									
									<xsl:if test="substring-before(/OrderConfirmation/OrderReference/PurchaseOrderDate,'T') != ''">								
										<PurchaseOrderDate>
											<xsl:value-of select="substring-before(/OrderConfirmation/OrderReference/PurchaseOrderDate,'T')"/>
										</PurchaseOrderDate>
									</xsl:if>									
									<xsl:if test="substring-after(/OrderConfirmation/OrderReference/PurchaseOrderDate,'T') != ''">
										<PurchaseOrderTime>
											<xsl:value-of select="substring-after(/OrderConfirmation/OrderReference/PurchaseOrderDate,'T')"/>
										</PurchaseOrderTime>	
									</xsl:if>		
									
									<xsl:if test="/OrderConfirmation/TradeAgreementReference">
										<TradeAgreement>
											<ContractReference>
												<xsl:value-of select="/OrderConfirmation/TradeAgreementReference/ContractReferenceNumber"/>
											</ContractReference>
					
											<xsl:if test="substring-before	(/OrderConfirmation/TradeAgreementReference/ContractReferenceDate, 'T') !='' ">
												<ContractDate>
													<xsl:value-of select="substring-before	(/OrderConfirmation/TradeAgreementReference/ContractReferenceDate, 'T')"/>
												</ContractDate>
											</xsl:if>											
										</TradeAgreement>
									</xsl:if>
									
									<xsl:if test="OrderConfirmation/OrderConfirmationDetails/CustomerReference">
										<CustomerPurchaseOrderReference>
											<xsl:value-of select="/OrderConfirmation/OrderConfirmationDetails/CustomerReference"/>
										</CustomerPurchaseOrderReference>
									</xsl:if>
								</PurchaseOrderReferences>
								
								<PurchaseOrderConfirmationReferences>
									<xsl:if test="string(/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationNumber) != ''">
										<PurchaseOrderConfirmationReference>
											<xsl:value-of 	select="/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationNumber"/>
										</PurchaseOrderConfirmationReference>
									</xsl:if>								
									<xsl:if test="substring-before(/OrderConfirmation/OrderConfirmationDetails/PurchaseOrderConfirmationDate, 'T') != ''">
										<PurchaseOrderConfirmationDate>
											<xsl:value-of select="substring-before(/OrderConfirmation/OrderConfirmationDetails/PurchaseOrderConfirmationDate, 'T')"/>				
										</PurchaseOrderConfirmationDate>
									</xsl:if>									
								</PurchaseOrderConfirmationReferences>		
								
								<xsl:if test="substring-before(/OrderConfirmation/SupplierConfirmationDate/ConfirmedMovementDateTime, 'T') != ''">
								<ConfirmedDeliveryDetails>
									<DeliveryDate>
										<xsl:value-of select="substring-before(/OrderConfirmation/SupplierConfirmationDate/ConfirmedMovementDateTime, 'T')"/>	
									</DeliveryDate>
								</ConfirmedDeliveryDetails>
								</xsl:if>					
										
							</PurchaseOrderConfirmationHeader>					
						
							
							<PurchaseOrderConfirmationDetail>
								<xsl:for-each select="OrderConfirmation/OrderDetails">							
								<PurchaseOrderConfirmationLine>									
										<ProductID>
											<GTIN><xsl:value-of select="GTIN"/></GTIN>
											<SuppliersProductCode><xsl:value-of select="AlternateCode"/></SuppliersProductCode>
										</ProductID>	
										<ConfirmedQuantity>
											<xsl:attribute name="UnitOfMeasure">
												<xsl:value-of select="RequestedQuantity/@unitCode"/>
											</xsl:attribute>
											<xsl:value-of select="RequestedQuantity"/>											
										</ConfirmedQuantity>
									</PurchaseOrderConfirmationLine>														
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>	
							
							<PurchaseOrderConfirmationTrailer>
								<NumberOfLines>
									<xsl:value-of select="/OrderConfirmation/DocumentLineItemCount"/>
								</NumberOfLines>
							</PurchaseOrderConfirmationTrailer>
																	
						</PurchaseOrderConfirmation>
					</BatchDocument>	
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
			
	</xsl:template>
</xsl:stylesheet>