<?xml version="1.0" encoding="UTF-8"?>
<!--
************************************************************************************************************************************************************************************
 Overview

************************************************************************************************************************************************************************************
 Module History
************************************************************************************************************************************************************************************
 Date       | Name      | Description of modification
************************************************************************************************************************************************************************************
05/07/2017	| M Dimant	| FB 11934 : Created
************************************************************************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text" encoding="UTF-8"/>
	
<xsl:variable name="FieldSeperator" select="'|'"/>	
<xsl:variable name="LineSeperator" select="'&#13;&#10;'"/>


	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="BatchHeader"/>
	
	<xsl:template match="InvoiceCreditJournalEntries">
	
	<xsl:variable name="Date" select="InvoiceCreditJournalEntriesHeader/ExportRunDate"/>
	<xsl:variable name="RunDate" select="concat(substring($Date,9,2),substring($Date,6,2),substring($Date,1,4))"/>

		<!-- SUMMARY LINE -->
		
		<!-- 1	Company (always SLFRETAIL) -->
		<xsl:text>SLFRETAIL</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 2	Document Code (always PPEX_INV_RES) -->
		<xsl:text>PPEX_INV_RES</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 3	Document Number (1 - Group all associated transactions)  -->
		<xsl:value-of select="format-number(count(preceding::InvoiceCreditJournalEntries)+1,'0000')"/>		
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 4	Currency (GBP) -->	
		<xsl:value-of select="InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 5	Posting (always B) -->	
		<xsl:text>B</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 6	Year	(Leave Blank) – system will default  -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 7	Period	(Leave Blank) – system will default  -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 8	Transaction Date (Current date)  -->
		<xsl:value-of select="$RunDate"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 9	Line Type	(S - Summary) -->
		<xsl:text>S</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 10	Nominal Account	(always 161000) -->
		<xsl:text>161000</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 11	Location (always 1111) -->
		<xsl:text>1111</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 12	El3	VSnnnnnnn – valid Coda supplier  -->
		<xsl:value-of select="InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 13	El4	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 14	El5	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 15	El6	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 16	Transaction Value - Total of all D detail line and T Tax(Gross) -->
		<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross)"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 17	Debit/Credit (always C= Credit) -->
		<xsl:text>C</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 18	Description	-->
		<xsl:text>Fourth Matchable Restaurant Invoice</xsl:text> 
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 19	Ext Ref 1	Scan Invoice Number/Delivery Number -->
		<xsl:value-of select="InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 20	Ext Ref 2	Supplier Invoice Number -->
		<xsl:value-of select="InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 21	Ext Ref 3	Order Number -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 22	Ext Ref 4	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 23	Ext Ref 5	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 24	Due date	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 25	Value date	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 26	Discount Value	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 27	Discount date	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 28	Tax Value (Total Tax of Invoice) -->
		<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT)"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 29	Tax Code (Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 30	Net Value (Difference between Gross and Tax) -->
		<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineNet)"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 31	Quantity	(Leave Blank) -->
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- 32	Quantity dp	(Leave Blank) -->
		<xsl:value-of select="$LineSeperator"/>		
		
		<!-- DETAIL LINE -->
		<xsl:for-each select="InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">
		
			<!-- 1	Company (always SLFRETAIL) -->
			<xsl:text>SLFRETAIL</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 2	Document Code (always PPEX_INV_RES) -->
			<xsl:text>PPEX_INV_RES</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 3	Document Number (1 - Group all associated transactions)  -->
			<xsl:value-of select="format-number(count(preceding::InvoiceCreditJournalEntries)+1,'0000')"/>		
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 4	Currency (GBP) -->	
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 5	Posting (always B) -->	
			<xsl:text>B</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 6	Year	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 7	Period	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 8	Transaction Date (Current date)  -->
			<xsl:value-of select="$RunDate"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 9	Line Type	(D - Detail) -->
			<xsl:text>D</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 10	Nominal Account	(always 233001) -->
			<xsl:text>233001</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 11	Location (unit code) -->
			<xsl:value-of select="substring-after(../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal,'-')"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 12	El3	- Department (Unit Nominal)  -->
			<xsl:value-of select="substring-before(../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal,'-')"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 13	El4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 14	El5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 15	El6	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 16	Transaction Value - Line Value -->
			<xsl:value-of select="LineNet"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 17	Debit/Credit (always D= Debit) -->
			<xsl:text>D</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 18	Description -->
			<xsl:value-of select="CostCentreName"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 19	Ext Ref 1	Scan Invoice Number (blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 20	Ext Ref 2	Supplier Invoice Number -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 21	Ext Ref 3	Delivery Note reference -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 22	Ext Ref 4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 23	Ext Ref 5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 24	Due date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 25	Value date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 26	Discount Value	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 27	Discount date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 28	Tax Value (Total Tax of Invoice) -->
			<xsl:value-of select="LineVAT"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 29	Tax Code -->
			<xsl:choose>
				<xsl:when test="VATCode='Z'">
					<xsl:text>TIZ</xsl:text>
				</xsl:when>
				<xsl:when test="VATCode='S'">
					<xsl:text>TIS</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>VAT Code not recognised (must be Z or S)</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 30	Net Value (Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 31	Quantity	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 32	Quantity dp	(Leave Blank) -->
			<xsl:value-of select="$LineSeperator"/>				
		</xsl:for-each>
		
		
		<!-- TAX LINE For Zero VAT--> 		
                                       
        <xsl:if test="InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/VATCode='Z'">
                                       
			<!-- 1	Company (always SLFRETAIL) -->
			<xsl:text>SLFRETAIL</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 2	Document Code (always PPEX_INV_RES) -->
			<xsl:text>PPEX_INV_RES</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 3	Document Number (1 - Group all associated transactions)  -->
			<xsl:value-of select="format-number(count(preceding::InvoiceCreditJournalEntries)+1,'0000')"/>		
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 4	Currency (GBP) -->	
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 5	Posting (always B) -->	
			<xsl:text>B</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 6	Year	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 7	Period	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 8	Transaction Date (Current date)  -->
			<xsl:value-of select="$RunDate"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 9	Line Type	(T - Tax) -->
			<xsl:text>T</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 10	Nominal Account	(always 171000) -->
			<xsl:text>171000</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 11	Location (always 1111) -->
			<xsl:text>1111</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 12	El3	VSnnnnnnn – Tax Code  -->
			<xsl:text>TIZ</xsl:text>					
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 13	El4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 14	El5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 15	El6	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 16	Transaction Value - Line Value i.e. Tax -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='Z']/LineVAT)"/> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 17	Debit (always D= Debit) -->
			<xsl:text>D</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 18	Description	-->
			<xsl:text>VAT</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 19	Ext Ref 1	Scan Invoice Number -->
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 20	Ext Ref 2	Supplier Invoice Number -->
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 21	Ext Ref 3	Order Number -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 22	Ext Ref 4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 23	Ext Ref 5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 24	Due date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 25	Value date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 26	Discount Value	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 27	Discount date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 28	Tax Value (Total Tax of Invoice) -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='Z']/LineVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 29	Tax Code  -->
			<xsl:text>TIZ</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 30	Net Value (Difference between Gross and Tax) -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='Z']/LineNet)"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 31	Quantity	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 32	Quantity dp	(Leave Blank) -->
			<xsl:value-of select="$LineSeperator"/>
				
		</xsl:if>                        
	
		<!-- TAX LINE For Standard VAT--> 		
                                       
        <xsl:if test="InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/VATCode='S'">
                                       
			<!-- 1	Company (always SLFRETAIL) -->
			<xsl:text>SLFRETAIL</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 2	Document Code (always PPEX_INV_RES) -->
			<xsl:text>PPEX_INV_RES</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 3	Document Number (1 - Group all associated transactions)  -->
			<xsl:value-of select="format-number(count(preceding::InvoiceCreditJournalEntries)+1,'0000')"/>		
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 4	Currency (GBP) -->	
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 5	Posting (always B) -->	
			<xsl:text>B</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 6	Year	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 7	Period	(Leave Blank) – system will default  -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 8	Transaction Date (Current date)  -->
			<xsl:value-of select="$RunDate"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 9	Line Type	(T - Tax) -->
			<xsl:text>T</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 10	Nominal Account	(always 171000) -->
			<xsl:text>171000</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 11	Location (always 1111) -->
			<xsl:text>1111</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 12	El3	VSnnnnnnn – Tax Code  -->
			<xsl:text>TIS</xsl:text>					
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 13	El4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 14	El5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 15	El6	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 16	Transaction Value - Line Value i.e. Tax -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='S']/LineVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 17	Debit (always D= Debit) -->
			<xsl:text>D</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 18	Description	-->
			<xsl:text>VAT</xsl:text> 
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 19	Ext Ref 1	Scan Invoice Number -->
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 20	Ext Ref 2	Supplier Invoice Number -->
			<xsl:value-of select="InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 21	Ext Ref 3	Order Number -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 22	Ext Ref 4	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 23	Ext Ref 5	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 24	Due date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 25	Value date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 26	Discount Value	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 27	Discount date	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 28	Tax Value (Total Tax of Invoice) -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='S']/LineVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 29	Tax Code  -->
			<xsl:text>TIS</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 30	Net Value (Difference between Gross and Tax) -->
			<xsl:value-of select="sum(InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine[VATCode='S']/LineNet)"/>
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 31	Quantity	(Leave Blank) -->
			<xsl:value-of select="$FieldSeperator"/>		
			<!-- 32	Quantity dp	(Leave Blank) -->
			<xsl:value-of select="$LineSeperator"/>
				
		</xsl:if>                        	
	
	</xsl:template>
</xsl:stylesheet>