<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview
 
Huffkins mapper for invoices and credits journal format.
==========================================================================================
 Date      		| Name 				| Description of modification
==========================================================================================
 24/02/2016	| Jose Miguel	|  FB10848 - Created.
==========================================================================================
 10/03/2016	| Jose Miguel	|  FB10869 - Fixes and changes.
==========================================================================================
 25/04/2016	| Jose Miguel	|  FB10934 - Adding support for CRN.
=========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="#default xsl msxsl js">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	
	<!-- Drive the transformation of the whole file -->
	<xsl:template match="/">
		<xsl:text>*ContactName,EmailAddress,POAddressLine1,POAddressLine2,POAddressLine3,POAddressLine4,POCity,PORegion,POPostalCode,POCountry,*InvoiceNumber,*InvoiceDate,*DueDate,Total,InventoryItemCode,Description,*Quantity,*UnitAmount,*AccountCode,*TaxType,TaxAmount,TrackingName1,TrackingOption1,TrackingName2,TrackingOption2,Currency</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
	</xsl:template>

<!-- Drive the transformation of each transation individually -->
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
		<xsl:variable name="header" select="../InvoiceCreditJournalEntriesHeader"/>
		<xsl:variable name="currentDocReference" select="$header/InvoiceReference"/>
		<xsl:variable name="typeSign">
			<xsl:choose>
				<xsl:when test="$header/TransactionType = 'INV'">1</xsl:when>
				<xsl:otherwise>-1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1])]">
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
				<!-- A - *ContactName - FnB Supplier Name - Correct -->
				<xsl:value-of select="$header/SupplierName"/>
				<xsl:text>,</xsl:text>
				<!-- B - EmailAddress - leave blank - Always leave blank -->
				<xsl:text>,</xsl:text>
				<!-- C - POAddressLine1 - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- D - POAddressLine2 - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- E - POAddressLine3 - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- F - POAddressLine4 - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- G - POCity - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- H - PORegion - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- I - POPostalCode - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- J - POCountry - leave blank - no. Always leave blank. -->
				<xsl:text>,</xsl:text>
				<!-- K - *InvoiceNumber - Invoice Number from FnB - Correct -->
				<xsl:value-of select="$header/InvoiceReference"/>
				<xsl:text>,</xsl:text>
				<!-- L - *InvoiceDate - Invoice Date from FnB - Correct -->
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="$header/InvoiceDate"/>
				</xsl:call-template>
				<xsl:text>,</xsl:text>
				<!-- M - *DueDate - Add 30 days to the invoice date - Ideally this would be a data field held within FnB, which we would adjust per supplier by reference to invoice date. If this is not possible could this field be defaulted to 30 days after the invoice date? xero guidance (Must be entered as dd/mm/yyyy or as written out in full.) -->
				<xsl:value-of select="js:addYearsMonthsDays(string($header/InvoiceDate), 0, 0, 30)"/>
				<xsl:text>,</xsl:text>
				<!-- N - Total - leave blank - always leave blank -->
				<xsl:text>,</xsl:text>
				<!-- O - InventoryItemCode - leave blank - always leave blank -->
				<xsl:text>,</xsl:text>
				<!-- P - Description - Invoice from Supplier Name - Yes, that's fine -->
				<xsl:value-of select="concat('Invoice from ', $header/SupplierName)"/>
				<xsl:text>,</xsl:text>
				<!-- Q - *Quantity - leave blank (defaults to 1)  -->
				<xsl:text>1</xsl:text>
				<xsl:text>,</xsl:text>
				<!-- R - *UnitAmount - Net value per nominal split (not the total Net value) - This is the net value per nominal split. Not the total net value. Each nominal split should have it's own value here, which will be multiplied by 1 as per column S. Xero will then add these lines together to totalise net value.  -->
				<xsl:value-of select="$typeSign * sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet)"/>
				<xsl:text>,</xsl:text>
				<!-- S - *AccountCode - Category Nominal code from FnB - This needs to be the category nominal code for the category one level below FOOD, BEVERAGE, MISC. I.e. Bread & Pastry, dairy, dry goods, fish, frozen, fruit & veg etc. The screenshot (named invoice import) in folder shows the level of detail we would like.  -->
				<xsl:value-of select="$currentCategoryNominal"/>
				<xsl:text>,</xsl:text>
				<!-- T - *TaxType - Always 20% (VAT on Expenses) - Please can this be defaulted to the following code exactly "20% (VAT on Expenses)". The characters are important as this is exactly how the 20% rate appears within Xero.  -->
				<xsl:text>20% (VAT on Expenses)</xsl:text>				
				<xsl:text>,</xsl:text>
				<!-- U - TaxAmount - Tax amount in numeric value per category nominal split from FnB - Correct. This field is the specific tax amount in numeric value per nominal category value as per column T. I.e in the example 42 would be the amount of tax payable on the net nominal total of 250 for code: BEV100. -->
				<xsl:value-of select="$typeSign * sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineVAT)"/>
				<xsl:text>,</xsl:text>
				<!-- V - TrackingName1 - default to "Site" - This column needs to read the following for every invoice: "Site" -->
				<xsl:text>Site</xsl:text>
				<xsl:text>,</xsl:text>
				<!-- W - TrackingOption1 - Unit site nominal - The content of this column needs to vary depending on the site which the invoice is for.  See below for list which shows Organisation hierarchy and  "trackingOption1" required. Essentially this needs to be set as the organisation hierarchy name for each site.  -->
				<xsl:value-of select="$header/UnitSiteNominal"/>
				<xsl:text>,</xsl:text>
				<!-- X - TrackingName2 - leave blank - Correct. Always leave blank -->
				<xsl:text>,</xsl:text>
				<!-- Y - TrackingOption2 - leave blank - Correct, always leave blank -->
				<xsl:text>,</xsl:text>
				<!-- Z - Currency - leave blank - PLEASE LEAVE THIS BLANK AS GBP IS OUR BASE CURRENCY IN XERO AND THEREFORE AMOUNTS WILL DEFAULT TO THIS. -->
				<xsl:text>,</xsl:text>
				<!-- AA -  - leave blank -  -->
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
	
]]></msxsl:script>
</xsl:stylesheet>
