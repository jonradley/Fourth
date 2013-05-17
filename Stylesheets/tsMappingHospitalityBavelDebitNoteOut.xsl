<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-07		| 2991 Created Module
**********************************************************************
R Cambridge	| 2010-10-14		| 3951 Created generic Bavel version from Aramark Spain version
**********************************************************************
A Barber		| 2013-05-17		| 6548 Amended tax summary output, added tax detail at line level.				
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>	
	
	<xsl:include href="./tsMappingHospitalityBavelCommon.xsl"/>
	
	<xsl:template match="/DebitNote">
		
		<Transaction>
			
			<GeneralData>
			
				<xsl:attribute name="Ref"><xsl:value-of select="DebitNoteHeader/DebitNoteReferences/DebitNoteReference"/></xsl:attribute>
				<xsl:attribute name="Type">AutoFacturaComercial</xsl:attribute>
				<xsl:attribute name="Date"><xsl:value-of select="DebitNoteHeader/DebitNoteReferences/DebitNoteDate"/></xsl:attribute>				
				
				<xsl:attribute name="Currency">
					<xsl:choose>
						<xsl:when test="DebitNoteHeader/Currency">
							<xsl:value-of select="DebitNoteHeader/Currency"/>
						</xsl:when>
						<xsl:otherwise>EUR</xsl:otherwise>
					</xsl:choose>				
				</xsl:attribute>
				
				<xsl:attribute name="BeginDate"><xsl:value-of select="DebitNoteHeader/InvoiceReferences/TaxPointDate"/></xsl:attribute>
				<xsl:attribute name="EndDate"><xsl:value-of select="DebitNoteHeader/InvoiceReferences/TaxPointDate"/></xsl:attribute>		

			</GeneralData>
			
			<Supplier>
			
				<xsl:for-each select="DebitNoteHeader/Supplier/SuppliersLocationID/SuppliersCode[1]">
					<xsl:attribute name="SupplierID">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each> 
				<xsl:attribute name="CustomerSupplierID">
					<!-- 525 -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</xsl:attribute> 
				<xsl:attribute name="CIF">
					<xsl:value-of select="DebitNoteHeader/InvoiceReferences/VATRegNo"/>
				</xsl:attribute>
				<xsl:attribute name="Company">
					<!-- Bebidas y Refrescos, S.A. -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersName"/>
				</xsl:attribute> 
				<xsl:attribute name="Address">
					<!-- Av. Diagonal, 23 -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
				</xsl:attribute> 
				<xsl:attribute name="City">
					<!-- Barcelona -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
				</xsl:attribute> 
				<xsl:attribute name="PC">
					<!-- 08012 -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersAddress/PostCode"/>
				</xsl:attribute> 
				<xsl:attribute name="Province">
					<!-- Barcelona -->
					<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
				</xsl:attribute> 
				<xsl:attribute name="Country">ESP</xsl:attribute>
				
			</Supplier>
			
			<Client>
			
				<xsl:for-each select="DebitNoteHeader/Buyer/BuyersLocationID/BuyersCode">
					<xsl:attribute name="ClientID">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each> 
				<xsl:attribute name="SupplierClientID">
					<!-- 525 -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersLocationID/SuppliersCode[1]"/>
				</xsl:attribute> 
				<xsl:attribute name="CIF">
					<xsl:value-of select="DebitNoteHeader/InvoiceReferences/BuyersVATRegNo"/>
				</xsl:attribute>
				<xsl:attribute name="Company">
					<!-- Bebidas y Refrescos, S.A. -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersName"/>
				</xsl:attribute> 
				<xsl:attribute name="Address">
					<!-- Av. Diagonal, 23 -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
				</xsl:attribute> 
				<xsl:attribute name="City">
					<!-- Barcelona -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
				</xsl:attribute> 
				<xsl:attribute name="PC">
					<!-- 08012 -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersAddress/PostCode"/>
				</xsl:attribute> 
				<xsl:attribute name="Province">
					<!-- Barcelona -->
					<xsl:value-of select="DebitNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
				</xsl:attribute> 
				<xsl:attribute name="Country">ESP</xsl:attribute>
				
				<xsl:variable name="bavelSysID">
					<xsl:call-template name="getTopLevelSysID">
						<xsl:with-param name="tsUnitCode" select="DebitNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</xsl:call-template>						
				</xsl:variable>
			
				<xsl:if test="$bavelSysID != ''">
					<xsl:attribute name="SysTopLevelClientID">
						<xsl:value-of select="$bavelSysID"/>
					</xsl:attribute> 
				</xsl:if>
			
			</Client>

			
			<Customers>
			
			
				<Customer>
				
					<xsl:variable name="primaryCodeForSite">
						<xsl:call-template name="getSiteID">
							<xsl:with-param name="tsUnitCode" select="DebitNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:call-template>	
					</xsl:variable>
					
					<xsl:variable name="secondaryCodeForSite">
						<xsl:call-template name="getSecondarySiteID">
							<xsl:with-param name="tsUnitCode" select="DebitNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
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
						<xsl:value-of select="DebitNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					</xsl:attribute> 
					<xsl:attribute name="SupplierCustomerID">
						<!-- 2 -->
						<xsl:call-template name="getSiteAndSecondaryID">
							<xsl:with-param name="tsUnitCode" select="DebitNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:call-template>
					</xsl:attribute>
					
					<xsl:attribute name="Customer">
						<!-- El Pato Barcelona -->
						<xsl:value-of select="DebitNoteHeader/ShipTo/ShipToName"/>
					</xsl:attribute> 
					<xsl:attribute name="Address">
						<!-- Av. Icaria, 34 -->
						<xsl:value-of select="DebitNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
					</xsl:attribute> 
					<xsl:attribute name="City">
						<!-- Barcelona -->
						<xsl:value-of select="DebitNoteHeader/ShipTo/ShipToAddress/AddressLine2"/>
					</xsl:attribute> 
					<xsl:attribute name="PC">
						<!-- 08005 -->
						<xsl:value-of select="DebitNoteHeader/ShipTo/ShipToAddress/PostCode"/>
					</xsl:attribute> 
					<xsl:attribute name="Province">
						<!-- Barcelona -->
						<xsl:value-of select="DebitNoteHeader/ShipTo/ShipToAddress/AddressLine3"/>
					</xsl:attribute> 
					<xsl:attribute name="Country">ESP</xsl:attribute>
					
				</Customer>
					
			</Customers>
			
	
			<References>
			
				<Reference>
				
					<xsl:attribute name="DNRef">
						<xsl:value-of select="(DebitNoteHeader/DeliveryNoteReferences/DeliveryNoteReference | DebitNoteDetail/DebitNoteLine/DeliveryNoteReferences/DeliveryNoteReference)"/>
					</xsl:attribute>
					<xsl:attribute name="PORef">
						<xsl:value-of select="(DebitNoteHeader/PurchaseOrderReferences/PurchaseOrderReference | DebitNoteDetail/DebitNoteLine/PurchaseOrderReferences/PurchaseOrderReference)"/>
					</xsl:attribute>
					<xsl:attribute name="InvoiceRef">
						<xsl:value-of select="DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
					</xsl:attribute>
					
					<xsl:attribute name="DNRefDate">
						<xsl:value-of select="(DebitNoteHeader/DeliveryNoteReferences/DeliveryNoteDate | DebitNoteDetail/DebitNoteLine/DeliveryNoteReferences/DeliveryNoteDate)"/>
					</xsl:attribute>
					<xsl:attribute name="PORefDate">
						<xsl:value-of select="(DebitNoteHeader/PurchaseOrderReferences/PurchaseOrderDate | DebitNoteDetail/DebitNoteLine/PurchaseOrderReferences/PurchaseOrderDate)"/>
					</xsl:attribute> 
					<xsl:attribute name="InvoiceRefDate">
						<xsl:value-of select="DebitNoteHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:attribute>
					
				</Reference>
			
			</References>
			
			<ProductList>
			
				<xsl:for-each select="DebitNoteDetail/DebitNoteLine">
			
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
							<xsl:value-of select="DebitedQuantity"/>
						</xsl:attribute> 
						<xsl:attribute name="MU">
							<xsl:call-template name="transUoM_toBaVel">
								<xsl:with-param name="tsUoM" select="DebitedQuantity/@UnitOfMeasure"/>
							</xsl:call-template>							
						</xsl:attribute>
						<xsl:attribute name="UP">
							<xsl:value-of select="UnitValueExclVAT"/>
						</xsl:attribute>
						<xsl:attribute name="Total">
							<xsl:value-of select="LineValueExclVAT"/>
						</xsl:attribute>	
						<xsl:attribute name="Comment">
							<xsl:value-of select="Narrative"/>
						</xsl:attribute>						
						
						<References>	
						
							<Reference>
										
								<xsl:attribute name="DNRef">
									<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
								</xsl:attribute>
								<xsl:attribute name="PORef">
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
								</xsl:attribute>
								<xsl:attribute name="InvoiceRef">
									<xsl:value-of select="../../DebitNoteHeader/InvoiceReferences/InvoiceReference"/>
								</xsl:attribute>
								
								<xsl:attribute name="DNRefDate">
									<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
								</xsl:attribute>
								<xsl:attribute name="PORefDate">
									<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
								</xsl:attribute> 
								<xsl:attribute name="InvoiceRefDate">
									<xsl:value-of select="../../DebitNoteHeader/InvoiceReferences/InvoiceDate"/>
								</xsl:attribute>	
							
							</Reference>
											
						</References>
						
						<Taxes>
							<Tax>
								<xsl:attribute name="Type">
									<xsl:value-of select="VATCode"/>
								</xsl:attribute>
								<xsl:attribute name="Rate">
									<xsl:value-of select="VATRate"/>
								</xsl:attribute>
								<xsl:attribute name="Amount">
									<xsl:value-of select="format-number(LineValueExclVAT * (VATRate div 100),'0.000')"/>
								</xsl:attribute>							
							</Tax>
						</Taxes>			
						
					</Product>
					
				</xsl:for-each>

			</ProductList>
			
			<!--GlobalDiscounts/-->
			<TaxSummary>
				<xsl:for-each select="DebitNoteTrailer/VATSubTotals/VATSubTotal">
						<TaxType>
							<xsl:attribute name="Type">
								<xsl:value-of select="@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="Rate">
								<xsl:value-of select="@VATRate"/>
							</xsl:attribute>
							<xsl:attribute name="Base">
								<xsl:value-of select="SettlementTotalExclVATAtRate"/>
							</xsl:attribute>
							<xsl:attribute name="Amount">
								<xsl:value-of select="VATAmountAtRate"/>
							</xsl:attribute>
						</TaxType>
				</xsl:for-each>
			</TaxSummary>
			
			<!--FeesSummary/>
			<DueDates/-->
			
			<TotalSummary>
			
				<xsl:attribute name="GrossAmount">
					<xsl:value-of select="format-number(sum(DebitNoteDetail/DebitNoteLine/LineValueExclVAT), '0.00')"/>
				</xsl:attribute> 
				<xsl:attribute name="NetAmount">
					<xsl:value-of select="DebitNoteTrailer/DiscountedLinesTotalExclVAT"/>
				</xsl:attribute> 
				<xsl:attribute name="Discounts">
					<xsl:value-of select="format-number(DebitNoteTrailer/DiscountedLinesTotalExclVAT - DebitNoteTrailer/SettlementTotalExclVAT, '0.00')"/>
				</xsl:attribute> 
				<xsl:attribute name="SubTotal">
					<xsl:value-of select="DebitNoteTrailer/SettlementTotalExclVAT"/>
				</xsl:attribute> 
				<xsl:attribute name="Tax">
					<xsl:value-of select="DebitNoteTrailer/VATAmount"/>
				</xsl:attribute>
				<xsl:attribute name="Total">
					<xsl:value-of select="DebitNoteTrailer/DocumentTotalInclVAT"/>
				</xsl:attribute>				
				<!--xsl:attribute name="GreenDot">
					<xsl:value-of select=""/>
				</xsl:attribute-->
				
			</TotalSummary>



			
			
			
	<!--GlobalDiscounts/>
	<TaxSummary>
		<Tax Type="IVA" Rate="4" Base="370" Amount="14.8"/>
	</TaxSummary>
	<FeesSummary/>
	<DueDates>
		<DueDate Date="2005-02-01" Amount="384.8" PaymentID="ReciboDomiciliado" Description="Domiciliacion"/>
	</DueDates>
	<TotalSummary GrossAmount="370" NetAmount="370" Discounts="0" SubTotal="370" Tax="14.8" Total="384.8" GreenDot="1.5"/-->

			
		</Transaction>
		
	</xsl:template>

</xsl:stylesheet>
