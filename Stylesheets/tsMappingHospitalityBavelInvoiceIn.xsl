<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2009-07-07		| 2991 Created Module
**********************************************************************
R Cambridge	| 2009-11-24		| 3260 Pilot / UAT changes 
											Add discounts into unit price + line value (as Aramark Es have already included any discount in the catalogue unit price)
**********************************************************************
R Cambridge	| 2010-04-30		| 3495 Omit any time part provided in Invoice date
**********************************************************************
R Cambridge	| 2010-05-11		| 3513 Only create line level tax elements when data is provided in inbound file
**********************************************************************
R Cambridge	| 2010-06-01		| 3551 Handle non-pl customers by using Supplier/@CustomerSupplierID as BuyersLocationID/SuppliersCode
													(this is infact the customer's code for the supplier - the wrong direction - 
													but it fits with what's set up and simplifies the set up of Voxel related relationships)
**********************************************************************
R Cambridge	| 2010-07-05		| 3723 Unit and line value calculations adjusted to accommodate multiple charges and discounts 
**********************************************************************
R Cambridge	| 2010-07-23		| 3788 if no PO date is supplied use delivery note date
**********************************************************************
R Cambridge	| 2010-10-14		| 3951 Created generic Bavel version from Aramark Spain version
**********************************************************************
R Cambridge	| 2010-11-08		| 4012 Voxel invoices failing validation - DiscountedLinesTotalExclVAT not provided
**********************************************************************
R Cambridge	| 2011-07-18		| 4621 Use TotalSummary/@SubTotal as source of taxable amount
													This means discounted lines total and settlement total must always be the same
**********************************************************************
R Cambridge	| 2011-08-22		| 4733 Ensure all line values and prices are 2dpl
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" encoding="ISO-8859-1" />
	
	<xsl:include href="./tsMappingHospitalityBavelCommon.xsl"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/Transaction">
	
		<xsl:variable name="suppliersCodeForUnit">
			<xsl:call-template name="getTSSiteID">
				<xsl:with-param name="bavelUnitCode" select="string(Customers/Customer/@SupplierClientID)"/>
				<xsl:with-param name="bavelSecondaryUnitCode" select="string(Customers/Customer/@CustomerSecondaryID)"/>					
				<xsl:with-param name="bavelTopLevelSysID" select="string(Client/@SysTopLevelClientID)"/>							
			</xsl:call-template>			
		</xsl:variable>
		
		<xsl:variable name="clientsCodeForUnit">
			<xsl:call-template name="getTSSiteID_noSysID">
				<xsl:with-param name="bavelUnitCode" select="string(Customers/Customer/@SupplierClientID)"/>
				<xsl:with-param name="bavelSecondaryUnitCode" select="string(Customers/Customer/@CustomerSecondaryID)"/>
			</xsl:call-template>
		</xsl:variable>
	
		<BatchRoot>
	
			<Batch>
				
				<BatchDocuments>
					<BatchDocument DocumentTypeNo="86">
						<Invoice>
						
							<TradeSimpleHeader>
							
								<SendersCodeForRecipient>
									<xsl:value-of select="$suppliersCodeForUnit"/>
								</SendersCodeForRecipient>
								
								<SendersBranchReference>
								
									<xsl:if test="Client/@SysTopLevelClientID != ''">
										<xsl:value-of select="Client/@SysTopLevelClientID"/>						
										<xsl:text>/</xsl:text>
									</xsl:if>
									
									<xsl:value-of select="Supplier/@CustomerSupplierID"/>
									
								</SendersBranchReference>	
													
							</TradeSimpleHeader>
							
							<InvoiceHeader>
								<Buyer>
									<BuyersLocationID>
										<xsl:for-each select="Client/@ClientID[. != ''][1]">
											<BuyersCode><xsl:value-of select="."/></BuyersCode>
										</xsl:for-each>
										
										<SuppliersCode>
											<xsl:choose>
												<!-- Standard baVel TR set up -->
												<xsl:when test="Client/@SysTopLevelClientID != ''">
													<xsl:value-of select="Client/@SysTopLevelClientID"/>
												</xsl:when>
												
												<!-- Aramark Spain legacy codes -->
												<xsl:otherwise>
													<xsl:value-of select="Supplier/@CustomerSupplierID"/>
												</xsl:otherwise>
											</xsl:choose>
										</SuppliersCode>
										
									</BuyersLocationID>
									<BuyersName><xsl:value-of select="Client/@Company"/></BuyersName>
									<BuyersAddress>
										<AddressLine1><xsl:value-of select="Client/@Address"/></AddressLine1>
										<AddressLine2><xsl:value-of select="Client/@City"/></AddressLine2>
										<AddressLine3><xsl:value-of select="Client/@Province"/></AddressLine3>
										<AddressLine4>ESP</AddressLine4>
										<PostCode><xsl:value-of select="Client/@PC"/></PostCode>
									</BuyersAddress>
								</Buyer>
								
								<!-- Registry? -->
								
								<Supplier>
									<SuppliersLocationID>
										<BuyersCode><xsl:value-of select="Supplier/@CustomerSupplierID"/></BuyersCode>
										<xsl:for-each select="Supplier/@SupplierID[. != ''][1]">
											<SuppliersCode><xsl:value-of select="."/></SuppliersCode>
										</xsl:for-each>
									</SuppliersLocationID>
									<SuppliersName><xsl:value-of select="Supplier/@Company"/></SuppliersName>
									<SuppliersAddress>
										<AddressLine1><xsl:value-of select="Supplier/@Address"/></AddressLine1>
										<AddressLine2><xsl:value-of select="Supplier/@City"/></AddressLine2>
										<AddressLine3><xsl:value-of select="Supplier/@Province"/></AddressLine3>
										<AddressLine4>ESP</AddressLine4>
										<PostCode><xsl:value-of select="Supplier/@PC"/></PostCode>
									</SuppliersAddress>
								</Supplier>
								
								<!-- Registry? -->
								
								<ShipTo>
									<ShipToLocationID>
										<BuyersCode><xsl:value-of select="$clientsCodeForUnit"/></BuyersCode>
										<SuppliersCode><xsl:value-of select="$suppliersCodeForUnit"/></SuppliersCode>									
									</ShipToLocationID>
									<ShipToName><xsl:value-of select="Customers/Customer/@Customer"/></ShipToName>
									<ShipToAddress>
										<AddressLine1><xsl:value-of select="Customers/Customer/@Address"/></AddressLine1>
										<AddressLine2><xsl:value-of select="Customers/Customer/@City"/></AddressLine2>
										<AddressLine3><xsl:value-of select="Customers/Customer/@Province"/></AddressLine3>
										<AddressLine4>ESP</AddressLine4>
										<PostCode><xsl:value-of select="Customers/Customer/@PC"/></PostCode>
									</ShipToAddress>
									<!--ContactName/-->
								</ShipTo>
								<InvoiceReferences>
									<InvoiceReference><xsl:value-of select="GeneralData/@Ref"/></InvoiceReference>
									<InvoiceDate><xsl:value-of select="substring-before(concat(GeneralData/@Date,'T'), 'T')"/></InvoiceDate>
									<xsl:for-each select="GeneralData/@BeginDate[. != ''][1]">
										<TaxPointDate><xsl:value-of select="."/></TaxPointDate>
									</xsl:for-each>
									<VATRegNo><xsl:value-of select="Supplier/@CIF"/></VATRegNo>
									<BuyersVATRegNo><xsl:value-of select="Client/@CIF"/></BuyersVATRegNo>
								</InvoiceReferences>
								<Currency>
									<xsl:choose>
										<xsl:when test="GeneralData/@Currency"><xsl:value-of select="GeneralData/@Currency"/></xsl:when>
										<xsl:otherwise>EUR</xsl:otherwise>
									</xsl:choose>
								</Currency>
							
							</InvoiceHeader>
							
							<InvoiceDetail>
							
								<xsl:for-each select="ProductList/Product">
							
									<InvoiceLine>
										
										<xsl:if test="/Transaction/References/Reference/@PORef[. != ''] or /Transaction/References/Reference/@PORefDate[. != '']">
											<PurchaseOrderReferences>
												<xsl:for-each select="/Transaction/References/Reference/@PORef[. != ''][1]">
													<PurchaseOrderReference><xsl:value-of select="."/></PurchaseOrderReference>
												</xsl:for-each>												
												
												<!-- 3788 use delivery note date if no PO date provided -->
												<xsl:choose>
													<xsl:when test="/Transaction/References/Reference/@PORefDate != ''">
														<PurchaseOrderDate><xsl:value-of select="/Transaction/References/Reference/@PORefDate"/></PurchaseOrderDate>
													</xsl:when>
													<xsl:when test="/Transaction/References/Reference/@DNRefDate != ''">
														<PurchaseOrderDate><xsl:value-of select="/Transaction/References/Reference/@DNRefDate"/></PurchaseOrderDate>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
												
											</PurchaseOrderReferences>
										</xsl:if>
										
										<xsl:if test="/Transaction/References/Reference/@DNRef[. != ''] or /Transaction/References/Reference/@DNRefDate[. != '']">
											<DeliveryNoteReferences>
												<xsl:for-each select="/Transaction/References/Reference/@DNRef[. != ''][1]">
													<DeliveryNoteReference><xsl:value-of select="."/></DeliveryNoteReference>
												</xsl:for-each>
												<xsl:for-each select="/Transaction/References/Reference/@DNRefDate[. != ''][1]">
													<DeliveryNoteDate><xsl:value-of select="."/></DeliveryNoteDate>
												</xsl:for-each>
											</DeliveryNoteReferences>
										</xsl:if>
										
										<ProductID>
											<SuppliersProductCode><xsl:value-of select="@SupplierSKU"/></SuppliersProductCode>
										</ProductID>
										
										<ProductDescription><xsl:value-of select="@Item"/></ProductDescription>
										
										<InvoicedQuantity>
											<xsl:attribute name="UnitOfMeasure">
													<xsl:call-template name="transUoM_fromBaVel">
														<xsl:with-param name="voxelUoM" select="@MU"/>
													</xsl:call-template>										
											</xsl:attribute>
											<xsl:value-of select="@Qty"/>
										</InvoicedQuantity>
										
																		
										<!--
											New logic for unit price, reflects the fact that Aramark Es have already included any discount in the catalogue unit price
										-->	
										
										<xsl:choose>
											
											<xsl:when test="Discounts/Discount/@Amount">
											
												<xsl:variable name="lineDiscounts" select="sum(Discounts/Discount[@Qualifier='Descuento']/@Amount)"/>
													
												<xsl:variable name="lineCharges" select="sum(Discounts/Discount[@Qualifier='Cargo']/@Amount)"/>
												
												<UnitValueExclVAT><xsl:value-of select="format-number((@Total - $lineDiscounts + $lineCharges) div @Qty, '0.00')"/></UnitValueExclVAT>
												
												<LineValueExclVAT><xsl:value-of select="format-number(@Total - $lineDiscounts + $lineCharges, '0.00')"/></LineValueExclVAT>
												
											</xsl:when>
											
											<xsl:otherwise>
												
												<!-- 4733 ensure 2dpl -->
												<UnitValueExclVAT><xsl:value-of select="format-number(@UP, '0.00')"/></UnitValueExclVAT>	
												
												<LineValueExclVAT><xsl:value-of select="format-number(@Total, '0.00')"/></LineValueExclVAT>
												
											</xsl:otherwise>
											
										</xsl:choose>																			
										
										
										
										<!--xsl:if test="Discounts/Discount/@Amount">
											<LineDiscountRate><xsl:value-of select="format-number(100 * Discounts/Discount/@Amount div @Total, '0.00')"/></LineDiscountRate>
											<LineDiscountValue><xsl:value-of select="Discounts/Discount/@Amount"/></LineDiscountValue>
										</xsl:if-->
										
										
										<xsl:for-each select="Taxes/Tax/@Type[1]">
											<VATCode><xsl:value-of select="."/></VATCode>
										</xsl:for-each>
										
										<xsl:for-each select="Taxes/Tax/@Rate[1]">
											<VATRate><xsl:value-of select="format-number(., '0.00')"/></VATRate>
										</xsl:for-each>
										
										<!-- Fees -->
										
										<!-- live level doc refs same as header level references? -->
										
									</InvoiceLine>
									
								</xsl:for-each>
									
							</InvoiceDetail>
							<InvoiceTrailer>
								
								<VATSubTotals>
									
									<xsl:for-each select="/Transaction/TaxSummary/Tax">
									
										<VATSubTotal>
											<xsl:attribute name="VATCode">
												<xsl:value-of select="@Type"/>
											</xsl:attribute>
											<xsl:attribute name="VATRate">
												<xsl:value-of select="format-number(@Rate, '0.00')"/>
											</xsl:attribute>
											
											<DiscountedLinesTotalExclVATAtRate><xsl:value-of select="@Base"/></DiscountedLinesTotalExclVATAtRate>
											
											<xsl:variable name="totalAtCodeAndRate" 
												select="sum(/Transaction/ProductList/Product[Taxes/Tax/@Type = current()/@Type and Taxes/Tax/@Rate = current()/@Rate]/@Total)"/>
												
											<!--xsl:variable name="discountAtCodeAndRate" 
												select="sum(/Transaction/ProductList/Product[Taxes/Tax/@Type = current()/@Type and Taxes/Tax/@Rate = current()/@Rate]/Discounts/Discount/@Amount)"/-->
											
											<!--DocumentDiscountAtRate><xsl:value-of select="$totalAtCodeAndRate - @Base"/></DocumentDiscountAtRate-->
											
											<!--DocumentTotalExclVATAtRate><xsl:value-of select="$totalAtCodeAndRate"/></DocumentTotalExclVATAtRate-->											
											<DocumentTotalExclVATAtRate><xsl:value-of select="@Base"/></DocumentTotalExclVATAtRate>
											<SettlementTotalExclVATAtRate><xsl:value-of select="@Base"/></SettlementTotalExclVATAtRate>
											<VATAmountAtRate><xsl:value-of select="@Amount"/></VATAmountAtRate>
										</VATSubTotal>
										
									</xsl:for-each>
										
								</VATSubTotals>
								<!-- 4012 Only create element if @NetAmount is provided-->
								<xsl:for-each select="TotalSummary/@SubTotal">
									<DiscountedLinesTotalExclVAT><xsl:value-of select="."/></DiscountedLinesTotalExclVAT>
								</xsl:for-each>
								<xsl:for-each select="TotalSummary/@Discounts[. != ''][1]">
									<DocumentDiscount><xsl:value-of select="."/></DocumentDiscount>
								</xsl:for-each>
								<xsl:for-each select="TotalSummary/@SubTotal[1]">
									<DocumentTotalExclVAT><xsl:value-of select="."/></DocumentTotalExclVAT>
								</xsl:for-each>
								<SettlementTotalExclVAT><xsl:value-of select="TotalSummary/@SubTotal"/></SettlementTotalExclVAT>
								<VATAmount><xsl:value-of select="TotalSummary/@Tax"/></VATAmount>
								<SettlementTotalInclVAT><xsl:value-of select="TotalSummary/@Total"/></SettlementTotalInclVAT>
								
								<!-- Greene Dot? -->
								
							</InvoiceTrailer>
						</Invoice>
					</BatchDocument>
				</BatchDocuments>
			</Batch>

		</BatchRoot>	
	
	</xsl:template>

</xsl:stylesheet>
