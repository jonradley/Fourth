<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Honest Burgers (56737) mapper for invoices and credits journal format.
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 12/07/2018	| Warith Nassor	| FB12245 - Created. Honest Burgers (56737) mapper for invoices and credits journal format. - Sage 200
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
	
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	
	<!-- Drive the transformation of the whole file -->
	
	<xsl:template match="/">
	
	<!-- Main headers -->
<xsl:text>AccountNumber,TransactionDate,TransactionReference,SecondReference,GoodsValueInAccountCurrency,TaxValue,DocumentToBaseCurrencyRate,DocumentToAccountCurrencyRate,SYSTraderTranType,</xsl:text>
		
		<!-- Calculate the maximum number of categories : Always 5 categories-->
		<xsl:text>NominalAnalysisNominalAccountNumber/1,NominalAnalysisNominalCostCentre/1,NominalAnalysisNominalDepartment/1,NominalAnalysisTransactionValue/1,NominalAnalysisNominalAnalysisNarrative/1,TaxAnalysisTaxRate/1,TaxAnalysisGoodsValueBeforeDiscount/1,TaxAnalysisTaxOnGoodsValue/1,</xsl:text>
<xsl:text>NominalAnalysisNominalAccountNumber/2,NominalAnalysisNominalCostCentre/2,NominalAnalysisNominalDepartment/2,NominalAnalysisTransactionValue/2,NominalAnalysisNominalAnalysisNarrative/2,TaxAnalysisTaxRate/2,TaxAnalysisGoodsValueBeforeDiscount/2,TaxAnalysisTaxOnGoodsValue/2,</xsl:text>
<xsl:text>NominalAnalysisNominalAccountNumber/3,NominalAnalysisNominalCostCentre/3,NominalAnalysisNominalDepartment/3,NominalAnalysisTransactionValue/3,NominalAnalysisNominalAnalysisNarrative/3,TaxAnalysisTaxRate/3,TaxAnalysisGoodsValueBeforeDiscount/3,TaxAnalysisTaxOnGoodsValue/3,</xsl:text>
<xsl:text>NominalAnalysisNominalAccountNumber/4,NominalAnalysisNominalCostCentre/4,NominalAnalysisNominalDepartment/4,NominalAnalysisTransactionValue/4,NominalAnalysisNominalAnalysisNarrative/4,TaxAnalysisTaxRate/4,TaxAnalysisGoodsValueBeforeDiscount/4,TaxAnalysisTaxOnGoodsValue/4,</xsl:text>
<xsl:text>NominalAnalysisNominalAccountNumber/5,NominalAnalysisNominalCostCentre/5,NominalAnalysisNominalDepartment/5,NominalAnalysisTransactionValue/5,NominalAnalysisNominalAnalysisNarrative/5,TaxAnalysisTaxRate/5,TaxAnalysisGoodsValueBeforeDiscount/5,TaxAnalysisTaxOnGoodsValue/5,</xsl:text>

<!--Trailer -->
<xsl:text>UserNumber</xsl:text>
		
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>

<!-- Drive the transformation of each transation individually -->	
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader"/>
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail" mode="category"/>
		<!-- Trailing columns -->
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail" mode="trailers"/>
		<xsl:text>&#13;&#10;</xsl:text>
		
	</xsl:template>
		
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>

	<xsl:template match="InvoiceCreditJournalEntriesHeader">
	
		<!-- A  --> <!-- AccountNumber = Supplier Name & SiteCode - Customer Account Number PLEASE NOTE - Where Supplier Nominal Codes and Site Code have not been entered into R9 Inventory at Site Level, fields will be left blank. -->
		<xsl:value-of select="concat(BuyersCodeForSupplier,'.',UnitSiteNominal)"/>
		<xsl:text>,</xsl:text>
		
		<!-- B --> <!-- TransactionDate = Transaction Effective Date  - FORMAT PENDING dd/mm/yy -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="InvoiceDate"/>
		</xsl:call-template> 
		<xsl:text>,</xsl:text>
		
		<!-- C --> <!-- TransactionReference = Transaction Invoice Number(or Delivery Note Number if blank). -->
		<xsl:choose>
			<xsl:when test="InvoiceReference"><xsl:value-of select="InvoiceReference"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="DeliveryReference"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- D --> <!-- SecondReference = Blank. -->
		<xsl:text>,</xsl:text>
		
		<!-- E --> <!-- GoodsValueInAccountCurrency = Account Currency ValueTransaction (Invoice not Delivery) Gross Total. -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineGross), '00.00')"/>
		<xsl:text>,</xsl:text>
	
		<!-- F --> <!-- TaxValue = Transaction (Invoice not Delivery) Tax Total -->
		<xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine/LineVAT), '00.00')"/>
		<xsl:text>,</xsl:text>
		
		<!-- G --> <!-- DocumentToBaseCurrencyRate = Base Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- H --> <!-- DocumentToAccountCurrencyRate = Account Currency RateAlways "1". -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		
		<!-- P --> <!-- SysTraderTranType = Transaction TypeShow "4" for Invoices, show "5" for Credit Notes. -->
		<xsl:choose>
			<xsl:when test="TransactionType='INV'"><xsl:text>4</xsl:text></xsl:when>
			<xsl:when test="TransactionType='CRN'"><xsl:text>5</xsl:text></xsl:when>
		</xsl:choose>
		<xsl:text>,</xsl:text>
	
	</xsl:template>

	<!-- Process the detail group the lines by Nominal Code and then by VATCode -->
	
	<xsl:template match="InvoiceCreditJournalEntriesDetail" mode="category">	
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:value-of select="js:resetCurrentCategoryNominals()"/>
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			
			<!-- NominalAnalysisNominalAccountNumber -->
			<xsl:value-of select="$currentCategoryNominal"/>
			<xsl:text>,</xsl:text>

			<!-- A NominalAnalysisNominalCostCentre = Category Split Cost Centre - fnb manager Site Nominal Code (can be blank if none entered). -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
			<xsl:text>,</xsl:text>
			
			<!-- B NominalAnalysisNominalDepartment =Always Blank -->
			<xsl:text>,</xsl:text>
			
			<!-- C NominalAnalysisTransactionValue = Category (Invoice not Delivery) Net Split Amount - Per Category Nominal Code & Tax Code per transaction on the same row. - SEE NOTE -->
			<xsl:value-of select="format-number(sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet), '00.00')"/>
			<xsl:text>,</xsl:text>
			
			<!-- E NominalAnalysisNominalAnalysisNarrative = Category Split - Analysis Narrative - Supplier Name. -->
			
			
			<xsl:value-of select="concat('PI',' / ',key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/BuyersCodeForSupplier,../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal,'.',key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/CostCentreName)"/>			
			<xsl:text>,</xsl:text>
			
		<!-- TAX SPLIT LINES -->
		
		<!-- A TaxAnalysisTaxRate = VAT Code =  S = 1, Z & E = 2 -->
			
		<xsl:choose>
	<xsl:when test="key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='S']"><xsl:text>1</xsl:text></xsl:when>
	<xsl:when test="key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='Z']"><xsl:text>2</xsl:text></xsl:when>
	<xsl:when test="key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='E']"><xsl:text>2</xsl:text></xsl:when>
	<xsl:otherwise>
	<xsl:text>Unknown</xsl:text>
	</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- B TaxAnalysisGoodsValueBeforeDiscount = Net Invoice Total. -->
		<xsl:choose>
		<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='S'"><xsl:value-of select="format-number(sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='S']/LineNet),'##.##')"/></xsl:when>
		<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='Z'"><xsl:value-of select="format-number(sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='Z']/LineNet),'##.##')"/></xsl:when>
		<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='E'"><xsl:value-of select="format-number(sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/../InvoiceCreditJournalEntriesLine[VATCode='E']/LineNet),'##.##')"/></xsl:when>
		</xsl:choose>		
		<xsl:text>,</xsl:text>
		
		<!-- C TaxAnalysisTaxOnGoodsValue = Calculated VAT per line in the invoice for all Tax codes.  -->
		<xsl:choose>
			<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='Z'"><xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[VATCode='Z']/LineVAT),  '00.00')"/></xsl:when>
			<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='S'"><xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[VATCode='S']/LineVAT),  '00.00')"/></xsl:when>
			<xsl:when test="../InvoiceCreditJournalEntriesLine/VATCode='S'"><xsl:value-of select="format-number(sum(../InvoiceCreditJournalEntriesLine[VATCode='E']/LineVAT),  '00.00')"/></xsl:when>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<xsl:value-of select="js:addCurrentCategoryNominal()"/>
		
		</xsl:for-each>
		
		<!-- insert remaining empty category nominal as needed to complete all allocated ones-->
		<xsl:value-of select="js:insertEmptyCategoryNominals()"/>
		
		</xsl:template>
		
		<xsl:template match="InvoiceCreditJournalEntriesDetail" mode="trailers">
		<!-- A UserNumber = Always Blank-->
		<xsl:text>11</xsl:text>
		<!--<xsl:text>,</xsl:text>-->
	</xsl:template>

<msxsl:script language="javascript" implements-prefix="js">	
	<![CDATA[ 
	var numTotalCategoryNominals = 5;
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
			result += ",,,,,,,,";
		}
		numCurrentCategoryNominals = 0;
		return result;
	}

]]></msxsl:script>
</xsl:stylesheet>
