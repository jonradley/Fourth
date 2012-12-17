<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 Glendola Leisure map for invoices and credits to Sun financials format.

 © Fourth Hospitality, 2012.
==========================================================================================
 Module History
==========================================================================================
 Version	| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 09/01/2012	| A Barber				| FB5159	Created module 
=======================================================================================
 24/04/2012	| M Emanuel				| Copying Novus Leisure Inv mapper to create Glendola Leisure Inv mapper
 =======================================================================================
 06/06/2012	| A Babrer				| FB5506 Introduced additional fields and nominal descripiton lookup
 =======================================================================================
 17/12/2012	| A Babrer				| FB5910 Fixed descripiton for credit note VAT line.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!--Define key to be used for finding distinct line information. -->
	<xsl:key name="keyInvoiceLinesByAccount" match="InvoiceLine" use="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference)"/>
	<xsl:key name="keyCreditLinesByAccount" match="CreditNoteLine" use="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>
	
	<!-- Invoice -->
	<xsl:template match="/Invoice">
	
		<!-- Store the Invoice Date-->
		<xsl:variable name="varInvoiceDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Store the Invoice Reference -->
		<xsl:variable name="valInvoiceReference" select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<!-- Store the Buyers Code-->
		<xsl:variable name="valBuyersCode" select="TradeSimpleHeader/RecipientsBranchReference"/>
		<!-- Store theTotal Amount Excl VAT-->
		<xsl:variable name="valSettlementTotalExclVAT" select="format-number(InvoiceTrailer/SettlementTotalExclVAT,'0.00')"/>
		<!-- Store the VAT-->
		<xsl:variable name="valVATAmount" select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
		<!-- Store the Settlement total amount INCl vat-->
		<xsl:variable name="valSettlementTotalInclVAT" select="format-number(InvoiceTrailer/SettlementTotalInclVAT,'0.00')"/>
		<!-- Store the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<!--VAT Rated?-->
		<xsl:variable name="valVATRated" select="count(InvoiceDetail/InvoiceLine/VATCode[.='S'])"/>
		
		<!-- Invoice Header -->
		<xsl:value-of select="$valRecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<!-- Amount Incl VAT-->
		<xsl:value-of select="$valSettlementTotalInclVAT * -1"/>
		<xsl:text>,</xsl:text>
		<!-- Debits/Credits -->
		<xsl:text>C</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Code -->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Rate -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Transaction Date -->
		<xsl:value-of select="$varInvoiceDate"/>
		<xsl:text>,</xsl:text>
		<!-- Transaction Reference -->
		<xsl:value-of select="$valInvoiceReference"/>
		<xsl:text>,</xsl:text>
		<!-- Line Type -->
		<xsl:text>Invoice</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- T3  Operation / Dept Analysis Code -->
		<xsl:value-of select="$valBuyersCode"/>
		<xsl:text>,</xsl:text>
		<!--Tax Code-->
		<xsl:choose>
			<xsl:when test="$valVATRated &gt; 0">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Z</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- Nominal Code Grouped Lines -->
		<xsl:for-each select="(InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyInvoiceLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference))[1])]">
			<xsl:sort select="translate(LineExtraData/AccountCode,'&quot;','')" data-type="text"/>
			<!-- Store the Account Code-->
			<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference)"/>
			<xsl:value-of select="substring-before($AccountCode,'+')"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="format-number((sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference) = 	$AccountCode]/LineValueExclVAT)-sum(../InvoiceLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference) = 	$AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- Debits/Credits -->
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Conversion Code -->
			<xsl:text>GBP</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Conversion Rate -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varInvoiceDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valInvoiceReference"/>
			<xsl:text>,</xsl:text>
			<!--Account Code Description-->
			<xsl:variable name="nominalDescription">
				<xsl:call-template name="transNominalCode">
					<xsl:with-param name="glendolaNominalCode" select="$AccountCode"/>
				</xsl:call-template>									
			</xsl:variable>
			<xsl:value-of select="$nominalDescription"/>
			<xsl:text>,</xsl:text>
			<!--Unit Code-->
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>S</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Z</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
		
		<!-- VAT Amount Line -->
		<xsl:text>25820</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$valVATAmount"/>
		<xsl:text>,</xsl:text>
		<!-- Debits/Credits -->
		<xsl:text>D</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Code -->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Rate -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$varInvoiceDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$valInvoiceReference"/>
		<xsl:text>,</xsl:text>
		<xsl:text>VAT Input (DR)</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$valBuyersCode"/>
		<xsl:text>,</xsl:text>
		<!-- Tax Code -->
		<xsl:choose>
			<xsl:when test="$valVATRated &gt; 0">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Z</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	
	
	<!--Credit Note-->
	<xsl:template match="/CreditNote">
	
		<!-- Store the Credit Note Date-->
		<xsl:variable name="varCreditNoteDate">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="utcFormat" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- Store the Credit Note Reference -->
		<xsl:variable name="valCreditNoteReference" select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<!-- Store the Buyers Code-->
		<xsl:variable name="valBuyersCode" select="TradeSimpleHeader/RecipientsBranchReference"/>
		<!-- Store theTotal Amount Excl VAT-->
		<xsl:variable name="valSettlementTotalExclVAT" select="format-number(CreditNoteTrailer/SettlementTotalExclVAT,'0.00')"/>
		<!-- Store the VAT-->
		<xsl:variable name="valVATAmount" select="format-number(CreditNoteTrailer/VATAmount,'0.00')"/>
		<!-- Store the Settlement total amount INCl vat-->
		<xsl:variable name="valSettlementTotalInclVAT" select="format-number(CreditNoteTrailer/SettlementTotalInclVAT,'0.00')"/>
		<!-- Store the Reciepient Code for Sender-->
		<xsl:variable name="valRecipientsCodeForSender" select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<!--VAT Rated?-->
		<xsl:variable name="valVATRated" select="count(CreditNoteDetail/CreditNoteLine/VATCode[.='S'])"/>
		
		<!-- Credit Note Header -->
		<xsl:value-of select="$valRecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<!-- Amount Incl VAT-->
		<xsl:value-of select="$valSettlementTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		<!-- Debits/Credits -->
		<xsl:text>D</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Code -->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Rate -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Transaction Date -->
		<xsl:value-of select="$varCreditNoteDate"/>
		<xsl:text>,</xsl:text>
		<!-- Transaction Reference -->
		<xsl:value-of select="$valCreditNoteReference"/>
		<xsl:text>,</xsl:text>
		<!-- Line Type -->
		<xsl:text>Credit</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- T3  Operation / Dept Analysis Code -->
		<xsl:value-of select="$valBuyersCode"/>
		<xsl:text>,</xsl:text>
		<!--Tax Code-->
		<xsl:choose>
			<xsl:when test="$valVATRated &gt; 0">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Z</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>
		
		<!-- Nominal Code Grouped Lines -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine)[generate-id() = generate-id(key('keyCreditLinesByAccount',concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference))[1])]">
			<xsl:sort select="translate(LineExtraData/AccountCode,'&quot;','')" data-type="text"/>
			<!-- Store the Account Code-->
			<xsl:variable name="AccountCode" select="concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>
			<xsl:value-of select="substring-before($AccountCode,'+')"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="-1 * format-number((sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference) = 	$AccountCode]/LineValueExclVAT)-sum(../CreditNoteLine[concat(translate(LineExtraData/AccountCode,'&quot;',''),'+',VATCode,'+',ancestor::CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference) = 	$AccountCode]/LineDiscountValue)),'0.00')"/>
			<xsl:text>,</xsl:text>
			<!-- Debits/Credits -->
			<xsl:text>C</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Conversion Code -->
			<xsl:text>GBP</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Conversion Rate -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$varCreditNoteDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valCreditNoteReference"/>
			<xsl:text>,</xsl:text>
			<!--Account Code Description-->
			<xsl:variable name="nominalDescription">
				<xsl:call-template name="transNominalCode">
					<xsl:with-param name="glendolaNominalCode" select="$AccountCode"/>
				</xsl:call-template>									
			</xsl:variable>
			<xsl:value-of select="$nominalDescription"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$valBuyersCode"/>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="$valVATRated &gt; 0">
					<xsl:text>S</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Z</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:for-each>
		
		<!-- VAT Amount Line -->
		<xsl:text>25810</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="-1 * $valVATAmount"/>
		<xsl:text>,</xsl:text>
		<!-- Debits/Credits -->
		<xsl:text>C</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Code -->
		<xsl:text>GBP</xsl:text>
		<xsl:text>,</xsl:text>
		<!-- Conversion Rate -->
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$varCreditNoteDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$valCreditNoteReference"/>
		<xsl:text>,</xsl:text>
		<xsl:text>VAT Output (CR)</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$valBuyersCode"/>
		<xsl:text>,</xsl:text>
		<!-- Tax Code -->
		<xsl:choose>
			<xsl:when test="$valVATRated &gt; 0">
				<xsl:text>S</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Z</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;&#10;</xsl:text>

	</xsl:template>
	
	<xsl:template name="formatDate">
		<xsl:param name="utcFormat"/>
		<xsl:value-of select="concat(substring($utcFormat,9,2),'/',substring($utcFormat,6,2),'/',substring($utcFormat,1,4))"/>
	</xsl:template>
	
	<xsl:template name="transNominalCode">
		<xsl:param name="glendolaNominalCode"/>
	
		<xsl:choose>
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14100'">Stock - Food</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14101'">Stock - Food - PreOp.</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14110'">Stock - Coffee</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14200'">Stock - Beverage</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14201'">Stock - Beverage - PreOp.</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14240'">Stock - Minibar</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14250'">Stock - Returnables</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14300'">Stock - Merchandise</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14301'">Stock - Merchandise - PreOp.</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14350'">Stock - Provision Merchandise</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14400'">Stock - Stationery</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14450'">Stock - CHC Stationery</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14500'">Stock - Equipment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14600'">Stock - Others</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14601'">Stock - Tobacco</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14602'">Stock - Phone-Cards</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14603'">Stock - Pre-paid Cards</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14604'">Stock - Gift Vouchers</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '14605'">Stock - Live Animals</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '25810'">VAT Output (CR)</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '25820'">VAT Input (DR)</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80000'">Travel Agency Commission</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80001'">Linen &amp; Laundry</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80003'">Printing &amp; Stationery</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80004'">Rooms Guest Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80005'">Guest Supplies - Executive</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80006'">Executive Lounge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80007'">In Room Tea &amp; Coffee</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80009'">Uniforms</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80010'">Uniforms Cleaning</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80011'">Sundry Cleaning</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80012'">Cleaning Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80013'">Cleaning Curtains &amp; Blankets</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80014'">Window Cleaning</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80015'">Pest Control</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80016'">Toilet Rolls</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80017'">Royalty &amp; Licences</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80018'">TV/Radio Licence</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80019'">Free Mini Bars</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80020'">Restaurant Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80021'">Bar Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80022'">Banqueting Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80023'">Kitchen Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80024'">Operating Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80025'">Club Operating Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80026'">Club Variable Costs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80027'">Habitat Operating Supples</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80028'">Retail Operating Supplies</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80032'">CO2</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80033'">Stock Losses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80034'">Stocktake Charges</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80035'">China/Glass &amp;Cutlery</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80036'">Menucards</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80037'">Candles</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80038'">Tableclothes</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80039'">Dishwasher Detergents</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80040'">Decorations</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80047'">Cost of Data Equipment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80048'">Equipment Rental</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80050'">Sales - Telephone</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80051'">Sales - Payphones/Fax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80052'">Sales-Internet Tel/transmitter</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80054'">Phone Equipment Rental</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80055'">Phone Equipment Maint</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80056'">Phone Call Charges</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80057'">Mobile Phones</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80058'">Internet Charges</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80059'">Employee Phones at Home</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80060'">Postage</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80063'">BS Correction</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80064'">General Insurance</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80065'">Photocopier</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80066'">Bad Debt Charge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80067'">Returned Cheques</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80068'">Cashiers Over&amp; Shorts</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80069'">Bank Charges</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80070'">Credit Card Commission</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80071'">Debt Collection</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80072'">Donations</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80073'">Guest Claims</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80074'">VAT Unclaimed</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80075'">Cash Security Transport</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80076'">Exchange Gains/Losses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80077'">Legal &amp; Professional Fees</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80078'">Audit Fee</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80079'">Membership &amp; Subscriptions</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80080'">Health &amp; Safety</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80081'">Ex Gratia Payments</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80082'">Orit Interest Charge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80083'">CreditCard Customer Commision</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80084'">Creditors Write Back Acc</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80085'">VAT RECLAIMED</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80086'">Inter-Company Write Off</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80100'">Managers Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80101'">Payroll outsourcing</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80105'">Staff Incentives/Bonuses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80106'">Staff Taxis</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80109'">Recruitment Cost &amp; Advertising</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80110'">Petrol Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80111'">Car Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80112'">Travel Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80113'">Entertaining Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80150'">Acquisition Cost</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80151'">Fee Woonstede</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80188'">Space Rental</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80189'">Contingency</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80190'">Sundry / Misc Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80191'">Container &amp; Deposit W/Offs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80192'">Relocation Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80193'">Agency Deposit Fee Property</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80199'">Fees Contingency</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80201'">Electricity</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80202'">Gas</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80203'">Water</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80204'">Sewerage</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80208'">Refuse / Waste Removal</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80209'">Energy Recharge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80210'">Building</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80211'">Tools</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80212'">Kitchen Equipment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80213'">Lifts</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80214'">Plumbing &amp; Heating</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80215'">Furnishings</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80216'">Paintwork / Decoration</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80217'">Elect Materials / Equipment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80218'">Furniture &amp; Fittings</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80219'">Computer Hardware</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80220'">Refridgeration</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80221'">Radio/TV/Video etc..</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80222'">Tech. Installation</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80223'">Small Articles</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80225'">Pagers &amp; Phones</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80226'">Neon Lights</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80229'">Light Bulbs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80230'">Grounds &amp; Landscaping</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80231'">Security &amp; Prevention</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80232'">Swim Pool Water Treatment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80233'">Fitness / Aerobics</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80234'">Tennis / Squash</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80235'">Sauna / Pool</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80236'">Bowling</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80237'">Maintenance Contracts</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80238'">Refund of Appartment Materials</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80239'">Insurance Repair/Claims</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80240'">Strand paviljoen Noordzee</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80300'">Freehold Property Costs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '80350'">Development Expenditure</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89070'">Records &amp; Tapes</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89071'">Music &amp; Entertainment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89080'">Advertising</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89081'">Mailing</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89082'">Direct Marketing etc..</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89083'">Group Marketing</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89084'">Brochures</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89085'">Sales Commission &amp; Trips</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89086'">Trade Fair Expenses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89087'">Promotion Lit/Signs/Events</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89088'">Gifts etc..</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89089'">Photography</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89090'">Directory Space - Annual</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89091'">Representation Fees</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89092'">Sponsorship/Marketing CoS</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89093'">Printing &amp; Design</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89094'">Menu Discounts &amp; Promos</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89095'">Party Bags / Balloons etc</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89510'">Commission on Revenue</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89520'">Commission on Corporate</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '89550'">Promotors Fee</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91000'">Management Fees Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91001'">Incentive Fees Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91002'">Franchise Fees Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91003'">Royalty to INC. USA</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91004'">Glendola Cross Charge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '91005'">GLP Mgmt Fees</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92100'">Property Rental Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92110'">Property Rent Payable CUK>GLH</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92150'">Landlord's Service Charge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92160'">Inducement Premium</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92170'">Lease Early Termination Costs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92200'">Property Rates / Ground Tax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92210'">Local/Sewer Tax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92300'">Insurance Building</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92310'">Insurance Claims Received</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '92999'">Amortisation of Goodwill</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93000'">Dep'n - Building</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93001'">Dep'n - F.F. &amp; Equipment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93002'">Dep'n - Impairment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93003'">Dep'n - Goodwill</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93011'">Impairment of Fixed Assets</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93012'">Provn Invest HM Ltd</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93013'">Provn Invest Swifts</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '93500'">Prov Re: Investments</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '94000'">Replacement Reserve (1550)</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '94100'">Deferred Repairs</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '94999'">Interest on Tax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95000'">Bank/Loan Interest Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95001'">HP Interest Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95002'">Cash Discount</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95003'">Lease - Finance</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95004'">Other Interest Payable - SHold</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95005'">Commitment Fees Payable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95006'">Financial Instruments - Hedge</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95500'">Bank/Loan Interest Receivable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95501'">Inland Rev Interest Receivable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '95502'">Other Interest Receivable</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '96000'">Pre-Opening Recovery</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97000'">Extraordinary Profits/Losses</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97001'">Asset Disposal Profit</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97002'">Loss on Sale of Subsiduary</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97003'">Shares Disposal Profit</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97050'">Dividends</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97800'">Dividends Pay/Rec</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97810'">Provision Funding</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97811'">Provision Investment</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97812'">Provision Onerous Contracts</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97820'">Termination of SWAP</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97997'">Corp Tax - Under Provision</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97998'">Deferred Tax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '97999'">Corporation Tax</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '98000'">Managers Commission/Bonus</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '98100'">Staff Bonus</xsl:when> 
			<xsl:when test="substring-before($glendolaNominalCode,'+') = '99999'">P&amp;L Cleardown Account</xsl:when> 
		</xsl:choose>
     	</xsl:template>
	
</xsl:stylesheet>
