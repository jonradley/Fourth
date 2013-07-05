<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************************************************************
27/06/2013	| Sahir Husssain | FB 6701 Created
*******************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<xsl:call-template name="CreateTradeSimpleHeader">
					<xsl:with-param name="SendersCodeForRecipient" select="TradeSimpleOrder/VenueId"/>
				</xsl:call-template>
				<BatchDocuments>
					<BatchDocument>
						<xsl:apply-templates select="TradeSimpleOrder"/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<xsl:template match="TradeSimpleOrder">
		<Invoice>
			<xsl:call-template name="CreateTradeSimpleHeader">
				<xsl:with-param name="SendersCodeForRecipient" select="VenueId"/>
			</xsl:call-template>
			<InvoiceHeader>
				<DocumentStatus>Original</DocumentStatus>
				<Buyer>
					<BuyersLocationID>
						<BuyersCode><xsl:value-of select="CustomerBusinessName"/></BuyersCode>
						<SuppliersCode><xsl:value-of select="VenueId"/></SuppliersCode>
					</BuyersLocationID>
					<BuyersAddress>
						<xsl:apply-templates select="CustomerAddress"/>
					</BuyersAddress>
				</Buyer>
				<Supplier>
						<SuppliersLocationID>
							<SuppliersCode><xsl:value-of select="SupplierName"/></SuppliersCode>
						</SuppliersLocationID>
						<SuppliersAddress>
							<xsl:apply-templates select="SupplierAddress"/>
						</SuppliersAddress>
					</Supplier>
				<ShipTo>
					<ShipToLocationID>
						<SuppliersCode><xsl:value-of select="VenueId"/></SuppliersCode>
					</ShipToLocationID>
				</ShipTo>
				<InvoiceReferences>
					<InvoiceReference><xsl:value-of select="InvoiceReference"/></InvoiceReference>
					<InvoiceDate><xsl:value-of select="InvoiceDate"/></InvoiceDate>
					<TaxPointDate><xsl:value-of select="InvoiceDate"/></TaxPointDate>
					<VATRegNo><xsl:value-of select="SupplierVatNumber"/></VATRegNo>
				</InvoiceReferences>
				<Currency>GBP</Currency>
			</InvoiceHeader>
			<InvoiceDetail>
				<xsl:apply-templates select="TradeSimpleItems/TradeSimpleOrderItem"/>
			</InvoiceDetail>
			<xsl:call-template name="CreateInvoiceTrailer"/>
		</Invoice>
	</xsl:template>
	<xsl:template match="TradeSimpleItems/TradeSimpleOrderItem">
		<InvoiceLine>
			<LineNumber><xsl:value-of select="position()"/></LineNumber>
			<PurchaseOrderReferences>
				<PurchaseOrderReference><xsl:value-of select="../../PurchaseOrderReference"/></PurchaseOrderReference>
				<PurchaseOrderDate><xsl:value-of select="../../PurchaseOrderDate"/></PurchaseOrderDate>
			</PurchaseOrderReferences>
			<ProductID>
				<SuppliersProductCode>
					<xsl:value-of select="./ProductCode"/>
				</SuppliersProductCode>
			</ProductID>
			<xsl:copy-of select="ProductDescription"/>
			<InvoicedQuantity><xsl:apply-templates select="Qty"/></InvoicedQuantity>
			<PackSize><xsl:value-of select="QtyPerPack"/></PackSize>
			<UnitValueExclVAT><xsl:apply-templates select="UnitValue"/></UnitValueExclVAT>
			<LineValueExclVAT><xsl:apply-templates select="RowValue"/></LineValueExclVAT>
			<VATCode><xsl:value-of select="VatCode"/></VATCode>
			<VATRate><xsl:apply-templates select="VatRate"/></VATRate>
		</InvoiceLine>
	</xsl:template>
	<xsl:template match="Qty">
		<xsl:variable name="sUoM">
			<xsl:call-template name="translateUoM">
				<xsl:with-param name="givenUoM" select="./UnitOfMeasure"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="string-length($sUoM) &gt; 0">
			<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$sUoM"/></xsl:attribute>
		</xsl:if>
		<xsl:value-of select="format-number(., '0.000')"/>
	</xsl:template>
	<xsl:template match="UnitValue | RowValue | VatRate">
		<xsl:value-of select="format-number(., '0.00')"/>
	</xsl:template>	
	<xsl:template name="CreateTradeSimpleHeader">
		<xsl:param name="SendersCodeForRecipient"/>
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:value-of select="$SendersCodeForRecipient"/>
			</SendersCodeForRecipient>
		</TradeSimpleHeader>
	</xsl:template>
	<xsl:template match="CustomerAddress | SupplierAddress">
		<AddressLine1><xsl:value-of select="."/></AddressLine1>
	</xsl:template>
	<xsl:template name="CreateInvoiceTrailer">
		<InvoiceTrailer>
			<NumberOfLines><xsl:value-of select="count(//TradeSimpleOrderItem)"/></NumberOfLines>
			<NumberOfItems><xsl:value-of select="sum(//TradeSimpleOrderItem/Qty)"/></NumberOfItems>
			<DocumentTotalExclVAT><xsl:value-of select="sum(//TradeSimpleOrderItem/RowValue)"/></DocumentTotalExclVAT>
		</InvoiceTrailer>
	</xsl:template>
	<!--Decode UOM-->
	<xsl:template name="translateUoM">
		<xsl:param name="givenUoM"/>
		<xsl:choose>
			<xsl:when test="$givenUoM = 'KG'">KGM</xsl:when>
			<xsl:when test="$givenUoM = 'EACH'">EA</xsl:when>
			<xsl:when test="$givenUoM = 'CASE'">CS</xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
