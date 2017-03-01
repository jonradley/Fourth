<?xml version="1.0" encoding="UTF-8"?>
<!--====================================================================================
 Date      		| Name 						| Description of modification
=======================================================================================
 30/05/2012	| KOshaughnessy		| Created module
=======================================================================================
 04/12/2013	| M Dimant				| 7519: Small changes to correct how values are formatted - CLD: 2dp, CST and CTR: 4 dp
=======================================================================================
 03/06/2014	| M Dimant				| 7843: Bug Fix - Added loop to catch all credit lines.
 =======================================================================================
 02/11/2016	| M Dimant				| 11378: Pass across brand name in the CDT segment from BuyersName field
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
					xmlns:fo="http://www.w3.org/1999/XSL/Format"
					xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
					xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
					xmlns:msxsl="urn:schemas-microsoft-com:xslt">

<xsl:output method="text"/>

	<xsl:variable name="sRecordSep">
		<xsl:text>'&#13;&#10;</xsl:text>
	</xsl:variable>
	
	<xsl:template match="/CreditNote">
	
	<xsl:text>STX=</xsl:text>
		<xsl:text>ANA:1+</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/SendersName"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="CreditNoteHeader/Buyer/BuyersName"/>
		<xsl:text>+</xsl:text>
		<!--xsl:value-of select="$msFileGenerationDate"/-->
		<xsl:text>:</xsl:text>
		<xsl:value-of select="vb:msFileGenerationTime()"/>
		<xsl:text>+</xsl:text>
		<xsl:variable name="FGN">
			<xsl:choose>
				<xsl:when test="CreditNoteHeader/BatchInformation/FileGenerationNo != ''">
					<xsl:value-of select="CreditNoteHeader/BatchInformation/FileGenerationNo"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CreditNoteHeader/BatchInformation/FileGenerationNo"/>				
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>CREHDR</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>MHD=1+CREHDR:9</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>TYP=0740</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>SDT=</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,17)"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Supplier/SuppliersAddress/PostCode,1,8)"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>CDT=</xsl:text>
		<xsl:value-of select="CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsName,1,40)"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="substring(CreditNoteHeader/Buyer/BuyersName,1,40)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsAddress/AddressLine1,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsAddress/AddressLine2,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsAddress/AddressLine3,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsAddress/AddressLine4,1,35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsAddress/PostCode,1,8)"/>
	<xsl:value-of select="$sRecordSep"/>		
	
	<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+1+</xsl:text>
		<!--xsl:value-of select="$msFileGenerationDate"/-->
	<xsl:value-of select="$sRecordSep"/>		
	
	<xsl:text>MTR=6</xsl:text>
	<xsl:value-of select="$sRecordSep"/>		
	
	<xsl:text>MHD=</xsl:text>
		<xsl:text>2+CREDIT:9</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:for-each select="/CreditNote">
	
	<xsl:text>CLO=</xsl:text>
		<xsl:if test="CreditNoteHeader/ShipTo/ShipToLocationID/GLN != '5555555555555' ">
			<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/GLN"/>
		</xsl:if>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToName"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1"/>
		<xsl:text>::::</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>CRF=</xsl:text>
		<xsl:if test="CreditNoteHeader/CreditNoteReferences/CreditNoteReference != ''">
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		</xsl:if>
		<xsl:text>+</xsl:text>	
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
		</xsl:call-template>		
		<xsl:text>+++++:::</xsl:text>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:text>OIR=1+</xsl:text>
		<xsl:if test="CreditNoteHeader/InvoiceReferences/InvoiceReference != '' ">
			<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
		</xsl:if>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/InvoiceReferences/InvoiceDate"/>
		</xsl:call-template>
		<xsl:text>+</xsl:text>
		<xsl:call-template name="msFormateDate">
			<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/InvoiceReferences/TaxPointDate"/>
		</xsl:call-template>
	<xsl:value-of select="$sRecordSep"/>	
	
	<xsl:for-each select="CreditNoteDetail/CreditNoteLine">	
		<xsl:text>CLD=1+</xsl:text>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:text>+++1+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditedQuantity,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(LineValueExclVAT,'#.0000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="VATCode"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(VATRate,'#.0000'),'.','')"/>
			<xsl:text>+::+++</xsl:text>
			<xsl:value-of select="ProductDescription"/>
		<xsl:value-of select="$sRecordSep"/>	
	</xsl:for-each>
		
		<xsl:for-each select="CreditNoteTrailer/VATSubTotals">
			<xsl:text>CST=1+</xsl:text>
				<!--VAT Rate Category Code-->
				<xsl:value-of select="VATSubTotal/@VATCode"/>
				<xsl:text>+</xsl:text>
				<!--VAT Rate Percentage-->
				<xsl:value-of select="VATSubTotal/@VATRate"/>
				<xsl:text>+</xsl:text>
				<!--Number of Item Lines-->
				<xsl:value-of select="VATSubTotal/NumberOfLinesAtRate"/>
				<xsl:text>+</xsl:text>
				<!--Line Sub-Total Amount (before VAT)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DiscountedLinesTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+++</xsl:text>
				<!--Extended Sub-Total Amount (before Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DocumentTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Sub-Total Settlement Discount Amount-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementDiscountAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Extended Sub-Total Amount (after Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--VAT Amount Payable-->
				<xsl:value-of select="translate(format-number(VATSubTotal/VATAmountAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Payable Sub-Total Amount (before Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/DocumentTotalInclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<!--Payable Sub-Total Amount (after Settlement Discount)-->
				<xsl:value-of select="translate(format-number(VATSubTotal/SettlementTotalInclVATAtRate,'#.00'),'.','')"/>
			<xsl:value-of select="$sRecordSep"/>	
		</xsl:for-each>
		
		<xsl:text>CTR=1+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DiscountedLinesTotalExclVAT,'#.00'),'.','')"/>	
			<xsl:text>+++</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
		<xsl:value-of select="$sRecordSep"/>	
		
		<xsl:text>MTR=8</xsl:text>
		<xsl:value-of select="$sRecordSep"/>	
		
		<xsl:text>MHD=</xsl:text>
			<xsl:value-of select="2 + count(CreditNoteTrailer/VATSubTotals/VATSubTotal)"/>
			<xsl:text>+CREDIT:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>	
	
	</xsl:for-each>
	
	</xsl:template>
	
	<!--=======================================================================================
  Routine        : msFormateDate()
  Description    : Converts a date in the format YYYY-MM-DD to the format YYMMDD 
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : K Oshaughnessy
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormateDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''), 3)"/>
	
	</xsl:template>

<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[

'==========================================================================================
' Routine        : msFileGenerationTime()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : K Oshaughnessy
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationTime()

Dim sNow

	sNow = CStr(Time)

	msFileGenerationTime = Replace(sNow,":","")
			
End Function

]]></msxsl:script>

</xsl:stylesheet>