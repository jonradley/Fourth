<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Perform transformations on the XML version of the flat file
******************************************************************************************
 Module History
******************************************************************************************
 Date			| Name					| Description of modification
******************************************************************************************
 05/03/2013	| Harold Robson		| FB6189 Created module 
******************************************************************************************
				| 							|
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!--=======================================================================================
  Routine        : {default template}
  Description    : apply trasnformations that are required for both INVs and CRNs, and store the xml in a variable
							then loop through the docs in the variable, applying a different set of trasnformations depending on the doctype
  Author         : H Robson 6189 11/03/2013
 =======================================================================================-->
	<xsl:template match="/">
		<!-- variable for new XML -->
		<xsl:variable name="xmlInboundDocuments">
			<xsl:apply-templates/>
		</xsl:variable>
		<!--perform the rest of the transformation as normal -->
		<xsl:call-template name="mainTransformation">
			<xsl:with-param name="vobNode" select="msxsl:node-set($xmlInboundDocuments)"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- format dates for T|S -->
	<xsl:template match="InvoiceDate | TaxPointDate | PurchaseOrderDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
		</xsl:element>
	</xsl:template>	
	
	<!-- copy template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

		
	<!--=======================================================================================
  Routine        : mainTransformation
  Description    : creates the output xml as before, except now it is acting on a variable and not directly on the input xml
  Author         : H Robson 6189 11/03/2013
 =======================================================================================-->
	<xsl:template name="mainTransformation">
		<xsl:param name="vobNode"/>

		<BatchRoot>

			<!-- Generate INVOICES -->
			<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'INVO']">
				<Batch>
					<BatchDocuments>
						<BatchDocument>
							<Invoice>
								<InvoiceHeader>
									<Buyer>
										<BuyersLocationID>
											<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></xsl:element>
										</BuyersLocationID>
										<xsl:element name="BuyersName"><xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/></xsl:element>
										<BuyersAddress>
											<xsl:element name="AddressLine1"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></xsl:element>
											<xsl:element name="AddressLine2"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></xsl:element>
											<xsl:element name="AddressLine3"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></xsl:element>
											<xsl:element name="AddressLine4"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/></xsl:element>
											<xsl:element name="PostCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode"/></xsl:element>
										</BuyersAddress>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></xsl:element>
										</ShipToLocationID>
										<xsl:element name="ShipToName"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></xsl:element>
										<ShipToAddress>
											<xsl:element name="AddressLine1"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:element>
											<xsl:element name="AddressLine2"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:element>
											<xsl:element name="AddressLine3"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:element>
											<xsl:element name="AddressLine4"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:element>
											<xsl:element name="PostCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/></xsl:element>
										</ShipToAddress>
									</ShipTo>
									<InvoiceReferences>
										<!-- On invoice files not credit type the true ben E Keith invoice number is 8 digits and is shown in the first 8 characters of the invoice number field 
										Please use the 8 digit number when referencing invoice number to the customer because that’s what’s on the hard copy.  
										The credits should be used in the full size of the invoice number because it uses the same 8 digit invoice number so we needed it to be unique.   
										example credit number: 04551824-C-201302051 example invoice number: 04597847. REMOVE: -I-20130201 -->
										<xsl:element name="InvoiceReference"><xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceReference,1,8)"/></xsl:element>
										<xsl:element name="InvoiceDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/></xsl:element>
										<xsl:element name="TaxPointDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/></xsl:element>
									</InvoiceReferences>
								</InvoiceHeader>
								<InvoiceDetail>
									<!-- LINE DETAIL -->
									<xsl:for-each select="InvoiceDetail/InvoiceLine">
										<InvoiceLine>
											<PurchaseOrderReferences>
												<xsl:element name="PurchaseOrderDate"><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/></xsl:element>
												<TradeAgreement><xsl:element name="ContractReference"><xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractReference"/></xsl:element></TradeAgreement>
											</PurchaseOrderReferences>
											<ProductID>
												<xsl:element name="GTIN"><xsl:value-of select="ProductID/GTIN"/></xsl:element>
												<xsl:element name="SuppliersProductCode"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:element>
											</ProductID>
											<xsl:element name="ProductDescription"><xsl:value-of select="ProductDescription"/></xsl:element>
											<xsl:element name="OrderedQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="OrderedQuantity"/>
											</xsl:element>
											<xsl:element name="DeliveredQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="DeliveredQuantity"/>
											</xsl:element>
											<xsl:element name="InvoicedQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="InvoicedQuantity"/>
											</xsl:element>
											<xsl:element name="UnitValueExclVAT"><xsl:value-of select="UnitValueExclVAT"/></xsl:element>
										</InvoiceLine>
									</xsl:for-each>
									<!-- LINE DETAIL: fees and surcharges -->
									<xsl:for-each select="DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !='']">
										<InvoiceLine>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="concat(DeliveryNoteReference,'-',DeliveryNoteDate)"/></SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:choose>
													<xsl:when test="DeliveryNoteDate = 'FSUR'">Fuel Surcharge</xsl:when>
													<xsl:when test="DeliveryNoteDate = 'DLVF'">Delivery Fee</xsl:when>
												</xsl:choose>
											</ProductDescription>
											<UnitValueExclVAT><xsl:value-of select="DespatchDate"/></UnitValueExclVAT>
										</InvoiceLine>
									</xsl:for-each>
								</InvoiceDetail>
								<!-- Invoice Trailer -->
								<InvoiceTrailer>
									<xsl:element name="NumberOfLines"><xsl:value-of select="InvoiceTrailer/NumberOfLines"/></xsl:element>
									<xsl:element name="NumberOfItems"><xsl:value-of select="InvoiceTrailer/NumberOfItems"/></xsl:element>
									<xsl:element name="DocumentTotalExclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/></xsl:element>
									<xsl:element name="VATAmount"><xsl:value-of select="InvoiceTrailer/VATAmount"/></xsl:element>
									<xsl:element name="DocumentTotalInclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/></xsl:element>
								</InvoiceTrailer>
							</Invoice>
						</BatchDocument>
					</BatchDocuments>
				</Batch>
			</xsl:for-each>
		
			<!-- Generate CREDITS -->
			<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'CRED']">
				<Batch>
					<BatchDocuments>
						<BatchDocument>
							<CreditNote>
								<CreditNoteHeader>
									<Buyer>
										<BuyersLocationID>
											<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></xsl:element>
										</BuyersLocationID>
										<xsl:element name="BuyersName"><xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/></xsl:element>
										<BuyersAddress>
											<xsl:element name="AddressLine1"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></xsl:element>
											<xsl:element name="AddressLine2"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></xsl:element>
											<xsl:element name="AddressLine3"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></xsl:element>
											<xsl:element name="AddressLine4"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/></xsl:element>
											<xsl:element name="PostCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode"/></xsl:element>
										</BuyersAddress>
									</Buyer>
									<ShipTo>
										<ShipToLocationID>
											<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></xsl:element>
										</ShipToLocationID>
										<xsl:element name="ShipToName"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></xsl:element>
										<ShipToAddress>
											<xsl:element name="AddressLine1"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/></xsl:element>
											<xsl:element name="AddressLine2"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/></xsl:element>
											<xsl:element name="AddressLine3"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/></xsl:element>
											<xsl:element name="AddressLine4"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/></xsl:element>
											<xsl:element name="PostCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/></xsl:element>
										</ShipToAddress>
									</ShipTo>
									<InvoiceReferences>
										<!-- On invoice files not credit type the true ben E Keith invoice number is 8 digits and is shown in the first 8 characters of the invoice number field 
										Please use the 8 digit number when referencing invoice number to the customer because that’s what’s on the hard copy.  
										The credits should be used in the full size of the invoice number because it uses the same 8 digit invoice number so we needed it to be unique.   
										example credit number: 04551824-C-201302051 example invoice number: 04597847. REMOVE: -I-20130201 -->
										<xsl:element name="InvoiceReference"><xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceReference,1,8)"/></xsl:element>
										<xsl:element name="InvoiceDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/></xsl:element>
										<xsl:element name="TaxPointDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/></xsl:element>
									</InvoiceReferences>
									<CreditNoteReferences>
										<xsl:element name="CreditNoteReference"><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:element>
										<xsl:element name="CreditNoteDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/></xsl:element>
										<xsl:element name="TaxPointDate"><xsl:value-of select="InvoiceHeader/InvoiceReferences/TaxPointDate"/></xsl:element>
									</CreditNoteReferences>									
								</CreditNoteHeader>
								<CreditNoteDetail>
									<!-- LINE DETAIL -->
									<xsl:for-each select="InvoiceDetail/InvoiceLine">
										<CreditNoteLine>
											<PurchaseOrderReferences>
												<xsl:element name="PurchaseOrderDate"><xsl:value-of select="PurchaseOrderDate"/></xsl:element>
												<TradeAgreement><xsl:element name="ContractReference"><xsl:value-of select="ContractReference"/></xsl:element></TradeAgreement>
											</PurchaseOrderReferences>
											<ProductID>
												<xsl:element name="GTIN"><xsl:value-of select="GTIN"/></xsl:element>
												<xsl:element name="SuppliersProductCode"><xsl:value-of select="SuppliersProductCode"/></xsl:element>
											</ProductID>
											<xsl:element name="ProductDescription"><xsl:value-of select="ProductDescription"/></xsl:element>
											<xsl:element name="OrderedQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="OrderedQuantity"/>
											</xsl:element>
											<xsl:element name="DeliveredQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="DeliveredQuantity"/>
											</xsl:element>
											<xsl:element name="InvoicedQuantity">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
												<xsl:value-of select="InvoicedQuantity"/>
											</xsl:element>
											<xsl:element name="UnitValueExclVAT"><xsl:value-of select="UnitValueExclVAT"/></xsl:element>
										</CreditNoteLine>
									</xsl:for-each>
									<!-- LINE DETAIL: fees and surcharges -->
									<xsl:for-each select="DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !='']">
										<CreditNoteLine>
											<ProductID>
												<SuppliersProductCode><xsl:value-of select="concat(DeliveryNoteReference,'-',DeliveryNoteDate)"/></SuppliersProductCode>
											</ProductID>
											<ProductDescription>
												<xsl:choose>
													<xsl:when test="DeliveryNoteDate = 'FSUR'">Fuel Surcharge</xsl:when>
													<xsl:when test="DeliveryNoteDate = 'DLVF'">Delivery Fee</xsl:when>
												</xsl:choose>
											</ProductDescription>
											<UnitValueExclVAT><xsl:value-of select="DespatchDate"/></UnitValueExclVAT>
										</CreditNoteLine>
									</xsl:for-each>
								</CreditNoteDetail>		
								<!-- Credit Note Trailer -->
								<CreditNoteTrailer>
									<xsl:element name="NumberOfLines"><xsl:value-of select="InvoiceTrailer/NumberOfLines"/></xsl:element>
									<xsl:element name="NumberOfItems"><xsl:value-of select="InvoiceTrailer/NumberOfItems"/></xsl:element>
									<xsl:element name="DocumentTotalExclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/></xsl:element>
									<xsl:element name="VATAmount"><xsl:value-of select="InvoiceTrailer/VATAmount"/></xsl:element>
									<xsl:element name="DocumentTotalInclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/></xsl:element>
								</CreditNoteTrailer>				
							</CreditNote>
						</BatchDocument>
					</BatchDocuments>
				</Batch>
			</xsl:for-each>
			
		</BatchRoot>
		
	</xsl:template>
	
</xsl:stylesheet>
