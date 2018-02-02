<?xml version="1.0" encoding="UTF-8"?>
<!-- ======================================================
 CURZON'S CVS AJE FOR EXCELERATOR, an add-in to import
 data into Sage.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright © 2017 Fourth
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Author: Johann Rodríguez <johann.rodriguez@fourth.com>
 Date: 16NOV2017
======================================================= -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:vb="http://www.abs-ltd.com/XSL/VBScript" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:variable name="EOL" select="'&#13;&#10;'"/>
    <xsl:variable name="EOC" select="','"/>
    <xsl:template match="/">
        <xsl:text>Account Reference,Name,Reference,Accrual Date,Due Date,Second Reference,Nominal Code,Cost Centre,Department,VAT Code,VAT Amount,Goods Ammount (Excluding VAT)</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
    </xsl:template>
    <xsl:template match="BatchDocument">
        <xsl:for-each select="AccrualJournalEntries">
            <!-- Account Reference: BuyersCodeForSupplier -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualJournalEntriesHeader/BuyersCodeForSupplier"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Name: SupplierName -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualJournalEntriesHeader/SupplierName"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Reference: InvoiceReference -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualJournalEntriesHeader/InvoiceReference"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Invoice Date: InvoiceDate -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="vb:FormatDate(string(AccrualJournalEntriesHeader/InvoiceDate))"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Due Date: Blank -->
            <xsl:value-of select="$EOC"/>
            <!-- Second Reference: ExportRunDate -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="vb:FormatDate(string(AccrualJournalEntriesHeader/ExportRunDate))"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Nominal Code: Always 4020 -->
            <xsl:text>"4020"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Cost Centre: BuyersUnitCode -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualJournalEntriesHeader/UnitSiteNominal"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Department: BuyersSiteCode -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="AccrualJournalEntriesHeader/BuyersSiteCode"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- VAT Code: Always 1 -->
            <xsl:text>"1"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- VAT Amount: Blank -->
            <xsl:value-of select="$EOC"/>
            <!-- Goods Ammount (Excluding VAT): LineNet -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="format-number(sum(.//AccrualJournalEntriesDetail/AccrualJournalEntriesLine/LineNet),'0.00')"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOL"/>
        </xsl:for-each>
    </xsl:template>
    <msxsl:script language='VBScript' implements-prefix="vb">
        <![CDATA[
Function FormatDate(Date)
    FormatDate = Right("0" & DatePart("d",Date), 2) _
        & "/" & Right("0" & DatePart("m",Date), 2) _ 
        & "/" & DatePart("yyyy",Date)
End Function
]]>
    </msxsl:script>
</xsl:stylesheet>