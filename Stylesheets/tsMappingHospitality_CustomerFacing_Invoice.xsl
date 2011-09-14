<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

Takes the internal version of a Credit Note, removes tradesimple specific 
tags used for processing and produces a customer facing version of the 
internal XML.

 
 © Alternative Business Solutions Ltd., 2000.
******************************************************************************************
 Module History
******************************************************************************************
 Version     | 
******************************************************************************************
 Date            | Name                       | Description of modification
******************************************************************************************
25/07/2007 | Moty Dimant    | Created stylesheet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    |                   |                                                                               
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="UTF-8"/>
	<xsl:template match="Invoice">
		<xsl:element name="Invoice">
			<xsl:element name="TradeSimpleHeader">
				<xsl:copy-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				<xsl:copy-of select="TradeSimpleHeader/SendersBranchReference"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:element>
			<xsl:element name="InvoiceHeader">
				<xsl:copy-of select="InvoiceHeader/BatchInformation"/>
				<xsl:copy-of select="InvoiceHeader/Buyer"/>
				<xsl:copy-of select="InvoiceHeader/Supplier"/>
				<xsl:element name="ShipTo">
					<xsl:element name="ShipToLocationID">
						<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:element>
					</xsl:element>
					<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToName"/>
					<xsl:copy-of select="InvoiceHeader/ShipTo/ShipToAddress"/>
				</xsl:element>
				<xsl:element name="InvoiceReferences">
					<xsl:copy-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					<xsl:copy-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
				</xsl:element>
				<xsl:copy-of select="InvoiceHeader/InvoiceReferences"/>
				<xsl:copy-of select="InvoiceHeader/Currency"/>
			</xsl:element>
			<xsl:element name="InvoiceDetail">
				<xsl:for-each select="InvoiceDetail/InvoiceLine">
					<xsl:element name="InvoiceLine">
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<xsl:element name="ProductID">
							<xsl:copy-of select="ProductID/GTIN"/>
							<xsl:copy-of select="ProductID/SuppliersProductCode"/>
							<xsl:element name="BuyersProductCode">
								<xsl:value-of select="InvoiceDetail/InvoiceLine/ProductID/BuyersProductCode"/>
							</xsl:element>
						</xsl:element>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:element name="InvoicedQuantity">
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="PackSize"/></xsl:attribute>
							<xsl:value-of select="InvoicedQuantity"/>
						</xsl:element>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="InvoiceTrailer">
				<xsl:copy-of select="InvoiceTrailer/NumberOfLines"/>
				<xsl:copy-of select="InvoiceTrailer/NumberOfItems"/>
				<xsl:copy-of select="InvoiceTrailer/NumberOfDeliveries"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentDiscountRate"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementDiscountRate"/>
				<xsl:element name="VATSubTotals">
					<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
						<xsl:element name="VATSubTotal">
							<xsl:attribute name="VATCode">
								<xsl:value-of select="@VATCode"/>
							</xsl:attribute>
							<xsl:attribute name="VATRate">
								<xsl:value-of select="@VATRate"/>
							</xsl:attribute>
							<xsl:copy-of select="NumberOfLinesAtRate"/>
							<xsl:copy-of select="NumberOfItemsAtRate"/>
							<xsl:copy-of select="DiscountedLinesTotalExclVATAtRate"/>
							<xsl:copy-of select="DocumentDiscountAtRate"/>
							<xsl:copy-of select="DocumentTotalExclVATAtRate"/>
							<xsl:copy-of select="SettlementDiscountAtRate"/>
							<xsl:copy-of select="SettlementTotalExclVATAtRate"/>
							<xsl:copy-of select="VATAmountAtRate"/>
							<xsl:copy-of select="DocumentTotalInclVATAtRate"/>
							<xsl:copy-of select="SettlementTotalInclVATAtRate"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<xsl:copy-of select="InvoiceTrailer/DiscountedLinesTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentDiscount"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementDiscount"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementTotalExclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/VATAmount"/>
				<xsl:copy-of select="InvoiceTrailer/DocumentTotalInclVAT"/>
				<xsl:copy-of select="InvoiceTrailer/SettlementTotalInclVAT"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
