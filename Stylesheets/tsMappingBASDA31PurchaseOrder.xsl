<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
 $Header: $ $NoKeywords: $
 Overview 
 
	BASDA 3.1 Purchase Order mapper
	

 © ABS Ltd., 2008
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 10/04/2008  | R Cambridge  | 1800 Created        
******************************************************************************************
             |              | 
***************************************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:schemas-basda-org:2000:purchaseOrder:xdr:3.01"  version="1.0">
	<!-- xmlns:doc="urn:schemas-basda-org:schema-extensions:documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:schemas-basda-org:2000:purchaseOrder:xdr:3.01		P:\Hospitality\Aramark\SimpleSimon\eBIS-XML-3.09\schemas\Order-v3.xsd" -->
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/PurchaseOrder">
		
		<Order>
			<OrderHead>
				<Schema>
					<Version>3.01</Version>
				</Schema>
				<Stylesheet>
					<StylesheetOwner>BML</StylesheetOwner>
					<StylesheetName>charord.xsl</StylesheetName>
					<Version>1</Version>
					<StylesheetType>XSL</StylesheetType>
				</Stylesheet>
				<Parameters>
					<Language>en-GB</Language>
					<DecimalSeparator>.</DecimalSeparator>
					<Precision>20.3</Precision>
				</Parameters>
				<!--OriginatingSoftware>
					<SoftwareManufacturer/>
					<SoftwareProduct/>
					<SoftwareVersion/>
				</OriginatingSoftware-->
				<OrderType Code="PUO" Codelist="BASDA">Purchase Order</OrderType>
				<Function Code="FIO" Codelist="BASDA">Firm Order</Function>
				<OrderCurrency>
					<Currency Codelist="ISO4217" Code="STL">STERLING</Currency>
				</OrderCurrency>
				<InvoiceCurrency>
					<Currency Codelist="ISO4217" Code="STL">STERLING</Currency>
				</InvoiceCurrency>
				<Checksum>0</Checksum>
			</OrderHead>
			<OrderReferences>
				<ContractOrderReference><xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/></ContractOrderReference>
				<!--CostCentre/>
				<TermsConditions/-->
				<BuyersOrderNumber Preserve="true"><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></BuyersOrderNumber>
				<!--Department/>
				<GeneralLedgerCode/>
				<ProjectCode Preserve=""/>
				<ProjectAnalysisCode Preserve=""/>
				<SuppliersOrderReference Preserve=""/>
				<CrossReference/>
				<ResponseTo/>
				<BatchNumber/>
				<GloballyUniqueID Preserve=""/-->
			</OrderReferences>
			<!--Extensions/-->
			<OrderDate><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/></OrderDate>
			<Supplier>
				<SupplierReferences>
					<BuyersCodeForSupplier><xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/></BuyersCodeForSupplier>
					<!--TaxNumber/-->
					<GLN><xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/GLN"/></GLN>
					<!--DUNS/>
					<RegistrationNumber/>
					<RegisteredIn/-->
				</SupplierReferences>
				<Party><xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/></Party>
				<Address>
					
					<xsl:for-each select="PurchaseOrderHeader/Supplier/SuppliersAddress/*[.!='']">
						<AddressLine><xsl:value-of select="."/></AddressLine>					
					</xsl:for-each>
					
				</Address>
				<!--Contact>
					<Name/>
					<Department/>
					<Section/>
					<UserID/>
					<InternalAddress/>
					<DDI/>
					<Switchboard/>
					<Fax/>
					<Telex/>
					<Email/>
					<Mobile/>
				</Contact-->
				<!--Narrative/-->
			</Supplier>
			<!--Originator>
				<BuyerReferences>
					<SuppliersCodeForBuyer/>
					<BuyersCodeForBuyer/>
					<TaxNumber/>
					<GLN/>
					<DUNS/>
					<Organisation/>
					<RegistrationNumber/>
					<RegisteredIn/>
				</BuyerReferences>
				<Party/>
				<Address>
					<AddressLine/>
					<Street/>
					<City/>
					<State/>
					<PostCode/>
					<Country Code="" Codelist=""/>
				</Address>
				<Contact>
					<Name/>
					<Department/>
					<Section/>
					<UserID/>
					<InternalAddress/>
					<DDI/>
					<Switchboard/>
					<Fax/>
					<Telex/>
					<Email/>
					<Mobile/>
				</Contact>
				<Narrative/>
			</Originator-->
			<Buyer>
				<BuyerReferences>
					<SuppliersCodeForBuyer><xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/></SuppliersCodeForBuyer>
					<!--TaxNumber/-->
					<GLN><xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/GLN"/></GLN>
					<!--DUNS/>
					<RegistrationNumber/>
					<RegisteredIn/-->
				</BuyerReferences>
				<Party><xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/></Party>
				<Address>
					
					<xsl:for-each select="PurchaseOrderHeader/Buyer/BuyersAddress/*[.!='']">
						<AddressLine><xsl:value-of select="."/></AddressLine>					
					</xsl:for-each>
					
				</Address>
				<!--Contact>
					<Name/>
					<Department/>
					<Section/>
					<UserID/>
					<InternalAddress/>
					<DDI/>
					<Switchboard/>
					<Fax/>
					<Telex/>
					<Email/>
					<Mobile/>
				</Contact>
				<Narrative/-->
			</Buyer>
			<Delivery>
				<DeliverTo>
					<DeliverToReferences>
						<BuyersCodeForLocation><xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"/></BuyersCodeForLocation>
						<!--TaxNumber/-->
						<GLN><xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/></GLN>
						<!--DUNS/>
						<RegistrationNumber/>
						<RegisteredIn/-->
					</DeliverToReferences>
					<Party><xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/></Party>
					<Address>
						
						<xsl:for-each select="PurchaseOrderHeader/ShipTo/ShipToAddress/*[.!='']">
							<AddressLine><xsl:value-of select="."/></AddressLine>
						</xsl:for-each>
						
					</Address>
					<Contact>
						<Name><xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/></Name>
						<!--Department/>
						<Section/>
						<UserID/>
						<InternalAddress/>
						<DDI/>
						<Switchboard/>
						<Fax/>
						<Telex/>
						<Email/>
						<Mobile/-->
					</Contact>
					<!--Narrative/-->
				</DeliverTo>
				<!--DeliverFrom>
					<DeliverFromReferences>
						<SuppliersCodeForLocation/>
						<BuyersCodeForLocation/>
						<TaxNumber/>
						<GLN/>
						<DUNS/>
						<RegistrationNumber/>
						<RegisteredIn/>
					</DeliverFromReferences>
					<Party/>
					<Address>
						<AddressLine/>
						<Street/>
						<City/>
						<State/>
						<PostCode/>
						<Country Code="" Codelist=""/>
					</Address>
					<Location/>
					<Contact>
						<Name/>
						<Department/>
						<Section/>
						<UserID/>
						<InternalAddress/>
						<DDI/>
						<Switchboard/>
						<Fax/>
						<Telex/>
						<Email/>
						<Mobile/>
					</Contact>
					<Narrative/>
				</DeliverFrom>
				<Carrier>
					<CarrierReferences>
						<BuyersCodeForCarrier/>
						<TaxNumber/>
						<GLN/>
						<DUNS/>
						<RegistrationNumber/>
						<RegisteredIn/>
					</CarrierReferences>
					<Party/>
					<Address>
						<AddressLine/>
						<Street/>
						<City/>
						<State/>
						<PostCode/>
						<Country Code="" Codelist=""/>
					</Address>
					<Contact>
						<Name/>
						<Department/>
						<Section/>
						<UserID/>
						<InternalAddress/>
						<DDI/>
						<Switchboard/>
						<Fax/>
						<Telex/>
						<Email/>
						<Mobile/>
					</Contact>
					<Narrative/>
				</Carrier>
				<Quantity UOMCode="" UOMDescription="" UOMCodelist="">
					<Packsize/>
					<Amount/>
				</Quantity-->
				<EarliestAcceptableDate><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></EarliestAcceptableDate>
				<LatestAcceptableDate><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></LatestAcceptableDate>
				<PreferredDate><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></PreferredDate>
				<!--ActualDeliveryDate/>
				<ExpectedDeliveryDate/-->
				
				<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
					<SpecialInstructions>PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions</SpecialInstructions>
				</xsl:if>
								
				<!--DeliveryInformation/>
				<DeliveryTerms/>
				<Narrative/-->
				
			</Delivery>
			<!--InvoiceTo>
				<InvoiceToReferences>
					<TaxNumber/>
					<GLN/>
					<DUNS/>
					<RegistrationNumber/>
					<RegisteredIn/>
					<SuppliersCodeForInvoiceTo/>
					<BuyersCodeForInvoiceTo/>
				</InvoiceToReferences>
				<Party/>
				<Address>
					<AddressLine/>
					<Street/>
					<City/>
					<State/>
					<PostCode/>
					<Country Code="" Codelist=""/>
				</Address>
				<Contact>
					<Name/>
					<Department/>
					<Section/>
					<UserID/>
					<InternalAddress/>
					<DDI/>
					<Switchboard/>
					<Fax/>
					<Telex/>
					<Email/>
					<Mobile/>
				</Contact>
				<Narrative/>
			</InvoiceTo-->
			
			<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
				<OrderLine Action="Add" >
					<!--TypeCode="" TypeDescription="" TypeCodelist=""-->
					<LineNumber Preserve="true"><xsl:value-of select="LineNumber"/></LineNumber>
					<!--OrderLineReferences>
						<ContractOrderReference/>
						<CostCentre/>
						<GeneralLedgerCode/>
						<BuyersOrderLineReference Preserve=""/>
						<ProjectCode Preserve=""/>
						<ProjectAnalysisCode Preserve=""/>
					</OrderLineReferences>
					<Originator>
						<BuyerReferences>
							<SuppliersCodeForBuyer/>
							<BuyersCodeForBuyer/>
							<TaxNumber/>
							<GLN/>
							<DUNS/>
							<Organisation/>
							<RegistrationNumber/>
							<RegisteredIn/>
						</BuyerReferences>
						<Party/>
						<Address>
							<AddressLine/>
							<Street/>
							<City/>
							<State/>
							<PostCode/>
							<Country Code="" Codelist=""/>
						</Address>
						<Contact>
							<Name/>
							<Department/>
							<Section/>
							<UserID/>
							<InternalAddress/>
							<DDI/>
							<Switchboard/>
							<Fax/>
							<Telex/>
							<Email/>
							<Mobile/>
						</Contact>
						<Narrative/>
					</Originator>
					<Extensions/-->
					<Product>
						<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
						<!--BuyersProductCode/-->
						<GTIN><xsl:value-of select="ProductID/GTIN"/></GTIN>
						<!--OtherProductCode Qualifier=""/>
						<TradedUnitCode/>
						<ConsumerUnitCode/-->
						<Description><xsl:value-of select="ProductDescription"/></Description>
						<!--Properties>
							<Quantity UOMCode="" UOMDescription="" UOMCodelist="">
								<Packsize/>
								<Amount/>
							</Quantity>
							<Length UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Width UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Depth UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Weight UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Volume UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Height UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Size UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Color UOMCode="" UOMDescription="" UOMCodelist=""/>
							<Other UOMCode="" UOMDescription="" UOMCodelist="" Description=""/>
						</Properties>
						<CommodityClass/-->
					</Product>
					<Quantity UOMCode="OrderedQuantity/@UnitOfMeasure" >
						<Packsize><xsl:value-of select="PackSize"/></Packsize>
						<Amount><xsl:value-of select="OrderedQuantity"/></Amount>
					</Quantity>
					<Price UOMCode="OrderedQuantity/@UnitOfMeasure">
						<!--Units><xsl:value-of select="?"/></Units-->
						<UnitPrice><xsl:value-of select="UnitValueExclVAT"/></UnitPrice>
						<!--SpecialPriceDescription/-->
					</Price>
					<!--PercentDiscount>
						<QualifyingTerms Code="" Codelist="">
							<PayByDate/>
							<DaysFromInvoice/>
							<DaysFromMonthEnd/>
							<DaysFromDelivery/>
						</QualifyingTerms>
						<Type Code="" Codelist=""/>
						<Percentage/>
					</PercentDiscount>
					<AmountDiscount>
						<QualifyingTerms Code="" Codelist="">
							<PayByDate/>
							<DaysFromInvoice/>
							<DaysFromMonthEnd/>
							<DaysFromDelivery/>
						</QualifyingTerms>
						<Type Code="" Codelist=""/>
						<Amount/>
					</AmountDiscount>
					<LineTax>
						<MixedRateIndicator/>
						<TaxRate Code="" Codelist=""/>
						<TaxValue/>
						<TaxRef Code="" Codelist="" Preserve=""/>
					</LineTax>
					<NetLineTotal/>
					<GrossLineTotal/-->
					<LineTotal><xsl:value-of select="LineValueExclVAT"/></LineTotal>
					<!--Delivery>
						<DeliverTo>
							<DeliverToReferences>
								<BuyersCodeForDelivery Preserve=""/>
								<BuyersCodeForLocation/>
								<TaxNumber/>
								<GLN/>
								<DUNS/>
								<RegistrationNumber/>
								<RegisteredIn/>
							</DeliverToReferences>
							<Party/>
							<Address>
								<AddressLine/>
								<Street/>
								<City/>
								<State/>
								<PostCode/>
								<Country Code="" Codelist=""/>
							</Address>
							<Location/>
							<Contact>
								<Name/>
								<Department/>
								<Section/>
								<UserID/>
								<InternalAddress/>
								<DDI/>
								<Switchboard/>
								<Fax/>
								<Telex/>
								<Email/>
								<Mobile/>
							</Contact>
							<Narrative/>
						</DeliverTo>
						<DeliverFrom>
							<DeliverFromReferences>
								<SuppliersCodeForLocation/>
								<BuyersCodeForLocation/>
								<TaxNumber/>
								<GLN/>
								<DUNS/>
								<RegistrationNumber/>
								<RegisteredIn/>
							</DeliverFromReferences>
							<Party/>
							<Address>
								<AddressLine/>
								<Street/>
								<City/>
								<State/>
								<PostCode/>
								<Country Code="" Codelist=""/>
							</Address>
							<Location/>
							<Contact>
								<Name/>
								<Department/>
								<Section/>
								<UserID/>
								<InternalAddress/>
								<DDI/>
								<Switchboard/>
								<Fax/>
								<Telex/>
								<Email/>
								<Mobile/>
							</Contact>
							<Narrative/>
						</DeliverFrom>
						<Carrier>
							<CarrierReferences>
								<BuyersCodeForCarrier/>
								<TaxNumber/>
								<GLN/>
								<DUNS/>
								<RegistrationNumber/>
								<RegisteredIn/>
							</CarrierReferences>
							<Party/>
							<Address>
								<AddressLine/>
								<Street/>
								<City/>
								<State/>
								<PostCode/>
								<Country Code="" Codelist=""/>
							</Address>
							<Contact>
								<Name/>
								<Department/>
								<Section/>
								<UserID/>
								<InternalAddress/>
								<DDI/>
								<Switchboard/>
								<Fax/>
								<Telex/>
								<Email/>
								<Mobile/>
							</Contact>
							<Narrative/>
						</Carrier>
						<Quantity UOMCode="" UOMDescription="" UOMCodelist="">
							<Packsize/>
							<Amount/>
						</Quantity>
						<EarliestAcceptableDate/>
						<LatestAcceptableDate/>
						<PreferredDate/>
						<ActualDeliveryDate/>
						<ExpectedDeliveryDate/>
						<SpecialInstructions/>
						<DeliveryInformation/>
						<DeliveryTerms/>
						<Narrative/>
					</Delivery>
					<OrderLineInformation/>
					<ExtendedDescription/>
					<Narrative/-->
				</OrderLine>
			
			</xsl:for-each>
			
			<!--PercentDiscount>
				<QualifyingTerms Code="" Codelist="">
					<PayByDate/>
					<DaysFromInvoice/>
					<DaysFromMonthEnd/>
					<DaysFromDelivery/>
				</QualifyingTerms>
				<Type Code="" Codelist=""/>
				<Percentage/>
			</PercentDiscount>
			<AmountDiscount>
				<QualifyingTerms Code="" Codelist="">
					<PayByDate/>
					<DaysFromInvoice/>
					<DaysFromMonthEnd/>
					<DaysFromDelivery/>
				</QualifyingTerms>
				<Type Code="" Codelist=""/>
				<Amount/>
			</AmountDiscount>
			<SpecialInstructions/>
			<Narrative/>
			<Settlement>
				<SettlementTerms Code="" Codelist="">
					<PayByDate/>
				</SettlementTerms>
				<SettlementMethod Code="" Codelist=""/>
				<BankDetails>
					<BankCode/>
					<BankReference/>
					<BankName/>
					<AccountName/>
					<GLN/>
					<DUNS/>
					<Address>
						<AddressLine/>
						<Street/>
						<City/>
						<State/>
						<PostCode/>
						<Country Code="" Codelist=""/>
					</Address>
					<Contact>
						<Name/>
						<Department/>
						<Section/>
						<UserID/>
						<InternalAddress/>
						<DDI/>
						<Switchboard/>
						<Fax/>
						<Telex/>
						<Email/>
						<Mobile/>
					</Contact>
				</BankDetails>
				<CardDetails CardType="Charge">
					<Issuer/>
					<Party/>
					<Address>
						<AddressLine/>
						<Street/>
						<City/>
						<State/>
						<PostCode/>
						<Country Code="" Codelist=""/>
					</Address>
					<ValidFrom/>
					<ExpiresEnd/>
					<IssueNumber/>
					<CardNumber/>
					<AuthorisationCode/>
					<SecurityCode/>
					<CRI/>
				</CardDetails>
				<SettlementBy>
					<SettlementByReferences>
						<GLN/>
						<DUNS/>
					</SettlementByReferences>
					<Party/>
					<Address>
						<AddressLine/>
						<Street/>
						<City/>
						<State/>
						<PostCode/>
						<Country Code="" Codelist=""/>
					</Address>
					<Contact>
						<Name/>
						<Department/>
						<Section/>
						<UserID/>
						<InternalAddress/>
						<DDI/>
						<Switchboard/>
						<Fax/>
						<Telex/>
						<Email/>
						<Mobile/>
					</Contact>
				</SettlementBy>
				<Contact>
					<Name/>
					<Department/>
					<Section/>
					<UserID/>
					<InternalAddress/>
					<DDI/>
					<Switchboard/>
					<Fax/>
					<Telex/>
					<Email/>
					<Mobile/>
				</Contact>
				<SettlementDiscount Code="" Codelist="">
					<PercentDiscount>
						<QualifyingTerms Code="" Codelist="">
							<PayByDate/>
							<DaysFromInvoice/>
							<DaysFromMonthEnd/>
							<DaysFromDelivery/>
						</QualifyingTerms>
						<Type Code="" Codelist=""/>
						<Percentage/>
					</PercentDiscount>
					<AmountDiscount>
						<QualifyingTerms Code="" Codelist="">
							<PayByDate/>
							<DaysFromInvoice/>
							<DaysFromMonthEnd/>
							<DaysFromDelivery/>
						</QualifyingTerms>
						<Type Code="" Codelist=""/>
						<Amount/>
					</AmountDiscount>
				</SettlementDiscount>
			</Settlement>
			<TaxSubTotal>
				<TaxRate Code="" Codelist=""/>
				<NumberOfLinesAtRate/>
				<TotalValueAtRate/>
				<SettlementDiscountAtRate/>
				<TaxableValueAtRate/>
				<TaxAtRate/>
				<NetPaymentAtRate/>
				<GrossPaymentAtRate/>
				<TaxCurrency>
					<Currency Code="" Codelist=""/>
					<AlternateCurrency Code="" Codelist=""/>
					<Rate CalculationType="D"/>
				</TaxCurrency>
			</TaxSubTotal-->
			<!--OrderTotal>
				<GoodsValue/>
				<FreightCharges/>
				<MiscCharges/>
				<TaxTotal/>
				<GrossValue/>
				<AmountPaid/>
				<AmountOutstanding/>
			</OrderTotal-->
		</Order>

	</xsl:template>
	

</xsl:stylesheet>
