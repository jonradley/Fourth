<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Covent Garden Resturants mapper for Accruals Journal Export to CSV.
==========================================================================================
 Module History 
==========================================================================================
 Version
==========================================================================================
 Date      		| Name 			| Description of modification
==========================================================================================
 13/01/2017	| Warith Nassor		| FB11474 - Created from Standard AJE Export
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="/">
	
		<!-- Create Header Row -->
		<xsl:text>Site Name,BuyersSiteCode,SupplierName,BuyersCodeForSupplier,DeliveryReference,DeliveryDate,Transaction Type,LineNet,LineVAT,LineGross</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>
		
		<!-- Apply transformation -->
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument/AccrualJournalEntries/AccrualJournalEntriesDetail"/>
		
	</xsl:template>
	
	
	<xsl:template match="AccrualJournalEntriesDetail">
		<!-- UnitSiteName -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/UnitSiteName))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- BuyersSiteCode -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/BuyersSiteCode))"/>
		<xsl:value-of select="$FieldSeperator"/>

		<!-- SupplierName -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/SupplierName))"/>
		<xsl:value-of select="$FieldSeperator"/>

		<!-- BuyersCodeForSupplier -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/BuyersCodeForSupplier))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- DeliveryReference -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/DeliveryReference))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- Delivery Date -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/DeliveryDate))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- Transaction Type -->
		<xsl:value-of select="js:quote(string(../AccrualJournalEntriesHeader/TransactionType))"/>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- LineNet -->
		<!-- When transaction type is a credit, we add a minus -->
		<xsl:choose>
			<xsl:when test="string(../AccrualJournalEntriesHeader/TransactionType) = 'PurCredit' ">
				<xsl:value-of select="js:quote(concat('-',format-number(sum(AccrualJournalEntriesLine/LineNet),'00.00')))"/>
			</xsl:when>
		<!-- Otherwise must be an invoice so output the positive value -->
			<xsl:otherwise>
				<xsl:value-of select="js:quote(format-number(sum(AccrualJournalEntriesLine/LineNet),'00.00'))"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$FieldSeperator"/>
		
		<!-- LineVAT -->
		<!-- When transaction type is a credit, else output invoice sum  -->
		<xsl:choose>
			<xsl:when test="string(../AccrualJournalEntriesHeader/TransactionType) = 'PurCredit' ">
			<xsl:value-of select="js:quote(format-number(sum(AccrualJournalEntriesLine/LineVAT),'00.00'))"/>
			</xsl:when>
			<!-- Otherwise must be an invoice so output the positive value-->
			<xsl:otherwise>
			<xsl:value-of select="js:quote(format-number(sum(AccrualJournalEntriesLine/LineVAT),'00.00'))"/>
			</xsl:otherwise>
		</xsl:choose>
	<xsl:value-of select="$FieldSeperator"/>

	<!-- LineGross-->
		<!-- When transaction type is a credit, else output invoice sum  -->
		<xsl:choose>
			<xsl:when test="string(../AccrualJournalEntriesHeader/TransactionType) = 'PurCredit' ">
			<xsl:value-of select="js:quote(format-number(sum(AccrualJournalEntriesLine/LineGross),'00.00'))"/>
			</xsl:when>
			<!-- Otherwise must be an invoice so output the positive value-->
			<xsl:otherwise>
			<xsl:value-of select="js:quote(format-number(sum(AccrualJournalEntriesLine/LineGross),'00.00'))"/>
			</xsl:otherwise>
		</xsl:choose>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
		
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
