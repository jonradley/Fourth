<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
Pizza Express Hong Kong mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 24/07/2015	| Jose Miguel	| FB10408 - Pizza Express Hong Kong - R9 - Invoice Export
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="#default xsl msxsl js">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	
	<xsl:template match="/">
		<xsl:text>Vendor ID,Invoice/CM #,Apply to Invoice Number,Credit Memo,Date,Drop Ship,Customer SO#,Waiting on Bill,Customer ID,Customer invoice #,Date Due,Accounts Payable Account,Ship Via,P.O. Note,Note Prints After Line Items,Beginning Balance Transaction,Applied To Purchase Order,Number of Distributions,Invoice/ CM Distribution,Apply to invoice Distribution,PO Number,PO Distribution,Quantity,Item ID,Serial Number,Description,G/L Account,Unit Price,UPC/ SKU,Weight,Amount,Job ID,Used for Reimbursable Expense,Displayed Terms,Return Authorization,Recur Number,Recur Frequency</xsl:text>	
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>
	<xsl:template match="BatchDocument">
		<xsl:apply-templates select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesDetail"/>
	</xsl:template>
		
	<!-- format date from YYYY-MM-DD to DD/MM/YYYY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat( substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>

	<!-- Process the detail group the lines by Nominal Code and then by VATCode -->
	<xsl:template match="InvoiceCreditJournalEntriesDetail">
		<xsl:variable name="currentDocReference" select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
		<xsl:variable name="currentDocTotalLines" select="count(InvoiceCreditJournalEntriesLine)"/>
		
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
			<!-- variables -->
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			<xsl:variable name="currentGroupNet" select="sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet)"/>
			<xsl:variable name="currentGroupTotalLines" select="count(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal)))"/>

			<!-- Output Starts here -->
			<!-- Vendor ID -->
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierName"/>
			<xsl:text>,</xsl:text>
			<!-- Invoice/CM # -->
			<xsl:value-of select="$currentDocReference"/>
			<xsl:text>,</xsl:text>
			<!-- Apply to Invoice Number - BLANK -->
			<xsl:text></xsl:text> 
			<xsl:text>,</xsl:text>
			<!-- Credit Memo -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'INV'"><xsl:text>FALSE</xsl:text></xsl:when>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/TransactionType = 'CRN'"><xsl:text>TRUE</xsl:text></xsl:when>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- Date - Invoice Date -->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			<!-- Drop Ship - FALSE -->
			<xsl:text>FALSE</xsl:text> 
			<xsl:text>,</xsl:text>
			<!-- Customer SO#  - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Waiting on Bill - FALSE -->
			<xsl:text>FALSE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Customer ID -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Customer invoice # - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Date Due - one month later than the invoice date -->
			<xsl:value-of select="js:addDays(string(../../InvoiceCreditJournalEntriesHeader/InvoiceDate), 30)"></xsl:value-of>
			<xsl:text>,</xsl:text>
			<!-- Accounts Payable 20000 -->
			<xsl:text>20000</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Ship Via - Airborne -->
			<xsl:text>Airborne</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- P.O. Note - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Note Prints After Line Items - FALSE -->
			<xsl:text>FALSE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Beginning Balance Transaction - FALSE -->
			<xsl:text>FALSE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Applied To Purchase Order - FALSE -->
			<xsl:text>FALSE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Number of Distributions - total lines in the invoice/credit -->
			<xsl:value-of select="$currentDocTotalLines"/>
			<xsl:text>,</xsl:text>
			<!-- Invoice/ CM Distribution - number of group (by apearance for the reference) -->
			<xsl:value-of select="js:groupNumber(string($currentDocReference), string($currentCategoryNominal))"/>
			<xsl:text>,</xsl:text>
			<!-- Apply to invoice Distribution - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- PO Number - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- PO Distribution - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Quantity - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Item ID - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Serial Number - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Description - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- G/L Account - CategoryNominal -->
			<xsl:value-of select="$currentCategoryNominal"/>
			<xsl:text>,</xsl:text>
			<!-- Unit Price - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- UPC/ SKU - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Weight - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Amount sum of LineNet -->
			<xsl:value-of select="$currentGroupNet"/>
			<xsl:text>,</xsl:text>
			<!-- Job ID - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Used for Reimbursable Expense - FALSE -->
			<xsl:text>FALSE</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Displayed Terms - Net 30 Days -->
			<xsl:text>Net 30 Days</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Return Authorization - BLANK -->
			<xsl:text></xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Recur Number - 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Recur Frequency 0 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
		
			<xsl:text>&#13;&#10;</xsl:text>
    </xsl:for-each>
    </xsl:template>
    
	<msxsl:script implements-prefix="js"><![CDATA[ 
	var docRefs = [];
	
	function groupNumber (docRef, key)
	{
		var counter = docRefs[docRef];
		if (counter == undefined)
		{
			counter = docRefs[docRef] = 0;
		}
		return docRefs[docRef] = ++counter;
	}
	
	function right (str, count)
	{
		return str.substring(str.length - count, str.length);
	}
	
	function pad2 (str)
	{
		return right('0' + str, 2);
	}
	
	function addDays (string_date, days)
	{
		// break 2015-06-11
		var parts = string_date.split("-")
		if (parts.length != 3) return 'Error in date :' + string_date;

		var year = parseInt(parts[0]);
		var month = parseInt(parts[1]);
		var day = parseInt(parts[2]);
		
		var date = new Date(year, month, day + days)
		
		return pad2(date.getDate()) + '/' + pad2(date.getMonth() + 1) + '/' + date.getFullYear()
	}
	
]]></msxsl:script>
</xsl:stylesheet>
