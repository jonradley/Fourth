<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2007-10-17		| 1332 Created Modele
**********************************************************************
R Cambridge	| 2007-11-13		| 1332 no info to populate Buyer tag
**********************************************************************
R Cambrdige	| 2008-03-27		| 2099 Logistics delivery reference should be the PO number 
												 (Because DN ref on electronic copy will never match paper copy)
**********************************************************************
Lee Boyton	| 2008-07-18		| 2358 Use the buyer's code for shipto if the seller's code is missing.				
**********************************************************************
R Cambridge	| 2009-07-02	  	| 2980 Ensure PL account codes are captured         
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	xmlns:deliver="urn:ean.ucc:deliver:2" 
	xmlns:eanucc="urn:ean.ucc:2" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader ../Schemas/sbdh/StandardBusinessDocumentHeader.xsd urn:ean.ucc:2 ../Schemas/DespatchAdviceProxy.xsd"
	exclude-result-prefixes="sh deliver eanucc">
	<xsl:output method="xml" encoding="UTF-8" />
	
	
	<xsl:template match="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/entityIdentification"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/entityIdentification"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandHeader"/>

	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/deliver:despatchAdvice">
	
		<xsl:variable name="sResponseType" select="string(@responseStatusType)"/>
		
		<BatchRoot>
			
			<Batch>
		
				<BatchDocuments>
				
					<BatchDocument DocumentTypeNo="7">
					
						<DeliveryNote>
						
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:choose>
										<xsl:when test="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1] != ''">
											<xsl:value-of select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
										</xsl:otherwise>
									</xsl:choose>									
								</SendersCodeForRecipient>
								
								<xsl:for-each select="shipFrom/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
									<SendersBranchReference>
										<xsl:value-of select="."/>
									</SendersBranchReference>
								</xsl:for-each>								
								
							</TradeSimpleHeader>
							
							<DeliveryNoteHeader>
								
								<Buyer>
									<BuyersLocationID>
										<xsl:for-each select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier[1]">
											<GLN><xsl:value-of select="."/></GLN>
										</xsl:for-each>
										<xsl:for-each select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier[1]">
											<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
										</xsl:for-each>
									</BuyersLocationID>
								</Buyer>

								<Supplier>
									<SuppliersLocationID>
										<xsl:for-each select="shipper/gln">
											<GLN><xsl:value-of select="."/></GLN>
										</xsl:for-each>
										<xsl:for-each select="shipper/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
											<BuyersCode><xsl:value-of select="."/></BuyersCode>
										</xsl:for-each>
									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<xsl:for-each select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
											<BuyersCode><xsl:value-of select="."/></BuyersCode>
										</xsl:for-each>
										<xsl:for-each select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
											<xsl:if test=". != ''">
												<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
											</xsl:if>
										</xsl:for-each>
									</ShipToLocationID>
								</ShipTo>
		
								
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="orderIdentification/referenceIdentification"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="substring-before(orderIdentification/referenceDateTime,'T')"/></PurchaseOrderDate>
									<PurchaseOrderTime><xsl:value-of select="substring-after(orderIdentification/referenceDateTime,'T')"/></PurchaseOrderTime>
								</PurchaseOrderReferences>
								
								
								<DeliveryNoteReferences>
									
									<!-- 2099 Logistics delivery reference should be PO ref -->
									<DeliveryNoteReference>
										<xsl:choose>
											<xsl:when test="shipper/gln='5036036000030'">
												<xsl:value-of select="orderIdentification/referenceIdentification"/>
											</xsl:when>												
											<xsl:otherwise>
												<xsl:value-of select="deliveryNote/referenceIdentification"/>
											</xsl:otherwise>	
										</xsl:choose>
									</DeliveryNoteReference>
									
									<DeliveryNoteDate><xsl:value-of select="substring-before(deliveryNote/referenceDateTime,'T')"/></DeliveryNoteDate>
								
								</DeliveryNoteReferences>
								
								<DeliveredDeliveryDetails>
									<DeliveryDate><xsl:value-of select="substring-before(estimatedDelivery/estimatedDeliveryDateTime,'T')"/></DeliveryDate>
								</DeliveredDeliveryDetails>
								
							</DeliveryNoteHeader>
							
							<DeliveryNoteDetail>
							
								<xsl:for-each select ="despatchItem">
							
									<DeliveryNoteLine>
										
										<ProductID>
											<GTIN><xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/gtin"/></GTIN>
											<SuppliersProductCode><xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/></SuppliersProductCode>
											<!--BuyersProductCode><xsl:value-of select=""/></BuyersProductCode-->
										</ProductID>
										
										
										<xsl:for-each select="tradeItemUnit/itemContained/containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue[1]">
											<ProductDescription>
												<xsl:value-of select="."/>
											</ProductDescription>
										</xsl:for-each>
										
										<DespatchedQuantity>
										
											<xsl:attribute name="UnitOfMeasure">
												<xsl:call-template name="transUoM">
													<xsl:with-param name="brakesUoM" select="tradeItemUnit/itemContained/quantityContained/measurementValue/@unitOfMeasure"/>
												</xsl:call-template>
											</xsl:attribute>
											
											<xsl:value-of select="tradeItemUnit/itemContained/quantityContained/measurementValue/value"/>
											
										</DespatchedQuantity>
										
									</DeliveryNoteLine>
									
								</xsl:for-each>
								
							</DeliveryNoteDetail>
							
						</DeliveryNote>
						
					</BatchDocument>
					
				</BatchDocuments>		
		
			</Batch>
			
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

</xsl:stylesheet>
