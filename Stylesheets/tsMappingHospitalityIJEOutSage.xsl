<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview: sage line 50 mapper for standard exports

 © Fourth 2013
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      		| Name 		| Description of modification
==========================================================================================
 08-10-2013	| S Sehgal     	| FB 7156 / FB 7183 Created
==========================================================================================
           			|                 		|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="/">
		<xsl:text>Type</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Account Reference</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Nominal A/C Ref</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Department Code</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Date</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Reference</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Details</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Net Amount</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Tax Code</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Tax Amount</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Exchange Rate</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Ex Ref</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>User</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="Batch"/>
	</xsl:template>
	<xsl:template match="Batch">
		<xsl:for-each select="BatchDocuments/BatchDocument/InvoiceCreditJournalEntries">
			<xsl:for-each select="InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">
				<xsl:choose>
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='INV'">PI</xsl:when>
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='CRN'">PC</xsl:when>
				</xsl:choose>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="CategoryNominal"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="concat(substring(../../InvoiceCreditJournalEntriesHeader/InvoiceDate,9,2),'/',substring(../../InvoiceCreditJournalEntriesHeader/InvoiceDate,6,2),'/',substring(../../InvoiceCreditJournalEntriesHeader/InvoiceDate,1,4))"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:call-template name="WrapCommaInQuotes">
					<xsl:with-param name="text" select="../../InvoiceCreditJournalEntriesHeader/SupplierName"/>
				</xsl:call-template>
				<xsl:text> delivery</xsl:text>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="LineNet"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="VATCode"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="LineVAT"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:text>1</xsl:text>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/FnBInternalRef"/>
				<xsl:value-of select="$FieldSeperator"/>
				<xsl:call-template name="WrapCommaInQuotes">
					<xsl:with-param name="text" select="../../InvoiceCreditJournalEntriesHeader/CreatedBy"/>
				</xsl:call-template>
				<xsl:value-of select="$RecordSeperator"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="WrapCommaInQuotes">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text,',')">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="$text"/>
				<xsl:text>"</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
