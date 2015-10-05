<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Fairfax Procurement Wizards Email attachment to xml mapper
**********************************************************************
Name		| Date       | Change
**********************************************************************
J Miguel	| 30/09/2015 | FB10511 - Email orders in
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<!-- Prepare Root element -->
	<xsl:template match="/Document">
		<xsl:variable name="BuyersCode" select="L1[L2[1]='Purchaser Account Code']/L2[2]"/>
		<xsl:variable name="BuyersName" select="L1[L2[1]='Purchaser Details']/L2[2]"/>
		<xsl:variable name="PurchaseOrderReference" select="L1[L2[1]='Order ID']/L2[2]"/>
		<xsl:variable name="PurchaseOrderDate" >
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="L1[L2[1]='Date Created']/L2[2]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="PurchaseOrderTime" select="concat(substring-after(L1[L2[1]='Date Created']/L2[2], ' '), ':00')"/>
		<xsl:variable name="SuppliersCode" select="L1[L2[1]='Supplier']/L2[2]"/>
		<xsl:variable name="SuppliersName" select="L1[L2[1]='Supplier']/L2[2]"/>
		<xsl:variable name="ShipToName" select="L1[L2[1]='Purchaser Unit']/L2[2]"/>
		<xsl:variable name="ContactName" select="L1[L2[1]='Purchaser Unit']/L2[2]"/>
		<xsl:variable name="DeliveryDate" >
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="L1[L2[1]='Requested Delivery Date']/L2[2]"/>
			</xsl:call-template>		
		</xsl:variable>
		<xsl:variable name="TotalExclVAT" select="substring-after(L1[L2[1]='']/L2[7], '£')"/>
		<xsl:variable name="SpecialDeliveryInstructions" select="L1[L2[1]='Purchase Order Comments']/following-sibling::L1[1]/L2[1]"/>
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="2">
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="$SuppliersCode"/></SendersCodeForRecipient>
								<SendersName><xsl:value-of select="$SuppliersName"/></SendersName>
								<TestFlag>0</TestFlag>
							</TradeSimpleHeader>
							<PurchaseOrderHeader>
								<Buyer>
									<BuyersLocationID>
										<GLN>5555555555555</GLN>
										<BuyersCode><xsl:value-of select="$BuyersCode"/></BuyersCode>
									</BuyersLocationID>
									<BuyersName><xsl:value-of select="$BuyersName"/></BuyersName>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN>5555555555555</GLN>
										<SuppliersCode><xsl:value-of select="$SuppliersCode"/></SuppliersCode>
									</SuppliersLocationID>
									<SuppliersName><xsl:value-of select="$SuppliersName"/></SuppliersName>
								</Supplier>
								<ShipTo>
									<ShipToLocationID>
										<GLN>5555555555555</GLN>
										<SuppliersCode><xsl:value-of select="$BuyersCode"/></SuppliersCode>
									</ShipToLocationID>
									<ShipToName><xsl:value-of select="$ShipToName"/></ShipToName>
									<ContactName><xsl:value-of select="$ContactName"/></ContactName>
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="$PurchaseOrderReference"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="$PurchaseOrderDate"/></PurchaseOrderDate>
									<PurchaseOrderTime><xsl:value-of select="$PurchaseOrderTime"/></PurchaseOrderTime>
								</PurchaseOrderReferences>
								<OrderedDeliveryDetails>
									<DeliveryType><xsl:text>Ordinary</xsl:text></DeliveryType>
									<DeliveryDate><xsl:value-of select="$DeliveryDate"/></DeliveryDate>
<!--									<xsl:if test="$SpecialDeliveryInstructions">
										<SpecialDeliveryInstructions>
											<xsl:value-of select="$SpecialDeliveryInstructions"/>
										</SpecialDeliveryInstructions>
									</xsl:if>-->
								</OrderedDeliveryDetails>
							</PurchaseOrderHeader>
							<PurchaseOrderDetail>
								<xsl:apply-templates select="L1[count(L2)=9 and number(L2[1]) = number(L2[1])]"/>
							</PurchaseOrderDetail>
							<PurchaseOrderTrailer>
								<NumberOfLines>
									<xsl:value-of select="count(L1[count(L2)=9 and number(L2[1]) = number(L2[1])])"/>
								</NumberOfLines>
								<TotalExclVAT>
									<xsl:value-of select="$TotalExclVAT"/>
								</TotalExclVAT>
							</PurchaseOrderTrailer>
						</PurchaseOrder>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>

	<xsl:template match="L1">
		<xsl:variable name="OrderedQuantity" select="L2[1]"/>
		<xsl:variable name="PackSize" select="L2[2]"/>
		<xsl:variable name="SupplierProductCode" select="L2[3]"/>
		<xsl:variable name="ProductDescription" select="concat(L2[4], ' ', L2[5])"/>
		<xsl:variable name="UnitValueExclVAT" select="substring-after(L2[6], '£')"/>
		<xsl:variable name="LineValueExclVAT" select="substring-after(L2[7], '£')"/>
		<PurchaseOrderLine>
			<ProductID>
				<GTIN>5555555555555</GTIN>
				<SuppliersProductCode><xsl:value-of select="$SupplierProductCode"/></SuppliersProductCode>
			</ProductID>
			<ProductDescription><xsl:value-of select="$ProductDescription"/></ProductDescription>
			<OrderedQuantity><xsl:value-of select="$OrderedQuantity"/></OrderedQuantity>
			<PackSize><xsl:value-of select="$PackSize"/></PackSize>
			<UnitValueExclVAT><xsl:value-of select="$UnitValueExclVAT"/></UnitValueExclVAT>
			<LineValueExclVAT><xsl:value-of select="$LineValueExclVAT"/></LineValueExclVAT>
		</PurchaseOrderLine>
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date, 7, 4), '-', substring($date, 4, 2), '-', substring($date, 1, 2))"/>
	</xsl:template>
</xsl:stylesheet>