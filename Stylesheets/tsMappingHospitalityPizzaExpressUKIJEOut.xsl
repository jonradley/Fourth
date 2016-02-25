<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
Pizza Express UK outbound mapper for invoices and credits journal format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 25/02/2016	| Jose Miguel	| FB10850 - Pay File with IJE Integration
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript" exclude-result-prefixes="#default xsl msxsl js">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyLinesByRefAndNominalCode" match="InvoiceCreditJournalEntriesLine" use="concat(../../InvoiceCreditJournalEntriesHeader/InvoiceReference,'|', CategoryNominal)"/>
	
	<xsl:template match="/">
		<xsl:text>VLEDUS,VLEDBT,VLEDBV,VLEDTN,VLEDLN,VLEDSP,VLEDTC,VLEDTR,VLCO,VLMCU,VLDL01,VLDCT,VLPO,VLVINV,VLDIVJ,VLDGJ,VLSCODE,VLATXA,VLSTAM,VLEXR1,VLCRCD,VLRMK</xsl:text>
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
		<xsl:variable name="currentDocTotalGroups" select="count(InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1]) and CategoryNominal != 'DISCREPANCY'])"/>
		<xsl:for-each select="InvoiceCreditJournalEntriesLine[generate-id() = generate-id(key('keyLinesByRefAndNominalCode', concat($currentDocReference, '|', CategoryNominal))[1]) and CategoryNominal != 'DISCREPANCY']">
			<!-- variables -->
			<xsl:variable name="currentCategoryNominal" select="CategoryNominal"/>
			<xsl:variable name="currentGroupNet" select="sum(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal))/LineNet)"/>
			<xsl:variable name="currentGroupTotalLines" select="count(key('keyLinesByRefAndNominalCode',concat($currentDocReference, '|', $currentCategoryNominal)))"/>

			<!-- Output Starts here -->
			<!-- VLEDUS - FOURTH - Char 10 -->
			<xsl:text>FOURTH</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- VLEDBT - Batch number -  -->
			<xsl:value-of select="/Batch/BatchHeader/FileGenerationNumber"/>
			<xsl:text>,</xsl:text>
			<!-- VLEDBV - Batch Value - Number  - PENDING - for credits this has to be negative... check the xml, maybe it holds the sign already -->
			<xsl:value-of select="sum(//LineNet)"/>
			<xsl:text>,</xsl:text>
			<!-- VLEDTN - Transaction Number - Number 22 -->
			<xsl:value-of select="position() * 1000"/>
			<xsl:text>,</xsl:text>
			<!-- VLEDLN - Line Number - Number 7 -->
			<xsl:value-of select="position() * 1000"/>
			<xsl:text>,</xsl:text>
			<!-- VLEDSP - 0 - Number 1 -->
			<xsl:text>0</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- VLEDTC - A - Alpha 1 -->
			<xsl:text>A</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- VLEDTR - V - Alpha 1 -->
			<xsl:text>V</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- VLCO - Company - Number 5 -->
			<xsl:value-of select="js:getVLCO(string(../InvoiceCreditJournalEntriesHeader/BuyersSiteCode))"/>
			<xsl:text>,</xsl:text>
			<!-- VLMCU - Business Unit - Char 12 -->
			<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/UnitSiteName"/>
			<xsl:text>,</xsl:text>
			<!-- VLDL01 - Business Unit Name - Alpha -->
			<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/UnitSiteName"/>
			<xsl:text>,</xsl:text>
			<!-- VLDCT - Document Type - Char 2 -->
			<xsl:choose>
				<xsl:when test="InvoiceCreditJournalEntriesHeader/TransactionType='INV'"><xsl:text></xsl:text></xsl:when>
				<xsl:when test="InvoiceCreditJournalEntriesHeader/TransactionType='CRN'"><xsl:text>P3</xsl:text></xsl:when>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- VLPO - Purchase order number - Number 8 -->
			<xsl:text>PENDING</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- VLVINV - Supplier Invoice number. - Alpha 25 -->
			<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<!-- VLDIVJ - Invoice Date - DD/MM/YYYY  -->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			<!-- VLDGJ - G/L date -  DD/MM/YYYY  -->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="../InvoiceCreditJournalEntriesHeader/ExportRunDate"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			<!-- VLSCODE - Fourth Supplier Code -  Alpha 8 -->
			<xsl:value-of select="js:toUpper(string(../InvoiceCreditJournalEntriesHeader/SupplierNominalCode))"/>
			<xsl:text>,</xsl:text>			
			<!-- VLATXA - Taxable Amount - Number 15 -->
			<xsl:value-of select="LineNet"/>
			<xsl:text>,</xsl:text>			
			<!-- VLSTAM - Tax Amount - Number 15 -->
			<xsl:value-of select="LineVAT"/>
			<xsl:text>,</xsl:text>	
			<!-- VLEXR1 - Vat Rate - Alpha 1 -->
			<xsl:if test="number(LineVAT) = 0">
				<xsl:text>E</xsl:text>	
			</xsl:if>
			<xsl:text>,</xsl:text>
			<!-- VLCRCD - Currency Code - Alpha 3 -->
			<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
			<xsl:text>,</xsl:text>			
			<!-- VLRMK - Delivery note number. - Char 30 -->
			<xsl:value-of select="../InvoiceCreditJournalEntriesHeader/DeliveryReference"/>
			<xsl:text>&#13;&#10;</xsl:text>
    </xsl:for-each>
    </xsl:template>
    
	<msxsl:script implements-prefix="js"><![CDATA[ 
	// While we do not have the CompanyCode implemented in R9 any new sites will be translated from the SiteCode
	var mapSiteCodeToCompanyCode =
	{
		'6001':'00018'
	};	
	
	// This translates the site code to the company code which will be used in column VLCO
	// If the value is not translated the original value unmapped is returned so we know which one caused it.
	function getVLCO (strSiteCode)
	{
		var strCompanyCode = mapSiteCodeToCompanyCode[strSiteCode];
		
		if (strCompanyCode == null)
		{
			strCompanyCode = strSiteCode;
		}
		return strCompanyCode;
	}
		
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
	
 function toUpper (str)
 {
	 return str.toUpperCase();
 }  
  	
]]></msxsl:script>
</xsl:stylesheet>
