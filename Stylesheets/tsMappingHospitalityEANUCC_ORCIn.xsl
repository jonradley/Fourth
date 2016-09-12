<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
Maps EANUCC XML Confirmations to internal XML 
******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name				| Description of modification
******************************************************************************************
 11/06/2016  	| M Dimant	   	| Created.     
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns:cc="http://www.ean-ucc.org/2002/gsmp/schemas/CoreComponents" 

				exclude-result-prefixes="script cc msxsl ">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/">

		<BatchRoot>
		
			<Batch>
			
			
				<BatchDocuments>
					<BatchDocument>
					
						<xsl:attribute name="DocumentTypeNo">3</xsl:attribute>
						
						<PurchaseOrderConfirmation>
						
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							      TRADESIMPLE HEADER
							      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<TradeSimpleHeader>
							
								<!-- SCR comes from Sellers code for Buyer if there, else it comes from Buyer GLN -->
								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="/OrderConfirmation/ShipTo/SellerAssigned">
											<xsl:value-of select="/OrderConfirmation/ShipTo/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/OrderConfirmation/ShipTo/ShipToGLN"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>
								
								
								<xsl:choose>
									<xsl:when test="/OrderConfirmation/TradeAgreementReference/ContractReferenceNumber  != '' ">
										<SendersBranchReference>
											<xsl:value-of select="/OrderConfirmation/TradeAgreementReference/ContractReferenceNumber"/>
										</SendersBranchReference>
									</xsl:when>
									
									<xsl:otherwise/>
									
								</xsl:choose>

												
							</TradeSimpleHeader>
								
								
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							      PURCHASE ORDER ACKNOWLEDGEMENT HEADER
							      ~~~~~~~~~~~~~~~~~~~~~~~ -->
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
										
										<xsl:if test="/OrderConfirmation/Buyer/BuyerAssigned and /OrderConfirmation/Buyer/BuyerAssigned !=''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										
										<xsl:if test="/OrderConfirmation/Buyer/SellerAssigned and /OrderConfirmation/Buyer/SellerAssigned !='' ">	
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
				
										<xsl:if test="/OrderConfirmation/Seller/BuyerAssigned and /OrderConfirmation/Seller/BuyerAssigned !=''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>						
										
										<xsl:if test="/OrderConfirmation/Seller/SellerAssigned and and /OrderConfirmation/Seller/SellerAssigned !=''">
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
										
										<xsl:if test="/OrderConfirmation/ShipTo/BuyerAssigned and /OrderConfirmation/ShipTo/BuyerAssigned !=''">
											<BuyersCode>
												<xsl:value-of select="/OrderConfirmation/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										
										<xsl:if test="/OrderConfirmation/ShipTo/SellerAssigned and /OrderConfirmation/ShipTo/SellerAssigned !=''">
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
									
									<xsl:if test="OrderConfirmation/OrderConfirmationDocumentDetails/CustomerReference">
										<CustomerPurchaseOrderReference>
											<xsl:value-of select="/OrderConfirmation/OrderConfirmationDocumentDetails/CustomerReference"/>
										</CustomerPurchaseOrderReference>
									</xsl:if>
								</PurchaseOrderReferences>
								
								<PurchaseOrderConfirmationReferences>
									<xsl:if test="string(/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationNumber) != ''">
										<PurchaseOrderConfirmationReference>
											<xsl:value-of 	select="/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationNumber"/>
										</PurchaseOrderConfirmationReference>
									</xsl:if>
								
									<xsl:if test="substring-before(/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationDate, 'T') != ''">
										<PurchaseOrderConfirmationDate>
											<xsl:value-of select="substring-before(/OrderConfirmation/OrderConfirmationDocumentDetails/PurchaseOrderConfirmationDate, 'T')"/>				
										</PurchaseOrderConfirmationDate>
									</xsl:if>
									
								</PurchaseOrderConfirmationReferences>		
								
								<OrderedDeliveryDetails>
				
									<!-- we try to get the movement type. We default to Delivery if we do not find it or it is not the only other valid value of 200, 	'Collect' -->
									<DeliveryType>
										<xsl:choose>
											<xsl:when test="/OrderConfirmation/MovementType = '200'">
												<xsl:text>Collect</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Delivery</xsl:text>							
											</xsl:otherwise>
										</xsl:choose>
									</DeliveryType>						
								
									<xsl:if test="substring-before(/OrderConfirmation/MovementDateTime, 'T') != ''">
										<DeliveryDate>
											<xsl:value-of select="substring-before(/OrderConfirmation/MovementDateTime, 'T')"/>
										</DeliveryDate>							
									</xsl:if>
									
									<xsl:if test="/OrderConfirmation/SlotTime">
										<DeliverySlot>
											<SlotStart>
												<xsl:value-of select="substring-after(/OrderConfirmation/SlotTime/SlotStartTime, 'T')"/>
											</SlotStart>						
										
											<SlotEnd>
												<xsl:value-of select="substring-after(/OrderConfirmation/SlotTime/SlotEndTime, 'T')"/>
											</SlotEnd>
										</DeliverySlot>
									</xsl:if>
										
									<xsl:if test="/OrderConfirmation/SpecialDeliveryRequirements">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="/OrderConfirmation/SpecialDeliveryRequirements"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</OrderedDeliveryDetails>
							</PurchaseOrderConfirmationHeader>
							<PurchaseOrderConfirmationDetail>
								<xsl:for-each select="OrderConfirmation/OrderDetails">
									<PurchaseOrderConfirmationLine>
										<ProductID>
											<SuppliersProductCode><xsl:value-of select="ItemIdentification/AlternateCode"/></SuppliersProductCode>
										</ProductID>
										<ConfirmedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="RequestedQuantity/@unitCode"/></xsl:attribute>
											<xsl:value-of select="RequestedQuantity"/>
										</ConfirmedQuantity>						
									</PurchaseOrderConfirmationLine>
								</xsl:for-each>
							</PurchaseOrderConfirmationDetail>			
						</PurchaseOrderConfirmation>
					</BatchDocument>	
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
			
	</xsl:template>
</xsl:stylesheet>