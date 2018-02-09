<?xml version="1.0" encoding="UTF-8"?>
<!-- ======================================================
 Generic CSV IJE for Xero, an SaaS accounting package.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Copyright © 2018 Fourth
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Author: Johann Rodríguez <johann.rodriguez@fourth.com>
 Date: 08FEB2018
 Case: 12579
 Notes: Initially created for Paesan and Scarpetta
=========================================================== 
 Module History
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Date      	| Name              | Description
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 14/10/2015	| Johann Rodríguez  | Creation
======================================================= -->
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:vb="http://www.abs-ltd.com/XSL/VBScript" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:variable name="EOL" select="'&#13;&#10;'"/>
    <xsl:variable name="EOC" select="','"/>
    <xsl:template match="/">
        <xsl:text>*ContactName,EmailAddress,POAddressLine1,POAddressLine2,POAddressLine3,POAddressLine4,POCity,PORegion,POPostalCode,POCountry,*InvoiceNumber,*InvoiceDate,*DueDate,Total,InventoryItemCode,Description,*Quantity,*UnitAmount,*AccountCode,*TaxType,TaxAmount,TrackingName1,TrackingOption1,TrackingName2,TrackingOption2,Currency</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
    </xsl:template>
    <xsl:template match="BatchDocument">
        <xsl:for-each select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">
            <!-- *ContactName: SupplierNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- EmailAddress: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POAddressLine1: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POAddressLine2: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POAddressLine3: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POAddressLine4: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POCity: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- PORegion: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POPostalCode: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- POCountry: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *InvoiceNumber: InvoiceReference -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *InvoiceDate: InvoiceDate -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="vb:FormatDate(string(../../InvoiceCreditJournalEntriesHeader/InvoiceDate))"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *DueDate: INVOICEDATE + 30 DAYS! -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="vb:PlusThirtyDays(string(../../InvoiceCreditJournalEntriesHeader/InvoiceDate))"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Total: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- InventoryItemCode: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Description: CategoryName -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="CategoryName"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *Quantity: ALWAYS "1"! -->
            <xsl:text>"1"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *UnitAmount: LineNet -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineNet)) != 'NaN'">
                <xsl:value-of select="format-number(LineNet,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *AccountCode: CategoryNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="CategoryNominal"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- *TaxType: LineVATPercentage -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineVATPercentage)) != 'NaN'">
                <xsl:value-of select="format-number(LineVATPercentage,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- TaxAmount: LineVAT -->
            <xsl:text>"</xsl:text>
            <xsl:if test="string(number(LineVAT)) != 'NaN'">
                <xsl:value-of select="format-number(LineVAT,'0.00')"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- TrackingName1: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- TrackingOption1: UnitSiteNominal -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- TrackingName2: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- TrackingOption2: BLANK! -->
            <xsl:text>""</xsl:text>
            <xsl:value-of select="$EOC"/>
            <!-- Currency: CurrencyCode -->
            <xsl:text>"</xsl:text>
            <xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
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

Function PlusThirtyDays(Date)
    PTD = DateAdd("m", 1, Date)
    PlusThirtyDays = FormatDate(PTD)
End Function
]]>
    </msxsl:script>
</xsl:stylesheet>