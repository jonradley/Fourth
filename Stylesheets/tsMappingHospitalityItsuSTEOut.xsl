<?xml version="1.0" encoding="UTF-8"?>
<!--*************************************************************************************************************************
Overview: itsu Site Transfers Export map
*****************************************************************************************************************************
Module History
*****************************************************************************************************************************
Date				| Name			| Modification
*****************************************************************************************************************************
29/07/2014	|	A Barber	| 7912: Created
*****************************************************************************************************************************
28/11/2014	|	M Dimant	| 10099: Removed the header column and changed the date format.
*****************************************************************************************************************************
22/04/2015	|	J Miguel	| 10235: Remove zero-lines
**************************************************************************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>

	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLinesByAccount" match="SiteTransfer" use="concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod,'+',TransactionDate)"/>
	
	<xsl:template match="/SiteTransfersExport">
		<xsl:for-each select="(/SiteTransfersExport/SiteTransfers/SiteTransfer)[generate-id() = generate-id(key('keyLinesByAccount',concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod,'+',TransactionDate))[1])]">
			<xsl:sort select="CategoryNominal" data-type="text"/> 
			<xsl:sort select="SiteTransferLocation/BuyersSiteCode" data-type="text"/> 
			<xsl:sort select="TransactionDate" data-type="text"/> 
			<xsl:variable name="amount" select="sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod,'+',TransactionDate) = $AccountCode and TransactionType = 'Debit']/LineValueExclVAT))-(sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod,'+',TransactionDate) = $AccountCode and TransactionType = 'Credit']/LineValueExclVAT)"/>
			<xsl:variable name="AccountCode" select="concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod,'+',TransactionDate)"/>
			<xsl:if test="$amount != 0">
				<!-- Posting Date -->		
				<xsl:value-of select="concat(substring(TransactionDate,9,2),'/',substring(TransactionDate,6,2),'/',substring(TransactionDate,1,4))"/>
				<xsl:text>,</xsl:text>
				<!-- Doc. No. -->
				<xsl:call-template name="formatDate">
					<xsl:with-param name="utcFormat" select="//SiteTransfersExportHeader/ExportRunDate"/>
				</xsl:call-template>
				<xsl:text>,</xsl:text>
				<!-- Account -->
				<xsl:value-of select="CategoryNominal"/>
				<xsl:text>,</xsl:text>
				<!-- Ext. Doc. No. -->
				<xsl:text>,</xsl:text>
				<!-- Description -->
				<xsl:value-of select="concat('Stock Transfers wk',StockFinancialPeriod)"/>
				<xsl:text>,</xsl:text>
				<!-- VAT Bus Post Grp -->
				<xsl:text>,</xsl:text>
				<!-- VAT Prod Post Grp -->
				<xsl:text>,</xsl:text>
				<!-- GD1 -->
				<xsl:value-of select="SiteTransferLocation/BuyersSiteCode"/>
				<xsl:text>,</xsl:text>
				<!-- GD2 -->
				<xsl:text>,</xsl:text>
				<!-- Debit Amount -->
				<xsl:choose>
					<xsl:when test="$amount &gt; 0">
						<xsl:value-of select="format-number($amount, '0.0')"/>
					</xsl:when>
					<xsl:otherwise>0.00</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				<!-- Credit Amount -->
				<xsl:choose>
					<xsl:when test="$amount &lt; 0">
						<xsl:value-of select="format-number(-$amount, '0.0')"/>
					</xsl:when>
					<xsl:otherwise>0.00</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
		</xsl:for-each>
	
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
		<xsl:variable name="formattedDate" select="substring($utcFormat,6,2)"/>
		<xsl:choose>
			<xsl:when test="$formattedDate = '01'">
				<xsl:text>JAN</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '02'">
				<xsl:text>FEB</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '03'">
				<xsl:text>MAR</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '04'">
				<xsl:text>APR</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '05'">
				<xsl:text>MAY</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '06'">
				<xsl:text>JUN</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '07'">
				<xsl:text>JUL</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '08'">
				<xsl:text>AUG</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '09'">
				<xsl:text>SEP</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '10'">
				<xsl:text>OCT</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '11'">
				<xsl:text>NOV</xsl:text>
			</xsl:when>
			<xsl:when test="$formattedDate = '12'">
				<xsl:text>DEC</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="concat(substring(//SiteTransfersExportHeader/ExportRunDate,3,2),'0',substring(//SiteTransfersExportHeader/ExportRunDate,9,2))"/>
	</xsl:template>
	
</xsl:stylesheet>