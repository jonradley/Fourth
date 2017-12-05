<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Consolidated Restaurant Operations Inc. (CRO) R9 Mapper for Invoice Credit Export Export to CSV.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 			| Description of modification
==========================================================================================
 20/11/2017	| Warith Nassor	| FB12201 - AJE Accurals Export - Splitting/Grouping by Nominal based on Doc Type & Invoice Ref. (To split by row on nominal, headers to be included in file)
==========================================================================================-->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">

	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	
	<xsl:variable name="FieldSeperator" select="','"/>
	
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLines" match="AccrualJournalEntriesLine" use="concat(../../AccrualJournalEntriesHeader/InvoiceReference, '|', CategoryNominal)"/>

		<xsl:variable name="BuyerSiteCode" select="Batch/BatchDocuments/BatchDocument/AccrualJournalEntries/AccrualJournalEntriesHeader/BuyersSiteCode"/>
		<xsl:variable name="SuppliersName" select="/BatchDocuments/BatchDocument/AccrualJournalEntries/AccrualJournalEntriesHeader/SupplierName"/>


	<xsl:template match="/">
			<xsl:text>DATABASE_NAME,ACCOUNT,DEBIT,CREDIT,REFCODE,DOCUMENT,DESCRIPTION,COMPANY,APPLY_DATE,FLAG</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument"/>
		</xsl:template>
	
	<xsl:template match="BatchDocument">
	
		<xsl:for-each select="AccrualJournalEntries/AccrualJournalEntriesDetail/AccrualJournalEntriesLine[generate-id() = generate-id(key('keyLines',concat(../../AccrualJournalEntriesHeader/InvoiceReference, '|', CategoryNominal))[1])]">
			<!--Stores the Account Code-->
			<xsl:variable name="key" select="concat(../../AccrualJournalEntriesHeader/InvoiceReference, '|', CategoryNominal)"/>
			
			<!--DATABASE_NAME #EMPTY#-->
			<xsl:value-of select="$FieldSeperator"/>    
		
			<!--ACCOUNT (FF +Concatanate CategoryNominal** + Buyers Site Code)(Buyer Side Code needs to be 4 chars)-->
				<xsl:value-of select="concat('FF',CategoryNominal,format-number($BuyerSiteCode, '0000'))"/>
			<xsl:value-of select="$FieldSeperator"/>

			<!--DEBIT--><!-- ***Net Amount ***-->
			<xsl:choose>
				<xsl:when test="../../AccrualJournalEntriesHeader/TransactionType = 'PurInvoice'">
						<xsl:value-of select="format-number(sum(../AccrualJournalEntriesLine[concat(../../AccrualJournalEntriesHeader/InvoiceReference, '|', CategoryNominal) = $key]/LineNet),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!--CREDIT--><!-- ***Net Amount **-->
			<xsl:choose>
				<xsl:when test="../../AccrualJournalEntriesHeader/TransactionType = 'PurCredit'">
					<xsl:value-of select="format-number(sum(../AccrualJournalEntriesLine[concat(../../AccrualJournalEntriesHeader/InvoiceReference, '|', CategoryNominal) = $key]/LineNet),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
						
			<xsl:value-of select="$FieldSeperator"/>
		
			<!--REFCODE #EMPTY#-->
			<xsl:value-of select="$FieldSeperator"/>
			
			<!--DOCUMENT -->
			<xsl:value-of select="../../AccrualJournalEntriesHeader/SupplierNominalCode"/>
			<xsl:value-of select="$FieldSeperator"/>

			<!--DESCRIPTION #EMPTY#-->
			<xsl:value-of select="../../../AccrualJournalEntries/AccrualJournalEntriesHeader/SupplierName"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!--COMPANY #EMPTY# -->
			<xsl:value-of select="$FieldSeperator"/>
			
			<!--APPLY_DATE-->
			<xsl:call-template name="formatDate">
				<xsl:with-param name="DateTimeStr" select="//ExportRunDate"/>
			</xsl:call-template>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!--FLAG-->
		<xsl:text>1</xsl:text>			
			<xsl:value-of select="$RecordSeperator"/>
		</xsl:for-each>
	</xsl:template>
	
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
