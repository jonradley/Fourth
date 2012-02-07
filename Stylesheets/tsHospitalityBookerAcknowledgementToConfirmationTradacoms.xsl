<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
		?		|			?			| Created module
**********************************************************************
R Cambridge	| 2011-06-07		| 4520 Added back order quantity and unit price
**********************************************************************
				|						|				
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<xsl:for-each select="Batch/BatchDocuments/BatchDocument/PurchaseOrderConfirmation">
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo"><xsl:text>3</xsl:text></xsl:attribute>
							<PurchaseOrderConfirmation>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
									<!--
										<xsl:choose>
											<xsl:when test="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode='5027615900022'">
												<xsl:choose>
													<xsl:when test="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode !=''">
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
											</xsl:otherwise>
										</xsl:choose>
									-->
									<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
									</SendersCodeForRecipient>
								</TradeSimpleHeader>
								<PurchaseOrderConfirmationHeader>
									<DocumentStatus>Original</DocumentStatus>
									<Buyer>
										<xsl:apply-templates select="PurchaseOrderConfirmationHeader/Buyer/*"/>
										<!--BuyersLocationID>
											<GLN/>
										</BuyersLocationID-->
									</Buyer>
									<Supplier>
										<xsl:apply-templates select="PurchaseOrderConfirmationHeader/Supplier/*"/>
										<!--SuppliersLocationID>
											<GLN/>
										</SuppliersLocationID-->
									</Supplier>
									<ShipTo>
									
									<!--
										<ShipToLocationID>
										
											<BuyersCode>
												<xsl:choose>
													<xsl:when test="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode='5027615900022'">
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</BuyersCode>
											
											<SuppliersCode>
												<xsl:choose>
													<xsl:when test="PurchaseOrderConfirmationHeader/Buyer/BuyersLocationID/SuppliersCode='5027615900022'">
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/BuyersCode"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
													</xsl:otherwise>
												</xsl:choose>
											</SuppliersCode>
										</ShipToLocationID>
										
										<ShipToName>
											<xsl:value-of select="PurchaseOrderConfirmationHeader/ShipTo/ShipToName"/>
										</ShipToName>
										<ShipToAddress>
											<xsl:apply-templates select="PurchaseOrderConfirmationHeader/ShipTo/ShipToAddress/*"/>
										</ShipToAddress>
										
										-->
										<xsl:apply-templates select="PurchaseOrderConfirmationHeader/ShipTo/*"/>
										
									</ShipTo>
									<PurchaseOrderReferences>
										<PurchaseOrderReference>
											<xsl:value-of 	select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
										</PurchaseOrderReference>
										<xsl:variable name="PODate" select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
										<PurchaseOrderDate>
											<xsl:value-of select="concat('20',substring($PODate,1,2),'-',substring($PODate,3,2),'-',substring($PODate,5,2))"/>
										</PurchaseOrderDate>
										<!--xsl:apply-templates select="PurchaseOrderConfirmationHeader/PurchaseOrderReferences/*"/-->
									</PurchaseOrderReferences>
									<PurchaseOrderConfirmationReferences>
										<PurchaseOrderConfirmationReference>
											<xsl:value-of 	select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
										</PurchaseOrderConfirmationReference>
										<xsl:variable name="POConDate" select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
										<PurchaseOrderConfirmationDate>
											<xsl:value-of 	select="concat('20',substring($POConDate,1,2),'-',substring($POConDate,3,2),'-',substring($POConDate,5,2))"/>
										</PurchaseOrderConfirmationDate>
										<!--xsl:apply-templates select="PurchaseOrderConfirmationHeader/PurchaseOrderConfirmationReferences/*"/-->
									</PurchaseOrderConfirmationReferences>
									<OrderedDeliveryDetails>
										<xsl:apply-templates select="PurchaseOrderConfirmationHeader/OrderedDeliveryDetails/DeliveryDate"/>
									</OrderedDeliveryDetails>
									<ConfirmedDeliveryDetails>
										<xsl:apply-templates select="PurchaseOrderConfirmationHeader/ConfirmedDeliveryDetails/DeliveryDate"/>
									</ConfirmedDeliveryDetails>
								</PurchaseOrderConfirmationHeader>
								<PurchaseOrderConfirmationDetail>
									<xsl:for-each select="PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine">
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
												<xsl:value-of select="format-number(OrderedQuantity,'0.00')"/>
											</OrderedQuantity>
											<ConfirmedQuantity>
												<xsl:value-of select="format-number(ConfirmedQuantity,'0.00')"/>
											</ConfirmedQuantity>
											<xsl:for-each select="BackOrderQuantity[.!=''][1]">
												<BackOrderQuantity>
													<xsl:value-of select="."/>
												</BackOrderQuantity>
											</xsl:for-each>
											<xsl:for-each select="UnitValueExclVAT[.!=''][1]">
												<UnitValueExclVAT>
													<xsl:value-of select="format-number(. div 100, '0.00')"/>
												</UnitValueExclVAT>
											</xsl:for-each>
										</PurchaseOrderConfirmationLine>
									</xsl:for-each>
								</PurchaseOrderConfirmationDetail>
							</PurchaseOrderConfirmation>
						</BatchDocument>
					</xsl:for-each>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:copy>
			<xsl:for-each select="*[contains(name(),'Address')][string(.) != '']">
				<xsl:element name="{concat('AddressLine', position())}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:for-each>
			<PostCode>
				<xsl:value-of select="PostCode"/>
			</PostCode>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | PurchaseOrderConfirmationDate | DeliveryDate">
		<xsl:copy>
			<xsl:value-of select="concat('20',substring(.,1,2),'-',substring(.,3,2),'-',substring(.,5,2))"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>