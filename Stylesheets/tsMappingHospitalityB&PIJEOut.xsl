<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
==========================================================================================
 24/05/2013	| S Hussain 				|	B&P - Invoice Export Mapper | Created
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	<xsl:template match="Batch/BatchDocuments/BatchDocument">
		<!--First Line-->
		<xsl:text>F</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:choose>
			<xsl:when test="string(./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/TransactionType) = 'INV'">
				<xsl:text>INVOICE</xsl:text>
			</xsl:when>
			<xsl:when test="string(./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/TransactionType) = 'CRN'">
				<xsl:text>CREDIT</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Original Invoice Number will always be blank-->
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/SupplierNominalCode"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/SupplierName"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:call-template name="FormatNumber">
			<xsl:with-param name="NumField" select="sum(./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross)"/>
		</xsl:call-template>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:call-template name="FormatNumber">
			<xsl:with-param name="NumField" select="sum(./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineNet)"/>
		</xsl:call-template>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:call-template name="FormatNumber">
			<xsl:with-param name="NumField" select="sum(./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT)"/>
		</xsl:call-template>
		<xsl:value-of select="$RecordSeperator"/>
		<!--VAT Line-->
		<xsl:apply-templates select="./InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">
			<xsl:sort select="./CategoryNominal"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="InvoiceCreditJournalEntriesLine">
		<xsl:variable name="currentVATCode">
			<xsl:value-of select="./VATCode"/>
		</xsl:variable> 
		<xsl:variable name="currentCategoryNominal">
			<xsl:value-of select="./CategoryNominal"/>
		</xsl:variable>
		<xsl:if test="count(preceding-sibling::node()[VATCode = $currentVATCode and CategoryNominal=$currentCategoryNominal]) = 0">
			<xsl:text>V</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<xsl:value-of select="$currentCategoryNominal"/>
			<xsl:value-of select="$FieldSeperator"/>
			<xsl:call-template name="FormatNumber">
				<xsl:with-param name="NumField" select="sum(../InvoiceCreditJournalEntriesLine[VATCode=$currentVATCode and CategoryNominal=$currentCategoryNominal]/LineNet)"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			<xsl:call-template name="FormatNumber">
				<xsl:with-param name="NumField" select="sum(../InvoiceCreditJournalEntriesLine[VATCode=$currentVATCode and CategoryNominal=$currentCategoryNominal]/LineVAT)"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			<xsl:value-of select="$currentVATCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			<xsl:text>UK</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="FormatNumber">
		<xsl:param name="NumField"/>
		<xsl:choose>
			<xsl:when test="number($NumField) != 'NaN'">
				<xsl:value-of select="format-number($NumField, '0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$NumField"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
