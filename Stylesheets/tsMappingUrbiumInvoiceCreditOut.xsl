<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

Maps internal invoices and credits into a csv format for Urbium.  The csv files
will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2005.
******************************************************************************************
 Module History
******************************************************************************************
 Date      	 	| Name       	 	| Description of modification
******************************************************************************************
 22/08/2005 	| A Sheppard  	| Created module.
******************************************************************************************
 05/09/2005 	| Lee Boyton	| H488. The Bar (unit) code is the buyer's branch reference.
******************************************************************************************
 06/09/2005 	| Lee Boyton	| H488. Fix to Credit notes incorrectly outputing invoice details.
******************************************************************************************
 23/10/2006 	| Lee Boyton	| 483. (NOV001) Change to the Journal Type column value.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	<xsl:template match="/Invoice">
		<xsl:variable name="BarCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
		</xsl:variable>
		<!--Purchase Lines-->
		<xsl:for-each select="//InvoiceLine">
			<xsl:sort select="LineExtraData/AccountCode"/>
			<xsl:sort select="VATCode"/>
			<xsl:if test="user:gbIsNewRefPair(LineExtraData/AccountCode, VATCode)">
				<xsl:variable name="AccountCode">
					<xsl:value-of select="LineExtraData/AccountCode"/>
				</xsl:variable>
				<xsl:variable name="VATCode">
					<xsl:value-of select="VATCode"/>
				</xsl:variable>
				<xsl:value-of select="translate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate, '-', '')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$BarCode"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
				<xsl:text> INV</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
				<xsl:text>/0</xsl:text>
				<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
				<xsl:text>,</xsl:text>
				<xsl:text>PIZ</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>D</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$AccountCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$BarCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="LineExtraData/BuyersVATCode"/>
				<xsl:value-of select="user:msCarriageReturn()"/>
			</xsl:if>
		</xsl:for-each>
		<!--Taxes Lines-->
		<xsl:for-each select="//VATSubTotal[@VATRate != 0.00]">
			<xsl:value-of select="translate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate, '-', '')"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$BarCode"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
			<xsl:text> INV</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
			<xsl:text>/0</xsl:text>
			<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATAmountAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:text>PIZ</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/TaxAccount"/>
			<xsl:value-of select="user:msCarriageReturn()"/>
		</xsl:for-each>
		<!--Supplier Line-->
		<xsl:value-of select="translate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate, '-', '')"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$BarCode"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
		<xsl:text> INV</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
		<xsl:text>/0</xsl:text>
		<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:text>PIZ</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>C</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/NominalCode"/>
	</xsl:template>
	
	<xsl:template match="/CreditNote">
		<xsl:variable name="BarCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
		</xsl:variable>
		<!--Purchase Lines-->
		<xsl:for-each select="//CreditNoteLine">
			<xsl:sort select="HeaderExtraData/AccountCode"/>
			<xsl:sort select="VATCode"/>
			<xsl:if test="user:gbIsNewRefPair(LineExtraData/AccountCode, VATCode)">
				<xsl:variable name="AccountCode">
					<xsl:value-of select="LineExtraData/AccountCode"/>
				</xsl:variable>
				<xsl:variable name="VATCode">
					<xsl:value-of select="VATCode"/>
				</xsl:variable>
				<xsl:value-of select="translate(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate, '-', '')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$BarCode"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
				<xsl:text> CN</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
				<xsl:text>/0</xsl:text>
				<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number(sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
				<xsl:text>,</xsl:text>
				<xsl:text>PCZ</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:text>C</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$AccountCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$BarCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="LineExtraData/BuyersVATCode"/>
				<xsl:value-of select="user:msCarriageReturn()"/>
			</xsl:if>
		</xsl:for-each>
		<!--Taxes Lines-->
		<xsl:for-each select="//VATSubTotal[@VATRate != 0.00]">
			<xsl:value-of select="translate(/CreditNoteHeader/CreditNoteReferences/CreditNoteDate, '-', '')"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$BarCode"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
			<xsl:text> CN</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
			<xsl:text>/0</xsl:text>
			<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATAmountAtRate"/>
			<xsl:text>,</xsl:text>
			<xsl:text>PCZ</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>C</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/TaxAccount"/>
			<xsl:value-of select="user:msCarriageReturn()"/>
		</xsl:for-each>
		<!--Supplier Line-->
		<xsl:value-of select="translate(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate, '-', '')"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$BarCode"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName, ',', ';'), 1, 18)"/>
		<xsl:text> CN</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
		<xsl:text>/0</xsl:text>
		<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		<xsl:text>PCZ</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>D</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/NominalCode"/>
	</xsl:template>
	
	<msxsl:script language="Javascript" implements-prefix="user"><![CDATA[ 
	         function msCarriageReturn()
	         {
	         	return '\n';
	         }
	]]></msxsl:script>
</xsl:stylesheet>