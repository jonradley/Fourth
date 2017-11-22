<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG Closing Stock Journal Export in CSV format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 19/04/2017	| M Dimant	| FB11685: Created.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	
	<xsl:template match="/">
	
	<xsl:text>TRG Closing Stock Value Export</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:text>Exported Date:</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="translate(/Batch/BatchHeader/ExportRunDate,'-','/')"/>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	
	<!-- Headers -->
	<xsl:text>Site ID,Total Closing Stock Value,Stock Period</xsl:text>
	<xsl:value-of select="$RecordSeperator"/>
	
	<xsl:for-each select="/Batch/BatchDocuments/BatchDocument">
	
		<!-- Site ID -->
		<xsl:value-of select="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/BuyersSiteCode"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Total Closing Stock Value-->
		<xsl:value-of select="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/ClosingStockValue"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Stock Period -->
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/StockPeriodStartDate"/>
		</xsl:call-template>
		<xsl:text>-</xsl:text>
		<xsl:call-template name="formatDate">
			<xsl:with-param name="date" select="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
		</xsl:call-template>
		<xsl:value-of select="$RecordSeperator"/>	
	</xsl:for-each>


	</xsl:template>
	
	<!-- Format the date from YYYYMMDD to DD/MM/YYYY-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>		
		<xsl:value-of select="concat(substring($date,7,2),'/',substring($date,5,2),'/',substring($date,1,4))"/>
	</xsl:template>

</xsl:stylesheet>
