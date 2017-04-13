<?xml version="1.0" encoding="UTF-8"?>
<!-- 
'******************************************************************************************
' Overview
'		
' Stylesheet to map noschema flatfile mapped MeatPak file to internal tradesimple xml
'
'	NOTE: THIS MAPPING IS SPECIFIC TO THE STRAND PALACE HOTEL ORDERS TO FAIRFAX MEADOW!
'        DO NOT USE THIS MAPPING FOR *ANY* OTHER APPLICATION
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002,2003.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name            | Description of modification
'******************************************************************************************
' 22/04/2003 | C Scott         | Created
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'            |                 | 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	
	<xsl:template match="Document">
	
		<xsl:variable name="sPODate">
			<xsl:value-of select="concat(substring(H/L2[3],1,4),'-',substring(H/L2[3],5,2),'-',substring(H/L2[3],7,2))"/>
		</xsl:variable>
		<xsl:variable name="sReqDate">
			<xsl:value-of select="concat(substring(H/L2[4],1,4),'-',substring(H/L2[4],5,2),'-',substring(H/L2[4],7,2))"/>
		</xsl:variable>
	
		<BatchRoot>
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>FAIRFAX</SendersCodeForRecipient>
					</TradeSimpleHeader>
					<PurchaseOrderHeader>
						<ShipTo>
							<ShipToLocationID>
								<!--GLN/-->
								<BuyersCode>
									<xsl:value-of select="H/L2[9]"/>
								</BuyersCode>
								<SuppliersCode>
									<xsl:value-of select="H/L2[9]"/>
								</SuppliersCode>
							</ShipToLocationID>
							<!--ShipToAddress>
								<xsl:variable name="addlines">
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[1]/L4[2]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[1]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[2]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[3]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[5]"/>
									</addline>
								</xsl:variable>
								
								<AddressLine1>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][1]"/>
								</AddressLine1>
								<AddressLine2>.</AddressLine2>
								<AddressLine3>Manchester</AddressLine3>
								<AddressLine4>.</AddressLine4>
								<PostCode>M60 4ES</PostCode>
							</ShipToAddress-->
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="H/L2[2]"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="$sPODate"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<OrderedDeliveryDetails>
							<DeliveryDate>
								<xsl:value-of select="$sReqDate"/>
							</DeliveryDate>
						</OrderedDeliveryDetails>
					</PurchaseOrderHeader>
					<PurchaseOrderDetail>
						<xsl:for-each select="L">
							<PurchaseOrderLine>
								<!--LineNumber>
									<xsl:value-of select="L2[2]/L3[1]/L4[1]"/>
								</LineNumber-->
								<ProductID>
									<SuppliersProductCode>
										<xsl:value-of select="L2[2]"/>
									</SuppliersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="L2[3]"/>
								</ProductDescription>
								<OrderedQuantity>
									<!--xsl:attribute name="UnitOfMeasure">
										<xsl:choose>
											<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">EA</xsl:when>
											<xsl:otherwise>CS</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute-->
									<xsl:value-of select="L2[5]"/>
								</OrderedQuantity>
								<!--PackSize>
									<xsl:choose>
										<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">Each</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('Case',L2[2]/L3[5]/L4[1])"/>
										</xsl:otherwise>
									</xsl:choose>
								</PackSize-->
								<UnitValueExclVAT>
									<xsl:value-of select="format-number(L2[4],'0.00')"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="format-number(L2[4] * L2[5],'0.00')"/>
								</LineValueExclVAT>
							</PurchaseOrderLine>
						</xsl:for-each>
					</PurchaseOrderDetail>
					<!--PurchaseOrderTrailer>
						<NumberOfLines>
							<xsl:value-of select="count(OLD)"/>
						</NumberOfLines>
						<TotalExclVAT>0.00</TotalExclVAT>
					</PurchaseOrderTrailer-->
				</PurchaseOrder>
		</BatchRoot>

	
	</xsl:template>

</xsl:stylesheet>
