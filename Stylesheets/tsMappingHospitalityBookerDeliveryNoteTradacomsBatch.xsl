<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************************************************************
Alterations


***************************************************************************************************************************************
Name		| Date			| Change
***************************************************************************************************************************************
R Cambridge	| 29/10/2007	| 1556 Create module
***************************************************************************************************************************************
M Emanuel	| 24/02/2012	| Created Delivery Note Mapper for Booker
***************************************************************************************************************************************
M Dimant	| 23/05/2018 	| FB 12854: Changes to handle Catchweight lines
***************************************************************************************************************************************
M Dimant	| 13/06/2018 	| FB 12952: Correction to fix Catchweight lines logic
***************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>

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
										<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
									</SendersCodeForRecipient>
									<xsl:if test="TradeSimpleHeader/SendersBranchReference">
										<SendersBranchReference>
											<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
										</SendersBranchReference>
									</xsl:if>
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
								
									<Buyer>
										<xsl:apply-templates select="DeliveryNoteHeader/Buyer/*"/>
									</Buyer>
									
									<Supplier>
										<xsl:apply-templates select="DeliveryNoteHeader/Supplier/*"/>
									</Supplier>
									
									<ShipTo>
										<xsl:apply-templates select="DeliveryNoteHeader/ShipTo/*"/>
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
										<PurchaseOrderReference><xsl:value-of select="DeliveryNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderReference>
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
										
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<xsl:for-each select="ProductDescription[1]">
												<ProductDescription><xsl:value-of select="."/></ProductDescription>
											</xsl:for-each>

											<xsl:for-each select="OrderedQuantity[1]">
												<OrderedQuantity RecordPos="DLD=" LPos="6" SFPos="2">
													<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderedQuantity /@UnitOfMeasure"/></xsl:attribute>
													
													<xsl:value-of select="OrderedQuantity"/>
												
												</OrderedQuantity>
											</xsl:for-each>
																						
											<DespatchedQuantity UnitOfMeasure="EA">																						
												<xsl:if test="string(DespatchedQuantity/@UnitOfMeasure) != ''">
													<xsl:attribute name="UnitOfMeasure">
														<xsl:choose>
															<xsl:when test="DespatchedQuantity/@UnitOfMeasure = 'KG'">KGM</xsl:when>
															<xsl:otherwise><xsl:value-of select="DespatchedQuantity/@UnitOfMeasure"/></xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<!-- Quantity for weighted items is temporarily held in ConfirmedQuantity. So if a value is present here, the line must be catchweight -->
													<xsl:when test="ConfirmedQuantity">
														<xsl:value-of select="number(ConfirmedQuantity) div 1000"/>
													</xsl:when>
													<!-- Otherwise it is not catchweight-->
													<xsl:otherwise><xsl:value-of select="DespatchedQuantity"/></xsl:otherwise>
												</xsl:choose>																								
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
	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<!--xsl:with-param name="vobjAddressElements"/-->
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
