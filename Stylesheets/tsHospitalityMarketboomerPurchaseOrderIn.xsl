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
					<xsl:text>TEST</xsl:text>
				</SendersCodeForRecipient>
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
						<!--<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>-->
					</BuyersLocationID>
					<BuyersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/BillTo/Name"/>
					</BuyersName>
					<BuyersAddress>
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
						<!--<BuyersCode></BuyersCode>
						<SuppliersCode></SuppliersCode>-->
					</SuppliersLocationID>
					<SuppliersName>
						<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Seller/Name"/>
					</SuppliersName>
					<SuppliersAddress>
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
						<AddressLine2>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/AddressLine2"/>
						</AddressLine2>
						<AddressLine3>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/City"/>
						</AddressLine3>
						<AddressLine4>
							<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/Location/Address/@country-code"/>
						</AddressLine4>
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
				</PurchaseOrderReferences>
				<OrderedDeliveryDetails>
					<DeliveryType>
						<xsl:text>Delivery</xsl:text>
					</DeliveryType>
					<DeliveryDate>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryDay"/>
					</DeliveryDate>
					<SpecialDeliveryInstructions>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ShipTo/DeliveryInstructions"/>
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/ConfirmInstructions"/>
						<xsl:text> : </xsl:text>
						<xsl:value-of select="/Supplier_Orders/SupplierOrder/Order/Header/Buyer/Comment"/>
					</SpecialDeliveryInstructions>
				</OrderedDeliveryDetails>
			</PurchaseOrderHeader>
			<PurchaseOrderDetail>
				<xsl:for-each select="/Supplier_Orders/SupplierOrder/Order/Body/Line">
					<PurchaseOrderLine>
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
 							</xsl:attribute>
 							<xsl:choose>
								<xsl:when test="Product/Unit/@measure='kg'">
									<xsl:value-of select ="(Quantity)*(Product/Unit/@size)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select ="Quantity"/>
								</xsl:otherwise>
							</xsl:choose>
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
						<OrderedDeliveryDetailsLineLevel>
							<DeliveryDate>
								<xsl:value-of select="Quantity/@delivery_date"/>
							</DeliveryDate>		
						</OrderedDeliveryDetailsLineLevel>
					</PurchaseOrderLine>
				</xsl:for-each>
			</PurchaseOrderDetail>
			<PurchaseOrderTrailer>
				<NumberOfLines>
					<xsl:value-of select ="count(//Line)"/>
				</NumberOfLines>
				<TotalExclVAT>
					<xsl:value-of select ="/Supplier_Orders/SupplierOrder/Order/Header/Financials/OrderValue"/>
				</TotalExclVAT>
			</PurchaseOrderTrailer>
		</PurchaseOrder>
	</BatchRoot>
	</xsl:template>
</xsl:stylesheet>