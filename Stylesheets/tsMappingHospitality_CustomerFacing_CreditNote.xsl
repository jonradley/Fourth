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
	<xsl:template match="CreditNote">
		<xsl:element name="CreditNote">
			<xsl:element name="TradeSimpleHeader">
				<xsl:copy-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				<xsl:copy-of select="TradeSimpleHeader/SendersBranchReference"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				<xsl:copy-of select="TradeSimpleHeader/RecipientsBranchReference"/>
			</xsl:element>
			<xsl:element name="CreditNoteHeader">
				<xsl:copy-of select="CreditNoteHeader/BatchInformation"/>
				<xsl:copy-of select="CreditNoteHeader/Buyer"/>
				<xsl:copy-of select="CreditNoteHeader/Supplier"/>
				<xsl:element name="ShipTo">
					<xsl:element name="ShipToLocationID">
						<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
						<xsl:element name="SuppliersCode">
							<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
						</xsl:element>
					</xsl:element>
					<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToName"/>
					<xsl:copy-of select="CreditNoteHeader/ShipTo/ShipToAddress"/>
				</xsl:element>
				<xsl:element name="InvoiceReferences">
					<xsl:copy-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
					<xsl:copy-of select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
				</xsl:element>
				<xsl:copy-of select="CreditNoteHeader/CreditNoteReferences"/>
				<xsl:copy-of select="CreditNoteHeader/Currency"/>
			</xsl:element>
			<xsl:element name="CreditNoteDetail">
				<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
					<xsl:element name="CreditNoteLine">
						<xsl:copy-of select="LineNumber"/>
						<xsl:copy-of select="CreditRequestReferences"/>
						<xsl:copy-of select="PurchaseOrderReferences"/>
						<xsl:copy-of select="DeliveryNoteReferences"/>
						<xsl:element name="ProductID">
							<xsl:copy-of select="ProductID/GTIN"/>
							<xsl:copy-of select="ProductID/SuppliersProductCode"/>
							<xsl:element name="BuyersProductCode">
								<xsl:value-of select="CreditNoteDetail/CreditNoteLine/ProductID/BuyersProductCode"/>
							</xsl:element>
						</xsl:element>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:element name="CreditedQuantity">
							<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="PackSize"/></xsl:attribute>
							<xsl:value-of select="CreditedQuantity"/>
						</xsl:element>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="CreditNoteTrailer">
				<xsl:copy-of select="CreditNoteTrailer/NumberOfLines"/>
				<xsl:copy-of select="CreditNoteTrailer/NumberOfItems"/>
				<xsl:copy-of select="CreditNoteTrailer/NumberOfDeliveries"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentDiscountRate"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementDiscountRate"/>
				<xsl:element name="VATSubTotals">
					<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
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
				<xsl:copy-of select="CreditNoteTrailer/DiscountedLinesTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentDiscount"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementDiscount"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementTotalExclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/VATAmount"/>
				<xsl:copy-of select="CreditNoteTrailer/DocumentTotalInclVAT"/>
				<xsl:copy-of select="CreditNoteTrailer/SettlementTotalInclVAT"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
