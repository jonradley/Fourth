<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview
 
Giraffe Concepts LTD mapper for invoices and credits journal format.
==========================================================================================
 Date      		| Name 				| Description of modification
==========================================================================================
 21/01/2016	| Jose Miguel	| FB11121 - Created
==========================================================================================
 15/11/2016	| Jose Miguel	| FB11390 - MOD Pizza R9 - IJE integration - CR
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="xsl msxsl js">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	
	<!-- Drive the transformation of the whole file -->
	<xsl:template match="/">
		<!-- Main headers -->
		<xsl:text>AccountNumber,CBAccountNumber,DaysDiscountValid,DiscountValue,DiscountPercentage,DueDate,GoodsValueInAccountCurrency,PurControlValueInBaseCurrency,DocumentToBaseCurrencyRate,DocumentToAccountCurrencyRate,PostedDate,QueryCode,TransactionReference,SecondReference,Source,SysTraderTranType,TransactionDate,UniqueReferenceNumber,UserNumber,TaxValue,SYSTraderGenerationReasonType,GoodsValueInBaseCurrency,</xsl:text>
		<!-- Three static Category headers groups -->
		<xsl:text>NominalAnalysisTransactionValue/1,NominalAnalysisNominalAccountNumber/1,NominalAnalysisNominalCostCentre/1,NominalAnalysisNominalDepartment/1,NominalAnalysisNominalAnalysisNarrative/1,NominalAnalysisTransactionAnalysisCode/1,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/2,NominalAnalysisNominalAccountNumber/2,NominalAnalysisNominalCostCentre/2,NominalAnalysisNominalDepartment/2,NominalAnalysisNominalAnalysisNarrative/2,NominalAnalysisTransactionAnalysisCode/2,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/3,NominalAnalysisNominalAccountNumber/3,NominalAnalysisNominalCostCentre/3,NominalAnalysisNominalDepartment/3,NominalAnalysisNominalAnalysisNarrative/3,NominalAnalysisTransactionAnalysisCode/3,</xsl:text>
		<!-- Taxes Headers -->
		<xsl:text>TaxAnalysisTaxRate/1,TaxAnalysisGoodsValueBeforeDiscount/1,TaxAnalysisDiscountValue/1,TaxAnalysisDiscountPercentage/1,TaxAnalysisTaxOnGoodsValue/1,</xsl:text>
		<xsl:text>TaxAnalysisTaxRate/2,TaxAnalysisGoodsValueBeforeDiscount/2,TaxAnalysisDiscountValue/2,TaxAnalysisDiscountPercentage/2,TaxAnalysisTaxOnGoodsValue/2,</xsl:text>
		<xsl:text>TaxAnalysisTaxRate/3,TaxAnalysisGoodsValueBeforeDiscount/3,TaxAnalysisDiscountValue/3,TaxAnalysisDiscountPercentage/3,TaxAnalysisTaxOnGoodsValue/3,</xsl:text>
		
		<!-- Trailer Header -->
		<xsl:text>ChequeCurrencyName,ChequeToBankExchangeRate,ChequeValueInChequeCurrency</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>

<!-- Drive the transformation of each transation individually -->	
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader"/>
		
		<!-- Process each transaction -->		
		<xsl:for-each select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail">
			<!-- Categories breakdown -->
			<!-- Create columns for Food -->
			<xsl:call-template name="createCategoryLine">
				<xsl:with-param name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:with-param name="currentCategoryNominal" select="14050"/>
			</xsl:call-template>				
			<!-- Create columns for Beverage -->
			<xsl:call-template name="createCategoryLine">
				<xsl:with-param name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:with-param name="currentCategoryNominal" select="14010"/>
			</xsl:call-template>
			<!-- Create columns for Non-Food -->
			<xsl:call-template name="createCategoryLine">
				<xsl:with-param name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
				<xsl:with-param name="currentCategoryNominal" select="14075"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- Taxes breakdown -->
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail" mode="tax"/>
		<!-- Trailing columns -->
		<!-- A ChequeCurrencyName = (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- B ChequeToBankExchangeRate = (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- C ChequeValueInChequeCurrency = (Always blank field). -->
		<xsl:text>&#13;&#10;</xsl:text>		
	</xsl:template>
		
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>

	<xsl:template match="InvoiceCreditJournalEntriesHeader">
		<!-- A AccountNumber = Customer Account NumberPLEASE NOTE - Where Supplier Nominal Codes have not been entered into fnb manager at Site Level, fields will be left blank. -->
		<xsl:value-of select="SupplierNominalCode"/>
		<xsl:text>,</xsl:text>
		<!-- B CBAccountNumber = Account NumberAlways (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- C DaysDiscountValid = Days Discount Valid(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- D DiscountValue = Discount Value (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- E DiscountPercentage = Discount Percentage (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- F DueDate = Due Date(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- G GoodsValueInAccountCurrency = Account Currency ValueTransaction (Invoice not Delivery) Gross Total. -->
		<xsl:value-of select="sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross)"/>
		<xsl:text>,</xsl:text>
		<!-- H PurControlValueInBaseCurrency = Control Base Currency Value(Always blank field). -->
		<xsl:value-of select="sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross)"/>
		<xsl:text>,</xsl:text>
		<!-- I DocumentToBaseCurrencyRate = Base Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- J DocumentToAccountCurrencyRate = Account Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- K PostedDate = ExportRunDate - dd/mm/yyyy -->
		<xsl:value-of select="js:getFormattedDate(string(ExportRunDate))"/>
		<xsl:text>,</xsl:text>
		<!-- L QueryCode = Query Code(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- M TransactionReference = Transaction Invoice Number. -->
		<xsl:value-of select="InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<!-- N SecondReference = Delivery Note Number(can be blank if none entered into fnb). -->
		<!--<xsl:value-of select="DeliveryReference"/> -->
		<xsl:text>,</xsl:text>
		<!-- O Source = . -->
		<xsl:text>2</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- P SysTraderTranType = Transaction TypeShow "4" for Invoices, show "5" for Credit Notes. -->
		<xsl:choose>
			<xsl:when test="TransactionType='INV'"><xsl:text>4</xsl:text></xsl:when>
			<xsl:when test="TransactionType='CRN'"><xsl:text>5</xsl:text></xsl:when>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- Q TransactionDate = Transaction Effective Date -->
		<xsl:value-of select="js:getFormattedDate(string(InvoiceDate))"/>
		<xsl:text>,</xsl:text>
		<!-- R UniqueReferenceNumber = Unique Reference(Always blank field) -->
		<xsl:text>,</xsl:text>
		<!-- S UserNumber = User Number(Always blank field) -->
		<xsl:text>,</xsl:text>
		<!-- T TaxValue = Transaction (Invoice not Delivery) Tax Total -->
		<xsl:value-of select="sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT)"/>
		<xsl:text>,</xsl:text>
		<!-- U SYSTraderGenerationReasonType = Reason Type(Always blank field). -->
    <xsl:text>0</xsl:text>
    <xsl:text>,</xsl:text>
		<!-- V GoodsValueInBaseCurrency = Base Currency ValueTransaction (Invoice not Delivery) Net Total. -->
		<xsl:value-of select="sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineNet)"/>
		<xsl:text>,</xsl:text>
	</xsl:template>

	<!-- Create a category nominal -->
	<xsl:template name="createCategoryLine">
	<xsl:param name="currentDocReference"/>
	<xsl:param name="currentCategoryNominal"/>
	<!-- A NominalAnalysisTransactionValue = Category (Invoice not Delivery) Net Split Amount - Per Category Nominal Code & Tax Code per transaction on the same row. - SEE NOTE -->
	<xsl:value-of select="sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet)"/>
	<xsl:text>,</xsl:text>
	<!-- B NominalAnalysisNominalAccountNumber = Category / Item Type / Cost Center Nominal Split Code - SEE NOTE -->
	<xsl:value-of select="$currentCategoryNominal"/>
	<xsl:text>,</xsl:text>
	<!-- C NominalAnalysisNominalCostCentre = Category Split Cost Centre - fnb manager Site Nominal Code (can be blank if none entered). -->
	<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
	<!--<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/BuyersSiteCode"/> -->
	<xsl:text>,</xsl:text>
	<!-- D NominalAnalysisNominalDepartment = Category Split Department - (Always blank field). -CR - ADM -->
	<xsl:text>BS</xsl:text>
	<xsl:text>,</xsl:text>
	<!-- E NominalAnalysisNominalAnalysisNarrative = Category Split - Analysis Narrative - Supplier Name. -->
	<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/SupplierNominalCode"/>
	<xsl:text>,</xsl:text>
	<!-- F NominalAnalysisTransactionAnalysisCode = Category Split - Analysis Code  - (Always blank field). -->
	<xsl:text>,</xsl:text>
	</xsl:template>
    
   	<!-- Process the VATCode trailer columns -->
	<xsl:template match="InvoiceCreditJournalEntriesDetail" mode="tax">
		<!-- A TaxAnalysisTaxRate =  Standard (S = 20%) Tax Code MappingAlways show "1" (for Standard (S = 20%) Tax Rate) in this column. -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- B TaxAnalysisGoodsValueBeforeDiscount = Standard Rate (S = 20% )  -->
		<xsl:value-of select="sum(InvoiceCreditJournalEntriesLine[VATCode='S']/LineNet)"/>
		<xsl:text>,</xsl:text>
		<!-- C TaxAnalysisDiscountValue = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- D TaxAnalysisDiscountPercentage = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- E TaxAnalysisTaxOnGoodsValue = Standard (S) Tax ValueTax value per S Tax Letter split,.-->
		<xsl:value-of select="sum(InvoiceCreditJournalEntriesLine[VATCode='S']/LineVAT)"/>
	  <xsl:text>,</xsl:text>
		<!-- A TaxAnalysisTaxRate = Zero Rated (Z = 0%) Tax Code MappingAlways show "9" (for Exempt (Z = 0%) Tax Rate) in this column.  -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- B TaxAnalysisGoodsValueBeforeDiscount	= Zero Rated (Z = 0%) Taxable AmountTaxable amount per Z Tax Letter, per transaction on the same row,or "0" if tax split does not exist. -->
    <xsl:value-of select="sum(InvoiceCreditJournalEntriesLine[VATCode='Z']/LineNet)"/>
		<xsl:text>,</xsl:text>
		<!-- C TaxAnalysisDiscountValue = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- D TaxAnalysisDiscountPercentage = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- E TaxAnalysisTaxOnGoodsValue = Zero Rated (Z ) Tax ValueAlways "0" for this Tax Code Letter. -->
    <xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
   	<!-- A TaxAnalysisTaxRate = Exempt (E = 0%) Tax Code MappingAlways show "0" (for Exempt (E = 0%) Tax Rate) in this column. -->
		<xsl:text>2</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- B TaxAnalysisGoodsValueBeforeDiscount = Exempt Rate (E = 0%) Taxable AmountTaxable amount per E Tax Letter, per transaction on the same row,or "0" if tax split does not exist. -->
    <xsl:value-of select="sum(InvoiceCreditJournalEntriesLine[VATCode='E']/LineNet)"/>
		<xsl:text>,</xsl:text>
		<!-- C TaxAnalysisDiscountValue = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- D TaxAnalysisDiscountPercentage = Discount ValueAlways "0". -->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- E TaxAnalysisTaxOnGoodsValue = Exempt (E ) Tax ValueAlways "0" for this Tax Code Letter.  -->
    <xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>

  </xsl:template>

	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
	function right (str, count)
	{
		return str.substring(str.length - count, str.length);
	}
	
	function pad2 (str)
	{
		return right('0' + str, 2);
	}
	
	function addYearsMonthsDays (string_date, years, months, days)
	{
		var parts = string_date.split("-")
		if (parts.length != 3) return 'Error in date :' + string_date;

		var year = parseInt(parts[0], 10);
		var month = parseInt(parts[1], 10);
		var day = parseInt(parts[2], 10);
		
		var date = new Date(year + years, month + months, day + days)
		
		return pad2(date.getDate()) + '/' + pad2(date.getMonth()) + '/' + date.getFullYear()
	}
	
	function getFormattedDate(input) 
	{
		var pattern = /(.{4})-(.{2})-(.{2})$/;
		var result = input.replace(pattern, function(match, p1, p2, p3)
			{
				return p3 + "/" + p2 + "/" + p1;
			}
		);
		return result;
	}
	
	var numTotalCategoryNominals = 0;
	var numCurrentCategoryNominals = 0;
	
	function addTotalCategoryNominal ()
	{
		numTotalCategoryNominals ++;
		return "";
	}
	
	function addCurrentCategoryNominal ()
	{
		numCurrentCategoryNominals ++;
		return "";
	}
	function resetCurrentCategoryNominals ()
	{
		numCurrentCategoryNominals = 0;
		return "";
	}
	
	function insertEmptyCategoryNominals ()
	{
		var c;
		var result = "";
		for (c = numCurrentCategoryNominals; numCurrentCategoryNominals < numTotalCategoryNominals; numCurrentCategoryNominals++)
		{
			result += ",,,,,,";
		}
		numCurrentCategoryNominals = 0;
		return result;
	}
]]></msxsl:script>
</xsl:stylesheet>
