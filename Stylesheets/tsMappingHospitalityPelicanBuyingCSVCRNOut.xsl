<?xml version="1.0" encoding="UTF-8"?>
<!--
=======================================================================================
Overview

Maps internal credit notes to Pelican Buying outbound CSV

=======================================================================================
Name		| Date		   	| Change
=======================================================================================
M Dimant	| 03/07/2013	| 6624: Created stylesheet
=======================================================================================

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:template match="/">		
		<xsl:text>HEAD</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode"/>
		<xsl:text>,</xsl:text>		
		<xsl:text>Y</xsl:text><!-- Credit Note identifier, i.e. this is a credit note! -->
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
		<xsl:text>,</xsl:text>
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementDiscount"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate"/>
		<xsl:text>,</xsl:text>
		<xsl:text>20</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="/CreditNote/CreditNoteDetail/CreditNoteLine">	
			<xsl:text>LINE</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>,</xsl:text>
			<!-- EAN Code -->
			<xsl:text>,</xsl:text>
			<!-- Product Group -->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="ProductDescription"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="normalize-space(PackSize)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!--Measure Indicator-->
			<xsl:text>,</xsl:text>
			<!--Total Measure-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="CreditedQuantity"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<!-- Discount  Amount -->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="LineValueExclVAT"/>
			<xsl:text>,</xsl:text>
			<!-- VAT Line Amount -->
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>