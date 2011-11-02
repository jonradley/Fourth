<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TCG mapper for orders from Alphameric 

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 16/10/2006	| R Cambridge			| Created module
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template 	match="/OrderHeader">
	
		<BatchRoot>
	
			<PurchaseOrder>
				
				<TradeSimpleHeader>
					<!--Hardcode to cope with TCG dual codes for S and N issue - no orders for non S and N suppliers will use this mapper-->
					<SendersCodeForRecipient><xsl:text>SCO011</xsl:text></SendersCodeForRecipient>
					<SendersBranchReference><xsl:value-of select="@LocationCode"/></SendersBranchReference>
	
				</TradeSimpleHeader>
				
				
				<PurchaseOrderHeader>
					
					<PurchaseOrderReferences>
					
						<PurchaseOrderReference><xsl:value-of select="@LocationCode"/>-<xsl:value-of select="@UserReference"/></PurchaseOrderReference>
						<PurchaseOrderDate><xsl:value-of select="@DateEntered"/></PurchaseOrderDate>
	
					</PurchaseOrderReferences>
					
					<OrderedDeliveryDetails>
	
						<DeliveryDate><xsl:value-of select="@DeliveryDate"/></DeliveryDate>
	
						<xsl:for-each select="@Notes[.!='']">	
							<SpecialDeliveryInstructions><xsl:value-of select="translate(.,'&#xD;&#xA;',' ')"/></SpecialDeliveryInstructions>	
						</xsl:for-each>
						
					</OrderedDeliveryDetails>
	
				</PurchaseOrderHeader>
				
				
				<PurchaseOrderDetail>
				
					<xsl:for-each select="/OrderHeader/OrderItem">
				
						<PurchaseOrderLine>
							
							<ProductID>
								<SuppliersProductCode><xsl:value-of select="@SupplierProductCode"/></SuppliersProductCode>
							</ProductID>
							
							<ProductDescription><xsl:value-of select="@SupplierPackageDescription"/></ProductDescription>
													
							<OrderedQuantity>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:choose>
										<xsl:when test="@ProductType='[S]'">EA</xsl:when>
										<xsl:when test="@ProductType='[P]'">CS</xsl:when>
									</xsl:choose>
								</xsl:attribute>
									
								<xsl:value-of select="@ItemQuantity"/>
								
							</OrderedQuantity>
													
							<PackSize>
								<xsl:choose>
									<xsl:when test="@ProductType='[S]'">Split</xsl:when>
									<xsl:when test="@ProductType='[P]'">Pack</xsl:when>
								</xsl:choose>
							</PackSize>
													
							<UnitValueExclVAT><xsl:value-of select="@ItemUnitPrice"/></UnitValueExclVAT>
							
							<LineValueExclVAT><xsl:value-of select="@ItemTotalNet"/></LineValueExclVAT>
	
						</PurchaseOrderLine>
						
					</xsl:for-each>
						
				</PurchaseOrderDetail>
				
				
				<PurchaseOrderTrailer>
				
					<NumberOfLines><xsl:value-of select="count(/OrderHeader/OrderItem)"/></NumberOfLines>
					
					<TotalExclVAT><xsl:value-of select="@TotalNet"/></TotalExclVAT>
					
				</PurchaseOrderTrailer>
				
				
			</PurchaseOrder>

		</BatchRoot>
		
	</xsl:template>

</xsl:stylesheet>
