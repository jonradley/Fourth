<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for orders from Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 23/08/2007	| R Cambridge			| FB1400 Created module (based on tsMappingHospitalityTCGOrderIn.xsl)
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template 	match="/Order">
	
		<BatchRoot>
	
			<PurchaseOrder>
				
				<TradeSimpleHeader>
				
					<SendersCodeForRecipient><xsl:value-of select="@SupplierCode"/></SendersCodeForRecipient>
					
					<SendersBranchReference>						
						<xsl:choose>
							<xsl:when test="substring-before(substring-after(@LocationCode,'RG'),'/') != ''">
								<xsl:value-of select="substring-before(substring-after(@LocationCode,'RG'),'/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@LocationCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<PurchaseOrderHeader>
					
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference><xsl:value-of select="@OrderID"/></PurchaseOrderReference>
						<xsl:variable name="sDateTimeSeperator" select="substring(@OrderDateTime,11,1)"/>
						<PurchaseOrderDate><xsl:value-of select="substring-before(@OrderDateTime,$sDateTimeSeperator)"/></PurchaseOrderDate>
						<PurchaseOrderTime><xsl:value-of select="substring-after(@OrderDateTime,$sDateTimeSeperator)"/></PurchaseOrderTime>
	
					</PurchaseOrderReferences>
					
					<OrderedDeliveryDetails>
	
						<DeliveryDate><xsl:value-of select="/@TargetDeliveryDate"/></DeliveryDate>
	
						<xsl:for-each select="@Notes[.!='']">	
							<SpecialDeliveryInstructions><xsl:value-of select="translate(.,'&#xD;&#xA;',' ')"/></SpecialDeliveryInstructions>	
						</xsl:for-each>
						
					</OrderedDeliveryDetails>
	
				</PurchaseOrderHeader>
				
				
				<PurchaseOrderDetail>
				
					<xsl:for-each select="/Order/OrderItem">
				
						<PurchaseOrderLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="@SupplierProductCode"/></SuppliersProductCode>
							</ProductID>
							
							<!--ProductDescription><xsl:value-of select="@SupplierPackageDescription"/></ProductDescription-->
													
							<OrderedQuantity>
								<xsl:choose>
									<xsl:when test="@MaxSplits = '1'">
										<xsl:attribute name="UnitOfMeasure">CS</xsl:attribute>									
										<xsl:value-of select="@Quantity"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="UnitOfMeasure">EA</xsl:attribute>									
										<xsl:value-of select="format-number(number(@Quantity) * number(@MaxSplits),'0.0000')"/>
									</xsl:otherwise>
								</xsl:choose>
							</OrderedQuantity>
													
							<PackSize>Pack</PackSize>
													
							<UnitValueExclVAT>
								<xsl:choose>
									<xsl:when test="@MaxSplits = '1'">
										
									</xsl:when>
									<xsl:otherwise>							
										<xsl:value-of select="format-number(number(@MajorUnitPrice) / number(@MaxSplits),'0.00')"/>
									</xsl:otherwise>
								</xsl:choose>
							</UnitValueExclVAT>
							
							
						</PurchaseOrderLine>
						
					</xsl:for-each>
						
				</PurchaseOrderDetail>
				
				
			</PurchaseOrder>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
