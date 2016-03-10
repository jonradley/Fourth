<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Ben E Keith Parent generalised mappers set - invoices and credits inbound.
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 28/04/2015	| J. Miguel	| FB10243 - Created copying and refactoring BEK original.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl">
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- copy template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- format dates for T|S -->
	<xsl:template match="InvoiceDate | TaxPointDate | PurchaseOrderDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
		</xsl:element>
	</xsl:template>	
	
	<!-- convert UoM codes MUST BE DONE BEFORE PRODUCT CODE LOGIC which depends on T|S UoMs -->
	<xsl:template match="@UnitOfMeasure">
		<xsl:attribute name="UnitOfMeasure">
			<xsl:choose>
				<xsl:when test=". = 'CA'"><xsl:text>CS</xsl:text></xsl:when>
				<xsl:when test=". = 'EA'"><xsl:text>EA</xsl:text></xsl:when>
				<xsl:when test=". = 'LB'"><xsl:text>PND</xsl:text></xsl:when>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
		
	<!-- format values for T|S -->
	<xsl:template match="OrderedQuantity | DeliveredQuantity |  UnitValueExclVAT | DocumentTotalExclVAT | VATAmount">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="format-number(.,'0.00')"/>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="DocumentTotalInclVAT">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="translate(format-number(.,'0.00'), '-', '')"/>
		</xsl:element>
	</xsl:template>
	<!-- format numbers for T|S -->
	<xsl:template match="NumberOfLines | NumberOfItems | SuppliersProductCode">
		<xsl:element name="{name()}">
			<xsl:value-of select="format-number(.,'#')"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="VATRate">
		<xsl:variable name="vatRate" select="(100 div LineValueExclVAT) * VATRate"/>
		<VATRate>
			<xsl:choose>
				<xsl:when test="$vatRate &gt; 0">
					<xsl:value-of select="format-number($vatRate,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
		</VATRate>
	</xsl:template>
	<!-- On invoice files not credit type the true ben E Keith invoice number is 8 digits and is shown in the first 8 characters of the invoice number field 
	Please use the 8 digit number when referencing invoice number to the customer because that’s what’s on the hard copy.  
	The credits should be used in the full size of the invoice number because it uses the same 8 digit invoice number so we needed it to be unique.   
	example credit number: 04551824-C-201302051 example invoice number: 04597847. REMOVE: -I-20130201 -->
	<xsl:template match="InvoiceReference">
		<InvoiceReference>
			<xsl:value-of select="substring(., 1, 8)"/>
		</InvoiceReference>	
	</xsl:template>

	<xsl:template match="BuyersAddress | ShipToAddress">
		<xsl:element name="{name()}">
			<AddressLine1>
				<xsl:choose>
					<xsl:when test="AddressLine1 != ''"><xsl:value-of select="AddressLine1"/></xsl:when>
					<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
				</xsl:choose>
			</AddressLine1>
			<AddressLine2>
				<xsl:choose>
					<xsl:when test="AddressLine2 != ''"><xsl:value-of select="AddressLine2"/></xsl:when>
					<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
				</xsl:choose></AddressLine2>
			<AddressLine3>
				<xsl:choose>
					<xsl:when test="AddressLine3 != ''"><xsl:value-of select="AddressLine3"/></xsl:when>
					<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
				</xsl:choose>
			</AddressLine3>
			<AddressLine4>
				<xsl:choose>
					<xsl:when test="AddressLine4 != ''"><xsl:value-of select="AddressLine4"/></xsl:when>
					<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
				</xsl:choose>
			</AddressLine4>
			<PostCode>
				<xsl:choose>
					<xsl:when test="PostCode != ''"><xsl:value-of select="PostCode"/></xsl:when>
					<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
				</xsl:choose>
			</PostCode>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ContactName"/>

	<xsl:template match="NumberOfLines[. &gt; 0]">
		<NumberOfLines>
			<xsl:value-of select=". + count(../../InvoiceDetail/InvoiceLine/DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !=''])"/>
		</NumberOfLines>
	</xsl:template>

	<xsl:template match="NumberOfItems">
		<NumberOfItems>
			<xsl:value-of select="translate(sum(../../InvoiceDetail/InvoiceLine/InvoicedQuantity[../Measure/MeasureIndicator != 'Y']), '-', '') +
			                      translate(sum(../../InvoiceDetail/InvoiceLine/Measure/TotalMeasure[../MeasureIndicator = 'Y']), '-', '')
		                      + count(../../InvoiceDetail/InvoiceLine/DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !=''])"/>
		</NumberOfItems>
	</xsl:template>

	<xsl:template match="Batch">
		<BatchRoot>
			<xsl:if test="count(BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'INVO']) &gt; 0">
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>INV</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- Generate INVOICES -->
							<xsl:for-each select="BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'INVO']">
								<BatchDocument>
									<Invoice>
										<xsl:apply-templates select="TradeSimpleHeader | InvoiceHeader"/>

										<InvoiceDetail>
											<!-- INVOICE LINE DETAIL -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
											
												<InvoiceLine>
													<xsl:apply-templates select="../InvoiceLine[1]/PurchaseOrderReferences"/>
													<xsl:apply-templates select="ProductID | ProductDescription | OrderedQuantity | DeliveredQuantity"/>
													<InvoicedQuantity>
														<xsl:apply-templates select="InvoicedQuantity/@UnitOfMeasure"/>
														<!-- handle catchweight products -->
														<xsl:choose>
															<xsl:when test="Measure/MeasureIndicator = 'Y'"><xsl:value-of select="format-number(Measure/TotalMeasure, '0.00')"/></xsl:when>
															<xsl:otherwise><xsl:value-of select="format-number(InvoicedQuantity, '0.00')"/></xsl:otherwise>
														</xsl:choose>
													</InvoicedQuantity>
													<xsl:apply-templates select="UnitValueExclVAT"/>
													<!-- vat code always exempt -->
													<VATCode>E</VATCode>
													<xsl:apply-templates select="VATRate"/>
												</InvoiceLine>
											</xsl:for-each>
											<!-- LINE DETAIL: fees and surcharges -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !='']">
												<InvoiceLine>
													<xsl:call-template name="createFeeLine"/>
												</InvoiceLine>
											</xsl:for-each>
										</InvoiceDetail>
										<!-- Invoice Trailer -->
										<InvoiceTrailer>
											<xsl:apply-templates select="InvoiceTrailer/*"/>
										</InvoiceTrailer>
									</Invoice>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:if>
			<xsl:if test="count(BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'CRED']) &gt; 0">
				<Document>
					<xsl:attribute name="TypePrefix"><xsl:text>CRN</xsl:text></xsl:attribute>
					<Batch>
						<BatchDocuments>
							<!-- Generate CREDITS -->
							<xsl:for-each select="BatchDocuments/BatchDocument/Invoice[InvoiceHeader/ShipTo/ContactName = 'CRED']">
								<BatchDocument>
									<CreditNote>
										<xsl:apply-templates select="TradeSimpleHeader"/>
										<CreditNoteHeader>
											<xsl:apply-templates select="InvoiceHeader/*"/>
											<CreditNoteReferences>
												<CreditNoteReference><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/></CreditNoteReference>
												<CreditNoteDate><xsl:value-of select="concat(substring(InvoiceHeader/InvoiceReferences/InvoiceDate,1,4),'-',substring(InvoiceHeader/InvoiceReferences/InvoiceDate,5,2),'-',substring(InvoiceHeader/InvoiceReferences/InvoiceDate,7,2))"/></CreditNoteDate>
												<xsl:apply-templates select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
											</CreditNoteReferences>
										</CreditNoteHeader>								
										<CreditNoteDetail>
											<!-- CREDIT LINE DETAIL -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<CreditNoteLine>
													<xsl:apply-templates select="../InvoiceLine[1]/PurchaseOrderReferences"/>
													<xsl:apply-templates select="ProductID | ProductDescription | OrderedQuantity | DeliveredQuantity "/>
													<CreditedQuantity>
														<xsl:apply-templates select="InvoicedQuantity/@UnitOfMeasure"/>
														<!-- handle catchweight products -->
														<xsl:choose>
															<xsl:when test="Measure/MeasureIndicator = 'Y'"><xsl:value-of select="translate(format-number(Measure/TotalMeasure, '0.00'),'-','')"/></xsl:when>
															<xsl:otherwise><xsl:value-of select="translate(format-number(InvoicedQuantity, '0.00'),'-','')"/></xsl:otherwise>
														</xsl:choose>
													</CreditedQuantity>
													<xsl:apply-templates select="UnitValueExclVAT"/>
													<!-- vat code and rate always exempt -->
													<VATCode>E</VATCode>
													<!-- work out the rate -->
													<xsl:apply-templates select="VATRate"/>
												</CreditNoteLine>
											</xsl:for-each>
											<!-- LINE DETAIL: fees and surcharges -->
											<xsl:for-each select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences[DeliveryNoteReference != '' and DeliveryNoteDate != '' and DespatchDate !='']">
												<CreditNoteLine>
													<xsl:call-template name="createFeeLine"/>>
												</CreditNoteLine>
											</xsl:for-each>
										</CreditNoteDetail>		
										<!-- Credit Note Trailer -->
										<CreditNoteTrailer>
											<xsl:apply-templates select="InvoiceTrailer/*"/>
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
	
	<xsl:template name="createFeeLine">
		<ProductID>
			<SuppliersProductCode><xsl:value-of select="concat(DeliveryNoteReference,'-',DeliveryNoteDate)"/></SuppliersProductCode>
		</ProductID>
		<ProductDescription>
			<xsl:value-of select="../GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
		</ProductDescription>
		<InvoicedQuantity>1</InvoicedQuantity>
		<UnitValueExclVAT><xsl:value-of select="format-number(DespatchDate, '0.00')"/></UnitValueExclVAT>
		<LineValueExclVAT><xsl:value-of select="format-number(DespatchDate, '0.00')"/></LineValueExclVAT>
		<!-- vat code always exempt -->
		<VATCode>E</VATCode>
		<VATRate>0.00</VATRate>
	</xsl:template>

</xsl:stylesheet>
