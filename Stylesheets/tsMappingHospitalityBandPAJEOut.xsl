<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
==========================================================================================
 24/07/2013	| S Hussain 				|	FB6859 - B&P - Accural Export Mapper | Created
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://abs-ltd.com">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:variable name="BalanceCreditUnit" select="9230"/>
	<xsl:template match="/">
		<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument/AccrualJournalEntries/AccrualJournalEntriesDetail/AccrualJournalEntriesLine"/>
	</xsl:template>
	<xsl:template match="AccrualJournalEntriesLine">
		<xsl:call-template name="CreateAccurals">
			<xsl:with-param name="Type">
				<xsl:text>Accrual</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="CreateAccurals">
			<xsl:with-param name="Type">
				<xsl:text>Reversal</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="CreateAccurals">
			<xsl:with-param name="Type">
				<xsl:text>BalanceCredit</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="CreateAccurals">
		<xsl:param name="Type"/>
		<xsl:text>GENERAL</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>STOCKACC</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="user:GetRowNumber()"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>G/L Account</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:choose>
			<xsl:when test="$Type = 'BalanceCredit'">
				<xsl:value-of select="$BalanceCreditUnit"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="CategoryNominal"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="../../AccrualJournalEntriesHeader/DeliveryDate"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>STOCK ACCRUALS</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:text>Stock Accruals</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:if test="$Type !=  'Accrual'">
			<xsl:text>-</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="LineNet"/>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="../../AccrualJournalEntriesHeader/BuyersUnitCode"/>
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<xsl:template match="LineNet">
		<xsl:choose>
			<xsl:when test="number(.) != 'NaN'">
				<xsl:value-of select="format-number(., '0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
	var mlPreviousRowNo = 0;
	function GetRowNumber()
	{
		mlPreviousRowNo = mlPreviousRowNo + 1;
		return mlPreviousRowNo;
	}
	]]></msxsl:script>
</xsl:stylesheet>
