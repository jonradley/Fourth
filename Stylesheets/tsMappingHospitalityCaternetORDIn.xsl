<!--======================================================================================
 Overview

 Maps GS1 XML 3.2 to internal XML
 
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date     	 	| Name 					| Description of modification
==========================================================================================
 26/10/2015	| M Dimant			| FB10556: Created module
==========================================================================================
 20/01/2016	| M Dimant			| FB10754: Addition of batch tags and correct supplier's code for buyer
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:deliver="urn:ean.ucc:deliver:2" xmlns:eanucc="urn:ean.ucc:2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="sh deliver eanucc" xmlns:order="urn:ean.ucc:order:2">
	<xsl:output method="xml"/>
	<xsl:template match="sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader"/>
	<xsl:template match="sh:StandardBusinessDocument/eanucc:message">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/seller/additionalPartyIdentification/additionalPartyIdentificationValue"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<PurchaseOrderHeader>
								<DocumentStatus>
									<xsl:choose>
										<xsl:when test="/eanucc:documentCommand/documentCommandOperand/order:order/@documentStatus = 'ORIGINAL'">
											<xsl:text>Original</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Original</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</DocumentStatus>
								<Buyer>
									<BuyersLocationID>
										<GLN>
											<xsl:choose>
												<xsl:when test="eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/buyer/gln">
													<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/buyer/gln"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>5555555555555</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</GLN>
									</BuyersLocationID>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/seller/gln"/>
										</GLN>
									</SuppliersLocationID>
									<SuppliersName>
										<xsl:value-of select="/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader/sh:Receiver/sh:Identifier"/>
									</SuppliersName>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<GLN>
											<xsl:choose>
												<xsl:when test="eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/gln">
													<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/gln"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>5555555555555</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</GLN>
										<BuyersCode>
											<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification/additionalPartyIdentificationValue"/>
										</BuyersCode>
										<SuppliersCode>
											<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderPartyInformation/buyer/additionalPartyIdentification/additionalPartyIdentificationValue"/>
										</SuppliersCode>
									</ShipToLocationID>
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderIdentification/uniqueCreatorIdentification"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="substring-before(eanucc:documentCommand/documentCommandOperand/order:order/@creationDateTime,'T')"/>
									</PurchaseOrderDate>
									<PurchaseOrderTime>
										<xsl:value-of select="substring(substring-after(eanucc:documentCommand/documentCommandOperand/order:order/@creationDateTime,'T'),1,8)"/>
									</PurchaseOrderTime>
								</PurchaseOrderReferences>
								<OrderedDeliveryDetails>
									<DeliveryDate>
										<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/orderLogisticalDateGroup/requestedDeliveryDate/date"/>
									</DeliveryDate>
									<xsl:if test="eanucc:documentCommand/documentCommandOperand/order:order/specialDeliveryNote/text">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/specialDeliveryNote/text"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</OrderedDeliveryDetails>
								<HeaderExtraData>
									<RouteNumber>
										<xsl:value-of select="eanucc:documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification/additionalPartyIdentificationValue"/>
									</RouteNumber>
								</HeaderExtraData>
							</PurchaseOrderHeader>
							<PurchaseOrderDetail>
								<xsl:for-each select="/sh:StandardBusinessDocument/eanucc:message/eanucc:documentCommand/documentCommandOperand/order:order/orderLineItem">
									<PurchaseOrderLine>
										<LineNumber>
											<xsl:value-of select="@number"/>
										</LineNumber>
										<ProductID>
											<GTIN>
												<xsl:choose>
													<xsl:when test="tradeItemIdentification/gtin">
														<xsl:value-of select="tradeItemIdentification/gtin"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>5555555555555</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</GTIN>
											<SuppliersProductCode>
												<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='SUPPLIER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
											</SuppliersProductCode>
										</ProductID>
										<ProductDescription>
											<xsl:value-of select="tradeItemIdentification/additionalTradeItemIdentification[additionalTradeItemIdentificationType='BUYER_ASSIGNED']/additionalTradeItemIdentificationValue"/>
										</ProductDescription>
										<OrderedQuantity>
											<xsl:attribute name="UnitOfMeasure"><xsl:call-template name="decodeUoM"><xsl:with-param name="input"><xsl:value-of select="requestedQuantity/unitOfMeasure/measurementUnitCodeValue"/></xsl:with-param></xsl:call-template></xsl:attribute>
											<xsl:value-of select="requestedQuantity/value"/>
										</OrderedQuantity>
									</PurchaseOrderLine>
								</xsl:for-each>
							</PurchaseOrderDetail>
							<PurchaseOrderTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(/sh:StandardBusinessDocument/eanucc:message/eanucc:documentCommand/documentCommandOperand/order:order/orderLineItem)"/>
								</NumberOfLines>
							</PurchaseOrderTrailer>
						</PurchaseOrder>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<xsl:template name="decodeUoM">
		<xsl:param name="input"/>
		<xsl:choose>
			<xsl:when test="$input = 'KG'">KGM</xsl:when>
			<xsl:when test="$input = 'EA'">EA</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
