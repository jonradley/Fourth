<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Standard R9 Mapper for Closing Stock Export Export to CSV.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 11/05/2017	| Warith Nassor	| FB11707 - Standard Closing Stock Export to convert this back to the CSV flat file
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="Batch">
		<xsl:apply-templates select="BatchHeader"/>
		<xsl:apply-templates select="BatchDocuments/BatchDocument/ClosingStockJournalEntries"/>
	</xsl:template>
	<xsl:template match="ClosingStockJournalEntries">
		<xsl:apply-templates select="ClosingStockJournalEntriesHeader"/>
		<xsl:apply-templates select="ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine"/>
	</xsl:template>
	<xsl:template match="BatchHeader">
		<!-- Header line -->
		<xsl:text>RecordType,OrganisationCode,SourceSystemExportID,SourceSystemOrgID,FormatCode,OrganisationName,ExportRunDate</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<!-- Record Type - H -->
		<xsl:text>H</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OrganisationCode (infact this was the AccountingSystemCode) -->
		<xsl:value-of select="js:quote(string(OrganisationCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SourceSystemExportID -->
		<xsl:value-of select="js:quote(string(SourceSystemExportID))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SourceSystemOrgID -->
		<xsl:value-of select="js:quote(string(SourceSystemOrgID))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OrganisationName -->
		<xsl:value-of select="js:quote(string(OrganisationName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Export Run Date -->
		<xsl:value-of select="js:quote(string(ExportRunDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Trailing commas -->
		<xsl:text>,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<xsl:template match="ClosingStockJournalEntriesHeader">
		<!-- P Header - Entires Header -->
		<xsl:text>Record Type,BuyersUnitCode,BuyersUnitCode,BuyersSiteName,StockFinancialYear,StockFinancialPeriod,StockPeriodStartDate,StockPeriodEndDate,ApprovedDate,ApprovedBy,CurrencyCode,OpeningStockValue,TotalPurchases,TotalSupplierReturns,TotalSiteTransfersSent,TotalAccountTransfersIn,TotalAccountTransfersOut,ClosingStockValue,ActualCOS,ActualPOS,ActualProfit,ActualCOSPercentage,TheoreticalCOS,TheoreticalCOSPercentage,CostVariance,COSVariancePercentage</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:text>P</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersUnitCode -->
		<xsl:value-of select="js:quote(string(BuyersUnitCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersSiteCode -->
		<xsl:value-of select="js:quote(string(BuyersSiteCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersSiteName -->
		<xsl:value-of select="js:quote(string(BuyersSiteName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialYear -->
		<xsl:value-of select="js:quote(string(StockFinancialYear))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialPeriod -->
		<xsl:value-of select="js:quote(string(StockFinancialPeriod))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockPeriodStartDate -->
		<xsl:value-of select="js:quote(string(StockPeriodStartDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockPeriodEndDate -->
		<xsl:value-of select="js:quote(string(StockPeriodEndDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ApprovedDate -->
		<xsl:value-of select="js:quote(string(ApprovedDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ApprovedBy -->
		<xsl:value-of select="js:quote(string(ApprovedBy))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CurrencyCode -->
		<xsl:value-of select="js:quote(string(CurrencyCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OpeningStockValue -->
		<xsl:value-of select="js:quote(string(OpeningStockValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TotalPurchases -->
		<xsl:value-of select="js:quote(string(TotalPurchases))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TotalSupplierReturns -->
		<xsl:value-of select="js:quote(string(TotalSupplierReturns))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TotalSiteTransfersSent -->
		<xsl:value-of select="js:quote(string(TotalSiteTransfersSent))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TotalAccountTransfersIn -->
		<xsl:value-of select="js:quote(string(TotalAccountTransfersIn))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TotalAccountTransfersOut -->
		<xsl:value-of select="js:quote(string(TotalAccountTransfersOut))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ClosingStockValue -->
		<xsl:value-of select="js:quote(string(ClosingStockValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ActualCOS -->
		<xsl:value-of select="js:quote(string(ActualCOS))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ActualPOS -->
		<xsl:value-of select="js:quote(string(ActualPOS))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ActualProfit -->
		<xsl:value-of select="js:quote(string(ActualProfit))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ActualCOSPercentage -->
		<xsl:value-of select="js:quote(string(ActualCOSPercentage))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TheoreticalCOS -->
		<xsl:value-of select="js:quote(string(TheoreticalCOS))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TheoreticalCOSPercentage -->
		<xsl:value-of select="js:quote(string(TheoreticalCOSPercentage))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CostVariance -->
		<xsl:value-of select="js:quote(string(CostVariance))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- COSVariancePercentage -->
		<xsl:value-of select="js:quote(string(COSVariancePercentage))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<xsl:template match="ClosingStockJournalEntriesLine">
		<!-- D Header - Line Detail -->
		<xsl:text>RecordType,OpeningTotalValue,DeliveredValue,SupplierReturnValue,TrxValue,ClosingValue,UsageValue,POSValue</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:text>D</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OpeningTotalValue -->
		<xsl:value-of select="js:quote(string(OpeningTotalValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- DeliveredValue -->
		<xsl:value-of select="js:quote(string(DeliveredValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SupplierReturnValue -->
		<xsl:value-of select="js:quote(string(SupplierReturnValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TrxValue -->
		<xsl:value-of select="js:quote(string(TrxValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ClosingValue -->
		<xsl:value-of select="js:quote(string(ClosingValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- UsageValue -->
		<xsl:value-of select="js:quote(string(UsageValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- POSValue -->
		<xsl:value-of select="js:quote(string(POSValue))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
function quote (str)
{
	if (str == null) return null;
	
	if (str.indexOf(',') == -1)
	{
		return str;
	}
	else
	{
		return '"'  + str + '"';
	}
}

	]]></msxsl:script>
</xsl:stylesheet>
