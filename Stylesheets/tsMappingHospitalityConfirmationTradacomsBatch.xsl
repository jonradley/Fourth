<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<PurchaseOrderConfirmation>
				<TradeSimpleHeader>
					<xsl:copy-of select="/PurchaseOrderConfirmation/TradeSimpleHeader/SendersCodeForRecipient"/>
				</TradeSimpleHeader>
				<PurchaseOrderConfirmationHeader>
					<DocumentStatus>Original</DocumentStatus>
					<Buyer>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Buyer/*"/>				
						<!--BuyersLocationID>
							<GLN/>
						</BuyersLocationID-->
					</Buyer>
					<Supplier>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/Supplier/*"/>
						<!--SuppliersLocationID>
							<GLN/>
						</SuppliersLocationID-->
					</Supplier>
					<ShipTo>
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ShipTo/*"/>
						<!--ShipToLocationID>
							<GLN/>
						</ShipToLocationID>
						<ShipToAddress>
							<AddressLine1/>
						</ShipToAddress-->
					</ShipTo>
					<PurchaseOrderReferences>
						<!--PurchaseOrderReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderReferences/*"/>
					</PurchaseOrderReferences>
					
					<PurchaseOrderConfirmationReferences>
						<!--PurchaseOrderConfirmationReference>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						</PurchaseOrderConfirmationReference>
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
						</PurchaseOrderConfirmationDate-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/*"/>
					</PurchaseOrderConfirmationReferences>
					
					<OrderedDeliveryDetails>
						<!--DeliveryType></DeliveryType-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
						<!--DeliveryDate><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/></DeliveryDate-->
					</OrderedDeliveryDetails>
					<ConfirmedDeliveryDetails>
						<!--DeliveryType/-->
						<xsl:apply-templates select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
						
						<!--DeliveryDate><xsl:value-of select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/></DeliveryDate-->
					</ConfirmedDeliveryDetails>
				</PurchaseOrderConfirmationHeader>
				<PurchaseOrderConfirmationDetail>
					<xsl:for-each select="/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
						<PurchaseOrderConfirmationLine>
							<LineNumber>
								<xsl:value-of select="count(preceding-sibling::* | self::*)"/>
							</LineNumber>
							<ProductID>
								<!--GTIN>55555555555555</GTIN>
								<SuppliersProductCode>
									<xsl:value-of select="SuppliersProductCode"/>
								</SuppliersProductCode>
								<xsl:if test="string(BuyersProductCode) != ''">
									<BuyersProductCode>
										<xsl:value-of select="BuyersProductCode"/>
									</BuyersProductCode>
								</xsl:if-->
								<xsl:apply-templates select="ProductID/*"/>
							</ProductID>
							<ProductDescription>
								<xsl:value-of select="ProductDescription"/>
							</ProductDescription>
							<OrderedQuantity>
								<xsl:value-of select="format-number(OrderedQuantity div 1000,'0.000')"/>
							</OrderedQuantity>
							<ConfirmedQuantity>
								<xsl:value-of select="format-number(ConfirmedQuantity div 1000,'0.000')"/>
							</ConfirmedQuantity>
							<UnitValueExclVAT>
								<xsl:value-of select="format-number(UnitValueExclVAT div 10000,'0.0000')"/>
							</UnitValueExclVAT>
						</PurchaseOrderConfirmationLine>
					</xsl:for-each>
				</PurchaseOrderConfirmationDetail>
				<PurchaseOrderConfirmationTrailer>
					<NumberOfLines>
						<xsl:value-of select="count(/PurchaseOrderConfirmation/PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine)"/>
					</NumberOfLines>
				</PurchaseOrderConfirmationTrailer>
			</PurchaseOrderConfirmation>
		</BatchRoot>	
	</xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<!--xsl:with-param name="vobjAddressElements"/-->
				
		<xsl:copy>
			<xsl:for-each select="*[contains(name(),'Address')][string(.) != '']">
				<xsl:element name="{concat('AddressLine', position())}"><xsl:value-of select="."/></xsl:element>		
			</xsl:for-each>
			<PostCode><xsl:value-of select="PostCode"/></PostCode>
		</xsl:copy>
	
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat('20',substring(.,1,2),'-',substring(.,3,2),'-',substring(.,5,2))"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
