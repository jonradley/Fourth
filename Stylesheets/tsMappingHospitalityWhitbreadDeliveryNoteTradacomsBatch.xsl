<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations


**********************************************************************
Name			| Date			| Change
**********************************************************************
M Dimant      | 22/10/2010	|  Created
**********************************************************************
				|					|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">

		<BatchRoot>
	
			<Batch>
				
				<BatchDocuments>
				
				
					<xsl:for-each select="/BatchDocument/DeliveryNote">
				
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
									<xsl:for-each select="TradeSimpleHeader/SendersBranchReference[1]">
										<SendersBranchReference><xsl:value-of select="."/></SendersBranchReference>
									</xsl:for-each>
								</TradeSimpleHeader>
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
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
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
