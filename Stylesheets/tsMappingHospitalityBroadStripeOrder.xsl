<?xml version="1.0" encoding="UTF-8"?>
<!-- 
'******************************************************************************************
' Overview
'		
' Stylesheet to map noschema flatfile mapped MeatPak file to internal tradesimple xml
'
'	NOTE: 
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002,2003.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name            | Description of modification
'******************************************************************************************
' 22/04/2003 | C Scott         | Created
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 01/06/2009 | R Cambridge     | 2916 capture invoice-to info //Buyer/* and //HeaderExtraData
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'            |                 | 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	
	<xsl:template match="Document">
	
		<xsl:variable name="sPODate">
			<!--xsl:value-of select="concat(substring(H/L2[3],1,4),'-',substring(H/L2[3],5,2),'-',substring(H/L2[3],7,2))"/-->
		</xsl:variable>
		<xsl:variable name="sReqDate">
			<xsl:value-of select="concat(substring(H/L2[19],7,4),'-',substring(H/L2[19],4,2),'-',substring(H/L2[19],1,2))"/>
		</xsl:variable>
	
		<BatchRoot>
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>FAIRFAXMEADOW</SendersCodeForRecipient>
					</TradeSimpleHeader>
					<PurchaseOrderHeader>
						
						<!-- 2916 Buyers tag used to store invoice-to fields -->
						<Buyer>
							<BuyersName>
								<xsl:value-of select="H/L2[4]"/>
							</BuyersName>
							<BuyersAddress>
							
								<xsl:for-each select="H/L2[position() &gt;= 5 and position() &lt;= 8][. != '']">
									<xsl:element name="{concat('AddressLine',string(position()))}">
										<xsl:value-of select="."/>
									</xsl:element>								
								</xsl:for-each>							

								<PostCode>
									<xsl:value-of select="H/L2[9]"/>
								</PostCode>
							</BuyersAddress>
						</Buyer>	
						
						<ShipTo>
							<ShipToLocationID>
								<!--GLN/-->
								<BuyersCode>
									<xsl:value-of select="H/L2[3]"/>
								</BuyersCode>
								<SuppliersCode>
									<xsl:value-of select="H/L2[3]"/>
								</SuppliersCode>
							</ShipToLocationID>
							<ShipToName>
								<xsl:value-of select="H/L2[11]"/>
							</ShipToName>
							<ShipToAddress>
								<xsl:variable name="addlines">
									<addline>
										<xsl:choose>
											<xsl:when test="H/L2[12] != ''">
												<xsl:value-of select="H/L2[12]"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</addline>
									<addline>
										<xsl:choose>
											<xsl:when test="H/L2[13] != ''">
												<xsl:value-of select="H/L2[13]"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</addline>
									<addline>
										<xsl:choose>
											<xsl:when test="H/L2[14] != ''">
												<xsl:value-of select="H/L2[14]"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</addline>
									<addline>
										<xsl:choose>
											<xsl:when test="H/L2[15] != ''">
												<xsl:value-of select="H/L2[15]"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</addline>
									<addline>
										<xsl:choose>
											<xsl:when test="H/L2[16] != ''">
												<xsl:value-of select="H/L2[16]"/>
											</xsl:when>
											<xsl:otherwise>.</xsl:otherwise>
										</xsl:choose>
									</addline>
								</xsl:variable>
								<AddressLine1>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[1]"/>
								</AddressLine1>
								<AddressLine2>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[2]"/>
								</AddressLine2>
								<AddressLine3>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[3]"/>
								</AddressLine3>
								<AddressLine4>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[4]"/>
								</AddressLine4>
								<PostCode>
									<xsl:value-of select="msxsl:node-set($addlines)/addline[5]"/>
								</PostCode>
							</ShipToAddress>
							<ContactName>
								<xsl:value-of select="H/L2[11]"/>
							</ContactName>
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="H/L2[2]"/>
							</PurchaseOrderReference>
							<!--PurchaseOrderDate>
								<xsl:value-of select="$sPODate"/>
							</PurchaseOrderDate-->
						</PurchaseOrderReferences>
						<OrderedDeliveryDetails>
							<DeliveryDate>
								<xsl:value-of select="$sReqDate"/>
							</DeliveryDate>
							<xsl:if test="H/L2[18] != ''">
								<SpecialDeliveryInstructions>
									<xsl:value-of select="H/L2[18]"/>
								</SpecialDeliveryInstructions>
							</xsl:if>
						</OrderedDeliveryDetails>
						
						<!-- 2916 store invoice-to telephone number -->
						<xsl:for-each select="H/L2[10][. != ''][1]">
						
							<HeaderExtraData>
								<BuyerContactTelephoneNumber>
									<xsl:value-of select="."/>
								</BuyerContactTelephoneNumber>
							</HeaderExtraData>
							
						</xsl:for-each>
						
					</PurchaseOrderHeader>
					<PurchaseOrderDetail>
						<xsl:for-each select="L">
							<PurchaseOrderLine>
								<!--LineNumber>
									<xsl:value-of select="L2[2]/L3[1]/L4[1]"/>
								</LineNumber-->
								<ProductID>
									<SuppliersProductCode>
										<xsl:value-of select="L2[3]"/>
									</SuppliersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:value-of select="L2[4]"/>
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
									<xsl:value-of select="format-number(L2[7],'0.00')"/>
								</UnitValueExclVAT>
								<LineValueExclVAT>
									<xsl:value-of select="format-number(L2[5] * L2[7],'0.00')"/>
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
