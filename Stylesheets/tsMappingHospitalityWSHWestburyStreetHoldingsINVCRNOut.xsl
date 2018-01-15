<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Maps iXML invoices into EanUcc format for Westbury Street Holdings
' 
'******************************************************************************************
' Module History
'******************************************************************************************
' Date			| Name			| Description of modification
'******************************************************************************************
' 10/08/2017 	| M Dimant		| 12251:Created 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns="http://www.eanucc.org/2002/Pay/FoodService/FoodService/UK/EanUcc/Pay" 
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml"/>
	
<!-- INVOICES -->
	<xsl:template match="/Invoice">	
	<Invoices>	
		<Invoice invoiceCurrencyCode="GBP">		
			<!-- Invoice Reference -->
			<InvoiceDocumentDetails>
				<InvoiceDocumentDate>
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
				</InvoiceDocumentDate>
				<InvoiceDocumentNumber>
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</InvoiceDocumentNumber>			
			</InvoiceDocumentDetails>		
			
			<!-- Purchase Order Reference -->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference">
				<OrderReference>
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate">
						<PurchaseOrderDate>
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate>
					</xsl:if>
					<PurchaseOrderNumber>
						<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
					</PurchaseOrderNumber>
				</OrderReference>
			</xsl:if>
			
			<!-- PO Confirmation Reference -->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference">
				<OrderConfirmationReference>
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate">
						<PurchaseOrderConfirmationDate>
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
						</PurchaseOrderConfirmationDate>
					</xsl:if>
					<PurchaseOrderConfirmationNumber>
						<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
					</PurchaseOrderConfirmationNumber>
				</OrderConfirmationReference>
			</xsl:if>
			
			<!-- Delivery Note Reference -->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference">
				<DespatchReference>
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate">
						<DespatchDocumentDate>
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
						</DespatchDocumentDate>
					</xsl:if>
					<DespatchDocumentNumber>
						<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
					</DespatchDocumentNumber>
				</DespatchReference>
			</xsl:if>
			
			<!-- Goods Received Note Reference -->
			<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference">
				<ReceiptAdviceReference>
					<xsl:if test="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate">
						<ReceiptAdviceDocumentDate>
							<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
						</ReceiptAdviceDocumentDate>
					</xsl:if>
					<ReceiptAdviceDocumentNumber>
						<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine[1]/GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
					</ReceiptAdviceDocumentNumber>
				</ReceiptAdviceReference>
			</xsl:if>
			
			<Buyer>
				<BuyerGLN><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN"/></BuyerGLN>
				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned>
						<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2">
						<StreetName><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3">
						<City><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode><xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
			</Buyer>
			
			<Seller>
				<SellerGLN scheme="GLN"><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN"/></SellerGLN>
				<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2">
						<StreetName><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3">
						<City><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode><xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
				<VATRegisterationNumber>
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
				</VATRegisterationNumber>
			</Seller>
			
			<ShipTo>
				<ShipToGLN scheme="GLN"><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/GLN"/></ShipToGLN>
				<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<xsl:if test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></BuildingIdentifier>
					<StreetName><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></StreetName>
					<City><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></City>
					<PostCode><xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode"/></PostCode>
					<Country>GB</Country>
				</Address>
			</ShipTo>			
			
			<DespatchInformation>
				<xsl:attribute name="actualShipDateTime">
					<xsl:choose>
						<xsl:when test="/Invoice/InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DespatchDate">
							<xsl:value-of select="concat(/Invoice/InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DespatchDate,'T00:00:00')"/>
						</xsl:when>					
						<xsl:otherwise>
							<xsl:value-of select="concat(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate,'T00:00:00')"/>
						</xsl:otherwise>
					</xsl:choose>						
				</xsl:attribute> 
			</DespatchInformation>
		
			<TaxPointDateTime>
				<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
			</TaxPointDateTime>
			
			<!-- Invoice Lines -->
			<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">
				<xsl:sort select="LineNumber"/>
				<InvoiceItem>
					<LineItemNumber><xsl:value-of select="LineNumber"/></LineItemNumber>
					<LineItemDescription><xsl:value-of select="ProductDescription"/></LineItemDescription>
					<ItemIdentifier>
						<GTIN scheme="GTIN"><xsl:value-of select="ProductID/GTIN"/></GTIN>
						<xsl:if test="ProductID/SuppliersProductCode">
							<AlternateCode><xsl:value-of select="ProductID/SuppliersProductCode"/></AlternateCode>
						</xsl:if>
					</ItemIdentifier>
					<InvoiceQuantity>
						<xsl:attribute name="unitCode"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(InvoicedQuantity, '0.000')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(InvoicedQuantity * -1, '0.000')"/></xsl:otherwise>
						</xsl:choose>
					</InvoiceQuantity>
					<xsl:if test="OrderedQuantity">
						<OrderedQuantity>
							<xsl:attribute name="unitCode"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></xsl:attribute>
							<xsl:value-of select="format-number(OrderedQuantity, '0.000')"/>
						</OrderedQuantity>
					</xsl:if>
					<UnitPrice Amount="GBP"><xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/></UnitPrice>
					<LineItemPrice Amount="GBP">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(LineValueExclVAT * -1, '0.00')"/></xsl:otherwise>
						</xsl:choose>
					</LineItemPrice>
					<xsl:if test="VATRate">
						<VATDetails>
							<TaxAmount>
								<xsl:value-of select="format-number((LineValueExclVAT * VATRate) div 100,'0.00')"/>
							</TaxAmount>
							<xsl:if test="VATCode">
								<TaxCategory codeList="EANCOM"><xsl:value-of select="VATCode"/></TaxCategory>
							</xsl:if>
							<TaxRate format="PERCENT"><xsl:value-of select="format-number(VATRate, '0.00')"/></TaxRate>
						</VATDetails>
					</xsl:if>
					<CreditLineIndicator>
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) &lt; 0">2</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</CreditLineIndicator>
				</InvoiceItem>
			</xsl:for-each>
			<!-- Trailer -->			
				<InvoiceTotals>	
					<DocumentDiscountRate format="PERCENT">
						<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentDiscountRate, '0.00')"/>
					</DocumentDiscountRate>
					<SettlementDiscountRate format="PERCENT">
						<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementDiscountRate, '0.00')"/>
					</SettlementDiscountRate>				
					<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal">
						<VATRateTotals>
							<VATDetails>
								<TaxCategory><xsl:value-of select="@VATCode"/></TaxCategory>
								<TaxRate format="PERCENT"><xsl:value-of select="format-number(@VATRate, '0.00')"/></TaxRate>
							</VATDetails>
							<DiscountedLineTotals Amount="GBP"><xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/></DiscountedLineTotals>
							<DocumentDiscountValue Amount="GBP"><xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/></DocumentDiscountValue>
							<SettlementDiscountValue Amount="GBP"><xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/></SettlementDiscountValue>
							<TaxableAmount Amount="GBP"><xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/></TaxableAmount>
							<VATPayable Amount="GBP"><xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/></VATPayable>
						</VATRateTotals>
					</xsl:for-each>
					<SettlementSubTotal Amount="GBP"><xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementTotalExclVAT, '0.00')"/></SettlementSubTotal>
					<InvoiceSubTotal Amount="GBP"><xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalExclVAT, '0.00')"/></InvoiceSubTotal>
					<VATTotal Amount="GBP"><xsl:value-of select="format-number(/Invoice/InvoiceTrailer/VATAmount, '0.00')"/></VATTotal>
					<SettlementInvoiceTotal Amount="GBP"><xsl:value-of select="format-number(/Invoice/InvoiceTrailer/SettlementTotalInclVAT, '0.00')"/></SettlementInvoiceTotal>
					<TotalPayable Amount="GBP"><xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalInclVAT, '0.00')"/></TotalPayable>
				</InvoiceTotals>
			</Invoice>
		</Invoices>
	</xsl:template>
	
	<!-- CREDIT NOTES -->
	<xsl:template match="/CreditNote">	
		<CreditNotes>	
			<CreditNote invoiceCurrencyCode="GBP">		
			<!-- Credit Note Reference -->
			<CreditNoteDocumentDetails>
				<CreditNoteDocumentDate>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
				</CreditNoteDocumentDate>
				<CreditNoteDocumentNumber>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</CreditNoteDocumentNumber>			
			</CreditNoteDocumentDetails>
				
			<!-- Invoice Reference -->
			<InvoiceReference>
				<InvoiceDocumentDate><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate"/></InvoiceDocumentDate>
				<InvoiceDocumentNumber><xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/></InvoiceDocumentNumber>
			</InvoiceReference>	
						
			<!-- Purchase Order Reference -->
			<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference">
				<OrderReference>
					<xsl:if test="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate">
						<PurchaseOrderDate>
							<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
						</PurchaseOrderDate>
					</xsl:if>
					<PurchaseOrderNumber>
						<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
					</PurchaseOrderNumber>
				</OrderReference>
			</xsl:if>			
			
			
			
			<Buyer>
				<BuyerGLN><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/></BuyerGLN>
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode">
					<BuyerAssigned>
						<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2">
						<StreetName><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3">
						<City><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode><xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
			</Buyer>
			
			<Seller>
				<SellerGLN scheme="GLN"><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/></SellerGLN>
				<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode">
					<BuyerAssigned><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/></BuildingIdentifier>
					<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2">
						<StreetName><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/></StreetName>
					</xsl:if>
					<xsl:if test="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3">
						<City><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/></City>
					</xsl:if>
					<PostCode><xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/></PostCode>
					<Country codeList="ISO">GB</Country>
				</Address>
				<VATRegisterationNumber>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
				</VATRegisterationNumber>
			</Seller>
			
			<ShipTo>
				<ShipToGLN scheme="GLN"><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/></ShipToGLN>
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
					<BuyerAssigned><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/></BuyerAssigned>
				</xsl:if>
				<xsl:if test="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
					<SellerAssigned><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/></SellerAssigned>
				</xsl:if>
				<Address>
					<BuildingIdentifier><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/></BuildingIdentifier>
					<StreetName><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2"/></StreetName>
					<City><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3"/></City>
					<PostCode><xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/PostCode"/></PostCode>
					<Country>GB</Country>
				</Address>
			</ShipTo>
		
			<DespatchInformation>
				<xsl:attribute name="actualShipDateTime">
					<xsl:choose>
						<xsl:when test="/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DespatchDate">
							<xsl:value-of select="concat(/CreditNote/CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DespatchDate,'T00:00:00')"/>
						</xsl:when>
						<xsl:when test="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate">
							<xsl:value-of select="concat(/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate,'T00:00:00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'T00:00:00')"/>
						</xsl:otherwise>
					</xsl:choose>						
				</xsl:attribute> 
			</DespatchInformation>
			
			<TaxPointDateTime>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
			</TaxPointDateTime>
			
			<!-- CreditNote Lines -->
			<xsl:for-each select="/CreditNote/CreditNoteDetail/CreditNoteLine">
				<xsl:sort select="LineNumber"/>
				<CreditItem>
					<LineItemNumber><xsl:value-of select="LineNumber"/></LineItemNumber>
					<LineItemDescription><xsl:value-of select="ProductDescription"/></LineItemDescription>
					<ItemIdentifier>
						<GTIN scheme="GTIN"><xsl:value-of select="ProductID/GTIN"/></GTIN>
						<xsl:if test="ProductID/SuppliersProductCode">
							<AlternateCode><xsl:value-of select="ProductID/SuppliersProductCode"/></AlternateCode>
						</xsl:if>
					</ItemIdentifier>
					<InvoiceQuantity>
						<xsl:attribute name="unitCode">
							<xsl:choose>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure">
									<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="InvoicedQuantity"><xsl:value-of select="format-number(InvoicedQuantity, '0.000')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(CreditedQuantity, '0.000')"/></xsl:otherwise>
						</xsl:choose>
					</InvoiceQuantity>
					<CreditQuantity>
						<xsl:attribute name="unitCode"><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(CreditedQuantity, '0.000')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(CreditedQuantity * -1, '0.000')"/></xsl:otherwise>
						</xsl:choose>
					</CreditQuantity>
					<xsl:if test="InvoicedQuantity">
						<InvoicedQuantity>
							<xsl:attribute name="unitCode"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
							<xsl:value-of select="format-number(InvoicedQuantity, '0.000')"/>
						</InvoicedQuantity>
					</xsl:if>
					<UnitPrice Amount="GBP"><xsl:value-of select="format-number(UnitValueExclVAT, '0.00')"/></UnitPrice>
					<LineItemPrice Amount="GBP">
						<xsl:choose>
							<xsl:when test="number(LineValueExclVAT) >= 0"><xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(LineValueExclVAT * -1, '0.00')"/></xsl:otherwise>
						</xsl:choose>
					</LineItemPrice>
					<xsl:if test="VATRate">
						<VATDetails>
							<TaxAmount>
								<xsl:value-of select="format-number((LineValueExclVAT * VATRate) div 100,'0.00')"/>
							</TaxAmount>
							<xsl:if test="VATCode">
								<TaxCategory codeList="EANCOM"><xsl:value-of select="VATCode"/></TaxCategory>
							</xsl:if>
							<TaxRate format="PERCENT"><xsl:value-of select="format-number(VATRate, '0.00')"/></TaxRate>
						</VATDetails>
					</xsl:if>
					<CreditLineIndicator><xsl:text>2</xsl:text></CreditLineIndicator>
				</CreditItem>
			</xsl:for-each>
			<!-- Trailer -->			
				<CreditTotals>	
					<DocumentDiscountRate format="PERCENT">
						<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentDiscountRate, '0.00')"/>
					</DocumentDiscountRate>
					<SettlementDiscountRate format="PERCENT">
						<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementDiscountRate, '0.00')"/>
					</SettlementDiscountRate>				
					<xsl:for-each select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
						<VATRateTotals>
							<VATDetails>
								<TaxCategory><xsl:value-of select="@VATCode"/></TaxCategory>
								<TaxRate format="PERCENT"><xsl:value-of select="format-number(@VATRate, '0.00')"/></TaxRate>
							</VATDetails>
							<DiscountedLineTotals Amount="GBP"><xsl:value-of select="format-number(DiscountedLinesTotalExclVATAtRate, '0.00')"/></DiscountedLineTotals>
							<DocumentDiscountValue Amount="GBP"><xsl:value-of select="format-number(DocumentDiscountAtRate, '0.00')"/></DocumentDiscountValue>
							<SettlementDiscountValue Amount="GBP"><xsl:value-of select="format-number(SettlementDiscountAtRate, '0.00')"/></SettlementDiscountValue>
							<TaxableAmount Amount="GBP"><xsl:value-of select="format-number(SettlementTotalExclVATAtRate, '0.00')"/></TaxableAmount>
							<VATPayable Amount="GBP"><xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/></VATPayable>
						</VATRateTotals>
					</xsl:for-each>
					<SettlementSubTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT, '0.00')"/></SettlementSubTotal>
					<CreditNoteSubTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT, '0.00')"/></CreditNoteSubTotal>
					<VATTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/VATAmount, '0.00')"/></VATTotal>
					<SettlementCreditTotal Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT, '0.00')"/></SettlementCreditTotal>
					<TotalPayable Amount="GBP"><xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/></TotalPayable>
				</CreditTotals>
			</CreditNote>
		</CreditNotes>
	</xsl:template>
	

	
</xsl:stylesheet>
