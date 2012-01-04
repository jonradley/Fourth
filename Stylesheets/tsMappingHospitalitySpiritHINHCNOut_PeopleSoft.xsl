<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

	Invoice/credit approval report to Spirit's Peoplesoft system

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 18/05/2011	| R Cambridge			| 4376 Created module
==========================================================================================
 20/07/2011 | A Barber	                	| 4376 Updated all name references from Punch to Spirit.
==========================================================================================
 15/08/2011 | A Barber                 	| 4686 Always provide etiher only 'Y' or 'N' as force match indicator
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:param name="sDocumentDate">Not Provided</xsl:param>
	<xsl:param name="sDocumentTime">Not Provided</xsl:param>
	<xsl:param name="nBatchID">Not Provided</xsl:param>
	
	<xsl:variable name="RECORD_SEPARATOR" select="'&#13;&#10;'"/>
	
	<xsl:variable name="AUTO_AUTH_USERNAME" select="'SYSTEM'"/>

	
	<xsl:template match="/">

		<xsl:call-template name="writeBatchHeader"/>
		
		<xsl:value-of select="$RECORD_SEPARATOR"/>
		
		<xsl:for-each select="BatchRoot/*">
			<xsl:call-template name="writeInvoiceSummaryLine"/>
			<xsl:value-of select="$RECORD_SEPARATOR"/>
		</xsl:for-each>

		<xsl:call-template name="writeBatchTrailer"/>
		
		<xsl:value-of select="$RECORD_SEPARATOR"/>		
		
		
	</xsl:template>
	
	<xsl:template name="writeBatchHeader">
	
		<!-- Record type ‘A0’ -->
		<xsl:text>A0</xsl:text>
		
		<!-- Date -->
		<xsl:text>20</xsl:text>
		<xsl:value-of select="translate($sDocumentDate,'-','')"/>
		
		<!-- Time -->
		<xsl:value-of select="translate($sDocumentTime,':','')"/>
		
		<!-- File Sequence number -->
		<!-- the formating format-number($nBatchID,'000000') is implied here but at the point this XSL is 
				applied $nBatchID contains just a text place holder (as obtaining an FGN requires a messageid 
				and obtaining a messageid required a batch GUID which will not have been created at this point ) -->
		<!-- The formating is defined by the config XML setting //FileGenerationNumberFormat -->
		<xsl:value-of select="$nBatchID"/>
		
		<!-- Padding -->
		<xsl:value-of select="'           '"/>
	
	</xsl:template>
	
	
	<xsl:template name="writeInvoiceSummaryLine">
	
		<!-- Record type ‘A1’ -->
		<xsl:text>A1</xsl:text>
		
		<!-- Supplier -->
		<xsl:value-of select="format-number(*/HeaderExtraData/STXSupplierCode,'000000')"/>
		
		<!-- Voucher ID -->
		<xsl:value-of select="format-number(*/HeaderExtraData/VoucherID,'00000000')"/>
		
		<!-- Sign Bit -->
		<xsl:choose>
			<xsl:when test="self::Invoice">+</xsl:when>
			<xsl:when test="self::CreditNote">-</xsl:when>
			<xsl:otherwise>?</xsl:otherwise>
		</xsl:choose>

		
		<!-- Invoice Gross Value -->
		<xsl:value-of select="translate(format-number(*/DocumentTotalExclVAT,'0000000000000.00'),'.','')"/>
		
		<!-- Force Match Indicator -->
		<xsl:choose>
			<!--xsl:when test="not(InvoiceHeader/HeaderExtraData/Authorisation/AuthorisedBy)">?</xsl:when-->
			<xsl:when test="translate(InvoiceHeader/HeaderExtraData/Authorisation/AuthorisedBy,'system','SYSTEM') != $AUTO_AUTH_USERNAME">Y</xsl:when>
			<xsl:otherwise>N</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	
	<xsl:template name="writeBatchTrailer">
	
		<!-- Record type ‘Z0’ -->
		<xsl:text>Z0</xsl:text>
		
		<!-- Record count -->
		<xsl:value-of select="format-number(count(/BatchRoot/*) + 2,'000000000000')"/>
		
		<!-- Padding -->
		<xsl:value-of select="'                   '"/>

	
	</xsl:template>


	
</xsl:stylesheet>
