<!--=========================================================================
KOShaughnessy | 10/08/2012	| FB5609 created
=============================================================================
KOShaughnessy | 17/09/2012	| FB 5708 bugfix to change the location of suppliers code for unit.
=============================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:output method="xml" encoding="UTF-8"/>
	
	<xsl:template match="/PurchaseOrder">

	<Order xmlns="urn:schemas-basda-org:2000:purchaseOrder:xdr:3.01" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:schemas-basda-org:2000:purchaseOrder:xdr:3.01 order-v3.xsd">
	
		<OrderHead>
		
			<Schema>
				<Version>3.05</Version>
			</Schema>
			
			<Parameters>
				<Language>en-GB</Language>
				<DecimalSeparator>.</DecimalSeparator>
				<Precision>20.3</Precision>
			</Parameters>
			
			<OrderType Code="PUO">Purchase Order</OrderType>
		
			<OrderCurrency>
				<Currency>
				<xsl:attribute name="Code">
					<xsl:text>GBP</xsl:text>
				</xsl:attribute>
				</Currency>
			</OrderCurrency>
			
			<Checksum>
				<xsl:text>0</xsl:text>
			</Checksum>
			
		</OrderHead>
		
		<OrderReferences>
		
			<ContractOrderReference>
				<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</ContractOrderReference>
			
			<BuyersOrderNumber>
				<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</BuyersOrderNumber>
			
		</OrderReferences>
		
		<OrderDate>
			<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
		</OrderDate>
		
		<Supplier>
			<Party>
				<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/>
			</Party>
		</Supplier>
		
		<Buyer>
			<BuyerReferences>
			
				<SuppliersCodeForBuyer>
					<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersLocationID/SuppliersCode"/>
				</SuppliersCodeForBuyer>
				
				<BuyersCodeForBuyer>
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</BuyersCodeForBuyer>
				
			</BuyerReferences>
			
			<Party>
				<xsl:value-of select="PurchaseOrderHeader/Buyer/BuyersName"/>			
			</Party>
			
		</Buyer>
		
		<Delivery>
			<DeliverTo>
			
				<DeliverToReferences>
					<BuyersCodeForLocation>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</BuyersCodeForLocation>
				</DeliverToReferences>
				
				<Party>
					<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
				</Party>
				
				<Address>
					<AddressLine>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</AddressLine>
					
					<AddressLine>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</AddressLine>
					
					<AddressLine>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</AddressLine>

					<AddressLine>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine4"/>
					</AddressLine>
					
					<PostCode>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
					</PostCode>
					
					<Country>GBR</Country>
				</Address>

			</DeliverTo>
			
			<DeliverFrom>
				<DeliverFromReferences>
					<SuppliersCodeForLocation>
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</SuppliersCodeForLocation>
				</DeliverFromReferences>
			</DeliverFrom>
			
		</Delivery>
		
		<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			<OrderLine>
			
				<LineNumber>
					<xsl:value-of select="LineNumber"/>
				</LineNumber>
				
				<OrderLineReferences>
					<ContractOrderReference>
						<xsl:value-of select="//PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
					</ContractOrderReference>
				</OrderLineReferences>
				
				<Product>
					<SuppliersProductCode>
						<xsl:value-of select="ProductID/SuppliersProductCode"/>
					</SuppliersProductCode>
					<Description>
						<xsl:value-of select="ProductDescription"/>
					</Description>
				</Product>
				
				<Quantity>
					<Packsize>
						<xsl:value-of select="PackSize"/>
					</Packsize>
					<Amount>
						<xsl:value-of select="OrderedQuantity"/>
					</Amount>
				</Quantity>
				
				<Price>
				<xsl:attribute name="UOMCode">
					<xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/>
				</xsl:attribute>
					<Units>1</Units>
					<UnitPrice>
						<xsl:value-of select="UnitValueExclVAT"/>
					</UnitPrice>
				</Price>
				
				<LineTotal>
					<xsl:value-of select="LineValueExclVAT"/>
				</LineTotal>
				
			</OrderLine>
		</xsl:for-each>
		
		<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions">
			<SpecialInstructions>
				<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
			</SpecialInstructions>
		</xsl:if>
		
	</Order>
	
	</xsl:template>
</xsl:stylesheet>
