<?xml version="1.0" encoding="UTF-8"?>
<!--================================================================================================================================================================================
 Overview: Standard Fourth Invoice Journal Export

 © Fourth 
====================================================================================================================================================================================
 Module History
====================================================================================================================================================================================
 Version		| 
====================================================================================================================================================================================
 Date      		| Name 			| Description of modification
====================================================================================================================================================================================
 12-04-2017		| M Dimant		| FB 11678: Created. Standard Invoice and Credit export to convert back to the CSV flat file
====================================================================================================================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>


		<xsl:template match="Batch">
		<!-- Column Header line -->
		<xsl:text>Record Type,OrganisationCode,SourceSystemExportID,FormatCode,SourceSystemOrgID,AccountingSystemCode </xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<!-- B -->
		<xsl:text>B</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- OrganisationCode -->
		<xsl:value-of select="js:quote(/Batch/BatchHeader/OrganisationCode)"/>
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
		<!-- AccountingSystemCode (same as OrganisationCode) -->
		<xsl:value-of select="js:quote(string(/Batch/BatchHeader/OrganisationCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Trailing commas -->
		<xsl:text>,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		
		<!-- Column Header line -->
		<xsl:text>RecordType,BuyersUnitCode,BuyersSiteCode,BuyerName,RegionName,SiteBrand,SiteClosingStockField,VATAccountCode,TransactionType,InvoiceReference,DeliveryReference,VoucherNumber,FnBInternalRef,TransactionDescription,BuyersCodeForSupplier,SupplierName,DeliveryDate,InvoiceDate,CustomFinancialYear,CustomFinancialPeriod,StockFinancialYear,StockFinancialPeriod,ExportRunDate,Amount,ConversionCode,ConvertedAmount,VATCode,LineVATPercentage,LineNet,LineVAT,LineGross,CostCentreName,CategoryCode1,CategoryCode2,CategoryCode3,CategoryCode4,CreatedBy,SupplierNominalCode,CategoryName,CategoryNominal,CurrencyCode,UnitSiteName,UnitSiteNominal</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="/Batch/BatchDocuments/BatchDocument/InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine"/>

	</xsl:template>
	
	<xsl:template match="InvoiceCreditJournalEntriesLine">
		<!-- E -->
		<xsl:text>E</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersUnitCode -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersSiteCode -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/BuyersSiteCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyerName -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/BuyerName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- RegionName -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/RegionName))"/>
		<xsl:value-of select="$FieldSeperator"/>		
		<!-- SiteBrand -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/SiteBrand))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SiteClosingStockField -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/SiteClosingStockField))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VATAccountCode -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/VATAccountCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TransactionType -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/TransactionType))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- InvoiceReference -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/InvoiceReference))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- DeliveryReference -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/DeliveryReference))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VoucherNumber -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/VoucherNumber))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- FnBInternalRef -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/FnBInternalRef))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- TransactionDescription -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/TransactionDescription))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- BuyersCodeForSupplier -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/BuyersCodeForSupplier))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SupplierName -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/SupplierName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- DeliveryDate -->
		<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/DeliveryDate, '-', '')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- InvoiceDate -->
		<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/InvoiceDate, '-', '')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CustomFinancialYear -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/CustomFinancialYear))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CustomFinancialPeriod -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/CustomFinancialPeriod))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialYear -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/StockFinancialYear))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- StockFinancialPeriod -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/StockFinancialPeriod))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- ExportRunDate -->
		<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/ExportRunDate, '-', '')"/>
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
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/CreatedBy))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- SupplierNominalCode -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryName -->
		<xsl:value-of select="js:quote(string(CategoryName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CategoryNominal -->
		<xsl:value-of select="js:quote(string(CategoryNominal))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- CurrencyCode -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/CurrencyCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- UnitSiteName -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/UnitSiteName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- UnitSiteNominal -->
		<xsl:value-of select="js:quote(string(../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal))"/>
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
