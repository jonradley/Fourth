<?xml version="1.0" encoding="UTF-8"?>
<!--****************************************************************************************
 Overview


******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name          | Description of modification
******************************************************************************************
 11/02/2009  | R Cambridge 	| 2733 Created (from King:trunk/Stylesheets/tsMapping_Inbound_EANUCC_PurchaseOrder.xsl)
******************************************************************************************
             |               | 
******************************************************************************************
             |               | 
***************************************************************************************-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<BatchRoot>
	            <PurchaseOrder>
			
				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      TRADESIMPLE HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
	                  <TradeSimpleHeader>
				
					<!-- SCR comes from Buyers code for seller if there, else it comes from Seller GLN -->
					<SendersCodeForRecipient>
						<xsl:choose>
							<xsl:when test="/Order/Seller/BuyerAssigned">
								<xsl:value-of select="/Order/Seller/BuyerAssigned"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/Order/Seller/SellerGLN"/>
							</xsl:otherwise>
						</xsl:choose>
					</SendersCodeForRecipient>
					
					<!-- Senders Branch Reference comes from Buyers code for ShipTo if there, else it comes from ShipTo GLN -->
					<!--<SendersBranchReference>
						<xsl:choose>
							<xsl:when test="/Order/ShipTo/BuyerAssigned">
								<xsl:value-of select="/Order/ShipTo/BuyerAssigned"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/Order/ShipTo/ShipToGLN"/>
							</xsl:otherwise>
						</xsl:choose>			
					</SendersBranchReference>-->
					
					<!-- SendersName, Address1 - 4 and PostCode will be populated by subsequent processors -->
		
					<!-- Recipients Code for Sender, Recipients Branch Reference, Name, Address1 - 4, PostCode and testflag are populated by subsequent 	processors -->
					
					<!-- TestFlag is populated by subsequent processors -->
					
				</TradeSimpleHeader>
				
				<!-- ~~~~~~~~~~~~~~~~~~~~~~~
				      PURCHASE ORDER HEADER
				      ~~~~~~~~~~~~~~~~~~~~~~~ -->
				<PurchaseOrderHeader>
					
					<!-- DocumentStatus always Original as copies are invalid-->
					<DocumentStatus>
						<xsl:text>Original</xsl:text>
					</DocumentStatus>
					
					<Buyer>
						<BuyersLocationID>
							<GLN>
								<xsl:value-of select="/Order/Buyer/BuyerGLN"/>
							</GLN>
							
							<xsl:if test="string(/Order/Buyer/BuyerAssigned) != ''">
								<BuyersCode>
									<xsl:value-of select="/Order/Buyer/BuyerAssigned"/>
								</BuyersCode>
							</xsl:if>
							
							<xsl:if test="string(/Order/Buyer/SellerAssigned) != ''">	
								<SuppliersCode>
									<xsl:value-of select="/Order/Buyer/SellerAssigned"/>
								</SuppliersCode>
							</xsl:if>
						</BuyersLocationID>
						
						<!-- Buyers name and address will be populated by the in-filler -->
					</Buyer>
				
					<Supplier>
						<SuppliersLocationID>
							<GLN>
								<xsl:value-of select="/Order/Seller/SellerGLN"/>
							</GLN>
	
							<xsl:if test="string(/Order/Seller/BuyerAssigned) != ''">
								<BuyersCode>
									<xsl:value-of select="/Order/Seller/BuyerAssigned"/>
								</BuyersCode>
							</xsl:if>						
							
							<xsl:if test="string(/Order/Seller/SellerAssigned) != ''">
								<SuppliersCode>
									<xsl:value-of select="/Order/Seller/SellerAssigned"/>
								</SuppliersCode>
							</xsl:if>						
						</SuppliersLocationID>
					
						<!-- Suppliers name and address will be populated by the in-filler -->
					</Supplier>
		
					<ShipTo>
						<ShipToLocationID>
							<GLN>
								<xsl:value-of select="/Order/ShipTo/ShipToGLN"/>
							</GLN>
							
							<xsl:if test="string(/Order/ShipTo/BuyerAssigned) != ''">
								<BuyersCode>
									<xsl:value-of select="/Order/ShipTo/BuyerAssigned"/>
								</BuyersCode>
							</xsl:if>
							
							<xsl:if test="string(/Order/ShipTo/SellerAssigned) != ''">
								<SuppliersCode>
									<xsl:value-of select="/Order/ShipTo/SellerAssigned"/>
								</SuppliersCode>
							</xsl:if>
						</ShipToLocationID>		
						
						<!-- ShipTo name and address will be populated by the in-filler -->
					</ShipTo>
	
					<PurchaseOrderReferences>
						<PurchaseOrderReference>
							<xsl:value-of select="/Order/OrderDocumentDetails/PurchaseOrderNumber"/>
						</PurchaseOrderReference>
						
						<PurchaseOrderDate>
							<xsl:value-of select="substring-before(/Order/OrderDocumentDetails/PurchaseOrderDate,'T')"/>
						</PurchaseOrderDate>
						
						<PurchaseOrderTime>
							<xsl:value-of select="substring-after(/Order/OrderDocumentDetails/PurchaseOrderDate,'T')"/>
						</PurchaseOrderTime>
						
						<xsl:if test="/Order/TradeAgreementReference">
							<TradeAgreement>
								<ContractReference>
									<xsl:value-of select="/Order/TradeAgreementReference/ContractReferenceNumber"/>
								</ContractReference>
		
								<ContractDate>
									<xsl:value-of select="substring-before(/Order/TradeAgreementReference/ContractReferenceDate, 'T')"/>
								</ContractDate>
							</TradeAgreement>
						</xsl:if>
						
						<xsl:if test="string(Order/OrderDocumentDetails/CustomerReference) != ''">
							<CustomerPurchaseOrderReference>
								<xsl:value-of select="Order/OrderDocumentDetails/CustomerReference"/>
							</CustomerPurchaseOrderReference>					
						</xsl:if>
					</PurchaseOrderReferences>
				
					<OrderedDeliveryDetails>
						
						<!-- we try to get the movement type. We default to Delivery if we do not find it or it is not the only other valid value of 200, 'Collect' -->											<DeliveryType>
							<xsl:choose>
								<xsl:when test="/Order/MovementType = '200'">
									<xsl:text>Collect</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>Delivery</xsl:text>							
								</xsl:otherwise>
							</xsl:choose>
						</DeliveryType>					
						
						<DeliveryDate>
							<xsl:value-of select="substring-before(Order/MovementDateTime, 'T')"/>
						</DeliveryDate>
						
						<xsl:if test="/Order/SlotTime">
							<DeliverySlot>
								<SlotStart>
									<xsl:value-of select="substring-after(Order/SlotTime/SlotStartTime, 'T')"/>
								</SlotStart>
		
								<SlotEnd>
									<xsl:value-of select="substring-after(Order/SlotTime/SlotEndTime, 'T')"/>
								</SlotEnd>
							</DeliverySlot>
						</xsl:if>
						
						<xsl:if test="string(/Order/SpecialDeliveryRequirements) != ''">
							<SpecialDeliveryInstructions>
								<xsl:value-of select="/Order/SpecialDeliveryRequirements"/>
							</SpecialDeliveryInstructions>
						</xsl:if>
					</OrderedDeliveryDetails>
				</PurchaseOrderHeader>
				
				<PurchaseOrderDetail>
				
					<xsl:for-each select="/Order/OrderDetails">
						<PurchaseOrderLine>
							
							<LineNumber>
								<xsl:value-of select="LineItemNumber"/>
							</LineNumber>
							
							<ProductID>
								<xsl:if test="string(ItemIdentification/GTIN) != ''">
									<GTIN>
										<xsl:value-of select="ItemIdentification/GTIN"/>
									</GTIN>
								</xsl:if>
								
								<xsl:if test="string(ItemIdentification/AlternateCode) != ''">
									<BuyersProductCode>
										<xsl:value-of select="ItemIdentification/AlternateCode"/>
									</BuyersProductCode>
								</xsl:if>
							</ProductID>
						
							<!-- Product Description is populated by subsequent processors -->
						
							<OrderedQuantity>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="RequestedQuantity/@unitCode"/>
								</xsl:attribute>
								
								<xsl:value-of select="format-number(RequestedQuantity, '0.000')"/>
							</OrderedQuantity>
	
							<!-- Pack Size is populated by subsequent processors -->
						
						</PurchaseOrderLine>
					</xsl:for-each>
				</PurchaseOrderDetail>
				
				<PurchaseOrderTrailer>
					<NumberOfLines>
						<xsl:value-of select="/Order/DocumentLineItemCount"/>
					</NumberOfLines>
				</PurchaseOrderTrailer>
			</PurchaseOrder>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>