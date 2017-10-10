<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview
 
Gaucho invoices and credits export in Sage Line 500 PSV format.
==========================================================================================
 Date      		| Name 				| Description of modification
==========================================================================================
				| M Dimant			| FB11951 - Created
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="'|'"/>
	<xsl:template match="/">		
		<xsl:apply-templates select="Batch"/>
	</xsl:template>
	<xsl:template match="Batch">
		<xsl:for-each select="BatchDocuments/BatchDocument/InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">
		
				<!-- FnB Internal Ref -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/FnBInternalRef"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Supplier Code -->
				<xsl:choose>
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode">
						<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Supplier Nominal not setup</xsl:text>
					</xsl:otherwise>				
				</xsl:choose>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- For CRN provide INV ref, otherwise for INV provide DN ref -->
				<xsl:choose> 
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='CRN'">
						<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceNumberforCRN"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
					</xsl:otherwise>					
				</xsl:choose>				
				<xsl:value-of select="$FieldSeperator"/>
				<!--  Invoice/Credit Number -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Invoice Date -->
				<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/InvoiceDate,'-','')"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Gross Amount -->
				<xsl:choose>
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='CRN'">
						<xsl:value-of select="-1 * LineGross"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="LineGross"/>
					</xsl:otherwise>					
				</xsl:choose>				
				<xsl:value-of select="$FieldSeperator"/>
				<!-- GL Code/Nominal P-<storecode>-<catnomcode> -->
				<xsl:choose>
					<xsl:when test="CategoryNominal">
						<xsl:value-of select="concat(../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal,'-',CategoryNominal)"/>
					</xsl:when>
					<xsl:otherwise><xsl:text>Category Nominal not setup</xsl:text></xsl:otherwise>
				</xsl:choose>				
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Net Amount -->
				<xsl:choose>
					<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType='CRN'"> 
						<xsl:value-of select="-1 * LineNet"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="LineNet"/>
					</xsl:otherwise>					
				</xsl:choose>				
				<xsl:value-of select="$FieldSeperator"/>		
				<!-- VAT Code -->
				<xsl:value-of select="VATCode"/>			
				<xsl:value-of select="$RecordSeperator"/>			
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
