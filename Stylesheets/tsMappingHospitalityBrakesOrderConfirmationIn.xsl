<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2007-07-26		| 1332 Created Modele
**********************************************************************
				|						|
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
	
		<PurchaseOrderConfirmation>
			<TradeSimpleHeader>
				<SendersCodeForRecipient/>
			</TradeSimpleHeader>
			<PurchaseOrderConfirmationHeader>
				<Buyer>
					<BuyersLocationID>
						<GLN><xsl:value-of select="buyer/gln"/></GLN>
						<BuyersCode/>
						<!-- is this correct as following additionalPartyIdentificationType says "BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY" -->
						<SuppliersCode><xsl:value-of select="buyer/additionalPartyIdentification/additionalPartyIdentificationType"/></SuppliersCode>
					</BuyersLocationID>
					<!--BuyersName/>
					<BuyersAddress>
						<AddressLine1/>
						<AddressLine2/>
						<AddressLine3/>
						<AddressLine4/>
						<PostCode/>
					</BuyersAddress-->
				</Buyer>
				<Supplier>
					<SuppliersLocationID>
						<GLN><xsl:value-of select="seller/gln"/></GLN>
						<BuyersCode><xsl:value-of select="seller/additionalPartyIdentification/additionalPartyIdentificationValue"/></BuyersCode>
						<SuppliersCode/>
					</SuppliersLocationID>
					<!--SuppliersName/>
					<SuppliersAddress>
						<AddressLine1/>
						<AddressLine2/>
						<AddressLine3/>
						<AddressLine4/>
						<PostCode/>
					</SuppliersAddress-->
				</Supplier>
				<ShipTo>
					<ShipToLocationID>
						<GLN/>
						<BuyersCode/>
						<SuppliersCode/>
					</ShipToLocationID>
					<ShipToName/>
					<ShipToAddress>
						<AddressLine1/>
						<AddressLine2/>
						<AddressLine3/>
						<AddressLine4/>
						<PostCode/>
					</ShipToAddress>
					<ContactName/>
				</ShipTo>
				<PurchaseOrderReferences>
					<PurchaseOrderReference><xsl:value-of select="responseToOriginalDocument/@referenceIdentification"/></PurchaseOrderReference>
					<PurchaseOrderDate><xsl:value-of select="substring-before(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderDate>
					<PurchaseOrderTime><xsl:value-of select="substring-after(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderTime>
					<!--TradeAgreement>
						<ContractReference/>
						<ContractDate/>
					</TradeAgreement>
					<CustomerPurchaseOrderReference/>
					<JobNumber/-->
				</PurchaseOrderReferences>
				<PurchaseOrderConfirmationReferences>
					<PurchaseOrderConfirmationReference><xsl:value-of select="responseToOriginalDocument/@referenceIdentification"/></PurchaseOrderConfirmationReference>
					<PurchaseOrderConfirmationDate><xsl:value-of select="substring-before(responseToOriginalDocument/@referenceDateTime,'T')"/></PurchaseOrderConfirmationDate>
				</PurchaseOrderConfirmationReferences>
				<!--OrderedDeliveryDetails>
					<DeliveryType/>
					<DeliveryDate/>
					<DeliverySlot>
						<SlotStart/>
						<SlotEnd/>
					</DeliverySlot>
					<DeliveryCutOffDate/>
					<DeliveryCutOffTime/>
					<SpecialDeliveryInstructions/>
				</OrderedDeliveryDetails-->
				
				<xsl:for-each select="orderModification/amendedDateTimeValue/requestedDeliveryDate[1]">
					
					<ConfirmedDeliveryDetails>
						<DeliveryType><xsl:value-of select="date"/></DeliveryType>
						<DeliveryDate><xsl:value-of select="time"/></DeliveryDate>
					</ConfirmedDeliveryDetails>
				
				</xsl:for-each>
				
				<SequenceNumber/>
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
								<xsl:attribute name="LineNarrative"><xsl:value-of select="orderResponseReasonCode"/></xsl:attribute>
								<xsl:text>Rejected</xsl:text>
							</ImplicitLinesStatus>						
						</xsl:when>
	
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
					
						<PurchaseOrderConfirmationLine LineStatus="">
							<LineNumber/>
							<ProductID>
								<GTIN/>
								<SuppliersProductCode/>
								<BuyersProductCode/>
							</ProductID>
							<SubstitutedProductID>
								<GTIN/>
								<SuppliersProductCode/>
								<BuyersProductCode/>
							</SubstitutedProductID>
							<ProductDescription/>
							<OrderedQuantity UnitOfMeasure=""/>
							<ConfirmedQuantity UnitOfMeasure=""/>
							<PackSize/>
							<UnitValueExclVAT/>
							<LineValueExclVAT/>
							<!--OrderedDeliveryDetailsLineLevel>
								<DeliveryDate/>
								<DeliverySlot>
									<SlotStart/>
									<SlotEnd/>
								</DeliverySlot>
							</OrderedDeliveryDetailsLineLevel>
							<ConfirmedDeliveryDetailsLineLevel>
								<DeliveryDate/>
								<DeliverySlot>
									<SlotStart/>
									<SlotEnd/>
								</DeliverySlot>
							</ConfirmedDeliveryDetailsLineLevel-->
							<Narrative Code=""/>
							<LineExtraData/>
						</PurchaseOrderConfirmationLine>

					</xsl:otherwise>

				</xsl:choose>
			
			
			</PurchaseOrderConfirmationDetail>
			
			<!--PurchaseOrderConfirmationTrailer>
				<NumberOfLines/>
				<TotalExclVAT/>
				<TrailerExtraData/>
			</PurchaseOrderConfirmationTrailer-->
			
		</PurchaseOrderConfirmation>	
	
	</xsl:template>

</xsl:stylesheet>
