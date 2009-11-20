<?xml version="1.0" encoding="UTF-8"?>

<!--******************************************************************
Alterations
**********************************************************************
Name					| Date				| Change
**********************************************************************
Andrew Barber			| 2009-11-05		| Created
*******************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
	<BatchRoot>
		<PurchaseOrder>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<!--<xsl:choose>
						<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier/@type='Buyer'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='Buyer']/@value"/>
						</xsl:when>							
						<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier/@type='ABN'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='DUNS']/@value"/>
						</xsl:when>
						<xsl:otherwise test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier/@type='DUNS'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='ABN']/@value"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='Buyer']/@value"/>-->
					<xsl:text>TEST</xsl:text>
				</SendersCodeForRecipient>
				<!--SendersBranchReference not used.
				<SendersBranchReference></SendersBranchReference>-->
				<!--Should the senders details be fixed as Marketboomer?-->
				<!--<SendersName>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
				</SendersName>
				<SendersAddress>
					<AddressLine1>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/@country-code"/>
					</AddressLine4>
					Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
					<PostCode></PostCode>
				</SendersAddress>-->
				<!--Should the recipients details be fixed as Fairfax?-->
				<!--<RecipientsCodeForSender>
					<xsl:choose>
						<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier/@type='Seller'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier[@type='Seller']/@value"/>
						</xsl:when>
						<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier/@type='ABN'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier[@type=ABN']/@value"/>
						</xsl:when>
						<xsl:when test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier/@type='ABN'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier[@type='DUNS']/@value"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier[@type='Seller']/@value"/>
				</RecipientsCodeForSender>-->
				<!--RecipientsBranchReference not used.
				<RecipientsBranchReference></RecipientsBranchReference>-->
				<!--<RecipientsName>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
				</RecipientsName>-->
				<!--<RecipientsAddress>
					<AddressLine1>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/@country-code"/>
					</AddressLine4>
					Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
					<PostCode></PostCode>
				</RecipientsAddress>-->
				<!--<TestFlag>
					<xsl:text>true</xsl:text>
				</TestFlag>-->
			</TradeSimpleHeader>
			<PurchaseOrderHeader>
				<DocumentStatus>
					<xsl:text>Original</xsl:text>	
				</DocumentStatus>
				<Buyer>
					<BuyersLocationID>
						<GLN>
							<!--No GLN's provided in Marketboomer PO's-->
							<xsl:text>5555555555555</xsl:text>
						</GLN>
						<!--What should the BuyersCode and SuppliersCode values be set to?-->
						<BuyersCode>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/PartyIds/Identifier[@type='Seller']/@value"/>
						</BuyersCode>
						<!--<SuppliersCode></SuppliersCode>-->
					</BuyersLocationID>
					<BuyersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
					</BuyersName>
					<BuyersAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2 != ''">
							<AddressLine2>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City != ''">
							<AddressLine3>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/@country-code != ''">
							<AddressLine4>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/@country-code"/>
							</AddressLine4>
						</xsl:if>
						<!--Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
						<PostCode></PostCode>-->
					</BuyersAddress>
				</Buyer>
				<Supplier>
					<SuppliersLocationID>
						<GLN>
							<!--No GLN's provided in Marketboomer PO's-->
							<xsl:text>5555555555555</xsl:text>
						</GLN>
						<!--What should the BuyersCode and SuppliersCode values be set to?-->
						<BuyersCode>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='Buyer']/@value"/>
						</BuyersCode>
						<!--<SuppliersCode></SuppliersCode>-->
					</SuppliersLocationID>
					<SuppliersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
					</SuppliersName>
					<SuppliersAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2 != ''">
							<AddressLine2>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City != ''">
							<AddressLine3>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/@country-code != ''">
							<AddressLine4>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/@country-code"/>
							</AddressLine4>
						</xsl:if>
						<!--Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
						<PostCode></PostCode>-->
					</SuppliersAddress>
				</Supplier>
				<ShipTo>
					<ShipToLocationID>
						<GLN>
							<!--No GLN's provided in Marketboomer PO's-->
							<xsl:text>5555555555555</xsl:text>
						</GLN>
						<!--What should the BuyersCode and SuppliersCode values be set to?-->
						<!--<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>-->
					</ShipToLocationID>
					<!--Ship to name provided as "[DEFAULT]" in Marketboomer order file, not mapped.
					<ShipToName></ShipToName>-->
					<ShipToAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine2 != ''">
							<AddressLine2>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/City != ''">
							<AddressLine3>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/City"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/@country-code != ''">
							<AddressLine4>
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/@country-code"/>
							</AddressLine4>
						</xsl:if>
						<!--Postcode datatype in Marketboomer xsd = positiveInteger, therefore not consistent with UK postcodes, not mapped.
						<PostCode></PostCode>-->
					</ShipToAddress>
					<ContactName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Contacts/Contact[@role='Creator']/Name"/>
					</ContactName>
				</ShipTo>
				<PurchaseOrderReferences>
					<PurchaseOrderReference>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/DocIds/Identifier[@type='ORDER_NUMBER']/@value"/>
					</PurchaseOrderReference>
					<PurchaseOrderDate>
						<!--Get date component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,1,10)"/>
					</PurchaseOrderDate>
					<PurchaseOrderTime>
						<!--Get time component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,12,19)"/>
					</PurchaseOrderTime>
					<!--TradeAgreement reference not used
					<TradeAgreement>
						<ContractReference></ContractReference>
						<ContractDate></ContractDate>
					</TradeAgreement>-->
					<!--CustomerPurchaseOrderReference not used.
					<CustomerPurchaseOrderReference></CustomerPurchaseOrderReference>-->
					<!-- JobNumber not used.
					<JobNumber></JobNumber>-->	
				</PurchaseOrderReferences>
				<OrderedDeliveryDetails>
					<DeliveryType>
						<xsl:text>Delivery</xsl:text>
					</DeliveryType>
					<DeliveryDate>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryDay"/>
					</DeliveryDate>
					<!--Text comment in inbound file, mapped to SpecialDeliveryInstructions.
					<DeliverySlot
						<SlotStart></SlotStart>
						<SlotEnd></SlotEnd>
					</DeliverySlot>-->
					<!--Text comment in inbound file, mapped to SpecialDeliveryInstructions.
					<DeliveryCutOffDate></DeliveryCutOffDate>
					<DeliveryCutOffTime></DeliveryCutOffTime>-->
					<SpecialDeliveryInstructions>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryInstructions"/>
						<!--Add cost centre here?
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/CostCentre"/>-->
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ConfirmInstructions"/>
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/Comment"/>
					</SpecialDeliveryInstructions>
				</OrderedDeliveryDetails>
				<!--OrderID not used.
				<OrderID></OrderID>-->
				<!--SequenceNumber not used.
				<SequenceNumber></SequenceNumber>-->
				<!--HeaderExtraData not used.
				<HeaderExtraData></HeaderExtraData-->
			</PurchaseOrderHeader>
			<PurchaseOrderDetail>
				<xsl:for-each select="/Supplier_Orders/SupplierOrder/Order/Body/Line">
					<PurchaseOrderLine>
						<!--How to generate line number? Is this done by the infiller?-->
						<!--<LineNumber/>-->
						<ProductID>
							<GTIN>
								<!--No GTIN's provided in Marketboomer PO's-->
								<xsl:text>5555555555555</xsl:text>
							</GTIN>
							<xsl:if test="Product/Identifiers/Identifier[@type='Seller']/@value != ''">
								<SuppliersProductCode>
										<xsl:value-of select ="Product/Identifiers/Identifier[@type='Seller']/@value"/>
								</SuppliersProductCode>
							</xsl:if>
							<xsl:if test="Product/Identifiers/Identifier[@type='Buyer']/@value != ''">
								<BuyersProductCode>
										<xsl:value-of select ="Product/Identifiers/Identifier[@type='Buyer']/@value"/>
								</BuyersProductCode>
							</xsl:if>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select ="Product/Description"/>
						</ProductDescription>
						<OrderedQuantity>
							<xsl:attribute name="UnitOfMeasure">
								<xsl:choose>
									<xsl:when test="Product/Unit/@measure='kg'">KGM</xsl:when>
									<xsl:when test="Product/Unit/@measure='each'">EA</xsl:when>
									<xsl:otherwise>EA</xsl:otherwise>
								</xsl:choose>
  								<!--More UOM's?-->
 							</xsl:attribute>
 							<xsl:choose>
								<xsl:when test="Product/Unit/@measure='kg'">
									<xsl:value-of select ="(Quantity)*(Product/Unit/@size)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="Quantity"/>
								</xsl:otherwise>
							</xsl:choose>
							<!--<xsl:value-of select ="Quantity"/>-->
						</OrderedQuantity>
						<PackSize>
							<xsl:value-of select ="Product/Package/@size"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select ="Product/Package/@name"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select ="UnitPrice"/>
						</UnitValueExclVAT>
						<LineValueExclVAT>
							<xsl:value-of select ="LineTotal"/>
						</LineValueExclVAT>
						<!--<OrderedDeliveryDetailsLineLevel>
							<DeliveryDate>
								<xsl:value-of select="Quantity/@delivery_date"/>
							</DeliveryDate>-->
							<!--Delivery slot specified in text description at order header level, mapped to SpecialDeliveryInstructions.
							<DeliverySlot>
								<SlotStart></SlotStart>
								<SlotEnd></SlotEnd>
							</DeliverySlot>-->				
						<!--</OrderedDeliveryDetailsLineLevel>-->
						<!--LineExtraData not used.
						<LineExtraData></LineExtraData>-->
					</PurchaseOrderLine>
				</xsl:for-each>
			</PurchaseOrderDetail>
			<!--Promotions detail not used in Marketboomer file.
			<PromotionsDetail>
				<PurchaseOrderLine>
					<LineNumber></LineNumber>
					<ProductID>
						<GTIN></GTIN>
						<SuppliersProductCode></SuppliersProductCode>
						<BuyersProductCode></BuyersProductCode>
					</ProductID>
					<ProductDescription></ProductDescription>
					<OrderedQuantity UnitOfMeasure=""></OrderedQuantity>
					<PackSize></PackSize>
					<UnitValueExclVAT></UnitValueExclVAT>
					<LineValueExclVAT></LineValueExclVAT>
					<OrderedDeliveryDetailsLineLevel>
						<DeliveryDate></DeliveryDate>
						<DeliverySlot>
							<SlotStart></SlotStart>
							<SlotEnd></SlotEnd>
						</DeliverySlot>
					</OrderedDeliveryDetailsLineLevel>
					<LineExtraData/>
				</PurchaseOrderLine>
			</PromotionsDetail>-->
			<PurchaseOrderTrailer>
				<NumberOfLines>
					<xsl:value-of select ="count(//Line)"/>
				</NumberOfLines>
				<TotalExclVAT>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Financials/OrderValue"/>
				</TotalExclVAT>
				<!--TrailerExtraData not used.
				<TrailerExtraData></TrailerExtraData>-->
			</PurchaseOrderTrailer>
		</PurchaseOrder>
	</BatchRoot>
	</xsl:template>
</xsl:stylesheet>