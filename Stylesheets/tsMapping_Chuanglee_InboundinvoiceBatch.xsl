<?xml version="1.0" encoding="UTF-8"?>
<!-- 
'******************************************************************************************
' Overview
'		
Generic inbound flat file for Chuanglee (Orchid)
' 
' © Alternative Business Solutions Ltd., 2000,2001,2002,2003.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name            | Description of modification
'******************************************************************************************
' 16/07/2007 | Moty Dimant     | FB: - Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>

			<Invoice>
				<TradeSimpleHeader>
					<SendersCodeForRecipient><xsl:value-of select="enter xpath"/></SendersCodeForRecipient>
					<SendersBranchReference><xsl:value-of select="enter xpath"/></SendersBranchReference>
					<SendersName><xsl:value-of select="enter xpath"/></SendersName>
					<SendersAddress>
						<AddressLine1><xsl:value-of select="enter xpath"/></AddressLine1>
						<AddressLine2><xsl:value-of select="enter xpath"/></AddressLine2>
						<AddressLine3><xsl:value-of select="enter xpath"/></AddressLine3>
						<AddressLine4><xsl:value-of select="enter xpath"/></AddressLine4>
						<PostCode>String</PostCode>
					</SendersAddress>
					<RecipientsCodeForSender><xsl:value-of select="enter xpath"/></RecipientsCodeForSender>
					<RecipientsBranchReference><xsl:value-of select="enter xpath"/></RecipientsBranchReference>
					<RecipientsName><xsl:value-of select="enter xpath"/></RecipientsName>
					<RecipientsAddress>
						<AddressLine1><xsl:value-of select="enter xpath"/></AddressLine1>
						<AddressLine2><xsl:value-of select="enter xpath"/></AddressLine2>
						<AddressLine3><xsl:value-of select="enter xpath"/></AddressLine3>
						<AddressLine4><xsl:value-of select="enter xpath"/></AddressLine4>
						<PostCode>String</PostCode>
					</RecipientsAddress>
					<TestFlag>1</TestFlag>
				</TradeSimpleHeader>
				<InvoiceHeader>
					<MHDSegment>
						<MHDHeader><xsl:value-of select="enter xpath"/></MHDHeader>
						<MHDVersion><xsl:value-of select="enter xpath"/></MHDVersion>
					</MHDSegment>
					<DocumentStatus>Original</DocumentStatus>
					<BatchInformation>
						<FileGenerationNo><xsl:value-of select="enter xpath"/></FileGenerationNo>
						<FileVersionNo><xsl:value-of select="enter xpath"/></FileVersionNo>
						<FileCreationDate>1967-08-13</FileCreationDate>
						<SendersTransmissionReference><xsl:value-of select="enter xpath"/></SendersTransmissionReference>
						<SendersTransmissionDate>2001-12-17T09:30:47-05:00</SendersTransmissionDate>
					</BatchInformation>
					<Buyer>
						<BuyersLocationID>
							<GLN><xsl:value-of select="enter xpath"/></GLN>
							<BuyersCode><xsl:value-of select="enter xpath"/></BuyersCode>
							<SuppliersCode><xsl:value-of select="enter xpath"/></SuppliersCode>
						</BuyersLocationID>
						<BuyersName><xsl:value-of select="enter xpath"/></BuyersName>
						<BuyersAddress>
							<AddressLine1><xsl:value-of select="enter xpath"/></AddressLine1>
							<AddressLine2><xsl:value-of select="enter xpath"/></AddressLine2>
							<AddressLine3><xsl:value-of select="enter xpath"/></AddressLine3>
							<AddressLine4><xsl:value-of select="enter xpath"/></AddressLine4>
							<PostCode>String</PostCode>
						</BuyersAddress>
					</Buyer>
					<Supplier>
						<SuppliersLocationID>
							<GLN><xsl:value-of select="enter xpath"/></GLN>
							<BuyersCode><xsl:value-of select="enter xpath"/></BuyersCode>
							<SuppliersCode><xsl:value-of select="enter xpath"/></SuppliersCode>
						</SuppliersLocationID>
						<SuppliersName><xsl:value-of select="enter xpath"/></SuppliersName>
						<SuppliersAddress>
							<AddressLine1><xsl:value-of select="enter xpath"/></AddressLine1>
							<AddressLine2><xsl:value-of select="enter xpath"/></AddressLine2>
							<AddressLine3><xsl:value-of select="enter xpath"/></AddressLine3>
							<AddressLine4><xsl:value-of select="enter xpath"/></AddressLine4>
							<PostCode>String</PostCode>
						</SuppliersAddress>
					</Supplier>
					<ShipTo>
						<ShipToLocationID>
							<GLN><xsl:value-of select="enter xpath"/></GLN>
							<BuyersCode><xsl:value-of select="enter xpath"/></BuyersCode>
							<SuppliersCode><xsl:value-of select="enter xpath"/></SuppliersCode>
						</ShipToLocationID>
						<ShipToName><xsl:value-of select="enter xpath"/></ShipToName>
						<ShipToAddress>
							<AddressLine1><xsl:value-of select="enter xpath"/></AddressLine1>
							<AddressLine2><xsl:value-of select="enter xpath"/></AddressLine2>
							<AddressLine3><xsl:value-of select="enter xpath"/></AddressLine3>
							<AddressLine4><xsl:value-of select="enter xpath"/></AddressLine4>
							<PostCode>String</PostCode>
						</ShipToAddress>
						<ContactName><xsl:value-of select="enter xpath"/></ContactName>
					</ShipTo>
					<InvoiceReferences>
						<InvoiceReference><xsl:value-of select="enter xpath"/></InvoiceReference>
						<InvoiceDate>1967-08-13</InvoiceDate>
						<TaxPointDate>1967-08-13</TaxPointDate>
						<VATRegNo><xsl:value-of select="enter xpath"/></VATRegNo>
						<InvoiceMatchingDetails>
							<MatchingStatus>Passed</MatchingStatus>
							<MatchingDate>1967-08-13</MatchingDate>
							<MatchingTime>14:20:00-05:00</MatchingTime>
							<GoodsReceivedNoteReference><xsl:value-of select="enter xpath"/></GoodsReceivedNoteReference>
							<GoodsReceivedNoteDate>1967-08-13</GoodsReceivedNoteDate>
							<DebitNoteReference><xsl:value-of select="enter xpath"/></DebitNoteReference>
							<DebitNoteDate>1967-08-13</DebitNoteDate>
							<CreditNoteReference><xsl:value-of select="enter xpath"/></CreditNoteReference>
							<CreditNoteDate>1967-08-13</CreditNoteDate>
						</InvoiceMatchingDetails>
					</InvoiceReferences>
					<Currency><xsl:value-of select="enter xpath"/></Currency>
					<SequenceNumber>2</SequenceNumber>
					<HeaderExtraData>
						<CodaPLAccount1><xsl:value-of select="enter xpath"/></CodaPLAccount1>
						<CodaPLAccount2><xsl:value-of select="enter xpath"/></CodaPLAccount2>
						<CodaVATNominalCode><xsl:value-of select="enter xpath"/></CodaVATNominalCode>
						<CodaCompanyCode><xsl:value-of select="enter xpath"/></CodaCompanyCode>
						<ClarityCompanyCode><xsl:value-of select="enter xpath"/></ClarityCompanyCode>
						<FinancialPeriod><xsl:value-of select="enter xpath"/></FinancialPeriod>
						<CodaBatchID><xsl:value-of select="enter xpath"/></CodaBatchID>
						<IsAuthorised>1</IsAuthorised>
						<IgnoreInvalidLineValues>1</IgnoreInvalidLineValues>
						<DepartmentCode><xsl:value-of select="enter xpath"/></DepartmentCode>
						<AccountingCode><xsl:value-of select="enter xpath"/></AccountingCode>
						<StockSystemIdentifier><xsl:value-of select="enter xpath"/></StockSystemIdentifier>
						<NominalCode><xsl:value-of select="enter xpath"/></NominalCode>
						<TaxAccount><xsl:value-of select="enter xpath"/></TaxAccount>
						<CompressedAztecOutput><xsl:value-of select="enter xpath"/></CompressedAztecOutput>
						<AutoGenerated><xsl:value-of select="enter xpath"/></AutoGenerated>
						<OrderType><xsl:value-of select="enter xpath"/></OrderType>
						<IsFoodSupplier>1</IsFoodSupplier>
						<CompanyCode><xsl:value-of select="enter xpath"/></CompanyCode>
						<ConceptCode><xsl:value-of select="enter xpath"/></ConceptCode>
						<AreaManagerCode><xsl:value-of select="enter xpath"/></AreaManagerCode>
						<ZoneCode><xsl:value-of select="enter xpath"/></ZoneCode>
					</HeaderExtraData>
				</InvoiceHeader>
				<InvoiceDetail>
					<InvoiceLine>
						<LineNumber>0</LineNumber>
						<PurchaseOrderReferences>
							<PurchaseOrderReference><xsl:value-of select="enter xpath"/></PurchaseOrderReference>
							<PurchaseOrderDate>1967-08-13</PurchaseOrderDate>
							<PurchaseOrderTime>14:20:00-05:00</PurchaseOrderTime>
							<TradeAgreement>
								<ContractReference><xsl:value-of select="enter xpath"/></ContractReference>
								<ContractDate>1967-08-13</ContractDate>
							</TradeAgreement>
							<CustomerPurchaseOrderReference><xsl:value-of select="enter xpath"/></CustomerPurchaseOrderReference>
							<JobNumber><xsl:value-of select="enter xpath"/></JobNumber>
						</PurchaseOrderReferences>
						<PurchaseOrderConfirmationReferences>
							<PurchaseOrderConfirmationReference><xsl:value-of select="enter xpath"/></PurchaseOrderConfirmationReference>
							<PurchaseOrderConfirmationDate>1967-08-13</PurchaseOrderConfirmationDate>
						</PurchaseOrderConfirmationReferences>
						<DeliveryNoteReferences>
							<DeliveryNoteReference><xsl:value-of select="enter xpath"/></DeliveryNoteReference>
							<DeliveryNoteDate>1967-08-13</DeliveryNoteDate>
							<DespatchDate>1967-08-13</DespatchDate>
						</DeliveryNoteReferences>
						<GoodsReceivedNoteReferences>
							<GoodsReceivedNoteReference><xsl:value-of select="enter xpath"/></GoodsReceivedNoteReference>
							<GoodsReceivedNoteDate>1967-08-13</GoodsReceivedNoteDate>
						</GoodsReceivedNoteReferences>
						<ProductID>
							<GTIN><xsl:value-of select="enter xpath"/></GTIN>
							<SuppliersProductCode><xsl:value-of select="enter xpath"/></SuppliersProductCode>
							<BuyersProductCode><xsl:value-of select="enter xpath"/></BuyersProductCode>
						</ProductID>
						<ProductDescription><xsl:value-of select="enter xpath"/></ProductDescription>
						<OrderedQuantity UnitOfMeasure="Text">3.14159</OrderedQuantity>
						<ConfirmedQuantity UnitOfMeasure="Text">3.14159</ConfirmedQuantity>
						<DeliveredQuantity UnitOfMeasure="Text">3.14159</DeliveredQuantity>
						<InvoicedQuantity UnitOfMeasure="Text">3.14159</InvoicedQuantity>
						<PackSize><xsl:value-of select="enter xpath"/></PackSize>
						<UnitValueExclVAT>3.14159</UnitValueExclVAT>
						<LineValueExclVAT>3.14159</LineValueExclVAT>
						<LineDiscountRate><xsl:value-of select="enter xpath"/></LineDiscountRate>
						<LineDiscountValue><xsl:value-of select="enter xpath"/></LineDiscountValue>
						<VATCode>S</VATCode>
						<VATRate><xsl:value-of select="enter xpath"/></VATRate>
						<NetPriceFlag>1</NetPriceFlag>
						<Measure>
							<UnitsInPack><xsl:value-of select="enter xpath"/></UnitsInPack>
							<OrderingMeasure><xsl:value-of select="enter xpath"/></OrderingMeasure>
							<MeasureIndicator><xsl:value-of select="enter xpath"/></MeasureIndicator>
							<TotalMeasure><xsl:value-of select="enter xpath"/></TotalMeasure>
							<TotalMeasureIndicator><xsl:value-of select="enter xpath"/></TotalMeasureIndicator>
						</Measure>
						<LineExtraData>
							<ProductGroup><xsl:value-of select="enter xpath"/></ProductGroup>
							<OriginalProductCode><xsl:value-of select="enter xpath"/></OriginalProductCode>
							<SuppliersOriginalVATCode><xsl:value-of select="enter xpath"/></SuppliersOriginalVATCode>
							<CodaVATCode><xsl:value-of select="enter xpath"/></CodaVATCode>
							<CodaLedgerCode><xsl:value-of select="enter xpath"/></CodaLedgerCode>
							<IsStockProduct>1</IsStockProduct>
							<StandardPriceUnitCode><xsl:value-of select="enter xpath"/></StandardPriceUnitCode>
							<StandardDeliveryUnitCost><xsl:value-of select="enter xpath"/></StandardDeliveryUnitCost>
							<ProductDescription2><xsl:value-of select="enter xpath"/></ProductDescription2>
							<CustomersConceptProductCode><xsl:value-of select="enter xpath"/></CustomersConceptProductCode>
							<AccountCode><xsl:value-of select="enter xpath"/></AccountCode>
							<CataloguePrice>3.14159</CataloguePrice>
							<BuyersVATCode><xsl:value-of select="enter xpath"/></BuyersVATCode>
							<UnallocatedLine>1</UnallocatedLine>
							<PurchaseOrderReference><xsl:value-of select="enter xpath"/></PurchaseOrderReference>
						</LineExtraData>
					</InvoiceLine>
				</InvoiceDetail>
				<InvoiceTrailer>
					<NumberOfLines>2</NumberOfLines>
					<NumberOfItems>3.14159</NumberOfItems>
					<NumberOfDeliveries>0</NumberOfDeliveries>
					<DocumentDiscountRate><xsl:value-of select="enter xpath"/></DocumentDiscountRate>
					<SettlementDiscountRate SettlementDiscountDays="2">3.14159</SettlementDiscountRate>
					<VATSubTotals>
						<VATSubTotal VATCode="Text" VATRate="Text">
							<NumberOfLinesAtRate>2</NumberOfLinesAtRate>
							<NumberOfItemsAtRate>3.14159</NumberOfItemsAtRate>
							<DiscountedLinesTotalExclVATAtRate>3.14159</DiscountedLinesTotalExclVATAtRate>
							<DocumentDiscountAtRate>3.14159</DocumentDiscountAtRate>
							<DocumentTotalExclVATAtRate>3.14159</DocumentTotalExclVATAtRate>
							<SettlementDiscountAtRate>3.14159</SettlementDiscountAtRate>
							<SettlementTotalExclVATAtRate>3.14159</SettlementTotalExclVATAtRate>
							<VATAmountAtRate>3.14159</VATAmountAtRate>
							<DocumentTotalInclVATAtRate>3.14159</DocumentTotalInclVATAtRate>
							<SettlementTotalInclVATAtRate>3.14159</SettlementTotalInclVATAtRate>
							<VATTrailerExtraData>
								<SuppliersOriginalVATCode><xsl:value-of select="enter xpath"/></SuppliersOriginalVATCode>
								<CodaVATCode><xsl:value-of select="enter xpath"/></CodaVATCode>
								<BuyersVATCode><xsl:value-of select="enter xpath"/></BuyersVATCode>
							</VATTrailerExtraData>
						</VATSubTotal>
					</VATSubTotals>
					<DiscountedLinesTotalExclVAT>3.14159</DiscountedLinesTotalExclVAT>
					<DocumentDiscount>3.14159</DocumentDiscount>
					<DocumentTotalExclVAT>3.14159</DocumentTotalExclVAT>
					<SettlementDiscount>3.14159</SettlementDiscount>
					<SettlementTotalExclVAT>3.14159</SettlementTotalExclVAT>
					<VATAmount>3.14159</VATAmount>
					<DocumentTotalInclVAT>3.14159</DocumentTotalInclVAT>
					<SettlementTotalInclVAT>3.14159</SettlementTotalInclVAT>
					<TrailerExtraData/>
				</InvoiceTrailer>
			</Invoice>

