<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Pizza Express Hong Kong mapper for closing stocks journal.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 30/07/2015	| Jose Miguel	| 10476 Pizza Express Hong Kong 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	<xsl:template match="/">
		<xsl:text>Date,Reference,ClearBankRec,Distribution,GLAccount,Description,Amount,JobID,Reimbur,Consol</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine"/>
	</xsl:template>
	
	<xsl:template match="BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine">
		<!-- generate the basic line -->
		<xsl:call-template name="generateLine">
			<xsl:with-param name="direction" select="normal"/>
		</xsl:call-template>
		<xsl:value-of select="$RecordSeperator"/>
		<!-- generate the reversed line -->
		<xsl:call-template name="generateLine">
			<xsl:with-param name="direction" select="reversed"/>
		</xsl:call-template>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	
	<xsl:template name="generateLine">
		<xsl:param name="direction"/>
		
		<xsl:variable name="siteCode" select="../../ClosingStockJournalEntriesHeader/BuyersSiteCode"/>
		<xsl:variable name="financialPeriod" select="js:pad(string(../../ClosingStockJournalEntriesHeader/StockFinancialPeriod), 2)"/>
		<xsl:variable name="countNominalCodes" select="count(../ClosingStockJournalEntriesLine/NominalCode)"/>
		
		<!--Date - Header stock period end date -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="../../ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Reference-->
		<xsl:value-of select="concat('Stock adj', $siteCode, 'W',  $financialPeriod)"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--ClearBankRec - BLANK -->
		<xsl:text></xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text></xsl:text>
		<!--Distribution - PENDING -->
		<xsl:value-of select="$countNominalCodes * 2"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--GLAccount -->
		<xsl:value-of select="concat(NominalCode, $siteCode)"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Description-->
		<xsl:text>Total Stocktake Adj for</xsl:text>
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="../../ClosingStockJournalEntriesHeader/StockPeriodStartDate"/>
		</xsl:call-template>
		<xsl:text>-</xsl:text>
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="../../ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
		</xsl:call-template>		
		<xsl:text> W</xsl:text>
		<xsl:value-of select="$financialPeriod"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Amount - ClosingValue -->
		<xsl:value-of select="ClosingValue"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text></xsl:text>
		<!--JobID - BLANK -->
		<xsl:text></xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Reimbur - FALSE -->
		<xsl:text>FALSE</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--Consol-->
		<xsl:text>FALSE</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>	
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
