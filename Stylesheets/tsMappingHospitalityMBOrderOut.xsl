<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
K Oshaughnessy| 2011-04-01		| 4349 Created Modele
**********************************************************************
				|						|				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="/PurchaseOrder">
	
		<RadUniPurchaseOrder>
		
			<!--These fields are hard coded for M&B-->
			<Version>
				<xsl:text>6.2</xsl:text>
			</Version>
			<NameSpace>
				<xsl:text>mabuat</xsl:text>
			</NameSpace>
			<ClientID>
			<xsl:text>1000152</xsl:text>
			</ClientID>
			<ClientName>
				<xsl:text>MAB2</xsl:text>
			</ClientName>
			
			<SupplierInfo>
				<SupplierId>
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</SupplierId>
				<Name>
					<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
				</Name>
				<VendorId>
					<xsl:choose>
						<xsl:when test="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
							<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/>
						</xsl:when>
						<xsl:otherwise>5555555555555</xsl:otherwise>
					</xsl:choose>
				</VendorId>
				<ExternalId/>
				<AutoFaxFlag>
					<xsl:text>n</xsl:text>
				</AutoFaxFlag>
				<AutoFaxNumber/>
				<EmailFlag>
					<xsl:text>y</xsl:text>
				</EmailFlag>
				<EmailAddress>
					<xsl:text>john.baughan@mbplc.com</xsl:text>
				</EmailAddress>
			</SupplierInfo>
			
			<RetailInfo>
				<BusinessUnitId>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</BusinessUnitId>
				<Name>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</Name>
				<LongName>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</LongName>
				<VendorId>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</VendorId>
				<Phone/>
				<Fax/>
				<Email/>
				<Address>
					<Address1>
						<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
					</Address1>
					<Address2>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</Address2>
					<City>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</City>
					<State>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
					</State>
					<Postal>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
					</Postal>
				</Address>
			</RetailInfo>
			
			<POInfo>
				<Type>
					<xsl:text>002</xsl:text>
				</Type>
				<ID>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
					<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,string-length(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference)-3)"/>
				</ID>
				<Number>
					<xsl:value-of select="substring(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference,string-length(PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference)-3)"/>
				</Number>
				<Date>
					<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</Date>
				<Time>131900</Time>
				<Description/>
			</POInfo>
			
			<DeliveryInfo>
				<RequestType>
					<xsl:text>002</xsl:text>
				</RequestType>
				<RequestDate>
					<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
				</RequestDate>
				<OrderDate>
					<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</OrderDate>
			</DeliveryInfo>
			
			<ShipToInfo>
				<Name>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</Name>
				<Address1>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</Address1>
				<Address2>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
				</Address2>
				<City>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
				</City>
				<State>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
				</State>
				<Postal>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
				</Postal>
				<Country>
					<xsl:text>GB</xsl:text>
				</Country>
				<Phone/>
				<Fax/>
				<EIdType/>
				<EId>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</EId>
			</ShipToInfo>
			
			<BillToInfo>
				<Name>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</Name>
				<Address1>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</Address1>
				<Address2>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
				</Address2>
				<City>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
				</City>
				<State>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
				</State>
				<Postal>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
				</Postal>
				<Country>
					<xsl:text>GB</xsl:text>
				</Country>
				<Phone/>
				<Fax/>
				<EIdType/>
				<EId>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</EId>
			</BillToInfo>
			
			<TermsInfo>
				<TermsLabel/>
			</TermsInfo>
			
			<Items>
				<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">	
						<Item>
							<Id>
								<xsl:value-of select="count(preceding-sibling::*)+1"/>
							</Id>
							<Name>
								<xsl:value-of select="ProductDescription"/>
							</Name>
							<Description/>
							<ExternalId>
								<xsl:choose>
									<xsl:when test="ProductID/BuyersProductCode !=''">
										<xsl:value-of select="ProductID/BuyersProductCode"/>
									</xsl:when>
								</xsl:choose>
							</ExternalId>
							<CategoryInfo>
								<Id>
									<xsl:text>1</xsl:text>
								</Id>
								<Name>
									<xsl:text>Stonegate</xsl:text>
								</Name>
								<VendorId/>
								<Description/>
							</CategoryInfo>
							<BrandInfo>
								<Id/>
								<Name/>
							</BrandInfo>
							<PackageInfo>
								<SupplierItemCode>
									<xsl:value-of select="ProductID/SuppliersProductCode"/>
								</SupplierItemCode>
								<PackagedItemID>
									<xsl:text>1</xsl:text>
								</PackagedItemID>
								<Name/>
								<PackagedInUOM>
									<xsl:text>1</xsl:text>
								</PackagedInUOM>
								<PackagedInName>
									<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
								</PackagedInName>
								<VendorPackagedInUOM/>
								<PricedInUOM>
									<xsl:text>1</xsl:text>
								</PricedInUOM>
								<PricedInName>
									<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
								</PricedInName>
								<VendorPricedInUOM/>
								<QuantityFactor>
									<xsl:text>1000</xsl:text>
								</QuantityFactor>
								<Status>
									<xsl:text>a</xsl:text>
								</Status>
								<PackageClass/>
							</PackageInfo>
							<PriceInfo>
								<UnitPrice>
									<xsl:text>1.00</xsl:text>
								</UnitPrice>
							</PriceInfo>
							<Quantity>
								<xsl:value-of select="OrderedQuantity"/>
							</Quantity>
							<ConfirmedQty>
								<xsl:value-of select="OrderedQuantity"/>
							</ConfirmedQty>
							<UnitBasisofMeasure>
								<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
							</UnitBasisofMeasure>
							<UnitPrice>
								<xsl:text>1.00</xsl:text>
							</UnitPrice>
							<BasisofPrice>
								<xsl:text>NEG</xsl:text>
							</BasisofPrice>
							<ProductServiceIdQualifier>
								<xsl:text>ZZ</xsl:text>
							</ProductServiceIdQualifier>
							<ProductServiceId/>
							<Cost>
								<xsl:text>1.00</xsl:text>
							</Cost>
						</Item>
				</xsl:for-each>
			</Items>			
			
			<TotalItems>
				<xsl:value-of select="count(PurchaseOrderDetail/PurchaseOrderLine/LineNumber)"/>
			</TotalItems>
			<TotalCost>
				<xsl:text>1.00</xsl:text>
			</TotalCost>
			<ReferenceInfo>
				<Type/>
				<Id/>
			</ReferenceInfo>
		</RadUniPurchaseOrder>
	
	</xsl:template>
</xsl:stylesheet>
