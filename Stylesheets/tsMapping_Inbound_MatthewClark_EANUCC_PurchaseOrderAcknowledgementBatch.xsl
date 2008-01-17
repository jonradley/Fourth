<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview



 © Alternative Business Solutions Ltd., 2007
******************************************************************************************
 Module History
******************************************************************************************
 Date        	| Name				| Description of modification
******************************************************************************************
 11/12/2007  	| R Cambridge   	| 1657 temporary logic for Aramark SBR requirements
******************************************************************************************
             	|               	|          
******************************************************************************************
             	|               	|        
***************************************************************************************-->
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
					
						<xsl:attribute name="DocumentTypeNo">84</xsl:attribute>
						
						<PurchaseOrderAcknowledgement>
						
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							      TRADESIMPLE HEADER
							      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<TradeSimpleHeader>
							
								<!-- SCR comes from Sellers code for Buyer if there, else it comes from Buyer GLN -->
								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="/OrderAcknowledgement/ShipTo/SellerAssigned">
											<xsl:value-of select="/OrderAcknowledgement/ShipTo/SellerAssigned"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="/OrderAcknowledgement/ShipTo/ShipToGLN"/>
										</xsl:otherwise>
									</xsl:choose>
								</SendersCodeForRecipient>
								
								
								<xsl:choose>
									<xsl:when test="/OrderAcknowledgement/TradeAgreementReference/ContractReferenceNumber != '' ">
										<SendersBranchReference>
											<xsl:value-of select="/OrderAcknowledgement/TradeAgreementReference/ContractReferenceNumber"/>
										</SendersBranchReference>
									</xsl:when>
									
									<!--xsl:when test="/OrderAcknowledgement/ShipTo/SellerAssigned = '50377314' or /OrderAcknowledgement/ShipTo/SellerAssigned = '50205796'">
										<SendersBranchReference>1AA</SendersBranchReference>
									</xsl:when-->
									
									<xsl:otherwise/>
									
								</xsl:choose>
								

								
								<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors -->
					
								<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode and testflag are populated by 	subsequent processors -->
								
								<!-- TestFlag is populated by subsequent processors -->
												
							</TradeSimpleHeader>
								
								
							<!-- ~~~~~~~~~~~~~~~~~~~~~~~
							      PURCHASE ORDER ACKNOWLEDGEMENT HEADER
							      ~~~~~~~~~~~~~~~~~~~~~~~ -->
							<PurchaseOrderAcknowledgementHeader>
				
								<!-- DocumentStatus is always Original as copies are invalid-->
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								
								<Buyer>
									<BuyersLocationID>
										
										<xsl:if test="string(/OrderAcknowledgement/Buyer/BuyerGLN) != ''">
											<GLN>
												<xsl:value-of select="/OrderAcknowledgement/Buyer/BuyerGLN"/>
											</GLN>
										</xsl:if>
										
										<xsl:if test="/OrderAcknowledgement/Buyer/BuyerAssigned">
											<BuyersCode>
												<xsl:value-of select="/OrderAcknowledgement/Buyer/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										
										<xsl:if test="/OrderAcknowledgement/Buyer/SellerAssigned">	
											<SuppliersCode>
												<xsl:value-of select="/OrderAcknowledgement/Buyer/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</BuyersLocationID>
									
									<!-- Buyers name and address will be populated by the in-filler -->
								</Buyer>
								
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="/OrderAcknowledgement/Seller/SellerGLN"/>
										</GLN>
				
										<xsl:if test="/OrderAcknowledgement/Seller/BuyerAssigned">
											<BuyersCode>
												<xsl:value-of select="/OrderAcknowledgement/Seller/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>						
										
										<xsl:if test="/OrderAcknowledgement/Seller/SellerAssigned">
											<SuppliersCode>
												<xsl:value-of select="/OrderAcknowledgement/Seller/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>						
									</SuppliersLocationID>
								
									<!-- Suppliers name and address will be populated by the in-filler -->
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<GLN>
											<xsl:value-of select="/OrderAcknowledgement/ShipTo/ShipToGLN"/>
										</GLN>
										
										<xsl:if test="/OrderAcknowledgement/ShipTo/BuyerAssigned">
											<BuyersCode>
												<xsl:value-of select="/OrderAcknowledgement/ShipTo/BuyerAssigned"/>
											</BuyersCode>
										</xsl:if>
										
										<xsl:if test="/OrderAcknowledgement/ShipTo/SellerAssigned">
											<SuppliersCode>
												<xsl:value-of select="/OrderAcknowledgement/ShipTo/SellerAssigned"/>
											</SuppliersCode>
										</xsl:if>
									</ShipToLocationID>		
								</ShipTo>
												
								<PurchaseOrderReferences>
				
									<PurchaseOrderReference>
										<xsl:value-of select="/OrderAcknowledgement/OrderReference/PurchaseOrderNumber"/>
									</PurchaseOrderReference>
									
									<xsl:if test="substring-before(/OrderAcknowledgement/OrderReference/PurchaseOrderDate,'T') != ''">								
										<PurchaseOrderDate>
											<xsl:value-of select="substring-before(/OrderAcknowledgement/OrderReference/PurchaseOrderDate,'T')"/>
										</PurchaseOrderDate>
									</xsl:if>
									
									<xsl:if test="substring-after(/OrderAcknowledgement/OrderReference/PurchaseOrderDate,'T') != ''">
										<PurchaseOrderTime>
											<xsl:value-of select="substring-after(/OrderAcknowledgement/OrderReference/PurchaseOrderDate,'T')"/>
										</PurchaseOrderTime>	
									</xsl:if>			
									
									<xsl:if test="/OrderAcknowledgement/TradeAgreementReference">
										<TradeAgreement>
											<ContractReference>
												<xsl:value-of select="/OrderAcknowledgement/TradeAgreementReference/ContractReferenceNumber"/>
											</ContractReference>
					
											<xsl:if test="substring-before	(/OrderAcknowledgement/TradeAgreementReference/ContractReferenceDate, 'T') !='' ">
												<ContractDate>
													<xsl:value-of select="substring-before	(/OrderAcknowledgement/TradeAgreementReference/ContractReferenceDate, 'T')"/>
												</ContractDate>
											</xsl:if>
											
											
										</TradeAgreement>
									</xsl:if>
									
									<xsl:if test="OrderAcknowledgement/OrderAcknowledgementDetails/CustomerReference">
										<CustomerPurchaseOrderReference>
											<xsl:value-of select="/OrderAcknowledgement/OrderAcknowledgementDetails/CustomerReference"/>
										</CustomerPurchaseOrderReference>
									</xsl:if>
								</PurchaseOrderReferences>
								
								<PurchaseOrderAcknowledgementReferences>
									<xsl:if test="string(/OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementNumber) != ''">
										<PurchaseOrderAcknowledgementReference>
											<xsl:value-of 	select="/OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementNumber"/>
										</PurchaseOrderAcknowledgementReference>
									</xsl:if>
								
									<xsl:if test="substring-before(/OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate, 'T') != ''">
										<PurchaseOrderAcknowledgementDate>
											<xsl:value-of select="substring-before(/OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate, 'T')"/>				
										</PurchaseOrderAcknowledgementDate>
									</xsl:if>
									
								</PurchaseOrderAcknowledgementReferences>		
								
								<OrderedDeliveryDetails>
				
									<!-- we try to get the movement type. We default to Delivery if we do not find it or it is not the only other valid value of 200, 	'Collect' -->
									<DeliveryType>
										<xsl:choose>
											<xsl:when test="/OrderAcknowledgement/MovementType = '200'">
												<xsl:text>Collect</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>Delivery</xsl:text>							
											</xsl:otherwise>
										</xsl:choose>
									</DeliveryType>						
								
									<xsl:if test="substring-before(/OrderAcknowledgement/MovementDateTime, 'T') != ''">
										<DeliveryDate>
											<xsl:value-of select="substring-before(/OrderAcknowledgement/MovementDateTime, 'T')"/>
										</DeliveryDate>							
									</xsl:if>
									
									<xsl:if test="/OrderAcknowledgement/SlotTime">
										<DeliverySlot>
											<SlotStart>
												<xsl:value-of select="substring-after(/OrderAcknowledgement/SlotTime/SlotStartTime, 'T')"/>
											</SlotStart>						
										
											<SlotEnd>
												<xsl:value-of select="substring-after(/OrderAcknowledgement/SlotTime/SlotEndTime, 'T')"/>
											</SlotEnd>
										</DeliverySlot>
									</xsl:if>
										
									<xsl:if test="/OrderAcknowledgement/SpecialDeliveryRequirements">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="/OrderAcknowledgement/SpecialDeliveryRequirements"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</OrderedDeliveryDetails>
							</PurchaseOrderAcknowledgementHeader>				
						</PurchaseOrderAcknowledgement>
					</BatchDocument>	
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
			
	</xsl:template>
</xsl:stylesheet>