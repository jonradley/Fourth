<?xml version="1.0" encoding="UTF-8"?>
<!--
***************************************************************************************
Generic Orders inbound mapper for iTN
***************************************************************************************
Name			| Date 				|	Description
***************************************************************************************
J Miguel		| 15/03/2016	| FB10876 - Created
***************************************************************************************
J Miguel		| 25/05/2016	| FB11028 - Adding support for more units of measure
***************************************************************************************
J Miguel		| 24/08/2016	| FB11267 - Map the SupplierCode instead of the their GLN
***************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:itn="http://itn.hub.biztalk.orderapp.ext.GenericITNSupplier.schemas.Order" exclude-result-prefixes="#default xsl itn">
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	<!-- Creates the container for the orders (one really) -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:apply-templates select="itn:GenericITNSupplierOrder"/>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<!-- Translate one order -->
	<xsl:template match="itn:GenericITNSupplierOrder">
		<BatchDocument DocumentTypeNo="2">
			<PurchaseOrder>
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="itn:SupplierDetails/itn:SupplierId"/>
					</SendersCodeForRecipient>
				</TradeSimpleHeader>
				<PurchaseOrderHeader>
					<Buyer>
						<BuyersLocationID>
							<GLN>
								<xsl:value-of select="itn:BuyerDetails/itn:BuyerGLN"/>
							</GLN>
							<BuyersCode>
								<xsl:value-of select="itn:BuyerDetails/itn:BuyerGroup/itn:BuyerGroupGLN"/>
							</BuyersCode>
						</BuyersLocationID>
						<BuyersName>
							<xsl:value-of select="itn:BuyerDetails/itn:BuyerGroup/itn:BuyerGroupName"/>
						</BuyersName>
					</Buyer>
					<Supplier>
						<SuppliersLocationID>
							<GLN>
								<xsl:value-of select="itn:SupplierDetails/itn:SupplierGLN"/>
							</GLN>
							<BuyersCode>
								<xsl:value-of select="itn:SupplierDetails/itn:SupplierId"/>
							</BuyersCode>
						</SuppliersLocationID>
						<SuppliersName>
							<xsl:value-of select="itn:SupplierDetails/itn:SupplierName"/>
						</SuppliersName>
					</Supplier>
					<ShipTo>
						<ShipToLocationID>
							<BuyersCode>
								<xsl:value-of select="itn:OrderHeader/itn:CustomerAccountNumber"/>
							</BuyersCode>
							<SuppliersCode>
								<xsl:value-of select="itn:OrderHeader/itn:CustomerAccountNumber"/>
							</SuppliersCode>
						</ShipToLocationID>
					</ShipTo>
					<PurchaseOrderReferences>
						<PurchaseOrderReference>
							<xsl:value-of select="itn:OrderHeader/itn:ItnOrderNumber"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="itn:OrderHeader/itn:OrderCreationDate"/>
						</PurchaseOrderDate>
					</PurchaseOrderReferences>
					<OrderedDeliveryDetails>
						<DeliveryType>Delivery</DeliveryType>
						<DeliveryDate>
							<xsl:value-of select="itn:OrderHeader/itn:DeliveryDate"/>
						</DeliveryDate>
					</OrderedDeliveryDetails>
				</PurchaseOrderHeader>
				<!-- Generate all lines -->
				<PurchaseOrderDetail>
					<xsl:apply-templates select="itn:LineItems/itn:LineItem"/>
				</PurchaseOrderDetail>
			</PurchaseOrder>
		</BatchDocument>
	</xsl:template>
	<!-- Translate one order line -->
	<xsl:template match="itn:LineItems/itn:LineItem">
		<PurchaseOrderLine>
			<LineNumber>
				<xsl:value-of select="itn:LineNumber"/>
			</LineNumber>
			<ProductID>
				<xsl:if test="itn:ProductGTIN!=''">
					<GTIN>
						<xsl:value-of select="itn:ProductGTIN"/>
					</GTIN>
				</xsl:if>
				<SuppliersProductCode>
					<xsl:value-of select="itn:ProductCode"/>
				</SuppliersProductCode>
			</ProductID>
			<xsl:if test="itn:ProductDescription!=''">
				<ProductDescription>
					<xsl:value-of select="itn:ProductDescription"/>
				</ProductDescription>
			</xsl:if>
			<OrderedQuantity>
				<xsl:attribute name="UnitOfMeasure">
					<xsl:choose>
						<xsl:when test="itn:UnitOfMeasure='BAG'"><xsl:text>CS</xsl:text></xsl:when>
						<xsl:when test="itn:UnitOfMeasure='BOX'"><xsl:text>CS</xsl:text></xsl:when>
						<xsl:when test="itn:UnitOfMeasure='CAR'"><xsl:text>CS</xsl:text></xsl:when>
						<xsl:when test="itn:UnitOfMeasure='PK'"><xsl:text>PF</xsl:text></xsl:when>
						<xsl:when test="itn:UnitOfMeasure='HR'"><xsl:text>HUR</xsl:text></xsl:when>
						<xsl:when test="itn:UnitOfMeasure='KG'"><xsl:text>KGM</xsl:text></xsl:when>
						<xsl:otherwise><xsl:text>EA</xsl:text></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:value-of select="itn:OrderedQuantity"/>
			</OrderedQuantity>
			<xsl:if test="itn:PackQuantity/itn:PackSize!=''">
				<PackSize>
					<xsl:value-of select="itn:PackQuantity/itn:PackSize"/>
				</PackSize>
			</xsl:if>
			<UnitValueExclVAT>
				<xsl:value-of select="itn:UnitPrice"/>
			</UnitValueExclVAT>
			<LineValueExclVAT>
				<xsl:value-of select="itn:LineItemPrice"/>
			</LineValueExclVAT>
		</PurchaseOrderLine>
	</xsl:template>
</xsl:stylesheet>
