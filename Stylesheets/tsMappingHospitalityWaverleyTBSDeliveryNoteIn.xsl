<!--******************************************************************
Alterations
**********************************************************************
Name				| Date				| Change
**********************************************************************
K Oshaughnessy| 2010-10-27		| 3450
**********************************************************************
R Cambridge		| 2011-07-26		| 4632 Added supplier's code for buyer (to allow tsProcessorHosptransSBR to remove SBR when required)
**********************************************************************
M Emanuel		| 2012-08-14		|	Copied Delivery Note Mapper for Waverley TBS
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	xmlns:deliver="urn:ean.ucc:deliver:2" 
	xmlns:eanucc="urn:ean.ucc:2" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	exclude-result-prefixes="sh deliver eanucc">

	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/entityIdentification"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/entityIdentification"/>
	<xsl:template match="/sh:StandardBusinessDocument/eanucc:message/eanucc:transaction/command/eanucc:documentCommand">
	
	
		<xsl:variable name="sResponseType" select="string(@responseStatusType)"/>
		
		<BatchRoot>
			
			<Batch>
		
				<BatchDocuments>
				
					<BatchDocument DocumentTypeNo="7">
					
						<DeliveryNote>
						
							<TradeSimpleHeader>
							
								<SendersCodeForRecipient>
									<xsl:choose>
									
										<xsl:when test="documentCommandOperand/deliver:despatchAdvice/receiver/additionalPartyIdentification/additionalPartyIdentificationValue !=''">
											<xsl:value-of select="documentCommandOperand/deliver:despatchAdvice/receiver/additionalPartyIdentification/additionalPartyIdentificationValue"/>
										</xsl:when>		
												
									</xsl:choose>						
								</SendersCodeForRecipient>

							</TradeSimpleHeader>
							
							<DeliveryNoteHeader>
								
								<Buyer>
									<BuyersLocationID>
										<GLN>
											<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier[1]"/>
										</GLN>
										<SuppliersCode>
											<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"/>
										</SuppliersCode>

									</BuyersLocationID>
								</Buyer>

								<Supplier>
									<SuppliersLocationID>
										<xsl:for-each select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier[1]">
											<GLN><xsl:value-of select="."/></GLN>
										</xsl:for-each>
										
										<SuppliersCode>
											<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/>
										</SuppliersCode>

									</SuppliersLocationID>
								</Supplier>
								
								<ShipTo>
									<ShipToLocationID>
										<xsl:for-each select="documentCommandOperand/deliver:despatchAdvice/shipTo/additionalPartyIdentification[additionalPartyIdentificationType='SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue[1]">
											<xsl:if test=". != ''">
												<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
											</xsl:if>
										</xsl:for-each>
									</ShipToLocationID>
								</ShipTo>
		
								
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="substring-before(documentCommandOperand/deliver:despatchAdvice/orderIdentification/referenceDateTime,'T')"/></PurchaseOrderDate>
									<PurchaseOrderTime><xsl:value-of select="substring-after(documentCommandOperand/deliver:despatchAdvice/orderIdentification/referenceDateTime,'T')"/></PurchaseOrderTime>
								</PurchaseOrderReferences>
								
								
								<DeliveryNoteReferences>
									
									<DeliveryNoteReference>
										<xsl:value-of select="documentCommandOperand/deliver:despatchAdvice/deliveryNote/referenceIdentification"/>
									</DeliveryNoteReference>
									
									<DeliveryNoteDate>
									<xsl:value-of select="substring-before(documentCommandOperand/deliver:despatchAdvice/deliveryNote/referenceDateTime,'T')"/>
									</DeliveryNoteDate>
								
								</DeliveryNoteReferences>
								
								<DeliveredDeliveryDetails>
									<DeliveryDate><xsl:value-of select="substring-before(documentCommandOperand/deliver:despatchAdvice/estimatedDelivery/estimatedDeliveryDateTime,'T')"/></DeliveryDate>
								</DeliveredDeliveryDetails>
								
							</DeliveryNoteHeader>
							
							<DeliveryNoteDetail>
								
								<xsl:for-each select ="documentCommandOperand/deliver:despatchAdvice/despatchItem">
							
									<DeliveryNoteLine>
										
										<ProductID>
											<GTIN>
												<xsl:choose>
													<xsl:when test="tradeItemUnit/itemContained/containedItemIdentification/gtin !=''">
														<xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/gtin"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>55555555555555</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</GTIN>
											<SuppliersProductCode>
												<xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue[1]"/>
											</SuppliersProductCode>
											<BuyersProductCode>
												<xsl:value-of select="tradeItemUnit/itemContained/containedItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue[1]"/>
											</BuyersProductCode>
										</ProductID>
										
										<DespatchedQuantity>
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
