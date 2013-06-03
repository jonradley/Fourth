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
 21/05/2013  | S Hussain       | Case 6589: Supplier Product Code Formatting + Optimization
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
	
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="84">
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
									
									<xsl:apply-templates select="/OrderAcknowledgement/OrderReference/PurchaseOrderDate"/>
									<xsl:call-template name="FormatTime">
										<xsl:with-param name="ElementName">PurchaseOrderTime</xsl:with-param>
										<xsl:with-param name="Node" select="/OrderAcknowledgement/OrderReference/PurchaseOrderDate"/>
									</xsl:call-template>
									
									<xsl:if test="string(/OrderAcknowledgement/TradeAgreementReference/ContractReferenceNumber) != ''">
										<TradeAgreement>
											<ContractReference>
												<xsl:value-of select="/OrderAcknowledgement/TradeAgreementReference/ContractReferenceNumber"/>
											</ContractReference>
											
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="ElementName">ContractDate</xsl:with-param>
												<xsl:with-param name="Node" select="/OrderAcknowledgement/TradeAgreementReference/ContractReferenceDate"/>
											</xsl:call-template>
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
									
									<xsl:apply-templates select="/OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate" />
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
									
									<xsl:call-template name="FormatDate">
										<xsl:with-param name="ElementName">DeliveryDate</xsl:with-param>
										<xsl:with-param name="Node" select="/OrderAcknowledgement/MovementDateTime"/>
									</xsl:call-template>
									
									<xsl:if test="/OrderAcknowledgement/SlotTime">
										<DeliverySlot>
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="ElementName">SlotStart</xsl:with-param>
												<xsl:with-param name="Node" select="/OrderAcknowledgement/SlotTime/SlotStartTime"/>
											</xsl:call-template>
											<xsl:call-template name="FormatDate">
												<xsl:with-param name="ElementName">SlotEnd</xsl:with-param>
												<xsl:with-param name="Node" select="/OrderAcknowledgement/SlotTime/SlotEndTime"/>
											</xsl:call-template>
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
	
	<xsl:template match="/OrderAcknowledgement/OrderReference/PurchaseOrderDate | /OrderAcknowledgement/OrderAcknowledgementDetails/PurchaseOrderAcknowledgementDate">
		<xsl:if test="substring-before(.,'T') != ''">		
			<xsl:element name="{name()}">
				<xsl:value-of select="substring-before(.,'T')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="FormatTime">
		<xsl:param name="ElementName"/>
		<xsl:param name="Node"/>
		<xsl:if test="substring-after($Node,'T') != ''">		
			<xsl:element name="{$ElementName}">
				<xsl:value-of select="substring-after($Node,'T')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="FormatDate">
		<xsl:param name="ElementName"/>
		<xsl:param name="Node"/>
		<xsl:if test="substring-before($Node,'T') != ''">		
			<xsl:element name="{$ElementName}">
				<xsl:value-of select="substring-before($Node,'T')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>