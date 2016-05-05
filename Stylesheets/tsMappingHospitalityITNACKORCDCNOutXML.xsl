<?xml version="1.0" encoding="UTF-8"?>
<!--
***************************************************************************************
Generic Ack, Confirmation, Delivery Notes mapper for iTN
***************************************************************************************
Name			| Date 				|	Description
***************************************************************************************
J Miguel		| 15/03/2016	| FB10876 - Created
***************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="fo">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<xsl:template match="PurchaseOrderAcknowledgement | PurchaseOrderConfirmation">
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="PurchaseOrderAcknowledgementHeader">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:when test="PurchaseOrderConfirmationHeader">
					<xsl:text>2</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="header" select="PurchaseOrderAcknowledgementHeader | PurchaseOrderConfirmationHeader"/>
		<ns0:GenericITNSupplierResponse xmlns:ns0="http://itn.hub.biztalk.orderapp.ext.GenericITNSupplier.schemas.OrderResponse">
			<OrderHeader>
				<OrderResponseType>
					<xsl:value-of select="$type"/>
				</OrderResponseType>
				<ItnOrderNumber>
					<xsl:value-of select="$header/PurchaseOrderReferences/PurchaseOrderReference"/>
				</ItnOrderNumber>
				<DeliveryDate>
					<xsl:value-of select="concat($header/OrderedDeliveryDetails/DeliveryDate, 'T00:00:00')"/>
				</DeliveryDate>
				<!-- pending -->
				<ItnOrderStatus>
					<xsl:choose>
						<xsl:when test="$type=1">
							<xsl:text>ACKNOWLEDGED</xsl:text>
						</xsl:when>
						<xsl:when test="$type=2 and count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus='Rejected']) = count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine)">
							<xsl:text>REJECTED</xsl:text>
						</xsl:when>
						<xsl:when test="$type=2 and count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine[@LineStatus='Changed']) > 0">
							<xsl:text>MODIFIED</xsl:text>
						</xsl:when>
						<xsl:when test="$type=2">
							<xsl:text>ACCEPTED</xsl:text>
						</xsl:when>
					</xsl:choose>
				</ItnOrderStatus>
				<OrderValue>
					<xsl:value-of select="PurchaseOrderAcknowledgementTrailer/TotalExclVAT | PurchaseOrderConfirmationTrailer/TotalExclVAT"/>
				</OrderValue>
				<OrderResponseDate>
					<xsl:value-of select="concat($header/PurchaseOrderAcknowledgementReferences/PurchaseOrderAcknowledgementDate | $header/ PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate, 'T00:00:00')"/>
				</OrderResponseDate>
				<SupplierReasonCode/>
				<OriginalOrderCreationDate>
					<xsl:value-of select="concat($header/PurchaseOrderReferences/PurchaseOrderDate, 'T00:00:00')"/>
				</OriginalOrderCreationDate>
				<OriginalOrderLines>
					<xsl:value-of select="PurchaseOrderAcknowledgementTrailer/NumberOfLines | PurchaseOrderConfirmationTrailer/NumberOfLines"/>
				</OriginalOrderLines>
				<CustomerAccountNumber>
					<xsl:value-of select="$header/ShipTo/ShipToLocationID/BuyersCode"/>
				</CustomerAccountNumber>
			</OrderHeader>
			<xsl:apply-templates select="$header/Supplier"/>
			<xsl:apply-templates select="$header/Buyer"/>
			<LineItems>
				<xsl:choose>
					<xsl:when test="$type=1">
						<LineItem/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine"/>
					</xsl:otherwise>
				</xsl:choose>
			</LineItems>
		</ns0:GenericITNSupplierResponse>
	</xsl:template>
	<xsl:template match="Supplier">
		<SupplierDetails>
			<SupplierId>
				<xsl:value-of select="SuppliersLocationID/BuyersCode"/>
			</SupplierId>
			<SupplierGLN>
				<xsl:value-of select="SuppliersLocationID/GLN"/>
			</SupplierGLN>
			<SupplierOrderNumber>
				<xsl:value-of select="../PurchaseOrderReferences/PurchaseOrderReference"/>
			</SupplierOrderNumber>
		</SupplierDetails>
	</xsl:template>
	<xsl:template match="Buyer">
		<BuyerDetails>
			<BuyerGLN>
				<xsl:value-of select="BuyersLocationID/GLN"/>
			</BuyerGLN>
			<ShipToId/>
			<ShipToGLN/>
			<BuyerGroup>
				<BuyerGroupGLN>
					<xsl:value-of select="BuyersLocationID/BuyersCode"/>
				</BuyerGroupGLN>
				<BuyerGroupName>
					<xsl:value-of select="BuyersName"/>
				</BuyerGroupName>
			</BuyerGroup>
		</BuyerDetails>
	</xsl:template>
	<xsl:template match="PurchaseOrderConfirmationLine">
		<LineItem>
			<ProductCode>
				<xsl:value-of select="ProductID/SuppliersProductCode"/>
			</ProductCode>
			<ItnLineNumber>
				<xsl:value-of select="LineNumber"/>
			</ItnLineNumber>
			<Quantity>
				<xsl:value-of select="ConfirmedQuantity"/>
			</Quantity>
			<UnitPrice>
				<xsl:value-of select="UnitValueExclVAT"/>
			</UnitPrice>
			<LinePrice>
				<xsl:value-of select="LineValueExclVAT"/>
			</LinePrice>
			<xsl:choose>
				<xsl:when test="@LineStatus='Changed'">
					<LineStatus>
						<xsl:text>OOS</xsl:text>
					</LineStatus>
				</xsl:when>
				<xsl:when test="@LineStatus='Rejected'">
					<LineStatus>
						<xsl:text>OOS</xsl:text>
					</LineStatus>
				</xsl:when>
				<xsl:when test="@LineStatus='Accepted'">
					<LineStatus>1</LineStatus>
				</xsl:when>
			</xsl:choose>
			<UnitOfMeasure>
				<xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/>
			</UnitOfMeasure>
		</LineItem>
	</xsl:template>
</xsl:stylesheet>
