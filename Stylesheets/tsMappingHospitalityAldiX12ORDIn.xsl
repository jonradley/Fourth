<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
ANSI X12 850 V5 - inbound order mapper  
© Fourth Hospitality Ltd, 2015.
==========================================================================================
 Module History
==========================================================================================
 Version			| 
==========================================================================================
 Date				| Name 				|	Description of modification
==========================================================================================
 10/12/2012	| Jose Miguel	|	FB10134 Created
==========================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<!-- Prepare Root element -->
	<xsl:template match="/Document">
		<!-- ISA Segment information -->
		<!-- Test Flag -->
		<xsl:variable name="Test" select="L1[L2[1]='ISA']/L2[16]"/>
		<!-- Populate the GLN of the buyer only if code '07' appears in ths ISA segment for the buyer or in its N1 segment 'BU' -->
		<xsl:variable name="BuyersGLN">
			<xsl:choose>
				<xsl:when test="L1[L2[1]='ISA']/L2[6]='07'"><xsl:value-of select="L1[L2[1]='ISA']/L2[7]"/></xsl:when>
				<xsl:when test="L1[L2[1]='N1' and L2[2]='BY' and L2[5]='UL']"><xsl:value-of select="L1[L2[1]='N1' and L2[2]='BY']/L5"/></xsl:when>
				<xsl:otherwise><xsl:text>5555555555555</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Populate the GLN of the supplier only if code '07' appears in ths ISA segment for the supplier or in its N1 segment 'SU'-->
		<xsl:variable name="SupplierGLN">
			<xsl:choose>
				<xsl:when test="L1[L2[1]='ISA']/L2[8]='07'"><xsl:value-of select="L1[L2[1]='ISA']/L2[9]"/></xsl:when>
				<xsl:when test="L1[L2[1]='N1' and L2[2]='SU' and L2[5]='UL']"><xsl:value-of select="L1[L2[1]='N1' and L2[2]='SU']/L5"/></xsl:when>
				<xsl:otherwise><xsl:text>5555555555555</xsl:text></xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<!-- Get the suppliers code for the buyer (could be the same as the GLN) from N1 -->
		<xsl:variable name="BuyersCode" select="L1[L2[1]='N1' and L2[2]='BY']/L2[5]"/>
		<!-- Get the buyers name -->
		<xsl:variable name="BuyersName" select="L1[L2[1]='N1' and L2[2]='BY']/L2[3]"/>
		
		<!-- Get the suppliers code for the supplier (could be the same as the GLN) from N1 -->
		<xsl:variable name="SuppliersCode" select="L1[L2[1]='N1' and L2[2]='SU']/L2[5]"/>
		<!-- Get the suppliers name -->
		<xsl:variable name="SuppliersName" select="L1[L2[1]='N1' and L2[2]='SU']/L2[3]"/>

		<!-- Get the suppliers code for the delivery address  (the unit's location) from its N1 -->
		<xsl:variable name="ShipToCode" select="L1[L2[1]='N1' and L2[2]='DA']/L2[5]"/>
		<xsl:variable name="ShipToName" select="L1[L2[1]='N1' and L2[2]='DA']/L2[3]"/>
		<xsl:variable name="ShipToAddressStreet" select="L1[L2[1]='N1' and L2[2]='DA']/following-sibling::L1[L2[1]='N3'][1]/L2[2]"/>
		<xsl:variable name="ShipToAddressCity" select="L1[L2[1]='N1' and L2[2]='DA']/following-sibling::L1[L2[1]='N4'][1]/L2[2]"/>
		<xsl:variable name="ShipToPostCode" select="L1[L2[1]='N1' and L2[2]='DA']/following-sibling::L1[L2[1]='N4'][1]/L2[4]"/>
				
		<!-- Get the PORef from the 4th item in the BEG segment -->
		<xsl:variable name="PurchaseOrderReference" select="L1[L2[1]='BEG']/L2[4]"/>

		<!-- Get the PO date from the 7th item in the BEG segment -->
		<xsl:variable name="PurchaseOrderDate" >
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="L1[L2[1]='BEG']/L2[6]"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Get the name of the cotanct in the order department -->
		<xsl:variable name="ContactName" select="L1[L2[1]='PER' and L2[2]='OD']/L2[3]"/>

		<!-- Get the delivery date from the DTM segment with code 002 -->
		<xsl:variable name="DeliveryDate" >
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="L1[L2[1]='DTM' and L2[2]='002']/L2[3]"/>
			</xsl:call-template>		
		</xsl:variable>
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="2">		
						<PurchaseOrder>
							<TradeSimpleHeader>
								<SendersCodeForRecipient><xsl:value-of select="$SuppliersCode"/></SendersCodeForRecipient>
								<SendersName><xsl:value-of select="$SuppliersName"/></SendersName>
								<TestFlag>
									<xsl:choose>
										<xsl:when test="$Test='P'"><xsl:text>0</xsl:text></xsl:when>
										<xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise>
									</xsl:choose>
								</TestFlag>
							</TradeSimpleHeader>
							<PurchaseOrderHeader>
								<Buyer>
									<BuyersLocationID>
										<GLN>
											<xsl:value-of select="$BuyersGLN"/>
										</GLN>
										<BuyersCode><xsl:value-of select="$BuyersCode"/></BuyersCode>
									</BuyersLocationID>
									<BuyersName><xsl:value-of select="$BuyersName"/></BuyersName>
								</Buyer>
								<Supplier>
									<SuppliersLocationID>
										<GLN>
											<xsl:value-of select="$SupplierGLN"/>
										</GLN>
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
									<ShipToAddress>
										<AddressLine1><xsl:value-of select="$ShipToAddressStreet"/></AddressLine1>
										<AddressLine2><xsl:value-of select="$ShipToAddressCity"/></AddressLine2>
										<PostCode><xsl:value-of select="$ShipToPostCode"/></PostCode>
									</ShipToAddress>
									<ContactName><xsl:value-of select="$ContactName"/></ContactName>
								</ShipTo>
								<PurchaseOrderReferences>
									<PurchaseOrderReference><xsl:value-of select="$PurchaseOrderReference"/></PurchaseOrderReference>
									<PurchaseOrderDate><xsl:value-of select="$PurchaseOrderDate"/></PurchaseOrderDate>
								</PurchaseOrderReferences>
								<OrderedDeliveryDetails>
									<DeliveryType><xsl:text>Ordinary</xsl:text></DeliveryType>
									<DeliveryDate><xsl:value-of select="$DeliveryDate"/></DeliveryDate>
								</OrderedDeliveryDetails>
							</PurchaseOrderHeader>
							<PurchaseOrderDetail>
								<xsl:apply-templates select="L1[L2[1]='PO1']"/>
							</PurchaseOrderDetail>
							<PurchaseOrderTrailer>
								<NumberOfLines><xsl:value-of select="count(L1[L2[1]='PO1'])"/></NumberOfLines>
							</PurchaseOrderTrailer>							
						</PurchaseOrder>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>						
	</xsl:template>

	<!-- Process each line of the order -->
	<xsl:template match="L1">	
		<xsl:variable name="LineNumber" select="L2[2]"/>
		<xsl:variable name="OrderedQuantity" select="L2[3]"/>
		<xsl:variable name="UnitOfMeasure">
			<xsl:choose>
				<xsl:when test="L2[4]='PC'"><xsl:text>EA</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>CS</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="PackSize" select="concat(L2[14], '-', following-sibling::L1[L2[1]='MEA'][1]/L2[4], 'x', following-sibling::L1[L2[1]='MEA'][2]/L2[4])"/>
		<xsl:variable name="ProductCode" select="L2[8]"/>
		<xsl:variable name="ProductDescription" select="following-sibling::L1[L2[1]='PID'][1]/L2[6]"/>
		<PurchaseOrderLine>
			<LineNumber><xsl:value-of select="$LineNumber"/></LineNumber>
			<ProductID>
				<GTIN>5555555555555</GTIN>
				<BuyersProductCode><xsl:value-of select="$ProductCode"/></BuyersProductCode>
			</ProductID>
			<ProductDescription><xsl:value-of select="$ProductDescription"/></ProductDescription>
			<OrderedQuantity><xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$UnitOfMeasure"/></xsl:attribute><xsl:value-of select="$OrderedQuantity"/></OrderedQuantity>
			<PackSize><xsl:value-of select="$PackSize"/></PackSize>
		</PurchaseOrderLine>
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2))"/>
	</xsl:template>
</xsl:stylesheet>