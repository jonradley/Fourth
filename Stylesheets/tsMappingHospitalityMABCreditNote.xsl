<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                              xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
                              xmlns:eanucc="urn:ean.ucc:2" 
                              xmlns:pay="urn:ean.ucc:pay:2" 
                              exclude-result-prefixes="fo xsl">
	<xsl:template match="CreditNote">
	
		<sh:StandardBusinessDocument>
			<sh:StandardBusinessDocumentHeader>
				<sh:HeaderVersion>2.2</sh:HeaderVersion>
				<sh:Sender>
					<sh:Identifier>
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Sender>
				<sh:Receiver>
					<sh:Identifier Authority="EAN.UCC">
						<xsl:attribute name="Authority">EAN.UCC</xsl:attribute>
						<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
					</sh:Identifier>
				</sh:Receiver>
				<sh:DocumentIdentification>
					<sh:Standard>EAN.UCC</sh:Standard>
					<sh:TypeVersion>2.0.2</sh:TypeVersion>
					<sh:InstanceIdentifier>
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
					</sh:InstanceIdentifier>
					<sh:Type>Invoice</sh:Type>
					<sh:MultipleType>false</sh:MultipleType>
					<sh:CreationDateAndTime>
						<xsl:value-of select="concat(CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'T00:00:00')"/>
					</sh:CreationDateAndTime>
				</sh:DocumentIdentification>
			</sh:StandardBusinessDocumentHeader>
			<eanucc:message>
				<entityIdentification>
					<uniqueCreatorIdentification>
						<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
					</uniqueCreatorIdentification>
					<contentOwner>
						<gln>
							<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
						</gln>
					</contentOwner>
				</entityIdentification>
				<eanucc:transaction>
					<entityIdentification>
						<uniqueCreatorIdentification>
							<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
						</uniqueCreatorIdentification>
						<contentOwner>
							<gln>
								<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
							</gln>
						</contentOwner>
					</entityIdentification>
					<command>
						<eanucc:documentCommand>
							<documentCommandHeader type="ADD">
								<entityIdentification>
									<uniqueCreatorIdentification>
										<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
									</uniqueCreatorIdentification>
									<contentOwner>
										<gln>
											<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
										</gln>
									</contentOwner>
								</entityIdentification>
							</documentCommandHeader>
							<documentCommandOperand>
								<pay:invoice>
									<xsl:attribute name="creationDateTime">
										<xsl:value-of select="concat(CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'T00:00:00')"/>
									</xsl:attribute>
									<xsl:attribute name="documentStatus">ORIGINAL</xsl:attribute>
									<contentVersion>
										<versionIdentification>2.1</versionIdentification>
									</contentVersion>
									<documentStructureVersion>
										<versionIdentification>2.1</versionIdentification>
									</documentStructureVersion>
									<invoiceIdentification>
										<uniqueCreatorIdentification>
											<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
										</uniqueCreatorIdentification>
										<contentOwner>
											<gln>
												<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
											</gln>
										</contentOwner>
									</invoiceIdentification>
									<invoiceCurrency>
										<currencyISOCode>GBP</currencyISOCode>
									</invoiceCurrency>
									<invoiceType>CREDIT_NOTE</invoiceType>
									<countryOfSupplyOfGoods>
										<countryISOCode>GB</countryISOCode>
									</countryOfSupplyOfGoods>
									<shipTo>
										<gln>00000000000000</gln>
										<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode != ''">
											<additionalPartyIdentification>
												<additionalPartyIdentificationValue>
													<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
												</additionalPartyIdentificationValue>
												<additionalPartyIdentificationType>SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
											</additionalPartyIdentification>
										</xsl:if>
										<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode">
											<additionalPartyIdentification>
												<additionalPartyIdentificationValue>
													<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
												</additionalPartyIdentificationValue>
												<additionalPartyIdentificationType>BUYER_ASSIGNED_IDENTIFIER_FOR_A_PARTY</additionalPartyIdentificationType>
											</additionalPartyIdentification>
										</xsl:if>
									</shipTo>
									<buyer>
										<partyIdentification>
											<gln>
												<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
											</gln>
										</partyIdentification>
									</buyer>
									<seller>
										<partyIdentification>
											<gln>
												<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
											</gln>
										</partyIdentification>
										<extension>
											<vat:vATInvoicePartyExtension>
												<vATRegistrationNumber>
													<xsl:value-of select="CreditNoteHeader/InvoiceReferences/VATRegNo"/>
												</vATRegistrationNumber>
											</vat:vATInvoicePartyExtension>
										</extension>
									</seller>
									<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
										<invoiceLineItem>
											<xsl:attribute name="number">
												<xsl:value-of select="LineNumber"/>
											</xsl:attribute>
											<tradeItemIdentification>
												<gtin>
													<xsl:choose>
														<xsl:when test="ProductID/GTIN != ''">
															<xsl:value-of select="ProductID/GTIN"/>
														</xsl:when>
														<xsl:otherwise>00000000000</xsl:otherwise>
													</xsl:choose>
												</gtin>
												<xsl:if test="ProductID/SuppliersProductCode != ''">
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="ProductID/SuppliersProductCode"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>SUPPLIER_ASSIGNED</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</xsl:if>
												<xsl:if test="ProductID/BuyersProductCode != ''">
													<additionalTradeItemIdentification>
														<additionalTradeItemIdentificationValue>
															<xsl:value-of select="ProductID/BuyersProductCode"/>
														</additionalTradeItemIdentificationValue>
														<additionalTradeItemIdentificationType>BUYER_ASSIGNED</additionalTradeItemIdentificationType>
													</additionalTradeItemIdentification>
												</xsl:if>
											</tradeItemIdentification>
											<invoicedQuantity>
												<value>
													<xsl:value-of select="CreditedQuantity"/>
												</value>
											</invoicedQuantity>
											<transferOfOwnershipDate>
												<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
											</transferOfOwnershipDate>
											<amountInclusiveAllowancesCharges>
												<xsl:value-of select="LineValueExclVAT"/>
											</amountInclusiveAllowancesCharges>
											<itemDescription>
												<language>
													<languageISOCode>eng</languageISOCode>
												</language>
												<text>
													<xsl:value-of select="ProductDescription"/>
												</text>
											</itemDescription>
											<itemPriceInclusiveAllowancesCharges>
												<xsl:value-of select="UnitValueExclVAT"/>
											</itemPriceInclusiveAllowancesCharges>
											<xsl:if test="DeliveryNoteReferences/DeliveryNoteDate != '' and DeliveryNoteReferences/DeliveryNoteReference != ''">
												<deliveryNote>
													<referenceDateTime>
														<xsL:value-of select="concat(DeliveryNoteReferences/DeliveryNoteDate,'T00:00:00')"/>
													</referenceDateTime>
													<referenceIdentification>
														<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
													</referenceIdentification>
												</deliveryNote>
											</xsl:if>
											<xsl:if test="PurchaseOrderReferences/PurchaseOrderReference != ''">
												<orderIdentification>
													<documentReference>
														<uniqueCreatorIdentification>
															<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
														</uniqueCreatorIdentification>
														<contentOwner>
															<gln>
																<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
															</gln>
														</contentOwner>
													</documentReference>
												</orderIdentification>
											</xsl:if>
											<invoice>
												<documentReference>
													<uniqueCreatorIdentification>
														<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
													</uniqueCreatorIdentification>
													<contentOwner>
														<gln>
															<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
														</gln>
													</contentOwner>
												</documentReference>
											</invoice>
											<invoiceLineTaxInformation>
												<dutyTaxFeeType>VALUE_ADDED_TAX</dutyTaxFeeType>
												<extension>
													<vat:vATTaxInformationExtension>
														<rate>
															<xsl:value-of select="format-number(VATRate,'0.00')"/>
														</rate>
														<vATCategory>
															<xsl:choose>
																<xsl:when test="VATCode = 'Z'">ZERO_RATED_GOODS</xsl:when>
																<xsl:when test="VATCode = 'S'">STANDARD_RATE</xsl:when>
															</xsl:choose>
														</vATCategory>
													</vat:vATTaxInformationExtension>
												</extension>
											</invoiceLineTaxInformation>
										</invoiceLineItem>
									</xsl:for-each>
									<invoiceTotals>
										<totalInvoiceAmount>
											<xsl:value-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
										</totalInvoiceAmount>
										<totalLineAmountInclusiveAllowancesCharges>
											<xsl:value-of select="CreditNoteTrailer/SettlementTotalExclVAT"/>
										</totalLineAmountInclusiveAllowancesCharges>
										<totalTaxAmount>
											<xsl:value-of select="CreditNoteTrailer/VATAmount"/>
										</totalTaxAmount>
										<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
											<taxSubTotal>
												<dutyTaxFeeType>VALUE_ADDED_TAX</dutyTaxFeeType>
												<taxableAmount>
													<xsl:value-of select="DocumentTotalExclVATAtRate"/>
												</taxableAmount>
												<taxAmount>
													<xsl:value-of select="VATAmountAtRate"/>
												</taxAmount>
												<extension>
													<vat:vATTaxInformationExtension>
														<rate>
															<xsl:value-of select="format-number(@VATRate,'0.00')"/>
														</rate>
														<vATCategory>
															<xsl:choose>
																<xsl:when test="@VATCode = 'Z'">ZERO_RATED_GOODS</xsl:when>
																<xsl:when test="@VATCode = 'S'">STANDARD_RATE</xsl:when>
															</xsl:choose>
														</vATCategory>
													</vat:vATTaxInformationExtension>
												</extension>
											</taxSubTotal>
										</xsl:for-each>
									</invoiceTotals>
								</pay:invoice>
							</documentCommandOperand>
						</eanucc:documentCommand>
					</command>
				</eanucc:transaction>
			</eanucc:message>
		</sh:StandardBusinessDocument>
	</xsl:template>
</xsl:stylesheet>
