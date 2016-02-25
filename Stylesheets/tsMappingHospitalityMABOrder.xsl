<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
                              xmlns:eanucc="urn:ean.ucc:2" 
                              xmlns:order="urn:ean.ucc:order:2"
                              exclude-result-prefixes="xsl fo sh eanucc order">
	<xsl:template match="sh:StandardBusinessDocument">
	
		<BatchRoot>
		
			<PurchaseOrder>
			
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient>
						<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/seller/gln"/>
					</SendersCodeForRecipient>
				
				</TradeSimpleHeader>
				
				<PurchaseOrderHeader>

					<ShipTo>
					
						<ShipToLocationID>

							<BuyersCode>
								<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
							</BuyersCode>

							<SuppliersCode>
								<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification[additionalPartyIdentificationType = 'BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY']/additionalPartyIdentificationValue"/>
							</SuppliersCode>

						</ShipToLocationID>

					</ShipTo>

					<PurchaseOrderReferences>
					
						<PurchaseOrderReference>
							<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderIdentification/uniqueCreatorIdentification"/>
						</PurchaseOrderReference>
						
						<xsl:variable name="sPODateTime">
							<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/@creationDateTime"/>
						</xsl:variable>

						<PurchaseOrderDate>
							<xsl:value-of select="substring-before($sPODateTime,'T')"/>
						</PurchaseOrderDate>
						
						<PurchaseOrderTime>
							<xsl:value-of select="substring-after($sPODateTime,'T')"/>
						</PurchaseOrderTime>
					
					</PurchaseOrderReferences>
					
					<OrderedDeliveryDetails>
						
						<DeliveryDate>
							<xsl:value-of select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/orderLogisticalDateGroup/requestedDeliveryDateAtUltimateConsignee/date"/>
						</DeliveryDate>
						
					</OrderedDeliveryDetails>
					
					
				</PurchaseOrderHeader>
				
				<PurchaseOrderDetail>
				
					<xsl:for-each select="eanucc:message/eanucc:transaction/command/eanucc:documentCommand/documentCommandOperand/order:order/orderLineItem">
					
						<PurchaseOrderLine>
						
							<LineNumber>
								<xsl:value-of select="@number"/>
							</LineNumber>
							
								<ProductID>
								
									<GTIN>
										<xsl:value-of select="tradeItemIdentification/gtin"/>
									</GTIN>
									
									<SuppliersProductCode>
										<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType = 'SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
									</SuppliersProductCode>
									
									<xsl:if test="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType = 'BUYER_ASSIGNED']/additionalTradeItemIdentificationValue != ''">
										<BuyersProductCode>
											<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType = 'BUYER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
										</BuyersProductCode>
									</xsl:if>
									
								</ProductID>
								
								<ProductDescription>Not Provided</ProductDescription>
								
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
									<xsl:value-of select="requestedQuantity"/>
								</OrderedQuantity> 
								<!--PackSize/-->
								<UnitValueExclVAT>0.00</UnitValueExclVAT>
								<LineValueExclVAT>0.00</LineValueExclVAT>
								<!--OrderedDeliveryDetailsLineLevel>
									<DeliveryDate/>
									<DeliverySlot>
										<SlotStart/>
										<SlotEnd/>
									</DeliverySlot>
								</OrderedDeliveryDetailsLineLevel-->
								<!--LineExtraData/-->

						</PurchaseOrderLine>
					
					</xsl:for-each>
				
				</PurchaseOrderDetail>
			
			</PurchaseOrder>
		
		</BatchRoot>
	
	</xsl:template>
</xsl:stylesheet>
