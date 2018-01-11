<?xml version="1.0" encoding="UTF-8"?>
<!-- ======================================================
 ETM Group'S CVS AJE, an add-in to import data
 into Sage via custom Excel macro.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright © 2018 Fourth
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Author: Johann Rodríguez <johann.rodriguez@fourth.com>
 Date: 11JAN2018
======================================================= -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:vb="http://www.abs-ltd.com/XSL/VBScript" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:variable name="EOL" select="'&#13;&#10;'"/>
    <xsl:variable name="EOC" select="','"/>
    <xsl:template match="/">
        <xsl:text>Organisation Code,Supplier Code,Supplier Name,Type,Reference,Date,Site Code,Site Name,Category Code,Category Name,Currency,Net,Gross,VAT Code,VAT Percentage</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
    </xsl:template>
    <xsl:template match="BatchDocument">
        <xsl:for-each select="AccrualJournalEntries/AccrualJournalEntriesDetail/AccrualJournalEntriesLine">
            <!-- Organisation Code: OrganisationCode -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../../../../BatchHeader/OrganisationCode"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Supplier Code: SupplierNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/SupplierNominalCode"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Supplier Name: SupplierName -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/SupplierName"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Type: TransactionType -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualsEntryType"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Reference: AccrualReference -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/InvoiceReference"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Date: InvoiceDate -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="vb:FormatDate(string(../../AccrualJournalEntriesHeader/InvoiceDate))"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Site Code: UnitSiteNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/UnitSiteNominal"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Site Name: UnitSiteName -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/UnitSiteName"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Category Code: CategoryNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="CategoryNominal"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Category Name: CategoryName -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="CategoryName"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Currency: CurrencyCode -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../AccrualJournalEntriesHeader/CurrencyCode"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Net: LineNet -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineNet)) != 'NaN'">
                <xsl:value-of select="format-number(LineNet,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Gross: LineGross -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineGross)) != 'NaN'">
                <xsl:value-of select="format-number(LineGross,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- VAT Code: VATCode -->
            <xsl:text>"</xsl:text>
            <xsl:if test="VATCode != 'Not provided'">
                <xsl:value-of select="VATCode"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- VAT Percentage: LineVATPercentage -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineVATPercentage)) != 'NaN'">
                <xsl:value-of select="format-number(LineVATPercentage,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOL"/>
        </xsl:for-each>
    </xsl:template>
    <msxsl:script language='VBScript' implements-prefix="vb">
    <![CDATA[
Function FormatDate(Date)
    Result = ""
    On Error Resume Next
    If Date <> "" Then
        Result = Right("0" & DatePart("d", Date), 2) _
            & "/" & Right("0" & DatePart("m", Date), 2) _ 
            & "/" & DatePart("yyyy", Date)
    End If
    FormatDate = Result
End Function
]]>
    </msxsl:script>
</xsl:stylesheet>