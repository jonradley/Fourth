<?xml version="1.0" encoding="UTF-8"?>
<!--
=======================================================================================================
Overview

The Seafood Restaurant (Padstow Ltd) (38705) mapper for invoices and credits journal format.
=======================================================================================================
 Date      		| Name 		| Description of modification
=======================================================================================================
31/08/2017		| W Nassor	| FB11930 - Created
*******************************************************************************************************
05/06/2018 		| W Nassor 	| FB12878 - Amendments/Changes - Removed all descrepency lines from export
*******************************************************************************************************
08/06/2018		| W Nassor	| FB12878 - Added Custom Tax Code (5%)
*******************************************************************************************************
01/08/2018		| M Dimant	| FB12878 - Various Amendments - add missing headers and remove empty spaces
=======================================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="#default xsl msxsl js">

	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	<xsl:key name="keyVATCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', VATCode)" />
	
	<!-- Drive the transformation of the whole file -->
	<xsl:template match="/">
	
		<!-- Main headers -->
<xsl:text>AccountNumber,CBAccountNumber,DaysDiscountValid,DiscountValue,DiscountPercentage,DueDate,GoodsValueInAccountCurrency,PurControlValueInBaseCurrency,DocumentToBaseCurrencyRate,DocumentToAccountCurrencyRate,PostedDate,QueryCode,TransactionReference,SecondReference,Source,SYSTraderTranType,TransactionDate,UniqueReferenceNumber,UserNumber,TaxValue,SYSTraderGenerationReasonType,GoodsValueInBaseCurrency,</xsl:text>
		
		<!-- Calculate the maximum number of categories : Always 5 categories-->
		<xsl:text>NominalAnalysisTransactionValue/1,NominalAnalysisNominalAccountNumber/1,NominalAnalysisNominalCostCentre/1,NominalAnalysisNominalDepartment/1,NominalAnalysisNominalAnalysisNarrative/1,NominalAnalysisTransactionAnalysisCode/1,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/2,NominalAnalysisNominalAccountNumber/2,NominalAnalysisNominalCostCentre/2,NominalAnalysisNominalDepartment/2,NominalAnalysisNominalAnalysisNarrative/2,NominalAnalysisTransactionAnalysisCode/2,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/3,NominalAnalysisNominalAccountNumber/3,NominalAnalysisNominalCostCentre/3,NominalAnalysisNominalDepartment/3,NominalAnalysisNominalAnalysisNarrative/3,NominalAnalysisTransactionAnalysisCode/3,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/4,NominalAnalysisNominalAccountNumber/4,NominalAnalysisNominalCostCentre/4,NominalAnalysisNominalDepartment/4,NominalAnalysisNominalAnalysisNarrative/4,NominalAnalysisTransactionAnalysisCode/4,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/5,NominalAnalysisNominalAccountNumber/5,NominalAnalysisNominalCostCentre/5,NominalAnalysisNominalDepartment/5,NominalAnalysisNominalAnalysisNarrative/5,NominalAnalysisTransactionAnalysisCode/5,</xsl:text>
		<xsl:text>NominalAnalysisTransactionValue/6,NominalAnalysisNominalAccountNumber/6,NominalAnalysisNominalCostCentre/6,NominalAnalysisNominalDepartment/6,NominalAnalysisNominalAnalysisNarrative/6,NominalAnalysisTransactionAnalysisCode/6,</xsl:text>
		
		<!-- Taxes : always ten taxes groups -->
		<xsl:text>TaxAnalysisTaxRate/1,TaxAnalysisGoodsValueBeforeDiscount/1,TaxAnalysisDiscountValue/1,TaxAnalysisDiscountPercentage/1,TaxAnalysisTaxOnGoodsValue/1,</xsl:text>
		<xsl:text>TaxAnalysisTaxRate/2,TaxAnalysisGoodsValueBeforeDiscount/2,TaxAnalysisDiscountValue/2,TaxAnalysisDiscountPercentage/2,TaxAnalysisTaxOnGoodsValue/2,</xsl:text>
		
		<xsl:text>TaxAnalysisTaxRate/3,TaxAnalysisGoodsValueBeforeDiscount/3,TaxAnalysisDiscountValue/3,TaxAnalysisDiscountPercentage/3,TaxAnalysisTaxOnGoodsValue/3,</xsl:text>
		
		<!-- Trailer -->
		<xsl:text>ChequeCurrencyName,ChequeToBankExchangeRate,ChequeValueInChequeCurrency</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	
	<!-- Drive the transformation of each transation individually -->
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader"/>
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail" mode="category"/>
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
		<!-- A  -->
		<!-- AccountNumber = Customer Account Number PLEASE NOTE - Where Supplier Nominal Codes have not been entered into fnb manager at Site Level, fields will be left blank. -->
		<xsl:value-of select="SupplierNominalCode"/>
		<xsl:text>,</xsl:text>
		<!-- B -->
		<!-- CBAccountNumber = Account NumberAlways Blank. -->
		<xsl:text>,</xsl:text>
		<!-- C -->
		<!-- DaysDiscountValid = Days Discount Valid(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- D -->
		<!-- DiscountValue = Discount Value(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- E -->
		<!-- DiscountPercentage = Discount Percentage (Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- F -->
		<!-- DueDate = Due Date(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- G -->
		<!-- GoodsValueInAccountCurrency = Account Currency ValueTransaction (Invoice not Delivery) Gross Total. -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross), '##.##')"/>

		<xsl:text>,</xsl:text>
		<!-- H -->
		<!-- PurControlValueInBaseCurrency = Control Base Currency Value -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross), '##.##')"/>
		<xsl:text>,</xsl:text>
		<!-- I -->
		<!-- DocumentToBaseCurrencyRate = Base Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- J -->
		<!-- DocumentToAccountCurrencyRate = Account Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- K -->
		<!-- PostedDate = File Exported Date - FORMAT PENDING dd/mm/yy -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="ExportRunDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<!-- L -->
		<!-- QueryCode = Query Code(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- M -->
		<!-- TransactionReference = Transaction Invoice Number(or Delivery Note Number if blank). -->
		<xsl:value-of select="UnitSiteNominal"/>
		<xsl:text>,</xsl:text>
		<!-- N -->
		<!-- SecondReference - Always blank -->
		<xsl:choose>
			<xsl:when test="InvoiceReference">
				<xsl:value-of select="InvoiceReference"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="DeliveryReference"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- O -->
		<!-- Source = SourceAlways "8". -->
		<xsl:text>8</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- P -->
		<!-- SysTraderTranType = Transaction TypeShow "4" for Invoices, show "5" for Credit Notes. -->
		<xsl:choose>
			<xsl:when test="TransactionType='INV'">
				<xsl:text>4</xsl:text>
			</xsl:when>
			<xsl:when test="TransactionType='CRN'">
				<xsl:text>5</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- Q -->
		<!-- TransactionDate = Transaction Effective Date  - FORMAT PENDING dd/mm/yy -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<!-- R -->
		<!-- UniqueReferenceNumber = Unique Reference(Always blank field) -->
		<xsl:text>,</xsl:text>
		<!-- S -->
		<!-- UserNumber = User Number(Always blank field) -->
		<xsl:text>,</xsl:text>
		<!-- T -->
		<!-- TaxValue = Transaction (Invoice not Delivery) Tax Total -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT), '##.##')"/>
		<xsl:text>,</xsl:text>
		<!-- U -->
		<!-- SYSTraderGenerationReasonType = Reason Type(Always blank field). -->
		<xsl:text>,</xsl:text>
		<!-- V -->
		<!-- GoodsValueInBaseCurrency = Base Currency ValueTransaction Line Net Total. -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineNet), '##.##')"/>
		<xsl:text>,</xsl:text>
	</xsl:template>
	
	<!-- Process the detail group the lines by Nominal Code and then by VATCode -->
	
		<xsl:template match="InvoiceCreditJournalEntriesDetail" mode="category">
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:value-of select="js:resetCurrentCategoryNominals()"/>
		
		
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			
			<xsl:if test="CostCentreName != 'Discrepancy'">
			
				<!-- W NominalAnalysisTransactionValue = Category (Invoice not Delivery) Net Split Amount - Per Category Nominal Code & Tax Code per transaction on the same row. - SEE NOTE -->
				<xsl:variable name="NominalNet">
					<xsl:value-of select="format-number(sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet), '##.##')"/>
				</xsl:variable>
				<xsl:variable name="DiscrepencyNet">
					<xsl:choose>
						<xsl:when test="../InvoiceCreditJournalEntriesLine/CostCentreName = 'Discrepancy'">
							<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[CostCentreName = 'Discrepancy']/LineNet), '##.##')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="0.00"/>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:variable>	
				<xsl:choose>
					<!-- Add the sum of all discrepency lines only to the first Category Net value-->
					<xsl:when test="count(preceding-sibling::InvoiceCreditJournalEntriesLine[CostCentreName != 'Discrepancy']) = 0">
						<xsl:value-of select="format-number($NominalNet + $DiscrepencyNet,'##.##')"/>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="format-number($NominalNet,'##.##')"/></xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				<!-- X NominalAnalysisNominalAccountNumber = Category / Item Type / Cost Center Nominal Split Code - SEE NOTE -->
				<xsl:value-of select="$currentCategoryNominal"/>
				<xsl:text>,</xsl:text>
				<!-- Y NominalAnalysisNominalCostCentre = Category Split Cost Centre - fnb manager Site Nominal Code (can be blank if none entered). -->
				<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
				<xsl:text>,</xsl:text>
				<!-- Z NominalAnalysisNominalDepartment = Category Split Department - (Always blank field). -CR - ADM -->
				<xsl:text>,</xsl:text>
				<!-- AA NominalAnalysisNominalAnalysisNarrative = Category Split - Analysis Narrative - Supplier Name. -->
				<xsl:text>,</xsl:text>
				<!-- AB NominalAnalysisTransactionAnalysisCode = Category Split - Analysis Code  - (Always blank field). -->
				<xsl:text>,</xsl:text>
				<xsl:value-of select="js:addCurrentCategoryNominal()"/>
			</xsl:if>
		</xsl:for-each>
		
		<!-- insert remaining empty category nominal as needed to complete all allocated ones -->
		<xsl:value-of select="js:insertEmptyCategoryNominals()"/>	
			
		</xsl:template>
		
		
		<!-- PROCESS THE VAT TRAILER COLUMNS -->
		<xsl:template match="InvoiceCreditJournalEntriesDetail" mode="tax">	
				
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyVATCode',concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', VATCode))[1])]">

		
		<xsl:variable name="currentVATCode" select="VATCode"/>		
		<!-- TAX RATE -->
		<!-- BG TaxAnalysisTaxRate (1) - Set Tax Code as required -->
		<xsl:choose>
			<xsl:when test="$currentVATCode ='Z'">
				<xsl:text>0</xsl:text>
			</xsl:when>
			<xsl:when test="$currentVATCode ='S'">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="$currentVATCode ='A'">
				<xsl:text>9</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$currentVATCode"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- BH TaxAnalysisGoodsValueBeforeDiscount -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[VATCode = $currentVATCode]/LineNet), '##.##')"/>	
		<xsl:text>,</xsl:text>
		<!-- BI TaxAnalysisDiscountValue = Discount Value Always Blank. -->
		<xsl:text>,</xsl:text>
		<!-- BJ TaxAnalysisDiscountPercentage = Discount Value Always Blank. -->
		<xsl:text>,</xsl:text>
		<!-- BK TaxAnalysisTaxOnGoodsValue  -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[VATCode = $currentVATCode]/LineVAT), '##.##')"/>
		<xsl:text>,</xsl:text>	
		

		</xsl:for-each>	
		
	</xsl:template>
	
	<msxsl:script implements-prefix="js"><![CDATA[ 
	var numTotalCategoryNominals = 6;
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
