<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 La Tasca mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 04/03/2015	| Jose Miguel	| FB10292 - Convent Garden Restaurants IJE mapper
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	<xsl:key name="keyLinesByRefNominalAndVATCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', CustomerVATCode)"/>

	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments"/>
	</xsl:template>
	<xsl:template match="BatchDocuments">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader"/>
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail"/>
	</xsl:template>

	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>
	
	<!-- Header information for the invoice / credit note -->
	<xsl:template match="InvoiceCreditJournalEntriesHeader">
		<!-- Supplier Nominal Code -->
		<xsl:value-of select="SupplierNominalCode"/>
		<xsl:text>,</xsl:text>
		<!-- 'Invoice' + space + supplier name -->
		<xsl:value-of select="concat('Invoice ', SupplierName)"/>
		<xsl:text>,</xsl:text>
		<!-- Invoice Date -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<!-- Invoice reference -->
		<xsl:value-of select="InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<!-- Net total -->
		<xsl:value-of select="format-number(-sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineNet),'0.00')"/>
		<xsl:text>,</xsl:text>
		<!-- Blank -->
		<xsl:text>,</xsl:text>
		<!-- Blank -->
		<xsl:text>,</xsl:text>
		<!-- Code -->
		<xsl:value-of select="BuyersSiteCode"/>
		<xsl:text>,</xsl:text>
		<!-- Nominal Code -->
		<xsl:value-of select="UnitSiteNominal"/>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<!-- Process the detail group the lines by Nominal Code and then by VATCode -->
	<xsl:template match="InvoiceCreditJournalEntriesDetail">
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
			<!-- variables -->
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			<!-- for each VATCOde within the current Nominal Code group of the same document -->
			<xsl:for-each select="key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', $currentCategoryNominal))[generate-id() = generate-id(key('keyLinesByRefNominalAndVATCode', concat($currentDocReference, '|', $currentCategoryNominal, '|', CustomerVATCode))[1])]">
				<!-- order the output - check if this is really required -->
				<xsl:sort select="CategoryNominal" data-type="text"/>
				<xsl:sort select="CustomerVATCode" data-type="text"/>
				<xsl:variable name="currentVATCode" select="CustomerVATCode"/>
				<xsl:variable name="currentGroupNet" select="sum(key('keyLinesByRefNominalAndVATCode',concat($currentDocReference, '|', $currentCategoryNominal, '|', $currentVATCode))/LineNet)"/>
				<!-- Category nominal (conditions pending -ask Ali if the condition has to be apply here or also to the grouping) -->
				<xsl:value-of select="$currentCategoryNominal"/>
				<xsl:text>,</xsl:text>
				<!-- Supplier Name -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierName"/>
				<xsl:text>,</xsl:text>
				<!-- Invoice Date  -->
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="../../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
				</xsl:call-template>
				<xsl:text>,</xsl:text>
				<!-- Invoice reference -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:text>,</xsl:text>
				<!-- Net total for this Category Nominal (and also for this VATrate) -->
				<xsl:value-of select="format-number($currentGroupNet,'0.00')"/>
				<xsl:text>,</xsl:text>
				<!-- VAT rate -->
				<xsl:value-of select="$currentVATCode"/>
				<xsl:text>,</xsl:text>
				<!-- Supplier Code -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier"/>
				<xsl:text>,</xsl:text>
				<!-- Site Code -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersSiteCode"/>
				<xsl:text>,</xsl:text>
				<!-- Nominal Code -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
