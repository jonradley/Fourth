<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Consolidated Restaurant Operations Inc. (CRO) R9 Mapper for Closing Stock Export Export to CSV.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 17/10/2017	| Warith Nassor	| FB12162 - CRO Closing Stock Export to convert this back to the CSV flat file
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	
	<xsl:variable name="BuyerSiteCode" select="Batch/BatchDocuments/BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/BuyersSiteCode"/>
	
	<xsl:template match="Batch">
		<xsl:text>DATABASE_NAME,ACCOUNT,DEBIT,CREDIT,REFCODE,DOCUMENT,DESCRIPTION,COMPANY,APPLY_DATE,FLAG</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="BatchDocuments/BatchDocument/ClosingStockJournalEntries/ClosingStockJournalEntriesDetail/ClosingStockJournalEntriesLine[NominalCode]"/>
	</xsl:template>
	
	<xsl:template match="ClosingStockJournalEntriesLine">
	
		<!--DATABASE_NAME-->
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--ACCOUNT (FF +Concatanate CategoryNominal** + Buyers Site Code)(Buyer Side Code needs to be 4 chars)-->
		<xsl:value-of select="concat('FF',NominalCode,format-number($BuyerSiteCode, '0000'))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--DEBIT-->
		<xsl:value-of select="$FieldSeperator"/>
	
		<!--CREDIT-->
		<xsl:value-of select="js:quote(string(ClosingValue))"/>		
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--REFCODE-->
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--DOCUMENT -->
		<xsl:call-template name="formatDate2">
				<xsl:with-param name="DateTimeStr2" select="../../ClosingStockJournalEntriesHeader/StockPeriodEndDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--DESCRIPTION-->
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--COMPANY-->
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--APPLY_DATE-->
		<xsl:call-template name="formatDate">
				<xsl:with-param name="DateTimeStr" select="../../../../../BatchHeader/ExportRunDate"/>
		</xsl:call-template>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!--FLAG-->
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
		</xsl:template>
		
		
	<!--DATE FORMAT FOR DOCUMENT (StockPeriodEndDate)-->
	<xsl:template name="formatDate2">
	     <xsl:param name="DateTimeStr2" />
      <xsl:variable name="mm2">
         <xsl:value-of select="substring($DateTimeStr2,5,2)" />
     </xsl:variable>
      <xsl:variable name="dd2">
        <xsl:value-of select="substring($DateTimeStr2,7,2)" />
     </xsl:variable>
      <xsl:variable name="yyyy2">
        <xsl:value-of select="substring($DateTimeStr2,1,4)" />
     </xsl:variable>
      <xsl:value-of select="concat($mm2,'/', $dd2, '/', $yyyy2)" />
       </xsl:template>
		
	<!--DATE FORMAT FOR APPLY_DATE (ExportRunDate)-->
	<xsl:template name="formatDate">
	     <xsl:param name="DateTimeStr" />
      <xsl:variable name="mm">
         <xsl:value-of select="substring($DateTimeStr,6,2)" />
     </xsl:variable>
      <xsl:variable name="dd">
        <xsl:value-of select="substring($DateTimeStr,9,2)" />
     </xsl:variable>
      <xsl:variable name="yyyy">
        <xsl:value-of select="substring($DateTimeStr,1,4)" />
     </xsl:variable>
      <xsl:value-of select="concat($mm,'/', $dd, '/', $yyyy)" />
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
