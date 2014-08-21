<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 TCG invoice/credit mapper to Alphameric

 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 16/10/2006	| R Cambridge			| Created module
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

	<xsl:template 	match="/Invoice | /CreditNote">
	
		<xsl:text>H</xsl:text>		
		<xsl:text>|</xsl:text>
		
		<xsl:text>OAREG</xsl:text>
		<xsl:text>|</xsl:text>
		
		<xsl:choose>
			<xsl:when test="/Invoice">XPRIN</xsl:when>
			<xsl:otherwise>XPRCR</xsl:otherwise>
		</xsl:choose>		
		<xsl:text>|</xsl:text>
		
		<xsl:for-each select="(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate)[1]">
			<xsl:value-of select="concat(substring(.,9,2),'/',substring(.,6,2),'/',substring(.,1,4))"/>
		</xsl:for-each>
		<xsl:text>|</xsl:text>
		
		<xsl:value-of select="/*/TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>|</xsl:text>
		
		<xsl:value-of select="(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>
		<xsl:text>|</xsl:text>
		
		<xsl:value-of select="(/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference | /CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference)[1]"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsBranchReference"/>
		<xsl:text>|</xsl:text>
		
		<!-- ???? -->
		<xsl:text>|</xsl:text>
		
		<xsl:if test="/CreditNote">-</xsl:if>
		<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalInclVAT | /CreditNote/CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/>
		<xsl:text>|</xsl:text>
		
		<xsl:if test="/CreditNote">-</xsl:if>
		<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/VATAmount| /CreditNote/CreditNoteTrailer/VATAmount, '0.00')"/>
		<xsl:text>|</xsl:text>
		
		<xsl:for-each select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal | /CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal">
		
			<xsl:value-of select="@VATCode"/>
			<xsl:text>|</xsl:text>
			
			<xsl:if test="/CreditNote">-</xsl:if>
			<xsl:value-of select="format-number(DocumentTotalExclVATAtRate, '0.00')"/>
			<xsl:text>|</xsl:text>
			
			<xsl:if test="/CreditNote">-</xsl:if>
			<xsl:value-of select="format-number(VATAmountAtRate, '0.00')"/>
			<xsl:if test="position() != last()">
				<xsl:text>|</xsl:text>
			</xsl:if>
		
		</xsl:for-each>
		
		<xsl:text>&#13;&#10;</xsl:text>
		
		
		<xsl:for-each select="">
		
			<xsl:text>N</xsl:text>		
			<xsl:text>|</xsl:text>
			
			<!-- ???? -->
			<xsl:text>|</xsl:text>
			
			<xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsBranchReference"/>	
			<xsl:text>|</xsl:text>
			
			<xsl:value-of select="LineExtraData/AccountCode"/>
			<xsl:text>|</xsl:text>
			
			<xsl:if test="/CreditNote">-</xsl:if>
			<xsl:value-of select="format-number(LineValueExclVAT, '0.00')"/>
			<xsl:text>|</xsl:text>
			
			<xsl:value-of select="VATCode"/>
			<xsl:text>|</xsl:text>
		
		</xsl:for-each>


	
	</xsl:template>

</xsl:stylesheet>
