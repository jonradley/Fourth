<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 itsu mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 04/03/2015	| Jose Miguel	| FB10169 Create module
=======================================================================================
NOTES:
1) Review pending points
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments"/>
	</xsl:template>
	
	<xsl:template match="BatchDocuments">
		<xsl:variable name="now" select="js:msFileGenerationDateInYYYYMM0DDFormat()"/>
		
		<xsl:for-each select="BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine[NominalCode]">
			<xsl:sort select="NominalCode" order="ascending"/>
			<xsl:variable name="siteCode" select="../../ClosingStockJournalEntriesHeader/BuyersSiteCode"/>
			<!-- 1st half -->
			<!--Posting Date : Last day of stock period: stock period end date-->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../../ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Doc. No. : Custom document number: use mask above set to date of export -->
			<xsl:value-of select="$now"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Account : Hard code '1000' -->
			<xsl:text>1000</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Ext Doc. No. : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Description : "Stock Transfers wk"&<Week No.> -->
			<xsl:value-of select="concat('Stock Transfers wk', StockFinancialYear)"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- VAT Code : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- VAT Prod Post Grp : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- GD1 : Location code: MUST INCLUDE LEADING ZEROS -->
			<xsl:value-of select="format-number(($siteCode), '000')"/>	
			<xsl:value-of select="$FieldSeperator"/>
			<!-- GD2 : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Debit Amount : Stock value, grouped by first level category - PENDING -->
			<xsl:value-of select="format-number((number(OpeningTotalValue)), '####.##')"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Credit Amount :Hard code '0.00'-->
			<xsl:text>0.00</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Bal. Account Type : Hardcode 'G/L Account' -->
			<xsl:text>G/L Account</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Bal. Account No. : BLANK or NULL -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Recurring Method : Hardcode 'RV Reversing Variable' -->
			<xsl:text>RV Reversing Variable</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Recurring Frequency : Hardcode '7D' -->
			<xsl:text>7D</xsl:text>			
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:for-each>

		<xsl:for-each select="BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine[NominalCode]">
			<xsl:sort select="NominalCode" order="ascending"/>
			<xsl:variable name="siteCode" select="../../ClosingStockJournalEntriesHeader/BuyersSiteCode"/>
			<!-- 2nd half -->
			<!--Posting Date : Last day of stock period: stock period end date-->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../../ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Doc. No. : Custom document number: use mask above set to date of export -->
			<xsl:value-of select="$now"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Account : Specific codes for stock #### - check pending -->
			<xsl:value-of select="NominalCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Ext Doc. No. : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Description : "Stock Transfers wk"&<Week No.> -->
			<xsl:value-of select="concat('Stock Transfers wk', StockFinancialYear)"/>
			<xsl:value-of select="$FieldSeperator"/>	
			<!-- VAT Code : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- VAT Prod Post Grp : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- GD1 : Location code: MUST INCLUDE LEADING ZEROS -->
			<xsl:value-of select="format-number(($siteCode), '000')"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- GD2 : Blank -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Debit Amount : Hard code '0.00' -->
			<xsl:text>0.00</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Credit Amount : Stock value, grouped by first level category - PENDING -->
			<xsl:value-of select="format-number((number(OpeningTotalValue)), '####.##')"/>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Bal. Account Type : Hardcode 'G/L Account' -->
			<xsl:text>G/L Account</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Bal. Account No. : BLANK or NULL -->
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Recurring Method : Hardcode 'RV Reversing Variable' -->
			<xsl:text>RV Reversing Variable</xsl:text>
			<xsl:value-of select="$FieldSeperator"/>
			<!-- Recurring Frequency : Hardcode '7D' -->
			<xsl:text>7D</xsl:text>		
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:for-each>		
	</xsl:template>
	
	<!-- Format the date from YYYYMMDD to DD/MM/YYYY-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>		
		<xsl:value-of select="concat(substring($date,7,2),'/',substring($date,5,2),'/',substring($date,1,4))"/>
	</xsl:template>	
	
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
function right (str, count)
{
	return str.substring(str.length - count, str.length);
}

function pad (str, num)
{
	return right('000000' + str, num);
}

/*=========================================================================================
' Routine        : msFileGenerationDate()
' Description    : Gets the date in 'YYMMDD' format and works in all regions and date configurations (UK, US).
' Returns        : A string
' Author         : Jose Miguel
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/
function msFileGenerationDateInYYYYMM0DDFormat ()
{
	var today = new Date();
	var year = today.getYear();
	var month = today.getMonth()+1;
	var day = today.getDate();
	
	
	return '' + pad(year, 4) + pad(month, 2) + '0-' + pad(day, 2);
}
	]]></msxsl:script>
</xsl:stylesheet>
