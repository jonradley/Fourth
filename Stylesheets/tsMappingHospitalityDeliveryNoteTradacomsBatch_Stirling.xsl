<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations


**********************************************************************
Name			| Date			| Change
**********************************************************************
R Cambridge	| 29/10/2007	| 1556 Create module
**********************************************************************
H Robson		|	2012-02-01		| 5226 change Aramark onto the default way of handling the Product Code
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>
	
	<!-- The structure of the interal XML varries depending on who the customer is -->
	
	<!-- All documents in the batch will be for the same customer/agreement -->	
	<xsl:variable name="ARAMARK" select="'ARAMARK'"/>
	<xsl:variable name="BEACON_PURCHASING" select="'BEACON_PURCHASING'"/>
	<xsl:variable name="COMPASS" select="'COMPASS'"/>
	<xsl:variable name="COOP" select="'COOP'"/>
	<xsl:variable name="FISHWORKS" select="'FISHWORKS'"/>
	<xsl:variable name="MCC" select="'MCC'"/>
	<xsl:variable name="ORCHID" select="'ORCHID'"/>
	<xsl:variable name="SEARCYS" select="'SEARCYS'"/>
	<xsl:variable name="SODEXO_PRESTIGE" select="'SODEXO_PRESTIGE'"/>
	<xsl:variable name="TESCO" select="'TESCO'"/>
	
	<xsl:variable name="CustomerFlag">
		<xsl:variable name="accountCode" select="string(//DeliveryNote/TradeSimpleHeader/SendersBranchReference)"/>
		<xsl:choose>
			<xsl:when test="$accountCode = '203909'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARA02T'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'ARANET'"><xsl:value-of select="$ARAMARK"/></xsl:when>
			<xsl:when test="$accountCode = 'BEACON'"><xsl:value-of select="$BEACON_PURCHASING"/></xsl:when>
			<xsl:when test="$accountCode = 'MIL14T'"><xsl:value-of select="$COMPASS"/></xsl:when>
			<xsl:when test="$accountCode = 'KIN04D'"><xsl:value-of select="$COOP"/></xsl:when>
			<xsl:when test="$accountCode = 'KIN04T'"><xsl:value-of select="$COOP"/></xsl:when>
			<xsl:when test="$accountCode = 'fishworks'"><xsl:value-of select="$FISHWORKS"/></xsl:when>
			<xsl:when test="$accountCode = 'MAR100T'"><xsl:value-of select="$MCC"/></xsl:when>
			<xsl:when test="$accountCode = 'BLA16T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'OPL01T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'ORCHID'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'PBR16T'"><xsl:value-of select="$ORCHID"/></xsl:when>
			<xsl:when test="$accountCode = 'SEA01T'"><xsl:value-of select="$SEARCYS"/></xsl:when>
			<xsl:when test="$accountCode = 'GAR06T'"><xsl:value-of select="$SODEXO_PRESTIGE"/></xsl:when>
			<xsl:when test="$accountCode = 'SOD99T'"><xsl:value-of select="$SODEXO_PRESTIGE"/></xsl:when>			
						
			<xsl:when test="$accountCode = 'TES01T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES08T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES12T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES15T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:when test="$accountCode = 'TES25T'"><xsl:value-of select="$TESCO"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>	
			<Batch>				
				<BatchDocuments>				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/DeliveryNote">
				
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient>
										<xsl:choose>
											<!--xsl:when test="SendersBranchReference = 'MIL14T'">MIL14T</xsl:when>
											<xsl:when test="SendersBranchReference = 'FMC01T'">FMC01T</xsl:when>
											<xsl:when test="SendersBranchReference = 'TES01T'">TES01T</xsl:when>					
											<xsl:when test="SendersBranchReference = 'TES08T'">TES08T</xsl:when>					
											<xsl:when test="SendersBranchReference = 'TES12T'">TES12T</xsl:when>					
											<xsl:when test="SendersBranchReference = 'TES15T'">TES15T</xsl:when>					
											<xsl:when test="SendersBranchReference = 'TES25T'">TES25T</xsl:when-->	
					
										<xsl:when test="$CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $BEACON_PURCHASING ">
										<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
										</xsl:when>			
									
										<xsl:otherwise>
											<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
										</xsl:otherwise>
					
										</xsl:choose>
								</SendersCodeForRecipient>
			
										<!--xsl:if test="SendersBranchReference = 'MIL14T' or SendersBranchReference = 'FMC01T' or SendersBranchReference = 'TES01T'"-->
										<!--xsl:if test="SendersBranchReference">
										<xsl:if test="contains('MIL14T~FMC01T~TES01T~TES08T~TES12T~TES15T~TES25T',SendersBranchReference)"-->
										<xsl:if test="$CustomerFlag = $COMPASS or $CustomerFlag = $TESCO or $CustomerFlag = $ARAMARK">
								<SendersBranchReference>
									<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
								</SendersBranchReference>
										</xsl:if>
										<!--/xsl:if>
										</xsl:if-->
							</TradeSimpleHeader>	
								<!--TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
									<xsl:for-each select="TradeSimpleHeader/SendersBranchReference[1]">
										<SendersBranchReference><xsl:value-of select="."/></SendersBranchReference>
									</xsl:for-each>
								</TradeSimpleHeader-->
								<DeliveryNoteHeader>
								
									<Buyer>
										<BuyersLocationID>
											<!--GLN><xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/></GLN-->
											<xsl:for-each select="DeliveryNoteHeader/Buyer/BuyersLocationID/SuppliersCode[1]">
												<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
											</xsl:for-each>											
										</BuyersLocationID>
									</Buyer>
									
									<!--Supplier>
										<SuppliersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></SuppliersCode>
										</SuppliersLocationID>
									</Supplier-->
									
									<ShipTo>
										<ShipToLocationID>
											<GLN>5555555555555</GLN>
											<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode[1]">
												<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
											</xsl:for-each>
										</ShipToLocationID>
										<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToName[1]">
											<ShipToName><xsl:value-of select="."/></ShipToName>
										</xsl:for-each>

			                    <xsl:if test="count(ShipTo/ShipToAddress/*) != 0">
			                    	<ShipToAddress>
												<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToAddress/*[. != '' and name() != 'PostCode']">
													<xsl:element name="{concat('AddressLine',string(position()))}">
														<xsl:value-of select="."/>
													</xsl:element>										
												</xsl:for-each>		
												<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToAddress/PostCode[1]">
													<PostCode><xsl:value-of select="."/></PostCode>
												</xsl:for-each>							
											</ShipToAddress>
			                    </xsl:if>
									</ShipTo>
									
									<xsl:variable name="sDocumentDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
										</xsl:call-template>
									</xsl:variable>

									<xsl:variable name="sPurchaseOrderDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
										</xsl:call-template>
									</xsl:variable>									
										
									<xsl:variable name="sDeliveryDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
										</xsl:call-template>
									</xsl:variable>
									
																		
									<PurchaseOrderReferences>
									
										<PurchaseOrderReference>
											<xsl:choose>
												<xsl:when test="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference">
													<xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat(DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'_',$sPurchaseOrderDate)"/>
												</xsl:otherwise>
											</xsl:choose>										
										</PurchaseOrderReference>
										
										<PurchaseOrderDate><xsl:value-of select="$sPurchaseOrderDate"/></PurchaseOrderDate>
										
									</PurchaseOrderReferences>										

									
									<DeliveryNoteReferences>
										<DeliveryNoteReference><xsl:value-of select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
										<DeliveryNoteDate><xsl:value-of select="$sDocumentDate"/></DeliveryNoteDate>
										<DespatchDate><xsl:value-of select="$sDeliveryDate"/></DespatchDate>
									</DeliveryNoteReferences>
									
									<DeliveredDeliveryDetails>
										<!--DeliveryType/-->
										<DeliveryDate><xsl:value-of select="$sDeliveryDate"/></DeliveryDate>
									</DeliveredDeliveryDetails>
									
								</DeliveryNoteHeader>
								
								<DeliveryNoteDetail>
								
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">								
									
										<DeliveryNoteLine>
										
											<ProductID>4
												<SuppliersProductCode>
													<xsl:value-of select="ProductID/SuppliersProductCode"/>
													<!-- 2012-02-01 - removed ARAMARK from this list, UoM SHOULD be added to product codes for them -->
													<xsl:if test="not(
														$CustomerFlag = $COMPASS or
														$CustomerFlag = $COOP  or
														$CustomerFlag = $FISHWORKS or
														$CustomerFlag = $MCC  or
														$CustomerFlag = $ORCHID or
														$CustomerFlag = $SEARCYS or
														$CustomerFlag = $SODEXO_PRESTIGE)" >
														<xsl:choose>
															<xsl:when test="ConfirmedQuantity/@UnitOfMeasure = 'EA'">-EA</xsl:when>
															<xsl:when test="ConfirmedQuantity/@UnitOfMeasure = 'CS'">-CS</xsl:when>
														</xsl:choose>												
													</xsl:if>	
												</SuppliersProductCode>
											</ProductID>
											
											<xsl:for-each select="ProductDescription[1]">
												<ProductDescription><xsl:value-of select="."/></ProductDescription>
											</xsl:for-each>

											<xsl:for-each select="OrderedQuantity[1]">
												<OrderedQuantity>
													<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="@UnitOfMeasure"/></xsl:attribute>
													
													<xsl:value-of select="."/>
												
												</OrderedQuantity>
											</xsl:for-each>
																						
											<DespatchedQuantity UnitOfMeasure="EA">		
																				
												<xsl:if test="string(DespatchedQuantity/@UnitOfMeasure) != ''">
													<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></xsl:attribute>
												</xsl:if>												
												
												<xsl:value-of select="DespatchedQuantity"/>
												
											</DespatchedQuantity>
											
											<xsl:for-each select="PackSize[1]">
												<PackSize><xsl:value-of select="."/></PackSize>
											</xsl:for-each>
														
										</DeliveryNoteLine>
			
									</xsl:for-each>
									
								</DeliveryNoteDetail>
								
							</DeliveryNote>
							
						</BatchDocument>
						
					</xsl:for-each>
						
				</BatchDocuments>
			</Batch>
			
		</BatchRoot>
	
	</xsl:template>
	
	
	<xsl:template name="msFormatDate">
		<xsl:param name="vsYYMMDD"/>
		
		<xsl:value-of select="concat('20',substring($vsYYMMDD,1,2),'-',substring($vsYYMMDD,3,2),'-',substring($vsYYMMDD,5,2))"/>
		
	</xsl:template>
										

</xsl:stylesheet>
