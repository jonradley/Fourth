<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Standard R9 Mapper for Accruals Journal Export to CSV.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 06/04/2017	| Warith Nassor	| FB11671 - Standard Accuals Mapper to convert this back to the CSV flat file
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
		<xsl:template match="Batch">
		<!-- Header line -->
		<xsl:text>Record Type,OrganisationCode,SourceSystemExportID,FormatCode,SourceSystemOrgID,AccountingSystemCode </xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<!-- B -->
		<xsl:text>B</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OrganisationCode (infact this was the AccountingSystemCode) -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/OrganisationCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SourceSystemExportID -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/SourceSystemExportID))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- FormatCode -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/FormatCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SourceSystemOrgID -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/SourceSystemOrgID))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- AccountingSystemCode left in the OrganisationCode -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/OrganisationCode))"/>
		<xsl:value-of select="$FieldSeperator"/>

		<!-- Trailing commas -->
		<xsl:text>,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:text>Record Type,AccrualType,BuyersUnitCode,BuyersSiteCode,BuyerName,RegionName,SiteBrand,SiteClosingStockField,VATAccountCode,TransactionType,InvoiceReference,DeliveryReference,VoucherNumber,FnBInternalRef,TransactionDescription,BuyersCodeForSupplier,SupplierName,DeliveryDate,InvoiceDate,CustomFinancialYear,CustomFinancialPeriod,StockFinancialYear,StockFinancialPeriod,ExportRunDate,Amount,ConversionCode,ConvertedAmount,VATCode,LineVATPercentage,LineNet,LineVAT,LineGross,CostCentreName,CategoryCode1,CategoryCode2,CategoryCode3,CategoryCode4,CreatedBy,SupplierNominalCode,CategoryName,CategoryNominal,CurrencyCode,UnitSiteName,UnitSiteNominal,AccrualsEntryType</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="//AccrualJournalEntriesLine"/>
	</xsl:template>
	
	<xsl:template match="AccrualJournalEntriesLine">
	<!-- Create E Header Row -->
	<xsl:value-of select="$RecordSeperator"/>
	<!-- Apply transformation --> 
	<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument/AccrualJournalEntries/AccrualJournalEntriesDetail"/>
	<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<xsl:template match="AccrualJournalEntriesLine">
		<!-- E -->
		<xsl:text>E</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- AccrualType -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/AccrualType))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersUnitCode -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/BuyersUnitCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersSiteCode -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/BuyersSiteCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyerName -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/BuyerName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- RegionName -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/RegionName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SiteBrand -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/SiteBrand))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SiteClosingStockField -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/SiteClosingStockField))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VATAccountCode -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/VATAccountCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TransactionType -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/TransactionType))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- InvoiceReference -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/InvoiceReference))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- DeliveryReference -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/DeliveryReference))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VoucherNumber -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/VoucherNumber))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- FnBInternalRef -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/FnBInternalRef))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TransactionDescription -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/TransactionDescription))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersCodeForSupplier -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/BuyersCodeForSupplier))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SupplierName -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/SupplierName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Delivery Date -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/DeliveryDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- InvoiceDate -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/InvoiceDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CustomFinancialYear -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/CustomFinancialYear))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CustomFinancialPeriod -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/CustomFinancialPeriod))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialYear -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/StockFinancialYear))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialPeriod -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/StockFinancialPeriod))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ExportRunDate -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/ExportRunDate))"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- Amount -->
		<xsl:value-of select="js:quote(string(Amount))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ConversionCode -->
		<xsl:value-of select="js:quote(string(ConversionCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ConvertedAmount -->
		<xsl:value-of select="js:quote(string(ConvertedAmount))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VATCode -->
		<xsl:value-of select="js:quote(string(VATCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- LineVATPercentage -->
		<xsl:value-of select="js:quote(string(LineVATPercentage))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- LineNet -->
		<xsl:value-of select="js:quote(string(LineNet))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- LineVAT -->
		<xsl:value-of select="js:quote(string(LineVAT))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- LineGross -->
		<xsl:value-of select="js:quote(string(LineGross))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CostCentreName -->
		<xsl:value-of select="js:quote(string(CostCentreName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryCode1 -->
		<xsl:value-of select="js:quote(string(CategoryCode1))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryCode2 -->
		<xsl:value-of select="js:quote(string(CategoryCode2))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryCode3 -->
		<xsl:value-of select="js:quote(string(CategoryCode3))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryCode4 -->
		<xsl:value-of select="js:quote(string(CategoryCode4))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CreatedBy -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/CreatedBy))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SupplierNominalCode -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/SupplierNominalCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryName -->
		<xsl:value-of select="js:quote(string(CategoryName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryNominal -->
		<xsl:value-of select="js:quote(string(CategoryNominal))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CurrencyCode -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/CurrencyCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- UnitSiteName -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/UnitSiteName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- UnitSiteNominal -->
		<xsl:value-of select="js:quote(string(../../AccrualJournalEntriesHeader/UnitSiteNominal))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- AccrualsEntryType -->
		<xsl:value-of select="js:quote(string(AccrualsEntryType))"/>
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
