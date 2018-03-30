<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************************
Maps Mitchell & Butler OFSCII XML Delivery Notes into internal format
******************************************************************************************************
Name			| Date				| Change
******************************************************************************************************
M Dimant		| 01-05-2013		|  5948: Created Module
******************************************************************************************************
  
******************************************************************************************************
		
***************************************************************************************************-->
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
										<xsl:when test="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1] != ''">
											<xsl:value-of select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]"/>
										</xsl:otherwise>
									</xsl:choose>									
								</SendersCodeForRecipient>
																
								<SendersBranchReference>
									<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/>
								</SendersBranchReference>
															
								
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
										
											<!-- Tradeteam product code should be GTIN -->
											<SuppliersProductCode>
												<xsl:choose> 
													<xsl:when test="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier='1000017'">
														<xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/gtin"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
													</xsl:otherwise>
												</xsl:choose>
											</SuppliersProductCode>
										</ProductID>										
										
						
										<DespatchedQuantity>										
											<xsl:attribute name="UnitOfMeasure">
												<xsl:call-template name="transUoM">
													<xsl:with-param name="mbUoM" select="tradeItemUnit/itemContained/quantityContained/measurementValue/@unitOfMeasure"/>
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
		<xsl:param name="mbUoM"/>
	
		<xsl:choose>
			<xsl:when test="$mbUoM = 'EA'">EA</xsl:when>
			<xsl:when test="$mbUoM = 'UN'">CS</xsl:when>
			<xsl:when test="$mbUoM = 'KG'">KGM</xsl:when>
			<xsl:when test="$mbUoM = 'KGM'">KGM</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

</xsl:stylesheet>