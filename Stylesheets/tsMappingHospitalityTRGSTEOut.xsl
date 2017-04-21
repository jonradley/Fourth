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
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>

	
	<xsl:template match="/">
	
	<xsl:text>TRG Closing Transfer Values Export</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:text>Exported Date:</xsl:text>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="translate(SiteTransfersExport/SiteTransfersExportHeader/ExportRunDate,'-','/')"/>
	<xsl:value-of select="$FieldSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	<xsl:value-of select="$RecordSeperator"/>
	
	<!-- Headers -->
	<xsl:text>Site ID Transfer From,Debit,Transfer Value,Stock Period No</xsl:text>
	<xsl:value-of select="$RecordSeperator"/>
	
	<xsl:for-each select="SiteTransfersExport/SiteTransfers/SiteTransfer">
	
		<!-- Site ID Transfer From -->
		<xsl:value-of select="SiteTransferLocation/BuyersSiteCode"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Credit/Debit -->
		<xsl:value-of select="TransactionType"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Transfer Value -->
		<xsl:value-of select="LineValueExclVAT"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Stock Period No -->
		<xsl:value-of select="StockFinancialPeriod"/>
		<xsl:value-of select="$RecordSeperator"/>	
	</xsl:for-each>

	<!-- Trailer -->
	<xsl:value-of select="$RecordSeperator"/>	
	<xsl:text>Exported Date:</xsl:text>
	
	</xsl:template>
	

</xsl:stylesheet>
