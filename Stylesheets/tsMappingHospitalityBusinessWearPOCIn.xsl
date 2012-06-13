<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:template match="OrderConfirmation">
<PurchaseOrderConfirmation>
	<TradeSimpleHeaderSent>
		<SendersCodeForRecipient><xsl:value-of select="SendersCodeforUnit" /></SendersCodeForRecipient>
	</TradeSimpleHeaderSent>
	<PurchaseOrderConfirmationHeader>
		<PurchaseOrderReferences>
			<PurchaseOrderReference><xsl:value-of select="PurchaseOrderReference"/></PurchaseOrderReference>
			<PurchaseOrderDate><xsl:value-of select="PurchaseOrderDate"/></PurchaseOrderDate>
		</PurchaseOrderReferences>
		<PurchaseOrderConfirmationReferences>
			<PurchaseOrderConfirmationReference/>
			<PurchaseOrderConfirmationDate/>
		</PurchaseOrderConfirmationReferences>
		<OrderedDeliveryDetails>
			<DeliveryDate><xsl:value-of select="RequiredDeliveryDate"/></DeliveryDate>
		</OrderedDeliveryDetails>
		<ConfirmedDeliveryDetails>
			<DeliveryDate><xsl:value-of select="ConfirmedDeliveryDate"/></DeliveryDate>
		</ConfirmedDeliveryDetails>
	</PurchaseOrderConfirmationHeader>
	<PurchaseOrderConfirmationDetail>
	<xsl:for-each select="DetailLine">
		<PurchaseOrderConfirmationLine>
			<LineNumber><xsl:value-of select="position()"/></LineNumber>
			<ProductID>
				<SuppliersProductCode><xsl:value-of select="SuppliersProductCode"/></SuppliersProductCode>
			</ProductID>
			<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
			<PackSize><xsl:value-of select="PackSize"/></PackSize>
			<OrderedQuantity><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityRequired"/></OrderedQuantity>
			<ConfirmedQuantity><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityToBeDelivered"/></ConfirmedQuantity>
			<UnitValueExclVAT><xsl:value-of select="UnitValueExVAT"/></UnitValueExclVAT>
			<LineValueExclVAT><xsl:value-of select="LineValueExVAT"/></LineValueExclVAT>
			<Narrative><xsl:value-of select="ReasonForChange"/></Narrative>
		</PurchaseOrderConfirmationLine>
		</xsl:for-each>
	</PurchaseOrderConfirmationDetail>
	<PurchaseOrderConfirmationTrailer>
		<NumberOfLines><xsl:value-of select="NumberOfLines"/></NumberOfLines>
	</PurchaseOrderConfirmationTrailer>
</PurchaseOrderConfirmation>
</xsl:template>
</xsl:stylesheet>
