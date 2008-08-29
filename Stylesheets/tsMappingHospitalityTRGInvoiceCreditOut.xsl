<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TRG mapper for invoices and credits to Navision format

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 28/08/2007	| R Cambridge			| FB1400 Created module 
==========================================================================================
 29/08/2008	| Lee Boyton       	| FB2452. Supplier Code added, as per v1-1 of specification.
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:template match="/Invoice">
	

		<xsl:call-template name="formatDate">
			<xsl:with-param name="utcFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		
		<!-- blank -->
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalExclVAT,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>&#13;&#10;</xsl:text>

	</xsl:template>
	
	
	
	<xsl:template match="/CreditNote">	
	


		<xsl:call-template name="formatDate">
			<xsl:with-param name="utcFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
		</xsl:call-template>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>,</xsl:text>
		
		<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(-1 * CreditNoteTrailer/SettlementTotalExclVAT,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(-1 * CreditNoteTrailer/VATAmount,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="format-number(-1 * CreditNoteTrailer/SettlementTotalInclVAT,'0.00')"/>
		<xsl:text>,</xsl:text>
		
		
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>&#13;&#10;</xsl:text>

	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
		
		<xsl:value-of select="concat(substring($utcFormat,9,2),'/',substring($utcFormat,6,2),'/',substring($utcFormat,3,2))"/>
	
	</xsl:template>
	
		
</xsl:stylesheet>
