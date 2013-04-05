<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Transformations on the XML version of the flat file - create INVs and CRNs
******************************************************************************************
 Module History
******************************************************************************************
 Date			| Name					| Description of modification
******************************************************************************************
 05/03/2013	| Harold Robson		| FB6189 Created module 
******************************************************************************************
 05/04/2013	| Harold Robson		| FB6298 fixes
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl">
	<xsl:include href="tsMappingHospitalityBenEKeithIncludes.xsl"/>
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
	
	<!-- convert UoM codes MUST BE DONE BEFORE PRODUCT CODE LOGIC which depends on T|S UoMs -->
	<xsl:template match="node()[@UnitOfMeasure]">
		<xsl:element name="{name()}">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="./@UnitOfMeasure = 'CA'">CS</xsl:when>
					<xsl:when test="./@UnitOfMeasure = 'EA'">EA</xsl:when>
					<xsl:when test="./@UnitOfMeasure = 'LB'">PND</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="format-number(.,'0.00')"/>
		</xsl:element>
	</xsl:template>
	
	<!-- copy template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- concatenate SendersBranchReference and SendersCodeForRecipient fields to SendersCodeForRecipient-->
	<xsl:template match="SendersCodeForRecipient">
		<SendersCodeForRecipient>
			<xsl:value-of select="concat(../SendersBranchReference,'-',.)"/>
		</SendersCodeForRecipient>
	</xsl:template>	
	
	<!-- format dates for T|S -->
	<xsl:template match="InvoiceDate | TaxPointDate | PurchaseOrderDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
		</xsl:element>
	</xsl:template>	
	
	<!-- format values for T|S -->
	<xsl:template match="OrderedQuantity | DeliveredQuantity | InvoicedQuantity | UnitValueExclVAT | DocumentTotalExclVAT | VATAmount | DocumentTotalInclVAT">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number(.,'0.00')"/>
		</xsl:element>
	</xsl:template>	
	
	<!-- format numbers for T|S -->
	<xsl:template match="NumberOfLines | NumberOfItems">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number(.,'#')"/>
		</xsl:element>
	</xsl:template>	

	<!--=======================================================================================
  Routine		: addressLineTransformation
  Description	: replaces blank address lines with full stops
  Author		: H Robson 6189 13/03/2013
 =======================================================================================-->
	<xsl:template name="addressLineTransformation">
		<xsl:element name="AddressLine1">
			<xsl:choose>
				<xsl:when test="AddressLine1 != ''"><xsl:value-of select="AddressLine1"/></xsl:when>
				<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="AddressLine2">
			<xsl:choose>
				<xsl:when test="AddressLine2 != ''"><xsl:value-of select="AddressLine2"/></xsl:when>
				<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="AddressLine3">
			<xsl:choose>
				<xsl:when test="AddressLine3 != ''"><xsl:value-of select="AddressLine3"/></xsl:when>
				<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="AddressLine4">
			<xsl:choose>
				<xsl:when test="AddressLine4 != ''"><xsl:value-of select="AddressLine4"/></xsl:when>
				<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		<xsl:element name="PostCode">
			<xsl:choose>
				<xsl:when test="PostCode != ''"><xsl:value-of select="PostCode"/></xsl:when>
				<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!--=======================================================================================
  Routine        : mainTransformation
  Description    : creates the output xml as before, except now it is acting on a variable and not directly on the input xml
  Author         : H Robson 6189 11/03/2013
 =======================================================================================-->
	<xsl:template name="mainTransformation">
		<xsl:param name="vobNode"/>

		<BatchRoot>
			<xsl:if test="count($vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'INVO']) &gt; 0">
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- Generate INVOICES -->
							<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'INVO']">
								<BatchDocument>
									<Invoice>
										<TradeSimpleHeader>
											<xsl:element name="SendersCodeForRecipient"><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></xsl:element>
										</TradeSimpleHeader>
										<InvoiceHeader>
											<Buyer>
												<BuyersLocationID>
													<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></xsl:element>
												</BuyersLocationID>
												<xsl:element name="BuyersName"><xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/></xsl:element>
												<xsl:for-each select="InvoiceHeader/Buyer/BuyersAddress">
													<BuyersAddress>
															<xsl:call-template name="addressLineTransformation"/>
													</BuyersAddress>
												</xsl:for-each>
											</Buyer>
											<ShipTo>
												<ShipToLocationID>
													<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></xsl:element>
												</ShipToLocationID>
												<xsl:element name="ShipToName"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></xsl:element>
												<xsl:for-each select="InvoiceHeader/ShipTo/ShipToAddress">
													<ShipToAddress>
															<xsl:call-template name="addressLineTransformation"/>
													</ShipToAddress>
												</xsl:for-each>
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
											<!-- INVOICE LINE DETAIL -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<InvoiceLine>
													<PurchaseOrderReferences>
														<xsl:element name="PurchaseOrderReference"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:element>
														<xsl:element name="PurchaseOrderDate"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:element>
														<TradeAgreement>
															<xsl:element name="ContractReference"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/></xsl:element>
														</TradeAgreement>
													</PurchaseOrderReferences>
													<ProductID>
														<xsl:if test="ProductID/GTIN != ''">
															<xsl:element name="GTIN"><xsl:value-of select="ProductID/GTIN"/></xsl:element>
														</xsl:if>
														<xsl:element name="SuppliersProductCode">
															<xsl:call-template name="CompoundProductCodeOperations">
																<xsl:with-param name="ProductCode" select="ProductID/SuppliersProductCode"/>
																<xsl:with-param name="UoM" select="OrderedQuantity/@UnitOfMeasure"/>
															</xsl:call-template>
														</xsl:element>
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
													<!-- vat code and rate always exempt -->
													<VATCode>E</VATCode>
													<VATRate>0</VATRate>
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
											<xsl:if test="InvoiceTrailer/NumberOfLines &gt; 0">
												<xsl:element name="NumberOfLines">
													<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="InvoiceTrailer/NumberOfItems &gt; 0">
												<xsl:element name="NumberOfItems">
													<xsl:value-of select="InvoiceTrailer/NumberOfItems"/>
												</xsl:element>
											</xsl:if>
											<VATSubTotals>
												<!-- no VAT in the US so we will create a VAT record showing all lines as tax exempt -->
												<VATSubTotal VATCode="E" VATRate="0">
													<NumberOfLinesAtRate><xsl:value-of select="InvoiceTrailer/NumberOfLines"/></NumberOfLinesAtRate>
													<NumberOfItemsAtRate><xsl:value-of select="InvoiceTrailer/NumberOfItems"/></NumberOfItemsAtRate>
													<DocumentTotalExclVATAtRate><xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/></DocumentTotalExclVATAtRate>
													<VATAmountAtRate><xsl:value-of select="number(0)"/></VATAmountAtRate>
													<DocumentTotalInclVATAtRate><xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/></DocumentTotalInclVATAtRate>
												</VATSubTotal>
											</VATSubTotals>
											<xsl:element name="DocumentTotalExclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/></xsl:element>
											<xsl:element name="VATAmount"><xsl:value-of select="InvoiceTrailer/VATAmount"/></xsl:element>
											<xsl:element name="DocumentTotalInclVAT"><xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/></xsl:element>
										</InvoiceTrailer>
									</Invoice>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:if>
			<xsl:if test="count($vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'CRED']) &gt; 0">
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- Generate CREDITS -->
							<xsl:for-each select="$vobNode/Batch/BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'CRED']">
								<BatchDocument>
									<CreditNote>
										<TradeSimpleHeader>
											<xsl:element name="SendersCodeForRecipient"><xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/></xsl:element>
										</TradeSimpleHeader>
										<CreditNoteHeader>
											<Buyer>
												<BuyersLocationID>
													<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode"/></xsl:element>
												</BuyersLocationID>
												<xsl:element name="BuyersName"><xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/></xsl:element>
												<xsl:for-each select="InvoiceHeader/Buyer/BuyersAddress">
													<BuyersAddress>
															<xsl:call-template name="addressLineTransformation"/>
													</BuyersAddress>
												</xsl:for-each>
											</Buyer>
											<ShipTo>
												<ShipToLocationID>
													<xsl:element name="SuppliersCode"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/></xsl:element>
												</ShipToLocationID>
												<xsl:element name="ShipToName"><xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/></xsl:element>
												<xsl:for-each select="InvoiceHeader/ShipTo/ShipToAddress">
													<ShipToAddress>
															<xsl:call-template name="addressLineTransformation"/>
													</ShipToAddress>
												</xsl:for-each>
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
											<!-- CREDIT LINE DETAIL -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<CreditNoteLine>
													<PurchaseOrderReferences>
														<xsl:element name="PurchaseOrderReference"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:element>
														<xsl:element name="PurchaseOrderDate"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:element>
														<TradeAgreement>
															<xsl:element name="ContractReference"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/TradeAgreement/ContractReference"/></xsl:element>
														</TradeAgreement>
													</PurchaseOrderReferences>
													<ProductID>
														<xsl:element name="GTIN"><xsl:value-of select="ProductID/GTIN"/></xsl:element>
														<xsl:element name="SuppliersProductCode">
															<xsl:call-template name="CompoundProductCodeOperations">
																<xsl:with-param name="ProductCode" select="ProductID/SuppliersProductCode"/>
																<xsl:with-param name="UoM" select="OrderedQuantity/@UnitOfMeasure"/>
															</xsl:call-template>
														</xsl:element>
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
													<xsl:element name="CreditedQuantity">
														<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
														<xsl:value-of select="translate(InvoicedQuantity,'-','')"/>
													</xsl:element>
													<xsl:element name="UnitValueExclVAT"><xsl:value-of select="UnitValueExclVAT"/></xsl:element>
													<!-- vat code and rate always exempt -->
													<VATCode>E</VATCode>
													<VATRate>0</VATRate>
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
													<!-- vat code and rate always exempt -->
													<VATCode>E</VATCode>
													<VATRate>0</VATRate>
												</CreditNoteLine>
											</xsl:for-each>
										</CreditNoteDetail>		
										<!-- Credit Note Trailer -->
										<CreditNoteTrailer>
											<xsl:if test="InvoiceTrailer/NumberOfLines &gt; 0">
												<xsl:element name="NumberOfLines">
													<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
												</xsl:element>
											</xsl:if>
											<xsl:element name="NumberOfItems">
												<xsl:value-of select="sum(InvoiceDetail/InvoiceLine/OrderedQuantity)"/>
											</xsl:element>
											<xsl:element name="DocumentTotalExclVAT"><xsl:value-of select="translate(InvoiceTrailer/DocumentTotalExclVAT,'-','')"/></xsl:element>
											<xsl:element name="VATAmount"><xsl:value-of select="InvoiceTrailer/VATAmount"/></xsl:element>
											<xsl:element name="DocumentTotalInclVAT"><xsl:value-of select="translate(InvoiceTrailer/DocumentTotalInclVAT,'-','')"/></xsl:element>
										</CreditNoteTrailer>				
									</CreditNote>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:if>
		</BatchRoot>	
	</xsl:template>
</xsl:stylesheet>
