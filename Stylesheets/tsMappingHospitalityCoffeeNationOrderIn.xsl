<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2007.
==========================================================================================
 Module History
==========================================================================================
 	Version		| 
==========================================================================================
 	Date      	| Name 				| Description of modification
==========================================================================================
	13/02/2007	| R Cambridge		| 950 Created module
==========================================================================================
	          	|            		| 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
	
		<BatchRoot>
		
			<Batch>
				<BatchDocuments>
		
					<xsl:for-each select="/B/BDs/BD/PO">
		
		
						<BatchDocument>
							<xsl:attribute name="DocumentTypeNo">2</xsl:attribute>
				
							<PurchaseOrder>
								<TradeSimpleHeader>
									<SendersCodeForRecipient><xsl:value-of select="TSH/SCR"/></SendersCodeForRecipient>
									<!--SendersBranchReference><xsl:value-of select="TSH/SBR"/></SendersBranchReference-->
								</TradeSimpleHeader>
								<PurchaseOrderHeader>
									<DocumentStatus>Original</DocumentStatus>
									<!--Buyer>
										<BuyersLocationID>
											<GLN>23234</GLN>
											<SuppliersCode><xsl:value-of select="POHeader/By/BysLocID/SupsCode"/></SuppliersCode>
										</BuyersLocationID>
									</Buyer-->
									<Supplier>
										<SuppliersLocationID>
											<!--GLN>23234</GLN-->
											<BuyersCode><xsl:value-of select="POHeader/Sup/SupsLocID/BysCode"/></BuyersCode>
										</SuppliersLocationID>
									</Supplier>
									<ShipTo>
										<ShipToLocationID>
											<!--GLN>23234</GLN-->
											<BuyersCode><xsl:value-of select="POHeader/ST/STLocID/BysCode"/></BuyersCode>
											<SuppliersCode><xsl:value-of select="concat('34',POHeader/ST/STLocID/BysCode)"/></SuppliersCode>
										</ShipToLocationID>
										<ShipToName><xsl:value-of select="POHeader/ST/STName"/></ShipToName>
										<ShipToAddress>
											<AddressLine1><xsl:value-of select="POHeader/ST/STAdd/AddLine1"/></AddressLine1>
										</ShipToAddress>
										<ContactName><xsl:value-of select="POHeader/ST/ContactName"/></ContactName>
									</ShipTo>
									<PurchaseOrderReferences>
										<PurchaseOrderReference><xsl:value-of select="POHeader/PORefs/PORef"/></PurchaseOrderReference>
										<PurchaseOrderDate><xsl:value-of select="POHeader/PORefs/PODate"/></PurchaseOrderDate>
									</PurchaseOrderReferences>
									<OrderedDeliveryDetails>
										<DeliveryType>Delivery</DeliveryType>
										<DeliveryDate><xsl:value-of select="POHeader/OedDelDet/DelDate"/></DeliveryDate>
									</OrderedDeliveryDetails>
								</PurchaseOrderHeader>
								<PurchaseOrderDetail>
								
									<xsl:for-each select="PODetail/POLine">
								
										<PurchaseOrderLine>
											<ProductID>
												<GTIN>55555555555555</GTIN>
												<SuppliersProductCode><xsl:value-of select="ProdID/SupsProdCode"/></SuppliersProductCode>
											</ProductID>
											<ProductDescription><xsl:value-of select="ProdDesc"/></ProductDescription>
											<OrderedQuantity>
												<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
												<xsl:value-of select="OedQuantity"/>
											</OrderedQuantity>
											<PackSize><xsl:value-of select="PackSize"/></PackSize>
											<UnitValueExclVAT><xsl:value-of select="format-number(Price,'0.00')"/></UnitValueExclVAT>											
											<LineValueExclVAT><xsl:value-of select="format-number(OedQuantity * Price,'0.00')"/></LineValueExclVAT>
										</PurchaseOrderLine>
									
									</xsl:for-each>
									
								</PurchaseOrderDetail>
								<!--PurchaseOrderTrailer>
									<NumberOfLines>?</NumberOfLines>
								</PurchaseOrderTrailer-->
							</PurchaseOrder>
		
						</BatchDocument>
		
					</xsl:for-each>
		
				</BatchDocuments>
			</Batch>	
	
		</BatchRoot>
	
	</xsl:template>
	
	
		

</xsl:stylesheet>
