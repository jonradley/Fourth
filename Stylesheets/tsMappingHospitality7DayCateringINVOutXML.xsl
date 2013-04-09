<!--
***************************************************************************************
Name			| Date 			|	Description
***************************************************************************************
M Emanuel	| 29/01/2013	| FB Case 5946 Created New Invoice out mapper
***************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" encoding="utf-8"/>
	<xsl:template match="/Invoice">

		<xsl:element name="FDHInvoices">
			<xsl:element name="SupplierCode">
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:element>
			<xsl:element name="Invoice">
				<xsl:element name="CustomerCode">
					<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
				</xsl:element>
				<xsl:element name="UnitCode">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</xsl:element>
				<xsl:element name="CustomersLocationCode">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</xsl:element>
				<xsl:element name="SuppliersLocationCode">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
				</xsl:element>
				<xsl:element name="DeliveryLocationEANCode">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
				</xsl:element>
				<xsl:element name="LocationName">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToName"/>
				</xsl:element>
				<xsl:element name="LocationAddress1">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine1"/>
				</xsl:element>
				<xsl:element name="LocationAddress2">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine2"/>
				</xsl:element>
				<xsl:element name="LocationAddress3">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine3"/>
				</xsl:element>
				<xsl:element name="LocationAddress4">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/AddressLine4"/>
				</xsl:element>
				<xsl:element name="LocationPostalCode">
					<xsl:value-of select="InvoiceHeader/ShipTo/ShipToAddress/PostCode"/>
				</xsl:element>
				<xsl:element name="InvoiceNumber">
					<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</xsl:element>
				
				<xsl:variable name="InvDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
				
				<xsl:element name="InvoiceDate">
					<xsl:value-of select="concat(substring($InvDate,1,4),substring($InvDate,6,2),substring($InvDate,9,2))"/>
				</xsl:element>
				

				<xsl:element name="InvoiceCurrency">
					<xsl:value-of select="InvoiceHeader/Currency"/>
				</xsl:element>
				<xsl:element name="DeliveryNoteNumber">
					<xsl:value-of select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteReference"/>
				</xsl:element>
				
				<xsl:variable name="DelDate" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate"/>
				
				<xsl:element name="DeliveryNoteDate">
					<xsl:value-of select="concat(substring($DelDate,1,4),substring($DelDate,6,2),substring($DelDate,9,2))"/>
				</xsl:element>
				<xsl:element name="PaymentDays">
					<xsl:text>00</xsl:text>
				</xsl:element>
				<xsl:element name="OrderList">
					<xsl:element name="Order">
						<xsl:element name="CustomersOrderNumber">
							<xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:element>
						<xsl:variable name="OrdDate" select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/>
						<xsl:element name="CustomersOrderDate">
							<xsl:value-of select="concat(substring($OrdDate,1,4),substring($OrdDate,6,2),substring($OrdDate,9,2))"/>
						</xsl:element>
						<xsl:element name="SuppliersOrderNumber">
							<xsl:value-of select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
						</xsl:element>
						<xsl:variable name="PoDate" select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/>
						<xsl:element name="DateOrderReceivedBySupplier">
							<xsl:value-of select="concat(substring($PoDate,1,4),substring($PoDate,6,2),substring($PoDate,9,2))"/>
						</xsl:element>
						<xsl:element name="LineList">
							<xsl:for-each select="InvoiceDetail/InvoiceLine">
								<xsl:element name="Line">
									<xsl:element name="ItemEANCode">
										<!-- Restrict to first 13 characters -->
										<xsl:value-of select="substring(ProductID/GTIN,1,13)"/>
									</xsl:element>
									<xsl:element name="SuppliersProductCode">
										<xsl:value-of select="ProductID/SuppliersProductCode"/>
									</xsl:element>
									<xsl:element name="Quantity">
										<xsl:value-of select="InvoicedQuantity"/>
									</xsl:element>
									<xsl:element name="UnitPrice">
										<xsl:value-of select="UnitValueExclVAT"/>
									</xsl:element>
									<xsl:element name="LinePrice">
										<xsl:value-of select="LineValueExclVAT"/>
									</xsl:element>
									<xsl:element name="VATCode">
										<xsl:value-of select="VATCode"/>
									</xsl:element>
									<xsl:element name="ProductDescription">
										<xsl:value-of select="ProductDescription"/>
									</xsl:element>
									<xsl:element name="LineDiscountAmount">
										<xsl:value-of select="LineDiscountValue"/>
									</xsl:element>
									<xsl:element name="AgreementCode">
										<xsl:value-of select="PurchaseOrderReferences/TradeAgreement/ContractReference"/>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="TaxSummary">
					<xsl:element name="Tax">
						<xsl:element name="VATCode">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/@VATCode"/>
						</xsl:element>
						<xsl:element name="VATPercentage">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/@VATRate"/>
						</xsl:element>
						<xsl:element name="NumberOfLineItems">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/NumberOfLinesAtRate"/>
						</xsl:element>
						<xsl:element name="AmountSubjectToVAT">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalExclVATAtRate"/>
						</xsl:element>
						<xsl:element name="VATAmount">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate"/>
						</xsl:element>
						<xsl:element name="PayableAmount">
							<xsl:value-of select="InvoiceTrailer/VATSubTotals/VATSubTotal/DocumentTotalInclVATAtRate"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="InvoiceSummary">
					<xsl:element name="TotalInvoiceAmount">
						<xsl:value-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
					</xsl:element>
					<xsl:element name="TotalVAT">
						<xsl:value-of select="InvoiceTrailer/VATAmount"/>
					</xsl:element>
					<xsl:element name="TotalPayable">
						<xsl:value-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
