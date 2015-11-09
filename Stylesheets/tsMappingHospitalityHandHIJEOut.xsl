<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
Harris and Hoole mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 09/11/2015	| Jose Miguel	| FB10590 - Harris and Hoole - R9 - Invoice Export
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#default xsl">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefNominalCodeVATCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal, '|', VATCode)"/>

	<xsl:template match="/">
		<xsl:text>TransactionType,InvoiceReference,InvoiceDate,BuyersSiteCode,DeliveryDate,Category Nominal,LineNet,LineVAT,VATCode,SupplierName,ExportRunDate,DeliveryReference</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail"/>
	</xsl:template>
		
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>

	<!-- Process the detail group the lines by Nominal Code and VATCode -->
	<xsl:template match="InvoiceCreditJournalEntriesDetail">
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefNominalCodeVATCode', concat($currentDocReference, '|', CategoryNominal, '|', VATCode))[1])]">
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			<xsl:variable name="currentVATCode" select="VATCode"/>
			<xsl:variable name="currentGroupVAT"
				 select="sum(key('keyLinesByRefNominalCodeVATCode',concat($currentDocReference, '|', $currentCategoryNominal, '|', $currentVATCode))/LineVAT)"/>
			<xsl:variable name="currentGroupNet"
				 select="sum(key('keyLinesByRefNominalCodeVATCode',concat($currentDocReference, '|', $currentCategoryNominal, '|', $currentVATCode))/LineNet)"/>
			<!-- TransactionType INV or CRN -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/TransactionType"/>
			<xsl:text>,</xsl:text>
			<!-- InvoiceReference -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!-- InvoiceDate -->
			<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/InvoiceDate, '-', '')"/>
			<xsl:text>,</xsl:text>
			<!-- BuyersSiteCode -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersSiteCode"/>
			<xsl:text>,</xsl:text>
			<!-- DeliveryDate -->
			<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/DeliveryDate, '-', '')"/>
			<xsl:text>,</xsl:text>
			<!-- Category Nominal -->
			<xsl:value-of select="$currentCategoryNominal"/>
			<xsl:text>,</xsl:text>
			<!-- LineNet -->
			<xsl:value-of select="$currentGroupNet"/>
			<xsl:text>,</xsl:text>
			<!-- LineVAT -->
			<xsl:value-of select="$currentGroupVAT"/>
			<xsl:text>,</xsl:text>
			<!-- VATCode -->
			<xsl:value-of select="$currentVATCode"/>
			<xsl:text>,</xsl:text>
			<!-- SupplierName -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierName"/>
			<xsl:text>,</xsl:text>
			<!-- ExportRunDate -->
			<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/ExportRunDate, '-', '')"/>
			<xsl:text>,</xsl:text>
			<!-- DeliveryReference -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
