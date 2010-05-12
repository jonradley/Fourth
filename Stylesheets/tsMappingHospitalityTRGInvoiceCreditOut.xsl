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
 12/05/2010	| Sandeep Sehgal| FB3516. Group output by  LineExtraData/AccountCode  
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>	

	<xsl:template match="/Invoice">
		<!-- Strore the Invoice Date-->
		<xsl:variable name="varInvoiceDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Strore the Invoice Reference-->					
		<xsl:variable name="valInvoiceReference" select="InvoiceHeader/InvoiceReferences/InvoiceReference" />
		<!-- Strore the Buyers Code-->		
		<xsl:variable name="valBuyersCode" select="InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode" />
		<!-- Strore theTotal Amount Excl VAT-->	
		<xsl:variable name="valSettlementTotalExclVAT" select="format-number(InvoiceTrailer/SettlementTotalExclVAT,'0.00')" />
		<!-- Strore the VAT-->	
		<xsl:variable name="valVATAmount" select="format-number(InvoiceTrailer/VATAmount,'0.00')" />
		<!-- Strore the Settlement total amount INCl vat-->	
		<xsl:variable name="valSettlementTotalInclVAT" select="format-number(InvoiceTrailer/SettlementTotalInclVAT,'0.00')" />
		<!-- Strore the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender">
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/> 
			<!-- Strore the Account Code-->	
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/> 	
			<xsl:value-of select="$varInvoiceDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!-- blank -->
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valVATAmount"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalInclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
               <xsl:value-of select="$AccountCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="format-number((sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT)-sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>&#13;&#10;</xsl:text>	
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="/CreditNote">	
	
		<!-- Strore the CN Date-->
		<xsl:variable name="varCreditNoteDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Strore the CN Reference-->					
		<xsl:variable name="valCreditNoteReference" select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference" />
		<!-- Strore the Invoice Reference-->					
		<xsl:variable name="valInvoiceReference" select="CreditNoteHeader/InvoiceReferences/InvoiceReference" />
		<!-- Strore the Buyers Code-->		
		<xsl:variable name="valBuyersCode" select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode" />
		<!-- Strore the Credit Total amount excl vat-->	
		<xsl:variable name="valSettlementTotalExclVAT" select="format-number(-1 * CreditNoteTrailer/SettlementTotalExclVAT,'0.00')" />
		<!-- Strore the VAT-->	
		<xsl:variable name="valVATAmount" select="format-number(-1 * CreditNoteTrailer/VATAmount,'0.00')" />
		<!-- Strore the Settlement total amount Incl VAT-->	
		<xsl:variable name="valSettlementTotalInclVAT" select="format-number(-1 * CreditNoteTrailer/SettlementTotalInclVAT,'0.00')" />
		<!-- Strore the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender">
			<xsl:choose>
				<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
					<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Group By Account Code -->
		<xsl:for-each select="(/CreditNote/CreditNoteDetail/CreditNoteLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/> 
			<!-- Strore the Account Code-->	
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/> 	
			<xsl:value-of select="$varCreditNoteDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valCreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalExclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valVATAmount"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalInclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
               <xsl:value-of select="$AccountCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="format-number( -1 * (sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT)-sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>&#13;&#10;</xsl:text>	
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
		
		<xsl:value-of select="concat(substring($utcFormat,9,2),'/',substring($utcFormat,6,2),'/',substring($utcFormat,3,2))"/>
	
	</xsl:template>
	
		
</xsl:stylesheet>
