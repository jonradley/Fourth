<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 itsu mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 03/09/2014	| Jose Miguel		| FB8557 ITSU (r9) - Invoice and Credit Journal Entries Batch
==========================================================================================
 25/11/2015	| Jose Miguel		| FB10628 ITSU - Amend IJE report mapper to shorten column G
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLines" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode)"/>	

	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	
	<xsl:template match="BatchDocument">
		<xsl:for-each select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLines',concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode))[1])]">
			<!-- Store the Account Code-->
			<xsl:variable name="key" select="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode)"/>
			
			<!-- Blank Field -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Vendor Number -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Date -->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Order No.- mapped to Delivery Reference instead -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Vendor Invoice No. -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Branch Code -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Description (Financial Period / Supplier Code / Delivery Date [DDMM]-->
			<xsl:value-of select="concat(../../InvoiceCreditJournalEntriesHeader/CustomFinancialPeriod,'/', ../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier ,'/',concat(substring(../../InvoiceCreditJournalEntriesHeader/DeliveryDate,9,2),substring(../../InvoiceCreditJournalEntriesHeader/DeliveryDate,6,2)))"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!--G/L Account-->
			<xsl:value-of select="CategoryNominal"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- VAT Code -->
			<xsl:choose>
				<xsl:when test="VATCode='Z'">ZERO</xsl:when>
				<xsl:when test="VATCode='S'">VAT20</xsl:when>
				<xsl:otherwise>UNKNOWN</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Net Amount -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'CRN'">
					<xsl:value-of select="format-number(-1 * (sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineNet)),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineNet),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- VAT Amount -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'CRN'">
					<xsl:value-of select="format-number(-1 * (sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineVAT)),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineVAT),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Gross Amount -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'CRN'">
					<xsl:value-of select="format-number(-1 *(sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineGross)),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, '|', CategoryNominal, '|', VATCode) = $key]/LineGross),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Format the date-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>		
		<xsl:value-of select="concat(substring($date,9,2),'/',substring($date,6,2),'/',substring($date,1,4))"/>
	</xsl:template>	
</xsl:stylesheet>
