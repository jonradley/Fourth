<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Pizza Express UK mapper for closing stocks journal.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      		| Name 				| Description of modification
==========================================================================================
 14/04/2015| Jose Miguel	| FB10911 - Created
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:include href="tsMappingHospitalityPizzaExpressCommon.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="keyEntriesByRestaurant" match="//ClosingStockJournalEntriesLine" use="../../ClosingStockJournalEntriesHeader/BuyersUnitCode"/>
	<xsl:variable name="NumberOfLines" select="2 * count(//ClosingStockJournalEntriesLine)"/>

	<xsl:template match="/">
		<xsl:text>BatchID,BatchValue,BatchRow,VNEDUS,VNEDTN,VNEDLN,VNEDER,VNEDSP,VNEDTC,VNEDTR,VNEDBT,VNKCO,VNDCT,VNDGJ,VNCO,VNANI,VNAM,VNAID,VNSBL,VNSBLT,VNLT,VNCTRY,VNAA,VNEXA,VNR2,VNDKJ,VNOPSQ,VNTORG,VNUSER,VNPID,VNJJOBN,VNUPMJ,VNUPMT,SystemTimeStamp,VNCRCD</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<xsl:for-each select="//ClosingStockJournalEntriesLine[generate-id() = generate-id(key('keyEntriesByRestaurant', ../../ClosingStockJournalEntriesHeader/BuyersUnitCode)[1])]">
			<xsl:sort order="ascending" select="../../ClosingStockJournalEntriesHeader/BuyersUnitCode"  data-type="number"/>
			<xsl:variable name="BuyersUnitCode" select="../../ClosingStockJournalEntriesHeader/BuyersUnitCode"/>
			<xsl:variable name="CompanyNumber" select="js:getSiteCodeToCompanyCode(string($BuyersUnitCode))"/>
			<xsl:variable name="Amount" select="number(sum(key('keyEntriesByRestaurant', $BuyersUnitCode)/ClosingValue))"/>
			
			<!-- generate the basic line -->
			<xsl:call-template name="generateLine">
				<xsl:with-param name="RestaurantLine" select="1"/>
				<xsl:with-param name="AccountCode" select="concat(js:right($CompanyNumber, 2), '.3510')"/>
				<xsl:with-param name="Amount" select="$Amount"/>
				<xsl:with-param name="Reference2" select="'CLOSTOCK'"/>
				<xsl:with-param name="CompanyNumber" select="$CompanyNumber"/>
			</xsl:call-template>
			<xsl:text>&#13;&#10;</xsl:text>
			<!-- generate the reversed line -->
			<xsl:call-template name="generateLine">
				<xsl:with-param name="RestaurantLine" select="2"/>
				<xsl:with-param name="AccountCode" select="concat($BuyersUnitCode, '.6175')"/>
				<xsl:with-param name="Amount" select="-$Amount"/>
				<xsl:with-param name="Reference2" select="'STOCK'"/>
				<xsl:with-param name="CompanyNumber" select="$CompanyNumber"/>
			</xsl:call-template>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
		
	<xsl:template name="generateLine">
		<xsl:param name="RestaurantLine"/>
		<xsl:param name="AccountCode"/>
		<xsl:param name="Amount"/>
		<xsl:param name="Reference2"/>
		<xsl:param name="CompanyNumber"/>
		
		<xsl:variable name="Header" select="(../../ClosingStockJournalEntriesHeader)"/>
		<xsl:variable name="BuyersUnitCode" select="$Header/BuyersUnitCode"/>
		<xsl:variable name="BatchID" select="number(/Batch/BatchHeader/FileGenerationNumber)"/>
		<xsl:variable name="TransactionNumber" select="js:getUniqueTransactionNumberByRestaurantCode(string($BuyersUnitCode))"/>
		
		<xsl:variable name="GLDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="date" select="$Header/StockPeriodEndDate"/>
			</xsl:call-template>
		</xsl:variable>
				
		<!-- A - BatchID - Batch Number - (Char 15) - Unique batch number for each restaurant. Increase sequentially - start at 1. Do not reset in the subsequent files.-->
		<xsl:value-of select="$BatchID"/>
		<xsl:text>,</xsl:text>
		<!-- B - BatchValue - 0 - (Number) - Total of VNAA column. Batch value should always be equal to zero.-->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- C - BatchRow - Number of rows with the batch - (Number) - Total number of rows excluding headers-->
		<xsl:value-of select="$NumberOfLines"/>
		<xsl:text>,</xsl:text>
		<!-- D - VNEDUS - FOURTH - (Char 10) - UPPER CASE. This is user ID for Fourth Inventory-->
		<xsl:text>FOURTH</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- E - VNEDTN - Transaction Number - (Number 22) - Set to 1 and increase by 1 for each new restaurant in the file-->
		<xsl:value-of select="$TransactionNumber"/>
		<xsl:text>,</xsl:text>
		<!-- F - VNEDLN - Line No - (Number 7) - This is the unique line number within the restaurant, i.e. it is a subset of VNEDTN. The first line within each restaurant to be reset to 1000, increment each new line within the same restaurant (VNEDTN) by 1000. Currently only two lines per restaurant should be reported.-->
		<xsl:value-of select="1000 * $RestaurantLine"/>
		<xsl:text>,</xsl:text>
		<!-- G - VNEDER - B - (Alpha 1) - UPPER CASE. EDI - Send/Receive Indicator – should always be set to B-->
		<xsl:text>B</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- H - VNEDSP - 0 - (Number 1) - Zero. Processing flag updates to 1 once processed in JDE.-->
		<xsl:text>0</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- I - VNEDTC - A - (Alpha 1) - UPPER CASE. EDI – Transaction Action – should always be set to A.-->
		<xsl:text>A</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- J - VNEDTR - J - (Alpha 1) - UPPER CASE. EDI – Transaction Type – should always be set to J.-->
		<xsl:text>J</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- K - VNEDBT - Batch number - (Char 15) - Unique batch number for each restaurant. Increase sequentially - start at 1. Do not reset in the subsequent files.-->
		<xsl:value-of select="$BatchID * 10000 + $TransactionNumber"/>
		<xsl:text>,</xsl:text>
		<!-- L - VNKCO - Doc Company Number - (Number 5) - The Company Code relating to the Location code of the transaction (same as VNCO). Leading zeros included i.e. 00010. See note 2.-->
		<xsl:value-of select="$CompanyNumber"/>
		<xsl:text>,</xsl:text>
		<!-- M - VNDCT - XJ - (Char 2) - UPPER CASE. Document Type – should always be set to XJ.-->
		<xsl:text>XJ</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- N - VNDGJ - G/L Date - () - Period end date. The date in DD/MM/YY format.(Fourth note: <StockPeriodEndDate>)-->
		<xsl:value-of select="$GLDate"/>			
		<xsl:text>,</xsl:text>
		<!-- O - VNCO - Company Number - (Number 5) - The Company Code relating to the Location code of the transaction. Leading zeros included i.e. 00010. (Fourth note: same as VNKCO). -->
		<xsl:value-of select="$CompanyNumber"/>		
		<xsl:text>,</xsl:text>
		<!-- P - VNANI - Account Code - (Char 9) - Full account code: If Balance Sheet Account = CO.3510 (Fourth note: VNAA > 0), If P&L Account = RRRR.6175. (Fourth note: VNAA < 0, created by the export for the balanced line). Where CO = Company number (VNCO) and RRRR = Restaurant location number (VNSBL)-->
		<xsl:value-of select="$AccountCode"/>
		<xsl:text>,</xsl:text>
		<!-- Q - VNAM - 2 - (Number 1) - Set to ‘2’. (Fourth note: hardcoded)-->
		<xsl:text>2</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- R - VNAID - Null - () - Leave blank / set to Null-->
		<xsl:text>,</xsl:text>
		<!-- S - VNSBL - Subledger Number - (Number 8) - Location Code, right justified with leading zeros-->
		<xsl:value-of select="js:pad(string($BuyersUnitCode), 8)"/>
		<xsl:text>,</xsl:text>
		<!-- T - VNSBLT - A - (Alpha 1) - UPPER CASE. Subledger Type A. (Fourth note: hardcoded)-->
		<xsl:text>A</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- U - VNLT - AA - (Alpha 25) - UPPER CASE. Ledger type. AA. (Fourth note: hardcoded)-->
		<xsl:text>AA</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- V - VNCTRY - Century - (Number 2) - Century Number –‘20’-->
		<xsl:text>20</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- W - VNAA - Amount - (Number 15) - This is the transaction value in the lowest monetary value (i.e. pence for GBP transactions in GBP file) with leading ‘-‘ if negative (see example provided). (Fourth note: <ClosingValue>)-->
		<xsl:value-of select="100 * $Amount"/>
		<xsl:text>,</xsl:text>
		<!-- X - VNEXA - Name – Alpha Explanation - (Char 30) - Set to ‘Closing Stock Accrual DD/MM/YY’, where DD/MM/YY is GL Date.-->
		<xsl:text>Closing Stock Accrual </xsl:text><xsl:value-of select="$GLDate"/>
		<xsl:text>,</xsl:text>
		<!-- Y - VNR2 - Reference2 - (Char 8) - UPPER CASE. BS = CLOSTOCK, for positive balance line. P&L = STOCK, for negative balance line. (Fourth note: Natural line = CLOSTOCK, Balanced line = STOCK)-->
		<xsl:value-of select="$Reference2"/>
		<xsl:text>,</xsl:text>
		<!-- Z - VNDKJ - Date – Check - () - Transaction date = GL date. The date in DD/MM/YY format-->
		<xsl:value-of select="$GLDate"/>
		<xsl:text>,</xsl:text>
		<!-- AA - VNOPSQ - Sequence Number – Operations - (Number 5) - This is the unique line number within the restaurant, i.e. it is a subset of VNEDTN. The first line within each restaurant to be reset to 100, increment each new line within the same restaurant (VNEDTN) by 100. Currently only two lines per restaurant should be reported-->
		<xsl:value-of select="100 * $RestaurantLine"/>
		<xsl:text>,</xsl:text>
		<!-- AB - VNTORG - FOURTH - (Alpha 10) - UPPER CASE. Set to FOURTH-->
		<xsl:text>FOURTH</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- AC - VNUSER - INTERFACE - (Alpha 10) - UPPER CASE. Set to INTERFACE-->
		<xsl:text>INTERFACE</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- AD - VNPID - INTERFACE - (Alpha 10) - UPPER CASE. Set to INTERFACE-->
		<xsl:text>INTERFACE</xsl:text>		
		<xsl:text>,</xsl:text>
		<!-- AE - VNJJOBN - PC01 - (Alpha 10) - Set to ‘PC01’-->
		<xsl:text>PC01</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- AF - VNUPMJ - Date – Updated - () - Date the file was generated (same date as in filename). The date in DD/MM/YY format-->
		<xsl:value-of select="js:msFileGenerationDateInDD_MM_YYFormat()"/>
		<xsl:text>,</xsl:text>
		<!-- AG - VNUPMT - Time – Last Updated - (Number 6) - Time the job finished as hhmmss (same time as in filename)-->
		<xsl:value-of select="js:msFileGenerationTimeHHMMSSFormat()"/>
		<xsl:text>,</xsl:text>
		<!-- AH - SystemTimeStamp - Full date and time last updated - (Number 14) - YYYYMMDDhhmmss-->
		<xsl:value-of select="js:msFileGenerationDateTimeYYYYMMDDhhmmss()"/>
		<xsl:text>,</xsl:text>
		<!-- AI - VNCRCD - Currency Code - (Alpha 3) - UPPER CASE. Set to transaction currency code-->
		<xsl:value-of select="$Header/CurrencyCode"/>
	</xsl:template>
	
	<!-- Format the date from YYYYMMDD to DD/MM/YY -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>		
		<xsl:value-of select="concat(substring($date,7,2),'/',substring($date,5,2),'/',substring($date,3,2))"/>
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 
	var mapRestaurants = {};
	var intNextFreeRestaurantNumber = 1;	
	function getUniqueTransactionNumberByRestaurantCode (strRestaurantCode)
	{
		var intRestaurantCode =  mapRestaurants[strRestaurantCode];
		if (intRestaurantCode == undefined)
		{
			intRestaurantCode = mapRestaurants[strRestaurantCode] = intNextFreeRestaurantNumber;
			intNextFreeRestaurantNumber += 1;
		}
		return intRestaurantCode;
	}

	function right (str, count)
	{
		return str.substring(str.length - count, str.length);
	}
	
	function pad (str, num)
	{
		return right('000000' + str, num);
	}
	
	var today = new Date();
	
	function msFileGenerationDateInDD_MM_YYFormat ()
	{
		var year = today.getYear();
		var month = today.getMonth()+1;
		var day = today.getDate();
			
		return '' + pad(day, 2) + '/' + pad(month, 2) + '/' + pad(year, 2);
	}
	function msFileGenerationTimeHHMMSSFormat ()
	{
		var hours = today.getHours();
		var minutes = today.getMinutes();
		var seconds = today.getSeconds();
			
		return '' + pad(hours, 2) + pad(minutes, 2) + pad(seconds, 2);
	}
	
	function msFileGenerationDateTimeYYYYMMDDhhmmss ()
	{
		var year = today.getYear();
		var month = today.getMonth()+1;
		var day = today.getDate();
		var hours = today.getHours();
		var minutes = today.getMinutes();
		var seconds = today.getSeconds();

		return '' + pad(year, 4) + pad(month, 2) + pad(day, 2)  + pad(hours, 2) + pad(minutes, 2) + pad(seconds, 2);
	}
	]]></msxsl:script>	
</xsl:stylesheet>
