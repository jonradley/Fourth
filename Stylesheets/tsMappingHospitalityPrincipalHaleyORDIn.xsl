<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-11-14		| 4966 Created Module
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="indepedi[@editype='Estimate']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="2">
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="supplierdata/@code"/></SendersCodeForRecipient>
								<!-- <SendersBranchReference/> -->
								<xsl:if test="clientdata/@name != ''"><SendersName><xsl:value-of select="clientdata/@name"/></SendersName></xsl:if>
								<SendersAddress>
									<xsl:if test="clientdata/@outletaddress1 != ''"><AddressLine1><xsl:value-of select="clientdata/@outletaddress1"/></AddressLine1></xsl:if>
									<xsl:if test="clientdata/@outletaddress2 != ''"><AddressLine2><xsl:value-of select="clientdata/@outletaddress2"/></AddressLine2></xsl:if>
									<xsl:if test="clientdata/@outletaddress3 != ''"><AddressLine3><xsl:value-of select="clientdata/@outletaddress3"/></AddressLine3></xsl:if>
									<xsl:if test="clientdata/@outlettown != ''"><AddressLine4><xsl:value-of select="clientdata/@outlettown"/></AddressLine4></xsl:if>
									<xsl:if test="clientdata/@outletpostcode != ''"><PostCode><xsl:value-of select="clientdata/@outletpostcode"/></PostCode></xsl:if>
								</SendersAddress>
								<!--<RecipientsCodeForSender/>
								<RecipientsBranchReference/>-->
								<xsl:if test="supplierdata/@name != ''"><RecipientsName><xsl:value-of select="supplierdata/@name"/></RecipientsName></xsl:if>
								<RecipientsAddress>
									<xsl:if test="supplierdata/@address1 != ''"><AddressLine1><xsl:value-of select="supplierdata/@address1"/></AddressLine1></xsl:if>
									<xsl:if test="supplierdata/@address2 != ''"><AddressLine2><xsl:value-of select="supplierdata/@address2"/></AddressLine2></xsl:if>
									<xsl:if test="supplierdata/@address3 != ''"><AddressLine3><xsl:value-of select="supplierdata/@address3"/></AddressLine3></xsl:if>
									<xsl:if test="supplierdata/@town != ''"><AddressLine4><xsl:value-of select="supplierdata/@town"/></AddressLine4></xsl:if>
									<xsl:if test="supplierdata/@postcode != ''"><PostCode><xsl:value-of select="supplierdata/@postcode"/></PostCode></xsl:if>
								</RecipientsAddress>
								<!--<TestFlag/>-->
							</TradeSimpleHeader>
							
							<PurchaseOrderHeader>
								<!--<DocumentStatus/>-->
								<Buyer>
									<!--<BuyersLocationID>
										<GLN/>
										<BuyersCode/>
										<SuppliersCode/>
									</BuyersLocationID>-->
									<xsl:if test="clientdata/@name != ''"><BuyersName><xsl:value-of select="clientdata/@name"/></BuyersName></xsl:if>
									<BuyersAddress>
										<xsl:if test="clientdata/@outletaddress1 != ''"><AddressLine1><xsl:value-of select="clientdata/@outletaddress1"/></AddressLine1></xsl:if>
										<xsl:if test="clientdata/@outletaddress2 != ''"><AddressLine2><xsl:value-of select="clientdata/@outletaddress2"/></AddressLine2></xsl:if>
										<xsl:if test="clientdata/@outletaddress3 != ''"><AddressLine3><xsl:value-of select="clientdata/@outletaddress3"/></AddressLine3></xsl:if>
										<xsl:if test="clientdata/@outlettown != ''"><AddressLine4><xsl:value-of select="clientdata/@outlettown"/></AddressLine4></xsl:if>
										<xsl:if test="clientdata/@outletpostcode != ''"><PostCode><xsl:value-of select="clientdata/@outletpostcode"/></PostCode></xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<BuyersCode><xsl:value-of select="supplierdata/@code"/></BuyersCode>
									</SuppliersLocationID>
									<xsl:if test="supplierdata/@name != ''"><SuppliersName><xsl:value-of select="supplierdata/@name"/></SuppliersName></xsl:if>
									<SuppliersAddress>
										<xsl:if test="supplierdata/@address1 != ''"><AddressLine1><xsl:value-of select="supplierdata/@address1"/></AddressLine1></xsl:if>
										<xsl:if test="supplierdata/@address2 != ''"><AddressLine2><xsl:value-of select="supplierdata/@address2"/></AddressLine2></xsl:if>
										<xsl:if test="supplierdata/@address3 != ''"><AddressLine3><xsl:value-of select="supplierdata/@address3"/></AddressLine3></xsl:if>
										<xsl:if test="supplierdata/@town != ''"><AddressLine4><xsl:value-of select="supplierdata/@town"/></AddressLine4></xsl:if>
										<xsl:if test="supplierdata/@postcode != ''"><PostCode><xsl:value-of select="supplierdata/@postcode"/></PostCode></xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<!--<ShipToLocationID>
										<GLN/>
										<BuyersCode/>
										<SuppliersCode/>
									</ShipToLocationID>-->
									<xsl:if test="clientdata/@name != ''"><ShipToName><xsl:value-of select="clientdata/@name"/></ShipToName></xsl:if>
									<ShipToAddress>
										<xsl:if test="deliverydata/@address1 != ''"><AddressLine1><xsl:value-of select="deliverydata/@address1"/></AddressLine1></xsl:if>
										<xsl:if test="deliverydata/@address2 != ''"><AddressLine2><xsl:value-of select="deliverydata/@address2"/></AddressLine2></xsl:if>
										<xsl:if test="deliverydata/@address3 != ''"><AddressLine3><xsl:value-of select="deliverydata/@address3"/></AddressLine3></xsl:if>
										<xsl:if test="deliverydata/@town != ''"><AddressLine4><xsl:value-of select="deliverydata/@town"/></AddressLine4></xsl:if>
										<xsl:if test="deliverydata/@postcode != ''"><PostCode><xsl:value-of select="deliverydata/@postcode"/></PostCode></xsl:if>
									</ShipToAddress>
									<ContactName/>
								</ShipTo>
								
								<PurchaseOrderReferences>
									<xsl:if test="indepedi/@reference != ''"><PurchaseOrderReference><xsl:value-of select="indepedi/@reference"/></PurchaseOrderReference></xsl:if>
									<xsl:if test="indepedi/@taxpoint != ''"><PurchaseOrderDate><xsl:value-of select="substring-before(indepedi/@taxpoint,'Z')"/></PurchaseOrderDate></xsl:if>
									<!--<TradeAgreement>
										<ContractReference/>
										<ContractDate/>
									</TradeAgreement>-->
									<!--<CustomerPurchaseOrderReference/>
									<JobNumber/>
									<OriginalPurchaseOrderReference/>-->
								</PurchaseOrderReferences>
								
								<!--<OrderedDeliveryDetails>
									<DeliveryType/>
									<DeliveryDate/>
									<DeliverySlot>
										<SlotStart/>
										<SlotEnd/>
									</DeliverySlot>
									<DeliveryCutOffDate/>
									<DeliveryCutOffTime/>
									<SpecialDeliveryInstructions/>
								</OrderedDeliveryDetails>
								<OrderID/>
								<SequenceNumber/>
								<HeaderExtraData/>-->
								
							</PurchaseOrderHeader>
							
							<PurchaseOrderDetail>
								<xsl:for-each select="productitems/productitem">
									<PurchaseOrderLine>
										<LineNumber><xsl:value-of select="position()"/></LineNumber>
										<ProductID>
											<!--<GTIN/>-->
											<xsl:if test="@itemcode!= ''"><SuppliersProductCode><xsl:value-of select="@itemcode"/></SuppliersProductCode></xsl:if>
										</ProductID>
										
										<xsl:if test="@description!= ''"><ProductDescription><xsl:value-of select="@description"/></ProductDescription></xsl:if>
										<xsl:if test="@quantity!= ''">
											<OrderedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:call-template name="uomLookup"/></xsl:attribute>
												<xsl:value-of select="@quantity"/>
											</OrderedQuantity>
										</xsl:if>
										<xsl:if test="@unitprice!= ''"><UnitValueExclVAT><xsl:value-of select="@unitprice"/></UnitValueExclVAT></xsl:if>
										<xsl:if test="@itemprice!= ''"><LineValueExclVAT><xsl:value-of select="@itemprice"/></LineValueExclVAT></xsl:if>
										<!--<OrderedDeliveryDetailsLineLevel>
											<DeliveryDate/>
											<DeliverySlot>
												<SlotStart/>
												<SlotEnd/>
											</DeliverySlot>
										</OrderedDeliveryDetailsLineLevel>
										<LineExtraData/>-->
									</PurchaseOrderLine>
								</xsl:for-each>
							</PurchaseOrderDetail>
							
							<xsl:for-each select="summarydata">
								<PurchaseOrderTrailer>
									<NumberOfLines><xsl:value-of select="count(/indepedi/productitems/productitem)"/></NumberOfLines>
									<TotalExclVAT><xsl:value-of select="@netamount"/></TotalExclVAT>
								</PurchaseOrderTrailer>
							</xsl:for-each>
							
						</PurchaseOrder>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<!-- UoM Lookup -->
	<xsl:template name="uomLookup">
		<xsl:choose>
			<xsl:when test="@nominalcode = 'EA' or @nominalcode = 'EACH'">EA</xsl:when>
			<xsl:when test="@nominalcode = 'PACK' or @nominalcode = 'CASE'">CS</xsl:when>
			<xsl:when test="@nominalcode = 'DOZ'">DZN</xsl:when>
			<xsl:when test="@nominalcode = 'KG'">KGM</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
