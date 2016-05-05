<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Delivery note to Internal XML  tsmapinghospitalitybusinesswearDCNIn
	

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 4/7/2012	| Stephen Bowers		| Created module
==========================================================================================
		13/7/2012	| 		Stephen Bowers			| Case 5580	bug fix to correct POCref and POCdate, DNRef abd DNrefdate.
==========================================================================================
           	|                 	|
=======================================================================================-->
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
								<DeliveryNoteReferences>
									<xsl:if test="Header/DeliveryNoteReference !=''">
										<DeliveryNoteReference>
											<xsl:value-of select="Header/DeliveryNoteReference"/>
										</DeliveryNoteReference>
									</xsl:if>
									<xsl:if test="Header/DeliveryNoteDate !=''">
										<DeliveryNoteDate>
											<xsl:value-of select="Header/DeliveryNoteDate"/>
										</DeliveryNoteDate>
									</xsl:if>
									<xsl:if test="Header/ActualDeliveryDate !=''">
										<DespatchDate>
											<xsl:value-of select="Header/ActualDeliveryDate"/>
										</DespatchDate>
									</xsl:if>
								</DeliveryNoteReferences>
								<DeliveredDeliveryDetails>
									<xsl:if test="Header/ActualDeliveryDate !=''">
										<DeliveryDate>
											<xsl:value-of select="Header/ActualDeliveryDate"/>
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
												<xsl:value-of select="SuppliersProductCode"/>
											</SuppliersProductCode>
										</ProductID>
										<xsl:if test="ProductDescription !=''">
										<ProductDescription>
										<xsl:value-of select="ProductDescription"/>
										</ProductDescription>
										</xsl:if>
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
