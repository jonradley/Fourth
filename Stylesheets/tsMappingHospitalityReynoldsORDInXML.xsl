<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	xmlns:deliver="urn:ean.ucc:deliver:2" 
	xmlns:eanucc="urn:ean.ucc:2" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	exclude-result-prefixes="sh deliver eanucc"
	xmlns:order="urn:ean.ucc:order:2">
	
<xsl:output method="xml"/>
<xsl:template match="StandardBusinessDocument/StandardBusinessDocumentHeader"/>
<xsl:template match="StandardBusinessDocument/message">
<BatchRoot>
	<PurchaseOrder >
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="documentCommand/documentCommandOperand/order/orderPartyInformation/seller/additionalPartyIdentification/additionalPartyIdentificationValue"/>
			</SendersCodeForRecipient>
		</TradeSimpleHeader>
		
		<PurchaseOrderHeader>
		
			<DocumentStatus>
			<xsl:choose>
				<xsl:when test="/documentCommand/documentCommandOperand/order/@documentStatus = 'ORIGINAL'">
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
							<xsl:when test="documentCommand/documentCommandOperand/order/orderPartyInformation/buyer/gln">
								<xsl:value-of select="documentCommand/documentCommandOperand/order/orderPartyInformation/buyer/gln"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>5555555555555</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</GLN>
				<SuppliersCode>
					<xsl:value-of select="documentCommand/documentCommandOperand/order/orderPartyInformation/seller/additionalPartyIdentification/additionalPartyIdentificationValue"/>
				</SuppliersCode>
				</BuyersLocationID>
			</Buyer>
			
			<Supplier>
				<SuppliersLocationID>
					<GLN>
						<xsl:value-of select="documentCommand/documentCommandOperand/order/orderPartyInformation/seller/gln"/>
					</GLN>
				</SuppliersLocationID>
				<SuppliersName>
					<xsl:value-of select="/StandardBusinessDocument/StandardBusinessDocumentHeader/Receiver/Identifier"/>
				</SuppliersName>
			</Supplier>
			
			<ShipTo>
				<ShipToLocationID>
					<GLN>
					<xsl:choose>
						<xsl:when test="documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/gln">
							<xsl:value-of select="documentCommand/documentCommandOperand/order:order/orderLogisticalInformation/shipToLogistics/shipTo/gln"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>5555555555555</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					</GLN>
					<BuyersCode>
						<xsl:value-of select="documentCommand/documentCommandOperand/order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification/additionalPartyIdentificationValue"/>
					</BuyersCode>
					<SuppliersCode>
						<xsl:value-of select="documentCommand/documentCommandOperand/order/orderPartyInformation/buyer/additionalPartyIdentification/additionalPartyIdentificationValue"/>
					</SuppliersCode>
				</ShipToLocationID>
			</ShipTo>
			
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
				<xsl:value-of select="documentCommand/documentCommandOperand/order/orderIdentification/uniqueCreatorIdentification"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:value-of select="substring-before(documentCommand/documentCommandOperand/order/@creationDateTime,'T')"/>
				</PurchaseOrderDate>
				<PurchaseOrderTime>
					<xsl:value-of select="substring(substring-after(documentCommand/documentCommandOperand/order/@creationDateTime,'T'),1,8)"/>
				</PurchaseOrderTime>
			</PurchaseOrderReferences>
			
			<OrderedDeliveryDetails>
				<DeliveryDate>
					<xsl:value-of select="documentCommand/documentCommandOperand/order/orderLogisticalInformation/orderLogisticalDateGroup/requestedDeliveryDate/date"/>
				</DeliveryDate>
			</OrderedDeliveryDetails>
			
			<HeaderExtraData>
				<RouteNumber><xsl:value-of select="documentCommand/documentCommandOperand/order/orderLogisticalInformation/shipToLogistics/shipTo/additionalPartyIdentification/additionalPartyIdentificationValue"/></RouteNumber>
			</HeaderExtraData>
			
		</PurchaseOrderHeader>
		
		<PurchaseOrderDetail>
		<xsl:for-each select="/StandardBusinessDocument/message/documentCommand/documentCommandOperand/order/orderLineItem">
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
				<xsl:attribute name="UnitOfMeasure">
					<xsl:call-template name="decodeUoM">
						<xsl:with-param name="input">
							<xsl:value-of select="requestedQuantity/unitOfMeasure/measurementUnitCodeValue"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:attribute>
					<xsl:value-of select="requestedQuantity/value"/>
				</OrderedQuantity>
			</PurchaseOrderLine>
		</xsl:for-each>
		</PurchaseOrderDetail>
		
		<PurchaseOrderTrailer>
			<NumberOfLines>
				<xsl:value-of select="count(/StandardBusinessDocument/message/documentCommand/documentCommandOperand/order/orderLineItem)"/>
			</NumberOfLines>
		</PurchaseOrderTrailer>
	</PurchaseOrder>
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
