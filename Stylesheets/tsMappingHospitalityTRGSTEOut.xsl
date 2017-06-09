<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG Site Transfer Export in CSV format.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 19/04/2017	| M Dimant	| FB11685: Created.
==========================================================================================
 05/06/2017	| M Dimant	| FB11834: Consolidated lines for all Debits/Credit per site.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:key name="Site" match="SiteTransfersExport/SiteTransfers/SiteTransfer/SiteTransferLocation/BuyersSiteCode" use="." />
	
	<xsl:template match="/">
		
		<xsl:text>TRG Closing Transfer Values Export</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:text>Exported Date:</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="translate(SiteTransfersExport/SiteTransfersExportHeader/ExportRunDate,'-','/')"/>
		<xsl:value-of select="$RecordSeperator"/>
		<xsl:value-of select="$RecordSeperator"/>
		
		<!-- Headers -->
		<xsl:text>Site ID Transfer From,Debit,Transfer Value,Stock Period No</xsl:text>
		<xsl:value-of select="$RecordSeperator"/>

		<xsl:apply-templates select="SiteTransfersExport/SiteTransfers"/>
		
		
		<!-- Trailer -->
		<xsl:value-of select="$RecordSeperator"/>	
		<xsl:text>Exported Date:</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<xsl:value-of select="translate(SiteTransfersExport/SiteTransfersExportHeader/ExportRunDate,'-','/')"/>
		
	</xsl:template>
	
		
	<xsl:template match="SiteTransfers">
		
		<!-- Create a line for each unique Site Code -->		
		<xsl:for-each select="SiteTransfer/SiteTransferLocation/BuyersSiteCode[generate-id()
                                       = generate-id(key('Site',.)[1])]">
			
			<!-- Put BuyersSiteCode into a variable so we can use it later -->
			<xsl:variable name="BuyersSiteCode"><xsl:value-of select="."/></xsl:variable>
			
				<!-- Create one line per site for Debits -->
				<xsl:if test="//SiteTransfer/SiteTransferLocation/BuyersSiteCode[.=$BuyersSiteCode and ../../TransactionType='Debit']">
					<!-- Site ID Transfer From -->		
					<xsl:value-of select="."/>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Above 'if' statement filters for Debits, so this will always be Debit -->			
					<xsl:text>Debit</xsl:text>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Transfer Value -->
					<xsl:value-of select="format-number(sum(//SiteTransfer[SiteTransferLocation/BuyersSiteCode=$BuyersSiteCode and TransactionType='Debit']/LineValueExclVAT),'0.00')"/>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Stock Period No -->
					<xsl:value-of select="../../StockFinancialPeriod"/>
					<xsl:value-of select="$RecordSeperator"/>	
				</xsl:if>
				
				<!-- Create one line per site for Credits -->
				<xsl:if test="//SiteTransfer/SiteTransferLocation/BuyersSiteCode[.=$BuyersSiteCode and ../../TransactionType='Credit']">
					<!-- Site ID Transfer From -->		
					<xsl:value-of select="."/>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Above 'if' statement filters for credits, so this will always be Credit -->		
					<xsl:text>Credit</xsl:text>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Transfer Value -->
					<xsl:value-of select="format-number(sum(//SiteTransfer[SiteTransferLocation/BuyersSiteCode=$BuyersSiteCode and TransactionType='Credit']/LineValueExclVAT),'0.00')"/>
					<xsl:value-of select="$FieldSeperator"/>
					<!-- Stock Period No -->
					<xsl:value-of select="../../StockFinancialPeriod"/>
					<xsl:value-of select="$RecordSeperator"/>	
				</xsl:if>
			
		</xsl:for-each>	
	
	</xsl:template>	

</xsl:stylesheet>
