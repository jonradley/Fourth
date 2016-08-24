<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 This XSL file is used to transform the XML of an MGR Pending Delivery Modified document
 that has been through Subs DB Extract using a reference document from the Document Repository

 © Fourth 2016
******************************************************************************************
 Module History
******************************************************************************************
 Date				| Name				| Description of modification
******************************************************************************************
 30/06/2016		|	Graham Neicho	| US13167. Created module.
******************************************************************************************
 29/07/2016		|	Sandeep Sehgal	| US19670 Added QuantityPrecison and CurrencyPrecision
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:param name="ReferenceFilepath"/>
	<xsl:variable name="ReferenceDocument" select="document($ReferenceFilepath)"/>
	<xsl:variable name="CurrencyPrecision" select="2" />
	<xsl:variable name="QuantityPrecision" select="4" />

	
	<xsl:template match="@*|node()" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="SubscriptionDetails" priority="2">
		<SubscriptionDetails>
			<xsl:apply-templates />
			<xsl:call-template name="WriteLines">
				<xsl:with-param name="LocationId" select="LocationId"/>
				<xsl:with-param name="Status" select="Status"/>
			</xsl:call-template>
		</SubscriptionDetails>
	</xsl:template>
	
	<xsl:template name="WriteLines">
		<xsl:param name="LocationId"/>
		<xsl:param name="Status"/>
		<xsl:if test="$ReferenceDocument/*/*[substring(local-name(), string-length(local-name()) - string-length('Detail') + 1) = 'Detail']/*[substring(local-name(), string-length(local-name()) - string-length('Line') + 1) = 'Line']">
			<Lines>
				<xsl:for-each select="$ReferenceDocument/*/*[substring(local-name(), string-length(local-name()) - string-length('Detail') + 1) = 'Detail']/*[substring(local-name(), string-length(local-name()) - string-length('Line') + 1) = 'Line']">
					<Item>
						<LineId><xsl:value-of select="LineNumber"/></LineId>
						<ProductNumber><xsl:value-of select="ProductID/SuppliersProductCode"/></ProductNumber>
						<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
						<OrderUnit><xsl:value-of select="OrderedQuantity[local-name(..) = 'PurchaseOrderLine']/@UnitOfMeasure | ConfirmedQuantity[local-name(..) = 'PurchaseOrderConfirmationLine']/@UnitOfMeasure | DespatchedQuantity[(local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine')]/@UnitOfMeasure | InvoicedQuantity[local-name(..) = 'InvoiceLine']/@UnitOfMeasure | AcceptedQuantity[local-name(..) = 'GoodsReceivedNoteLine']/@UnitOfMeasure"/></OrderUnit>
						<ReceivedUnit><xsl:value-of select="DespatchedQuantity[(local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine')]/@UnitOfMeasure | InvoicedQuantity[local-name(..) = 'InvoiceLine']/@UnitOfMeasure | AcceptedQuantity[local-name(..) = 'GoodsReceivedNoteLine']/@UnitOfMeasure"/></ReceivedUnit>
						<OrderedQuantity><xsl:value-of select="OrderedQuantity[local-name(..) = 'PurchaseOrderLine'] | ConfirmedQuantity[local-name(..) = 'PurchaseOrderConfirmationLine'] | DespatchedQuantity[(local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine')] | InvoicedQuantity[local-name(..) = 'InvoiceLine'] | AcceptedQuantity[local-name(..) = 'GoodsReceivedNoteLine']"/></OrderedQuantity>
						<ReceivedQuantity><xsl:value-of select="AcceptedQuantity"/></ReceivedQuantity>
						<OrderedUnitPrice><xsl:value-of select="UnitValueExclVAT[local-name(..) = 'PurchaseOrderLine' or local-name(..) = 'PurchaseOrderConfirmationLine']"/></OrderedUnitPrice>
						<ReceivedUnitPrice><xsl:value-of select="UnitValueExclVAT[local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine' or local-name(..) = 'InvoiceLine' or local-name(..) = 'GoodsReceivedNoteLine']"/></ReceivedUnitPrice>
						<OrderedCurrencyCode/>
						<ReceivedCurrencyCode/>
						<IsPriceEditable/>
						<IsCatchweight>
							<xsl:choose>
								<xsl:when test="LineExtraData/IsCatchweightProduct"><xsl:value-of select="LineExtraData/IsCatchweightProduct"/></xsl:when>
								<xsl:when test="OrderedQuantity/@UnitOfMeasure and (DespatchedQuantity[(local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine')]/@UnitOfMeasure | InvoicedQuantity[local-name(..) = 'InvoiceLine']/@UnitOfMeasure | AcceptedQuantity[local-name(..) = 'GoodsReceivedNoteLine']/@UnitOfMeasure)">
									<xsl:choose>
										<xsl:when test="OrderedQuantity/@UnitOfMeasure = (DespatchedQuantity[(local-name(..) = 'DeliveryNoteLine' or local-name(..) = 'ProofOfDeliveryLine')]/@UnitOfMeasure | InvoicedQuantity[local-name(..) = 'InvoiceLine']/@UnitOfMeasure | AcceptedQuantity[local-name(..) = 'GoodsReceivedNoteLine']/@UnitOfMeasure)">FALSE</xsl:when>
										<xsl:otherwise>TRUE</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</IsCatchweight>
						<Status><xsl:value-of select="$Status"/></Status>
						<OutletId><xsl:value-of select="$LocationId"/></OutletId>
						<CurrencyPrecision><xsl:value-of select="$CurrencyPrecision"/></CurrencyPrecision>
						<QuantityPrecision><xsl:value-of select="$QuantityPrecision"/></QuantityPrecision>
					</Item>
				</xsl:for-each>
			</Lines>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>