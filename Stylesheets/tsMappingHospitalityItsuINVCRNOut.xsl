<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 itsu mapper for invoices and credits to Navision format.

 © Alternative Business Solutions Ltd, 2011.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 22/03/2011	| Andrew Barber		| FB4243 Created module 
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'+',VATCode)"/>	

	<!-- Invoices -->
	<xsl:template match="/Invoice">
		<!-- Store the Invoice Date-->
		<xsl:variable name="varInvoiceDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Store the Invoice Reference-->					
		<xsl:variable name="valInvoiceReference" select="InvoiceHeader/InvoiceReferences/InvoiceReference" />
		<!-- Store the Order Reference-->					
		<xsl:variable name="valOrderReference" select="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference" />
		<!-- Store the Buyers Code-->
		<xsl:variable name="valBuyersCode" select="TradeSimpleHeader/RecipientsBranchReference" />
		<!-- Store the Supplier Name-->		
		<xsl:variable name="valSupplierName" select="InvoiceHeader/Supplier/SuppliersName" />
		<!-- Store the Delivery Date-->		
		<xsl:variable name="valDeliveryDate" select="InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate" />
		<!-- Store the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender" />
		<!-- Store the Financial Period-->
		<xsl:variable name="valFinancialPeriod" select="substring(InvoiceHeader/HeaderExtraData/FinancialPeriod,5,2)" />
		
		<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',concat(LineExtraData/AccountCode,'+',VATCode))[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/> 
			<!-- Store the Account Code-->	
			<xsl:variable name="AccountCode" select="concat(LineExtraData/AccountCode,'+',VATCode)"/>
			<!-- Blank Field -->
			<xsl:text>,</xsl:text>
			<!-- Vendor Number -->
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
			<!-- Date -->
			<xsl:value-of select="$varInvoiceDate"/>
			<xsl:text>,</xsl:text>
			<!-- Order No. -->
			<xsl:value-of select="$valOrderReference"/>
			<xsl:text>,</xsl:text>
			<!-- Vendor Invoice No. -->
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!-- Branch Code -->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!-- Description (Financial Period / Supplier Name / Delivery Date [DDMM] -->
			<xsl:value-of select="concat($valFinancialPeriod,'/',substring($valSupplierName,1,22),'/',concat(substring($valDeliveryDate,9,2),substring($valDeliveryDate,6,2)))"/>
			<xsl:text>,</xsl:text>
			<!--G/L Account -->
               	<xsl:value-of select="substring-before($AccountCode,'+')"/>
			<xsl:text>,</xsl:text>
			<!-- VAT Code -->
			<xsl:choose>
				<xsl:when test="VATCode='Z'">ZERO</xsl:when>
				<xsl:when test="VATCode='S'">VAT20</xsl:when>
				<xsl:otherwise>UNKNOWN</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- Net Amount -->
			<xsl:value-of select="format-number((sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- VAT Amount -->
			<xsl:value-of select="format-number((sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue))*(VATRate div 100),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- Gross Amount -->
			<xsl:value-of select="format-number(((sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//InvoiceLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue))*((VATRate div 100)+1)),'0.00')"/>
			<xsl:text>&#13;&#10;</xsl:text>	
		</xsl:for-each>
	</xsl:template>
	
	<!-- Credit Notes -->	
	<xsl:template match="/CreditNote">	
		<!-- Store the Credit Note Date-->
		<xsl:variable name="varCreditNoteDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Store the Credit Note Reference-->					
		<xsl:variable name="valCreditNoteReference" select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference" />
		<!-- Invoice Reference ??? -->
		<!-- Store the Order Reference-->					
		<xsl:variable name="valOrderReference" select="CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference" />
		<!-- Store the Buyers Code-->
		<xsl:variable name="valBuyersCode" select="TradeSimpleHeader/RecipientsBranchReference" />
		<!-- Store the Supplier Name-->		
		<xsl:variable name="valSupplierName" select="CreditNoteHeader/Supplier/SuppliersName" />
		<!-- Store the Delivery Date-->		
		<xsl:variable name="valDeliveryDate" select="CreditNoteDetail/CreditNoteLine/DeliveryNoteReferences/DeliveryNoteDate" />
		<!-- Store the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender" />
		<!-- Store the Financial Period-->
		<xsl:variable name="valFinancialPeriod" select="substring(CreditNoteHeader/HeaderExtraData/FinancialPeriod,5,2)" />
			
		<!-- Group By Account Code -->
		<xsl:for-each select="(/CreditNote/CreditNoteDetail/CreditNoteLine)[generate-id() = generate-id(key('keyLinesByAccount',concat(LineExtraData/AccountCode,'+',VATCode))[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/> 
			<!-- Store the Account Code-->	
			<xsl:variable name="AccountCode" select="concat(LineExtraData/AccountCode,'+',VATCode)"/>
			<!-- Blank Field -->
			<xsl:text>,</xsl:text>
			<!-- Vendor Number -->
			<xsl:value-of select="$valRecipientsCodeForSender"/>
			<xsl:text>,</xsl:text>
			<!-- Date -->
			<xsl:value-of select="$varCreditNoteDate"/>
			<xsl:text>,</xsl:text>
			<!-- Order No. -->
			<xsl:value-of select="$valOrderReference"/>
			<xsl:text>,</xsl:text>
			<!-- Vendor Invoice No. -->
			<xsl:value-of select="$valCreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<!-- Branch Code -->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<!-- Description (Financial Period / Supplier Name / Delivery Date [DDMM] -->
			<xsl:value-of select="concat($valFinancialPeriod,'/',substring($valSupplierName,1,22),'/',concat(substring($valDeliveryDate,9,2),substring($valDeliveryDate,6,2)))"/>
			<xsl:text>,</xsl:text>
			<!--G/L Account -->
               	<xsl:value-of select="substring-before($AccountCode,'+')"/>
			<xsl:text>,</xsl:text>
			<!-- VAT Code -->
			<xsl:choose>
				<xsl:when test="VATCode='Z'">ZERO</xsl:when>
				<xsl:when test="VATCode='S'">VAT20</xsl:when>
				<xsl:otherwise>UNKNOWN</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- Net Amount -->
			<xsl:value-of select="format-number(-1 * (sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- VAT Amount -->
			<xsl:value-of select="format-number(-1 * (sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue))*(VATRate div 100),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- Gross Amount -->
			<xsl:value-of select="format-number(-1 * ((sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineValueExclVAT)-sum(//CreditNoteLine[concat(LineExtraData/AccountCode,'+',VATCode) = $AccountCode]/LineDiscountValue))*((VATRate div 100)+1)),'0.00')"/>		
			<xsl:text>&#13;&#10;</xsl:text>	
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>		
		<xsl:value-of select="concat(substring($utcFormat,9,2),'/',substring($utcFormat,6,2),'/',substring($utcFormat,1,4))"/>
	</xsl:template>
</xsl:stylesheet>
