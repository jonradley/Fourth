<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<!--Declare Doc Type Variable-->
						<xsl:variable name="DocType">
							<xsl:choose>
								<xsl:when test="Invoice/InvoiceHead/InvoiceType/@Code = 'INV'">Invoice</xsl:when>
								<xsl:when test="Invoice/InvoiceHead/InvoiceType/@Code = 'CRN'">CreditNote</xsl:when>
							</xsl:choose>
						</xsl:variable>
							<xsl:element name="{$DocType}">
							<!--tradesimple Header-->
							<TradeSimpleHeader>
								<!--SendersCodeForRecipient-->
								<SendersCodeForRecipient>
									<xsl:value-of select="//Invoice/Buyer/BuyerReferences/SuppliersCodeForBuyer"/>
								</SendersCodeForRecipient>
							</TradeSimpleHeader>
							<xsl:element name="{concat($DocType,'Header')}">
								<!--Document Status-->
								<DocumentStatus>
									<xsl:text>Original</xsl:text>
								</DocumentStatus>
								<!--Buyer-->
								<xsl:element name="Buyer">
									<xsl:if test="//Invoice/Buyer/Party != ''">
										<!--Buyers Name-->
										<BuyersName>
											<xsl:value-of select="//Invoice/Buyer/Party"/>
										</BuyersName>
									</xsl:if>
									<xsl:if test="//Invoice/Buyer/Address/AddressLine[1] != ''">
										<BuyersAddress>
											<AddressLine1>
												<xsl:value-of select="//Invoice/Buyer/Address/AddressLine[1]"/>
											</AddressLine1>
											<xsl:if test="//Invoice/Buyer/Address/AddressLine[2] != ''">
												<AddressLine2>
													<xsl:value-of select="//Invoice/Buyer/Address/AddressLine[2]"/>
												</AddressLine2>
											</xsl:if>
											<xsl:if test="//Invoice/Supplier/Buyer/AddressLine[3] != ''">
												<AddressLine3>
													<xsl:value-of select="//Invoice/Buyer/Address/AddressLine[3]"/>
												</AddressLine3>
											</xsl:if>
											<xsl:if test="//Invoice/Buyer/Address/AddressLine[4] != ''">
												<AddressLine4>
													<xsl:value-of select="//Invoice/Buyer/Address/AddressLine[4]"/>
												</AddressLine4>
											</xsl:if>
											<xsl:if test="//Invoice/Buyer/Address/PostCode != ''">
												<PostCode>
													<xsl:value-of select="//Invoice/Buyer/Address/PostCode"/>
												</PostCode>
											</xsl:if>
										</BuyersAddress>
									</xsl:if>
								</xsl:element>
								<!--Supplier-->
								<xsl:element name="Supplier">
									<!--Suppliers Location ID-->
									<xsl:element name="SuppliersLocationID">
										<xsl:if test="Invoice/Supplier/SupplierReferences/GLN != ''">
											<GLN>
												<xsl:value-of select="Invoice/Supplier/SupplierReferences/GLN"/>
											</GLN>
										</xsl:if>
										<!--<BuyersCode>
										<xsl:value-of select="//Invoice/Supplier/SupplierReferences/BuyersCodeForSupplier"/>
									</BuyersCode>-->
										<!--<SuppliersCode/>-->
									</xsl:element>
									<!--Suppliers Name-->
									<xsl:element name="SuppliersName">
										<xsl:value-of select="Invoice/Supplier/Party"/>
									</xsl:element>
									<!--Suppliers Address-->
									<xsl:if test="Invoice/Supplier/Address/AddressLine[1] != ''">
										<SuppliersAddress>
											<AddressLine1>
												<xsl:value-of select="Invoice/Supplier/Address/AddressLine[1]"/>
											</AddressLine1>
											<xsl:if test="Invoice/Supplier/Address/AddressLine[2] != ''">
												<AddressLine2>
													<xsl:value-of select="Invoice/Supplier/Address/AddressLine[2]"/>
												</AddressLine2>
											</xsl:if>
											<xsl:if test="Invoice/Supplier/Address/AddressLine[3] != ''">
												<AddressLine3>
													<xsl:value-of select="Invoice/Supplier/Address/AddressLine[3]"/>
												</AddressLine3>
											</xsl:if>
											<xsl:if test="Invoice/Supplier/Address/AddressLine[4] != ''">
												<AddressLine4>
													<xsl:value-of select="Invoice/Supplier/Address/AddressLine[4]"/>
												</AddressLine4>
											</xsl:if>
											<xsl:if test="Invoice/Supplier/Address/PostCode != ''">
												<PostCode>
													<xsl:value-of select="Invoice/Supplier/Address/PostCode"/>
												</PostCode>
											</xsl:if>
										</SuppliersAddress>
									</xsl:if>
								</xsl:element>
								<!--Ship To-->
								<xsl:element name="ShipTo">
									<xsl:if test="//Invoice/Delivery/DeliverTo/Party != ''">
										<xsl:if test="//Invoice/Delivery/DeliverTo/Party != ''">
											<ShipToName>
												<xsl:value-of select="//Invoice/Delivery/DeliverTo/Party"/>
											</ShipToName>
										</xsl:if>
										<xsl:if test="//Invoice/Delivery/DeliverTo/Address/AddressLine[1] != ''">
											<ShipToAddress>
												<AddressLine1>
													<xsl:value-of select="//Invoice/Delivery/DeliverTo/Address/AddressLine[1]"/>
												</AddressLine1>
												<xsl:if test="//Invoice/Delivery/DeliverTo/Address/AddressLine[2] != ''">
													<AddressLine2>
														<xsl:value-of select="//Invoice/Delivery/DeliverTo/Address/AddressLine[2]"/>
													</AddressLine2>
												</xsl:if>
												<xsl:if test="//Invoice/Delivery/DeliverTo/Address/AddressLine[3] != ''">
													<AddressLine3>
														<xsl:value-of select="//Invoice/Delivery/DeliverTo/Address/AddressLine[3]"/>
													</AddressLine3>
												</xsl:if>
												<xsl:if test="//Invoice/Delivery/DeliverTo/Address/AddressLine[4] != ''">
													<AddressLine4>
														<xsl:value-of select="//Invoice/Delivery/DeliverTo/Address/AddressLine[4]"/>
													</AddressLine4>
												</xsl:if>
												<xsl:if test="//Invoice/Delivery/DeliverTo/Address/PostCode != ''">
													<PostCode>
														<xsl:value-of select="//Invoice/Delivery/DeliverTo/Address/PostCode"/>
													</PostCode>
												</xsl:if>
											</ShipToAddress>
										</xsl:if>
									</xsl:if>
								</xsl:element>
								<!--Invoice References-->
								<xsl:element name="{concat($DocType,'References')}">
									<!--Invoice/Credit Reference-->
									<xsl:element name="{concat($DocType,'Reference')}">
										<xsl:value-of select="//Invoice/InvoiceReferences/SuppliersInvoiceNumber"/>
									</xsl:element>
									<!--Invoice/Credit Date-->
									<xsl:element name="{concat($DocType,'Date')}">
										<xsl:value-of select="//Invoice/InvoiceDate"/>
									</xsl:element>
									<!--Tax Point Date-->
									<xsl:element name="TaxPointDate">
										<xsl:value-of select="//Invoice/TaxPointDate"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
							<!-- Invoice Detail -->
							<xsl:element name="{concat($DocType,'Detail')}">
								<!--Invoice Lines-->
								<xsl:for-each select="//Invoice/InvoiceLine">
									<xsl:element name="{concat($DocType,'Line')}">
										<!--Line Number-->
										<xsl:element name="LineNumber">
											<xsl:value-of select="LineNumber"/>
										</xsl:element>
										<!--Purchase Order References-->
										<xsl:if test="//Invoice/InvoiceReferences/BuyersOrderNumber !=''">
											<xsl:element name="PurchaseOrderReferences">
												<!--Purchase Order Reference-->
												<xsl:element name="PurchaseOrderReference">
													<xsl:value-of select="//Invoice/InvoiceReferences/BuyersOrderNumber"/>
												</xsl:element>
												<!--Purchase Order Date-->
												<!--<xsl:element name="PurchaseOrderDate"></xsl:element>-->
											</xsl:element>
										</xsl:if>
										<!--Delivery Note References-->
										<xsl:if test="//Invoice/InvoiceReferences/DeliveryNoteNumber !=''">
											<xsl:element name="DeliveryNoteReferences">
												<!--Delivery Note Reference-->
												<xsl:element name="DeliveryNoteReference">
													<xsl:value-of select="//Invoice/InvoiceReferences/DeliveryNoteNumber"/>
												</xsl:element>
												<!--Delivery Note Date-->
												<!--<xsl:element name="DeliveryNoteDate"></xsl:element>-->
											</xsl:element>
										</xsl:if>
										<!--Product Identifiers-->
										<xsl:element name="ProductID">
											<xsl:if test="Product/BuyersProductCode !=''">
												<xsl:element name="BuyersProductCode">
													<xsl:value-of select="Product/BuyersProductCode"/>
												</xsl:element>
											</xsl:if>
											<xsl:if test="Product/SuppliersProductCode !=''">
												<xsl:element name="SuppliersProductCode">
													<xsl:value-of select="Product/SuppliersProductCode"/>
												</xsl:element>
											</xsl:if>
										</xsl:element>
										<!--ProductDescription-->
										<xsl:element name="ProductDescription">
											<xsl:value-of select="Product/Description"/>
										</xsl:element>
										<!--Invoiced/Credited Quantity-->
										<xsl:choose>
											<xsl:when test="$DocType = 'Invoice'">
												<xsl:element name="InvoicedQuantity">
													<xsl:value-of select="Quantity/Amount"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="$DocType = 'CreditNote'">
												<xsl:element name="CreditedQuantity">
													<xsl:value-of select="Quantity/Amount"/>
												</xsl:element>
											</xsl:when>
										</xsl:choose>
										<!--Pack Size-->
										<!--Unit Value Excl VAT-->
										<xsl:element name="UnitValueExclVAT">
											<xsl:value-of select="Price/UnitPrice"/>
										</xsl:element>
										<!--Line Value Excl VAT-->
										<!--<xsl:element name="LineValueExclVAT">
											<xsl:value-of select="(LineTotal - LineTax/TaxValue)"/>
										</xsl:element>-->
										<!--VAT Code-->
										<xsl:element name="VATCode">
											<xsl:value-of select="vbscript:msTranslateVATCode(LineTax/TaxRate/@Code)"/>
										</xsl:element>
										<!--VAT Rate-->
										<xsl:element name="VATRate">
											<xsl:value-of select="LineTax/TaxRate"/>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
							<!--Invoice Trailer-->
							<xsl:element name="{concat($DocType,'Trailer')}">
								<!--Number of Lines-->
								<xsl:element name="NumberOfLines">
									<xsl:value-of select="//Invoice/InvoiceTotal/NumberOfLines"/>
								</xsl:element>
								<!--Number of Items-->
								<xsl:element name="NumberOfItems">
									<xsl:value-of select="sum(//Invoice/InvoiceLine/Quantity/Amount)"/>
								</xsl:element>
								<!--Document Total Excl VAT-->
								<xsl:element name="DocumentTotalExclVAT">
									<xsl:value-of select="//Invoice/InvoiceTotal/LineValueTotal"/>
								</xsl:element>
								<!--VAT Subtotals-->
								<xsl:element name="VATSubTotals">
									<xsl:for-each select="//Invoice/TaxSubTotal">
										<xsl:element name="VATSubTotal">
											<!--VAT Code-->
											<xsl:attribute name="VATCode">
												<xsl:value-of select="vbscript:msTranslateVATCode(TaxRate/@Code)"/>
											</xsl:attribute>
											<!--VAT Rate-->
											<xsl:attribute name="VATRate">
												<xsl:value-of select="TaxRate"/>
											</xsl:attribute>
											<!--Document Total Excluding VAT at Rate-->
											<xsl:element name="DocumentTotalExclVATAtRate">
												<xsl:value-of select="TotalValueAtRate"/>
											</xsl:element>
											<!-- VAT Amount At Rate-->
											<xsl:element name="VATAmountAtRate">
												<xsl:value-of select="TaxAtRate"/>
											</xsl:element>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<!--VAT Amount-->
								<xsl:element name="VATAmount">
									<xsl:value-of select="//Invoice/InvoiceTotal/TaxTotal"/>
								</xsl:element>
								<!--Document Total Incl VAT-->
								<xsl:element name="DocumentTotalInclVAT">
									<xsl:value-of select="//Invoice/InvoiceTotal/GrossValue"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[
	
			Function msTranslateVATCode(inputValue)
			Dim vsCode
			Dim sNewCode
			
				vsCode = inputValue.item(0).nodeTypedValue
				
				Select Case vsCode
					Case "S"
						sNewCode = "S"
					Case "Z"
						sNewCode = "Z"
					Case "E"
						sNewCode = "E"
					' This is in here temporarily
					Case "1"
						sNewCode = "S"
					Case "A"
						sNewCode = "S"
				End Select
				
				msTranslateVATCode = sNewCode
				
			End Function
	
	]]></msxsl:script>
</xsl:stylesheet>
