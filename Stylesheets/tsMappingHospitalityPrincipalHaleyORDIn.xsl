<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2011-11-14		| 4966 Created Module
**********************************************************************
H Robson	| 2011-12-01		| 4966 Revisions (element names changed case from the spec, date format changed)
**********************************************************************
H Robson	| 2012-01-09		| 4966 Fix (no delivery date)
**********************************************************************
H Robson	| 2012-01-12		| 5164 Map the SpecialDeliveryInstructions field.
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="INDEPEDI[@EDIType='Estimate']">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="2">
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="SupplierData/@code"/></SendersCodeForRecipient>
								<!-- <SendersBranchReference/> -->
								<xsl:if test="ClientData/@Name != ''"><SendersName><xsl:value-of select="ClientData/@Name"/></SendersName></xsl:if>
								<SendersAddress>
									<xsl:if test="ClientData/@OutletAddress1 != ''"><AddressLine1><xsl:value-of select="ClientData/@OutletAddress1"/></AddressLine1></xsl:if>
									<xsl:if test="ClientData/@OutletAddress2 != ''"><AddressLine2><xsl:value-of select="ClientData/@OutletAddress2"/></AddressLine2></xsl:if>
									<xsl:if test="ClientData/@OutletAddress3 != ''"><AddressLine3><xsl:value-of select="ClientData/@OutletAddress3"/></AddressLine3></xsl:if>
									<xsl:if test="ClientData/@OutletTown != ''"><AddressLine4><xsl:value-of select="ClientData/@OutletTown"/></AddressLine4></xsl:if>
									<xsl:if test="ClientData/@OutletPostCode != ''"><PostCode><xsl:value-of select="ClientData/@OutletPostCode"/></PostCode></xsl:if>
								</SendersAddress>
								<!--<RecipientsCodeForSender/>
								<RecipientsBranchReference/>-->
								<xsl:if test="SupplierData/@Name != ''"><RecipientsName><xsl:value-of select="SupplierData/@Name"/></RecipientsName></xsl:if>
								<RecipientsAddress>
									<xsl:if test="SupplierData/@Address1 != ''"><AddressLine1><xsl:value-of select="SupplierData/@Address1"/></AddressLine1></xsl:if>
									<xsl:if test="SupplierData/@Address2 != ''"><AddressLine2><xsl:value-of select="SupplierData/@Address2"/></AddressLine2></xsl:if>
									<xsl:if test="SupplierData/@Address3 != ''"><AddressLine3><xsl:value-of select="SupplierData/@Address3"/></AddressLine3></xsl:if>
									<xsl:if test="SupplierData/@Town != ''"><AddressLine4><xsl:value-of select="SupplierData/@Town"/></AddressLine4></xsl:if>
									<xsl:if test="SupplierData/@PostCode != ''"><PostCode><xsl:value-of select="SupplierData/@PostCode"/></PostCode></xsl:if>
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
									<xsl:if test="ClientData/@Name != ''"><BuyersName><xsl:value-of select="ClientData/@Name"/></BuyersName></xsl:if>
									<BuyersAddress>
										<xsl:if test="ClientData/@OutletAddress1 != ''"><AddressLine1><xsl:value-of select="ClientData/@OutletAddress1"/></AddressLine1></xsl:if>
										<xsl:if test="ClientData/@OutletAddress2 != ''"><AddressLine2><xsl:value-of select="ClientData/@OutletAddress2"/></AddressLine2></xsl:if>
										<xsl:if test="ClientData/@OutletAddress3 != ''"><AddressLine3><xsl:value-of select="ClientData/@OutletAddress3"/></AddressLine3></xsl:if>
										<xsl:if test="ClientData/@OutletTown != ''"><AddressLine4><xsl:value-of select="ClientData/@OutletTown"/></AddressLine4></xsl:if>
										<xsl:if test="ClientData/@OutletPostCode != ''"><PostCode><xsl:value-of select="ClientData/@OutletPostCode"/></PostCode></xsl:if>
									</BuyersAddress>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<BuyersCode><xsl:value-of select="SupplierData/@code"/></BuyersCode>
									</SuppliersLocationID>
									<xsl:if test="SupplierData/@Name != ''"><SuppliersName><xsl:value-of select="SupplierData/@Name"/></SuppliersName></xsl:if>
									<SuppliersAddress>
										<xsl:if test="SupplierData/@Address1 != ''"><AddressLine1><xsl:value-of select="SupplierData/@Address1"/></AddressLine1></xsl:if>
										<xsl:if test="SupplierData/@Address2 != ''"><AddressLine2><xsl:value-of select="SupplierData/@Address2"/></AddressLine2></xsl:if>
										<xsl:if test="SupplierData/@Address3 != ''"><AddressLine3><xsl:value-of select="SupplierData/@Address3"/></AddressLine3></xsl:if>
										<xsl:if test="SupplierData/@Town != ''"><AddressLine4><xsl:value-of select="SupplierData/@Town"/></AddressLine4></xsl:if>
										<xsl:if test="SupplierData/@PostCode != ''"><PostCode><xsl:value-of select="SupplierData/@PostCode"/></PostCode></xsl:if>
									</SuppliersAddress>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<SuppliersCode><xsl:value-of select="ClientData/@OutletReference"/></SuppliersCode>
										<BuyersCode><xsl:value-of select="ClientData/@OutletReference"/></BuyersCode>
									</ShipToLocationID>
									<xsl:if test="ClientData/@Name != ''"><ShipToName><xsl:value-of select="ClientData/@Name"/></ShipToName></xsl:if>
									<ShipToAddress>
										<xsl:if test="DeliveryData/@Address1 != ''"><AddressLine1><xsl:value-of select="DeliveryData/@Address1"/></AddressLine1></xsl:if>
										<xsl:if test="DeliveryData/@Address2 != ''"><AddressLine2><xsl:value-of select="DeliveryData/@Address2"/></AddressLine2></xsl:if>
										<xsl:if test="DeliveryData/@Address3 != ''"><AddressLine3><xsl:value-of select="DeliveryData/@Address3"/></AddressLine3></xsl:if>
										<xsl:if test="DeliveryData/@Town != ''"><AddressLine4><xsl:value-of select="DeliveryData/@Town"/></AddressLine4></xsl:if>
										<xsl:if test="DeliveryData/@PostCode != ''"><PostCode><xsl:value-of select="DeliveryData/@PostCode"/></PostCode></xsl:if>
									</ShipToAddress>
								</ShipTo>
								
								<PurchaseOrderReferences>
									<xsl:if test="@Reference != ''"><PurchaseOrderReference><xsl:value-of select="@Reference"/></PurchaseOrderReference></xsl:if>
									<PurchaseOrderDate>
										<xsl:call-template name="dateToInternal">
											<xsl:with-param name="inputDate" select="@Created"/>
										</xsl:call-template>
									</PurchaseOrderDate>
									<!--<TradeAgreement>
										<ContractReference/>
										<ContractDate/>
									</TradeAgreement>-->
									<!--<CustomerPurchaseOrderReference/>
									<JobNumber/>
									<OriginalPurchaseOrderReference/>-->
								</PurchaseOrderReferences>
								
								<OrderedDeliveryDetails>
									<DeliveryDate>
										<xsl:call-template name="dateToInternal">
											<xsl:with-param name="inputDate" select="@TaxPoint"/>
										</xsl:call-template>
									</DeliveryDate>
									<!--<DeliverySlot>
										<SlotStart/>
										<SlotEnd/>
									</DeliverySlot>
									<DeliveryCutOffDate/>
									<DeliveryCutOffTime/>-->
									<xsl:if test="@Notes != ''">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="@Notes"/>
										</SpecialDeliveryInstructions>
									</xsl:if>
								</OrderedDeliveryDetails>
								<!--<OrderID/>
								<SequenceNumber/>
								<HeaderExtraData/>-->
								
							</PurchaseOrderHeader>
							
							<PurchaseOrderDetail>
								<xsl:for-each select="ProductItems/ProductItem">
									<PurchaseOrderLine>
										<LineNumber><xsl:value-of select="position()"/></LineNumber>
										<ProductID>
											<!--<GTIN/>-->
											<xsl:if test="@ItemCode != ''"><SuppliersProductCode><xsl:value-of select="@ItemCode"/></SuppliersProductCode></xsl:if>
										</ProductID>
										
										<xsl:if test="@Description != ''"><ProductDescription><xsl:value-of select="@Description"/></ProductDescription></xsl:if>
										<xsl:if test="@Quantity != ''">
											<OrderedQuantity>
												<xsl:attribute name="UnitOfMeasure"><xsl:call-template name="uomLookup"/></xsl:attribute>
												<xsl:value-of select="@Quantity"/>
											</OrderedQuantity>
										</xsl:if>
										<xsl:if test="@UnitPrice != ''"><UnitValueExclVAT><xsl:value-of select="@UnitPrice"/></UnitValueExclVAT></xsl:if>
										<xsl:if test="@ItemPrice != ''"><LineValueExclVAT><xsl:value-of select="@ItemPrice"/></LineValueExclVAT></xsl:if>
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
							
							<xsl:for-each select="SummaryData">
								<PurchaseOrderTrailer>
									<NumberOfLines><xsl:value-of select="count(/INDEPEDI/ProductItems/ProductItem)"/></NumberOfLines>
									<TotalExclVAT><xsl:value-of select="@NetAmount"/></TotalExclVAT>
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
			<xsl:when test="@NominalCode = 'EA' or @NominalCode = 'EACH'">EA</xsl:when>
			<xsl:when test="@NominalCode = 'PACK' or @NominalCode = 'CASE'">CS</xsl:when>
			<xsl:when test="@NominalCode = 'DOZ'">DZN</xsl:when>
			<xsl:when test="@NominalCode = 'KG'">KGM</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- =============================================================================================
	dateToInternal
	INPUT: DD/MM/YYYY 
	OUTPUT: YYYY-MM-DD
	============================================================================================== -->
	<xsl:template name="dateToInternal">
		<xsl:param name="inputDate" />
		<xsl:param name="day" />
		<xsl:param name="month" />
		<xsl:param name="year" />
		<!-- the first iteration is always 1 -->
		<xsl:param name="iteration" select="number(1)" />
		
		<!-- there are 4 steps (iterations) to this process -->
		<xsl:if test="$iteration &lt;= 4">
			<xsl:choose>
				<!-- the first iteration reads the first segment (the day) and stores it -->
				<xsl:when test="$iteration = 1">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="iteration" select="2"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the second iteration reads the second segment (the month) and stores it -->
				<xsl:when test="$iteration = 2">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="inputDate" select="substring-after($inputDate,'/')"/>
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="format-number(substring-before($inputDate,'/'),'00')"/>
						<xsl:with-param name="iteration" select="3"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the third iteration reads the third segment (the year) and stores it -->
				<xsl:when test="$iteration = 3">
					<xsl:call-template name="dateToInternal">
						<xsl:with-param name="day" select="$day"/>
						<xsl:with-param name="month" select="$month"/>
						<xsl:with-param name="year" select="$inputDate"/>
						<xsl:with-param name="iteration" select="4"/>
					</xsl:call-template>
				</xsl:when>
				<!-- the fourth iteration outputs the correctly formatted date -->
				<xsl:when test="$iteration = 4">
					<xsl:value-of select="$year"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$month"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$day"/>
				</xsl:when>				
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
