<?xml version="1.0" encoding="UTF-8"?>
<!-- 
 Date       		| Name        	| Description of modification
=========================================================================================
 26/09/2011	| M Dimant    | Created. Maps internal invoices to cXML for Glasgow City Council.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				|				|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=========================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com" exclude-result-prefixes="fo jscript msxsl">
	<xsl:template match="Invoice">
		<cXML>
			<xsl:attribute name="payloadID">201106171716.INV.108514@kewill.com</xsl:attribute>
			<xsl:attribute name="timestamp"><xsl:value-of select="jscript:getTimeStamp()"/></xsl:attribute>
			<Header>
				<From>
					<Credential domain="SupplierID">
						<Identity>1001006</Identity>
					</Credential>
				</From>
				<To>
					<Credential domain="GlasgowID">
						<Identity>GCCCXML</Identity>
					</Credential>
				</To>
				<Sender>
					<Credential domain="KewillID">
						<Identity>KewillSys</Identity>
					</Credential>
					<UserAgent>HTTP UserAgent</UserAgent>
				</Sender>
			</Header>
			<Request>
				<InvoiceDetailRequest>
						<InvoiceDetailRequestHeader>
							<xsl:attribute name="invoiceID"><xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:attribute>
							<xsl:attribute name="purpose">standard</xsl:attribute>
							<xsl:attribute name="operation">new</xsl:attribute>
							<xsl:attribute name="invoiceDate"><xsl:value-of select="concat(InvoiceHeader/InvoiceReferences/InvoiceDate,'T00:00:00')"/></xsl:attribute>
							<InvoiceDetailLineIndicator isTaxInLine="yes"/>
							<InvoicePartner>
								<Contact role="soldTo" addressID="GCC">
									<Name xml:lang="en"/>
									<PostalAddress>
										<Street><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></Street>
										<Street><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/></Street>
										<Street><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/></Street>
										<City><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/></City>
										<PostalCode><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/PostCode"/></PostalCode>
										<Country isoCountryCode="GB">UK</Country>
									</PostalAddress>
								</Contact>
							</InvoicePartner>
							<InvoicePartner>
								<Contact>
									<xsl:attribute name="role">remitTo</xsl:attribute>
									<Name>
										<xsl:attribute name="xml:lang">en</xsl:attribute>
										<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
									</Name>
									<PostalAddress>
										<Street><xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/></Street>
										<Street><xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/></Street>
										<Street><xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/></Street>
										<City><xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/></City>
										<PostalCode><xsl:value-of select="InvoiceHeader/Supplier/SuppliersAddress/PostCode"/></PostalCode>
										<Country isoCountryCode="GB">UK</Country>
									</PostalAddress>
								</Contact>
								<IdReference>
									<xsl:attribute name="identifier"><xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/></xsl:attribute>
									<xsl:attribute name="domain">vatID</xsl:attribute>
									<Creator xml:lang="en"/>
									<Description xml:lang="en">Supplier VAT Number</Description>
								</IdReference>
							</InvoicePartner>						
						</InvoiceDetailRequestHeader>
						<InvoiceDetailOrder>
							<InvoiceDetailOrderInfo>
								<OrderReference orderID="1424620" orderDate="2011-06-13T00:00:00+00:00">
									<xsl:attribute name="orderID"><xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:attribute>
									<xsl:attribute name="orderDate"><xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:attribute>			
								</OrderReference>
							</InvoiceDetailOrderInfo>						
							<xsl:for-each select="InvoiceDetail/InvoiceLine">
								<InvoiceDetailItem>
									<xsl:attribute name="invoiceLineNumber"><xsl:value-of select="LineNumber"/></xsl:attribute>
									<xsl:attribute name="quantity"><xsl:value-of select="format-number(InvoicedQuantity,'0.00')"/></xsl:attribute>
									<UnitOfMeasure><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></UnitOfMeasure>
									<UnitPrice>
										<Money currency="GBP">
											<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
										</Money>
									</UnitPrice>
									<InvoiceDetailItemReference lineNumber="1">
										<xsl:attribute name="lineNumber"><xsl:value-of select="LineNumber"/></xsl:attribute>
										<ItemID>
											<SupplierPartID><xsl:value-of select="ProductID/SuppliersProductCode"/></SupplierPartID>
										</ItemID>
										<Description xml:lang="en"><xsl:value-of select="ProductDescription"/></Description>
									</InvoiceDetailItemReference>
									<SubtotalAmount>
										<Money currency="GBP"><xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/></Money>
									</SubtotalAmount>								
									<Tax>
										<Money currency="GBP"><xsl:value-of select="format-number((VATRate div 100)*(LineValueExclVAT),'0.00')"/></Money>
										<Description xml:lang="en">total item tax</Description>
										<TaxDetail purpose="tax" category="VAT">
										<xsl:attribute name="percentageRate"><xsl:value-of select="VATRate"/></xsl:attribute>
											<TaxableAmount>
												<Money currency="GBP"><xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/></Money>
											</TaxableAmount>
											<TaxAmount>
												<Money currency="GBP"><xsl:value-of select="format-number((VATRate div 100)*(LineValueExclVAT),'0.00')"/></Money>
											</TaxAmount>
										</TaxDetail>
									</Tax>
									<GrossAmount>
										<Money currency="GBP"><xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/></Money>
									</GrossAmount>
									<NetAmount>
										<Money currency="GBP"><xsl:value-of select="format-number(LineValueExclVAT+((VATRate div 100)*LineValueExclVAT),'0.00')"/></Money>
									</NetAmount>
									<Extrinsic name="LinePurchaseOrderNumber"><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/></Extrinsic>													</InvoiceDetailItem>							
							</xsl:for-each>							
						</InvoiceDetailOrder>
						<InvoiceDetailSummary>
							<SubtotalAmount>
								<Money currency="GBP"><xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalExclVAT,'0.00')"/></Money>
							</SubtotalAmount>
							<Tax>
								<Money currency="GBP"><xsl:value-of select="format-number(InvoiceTrailer/VATAmount,'0.00')"/></Money>
								<Description xml:lang="en">total tax</Description>
								<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
									<TaxDetail>
										<xsl:attribute name="purpose">tax</xsl:attribute>
										<xsl:attribute name="category">VAT</xsl:attribute>
										<xsl:attribute name="percentageRate"><xsl:value-of select="@VATRate"/></xsl:attribute>
										<TaxableAmount>
											<Money currency="GBP"><xsl:value-of select="format-number(DocumentTotalExclVATAtRate,'0.00')"/></Money>
										</TaxableAmount>
										<TaxAmount>
											<Money currency="GBP"><xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/></Money>
										</TaxAmount>
									</TaxDetail>
								</xsl:for-each>
							</Tax>
							<GrossAmount>
								<Money currency="GBP"><xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/></Money>
							</GrossAmount>
							<NetAmount>
								<Money currency="GBP"><xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/></Money>
							</NetAmount>
							<DueAmount>
								<Money currency="GBP"><xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/></Money>
							</DueAmount>
						</InvoiceDetailSummary>
				</InvoiceDetailRequest>
			</Request>
		</cXML>
	</xsl:template>
	
	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function getTimeStamp() {
			dtTimeStamp = new Date();
			sYear  = dtTimeStamp.getFullYear();
			sMonth = 'x0' + (dtTimeStamp.getMonth() + 1);
			sMonth = sMonth.substr(sMonth.length - 2,2);
			sDate  = 'x0' + dtTimeStamp.getDate();
			sDate  = sDate.substr(sDate.length - 2,2);
			sHour  = 'x0' + dtTimeStamp.getHours();
			sHour  = sHour.substr(sHour.length - 2,2);
			sMin   = 'x0' + dtTimeStamp.getMinutes();
			sMin   = sMin.substr(sMin.length - 2,2);
			sSec   = 'x0' + dtTimeStamp.getSeconds();
			sSec   = sSec.substr(sSec.length - 2,2);
			sTimeStamp = sYear + '-' + sMonth + '-' + sDate + 'T' + sHour + ':' + sMin + ':' + sSec;
			return sTimeStamp;
		}
	]]></msxsl:script>
</xsl:stylesheet>
