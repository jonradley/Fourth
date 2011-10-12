<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

	Tradacoms order mapping for M&B via Brakes

******************************************************************************************
 Module History
******************************************************************************************
 Date         | Name       		| Description of modification
******************************************************************************************
     ?       	|       ?       	| Created
******************************************************************************************
 12/09/2011   	| R Cambridge   	| 4828 read customer PO ref from DIN/DINN/1 
 													 explicitly get delivery date (was set by infiller as today's date)
 														(Also convert blank ship-to name  & address line 1
 														 and product descripiton to 'Not Provided')
******************************************************************************************
	          	|              	|	                                                        
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">

	<xsl:template match="Document">

	<xsl:variable name="sPODate" select="concat('20', substring(ORD/L2[2]/L3/L4[3], 1, 2), '-', substring(ORD/L2[2]/L3/L4[3], 3, 2), '-', substring(ORD/L2[2]/L3/L4[3], 5, 2))"/>
	<xsl:variable name="sReqDate" select="concat('20', substring(DIN/L2[2]/L3[1]/L4[1], 1, 2), '-', substring(DIN/L2[2]/L3[1]/L4[1], 3, 2), '-',  substring(DIN/L2[2]/L3[1]/L4[1], 5, 2))"/>


		<BatchRoot>
				<PurchaseOrder>
					<TradeSimpleHeader>
						<SendersCodeForRecipient>
							<xsl:value-of select="SDT/L2/L3[1]/L4[2]"/>
						</SendersCodeForRecipient>
					</TradeSimpleHeader>
					<PurchaseOrderHeader>
						<ShipTo>
							<ShipToLocationID>
								<!--GLN/-->
								<BuyersCode>
									<xsl:value-of select="CLO/L2[2]/L3[1]/L4[2]"/>
								</BuyersCode>
								<SuppliersCode>
									<xsl:value-of select="CLO/L2[2]/L3[1]/L4[2]"/>
								</SuppliersCode>
							</ShipToLocationID>
							<ShipToName>
								<xsl:choose>
									<xsl:when test="string(CLO/L2[2]/L3[2]/L4[1]) != ''">
										<xsl:value-of select="CLO/L2[2]/L3[2]/L4[1]"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Not Provided</xsl:text>
									</xsl:otherwise>
								</xsl:choose>								
							</ShipToName>
							<ShipToAddress>
								<xsl:variable name="addlines">
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
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[4]"/>
									</addline>
									<addline>
										<xsl:value-of select="CLO/L2[2]/L3[3]/L4[5]"/>
									</addline>
								</xsl:variable>
								
								<AddressLine1>
									<xsl:choose>
										<xsl:when test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 0">
											<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Not Provided</xsl:text>
										</xsl:otherwise>
									</xsl:choose>																		
								</AddressLine1>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 1">
									<AddressLine2>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][2]"/>
									</AddressLine2>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 2">
									<AddressLine3>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][3]"/>
									</AddressLine3>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 3">
									<AddressLine4>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][4]"/>
									</AddressLine4>
								</xsl:if>
								<xsl:if test="count(msxsl:node-set($addlines)/addline[. != '']) &gt; 4">
									<PostCode>
										<xsl:value-of select="msxsl:node-set($addlines)/addline[. != ''][5]"/>
									</PostCode>
								</xsl:if>
							</ShipToAddress>
						</ShipTo>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<!--xsl:value-of select="ORD/L2[2]/L3/L4[2]"/-->
								<xsl:value-of select="ORD/L2[2]/L3/L4[1]"/>
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
						<SequenceNumber>
							<xsl:value-of select="FIL/L2[2]/L3[1]/L4[1]"/>
						</SequenceNumber>
						<HeaderExtraData>
							<DistDepotCode>
								<xsl:value-of select="DIN/L2[2]/L3[4]/L4[1]"/>
							</DistDepotCode>
							<RouteNumber>
								<xsl:value-of select="DIN/L2[2]/L3[4]/L4[2]"/>
							</RouteNumber>
							<DropNumber>
								<xsl:value-of select="DIN/L2[2]/L3[4]/L4[3]"/>
							</DropNumber>
							<CustomerOrderNumber>
								<xsl:value-of select="DIN/L2[2]/L3[5]/L4[1]"/>
							</CustomerOrderNumber>
						</HeaderExtraData>
					</PurchaseOrderHeader>
					<PurchaseOrderDetail>
						<xsl:for-each select="OLD">
							<xsl:variable name="sSeqNo">
								<xsl:value-of select="L2[2]/L3[1]/L4[1]"/>
							</xsl:variable>
							<PurchaseOrderLine>
								<LineNumber>
									<xsl:value-of select="L2[2]/L3[1]/L4[1]"/>
								</LineNumber>
								<ProductID>
									<SuppliersProductCode>
										<xsl:choose>
											<xsl:when test="L2[2]/L3[2]/L4[2] != ''">
												<xsl:value-of select="L2[2]/L3[2]/L4[2]"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="L2[2]/L3[4]/L4[2]"/>
											</xsl:otherwise>
										</xsl:choose>
									</SuppliersProductCode>
									<BuyersProductCode>
										<xsl:value-of select="L2[2]/L3[4]/L4[2]"/>
									</BuyersProductCode>
								</ProductID>
								<ProductDescription>
									<xsl:choose>
										<xsl:when test="string(L2[2]/L3[10]/L4[1]) != ''">
											<xsl:value-of select="L2[2]/L3[10]/L4[1]"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Not Provided</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</ProductDescription>
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure">
										<xsl:choose>
											<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">EA</xsl:when>
											<xsl:otherwise>CS</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="L2[2]/L3[6]/L4[1]"/>
								</OrderedQuantity>
								<PackSize>
									<xsl:choose>
										<xsl:when test="L2[2]/L3[5]/L4[1] = '1'">Each</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('Case',L2[2]/L3[5]/L4[1])"/>
										</xsl:otherwise>
									</xsl:choose>
								</PackSize>
								<UnitValueExclVAT>0.00</UnitValueExclVAT>
								<LineValueExclVAT>0.00</LineValueExclVAT>
								<LineExtraData>
									<UNOR5120>
										<xsl:value-of select="L2[2]/L3[5]/L4[1]"/>
									</UNOR5120>
									<UNOR5121>
										<xsl:value-of select="L2[2]/L3[5]/L4[2]"/>
									</UNOR5121>
									<UNOR5122>
										<xsl:value-of select="L2[2]/L3[5]/L4[3]"/>
									</UNOR5122>
									<OUCT6011>
										<xsl:value-of select="L2[2]/L3[7]/L4[2]"/>
									</OUCT6011>
									<CustomerLineNumber>
										<xsl:value-of select="following-sibling::*[name() = 'DNB'][1]/L2[2]/L3[5]/L4[1]"/>
									</CustomerLineNumber>
								</LineExtraData>
							</PurchaseOrderLine>
						</xsl:for-each>
					</PurchaseOrderDetail>
					<PurchaseOrderTrailer>
						<NumberOfLines>
							<xsl:value-of select="count(OLD)"/>
						</NumberOfLines>
						<TotalExclVAT>0.00</TotalExclVAT>
					</PurchaseOrderTrailer>
				</PurchaseOrder>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
