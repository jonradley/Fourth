<?xml version="1.0" encoding="UTF-8"?>
<!--************************************************************
Overview: itsu Site Transfers Export map
****************************************************************
Module History
****************************************************************
Date				| Name			| Modification
****************************************************************
29/07/2014	|	A Barber	| 7912: Created
*************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>

	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLinesByAccount" match="SiteTransfer" use="concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod)"/>
	
	<xsl:template match="/SiteTransfersExport">
		<xsl:for-each select="(/SiteTransfersExport/SiteTransfers/SiteTransfer)[generate-id() = generate-id(key('keyLinesByAccount',concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod))[1])]">
			<xsl:sort select="SiteTransferLocation/BuyersUnitCode" data-type="text"/> 
			<xsl:variable name="AccountCode" select="concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod)"/>
			<!-- Posting Date -->
			<xsl:value-of select="script:msDateSubtraction()"/>
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
				<xsl:when test="format-number((sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Debit']/LineValueExclVAT))-(sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Credit']/LineValueExclVAT)),'0.00') &gt; 0">
					<xsl:value-of select="format-number((sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Debit']/LineValueExclVAT))-(sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Credit']/LineValueExclVAT)),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- Credit Amount -->
			<xsl:choose>
				<xsl:when test="format-number((sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Debit']/LineValueExclVAT))-(sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Credit']/LineValueExclVAT)),'0.00') &lt; 0">
					<xsl:value-of select="format-number(-1 * ((sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Debit']/LineValueExclVAT))-(sum(//SiteTransfer[concat(SiteTransferLocation/BuyersSiteCode,'+',CategoryNominal,'+',StockFinancialPeriod) = $AccountCode and TransactionType = 'Credit']/LineValueExclVAT))),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>0.00</xsl:otherwise>
			</xsl:choose>
			<!--xsl:value-of select="$AccountCode"/-->
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
	
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
			<xsl:choose>
				<xsl:when test="substring($utcFormat,6,2) = '01'">
					<xsl:text>JAN</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '02'">
					<xsl:text>FEB</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '03'">
					<xsl:text>MAR</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '04'">
					<xsl:text>APR</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '05'">
					<xsl:text>MAY</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '06'">
					<xsl:text>JUN</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '07'">
					<xsl:text>JUL</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '08'">
					<xsl:text>AUG</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '09'">
					<xsl:text>SEP</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '10'">
					<xsl:text>OCT</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '11'">
					<xsl:text>NOV</xsl:text>
				</xsl:when>
				<xsl:when test="substring($utcFormat,6,2) = '12'">
					<xsl:text>DEC</xsl:text>
				</xsl:when>
			</xsl:choose>
		<xsl:value-of select="concat(substring(//SiteTransfersExportHeader/ExportRunDate,3,2),'0',substring(//SiteTransfersExportHeader/ExportRunDate,9,2))"/>
	</xsl:template>
	
	<msxsl:script language="vbscript" implements-prefix="script"><![CDATA[ 
	
		'=========================================================================================
		' Routine			: msDateSubtraction
		' Description		: Gets current date -2 days in the format "yyyy-mm-dd"
		' Inputs				: String
		' Outputs			: None
		' Returns			: String
		' Author				: Andrew Barber, 2014-07-29
		' Alterations		:
		'=========================================================================================
		
		Function msDateSubtraction()
			
			'Get current date, subtract 2 days and convert to string.
			getSubtractedDate=CStr(DateAdd("d",-2,Date()))
			
			'Convert Date into yyyy-mm-dd format.
			msDateSubtraction=Right(getSubtractedDate,4) & "-" & Mid(getSubtractedDate,4,2) & "-" & Left(getSubtractedDate,2)
			
		End Function
	
	]]></msxsl:script>
	
</xsl:stylesheet>
