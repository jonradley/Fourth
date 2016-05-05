<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-07		| 2991 Created Module
**********************************************************************
				|						|				
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	<xsl:variable name="SITE_CODE_SEPARATOR" select="' '"/>
	
	<xsl:template match="/GoodsReceivedNote">
		
		<Transaction>
			
			<GeneralData>
			
				<xsl:attribute name="Ref"><xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/></xsl:attribute>
				<xsl:attribute name="Type">AutoAlbaranComercial</xsl:attribute>
				<xsl:attribute name="Date"><xsl:value-of select="GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/></xsl:attribute>
				<xsl:attribute name="Currency">EUR</xsl:attribute>
				<xsl:attribute name="BeginDate"><xsl:value-of select="GoodsReceivedNoteHeader/OrderedDeliveryDetails/DeliveryDate"/></xsl:attribute>
				<xsl:attribute name="EndDate"><xsl:value-of select="GoodsReceivedNoteHeader/OrderedDeliveryDetails/DeliveryDate"/></xsl:attribute>
				
				<xsl:if test="GoodsReceivedNoteHeader/OrderedDeliveryDetails/DeliverySlot[SlotStart and SlotEnd]">				
					<xsl:attribute name="BeginTime"><xsl:value-of select="GoodsReceivedNoteHeader/OrderedDeliveryDetails/DeliverySlot/SlotStart"/></xsl:attribute>
					<xsl:attribute name="EndTime"><xsl:value-of select="GoodsReceivedNoteHeader/OrderedDeliveryDetails/DeliverySlot/SlotEnd"/></xsl:attribute>				
				</xsl:if>				

			</GeneralData>
			
			<Supplier>
			
				<xsl:for-each select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/SuppliersCode[1]">
					<xsl:attribute name="SupplierID">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each> 
				<xsl:attribute name="CustomerSupplierID">
					<!-- 525 -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</xsl:attribute> 
				<xsl:attribute name="CIF"/> 
				<xsl:attribute name="Company">
					<!-- Bebidas y Refrescos, S.A. -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersName"/>
				</xsl:attribute> 
				<xsl:attribute name="Address">
					<!-- Av. Diagonal, 23 -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
				</xsl:attribute> 
				<xsl:attribute name="City">
					<!-- Barcelona -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
				</xsl:attribute> 
				<xsl:attribute name="PC">
					<!-- 08012 -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/PostCode"/>
				</xsl:attribute> 
				<xsl:attribute name="Province">
					<!-- Barcelona -->
					<xsl:value-of select="GoodsReceivedNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
				</xsl:attribute> 
				<xsl:attribute name="Country">ESP</xsl:attribute>
				
			</Supplier>
			
			<Customers>
			
				<Customer>
				
					<xsl:variable name="primaryCodeForSite" 
						select="substring-before(concat(GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode, $SITE_CODE_SEPARATOR), $SITE_CODE_SEPARATOR)"/>
					
					<xsl:variable name="secondaryCodeForSite" 
						select="substring-after(GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/BuyersCode, $SITE_CODE_SEPARATOR)"/>
									
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
						<xsl:value-of select="GoodsReceivedNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
					</xsl:attribute> 
					<xsl:attribute name="SupplierCustomerID">
						<!-- 2 -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</xsl:attribute> 
					<xsl:attribute name="Customer">
						<!-- El Pato Barcelona -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToName"/>
					</xsl:attribute> 
					<xsl:attribute name="Address">
						<!-- Av. Icaria, 34 -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</xsl:attribute> 
					<xsl:attribute name="City">
						<!-- Barcelona -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</xsl:attribute> 
					<xsl:attribute name="PC">
						<!-- 08005 -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode"/>
					</xsl:attribute> 
					<xsl:attribute name="Province">
						<!-- Barcelona -->
						<xsl:value-of select="GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</xsl:attribute> 
					<xsl:attribute name="Country">ESP</xsl:attribute>
					
				</Customer>
					
			</Customers>
			
	
			<References>
				
				<xsl:attribute name="DNRef">
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
				</xsl:attribute>
				<xsl:attribute name="PORef">
					<xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
				</xsl:attribute>
				
				<xsl:attribute name="DNRefDate">
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
				</xsl:attribute>
				<xsl:attribute name="PORefDate">
					<xsl:value-of select="GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
				</xsl:attribute>		
				 
			
			</References>
			
			<ProductList>
			
				<xsl:for-each select="GoodsReceivedNoteDetail/GoodsReceivedNoteLine">
			
					<Product>
					
						<xsl:attribute name="SupplierSKU">
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</xsl:attribute> 
						<xsl:attribute name="CustomerSKU">
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</xsl:attribute> 
						<xsl:attribute name="Item">
							<xsl:value-of select="ProductDescription"/>
						</xsl:attribute> 
						<xsl:attribute name="Qty">
							<xsl:value-of select="AcceptedQuantity"/>
						</xsl:attribute> 
						<xsl:attribute name="MU">
							<xsl:call-template name="transUoM">
								<xsl:with-param name="tsUoM" select="AcceptedQuantity/@UnitOfMeasure"/>
							</xsl:call-template>							
						</xsl:attribute>
						<xsl:attribute name="UP">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:attribute>
						<xsl:attribute name="Total">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:attribute>		
						
						
						<References>				
							<xsl:attribute name="DNRef">
								<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteReference"/>
							</xsl:attribute>
							<xsl:attribute name="PORef">
								<xsl:value-of select="/*/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
							</xsl:attribute>
							<xsl:attribute name="DNRefDate">
								<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/DeliveryNoteReferences/DeliveryNoteDate"/>
							</xsl:attribute>
							<xsl:attribute name="PORefDate">
								<xsl:value-of select="/*/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
							</xsl:attribute> 						
						</References>			
						
					</Product>
					
				</xsl:for-each>

			</ProductList>
			
			<!-- Although mandatory, these can be missed out -->
			<!--GlobalDiscounts/>
			<TaxSummary/>
			<FeesSummary/>
			<DueDates/-->
			<!--TotalSummary>
			
				<xsl:attribute name="GrossAmount">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="NetAmount">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="Discounts">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="SubTotal">
					<xsl:value-of select=""/>
				</xsl:attribute> 
				<xsl:attribute name="Tax">
					<xsl:value-of select=""/>
				</xsl:attribute>
				<xsl:attribute name="Total">
					<xsl:value-of select=""/>
				</xsl:attribute>				
				<xsl:attribute name="GreenDot">
					<xsl:value-of select=""/>
				</xsl:attribute>
				
			</TotalSummary-->
			
		</Transaction>
		
	</xsl:template>

	<xsl:template name="transUoM">
		<xsl:param name="tsUoM"/>
		<xsl:choose>
			<xsl:when test="$tsUoM = 'EA'">Unidades</xsl:when>
			<xsl:when test="$tsUoM = 'CS'">Cajas</xsl:when>
			<xsl:when test="$tsUoM = 'KGM'">Kgs</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
