<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2007-07-26		| 1332 Created Modele
**********************************************************************
R Cambridge	| 2007-11-13		| 1332 no info to populate Buyer tag
**********************************************************************
R Cambridge	| 2008-01-03		| 1686 revised rejection codes
**********************************************************************
				|						|
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	xmlns:order="urn:ean.ucc:order:2" 
	xmlns:eanucc="urn:ean.ucc:2" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader ../Schemas/sbdh/StandardBusinessDocumentHeader.xsd urn:ean.ucc:2 ../Schemas/OrderResponseProxy.xsd"
	exclude-result-prefixes="sh order eanucc">
	<xsl:output method="xml" encoding="UTF-8" />
	
	
	<xsl:template match="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/entityIdentification"/>

	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/order:orderResponse">
	
		<xsl:variable name="sResponseType" select="string(@responseStatusType)"/>
		
		<BatchRoot>
	
			<PurchaseOrderConfirmation>
				
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
					</SendersCodeForRecipient>
					
					<SendersBranchReference>
						<xsl:value-of select="seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
					</SendersBranchReference>
					
				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>
					
					<!--Buyer>
						<BuyersLocationID>
							<xsl:for-each select="buyer/gln[1]">
								<GLN><xsl:value-of select="."/></GLN>
							</xsl:for-each>
							<xsl:for-each select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<BuyersCode><xsl:value-of select="."/></BuyersCode>
							</xsl:for-each>
							<xsl:for-each select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
							</xsl:for-each>
						</BuyersLocationID>
					</Buyer-->
					
					<Supplier>
						<SuppliersLocationID>
							<xsl:for-each select="seller/gln[1]">
								<GLN><xsl:value-of select="."/></GLN>
							</xsl:for-each>
							<xsl:for-each select="seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<BuyersCode><xsl:value-of select="."/></BuyersCode>
							</xsl:for-each>
							<!--SuppliersCode/-->
						</SuppliersLocationID>
					</Supplier>
					
					<ShipTo>
						<ShipToLocationID>
							<xsl:for-each select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<BuyersCode><xsl:value-of select="."/></BuyersCode>
							</xsl:for-each>
							<xsl:for-each select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
							</xsl:for-each>
						</ShipToLocationID>
					</ShipTo>
					
					<PurchaseOrderReferences>
						<PurchaseOrderReference><xsl:value-of select="responseToOriginalDocument/@referenceIdentification"/></PurchaseOrderReference>
						<PurchaseOrderDate><xsl:value-of select="substring-before(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderDate>
						<PurchaseOrderTime><xsl:value-of select="substring-after(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderTime>
					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
						<PurchaseOrderConfirmationReference><xsl:value-of select="responseToOriginalDocument/@referenceIdentification"/></PurchaseOrderConfirmationReference>
						<PurchaseOrderConfirmationDate><xsl:value-of select="substring-before(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderConfirmationDate>
					</PurchaseOrderConfirmationReferences>
					
					<xsl:for-each select="orderModification/amendedDateTimeValue/requestedDeliveryDate[1]">
						
						<ConfirmedDeliveryDetails>
							<DeliveryDate><xsl:value-of select="date"/></DeliveryDate>
							<!--DeliveryTime><xsl:value-of select="time"/></DeliveryTime-->
						</ConfirmedDeliveryDetails>
					
					</xsl:for-each>
					
					<!--SequenceNumber/-->
					
					<HeaderExtraData>
					
						<xsl:choose>
							
							<xsl:when test="$sResponseType = 'ACCEPTED'">
								<ImplicitLinesStatus>						
									<xsl:attribute name="LineNarrative"/>
									<xsl:text>Accepted</xsl:text>
								</ImplicitLinesStatus>
							</xsl:when>
							
							<xsl:when test="$sResponseType = 'REJECTED'">
								<ImplicitLinesStatus>
									<xsl:attribute name="LineNarrative">
										<xsl:call-template name="transReasonCode">
											<xsl:with-param name="brakesReasonCode" select="orderResponseReasonCode"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:text>Rejected</xsl:text>
								</ImplicitLinesStatus>						
							</xsl:when>
							
							<xsl:when test="$sResponseType = 'MODIFIED'">
								<ImplicitLinesStatus>
									<xsl:attribute name="LineNarrative">
										<xsl:call-template name="transReasonCode">
											<xsl:with-param name="brakesReasonCode" select="orderResponseReasonCode"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:text>Accepted</xsl:text>
								</ImplicitLinesStatus>						
							</xsl:when>
							
							<xsl:otherwise>
								<ImplicitLinesStatus>
									<xsl:attribute name="LineNarrative">
										<xsl:call-template name="transReasonCode">
											<xsl:with-param name="brakesReasonCode" select="orderResponseReasonCode"/>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:text>Unrecognised lines status code recieved from Brake Bros system</xsl:text>
								</ImplicitLinesStatus>
							</xsl:otherwise>
		
						</xsl:choose>
	
					
					</HeaderExtraData>
					
				</PurchaseOrderConfirmationHeader>
				
				<PurchaseOrderConfirmationDetail>
				
					
				
					<xsl:choose>
						
						<xsl:when test="$sResponseType = 'ACCEPTED'">
							<!-- HeaderExtraData/ImplicitLinesStatus will cause tsProcessorHospInFiller to add order lines omitted as 'Accepted' -->
						</xsl:when>
						
						<xsl:when test="$sResponseType = 'REJECTED'">
							<!-- HeaderExtraData/ImplicitLinesStatus will cause tsProcessorHospInFiller to add order lines omitted as 'Rejected' -->					
						</xsl:when>
						
						<xsl:otherwise>
						
							<xsl:for-each select="orderModification/orderModificationLineItemLevel">
							
								<PurchaseOrderConfirmationLine>
									<xsl:attribute name="LineStatus">
										<xsl:choose>
											<xsl:when test="number(modifiedOrderInformation/requestedQuantity/value) = 0">Rejected</xsl:when>
											<xsl:otherwise>Changed</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								
									<xsl:choose>
									
										<xsl:when test="substituteItemIdentification">
										
											<ProductID>
												<GTIN><xsl:value-of select="modifiedOrderInformation/tradeItemIdentification/gtin"/></GTIN>
												<SuppliersProductCode><xsl:value-of select="modifiedOrderInformation/tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
												<xsl:for-each select="modifiedOrderInformation/tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue">
													<BuyersProductCode><xsl:value-of select="."/></BuyersProductCode>
												</xsl:for-each>
											</ProductID>
											
											<SubstitutedProductID>
												<GTIN><xsl:value-of select="substituteItemIdentification/gtin"/></GTIN>
												<SuppliersProductCode><xsl:value-of select="substituteItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
												<xsl:for-each select="substituteItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue">
													<BuyersProductCode><xsl:value-of select="."/></BuyersProductCode>
												</xsl:for-each>
											</SubstitutedProductID>
										
										</xsl:when>
										
										<xsl:otherwise>
										
											<ProductID>
												<GTIN><xsl:value-of select="modifiedOrderInformation/tradeItemIdentification/gtin"/></GTIN>
												<SuppliersProductCode><xsl:value-of select="modifiedOrderInformation/tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
												<!-- buyer's code contains description -->
											</ProductID>
										
										</xsl:otherwise>									
									
									</xsl:choose>								
								
								
									<xsl:for-each select="modifiedOrderInformation/tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue[.!=''][1]">
										<ProductDescription><xsl:value-of select="."/></ProductDescription>
									</xsl:for-each>
																	
									
									<!--OrderedQuantity><xsl:value-of select="modifiedOrderInformation/requestedQuantity/value"/></OrderedQuantity-->
									
									<ConfirmedQuantity>
									
										<xsl:attribute name="UnitOfMeasure">										
											<xsl:call-template name="transUoM">
												<xsl:with-param name="brakesUoM" select="modifiedOrderInformation/requestedQuantity/unitOfMeasure/measurementUnitCodeValue"/>
											</xsl:call-template>
										</xsl:attribute>
										
										<xsl:value-of select="modifiedOrderInformation/requestedQuantity/value"/>
										
									</ConfirmedQuantity>
									
									<!--PackSize/>
									<UnitValueExclVAT/>
									<LineValueExclVAT/-->
									
									<xsl:variable name="reasonCode">
										<xsl:call-template name="transReasonCode">
											<xsl:with-param name="brakesReasonCode" select="orderResponseReasonCode"/>
										</xsl:call-template>									
									</xsl:variable>
									
									<xsl:if test="$reasonCode != ''">
									
										<Narrative>
											<xsl:value-of select="$reasonCode"/>
										</Narrative>
										
									</xsl:if>
									
									<!--LineExtraData/-->
									
								</PurchaseOrderConfirmationLine>

							</xsl:for-each>
	
						</xsl:otherwise>
	
					</xsl:choose>
				
				
				</PurchaseOrderConfirmationDetail>
				
			</PurchaseOrderConfirmation>	

		</BatchRoot>
	
	</xsl:template>

	<xsl:template name="transUoM">
		<xsl:param name="brakesUoM"/>
	
		<xsl:choose>
			<xsl:when test="$brakesUoM = 'EA'">EA</xsl:when>
			<xsl:when test="$brakesUoM = 'UN'">CS</xsl:when>
			<xsl:when test="$brakesUoM = 'KG'">KGM</xsl:when>
			<xsl:when test="$brakesUoM = 'KGM'">KGM</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<xsl:template name="transReasonCode">
		<xsl:param name="brakesReasonCode"/>
	
		<xsl:choose>
			
			<!-- translations, as specified by Kewill to Food Partners -->
			<xsl:when test="$brakesReasonCode = 'CUSTOMER_IDENTIFICATION_NUMBER_IS_MISSING'">Customer identification number is missing</xsl:when>
			<xsl:when test="$brakesReasonCode = 'CUSTOMER_IDENTIFICATION_NUMBER_IS_INVALID'">Customer identification number is invalid</xsl:when>
			<xsl:when test="$brakesReasonCode = 'INVALID_DATE'">Invalid date</xsl:when>
			<xsl:when test="$brakesReasonCode = 'DELIVERY_SLOT_NOT_VALID_FOR_LOCATION'">Delivery slot not valid for location</xsl:when>
			<xsl:when test="$brakesReasonCode = 'MISSING_MESSAGE_REFERENCE_NUMBER'">Missing message reference number</xsl:when>
			<xsl:when test="$brakesReasonCode = 'SENDER_NOT_AUTHORIZED_FOR_THIS_MESSAGE'">Sender not authorized for this message	</xsl:when>
			<xsl:when test="$brakesReasonCode = 'DISCONTINUED_LINE'">Discontinued line</xsl:when>
			<xsl:when test="$brakesReasonCode = 'ITEM_TEMPORARILY_NOT_AVAILABLE'">Item temporarily not available</xsl:when>
			<xsl:when test="$brakesReasonCode = 'INVALID_PRODUCT_OR_ITEM_IDENTIFICATION'">Invalid product or item identification</xsl:when>
			<xsl:when test="$brakesReasonCode = 'PRODUCT_NOT_VALID_FOR_LOCATION'">Product not valid for location</xsl:when>
			<xsl:when test="$brakesReasonCode = 'RECEIVED_AFTER_CUTOFF_DATE_OR_TIME'">Received after cutoff date or time</xsl:when>
			<xsl:when test="$brakesReasonCode = 'OTHER_UNLISTED_REASON'">Other unlisted reason</xsl:when>
			
			<!-- default -->
			<xsl:otherwise></xsl:otherwise>
			
		</xsl:choose>
	
	</xsl:template>


</xsl:stylesheet>
