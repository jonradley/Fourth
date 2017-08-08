<?xml version="1.0" encoding="UTF-8"?>
<!--
***********************************************************************************************
 Overview

 Create XML representing the Orchestration Order Created message for a given TS purchase order

 © Fourth 2017
***********************************************************************************************
 Module History
***********************************************************************************************
 Date          | Name               | Description of modification
***********************************************************************************************
 04/08/2017    | R Cambridge        | US34409
***********************************************************************************************

***********************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:param name="ReferenceFilepath"/>
	
	<xsl:variable name="ReferenceDocument" select="document($ReferenceFilepath)"/>
	
	<xsl:template match="@*|node()" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="SubscriptionDetails" priority="2">
	
		<SubscriptionDetails>
		
			<xsl:for-each select="/OrderCreatedEvent/SubscriptionDetails/SequenceNumber"><SequenceNumber><xsl:value-of select ="."/></SequenceNumber></xsl:for-each>			
			<xsl:for-each select="/OrderCreatedEvent/SubscriptionDetails/CustomerCanonicalId"><CustomerCanonicalId><xsl:value-of select ="."/></CustomerCanonicalId></xsl:for-each>
			<xsl:for-each select="/OrderCreatedEvent/SubscriptionDetails/SourceSystem"><SourceSystem><xsl:value-of select ="."/></SourceSystem></xsl:for-each>

			<!-- Order details -->
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"><OrderReference><xsl:value-of select ="."/></OrderReference></xsl:for-each>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"><OrderDate><xsl:value-of select ="."/></OrderDate></xsl:for-each>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"><DeliveryDate><xsl:value-of select ="."/></DeliveryDate></xsl:for-each>
			<xsl:for-each select="/OrderCreatedEvent/SubscriptionDetails/CurrencyIso4217Code"><CurrencyIso4217Code><xsl:value-of select ="."/></CurrencyIso4217Code></xsl:for-each>
			
			<!-- May be needed by Adaco in future -->
			<IsDeliveryNoteRequired>1</IsDeliveryNoteRequired>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"><Note><xsl:value-of select ="."/></Note></xsl:for-each>
			
			<!-- Supplier details -->
			<!--xsl:for-each select=""><SupplierExternalId><xsl:value-of select ="."/></SupplierExternalId></xsl:for-each-->
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"><SupplierCode><xsl:value-of select ="."/></SupplierCode></xsl:for-each>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/Supplier/SuppliersName"><SupplierName><xsl:value-of select ="."/></SupplierName></xsl:for-each>	
			<!-- Customer (recipient) details -->
			<!--xsl:for-each select=""><LocationExternalId><xsl:value-of select ="."/></LocationExternalId></xsl:for-each-->
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"><LocationCode><xsl:value-of select ="."/></LocationCode></xsl:for-each>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderHeader/ShipTo/ShipToLocationID/BuyersCode"><LocationName><xsl:value-of select ="."/></LocationName></xsl:for-each>
						
			<xsl:call-template name="WriteLines">
				<xsl:with-param name="CurrencyIso4217Code" select="/OrderCreatedEvent/SubscriptionDetails/CurrencyIso4217Code"/>
			</xsl:call-template>
			
		</SubscriptionDetails>
		
	</xsl:template>
	
	<xsl:template name="WriteLines">
		<xsl:param name="CurrencyIso4217Code"/>
		<Lines>
			<xsl:for-each select="$ReferenceDocument/PurchaseOrder/PurchaseOrderDetail/PurchaseOrderLine">
				<OrderLine>
					<xsl:for-each select="LineNumber">
						<LineNumber>
							<xsl:value-of select="."/>
						</LineNumber>
					</xsl:for-each>
					<xsl:for-each select="ProductID/SuppliersProductCode">
						<SupplierProductCode>
							<xsl:value-of select="."/>
						</SupplierProductCode>
					</xsl:for-each>
					<xsl:for-each select="ProductDescription">
						<ProductDescription>
							<xsl:value-of select="."/>
						</ProductDescription>
					</xsl:for-each>
					<xsl:for-each select="OrderedQuantity">
						<OrderedQuantity>
							<xsl:value-of select="."/>
						</OrderedQuantity>
					</xsl:for-each>
					<xsl:for-each select="@UnitOfMeasure">
						<OrderUnitCode>
							<xsl:value-of select="."/>
						</OrderUnitCode>
					</xsl:for-each>
					<xsl:for-each select="PackSize">
						<OrderUnitDescription>
							<xsl:value-of select="."/>
						</OrderUnitDescription>
					</xsl:for-each>
					<xsl:for-each select="UnitValueExclVAT">
						<UnitPriceExcludingVAT>
							<xsl:value-of select="."/>
						</UnitPriceExcludingVAT>
					</xsl:for-each>
					<xsl:if test="CurrencyIso4217Code != ''">
						<CurrencyIso4217Code>
							<xsl:value-of select="$CurrencyIso4217Code"/>
						</CurrencyIso4217Code>
					</xsl:if>
				</OrderLine>
			</xsl:for-each>
		</Lines>
	</xsl:template>
	
</xsl:stylesheet>
