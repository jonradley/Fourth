<?xml version="1.0" encoding="UTF-8"?>
<!--
=======================================================================================
Overview

Maps internal invoices to Pelican Buying outbound CSV

=======================================================================================
Name		| Date		   	| Change
=======================================================================================
M Dimant	| 12/06/2013	| 6624: Created stylesheet
=======================================================================================

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8"/>
	<xsl:template match="/">
		
		<xsl:text>HEAD</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of  select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode"/>
		<xsl:text>,</xsl:text>		
		<xsl:text>N</xsl:text><!-- Credit Note identifier, i.e. this is not a credit note! -->
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		<xsl:text>,</xsl:text>
		<!-- Location for original Invoice Number in Credit Notes -->
		<xsl:text>,</xsl:text>
		<!-- Location to original Invoice Date in Credit Notes -->
		<xsl:text>,</xsl:text>
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementDiscount"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/SettlementTotalExclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/VATAmountAtRate"/>
		<xsl:text>,</xsl:text>
		<xsl:text>20</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="/Invoice/InvoiceDetail/InvoiceLine">	
			<xsl:text>LINE</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
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
			<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
			<xsl:text>,</xsl:text>
			<!--Measure Indicator-->
			<xsl:text>,</xsl:text>
			<!--Total Measure-->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="InvoicedQuantity"/>
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