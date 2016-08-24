<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
Overview

Maps internal invoices, credits and debits to make a copy of themselves for FnB to store in an archive.
Done like this (rather than just routing a copy straight through) so that any new fields added to any of these documents
will NOT automatically be added to this document.

 © Fourth Hospitality 2011
******************************************************************************************
 Module History
******************************************************************************************
 Date		| Name				| Description of modification
******************************************************************************************
25/03/2011 	| Graham Neicho 	| Created module. FB4292
******************************************************************************************
13/10/2011 	| Sandeep Sehgal	| 4928. Set output encoding as UTF-8
******************************************************************************************
16/04/2012	| Andrew Barber	| 5417: Renamed Aramark map to become generic map.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl">
<xsl:output encoding="UTF-8"/>
	<xsl:template match="/Invoice | /CreditNote | /DebitNote">
		<xsl:variable name="DocumentType">
			<xsl:value-of select="local-name(.)"/>
		</xsl:variable>
		<xsl:element name="{$DocumentType}">
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</SendersCodeForRecipient>
				<xsl:if test="TradeSimpleHeader/SendersBranchReference">
					<SendersBranchReference>
						<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
					</SendersBranchReference>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/SendersName">
					<SendersName>
						<xsl:value-of select="TradeSimpleHeader/SendersName"/>
					</SendersName>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/SendersAddress">
					<SendersAddress>
						<AddressLine1>
							<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine2">
							<AddressLine2>
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine3">
							<AddressLine3>
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/AddressLine4">
							<AddressLine4>
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
							</AddressLine4>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/SendersAddress/PostCode">
							<PostCode>
								<xsl:value-of select="TradeSimpleHeader/SendersAddress/PostCode"/>
							</PostCode>
						</xsl:if>
					</SendersAddress>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/RecipientsCodeForSender">
					<RecipientsCodeForSender>
						<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
					</RecipientsCodeForSender>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/RecipientsBranchReference">
					<RecipientsBranchReference>
						<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
					</RecipientsBranchReference>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/RecipientsName">
					<RecipientsName>
						<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
					</RecipientsName>
				</xsl:if>
				<xsl:if test="TradeSimpleHeader/RecipientsAddress">
					<RecipientsAddress>
						<AddressLine1>
							<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
						</AddressLine1>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine2">
							<AddressLine2>
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
							</AddressLine2>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine3">
							<AddressLine3>
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
							</AddressLine3>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/AddressLine4">
							<AddressLine4>
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
							</AddressLine4>
						</xsl:if>
						<xsl:if test="TradeSimpleHeader/RecipientsAddress/PostCode">
							<PostCode>
								<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
							</PostCode>
						</xsl:if>
					</RecipientsAddress>
				</xsl:if>
				<TestFlag>
					<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
				</TestFlag>
			</TradeSimpleHeader>
			<xsl:for-each select="InvoiceHeader | CreditNoteHeader | DebitNoteHeader">
				<xsl:element name="{$DocumentType}Header">
					<xsl:if test="MHDSegment">
						<MHDSegment>
							<MHDHeader>
								<xsl:value-of select="MHDSegment/MHDHeader"/>
							</MHDHeader>
							<MHDVersion>
								<xsl:value-of select="MHDSegment/MHDVersion"/>
							</MHDVersion>
						</MHDSegment>
					</xsl:if>
					<DocumentStatus>
						<xsl:value-of select="DocumentStatus"/>
					</DocumentStatus>
					<xsl:if test="BatchInformation">
						<BatchInformation>
							<xsl:if test="BatchInformation/FileGenerationNo">
								<FileGenerationNo>
									<xsl:value-of select="BatchInformation/FileGenerationNo"/>
								</FileGenerationNo>
							</xsl:if>
							<xsl:if test="BatchInformation/FileVersionNo">
								<FileVersionNo>
									<xsl:value-of select="BatchInformation/FileVersionNo"/>
								</FileVersionNo>
							</xsl:if>
							<xsl:if test="BatchInformation/FileCreationDate">
								<FileCreationDate>
									<xsl:value-of select="BatchInformation/FileCreationDate"/>
								</FileCreationDate>
							</xsl:if>
							<xsl:if test="BatchInformation/SendersTransmissionReference">
								<SendersTransmissionReference>
									<xsl:value-of select="BatchInformation/SendersTransmissionReference"/>
								</SendersTransmissionReference>
							</xsl:if>
							<xsl:if test="BatchInformation/SendersTransmissionDate">
								<SendersTransmissionDate>
									<xsl:value-of select="BatchInformation/SendersTransmissionDate"/>
								</SendersTransmissionDate>
							</xsl:if>
						</BatchInformation>
					</xsl:if>
					<Buyer>
						<BuyersLocationID>
							<GLN>
								<xsl:value-of select="Buyer/BuyersLocationID/GLN"/>
							</GLN>
							<xsl:if test="Buyer/BuyersLocationID/BuyersCode">
								<BuyersCode>
									<xsl:value-of select="Buyer/BuyersLocationID/BuyersCode"/>
								</BuyersCode>
							</xsl:if>
							<xsl:if test="Buyer/BuyersLocationID/SuppliersCode">
								<SuppliersCode>
									<xsl:value-of select="Buyer/BuyersLocationID/SuppliersCode"/>
								</SuppliersCode>
							</xsl:if>
						</BuyersLocationID>
						<xsl:if test="Buyer/BuyersName">
							<BuyersName>
								<xsl:value-of select="Buyer/BuyersName"/>
							</BuyersName>
						</xsl:if>
						<xsl:if test="Buyer/BuyersAddress">
							<BuyersAddress>
								<AddressLine1>
									<xsl:value-of select="Buyer/BuyersAddress/AddressLine1"/>
								</AddressLine1>
								<xsl:if test="Buyer/BuyersAddress/AddressLine2">
									<AddressLine2>
										<xsl:value-of select="Buyer/BuyersAddress/AddressLine2"/>
									</AddressLine2>
								</xsl:if>
								<xsl:if test="Buyer/BuyersAddress/AddressLine3">
									<AddressLine3>
										<xsl:value-of select="Buyer/BuyersAddress/AddressLine3"/>
									</AddressLine3>
								</xsl:if>
								<xsl:if test="Buyer/BuyersAddress/AddressLine4">
									<AddressLine4>
										<xsl:value-of select="Buyer/BuyersAddress/AddressLine4"/>
									</AddressLine4>
								</xsl:if>
								<xsl:if test="Buyer/BuyersAddress/PostCode">
									<PostCode>
										<xsl:value-of select="Buyer/BuyersAddress/PostCode"/>
									</PostCode>
								</xsl:if>
							</BuyersAddress>
						</xsl:if>
					</Buyer>
					<Supplier>
						<SuppliersLocationID>
							<GLN>
								<xsl:value-of select="Supplier/SuppliersLocationID/GLN"/>
							</GLN>
							<xsl:if test="Supplier/SuppliersLocationID/BuyersCode">
								<BuyersCode>
									<xsl:value-of select="Supplier/SuppliersLocationID/BuyersCode"/>
								</BuyersCode>
							</xsl:if>
							<xsl:if test="Supplier/SuppliersLocationID/SuppliersCode">
								<SuppliersCode>
									<xsl:value-of select="Supplier/SuppliersLocationID/SuppliersCode"/>
								</SuppliersCode>
							</xsl:if>
						</SuppliersLocationID>
						<SuppliersName>
							<xsl:value-of select="Supplier/SuppliersName"/>
						</SuppliersName>
						<xsl:if test="Supplier/SuppliersAddress">
							<SuppliersAddress>
								<AddressLine1>
									<xsl:value-of select="Supplier/SuppliersAddress/AddressLine1"/>
								</AddressLine1>
								<xsl:if test="Supplier/SuppliersAddress/AddressLine2">
									<AddressLine2>
										<xsl:value-of select="Supplier/SuppliersAddress/AddressLine2"/>
									</AddressLine2>
								</xsl:if>
								<xsl:if test="Supplier/SuppliersAddress/AddressLine3">
									<AddressLine3>
										<xsl:value-of select="Supplier/SuppliersAddress/AddressLine3"/>
									</AddressLine3>
								</xsl:if>
								<xsl:if test="Supplier/SuppliersAddress/AddressLine4">
									<AddressLine4>
										<xsl:value-of select="Supplier/SuppliersAddress/AddressLine4"/>
									</AddressLine4>
								</xsl:if>
								<xsl:if test="Supplier/SuppliersAddress/PostCode">
									<PostCode>
										<xsl:value-of select="Supplier/SuppliersAddress/PostCode"/>
									</PostCode>
								</xsl:if>
							</SuppliersAddress>
						</xsl:if>
					</Supplier>
					<ShipTo>
						<ShipToLocationID>
							<GLN>
								<xsl:value-of select="ShipTo/ShipToLocationID/GLN"/>
							</GLN>
							<xsl:if test="ShipTo/ShipToLocationID/BuyersCode">
								<BuyersCode>
									<xsl:value-of select="ShipTo/ShipToLocationID/BuyersCode"/>
								</BuyersCode>
							</xsl:if>
							<xsl:if test="ShipTo/ShipToLocationID/SuppliersCode">
								<SuppliersCode>
									<xsl:value-of select="ShipTo/ShipToLocationID/SuppliersCode"/>
								</SuppliersCode>
							</xsl:if>
						</ShipToLocationID>
						<xsl:if test="ShipTo/ShipToName">
							<ShipToName>
								<xsl:value-of select="ShipTo/ShipToName"/>
							</ShipToName>
						</xsl:if>
						<ShipToAddress>
							<AddressLine1>
								<xsl:value-of select="ShipTo/ShipToAddress/AddressLine1"/>
							</AddressLine1>
							<xsl:if test="ShipTo/ShipToAddress/AddressLine2">
								<AddressLine2>
									<xsl:value-of select="ShipTo/ShipToAddress/AddressLine2"/>
								</AddressLine2>
							</xsl:if>
							<xsl:if test="ShipTo/ShipToAddress/AddressLine3">
								<AddressLine3>
									<xsl:value-of select="ShipTo/ShipToAddress/AddressLine3"/>
								</AddressLine3>
							</xsl:if>
							<xsl:if test="ShipTo/ShipToAddress/AddressLine4">
								<AddressLine4>
									<xsl:value-of select="ShipTo/ShipToAddress/AddressLine4"/>
								</AddressLine4>
							</xsl:if>
							<xsl:if test="ShipTo/ShipToAddress/PostCode">
								<PostCode>
									<xsl:value-of select="ShipTo/ShipToAddress/PostCode"/>
								</PostCode>
							</xsl:if>
						</ShipToAddress>
						<xsl:if test="ShipTo/ContactName">
							<ContactName>
								<xsl:value-of select="ShipTo/ContactName"/>
							</ContactName>
						</xsl:if>
					</ShipTo>
					<xsl:if test="InvoiceReferences">
						<InvoiceReferences>
							<InvoiceReference>
								<xsl:value-of select="InvoiceReferences/InvoiceReference"/>
							</InvoiceReference>
							<InvoiceDate>
								<xsl:value-of select="InvoiceReferences/InvoiceDate"/>
							</InvoiceDate>
							<xsl:if test="InvoiceReferences/TaxPointDate">
								<TaxPointDate>
									<xsl:value-of select="InvoiceReferences/TaxPointDate"/>
								</TaxPointDate>
							</xsl:if>
							<xsl:if test="InvoiceReferences/VATRegNo">
								<VATRegNo>
									<xsl:value-of select="InvoiceReferences/VATRegNo"/>
								</VATRegNo>
							</xsl:if>
							<xsl:if test="InvoiceReferences/BuyersVATRegNo">
								<BuyersVATRegNo>
									<xsl:value-of select="InvoiceReferences/BuyersVATRegNo"/>
								</BuyersVATRegNo>
							</xsl:if>
							<xsl:if test="InvoiceReferences/InvoiceMatchingDetails">
								<InvoiceMatchingDetails>
									<MatchingStatus>
										<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingStatus"/>
									</MatchingStatus>
									<MatchingDate>
										<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingDate"/>
									</MatchingDate>
									<MatchingTime>
										<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingTime"/>
									</MatchingTime>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteReference">
										<GoodsReceivedNoteReference>
											<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteReference"/>
										</GoodsReceivedNoteReference>
									</xsl:if>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteDate">
										<GoodsReceivedNoteDate>
											<xsl:value-of select="InvoiceMatchingDetails/GoodsReceivedNoteDate"/>
										</GoodsReceivedNoteDate>
									</xsl:if>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/DebitNoteReference">
										<DebitNoteReference>
											<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/DebitNoteReference"/>
										</DebitNoteReference>
									</xsl:if>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/DebitNoteDate">
										<DebitNoteDate>
											<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/DebitNoteDate"/>
										</DebitNoteDate>
									</xsl:if>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/CreditNoteReference">
										<CreditNoteReference>
											<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/CreditNoteReference"/>
										</CreditNoteReference>
									</xsl:if>
									<xsl:if test="InvoiceReferences/InvoiceMatchingDetails/CreditNoteDate">
										<CreditNoteDate>
											<xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/CreditNoteDate"/>
										</CreditNoteDate>
									</xsl:if>
								</InvoiceMatchingDetails>
							</xsl:if>
						</InvoiceReferences>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$DocumentType = 'CreditNote'">
							<CreditNoteReferences>
								<CreditNoteReference>
									<xsl:value-of select="CreditNoteReferences/CreditNoteReference"/>
								</CreditNoteReference>
								<CreditNoteDate>
									<xsl:value-of select="CreditNoteReferences/CreditNoteDate"/>
								</CreditNoteDate>
								<TaxPointDate>
									<xsl:value-of select="CreditNoteReferences/TaxPointDate"/>
								</TaxPointDate>
								<VATRegNo>
									<xsl:value-of select="CreditNoteReferences/VATRegNo"/>
								</VATRegNo>
							</CreditNoteReferences>
						</xsl:when>
						<xsl:when test="$DocumentType = 'DebitNote'">
							<DebitNoteReferences>
								<DebitNoteReference>
									<xsl:value-of select="DebitNoteReferences/DebitNoteReference"/>
								</DebitNoteReference>
								<DebitNoteDate>
									<xsl:value-of select="DebitNoteReferences/DebitNoteDate"/>
								</DebitNoteDate>
								<TaxPointDate>
									<xsl:value-of select="DebitNoteReferences/TaxPointDate"/>
								</TaxPointDate>
								<VATRegNo>
									<xsl:value-of select="DebitNoteReferences/VATRegNo"/>
								</VATRegNo>
							</DebitNoteReferences>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="Currency">
						<Currency>
							<xsl:value-of select="Currency"/>
						</Currency>
					</xsl:if>
					<xsl:if test="SequenceNumber">
						<SequenceNumber>
							<xsl:value-of select="SequenceNumber"/>
						</SequenceNumber>
					</xsl:if>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="InvoiceDetail | CreditNoteDetail | DebitNoteDetail">
				<xsl:element name="{$DocumentType}Detail">
					<xsl:for-each select="InvoiceLine | CreditNoteLine | DebitNoteLine">
						<xsl:element name="{$DocumentType}Line">
							<LineNumber>
								<xsl:value-of select="LineNumber"/>
							</LineNumber>
							<xsl:if test="CreditRequestReferences">
								<CreditRequestReferences>
									<CreditRequestReference>
										<xsl:value-of select="CreditRequestReferences/CreditRequestReference"/>
									</CreditRequestReference>
									<CreditRequestDate>
										<xsl:value-of select="CreditRequestReferences/CreditRequestDate"/>
									</CreditRequestDate>
									<xsl:if test="CreditRequestReferences/VATRegNo">
										<VATRegNo>
											<xsl:value-of select="CreditRequestReferences/VATRegNo"/>
										</VATRegNo>
									</xsl:if>
									<xsl:if test="CreditRequestReferences/ContactName">
										<ContactName>
											<xsl:value-of select="CreditRequestReferences/ContactName"/>
										</ContactName>
									</xsl:if>
									<xsl:if test="CreditRequestReferences/SuppliersName">
										<SuppliersName>
											<xsl:value-of select="CreditRequestReferences/SuppliersName"/>
										</SuppliersName>
									</xsl:if>
									<xsl:if test="CreditRequestReferences/CreditRequestStatus">
										<CreditRequestStatus>
											<xsl:value-of select="CreditRequestReferences/CreditRequestStatus"/>
										</CreditRequestStatus>
									</xsl:if>
								</CreditRequestReferences>
							</xsl:if>
							<xsl:if test="PurchaseOrderReferences">
								<PurchaseOrderReferences>
									<PurchaseOrderReference>
										<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
									</PurchaseOrderReference>
									<PurchaseOrderDate>
										<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
									</PurchaseOrderDate>
									<xsl:if test="PurchaseOrderReferences/PurchaseOrderTime">
										<PurchaseOrderTime>
											<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderTime"/>
										</PurchaseOrderTime>
									</xsl:if>
									<xsl:if test="PurchaseOrderReferences/TradeAgreement">
										<TradeAgreement>
											<ContractReference>
												<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractReference"/>
											</ContractReference>
											<xsl:if test="PurchaseOrderReferences/TradeAgreement/ContractDate">
												<ContractDate>
													<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractDate"/>
												</ContractDate>
											</xsl:if>
										</TradeAgreement>
									</xsl:if>
									<xsl:if test="PurchaseOrderReferences/CustomerPurchaseOrderReference">
										<CustomerPurchaseOrderReference>
											<xsl:value-of select="PurchaseOrderReferences/CustomerPurchaseOrderReference"/>
										</CustomerPurchaseOrderReference>
									</xsl:if>
									<xsl:if test="PurchaseOrderReferences/JobNumber">
										<JobNumber>
											<xsl:value-of select="PurchaseOrderReferences/JobNumber"/>
										</JobNumber>
									</xsl:if>
									<xsl:if test="PurchaseOrderReferences/OriginalPurchaseOrderReference">
										<OriginalPurchaseOrderReference>
											<xsl:value-of select="PurchaseOrderReferences/OriginalPurchaseOrderReference"/>
										</OriginalPurchaseOrderReference>
									</xsl:if>
								</PurchaseOrderReferences>
							</xsl:if>
							<xsl:if test="PurchaseOrderConfirmationReferences">
								<PurchaseOrderConfirmationReferences>
									<PurchaseOrderConfirmationReference>
										<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
									</PurchaseOrderConfirmationReference>
									<PurchaseOrderConfirmationDate>
										<xsl:value-of select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
									</PurchaseOrderConfirmationDate>
								</PurchaseOrderConfirmationReferences>
							</xsl:if>
							<xsl:if test="DeliveryNoteReferences">
								<DeliveryNoteReferences>
									<DeliveryNoteReference>
										<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
									</DeliveryNoteReference>
									<DeliveryNoteDate>
										<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
									</DeliveryNoteDate>
									<DespatchDate>
										<xsl:value-of select="DeliveryNoteReferences/DespatchDate"/>
									</DespatchDate>
								</DeliveryNoteReferences>
							</xsl:if>
							<xsl:if test="GoodsReceivedNoteReferences">
								<GoodsReceivedNoteReferences>
									<GoodsReceivedNoteReference>
										<xsl:value-of select="GoodsReceivedNoteReferences/GoodsReceivedNoteReference"/>
									</GoodsReceivedNoteReference>
									<GoodsReceivedNoteDate>
										<xsl:value-of select="GoodsReceivedNoteReferences/GoodsReceivedNoteDate"/>
									</GoodsReceivedNoteDate>
								</GoodsReceivedNoteReferences>
							</xsl:if>
							<ProductID>
								<GTIN>
									<xsl:value-of select="ProductID/GTIN"/>
								</GTIN>
								<xsl:if test="ProductID/SuppliersProductCode">
									<SuppliersProductCode>
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</SuppliersProductCode>
								</xsl:if>
								<xsl:if test="ProductID/BuyersProductCode">
									<BuyersProductCode>
										<xsl:value-of select="ProductID/BuyersProductCode"/>
									</BuyersProductCode>
								</xsl:if>
							</ProductID>
							<ProductDescription>
								<xsl:value-of select="ProductDescription"/>
							</ProductDescription>
							<xsl:if test="OrderedQuantity">
								<OrderedQuantity>
									<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="OrderedQuantity/@UnitOfMeasure"/></xsl:attribute>
									<xsl:value-of select="OrderedQuantity"/>
								</OrderedQuantity>
							</xsl:if>
							<xsl:if test="ConfirmedQuantity">
								<ConfirmedQuantity>
									<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="ConfirmedQuantity/@UnitOfMeasure"/></xsl:attribute>
									<xsl:value-of select="ConfirmedQuantity"/>
								</ConfirmedQuantity>
							</xsl:if>
							<xsl:if test="DeliveredQuantity">
								<DeliveredQuantity>
									<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DeliveredQuantity/@UnitOfMeasure"/></xsl:attribute>
									<xsl:value-of select="DeliveredQuantity"/>
								</DeliveredQuantity>
							</xsl:if>
							<xsl:if test="InvoicedQuantity">
								<InvoicedQuantity>
									<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
									<xsl:value-of select="InvoicedQuantity"/>
								</InvoicedQuantity>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$DocumentType = 'CreditNote'">
									<CreditedQuantity>
										<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></xsl:attribute>
										<xsl:value-of select="CreditedQuantity"/>
									</CreditedQuantity>
								</xsl:when>
								<xsl:when test="$DocumentType = 'DebitNote'">
									<DebitedQuantity>
										<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="DebitedQuantity/@UnitOfMeasure"/></xsl:attribute>
										<xsl:value-of select="DebitedQuantity"/>
									</DebitedQuantity>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="PackSize">
								<PackSize>
									<xsl:value-of select="PackSize"/>
								</PackSize>
							</xsl:if>
							<UnitValueExclVAT>
								<xsl:if test="UnitValueExclVAT/@ValidationResult">
									<xsl:attribute name="ValidationResult"><xsl:value-of select="UnitValueExclVAT/@ValidationResult"/></xsl:attribute>
								</xsl:if>
								<xsl:value-of select="UnitValueExclVAT"/>
							</UnitValueExclVAT>
							<LineValueExclVAT>
								<xsl:value-of select="LineValueExclVAT"/>
							</LineValueExclVAT>
							<xsl:if test="LineDiscountRate">
								<LineDiscountRate>
									<xsl:value-of select="LineDiscountRate"/>
								</LineDiscountRate>
							</xsl:if>
							<xsl:if test="LineDiscountValue">
								<LineDiscountValue>
									<xsl:value-of select="LineDiscountValue"/>
								</LineDiscountValue>
							</xsl:if>
							<VATCode>
								<xsl:value-of select="VATCode"/>
							</VATCode>
							<VATRate>
								<xsl:value-of select="VATRate"/>
							</VATRate>
							<xsl:if test="Narrative">
								<Narrative>
									<xsl:if test="Narrative/@Code">
										<xsl:attribute name="Code"><xsl:value-of select="Narrative/@Code"/></xsl:attribute>
									</xsl:if>
									<xsl:value-of select="Narrative"/>
								</Narrative>
							</xsl:if>
							<xsl:if test="NetPriceFlag">
								<NetPriceFlag>
									<xsl:value-of select="NetPriceFlag"/>
								</NetPriceFlag>
							</xsl:if>
							<xsl:if test="Measure">
								<Measure>
									<xsl:if test="Measure/UnitsInPack">
										<UnitsInPack>
											<xsl:value-of select="Measure/UnitsInPack"/>
										</UnitsInPack>
									</xsl:if>
									<xsl:if test="Measure/OrderingMeasure">
										<OrderingMeasure>
											<xsl:value-of select="Measure/OrderingMeasure"/>
										</OrderingMeasure>
									</xsl:if>
									<xsl:if test="Measure/MeasureIndicator">
										<MeasureIndicator>
											<xsl:value-of select="Measure/MeasureIndicator"/>
										</MeasureIndicator>
									</xsl:if>
									<xsl:if test="Measure/TotalMeasure">
										<TotalMeasure>
											<xsl:value-of select="Measure/TotalMeasure"/>
										</TotalMeasure>
									</xsl:if>
									<xsl:if test="Measure/TotalMeasureIndicator">
										<TotalMeasureIndicator>
											<xsl:value-of select="Measure/TotalMeasureIndicator"/>
										</TotalMeasureIndicator>
									</xsl:if>
								</Measure>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="InvoiceTrailer | CreditTrailer | DebitNoteTrailer">
				<xsl:element name="{$DocumentType}Trailer">
					<NumberOfLines>
						<xsl:value-of select="NumberOfLines"/>
					</NumberOfLines>
					<NumberOfItems>
						<xsl:value-of select="NumberOfItems"/>
					</NumberOfItems>
					<NumberOfDeliveries>
						<xsl:value-of select="NumberOfDeliveries"/>
					</NumberOfDeliveries>
					<DocumentDiscountRate>
						<xsl:value-of select="DocumentDiscountRate"/>
					</DocumentDiscountRate>
					<SettlementDiscountRate>
						<xsl:if test="SettlementDiscountRate/@SettlementDiscountDays">
							<xsl:attribute name="SettlementDiscountDays"><xsl:value-of select="SettlementDiscountRate/@SettlementDiscountDays"/></xsl:attribute>
						</xsl:if>
						<xsl:value-of select="SettlementDiscountRate"/>
					</SettlementDiscountRate>
					<VATSubTotals>
						<xsl:for-each select="VATSubTotals/VATSubTotal">
							<VATSubTotal>
								<xsl:attribute name="VATCode"><xsl:value-of select="@VATCode"/></xsl:attribute>
								<xsl:attribute name="VATRate"><xsl:value-of select="@VATRate"/></xsl:attribute>
								<NumberOfLinesAtRate>
									<xsl:value-of select="NumberOfLinesAtRate"/>
								</NumberOfLinesAtRate>
								<NumberOfItemsAtRate>
									<xsl:value-of select="NumberOfItemsAtRate"/>
								</NumberOfItemsAtRate>
								<DiscountedLinesTotalExclVATAtRate>
									<xsl:value-of select="DiscountedLinesTotalExclVATAtRate"/>
								</DiscountedLinesTotalExclVATAtRate>
								<DocumentDiscountAtRate>
									<xsl:value-of select="DocumentDiscountAtRate"/>
								</DocumentDiscountAtRate>
								<DocumentTotalExclVATAtRate>
									<xsl:value-of select="DocumentTotalExclVATAtRate"/>
								</DocumentTotalExclVATAtRate>
								<SettlementDiscountAtRate>
									<xsl:value-of select="SettlementDiscountAtRate"/>
								</SettlementDiscountAtRate>
								<SettlementTotalExclVATAtRate>
									<xsl:value-of select="SettlementTotalExclVATAtRate"/>
								</SettlementTotalExclVATAtRate>
								<VATAmountAtRate>
									<xsl:value-of select="VATAmountAtRate"/>
								</VATAmountAtRate>
								<DocumentTotalInclVATAtRate>
									<xsl:value-of select="DocumentTotalInclVATAtRate"/>
								</DocumentTotalInclVATAtRate>
								<SettlementTotalInclVATAtRate>
									<xsl:value-of select="SettlementTotalInclVATAtRate"/>
								</SettlementTotalInclVATAtRate>
							</VATSubTotal>
						</xsl:for-each>
					</VATSubTotals>
					<DiscountedLinesTotalExclVAT>
						<xsl:value-of select="DiscountedLinesTotalExclVAT"/>
					</DiscountedLinesTotalExclVAT>
					<DocumentDiscount>
						<xsl:value-of select="DocumentDiscount"/>
					</DocumentDiscount>
					<DocumentTotalExclVAT>
						<xsl:value-of select="DocumentTotalExclVAT"/>
					</DocumentTotalExclVAT>
					<SettlementDiscount>
						<xsl:value-of select="SettlementDiscount"/>
					</SettlementDiscount>
					<SettlementTotalExclVAT>
						<xsl:value-of select="SettlementTotalExclVAT"/>
					</SettlementTotalExclVAT>
					<VATAmount>
						<xsl:value-of select="VATAmount"/>
					</VATAmount>
					<DocumentTotalInclVAT>
						<xsl:value-of select="DocumentTotalInclVAT"/>
					</DocumentTotalInclVAT>
					<SettlementTotalInclVAT>
						<xsl:value-of select="SettlementTotalInclVAT"/>
					</SettlementTotalInclVAT>
				</xsl:element>
			</xsl:for-each>
			<xsl:if test="$DocumentType = 'Invoice' or $DocumentType = 'CreditNote'">
				<xsl:if test="DistributionsHeader">
					<DistributionsHeader>
						<InterCompanyFlag>
							<xsl:value-of select="DistributionsHeader/InterCompanyFlag"/>
						</InterCompanyFlag>
						<VATSchedule>
							<xsl:value-of select="DistributionsHeader/VATSchedule"/>
						</VATSchedule>
						<CompanyPLCode>
							<xsl:value-of select="DistributionsHeader/CompanyPLCode"/>
						</CompanyPLCode>
						<CostCentreCode>
							<xsl:value-of select="DistributionsHeader/CostCentreCode"/>
						</CostCentreCode>
					</DistributionsHeader>
				</xsl:if>
				<xsl:if test="DistributionsDetail">
					<DistributionsDetail>
						<xsl:for-each select="DistributionsDetail/DistributionsLine">
							<DistributionsLine>
								<DistributionType>
									<xsl:value-of select="DistributionType"/>
								</DistributionType>
								<CompanyCode>
									<xsl:value-of select="CompanyCode"/>
								</CompanyCode>
								<DistributionAccount>
									<xsl:value-of select="DistributionAccount"/>
								</DistributionAccount>
								<CreditOrDebitAmount>
									<xsl:attribute name="CreditOrDebit"><xsl:value-of select="CreditOrDebitAmount/@CreditOrDebit"/></xsl:attribute>
									<xsl:value-of select="CreditOrDebitAmount"/>
								</CreditOrDebitAmount>
								<xsl:if test="Narrative">
									<Narrative>
										<xsl:if test="Narrative/@Code">
											<xsl:attribute name="Code"><xsl:value-of select="Narrative/@Code"/></xsl:attribute>
										</xsl:if>
										<xsl:value-of select="Narrative"/>
									</Narrative>
								</xsl:if>
							</DistributionsLine>
						</xsl:for-each>
					</DistributionsDetail>
				</xsl:if>
				<xsl:if test="DistributionsTrailer">
					<DistributionsTrailer>
						<PurchasesDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/PurchasesDistributionsTotal"/>
						</PurchasesDistributionsTotal>
						<TaxDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/TaxDistributionsTotal"/>
						</TaxDistributionsTotal>
						<TradeDiscountDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/TradeDiscountDistributionsTotal"/>
						</TradeDiscountDistributionsTotal>
						<BasicDiscountDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/BasicDiscountDistributionsTotal"/>
						</BasicDiscountDistributionsTotal>
						<DeductORDiscountDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/DeductORDiscountDistributionsTotal"/>
						</DeductORDiscountDistributionsTotal>
						<OtherDistributionsTotal>
							<xsl:value-of select="DistributionsTrailer/OtherDistributionsTotal"/>
						</OtherDistributionsTotal>
					</DistributionsTrailer>
				</xsl:if>
			</xsl:if>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>