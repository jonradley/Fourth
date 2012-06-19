<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="DeliveryNote">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="7">
						<DeliveryNote>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="Header/SendersCodeforUnit"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<DeliveryNoteHeader>
								<ShipTo>
									<xsl:if test="DeliveryLocationName != ''">
										<ShipToName>
											<xsl:value-of select="DeliveryLocationName"/>
										</ShipToName>
									</xsl:if>
									<ShipToAddress>
										<xsl:if test="DeliveryLocationAddressLine1 !=''">
											<AddressLine1>
												<xsl:value-of select="DeliveryLocationAddressLine1"/>
											</AddressLine1>
										</xsl:if>
										<xsl:if test="DeliveryLocationAddressLine2 !=''">
											<AddressLine2>
												<xsl:value-of select="DeliveryLocationAddressLine2"/>
											</AddressLine2>
										</xsl:if>
										<xsl:if test="DeliveryLocationAddressLine3 !=''">
											<AddressLine3>
												<xsl:value-of select="DeliveryLocationAddressLine3"/>
											</AddressLine3>
										</xsl:if>
										<xsl:if test="DeliveryLocationAddressLine4 !=''">
											<AddressLine4>
												<xsl:value-of select="DeliveryLocationAddressLine4"/>
											</AddressLine4>
										</xsl:if>
										<xsl:if test="DeliveryLocationAddressPostCode !=''">
											<PostCode>
												<xsl:value-of select="DeliveryLocationAddressPostCode"/>
											</PostCode>
										</xsl:if>
									</ShipToAddress>
									<xsl:if test="DeliveryLocationContact !=''">
										<ContactName>
											<xsl:value-of select="DeliveryLocationContact"/>
										</ContactName>
									</xsl:if>
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="Header/PurchaseOrderReference"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="Header/PurchaseOrderDate"/>
									</PurchaseOrderDate>
								</PurchaseOrderReferences>
								<!--<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference/>
									<PurchaseOrderConfirmationDate/>
								</PurchaseOrderConfirmationReferences>-->
								<DeliveryNoteReferences>
									<xsl:if test="DeliveryNoteReference !=''">
										<DeliveryNoteReference>
											<xsl:value-of select="DeliveryNoteReference"/>
										</DeliveryNoteReference>
									</xsl:if>
									<xsl:if test="DeliveryNoteDate !=''">
										<DeliveryNoteDate>
											<xsl:value-of select="DeliveryNoteDate"/>
										</DeliveryNoteDate>
									</xsl:if>
									<xsl:if test="ActualDeliveryDate !=''">
										<DespatchDate>
											<xsl:value-of select="ActualDeliveryDate"/>
										</DespatchDate>
									</xsl:if>
								</DeliveryNoteReferences>
								<DeliveredDeliveryDetails>
									<xsl:if test="ActualDeliveryDate !=''">
										<DeliveryDate>
											<xsl:value-of select="ActualDeliveryDate"/>
										</DeliveryDate>
									</xsl:if>
								</DeliveredDeliveryDetails>
							</DeliveryNoteHeader>
							<DeliveryNoteDetail>
								<xsl:for-each select="DetailLine">
									<DeliveryNoteLine>
										<LineNumber>
											<xsl:value-of select="position()"/>
										</LineNumber>
										<ProductID>
											<SuppliersProductCode>
												<xsl:value-of select="Header/SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										<ProductDescription>
										<xsl:value-of select="ProductDescription"/>
										</ProductDescription>
										<xsl:if test="QuantityRequired !=''">
										<OrderedQuantity>
											<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
											<xsl:value-of select="QuantityRequired"/>
										</OrderedQuantity>
										</xsl:if>
										<xsl:if test="QuantityToBeDelivered !=''">
										<ConfirmedQuantity>
											<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
											<xsl:value-of select="QuantityToBeDelivered"/>
										</ConfirmedQuantity>
										</xsl:if>
										<xsl:if test="QuantityDelivered !=''">
										<DespatchedQuantity>
											<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>
											<xsl:value-of select="QuantityDelivered"/>
										</DespatchedQuantity>
										</xsl:if>
										<xsl:if test="UnitValueExVAT !=''">
											<UnitValueExclVAT>
												<xsl:value-of select="UnitValueExVAT"/>
											</UnitValueExclVAT>
										</xsl:if>
									</DeliveryNoteLine>
								</xsl:for-each>
							</DeliveryNoteDetail>
						</DeliveryNote>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
