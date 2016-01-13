<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a (Sun) csv format for Searcy.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 26/06/2008 | Shailesh Dubey| Created module.
******************************************************************************************
 
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:user="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note;  the '::' literal is simply used as a convenient separator for the 2 values that make up the second key. -->
	<xsl:key name="keyLinesByVAT" match="InvoiceLine | CreditNoteLine" use="LineExtraData/BuyersVATCode"/>
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	<xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',LineExtraData/BuyersVATCode)"/>
	
	<xsl:template match="/Invoice | /CreditNote">
			
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		<xsl:variable name="RowTypeIndicator">
			<xsl:text>2;</xsl:text>
		</xsl:variable>
		
		<!-- store the document date as it is referenced on multiple lines -->		
		<xsl:variable name="DocumentDate">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate">
					<xsl:call-template name="formatDate">
						<xsl:with-param name="xmlDate" select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="formatDate">
						<xsl:with-param name="xmlDate" select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- store the document reference as it is referenced on multiple lines -->		
		<xsl:variable name="DocumentReference">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference">
					<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		
		<!-- construct the value for the Supplier Detail field -->		
		<xsl:variable name="SuppliersName">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
					<xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName,',',''),1,50)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName,',',''),1,50)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- construct the value for the journal type field as it is used on multiple lines -->
		<xsl:variable name="JournalType">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/JournalType">
					<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/JournalType"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/JournalType"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

			
		<!-- construct the value for the Department as it is used on multiple lines -->
		<xsl:variable name="Department">		
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/Department">
					<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/Department"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/Credit/CreditNoteDetail/CreditNoteLine/LineExtraData/Department"/>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>	
		
		<!-- construct the value for the Supplier Code as it is used on multiple lines -->
		<xsl:variable name="SupplierCode" select="TradeSimpleHeader/RecipientsCodeForSender"/>
		
		<!-- construct the value for the description field as it is used on multiple lines -->		
		<xsl:variable name="Description">			
			<xsl:choose>
				<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsName">
					<xsl:text>Purchase Invoice-</xsl:text><xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Purchase Invoice-</xsl:text><xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsName"/>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
		
		<!-- construct the value for the Operator Code field as it is used on multiple lines -->		
		<xsl:variable name="OperatorCode">	
			<xsl:text>tradesimple</xsl:text>			
		</xsl:variable>
		
		<!-- construct the value for the AccountingPeriod as it is used on multiple lines -->
		<xsl:variable name="AccountingPeriod">	
		<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod">
					<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
					<xsl:text>0</xsl:text>
					<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>
					<xsl:text>0</xsl:text>
					<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				</xsl:otherwise>
		</xsl:choose>		
		</xsl:variable>
		
		<!--Purchase Lines-->		
		<!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',LineExtraData/BuyersVATCode))[1])]">
				<xsl:sort select="LineExtraData/BuyersVATCode" data-type="text"/>
				<xsl:variable name="TranslatedVatCode" select="LineExtraData/BuyersVATCode"/>
				
					<!-- now output a summary line for the current Account Code and VAT Code combination -->
					<xsl:value-of select="$RowTypeIndicator"/>
					<xsl:text>,</xsl:text>				
					<xsl:value-of select="$DocumentReference"/>
					<xsl:text>,</xsl:text>				
					<xsl:value-of select="$DocumentDate"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$AccountCode"/>
					<xsl:text>,</xsl:text>
					<xsl:text>Cost of Sale</xsl:text>   
					<xsl:text>,</xsl:text>
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT),'0.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$Department"/>
					<xsl:text>,</xsl:text>	
					<xsl:value-of select="$TranslatedVatCode"/>
					<xsl:text>,</xsl:text> 
					<xsl:value-of select="$SupplierCode"/>
					<xsl:text>,</xsl:text>			
					<xsl:value-of select="$JournalType"/>
					<xsl:text>,</xsl:text>					
					<xsl:value-of select="$Description"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$OperatorCode"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$AccountingPeriod"/>															
					<xsl:value-of select="$NewLine"/>
			</xsl:for-each>
		</xsl:for-each>
		
		<!--Taxes Lines-->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByVAT',LineExtraData/BuyersVATCode)[1])]">
			<xsl:sort select="LineExtraData/BuyersVATCode" data-type="text"/>
			<xsl:variable name="TranslatedVatCode" select="LineExtraData/BuyersVATCode"/>
			<xsl:variable name="VATRate" select="VATRate"/>

			<xsl:value-of select="$RowTypeIndicator"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
			<xsl:text>700400</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>VAT INPUTS</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT)  * ($VATRate div 100) ,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT) * ($VATRate div 100),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$Department"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$TranslatedVatCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$SupplierCode"/>
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$JournalType"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$Description"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$OperatorCode"/>
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$AccountingPeriod"/>						
			<xsl:value-of select="$NewLine"/>
		</xsl:for-each>
		
		<!--Supplier Line-->
		<xsl:value-of select="$RowTypeIndicator"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$DocumentReference"/>
		<xsl:text>,</xsl:text>		
		<xsl:value-of select="$DocumentDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$SuppliersName"/>
		<xsl:text>,</xsl:text>
			<xsl:choose>
			<xsl:when test="/Invoice/InvoiceTrailer/SettlementTotalInclVAT">
				<xsl:value-of select="format-number(-1 * /Invoice/InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$Department"/>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/VATTrailerExtraData/BuyersVATCode">
				<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/VATTrailerExtraData/BuyersVATCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/VATTrailerExtraData/BuyersVATCode"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>	
		<xsl:value-of select="$SupplierCode"/>
		<xsl:text>,</xsl:text>	
		<xsl:value-of select="$JournalType"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$Description"/>		
		<xsl:text>,</xsl:text>	
		<xsl:value-of select="$OperatorCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$AccountingPeriod"/>		
		<xsl:value-of select="$NewLine"/>

	</xsl:template>
		
	<!-- translates a date in YYYY-MM-DD format to a date in DD/MM/YYYY format -->
	<xsl:template name="formatDate">
		<xsl:param name="xmlDate"/>
		
		<xsl:value-of select="substring($xmlDate,9,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($xmlDate,6,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($xmlDate,1,4)"/>
		
	</xsl:template>
		
</xsl:stylesheet>
