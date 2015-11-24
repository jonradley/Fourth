<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for orders from Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 				| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge		| FB1400 Created module (based on tsMappingHospitalityTCGOrderIn.xsl)
==========================================================================================
 22/09/2008	| R Cambridge     	| 2474 populate //ShipToLocationID/BuyersCode with sender's branch reference
==========================================================================================
 21/10/2008	| R Cambridge     	| 2524 temporary fix to ignore split pack info for some suppliers
==========================================================================================
 13/05/2009	| Rave Tech 		| 2878 Removed MaxSplits logic to implement CaseSize logic in processor.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/Order">
				
		<xsl:variable name="sDateTimeSeperator" select="substring(@OrderDateTime,11,1)"/>
				
		<xsl:variable name="sTRGUnitCode">
			<xsl:choose>
				<xsl:when test="substring-before(substring-after(@LocationCode,'RG'),'/') != ''">
					<xsl:value-of select="substring-before(substring-after(@LocationCode,'RG'),'/')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@LocationCode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<BatchRoot>
		
			<PurchaseOrder>
			
				<TradeSimpleHeader>
					<SendersCodeForRecipient>
						<xsl:value-of select="@SupplierCode"/>
					</SendersCodeForRecipient>
					<SendersBranchReference>
						<xsl:value-of select="$sTRGUnitCode"/>
					</SendersBranchReference>
				</TradeSimpleHeader>
				
				<PurchaseOrderHeader>
				
					<ShipTo>
						<ShipToLocationID>
							<BuyersCode>
								<xsl:value-of select="$sTRGUnitCode"/>
							</BuyersCode>
						</ShipToLocationID>
					</ShipTo>				
				
					<PurchaseOrderReferences>
						<PurchaseOrderReference>
							<xsl:value-of select="@OrderID"/>
						</PurchaseOrderReference>
						<PurchaseOrderDate>
							<xsl:value-of select="substring-before(@OrderDateTime,$sDateTimeSeperator)"/>
						</PurchaseOrderDate>
						<PurchaseOrderTime>
							<xsl:value-of select="substring-after(@OrderDateTime,$sDateTimeSeperator)"/>
						</PurchaseOrderTime>
					</PurchaseOrderReferences>
					
					<OrderedDeliveryDetails>
						<DeliveryDate>
							<xsl:value-of select="substring-before(@TargetDeliveryDate,$sDateTimeSeperator)"/>
						</DeliveryDate>
						<xsl:for-each select="@Notes[.!='']">
							<SpecialDeliveryInstructions>
								<xsl:value-of select="translate(.,'&#xD;&#xA;',' ')"/>
							</SpecialDeliveryInstructions>
						</xsl:for-each>
					</OrderedDeliveryDetails>
					
				</PurchaseOrderHeader>
				
				<PurchaseOrderDetail>
					
					<xsl:for-each select="/Order/OrderItem">
						
						<PurchaseOrderLine>
							<ProductID>
								<SuppliersProductCode>
									<xsl:value-of select="@SupplierProductCode"/>
								</SuppliersProductCode>
							</ProductID>
							<!--ProductDescription><xsl:value-of select="@SupplierPackageDescription"/></ProductDescription-->
							<OrderedQuantity>
								<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>
								<xsl:value-of select="@Quantity"/>
							</OrderedQuantity>
							<PackSize>Pack</PackSize>
							<UnitValueExclVAT>
								<xsl:value-of select="@MajorUnitPrice"/>
							</UnitValueExclVAT>
						</PurchaseOrderLine>
						
					</xsl:for-each>
					
				</PurchaseOrderDetail>
				
			</PurchaseOrder>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
