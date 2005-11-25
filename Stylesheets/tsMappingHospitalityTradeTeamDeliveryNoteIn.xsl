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
 25/11/2005	| R Cambridge	| H522 Changed input can be output of FF2XML
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				| 					|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">

		<BatchRoot>
	
			<Batch>
				<TradeSimpleHeader>
					<SendersCodeForRecipient><xsl:value-of select="/Batch/BatchDocuments/BatchDocument/DeliveryNote/SendersCodeForRecipient"/></SendersCodeForRecipient>
				</TradeSimpleHeader>
				<BatchDocuments>
				
				
					<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/DeliveryNote">
				
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
							<DeliveryNote>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
									<!--xsl:if test="string() != ''"><SendersBranchReference><xsl:value-of select="$sCurrentANA"/></SendersBranchReference></xsl:if-->
								</TradeSimpleHeader>
								<DeliveryNoteHeader>
								
									<Buyer>
										<BuyersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Buyer/BuyersLocationID/GLN"/></GLN>
										</BuyersLocationID>
									</Buyer>
									
									<Supplier>
										<SuppliersLocationID>
											<GLN><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/Supplier/SuppliersLocationID/GLN"/></SuppliersCode>
										</SuppliersLocationID>
									</Supplier>
									
									<ShipTo>
										<ShipToLocationID>
											<GLN>5555555555555</GLN>
											<SuppliersCode><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="DeliveryNoteHeader/ShipTo/ShipToName"/></ShipToName>
										<ShipToAddress>
											<xsl:for-each select="DeliveryNoteHeader/ShipTo/ShipToAddress/*[string != '']">
												<xsl:element name="{concat('AddressLine',string(position()))}">
													<xsl:value-of select="."/>
												</xsl:element>										
											</xsl:for-each>									
											<!--xsl:call-template name="mobjShuffleAddressLines">
												<xsl:with-param name="vsAddressLines" select="concat($objDoc/ShipToAddress,':')"/>
												<xsl:with-param name="vnLineNumber" select="1"/>
											</xsl:call-template-->
										</ShipToAddress>
									</ShipTo>
									
									<xsl:variable name="sDocumentDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="sDeliveryDate">
										<xsl:call-template name="msFormatDate">
											<xsl:with-param name="vsYYMMDD" select="DeliveryNoteHeader/DeliveredDeliveryDetails/DeliveryDate"/>
										</xsl:call-template>
									</xsl:variable>
									
									<PurchaseOrderReferences>
										<PurchaseOrderReference>Not provided</PurchaseOrderReference>
										<PurchaseOrderDate><xsl:value-of select="$sDocumentDate"/></PurchaseOrderDate>
									</PurchaseOrderReferences>
									
									<PurchaseOrderConfirmationReferences>
										<PurchaseOrderConfirmationReference>Not provided</PurchaseOrderConfirmationReference>
										<PurchaseOrderConfirmationDate><xsl:value-of select="$sDocumentDate"/></PurchaseOrderConfirmationDate>
									</PurchaseOrderConfirmationReferences>
									
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
								
									<!--xsl:for-each select="$objDoc/Lines/Line[string(@SuppliersANANumber) = $sCurrentANA]"-->
									<xsl:for-each select="DeliveryNoteDetail/DeliveryNoteLine">								
									
										<DeliveryNoteLine>
										
											<ProductID>
												<GTIN>5555555555555</GTIN>
												<SuppliersProductCode><xsl:value-of select="ProductID/SuppliersProductCode"/></SuppliersProductCode>
											</ProductID>
											
											<ProductDescription><xsl:value-of select="ProductDescription"/></ProductDescription>
											
											<xsl:variable name="sQuantity">
												<xsl:if test="string(OrderedQuantity) = 'C'">-</xsl:if>
												<xsl:value-of select="DespatchedQuantity"/>
											</xsl:variable>
											
											<OrderedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></OrderedQuantity>
											<ConfirmedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></ConfirmedQuantity>
											<DespatchedQuantity UnitOfMeasure="EA"><xsl:value-of select="$sQuantity"/></DespatchedQuantity>
											<UnitValueExclVAT><xsl:value-of select="UnitPrice"/></UnitValueExclVAT>
			
											<LineExtraData>
												<IsStockProduct>true</IsStockProduct>
												<UnallocatedLine>true</UnallocatedLine>
											</LineExtraData>																					
											
										</DeliveryNoteLine>
			
									</xsl:for-each>
									
								</DeliveryNoteDetail>
								<DeliveryNoteTrailer>
									<NumberOfLines><xsl:value-of select="count(DeliveryNoteDetail/DeliveryNoteLine)"/></NumberOfLines>
								</DeliveryNoteTrailer>
							</DeliveryNote>
						</BatchDocument>
							
						<!--/xsl:for-each-->
						
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
