<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 	Input:	the intermidate XML produced by tsProcessorLPCSFIDeliveryMapIn
 	Output: 	a delivery note batch 

 © Alternative Business Solutions Ltd, 2005.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date			| Name 			| Description of modification
==========================================================================================
 28/10/2005	| R Cambridge	| H522 Created module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 02/12/2005 | Lee Boyton  | H522. Map Supplier's ANA to SuppliersCode for
                          | consistency with invoices and credit note documents.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 					|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">
	
		<Batch>
			<TradeSimpleHeader>
				<SendersCodeForRecipient><xsl:value-of select="/Documents/Document/SendersCodeForRecipient"/></SendersCodeForRecipient>
			</TradeSimpleHeader>
			<BatchDocuments>
			
			
				<xsl:for-each select="/Documents/Document">
				
					<!-- get distinct supplier ANA numbers in this doc -->	
					
					<xsl:variable name="sDistinctANAs">
					
						<xsl:for-each select="Lines/Line">
						
							<xsl:variable name="sANA" select="string(@SuppliersANANumber)"/>
							
							<xsl:if test="not(preceding-sibling::Line[string(@SuppliersANANumber) = $sANA])">
								<ANA><xsl:value-of select="$sANA"/></ANA>
							</xsl:if>			
						
						</xsl:for-each>
						
					</xsl:variable>
					
					<!-- Bind current doc to this variable as current node goes out of scope in the following for-each -->
					<xsl:variable name="objDoc" select="."/>			
					
					<xsl:for-each select="msxsl:node-set($sDistinctANAs)/ANA">
					
						<xsl:variable name="sCurrentANA" select="string(.)"/>
			
						<BatchDocument DocumentTypeNo="7">
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="$objDoc/SendersCodeForRecipient"/></SendersCodeForRecipient>
									<xsl:if test="string() != ''"><SendersBranchReference><xsl:value-of select="$sCurrentANA"/></SendersBranchReference></xsl:if>
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
									<!--BatchInformation/>
									<DocumentStatus/-->
									<Buyer>
										<BuyersLocationID>
											<GLN><xsl:value-of select="$objDoc/SendersCodeForRecipient"/></GLN>
										</BuyersLocationID>
									</Buyer>
									<Supplier>
										<SuppliersLocationID>
											<GLN><xsl:value-of select="$objDoc/SendersANA"/></GLN>
											<SuppliersCode><xsl:value-of select="$sCurrentANA"/></SuppliersCode>
										</SuppliersLocationID>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<GLN>5555555555555</GLN>
											<SuppliersCode><xsl:value-of select="$objDoc/ShipToCode"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="$objDoc/ShipToName"/></ShipToName>
										<ShipToAddress>
											<xsl:call-template name="mobjShuffleAddressLines">
												<xsl:with-param name="vsAddressLines" select="concat($objDoc/ShipToAddress,':')"/>
												<xsl:with-param name="vnLineNumber" select="1"/>
											</xsl:call-template>
										</ShipToAddress>
									</ShipTo>
									<PurchaseOrderReferences>
										<PurchaseOrderReference>Not provided</PurchaseOrderReference>
										<PurchaseOrderDate><xsl:value-of select="$objDoc/DeliveryNoteDate"/></PurchaseOrderDate>
									</PurchaseOrderReferences>
									<PurchaseOrderConfirmationReferences>
										<PurchaseOrderConfirmationReference>Not provided</PurchaseOrderConfirmationReference>
										<PurchaseOrderConfirmationDate><xsl:value-of select="$objDoc/DeliveryNoteDate"/></PurchaseOrderConfirmationDate>
									</PurchaseOrderConfirmationReferences>
									<DeliveryNoteReferences>
										<DeliveryNoteReference><xsl:value-of select="$objDoc/DeliveryNoteNumber"/></DeliveryNoteReference>
										<DeliveryNoteDate><xsl:value-of select="$objDoc/DeliveryNoteDate"/></DeliveryNoteDate>
										<DespatchDate><xsl:value-of select="$objDoc/DeliveryDate"/></DespatchDate>
									</DeliveryNoteReferences>
									<DeliveredDeliveryDetails>
										<!--DeliveryType/-->
										<DeliveryDate><xsl:value-of select="$objDoc/DeliveryDate"/></DeliveryDate>
									</DeliveredDeliveryDetails>
								</DeliveryNoteHeader>
								
								<DeliveryNoteDetail>
								
									<xsl:for-each select="$objDoc/Lines/Line[string(@SuppliersANANumber) = $sCurrentANA]">
									
										<DeliveryNoteLine>
										
											<ProductID>
												<GTIN>5555555555555</GTIN>
												<SuppliersProductCode><xsl:value-of select="SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
											
											<xsl:variable name="sQuantity">
												<xsl:if test="string(CreditFlag) = 'C'">-</xsl:if>
												<xsl:value-of select="DeliveredQuantity"/>
											</xsl:variable>
											
											<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></OrderedQuantity>
											<ConfirmedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></ConfirmedQuantity>
											<DespatchedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></DespatchedQuantity>
											<UnitValueExclVAT><xsl:value-of select="UnitPrice"/></UnitValueExclVAT>

											<LineExtraData>
												<IsStockProduct>true</IsStockProduct>
												<xsl:if test="$sCurrentANA = ''">
													<UnallocatedLine>true</UnallocatedLine>
												</xsl:if>
											</LineExtraData>
																						
											
										</DeliveryNoteLine>

									</xsl:for-each>
									
								</DeliveryNoteDetail>
								<DeliveryNoteTrailer>
									<NumberOfLines><xsl:value-of select="count($objDoc/Lines/Line[string(@SuppliersANANumber) = $sCurrentANA])"/></NumberOfLines>
								</DeliveryNoteTrailer>
							</DeliveryNote>
						</BatchDocument>
						
					</xsl:for-each>
					
				</xsl:for-each>
					
			</BatchDocuments>
		</Batch>
	
	</xsl:template>
	
	
	<xsl:template name="mobjShuffleAddressLines">
		<xsl:param name="vsAddressLines"/>
		<xsl:param name="vnLineNumber"/>

		<xsl:choose>
		
			<xsl:when test="$vsAddressLines = '' or $vnLineNumber &gt; 4"/>
			
			<xsl:when test="substring-before($vsAddressLines,':') = ''">			
				<xsl:call-template name="mobjShuffleAddressLines">
					<xsl:with-param name="vsAddressLines" select="substring-after($vsAddressLines,':')"/>
					<xsl:with-param name="vnLineNumber" select="$vnLineNumber"/>
				</xsl:call-template>			
			</xsl:when>
			
			<xsl:otherwise>
			
				<xsl:element name="{concat('AddressLine',string($vnLineNumber))}">
					<xsl:value-of select="substring-before($vsAddressLines,':')"/>
				</xsl:element>
			
				<xsl:call-template name="mobjShuffleAddressLines">
					<xsl:with-param name="vsAddressLines" select="substring-after($vsAddressLines,':')"/>
					<xsl:with-param name="vnLineNumber" select="$vnLineNumber + 1"/>
				</xsl:call-template>
			
			</xsl:otherwise>
			
		</xsl:choose>

	</xsl:template>
										

</xsl:stylesheet>
