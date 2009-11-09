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
		<PurchaseOrder>
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:if test="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier/@type='Buyer'">
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/PartyIds/Identifier[@type='Buyer']/@value"/>
					</xsl:if>
				</SendersCodeForRecipient>
				<SendersName>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
				</SendersName>
				<SendersAddress>
					<AddressLine1>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/AddressLine2"/>
					</AddressLine2>
					<AddressLine3/>
					<AddressLine4>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Address/City"/>
					</AddressLine4>
					<PostCode/>
				</SendersAddress>
				<RecipientsCodeForSender></RecipientsCodeForSender>
				<RecipientsName>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
				</RecipientsName>
				<RecipientsAddress>
					<AddressLine1>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2"/>
					</AddressLine2>
					<AddressLine3/>
					<AddressLine4>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City"/>
					</AddressLine4>
					<PostCode/>
				</RecipientsAddress>
				<TestFlag>
					<xsl:text>true</xsl:text>
				</TestFlag>
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
						<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>
					</BuyersLocationID>
					<BuyersName>
						<xsl:if test="@role='Creator'">
								<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Role/Contacts/Contact[@role='Creator']/@role"/>
						</xsl:if>
					</BuyersName>
					<BuyersAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Marketplace/Address/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Marketplace/Address/AddressLine2"/>
						</AddressLine2>
						<AddressLine3/>
						<AddressLine4>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Marketplace/Address/City"/>
						</AddressLine4>
						<PostCode/>
					</BuyersAddress>
				</Buyer>
				<Supplier>
					<SuppliersLocationID>
						<GLN>
							<!--No GLN's provided in Marketboomer PO's-->
							<xsl:text>5555555555555</xsl:text>
						</GLN>
						<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>
					</SuppliersLocationID>
					<SuppliersName></SuppliersName>
					<SuppliersAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/AddressLine2"/>
						</AddressLine2>
						<AddressLine3/>
						<AddressLine4>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Address/City"/>
						</AddressLine4>
						<PostCode/>
					</SuppliersAddress>
				</Supplier>
				<ShipTo>
					<ShipToLocationID>
						<GLN>
							<!--No GLN's provided in Marketboomer PO's-->
							<xsl:text>5555555555555</xsl:text>
						</GLN>
						<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>
					</ShipToLocationID>
					<ShipToName></ShipToName>
					<ShipToAddress>
						<AddressLine1>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine1"/>
						</AddressLine1>
						<AddressLine2>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine2"/>
						</AddressLine2>
						<AddressLine3/>
						<AddressLine4>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/City"/>
						</AddressLine4>
						<PostCode/>
					</ShipToAddress>
					<ContactName></ContactName>
				</ShipTo>
				<PurchaseOrderReferences>
					<PurchaseOrderReference>
						<xsl:if test="/Supplier_Orders/SupplierOrder/Order/DocIds/Identifier/@type='ORDER_NUMBER'">
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/DocIds/Identifier[@type='ORDER_NUMBER']/@value"/>
						</xsl:if>
					</PurchaseOrderReference>
					<PurchaseOrderDate>
						<!--Get date component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,1,10)"/>
					</PurchaseOrderDate>
					<PurchaseOrderTime>
						<!--Get time component from datetime value-->
						<xsl:value-of select ="substring(/Supplier_Orders/SupplierOrder/Order/@date,12,19)"/>
					</PurchaseOrderTime>
					<TradeAgreement>
						<ContractReference></ContractReference>
						<ContractDate></ContractDate>
					</TradeAgreement>
					<CustomerPurchaseOrderReference></CustomerPurchaseOrderReference>
					
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
					<DeliveryCutOffDate></DeliveryCutOffDate>
					<DeliveryCutOffTime></DeliveryCutOffTime>
					<SpecialDeliveryInstructions></SpecialDeliveryInstructions>
				</OrderedDeliveryDetails>
				<OrderID></OrderID>
				
				<!--		???
				<FileGenerationNumber>
				</FileGenerationNumber>-->
				
				<SequenceNumber />
				<!--HeaderExtraData not used.
				<HeaderExtraData />-->
				
			</PurchaseOrderHeader>

			<!--Order Lines-->
			
			<PurchaseOrderDetail>
				<xsl:for-each select="/Supplier_Orders/SupplierOrder/Order/Body/Line">
					<PurchaseOrderLine>
						<!--How to generate line number??-->
						<LineNumber/>
						<ProductID>
							<GTIN>
								<!--No GTIN's provided in Marketboomer PO's-->
								<xsl:text>5555555555555</xsl:text>
							</GTIN>
							<SuppliersProductCode>
								<xsl:if test="Product/Identifiers/Identifier/@type='Seller'">
									<xsl:value-of select ="Product/Identifiers/Identifier[@type='Seller']/@value"/>
								</xsl:if>
							</SuppliersProductCode>
							<BuyersProductCode>
								<xsl:if test="Product/Identifiers/Identifier/@type='Buyer'">
									<xsl:value-of select ="Product/Identifiers/Identifier[@type='Buyer']/@value"/>
								</xsl:if>
							</BuyersProductCode>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select ="Product/Description"/>
						</ProductDescription>
						<OrderedQuantity>
							<xsl:attribute name="UnitOfMeasure">
  								<xsl:if test="Product/Unit/@measure='kg'">KGM</xsl:if>
  								<xsl:if test="Product/Unit/@measure='each'">EA</xsl:if>
  								<!--More UOM's?-->
 							</xsl:attribute>
							<xsl:value-of select ="Quantity"/>
						</OrderedQuantity>
						<PackSize>
							<xsl:value-of select ="Product/Package/@size"/>
							<xsl:value-of select ="Product/Package/@name"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select ="UnitPrice"/>
						</UnitValueExclVAT>
						<LineValueExclVAT>
							<xsl:value-of select ="LineTotal"/>
						</LineValueExclVAT>
						<OrderedDeliveryDetailsLineLevel>
							<DeliveryDate>
								<xsl:value-of select="Quantity/@delivery_date"/>
							</DeliveryDate>
							
							<!--Delivery slot data in text despcription line in Marketboomer file... Not mapped.
							<DeliverySlot>
								<SlotStart></SlotStart>
								<SlotEnd></SlotEnd>
							</DeliverySlot>-->
													
						</OrderedDeliveryDetailsLineLevel>
						
						<!--LineExtraData not used.
						<LineExtraData/>-->
						
					</PurchaseOrderLine>
				</xsl:for-each>
			</PurchaseOrderDetail>

			<!--Trailer details-->
			
			<PurchaseOrderTrailer>
				<NumberOfLines>
					<xsl:value-of select ="count(//Line)"/>
				</NumberOfLines>
				<TotalExclVAT>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Financials/OrderValue"/>
				</TotalExclVAT>
				
				<!--TrailerExtraData not used.
				<TrailerExtraData/>-->

			</PurchaseOrderTrailer>
		</PurchaseOrder>
	</xsl:template>
</xsl:stylesheet>