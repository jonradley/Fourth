<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

 Navision uses a slightly modified version of the internal format. However
 the internal format has changed as part of the Elior implementation so the 
 previous mapping processor is now a pre-mapping to be followed by this
 stylesheet.
 
 This stylesheet has been added to ensure that future internal changes
 (as long as they are backwardly compatible) will not require further
 changes to the format Navision receive.

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 14/10/2004 | Lee Boyton  | Created module.
******************************************************************************************
 16/03/2005 | A Sheppard | H347. Added debit note mapping 
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#default xsl">
<xsl:output method="xml" encoding="ISO-8859-1"/>

<xsl:template match="/Invoice">
	<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="NavisionInvoice.xsl"</xsl:processing-instruction>
	<Invoice>
		<xsl:apply-templates select="TradeSimpleHeader"/>
		<xsl:apply-templates select="InvoiceHeader"/>
		<xsl:apply-templates select="InvoiceDetail"/>
		<xsl:apply-templates select="InvoiceTrailer"/>
	</Invoice>
</xsl:template>

<xsl:template match="/CreditNote">
	<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="NavisionCredit.xsl"</xsl:processing-instruction>
	<CreditNote>
		<xsl:apply-templates select="TradeSimpleHeader"/>
		<xsl:apply-templates select="CreditNoteHeader"/>
		<xsl:apply-templates select="CreditNoteDetail"/>
		<xsl:apply-templates select="CreditNoteTrailer"/>
	</CreditNote>
</xsl:template>

<xsl:template match="/DebitNote">
	<xsl:processing-instruction name="xml-stylesheet">type="text/xsl" href="NavisionDebit.xsl"</xsl:processing-instruction>
	<DebitNote>
		<xsl:apply-templates select="TradeSimpleHeader"/>
		<xsl:apply-templates select="DebitNoteHeader"/>
		<xsl:apply-templates select="DebitNoteDetail"/>
		<xsl:apply-templates select="DebitNoteTrailer"/>
	</DebitNote>
</xsl:template>

<!-- Templates for outputting the header information -->

<xsl:template match="TradeSimpleHeader">
	<TradeSimpleHeader>
		<xsl:apply-templates select="SendersCodeForRecipient"/>
		<xsl:apply-templates select="SendersBranchReference"/>
		<xsl:apply-templates select="SendersName"/>
		<xsl:apply-templates select="SendersAddress"/>
		<xsl:apply-templates select="RecipientsCodeForSender"/>
		<xsl:apply-templates select="RecipientsBranchReference"/>
		<xsl:apply-templates select="RecipientsName"/>
		<xsl:apply-templates select="RecipientsAddress"/>
		<xsl:apply-templates select="TestFlag"/>
	</TradeSimpleHeader>
</xsl:template>

<!-- Basic copying template to handle optional elements in TradeSimpleHeader -->
<xsl:template match="SendersCodeForRecipient | SendersBranchReference | SendersName | RecipientsCodeForSender | RecipientsBranchReference | RecipientsName | TestFlag">
	<xsl:element name="{name(current())}">
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<xsl:template match="InvoiceHeader | CreditNoteHeader | DebitNoteHeader">
	<xsl:element name="{name(current())}">
		<DocumentStatus><xsl:value-of select="DocumentStatus"/></DocumentStatus>
		<Buyer>
			<xsl:apply-templates select="Buyer/BuyersLocationID"/>
			<xsl:apply-templates select="Buyer/BuyersName"/>
			<xsl:apply-templates select="Buyer/BuyersAddress"/>
		</Buyer>
		<Supplier>
			<xsl:apply-templates select="Supplier/SuppliersLocationID"/>
			<xsl:apply-templates select="Supplier/SuppliersName"/>
			<xsl:apply-templates select="Supplier/SuppliersAddress"/>
		</Supplier>
		<ShipTo>
			<xsl:apply-templates select="ShipTo/ShipToLocationID"/>
			<xsl:apply-templates select="ShipTo/ShipToName"/>
			<xsl:apply-templates select="ShipTo/ShipToAddress"/>
		</ShipTo>
		<!-- the purchase order, order confirmation, delivery note and goods received note references are now stored at the line level internally so 
		they need to be put back into the header to match the previous version. NB: this assumes only a single instance of each reference across all lines. -->
		<PurchaseOrderReferences>
			<PurchaseOrderReference><xsl:value-of select="//PurchaseOrderReferences[1]/PurchaseOrderReference"/></PurchaseOrderReference>
			<PurchaseOrderDate><xsl:value-of select="//PurchaseOrderReferences[1]/PurchaseOrderDate"/></PurchaseOrderDate>
			<xsl:if test="//PurchaseOrderReferences[1]/PurchaseOrderTime">
				<PurchaseOrderTime><xsl:value-of select="//PurchaseOrderReferences[1]/PurchaseOrderTime"/></PurchaseOrderTime>
			</xsl:if>
			<xsl:if test="//PurchaseOrderReferences[1]/TradeAgreement">
				<TradeAgreement>
					<ContractReference><xsl:value-of select="//PurchaseOrderReferences[1]/TradeAgreement/ContractReference"/></ContractReference>
					<xsl:if test="//PurchaseOrderReferences[1]/TradeAgreement/ContractDate">
						<ContractDate><xsl:value-of select="//PurchaseOrderReferences[1]/TradeAgreement/ContractDate"/></ContractDate>
					</xsl:if>
				</TradeAgreement>
			</xsl:if>
			<xsl:if test="//PurchaseOrderReferences[1]/CustomerPurchaseOrderReference">
				<CustomerPurchaseOrderReference><xsl:value-of select="//PurchaseOrderReferences[1]/CustomerPurchaseOrderReference"/></CustomerPurchaseOrderReference>
			</xsl:if>
		</PurchaseOrderReferences>
		<PurchaseOrderConfirmationReferences>
			<PurchaseOrderConfirmationReference><xsl:value-of select="//PurchaseOrderConfirmationReferences[1]/PurchaseOrderConfirmationReference"/></PurchaseOrderConfirmationReference>
			<PurchaseOrderConfirmationDate><xsl:value-of select="//PurchaseOrderConfirmationReferences[1]/PurchaseOrderConfirmationDate"/></PurchaseOrderConfirmationDate>
		</PurchaseOrderConfirmationReferences>
		<DeliveryNoteReferences>
			<DeliveryNoteReference><xsl:value-of select="//DeliveryNoteReferences[1]/DeliveryNoteReference"/></DeliveryNoteReference>
			<DeliveryNoteDate><xsl:value-of select="//DeliveryNoteReferences[1]/DeliveryNoteDate"/></DeliveryNoteDate>
			<DespatchDate><xsl:value-of select="//DeliveryNoteReferences[1]/DespatchDate"/></DespatchDate>
		</DeliveryNoteReferences>
		<!-- The GoodsReceivedNoteReferences element was optional at the header level previously -->
		<xsl:if test="//GoodsReceivedNoteReferences">
			<GoodsReceivedNoteReferences>
				<GoodsReceivedNoteReference><xsl:value-of select="//GoodsReceivedNoteReferences/GoodsReceivedNoteReference[1]"/></GoodsReceivedNoteReference>
				<GoodsReceivedNoteDate><xsl:value-of select="//GoodsReceivedNoteReferences/GoodsReceivedNoteDate[1]"/></GoodsReceivedNoteDate>
			</GoodsReceivedNoteReferences>
		</xsl:if>
		<!-- InvoiceReferences was previously mandatory in the internal schema, they are now optional.
		The assumption is that they will always exist for documents passing through this mapping -->
		<InvoiceReferences>
			<InvoiceReference><xsl:value-of select="InvoiceReferences/InvoiceReference"/></InvoiceReference>
			<InvoiceDate><xsl:value-of select="InvoiceReferences/InvoiceDate"/></InvoiceDate>
			<TaxPointDate><xsl:value-of select="InvoiceReferences/TaxPointDate"/></TaxPointDate>
			<VATRegNo><xsl:value-of select="InvoiceReferences/VATRegNo"/></VATRegNo>
			<xsl:if test="InvoiceReferences/InvoiceMatchingDetails">
				<InvoiceMatchingDetails>
					<MatchingStatus><xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingStatus"/></MatchingStatus>
					<MatchingDate><xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingDate"/></MatchingDate>
					<MatchingTime><xsl:value-of select="InvoiceReferences/InvoiceMatchingDetails/MatchingTime"/></MatchingTime>
					<xsl:apply-templates select="InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteReference"/>
					<xsl:apply-templates select="InvoiceReferences/InvoiceMatchingDetails/GoodsReceivedNoteDate"/>
					<xsl:apply-templates select="InvoiceReferences/InvoiceMatchingDetails/CreditNoteReference"/>
					<xsl:apply-templates select="InvoiceReferences/InvoiceMatchingDetails/CreditNoteDate"/>
				</InvoiceMatchingDetails>
			</xsl:if>
		</InvoiceReferences>
		<!-- NB: CreditNoteReferences will only exist in a credit note document -->
		<xsl:if test="CreditNoteReferences">
			<CreditNoteReferences>
				<CreditNoteReference><xsl:value-of select="CreditNoteReferences/CreditNoteReference"/></CreditNoteReference>
				<CreditNoteDate><xsl:value-of select="CreditNoteReferences/CreditNoteDate"/></CreditNoteDate>
				<TaxPointDate><xsl:value-of select="CreditNoteReferences/TaxPointDate"/></TaxPointDate>
				<VATRegNo><xsl:value-of select="CreditNoteReferences/VATRegNo"/></VATRegNo>
			</CreditNoteReferences>
		</xsl:if>
		<!-- NB: DebitNoteReferences will only exist in a debit note document -->
		<xsl:if test="DebitNoteReferences">
			<DebitNoteReferences>
				<DebitNoteReference><xsl:value-of select="DebitNoteReferences/DebitNoteReference"/></DebitNoteReference>
				<DebitNoteDate><xsl:value-of select="DebitNoteReferences/DebitNoteDate"/></DebitNoteDate>
				<TaxPointDate><xsl:value-of select="DebitNoteReferences/TaxPointDate"/></TaxPointDate>
				<VATRegNo><xsl:value-of select="DebitNoteReferences/VATRegNo"/></VATRegNo>
			</DebitNoteReferences>
		</xsl:if>
		<xsl:apply-templates select="SequenceNumber"/>
	</xsl:element>
</xsl:template>

<!-- Basic copying template to handle optional elements in the header section -->
<xsl:template match="BuyersName | SuppliersName | ShipToName | GoodsReceivedNoteReference | GoodsReceivedNoteDate | CreditNoteReference | CreditNoteDate | DebitNoteReference | DebitNoteDate | SequenceNumber">
	<xsl:element name="{name(current())}">
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<xsl:template match="BuyersLocationID | SuppliersLocationID | ShipToLocationID">
	<xsl:element name="{name(current())}">
		<xsl:apply-templates select="GLN"/>
		<xsl:apply-templates select="BuyersCode"/>
		<xsl:apply-templates select="SuppliersCode"/>
	</xsl:element>
</xsl:template>

<xsl:template match="SendersAddress | RecipientsAddress | BuyersAddress | SuppliersAddress | ShipToAddress">
	<xsl:if test="AddressLine1">
		<xsl:element name="{name(current())}">
			<xsl:apply-templates select="AddressLine1"/>
			<xsl:apply-templates select="AddressLine2"/>
			<xsl:apply-templates select="AddressLine3"/>
			<xsl:apply-templates select="AddressLine4"/>
			<xsl:apply-templates select="PostCode"/>
		</xsl:element>
	</xsl:if>
</xsl:template>

<!-- Basic copying template to handle remaining optional and mandatory elements in the header party and address elements -->
<xsl:template match="GLN | BuyersCode | SuppliersCode | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | AddressLine5 | PostCode">
	<xsl:element name="{name(current())}">
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<!-- Templates for outputting the line information -->

<xsl:template match="InvoiceDetail | CreditNoteDetail | DebitNoteDetail">
	<xsl:element name="{name(current())}">
		<!-- the following works because there will either be just InvoiceLine elements or CreditNoteLine elements NOT both in any one document -->
		<xsl:apply-templates select="InvoiceLine"/>
		<xsl:apply-templates select="CreditNoteLine"/>
		<xsl:apply-templates select="DebitNoteLine"/>
	</xsl:element>
</xsl:template>

<xsl:template match="InvoiceLine | CreditNoteLine | DebitNoteLine">
	<xsl:element name="{name(current())}">
		<xsl:apply-templates select="LineNumber"/>
		<xsl:apply-templates select="ProductID"/>
		<xsl:apply-templates select="ProductDescription"/>
		<xsl:apply-templates select="OrderedQuantity"/>
		<xsl:apply-templates select="ConfirmedQuantity"/>
		<xsl:apply-templates select="DeliveredQuantity"/>
		<xsl:apply-templates select="InvoicedQuantity"/>
		<xsl:apply-templates select="CreditedQuantity"/>
		<xsl:apply-templates select="DebitedQuantity"/>
		<xsl:apply-templates select="PackSize"/>
		<xsl:apply-templates select="UnitValueExclVAT"/>
		<xsl:apply-templates select="LineValueExclVAT"/>
		<xsl:apply-templates select="LineDiscountRate"/>
		<xsl:apply-templates select="LineDiscountValue"/>
		<xsl:apply-templates select="VATCode"/>
		<xsl:apply-templates select="VATRate"/>
		<xsl:apply-templates select="NetPriceFlag"/>
		<xsl:apply-templates select="GroupCode"/>
	</xsl:element>
</xsl:template>

<xsl:template match="ProductID">
	<ProductID>
		<xsl:apply-templates select="GTIN"/>
		<xsl:apply-templates select="SuppliersProductCode"/>
		<xsl:apply-templates select="BuyersProductCode"/>
	</ProductID>
</xsl:template>

<xsl:template match="OrderedQuantity | ConfirmedQuantity | DeliveredQuantity | InvoicedQuantity | CreditedQuantity | DebitedQuantity">
	<xsl:element name="{name(current())}">
		<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="@UnitOfMeasure"/></xsl:attribute>
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<!-- Basic copying template to handle remaining optional and mandatory elements in the lines -->
<xsl:template match="LineNumber | ProductDescription | PackSize | UnitValueExclVAT | LineValueExclVAT | LineDiscountRate | LineDiscountValue | VATCode | VATRate | NetPriceFlag | GroupCode | GTIN | BuyersProductCode | SuppliersProductCode">
	<xsl:element name="{name(current())}">
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

<!-- Templates for outputting the trailer information -->

<xsl:template match="InvoiceTrailer | CreditNoteTrailer | DebitNoteTrailer">
	<xsl:element name="{name(current())}">
		<xsl:apply-templates select="NumberOfLines"/>
		<xsl:apply-templates select="DocumentDiscountRate"/>
		<xsl:apply-templates select="SettlementDiscountRate"/>
		<xsl:apply-templates select="SettlementTotalExclVAT"/>
		<xsl:apply-templates select="DocumentTotalExclVAT"/>
		<xsl:apply-templates select="VATAmount"/>
		<VATSubTotals>
			<xsl:apply-templates select="VATSubTotals/VATSubTotal"/>
		</VATSubTotals>
		<GroupVATSubTotals>
			<xsl:apply-templates select="GroupVATSubTotals/GroupVATSubTotal"/>
		</GroupVATSubTotals>
		<xsl:apply-templates select="SettlementTotalInclVAT"/>
		<xsl:apply-templates select="DocumentTotalInclVAT"/>
	</xsl:element>
</xsl:template>

<xsl:template match="SettlementDiscountRate">
	<SettlementDiscountRate>
		<xsl:if test="@SettlementDiscountDays">
			<xsl:attribute name="SettlementDiscountDays"><xsl:value-of select="@SettlementDiscountDays"/></xsl:attribute>
		</xsl:if>	
		<xsl:value-of select="."/>
	</SettlementDiscountRate>
</xsl:template>

<xsl:template match="VATSubTotal">
	<VATSubTotal>
		<xsl:attribute name="VATCode"><xsl:value-of select="@VATCode"/></xsl:attribute>
		<xsl:attribute name="VATRate"><xsl:value-of select="@VATRate"/></xsl:attribute>
		<NumberOfLinesAtRate><xsl:value-of select="NumberOfLinesAtRate"/></NumberOfLinesAtRate>
		<DiscountedTotalExclVATAtRate><xsl:value-of select="DiscountedLinesTotalExclVATAtRate"/></DiscountedTotalExclVATAtRate>
		<DocumentDiscountAtRate><xsl:value-of select="DocumentDiscountAtRate"/></DocumentDiscountAtRate>
		<SettlementDiscountAtRate><xsl:value-of select="SettlementDiscountAtRate"/></SettlementDiscountAtRate>
		<TaxableTotalExclVATAtRate><xsl:value-of select="SettlementTotalExclVATAtRate"/></TaxableTotalExclVATAtRate>
		<VATAmountAtRate><xsl:value-of select="VATAmountAtRate"/></VATAmountAtRate>
	</VATSubTotal>
</xsl:template>

<xsl:template match="GroupVATSubTotal">
	<GroupVATSubTotal>
		<xsl:attribute name="GroupCode"><xsl:value-of select="@GroupCode"/></xsl:attribute>
		<xsl:attribute name="VATCode"><xsl:value-of select="@VATCode"/></xsl:attribute>
		<xsl:attribute name="VATRate"><xsl:value-of select="@VATRate"/></xsl:attribute>
		<NumberOfLinesAtGroupAndRate><xsl:value-of select="NumberOfLinesAtGroupAndRate"/></NumberOfLinesAtGroupAndRate>
		<DiscountedTotalExVATAtGroupAndRate><xsl:value-of select="DiscountedLinesTotalExVATAtGroupAndRate"/></DiscountedTotalExVATAtGroupAndRate>
		<DocumentDiscountAtGroupAndRate><xsl:value-of select="DocumentDiscountAtGroupAndRate"/></DocumentDiscountAtGroupAndRate>
		<SettlementDiscountAtGroupAndRate><xsl:value-of select="SettlementDiscountAtGroupAndRate"/></SettlementDiscountAtGroupAndRate>
		<TaxableTotalExclVATAtGroupAndRate><xsl:value-of select="SettlementTotalExclVATAtGroupAndRate"/></TaxableTotalExclVATAtGroupAndRate>
		<VATAmountAtGroupAndRate><xsl:value-of select="VATAmountAtGroupAndRate"/></VATAmountAtGroupAndRate>
	</GroupVATSubTotal>
</xsl:template>

<!-- Basic copying template to handle remaining optional and mandatory elements in the trailer -->
<xsl:template match="NumberOfLines | DocumentDiscountRate | SettlementTotalExclVAT | DocumentTotalExclVAT | VATAmount | SettlementTotalInclVAT | DocumentTotalInclVAT">
	<xsl:element name="{name(current())}">
		<xsl:value-of select="."/>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>