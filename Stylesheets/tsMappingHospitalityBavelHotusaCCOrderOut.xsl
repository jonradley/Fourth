<?xml version="1.0" encoding="UTF-8"?>
<!--===================================================================================
Alterations
=======================================================================================
Name	 | Date			| Change
=======================================================================================
J Miguel | 27/08/2015	| 10474 (UK) / 10475 (US) - Fork from default voxel mapper
====================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	<xsl:include href="./tsMappingHospitalityBavelCommon.xsl"/>
	
	<xsl:template match="/PurchaseOrder">
		
		<Transaction>
			
			<GeneralData>
			
				<xsl:attribute name="Ref"><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
				<xsl:attribute name="Type">Pedido</xsl:attribute>
				<xsl:attribute name="Date"><xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:attribute>
				<xsl:attribute name="Currency">EUR</xsl:attribute>
				<xsl:attribute name="BeginDate"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></xsl:attribute>
				<xsl:attribute name="EndDate"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/></xsl:attribute>
				
				<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot[SlotStart and SlotEnd]">				
					<xsl:attribute name="BeginTime"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/></xsl:attribute>
					<xsl:attribute name="EndTime"><xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/></xsl:attribute>				
				</xsl:if>				

			</GeneralData>
			
			<Supplier>
			
				<xsl:for-each select="PurchaseOrderHeader/Supplier/SuppliersLocationID/SuppliersCode[1]">
					<xsl:attribute name="SupplierID">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each> 
				<xsl:attribute name="CustomerSupplierID">
					<!-- 525 -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</xsl:attribute> 
				<xsl:attribute name="CIF"/> 
				<xsl:attribute name="Company">
					<!-- Bebidas y Refrescos, S.A. -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersName"/>
				</xsl:attribute> 
				<xsl:attribute name="Address">
					<!-- Av. Diagonal, 23 -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine1"/>
				</xsl:attribute> 
				<xsl:attribute name="City">
					<!-- Barcelona -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine2"/>
				</xsl:attribute> 
				<xsl:attribute name="PC">
					<!-- 08012 -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersAddress/PostCode"/>
				</xsl:attribute> 
				<xsl:attribute name="Province">
					<!-- Barcelona -->
					<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersAddress/AddressLine3"/>
				</xsl:attribute> 
				<xsl:attribute name="Country">ESP</xsl:attribute>
				
			</Supplier>
			
			<Customers>
			
				<Customer>
				
					<xsl:variable name="primaryCodeForSite">
						<xsl:call-template name="getSiteID">
							<xsl:with-param name="tsUnitCode" select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:call-template>	
					</xsl:variable>
					
					<xsl:variable name="secondaryCodeForSite">
						<xsl:call-template name="getSecondarySiteID">
							<xsl:with-param name="tsUnitCode" select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:call-template>					
					</xsl:variable>
					
									
					<xsl:attribute name="CustomerID">
						<!-- 25 -->
						<xsl:value-of select="$primaryCodeForSite"/>
					</xsl:attribute> 
					
					<xsl:if test="$secondaryCodeForSite != ''">
						<xsl:attribute name="CustomerSecondaryID">
							<!-- 25 -->
							<xsl:value-of select="$secondaryCodeForSite"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="SupplierClientID">
						<!-- 1024 -->
						<xsl:value-of select="PurchaseOrderHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</xsl:attribute> 
					<xsl:attribute name="SupplierCustomerID">
						<!-- 2 -->
						<xsl:call-template name="getSiteAndSecondaryID">
							<xsl:with-param name="tsUnitCode" select="PurchaseOrderHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:call-template>
					</xsl:attribute> 
					<xsl:attribute name="Customer">
						<!-- El Pato Barcelona -->
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToName"/>
					</xsl:attribute> 
					<xsl:attribute name="Address">
						<!-- Av. Icaria, 34 -->
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</xsl:attribute> 
					<xsl:attribute name="City">
						<!-- Barcelona -->
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</xsl:attribute> 
					<xsl:attribute name="PC">
						<!-- 08005 -->
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/PostCode"/>
					</xsl:attribute> 
					<xsl:attribute name="Province">
						<!-- Barcelona -->
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</xsl:attribute> 
					<xsl:attribute name="Country">ESP</xsl:attribute>
					
				</Customer>
					
			</Customers>
			
			<xsl:if test="PurchaseOrderHeader/ShipTo/ContactName[. != ''] or PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions[. != '']">
				<Comments>
					<Comment>
						<xsl:attribute name="Msg">
							<xsl:if test="PurchaseOrderHeader/ShipTo/ContactName[. != '']">
								<xsl:text>Incidencias contactar con </xsl:text><xsl:value-of select="PurchaseOrderHeader/ShipTo/ContactName"/><xsl:text>. </xsl:text>
							</xsl:if>
							<!-- Pedido urgente!!! -->
							<xsl:if test="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions[. != '']">
								<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/SpecialDeliveryInstructions"/>
							</xsl:if>
						</xsl:attribute>
					</Comment>
					<Comment Subject="Cadena">
						<xsl:value-of select="PurchaseOrderHeader/ShipTo/ShipToLocationID/GLN"/>
					</Comment>
				</Comments>
			</xsl:if>
				
			<References/>
			
			<ProductList>
			
				<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
			
					<Product>
					
						<xsl:attribute name="SupplierSKU">
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</xsl:attribute> 
						<xsl:attribute name="CustomerSKU">
							<xsl:value-of select="ProductID/BuyersProductCode"/>
						</xsl:attribute> 
						<xsl:attribute name="Item">
							<xsl:value-of select="ProductDescription"/>
						</xsl:attribute> 
						<xsl:attribute name="Qty">
							<xsl:value-of select="OrderedQuantity"/>
						</xsl:attribute> 
						<xsl:attribute name="MU">
							<xsl:call-template name="transUoM_toBaVel">
								<xsl:with-param name="tsUoM" select="OrderedQuantity/@UnitOfMeasure"/>
							</xsl:call-template>							
						</xsl:attribute>
						<xsl:attribute name="UP">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:attribute>
						<xsl:attribute name="Total">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:attribute>					
						
					</Product>
					
				</xsl:for-each>

			</ProductList>
			
			<!-- Although mandatory, these can be missed out -->
			<!--GlobalDiscounts/>
			<TaxSummary/>
			<FeesSummary/>
			<DueDates/-->
			<TotalSummary>
			
				<!--xsl:attribute name="GrossAmount">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="NetAmount">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="Discounts">
					<xsl:value-of select=""/>
				</xsl:attribute--> 
				<xsl:attribute name="Total">
					<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
				</xsl:attribute>
				<xsl:attribute name="Tax">
					<xsl:text>0</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="SubTotal">
					<xsl:value-of select="PurchaseOrderTrailer/TotalExclVAT"/>
				</xsl:attribute> 			
				<!--xsl:attribute name="GreenDot">
					<xsl:value-of select=""/>
				</xsl:attribute-->
				
			</TotalSummary>
			
		</Transaction>
		
	</xsl:template>


	
</xsl:stylesheet>
