<?xml version="1.0" encoding="UTF-8"?>
<!--================================================================================================================================
 Module History
====================================================================================================================================
 Version	| 
====================================================================================================================================
 Date      	| Name 				| Description of modification
====================================================================================================================================
 03/09/2014	| Jose Miguel		| FB9009 - ISS HED - Primary education mapper for weekly invoices/credit notes batches in new format
====================================================================================================================================
 27/11/2014	| Jose Miguel		| FB10097- ISS HED - Limit cost code column to only 4 chars
====================================================================================================================================
 17/12/2014	| Jose Miguel		| FB10105- ISS HED - Fix the Expense Code and the sign for credits
====================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:template match="Batch">
		<xsl:apply-templates select="BatchDocuments/BatchDocument/Invoice | BatchDocuments/BatchDocument/CreditNote"/>
	</xsl:template>
	<xsl:template match="Invoice | CreditNote">
		<xsl:variable name="type" select="name(.)"/>
		<xsl:variable name="sign">
			<xsl:choose>
				<xsl:when test="$type = 'Invoice'">1</xsl:when>
				<xsl:when test="$type = 'CreditNote'">-1</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- Header line -->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="$type = 'Invoice'">
				<xsl:text>PLJJI</xsl:text>
			</xsl:when>
			<xsl:when test="$type = 'CreditNote'">
				<xsl:text>PLJJC</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>,</xsl:text>
		<!-- JM unit name -->
		<xsl:value-of select="(InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$sign * number((InvoiceTrailer | CreditNoteTrailer)/SettlementTotalInclVAT)"/>
		<xsl:text>,</xsl:text>
		<!-- docdate -->
		<xsl:call-template name="formatDateToDDMMYYYY">
			<xsl:with-param name="date" select="InvoiceHeader/InvoiceReferences/InvoiceDate | CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		<!-- vatvat1 -->
		<xsl:value-of select="$sign * number((InvoiceTrailer | CreditNoteTrailer)/VATAmount)"/>
		<xsl:text>,</xsl:text>
		<!-- vatgoods1 -->
		<xsl:value-of select="$sign * number((InvoiceTrailer | CreditNoteTrailer)/SettlementTotalExclVAT)"/>
		<xsl:text>,</xsl:text>
		<!-- vatcode1 -->
		<xsl:choose>
			<xsl:when test="number((InvoiceTrailer | CreditNoteTrailer)/VATAmount)!=0">S</xsl:when>
			<xsl:otherwise>Z</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender, 1, 4)"/>
		<!-- Trailer line -->
		<xsl:text>&#13;&#10;</xsl:text>
		<xsl:text>N</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- costcode -->
		<xsl:value-of select="substring((InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToLocationID/BuyersCode, 1, 4)"/>
		<xsl:text>,</xsl:text>
		<!-- expensecode -->
		<xsl:text>12-2-01</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- JM unit name -->
		<xsl:value-of select="(InvoiceHeader | CreditNoteHeader)/ShipTo/ShipToName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$sign * number((InvoiceTrailer | CreditNoteTrailer)/SettlementTotalExclVAT)"/>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="number((InvoiceTrailer | CreditNoteTrailer)/VATAmount)!=0">S</xsl:when>
			<xsl:otherwise>Z</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<!-- Format the date as dd/mm/yyyy -->
	<xsl:template name="formatDateToDDMMYYYY">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
	</xsl:template>
</xsl:stylesheet>
