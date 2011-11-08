<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
H Mahbub   	| 2009-12-08		| 3235 copy of tsMappingHospitalityBrakesOrderConfirmationIn.xsl
**********************************************************************
R Cambridge	| 2010-01-28		| 2325 remove line statuses				
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
						<xsl:value-of select="buyer/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
					</SendersCodeForRecipient>
					
					<xsl:for-each select="seller/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
						<SendersBranchReference>
							<xsl:value-of select="."/>
						</SendersBranchReference>
					</xsl:for-each>
					
					
				</TradeSimpleHeader>
				
				<PurchaseOrderConfirmationHeader>
					
					<Buyer>
						<BuyersLocationID>
							<xsl:for-each select="buyer/gln[1]">
								<GLN><xsl:value-of select="."/></GLN>
							</xsl:for-each>
							<xsl:for-each select="buyer/gln[1]">
								<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
							</xsl:for-each>
						</BuyersLocationID>
					</Buyer>
					
					<Supplier>
						<SuppliersLocationID>
							<xsl:for-each select="seller/gln[1]">
								<GLN><xsl:value-of select="."/></GLN>
							</xsl:for-each>
							<xsl:for-each select="seller/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
								<BuyersCode><xsl:value-of select="."/></BuyersCode>
							</xsl:for-each>
							<SuppliersCode/>
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
									<xsl:text>Unrecognised lines status code received from Brake Bros system</xsl:text>
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
							
							
								<xsl:call-template name="writeConfLine">
								
									<!-- Enteprise won't be sending meaningful line statuses -->
									
									<xsl:with-param name="productID" select="modifiedOrderInformation/tradeItemIdentification"/>
									
									<xsl:with-param name="subProductID" select="substituteItemIdentification"/>
									
									
										
									<xsl:with-param name="quantityOrdered">
										<xsl:if test="substituteItemIdentification">0</xsl:if>
									</xsl:with-param>		
																
									
									<xsl:with-param name="quantityConfirmed">
										<xsl:value-of select="modifiedOrderInformation/requestedQuantity/value"/>
									</xsl:with-param>
									
									<xsl:with-param name="quantityUoM">									
										<xsl:value-of select="modifiedOrderInformation/requestedQuantity/unitOfMeasure/measurementUnitCodeValue"/>
									</xsl:with-param>

									<xsl:with-param name="reasonCode">
									
										<xsl:choose>
										
											<xsl:when test="substituteItemIdentification">Substitute</xsl:when>
											
											<xsl:otherwise>
												<xsl:value-of select="orderResponseReasonCode"/>
											</xsl:otherwise>
										
										</xsl:choose>
									
									</xsl:with-param>								
									
															
								</xsl:call-template>
								

								<xsl:if test="substituteItemIdentification">
								
									<!-- Previous line was an Add, now reject the substituted product -->
									<xsl:call-template name="writeConfLine">
									
										<xsl:with-param name="productID" select="substituteItemIdentification"/>
										
										<xsl:with-param name="subProductID" select="ShouldntMatchAnythingEver"/>
										
										<xsl:with-param name="quantityConfirmed">0</xsl:with-param>
										
										<xsl:with-param name="quantityUoM">
											<xsl:value-of select="modifiedOrderInformation/requestedQuantity/unitOfMeasure/measurementUnitCodeValue"/>
										</xsl:with-param>
										
										<xsl:with-param name="reasonCode">
										  <xsl:value-of select="orderResponseReasonCode"/>
										</xsl:with-param>	
									
									</xsl:call-template>
								
								</xsl:if>
								

							</xsl:for-each>
							
	
						</xsl:otherwise>
						
	
					</xsl:choose>
				
				
				</PurchaseOrderConfirmationDetail>
				
			</PurchaseOrderConfirmation>	

		</BatchRoot>
	
	</xsl:template>
	
	
	<xsl:template name="writeConfLine">
		<xsl:param name="productID"/>
		<xsl:param name="subProductID"/>
		<xsl:param name="quantityOrdered" select="''"/>
		<xsl:param name="quantityConfirmed"/>
		<xsl:param name="quantityUoM"/>
		<xsl:param name="reasonCode"/>
		
	
	
		<PurchaseOrderConfirmationLine>

				
			<ProductID>
				<xsl:if test="string($productID/gtin)!=''">
					<GTIN><xsl:value-of select="$productID/gtin"/></GTIN>
				</xsl:if>
				<SuppliersProductCode><xsl:value-of select="$productID/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
				<xsl:for-each select="$productID/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue[string(.)!='']">
					<BuyersProductCode><xsl:value-of select="."/></BuyersProductCode>
				</xsl:for-each>
			</ProductID>			
			
			<xsl:if test="count($subProductID/*)">
					
				<SubstitutedProductID>
					<GTIN><xsl:value-of select="$subProductID/gtin"/></GTIN>
					<SuppliersProductCode><xsl:value-of select="$subProductID/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
					<xsl:for-each select="$subProductID/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue">
						<BuyersProductCode><xsl:value-of select="."/></BuyersProductCode>
					</xsl:for-each>
				</SubstitutedProductID>
			
			</xsl:if>							
		
			<!--ProductDescription/-->
			<!--OrderedQuantity><xsl:value-of select="modifiedOrderInformation/requestedQuantity/value"/></OrderedQuantity-->
			
			<xsl:if test="$quantityOrdered != ''">
				<OrderedQuantity>
					<xsl:value-of select="$quantityOrdered"/>
				</OrderedQuantity>			
			</xsl:if>
			
			<ConfirmedQuantity>
			
				<xsl:attribute name="UnitOfMeasure">										
					<xsl:call-template name="transUoM">
						<xsl:with-param name="brakesUoM" select="$quantityUoM"/>
					</xsl:call-template>
				</xsl:attribute>
				
				<xsl:value-of select="$quantityConfirmed"/>
				
			</ConfirmedQuantity>
			
			<!--PackSize/>
			<UnitValueExclVAT/>
			<LineValueExclVAT/-->
			
			<xsl:variable name="reasonText">
				<xsl:call-template name="transReasonCode">
					<xsl:with-param name="brakesReasonCode" select="$reasonCode"/>
				</xsl:call-template>									
			</xsl:variable>
			
			<xsl:if test="$reasonText != ''">
			
				<Narrative>
					<xsl:value-of select="$reasonText"/>
				</Narrative>
				
			</xsl:if>
			
			<!--LineExtraData/-->
			
		</PurchaseOrderConfirmationLine>

	
	
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
			
			<!-- translations, as specified by Kewill to Brakes -->
			<xsl:when test="$brakesReasonCode = 'INVALID_BUYER_IDENTIFICATION'">Invalid Customer account number</xsl:when>   
			<xsl:when test="$brakesReasonCode = 'BUSINESS_SCOPE_BLOCK'">Customer account number on stop</xsl:when>
			<xsl:when test="$brakesReasonCode = 'CUSTOMER_IDENTIFICATION_NUMBER_DOES_NOT_EXIST'">Customer account number closed</xsl:when>
			<xsl:when test="$brakesReasonCode = 'DELIVERY_SLOT_NOT_VALID_FOR_LOCATION'">Invalid delivery day is requested</xsl:when>
			<xsl:when test="$brakesReasonCode = 'DELIVERY_SLOT_MISSED'">Request delivery cut-off time is missed</xsl:when>
			<xsl:when test="$brakesReasonCode = 'MISSING_MESSAGE_REFERENCE_NUMBER'">Purchase Order number is missing\invalid</xsl:when>
			<xsl:when test="$brakesReasonCode = 'MISSING_DATA'">Purchase Card number is missing\invalid</xsl:when>
			<xsl:when test="$brakesReasonCode = 'BUSINESS_SCOPE_BLOCK'">Minimum Order Level Not Reached</xsl:when>
			<xsl:when test="$brakesReasonCode = 'INVALID_PRODUCT_OR_ITEM_IDENTIFICATION'">Invalid product code</xsl:when>
			<xsl:when test="$brakesReasonCode = 'ITEM_NOT_AUTHORIZED'">Product not on Agreed Buying List</xsl:when>
			<xsl:when test="$brakesReasonCode = 'PRODUCT_NOT_VALID_FOR_LOCATION'">Product not valid on servicing depot</xsl:when>
			<xsl:when test="$brakesReasonCode = 'DISCONTINUED_LINE'">Product discontinued\not on sale</xsl:when>
			<xsl:when test="$brakesReasonCode = 'PRODUCT_OUT_OF_STOCK'">Product out of stock</xsl:when>
			<xsl:when test="$brakesReasonCode = 'RECEIVED_AFTER_CUTOFF_DATE_OR_TIME'">Product past product cut-off time</xsl:when>
			<xsl:when test="$brakesReasonCode = 'UNAUTHORIZED_BUSINESS_PROCESS_STATE'">Quantity greater than 99</xsl:when>
			
			<!-- default -->
			<xsl:otherwise>
        <xsl:value-of select="$brakesReasonCode"/>
      </xsl:otherwise>
			
		</xsl:choose>
	
	</xsl:template>


</xsl:stylesheet>
