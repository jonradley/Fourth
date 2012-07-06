<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Novus Leisure map for invoices and credits to Sun financials format.

 © Fourth Hospitality, 2012.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 09/01/2012	| A Barber				| FB5159	Created module 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyInvoiceLinesByAccount" match="InvoiceLine" use="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference)"/>

	<xsl:key name="keyCreditLinesByAccount" match="CreditNoteLine" use="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>

	
	<xsl:template match="/BatchRoot">
	
		<!-- Column Headers -->
		<xsl:text>Layout_ID</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>A/C_Code</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Date</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Reference</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Description</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Amount</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Period</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Bar</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>VAT</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>D/C</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>Creditor Analysis</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- First Line must contain '1;2' -->
		<xsl:text>1;2</xsl:text>
		
		<xsl:for-each select="Invoice">
		
			<!-- Store the Invoice Date-->
			<xsl:variable name="varInvoiceDate">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="utcFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- Store the Delivery Note Reference-->
			<xsl:variable name="valDeliveryNoteReference" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteReference[1]"/>
			<!-- Store the Invoice Reference -->
			<xsl:variable name="valInvoiceReference" select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<!-- Store the Buyers Code-->
			<xsl:variable name="valBuyersCode" select="substring-before(TradeSimpleHeader/RecipientsBranchReference,'-')"/>
			<!-- Store theTotal Amount Excl VAT-->
			<xsl:variable name="valSettlementTotalExclVAT" select="format-number(InvoiceTrailer/SettlementTotalExclVAT,'0.00')"/>
			<!-- Store the VAT-->
			<xsl:variable name="valVATAmount" select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
			<!-- Store the Settlement total amount INCl vat-->
			<xsl:variable name="valSettlementTotalInclVAT" select="format-number(InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/>
			<!-- Store the Reciepient Code for Sender-->
			<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender"/>
			<!-- Store the Financial Period -->
			<xsl:variable name="valFinancialPeriod" select="concat(substring(InvoiceHeader/HeaderExtraData/FinancialPeriod,1,4),'/',format-number(substring	(InvoiceHeader/HeaderExtraData/FinancialPeriod,5,2),'000'))"/>
			<xsl:variable name="valVATRated" select="count(InvoiceDetail/InvoiceLine/VATCode[.='S'])"/>
			
			<!-- Invoice Header -->
			<xsl:choose>
				<xsl:when test="preceding-sibling::Invoice[1]">
					<xsl:text>2;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varInvoiceDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!--Comprise of venue code (substring) / supplier name / DN reference-->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$valDeliveryNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalInclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valFinancialPeriod"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!--Tax Code-->
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>IT</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>IZ</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>C</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!-- Nominal Code Grouped Lines -->
			<xsl:for-each select="(InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyInvoiceLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference))[1])]">
				<xsl:sort select="translate(LineExtraData/AccountCode,'&quot;','')" data-type="text"/>
				<!-- Store the Account Code-->
				<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference)"/>
				<xsl:text>2;</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="concat(substring($AccountCode,1,4),'00')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$varInvoiceDate"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valInvoiceReference"/>
				<xsl:text>,</xsl:text>
				<!--Comprise of venue code (substring) / supplier name / DN reference-->
				<xsl:value-of select="$valBuyersCode"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="../../InvoiceHeader/Supplier/SuppliersName"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$valDeliveryNoteReference"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number((sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference) = 	$AccountCode]/LineValueExclVAT)-sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference) = 	$AccountCode]/LineDiscountValue)),'0.00')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valFinancialPeriod"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valBuyersCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="LineExtraData/BuyersVATCode"/>
				<xsl:text>,</xsl:text>
				<xsl:text>D</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valRecipientsCodeForSender"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
			<!-- VAT Amount Line -->
			<xsl:text>2;</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>790100</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varInvoiceDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!--Comprise of venue code (substring) / supplier name / DN reference-->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="InvoiceHeader/Supplier/SuppliersName"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$valDeliveryNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valVATAmount"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valFinancialPeriod"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!-- Tax Code -->
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>IT</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>IZ</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>	
		
		<xsl:for-each select="CreditNote">
		
			<!-- Store the Credit Note Date-->
			<xsl:variable name="varCreditNoteDate">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="utcFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- Store the Delivery Note Reference-->
			<xsl:variable name="valDeliveryNoteReference" select="CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteReference[1]"/>
			<!-- Store the Credit Note Reference -->
			<xsl:variable name="valCreditNoteReference" select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<!-- Store the Buyers Code-->
			<xsl:variable name="valBuyersCode" select="substring-before(TradeSimpleHeader/RecipientsBranchReference,'-')"/>
			<!-- Store theTotal Amount Excl VAT-->
			<xsl:variable name="valSettlementTotalExclVAT" select="format-number(CreditNoteTrailer/SettlementTotalExclVAT,'0.00')"/>
			<!-- Store the VAT-->
			<xsl:variable name="valVATAmount" select="format-number(CreditNoteTrailer/VATAmount,'0.00')"/>
			<!-- Store the Settlement total amount INCl vat-->
			<xsl:variable name="valSettlementTotalInclVAT" select="format-number(CreditNoteTrailer/SettlementTotalInclVAT,'0.00')"/>
			<!-- Store the Reciepient Code for Sender-->
			<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender"/>
			<!-- Store the Financial Period -->
			<xsl:variable name="valFinancialPeriod" select="concat(substring(CreditNoteHeader/HeaderExtraData/FinancialPeriod,1,4),'/',format-number(substring	(CreditNoteHeader/HeaderExtraData/FinancialPeriod,5,2),'000'))"/>
			<xsl:variable name="valVATRated" select="count(CreditNoteDetail/CreditNoteLine/VATCode[.='S'])"/>
			
			<!-- Credit Note Header -->
			<xsl:choose>
				<xsl:when test="preceding-sibling::CreditNote[1]">
					<xsl:text>2;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varCreditNoteDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valCreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<!--Comprise of venue code (substring) / supplier name / DN reference-->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersName"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$valDeliveryNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valSettlementTotalInclVAT"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valFinancialPeriod"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!--Tax Code-->
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>IT</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>IZ</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
			<!-- Nominal Code Grouped Lines -->
			<xsl:for-each select="(CreditNoteDetail/CreditNoteLine)[generate-id() = generate-id(key('keyCreditLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference))[1])]">
				<xsl:sort select="translate(LineExtraData/AccountCode,'&quot;','')" data-type="text"/>
				<!-- Store the Account Code-->
				<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>
				<xsl:text>2;</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="concat(substring($AccountCode,1,4),'00')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$varCreditNoteDate"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valCreditNoteReference"/>
				<xsl:text>,</xsl:text>
				<!--Comprise of venue code (substring) / supplier name / DN reference-->
				<xsl:value-of select="$valBuyersCode"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="../../CreditNoteHeader/Supplier/SuppliersName"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$valDeliveryNoteReference"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number((sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference) = 	$AccountCode]/LineValueExclVAT)-sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference) = 	$AccountCode]/LineDiscountValue)),'0.00')"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valFinancialPeriod"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valBuyersCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="LineExtraData/BuyersVATCode"/>
				<xsl:text>,</xsl:text>
				<xsl:text>C</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$valRecipientsCodeForSender"/>
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:for-each>
			
			<!-- VAT Amount Line -->
			<xsl:text>2;</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>790100</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varCreditNoteDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valCreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<!--Comprise of venue code (substring) / supplier name / DN reference-->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="CreditNoteHeader/Supplier/SuppliersName"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$valDeliveryNoteReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valVATAmount"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valFinancialPeriod"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!-- Tax Code -->
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>IT</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>IZ</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>C</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>&#13;&#10;</xsl:text>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
		<xsl:value-of select="concat(substring($utcFormat,9,2),'/',substring($utcFormat,6,2),'/',substring($utcFormat,1,4))"/>
	</xsl:template>
	
</xsl:stylesheet>
