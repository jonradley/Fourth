<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:template match="DeliveryNote">
<DeliveryNote>
	<TradeSimpleHeader>
		<SendersCodeForRecipient><xsl:value-of select="SendersCodeforUnit"/></SendersCodeForRecipient>
	</TradeSimpleHeader>
	<DeliveryNoteHeader>
		<ShipTo>
			<ShipToName><xsl:value-of select="DeliveryLocationName"/></ShipToName>	
			<ShipToAddress>
				<AddressLine1><xsl:value-of select="DeliveryLocationAddressLine1"/></AddressLine1>
				<AddressLine2><xsl:value-of select="DeliveryLocationAddressLine2"/></AddressLine2>
				<AddressLine3><xsl:value-of select="DeliveryLocationAddressLine3"/></AddressLine3>
				<AddressLine4><xsl:value-of select="DeliveryLocationAddressLine4"/></AddressLine4>
				<PostCode><xsl:value-of select="DeliveryLocationAddressPostCode"/></PostCode>
			</ShipToAddress>
			<ContactName><xsl:value-of select="DeliveryLocationContact"/></ContactName>
		</ShipTo>
		<PurchaseOrderReferences>
			<PurchaseOrderReference><xsl:value-of select="PurchaseOrderReference"/></PurchaseOrderReference>
			<PurchaseOrderDate><xsl:value-of select="PurchaseOrderDate"/></PurchaseOrderDate>
		</PurchaseOrderReferences>
		<PurchaseOrderConfirmationReferences>
			<PurchaseOrderConfirmationReference/>
			<PurchaseOrderConfirmationDate/>
		</PurchaseOrderConfirmationReferences>
		<DeliveryNoteReferences>
			<DeliveryNoteReference><xsl:value-of select="DeliveryNoteReference"/></DeliveryNoteReference>
			<DeliveryNoteDate><xsl:value-of select="DeliveryNoteDate"/></DeliveryNoteDate>
			<DespatchDate><xsl:value-of select="ActualDeliveryDate"/></DespatchDate>
		</DeliveryNoteReferences>
		<DeliveredDeliveryDetails>
			<DeliveryDate><xsl:value-of select="ActualDeliveryDate"/></DeliveryDate>
		</DeliveredDeliveryDetails>
	</DeliveryNoteHeader>
	<DeliveryNoteDetail>
		<xsl:for-each select="DetailLine">
		<DeliveryNoteLine>
			<LineNumber><xsl:value-of select="position()"/></LineNumber>
			<ProductID>
				<SuppliersProductCode><xsl:value-of select="SuppliersProductCode"/></SuppliersProductCode>
			</ProductID>
			<ProductDescription/>
			<OrderedQuantity><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityRequired"/></OrderedQuantity>
			<ConfirmedQuantity><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityToBeDelivered"/></ConfirmedQuantity>
			<DespatchedQuantity><xsl:attribute name="UnitOfMeasure">EA</xsl:attribute><xsl:value-of select="QuantityDelivered"/></DespatchedQuantity>
			<UnitValueExclVAT><xsl:value-of select="UnitValueExVAT"/></UnitValueExclVAT>
			</DeliveryNoteLine>
	</xsl:for-each>
	</DeliveryNoteDetail>
</DeliveryNote>
</xsl:template>
</xsl:stylesheet>
