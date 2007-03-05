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
 07/12/2006	| R Cambridge			| 602 Use tax point date instead of invoice date 
==========================================================================================
 02/01/2007	| R Cambridge			| 662 Roll back 602 (Scottish and Newcastle have adjusted their mapping)
==========================================================================================
 05/03/2007	| R Cambridge			| 864 TCG invoice/credit mapper to infer missing expense codes 
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="utf-8"/>

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
		
		<xsl:choose>
			<xsl:when test="contains(/*/TradeSimpleHeader/RecipientsCodeForSender,'/')">
				<xsl:value-of select="substring-before(/*/TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/*/TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>|</xsl:text>
		
		<xsl:value-of select="(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference)"/>
		<xsl:text>|</xsl:text>
		
		<!--xsl:variable name="sPOReference" select="(/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference | /CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference)[1]"/-->

		<xsl:variable name="sPOReference">
			<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference | /CreditNote/CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference)[1]">
				<xsl:choose>
					<xsl:when test="contains(.,'-')"><xsl:value-of select="substring-after(.,'-')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		
		
		<xsl:text>PO</xsl:text>
		<xsl:value-of select="substring(concat('00000000',$sPOReference), string-length($sPOReference)+1)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="(/Invoice/TradeSimpleHeader/RecipientsBranchReference | /CreditNote/TradeSimpleHeader/RecipientsBranchReference)"/>
		<xsl:text>|</xsl:text>
		
		<!-- ???? -->
		<xsl:text>|</xsl:text>
		
		<xsl:if test="/CreditNote">-</xsl:if>
		<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalInclVAT | /CreditNote/CreditNoteTrailer/DocumentTotalInclVAT, '0.00')"/>
		<xsl:text>|</xsl:text>
		
		<xsl:if test="/CreditNote">-</xsl:if>
		<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/VATAmount| /CreditNote/CreditNoteTrailer/VATAmount, '0.00')"/>
		<xsl:text>|</xsl:text>
		
		<xsl:for-each select="(/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal | /CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal)[position() &lt;=5]">
		
			<xsl:choose>
				<xsl:when test="@VATCode='S'">S</xsl:when>
				<xsl:when test="@VATCode='E'">E</xsl:when>
				<xsl:when test="@VATCode='Z'">Z</xsl:when>
				<xsl:when test="@VATCode='L'">5</xsl:when>
				<xsl:otherwise>?</xsl:otherwise>
			</xsl:choose>
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
		

		<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine | /CreditNote/CreditNoteDetail/CreditNoteLine)">
			
			<!-- pre 864 logic (ie the correct way) -->
			<!--====================================================================================================================================-->
			
			<!-- xsl:sort select="concat(VATCode,'_',LineExtraData/AccountCode)"/>
		
			<xsl:variable name="sCurrentKey" select="concat(VATCode,'_',LineExtraData/AccountCode)"/>
			
			<xsl:if test="not(preceding-sibling::*[concat(VATCode,'_',LineExtraData/AccountCode) = $sCurrentKey])">
			
				<xsl:text>N</xsl:text>		
				<xsl:text>|</xsl:text>
				
				<! ???? >
				<xsl:text>|</xsl:text>
				
				<xsl:value-of select="(/Invoice/TradeSimpleHeader/RecipientsBranchReference | /CreditNote/TradeSimpleHeader/RecipientsBranchReference)"/>	
				<xsl:text>|</xsl:text>
				
				<xsl:value-of select="LineExtraData/AccountCode"/>
				<xsl:text>|</xsl:text>
				
				<xsl:if test="/CreditNote">-</xsl:if>
				<xsl:value-of select="format-number(sum(../*[concat(VATCode,'_',LineExtraData/AccountCode)=$sCurrentKey]/LineValueExclVAT), '0.00')"/>
				<xsl:text>|</xsl:text>
				
				<xsl:choose>
					<xsl:when test="VATCode='S'">S</xsl:when>
					<xsl:when test="VATCode='E'">E</xsl:when>
					<xsl:when test="VATCode='Z'">Z</xsl:when>
					<xsl:when test="VATCode='L'">5</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
		
				<xsl:text>&#13;&#10;</xsl:text>
		
			</xsl:if-->
			
			<!--====================================================================================================================================-->
			
			<xsl:sort select="concat(VATCode,'_')"/>
			
			<xsl:variable name="sCurrentKey" select="concat(VATCode,'_')"/>
			
			<xsl:if test="not(preceding-sibling::*[concat(VATCode,'_') = $sCurrentKey])">
			
				<xsl:text>N</xsl:text>		
				<xsl:text>|</xsl:text>
				
				<!-- ???? -->
				<xsl:text>|</xsl:text>
				
				<xsl:value-of select="(/Invoice/TradeSimpleHeader/RecipientsBranchReference | /CreditNote/TradeSimpleHeader/RecipientsBranchReference)"/>	
				<xsl:text>|</xsl:text>
				
				<!--xsl:value-of select="LineExtraData/AccountCode"/-->
				<xsl:choose>
					<xsl:when test="string(LineExtraData/AccountCode)='' and substring(/*/TradeSimpleHeader/RecipientsCodeForSender,1,3) = 'SCO'">2000-</xsl:when>
					<xsl:when test="string(LineExtraData/AccountCode)='' and substring(/*/TradeSimpleHeader/RecipientsCodeForSender,1,3) = 'BRA'">2300-</xsl:when>
					<xsl:otherwise><xsl:value-of select="LineExtraData/AccountCode"/></xsl:otherwise>
				</xsl:choose>
				<xsl:text>|</xsl:text>
				
				<xsl:if test="/CreditNote">-</xsl:if>
				<xsl:value-of select="format-number(sum(../*[concat(VATCode,'_')=$sCurrentKey]/LineValueExclVAT), '0.00')"/>
				<xsl:text>|</xsl:text>
				
				<xsl:choose>
					<xsl:when test="VATCode='S'">S</xsl:when>
					<xsl:when test="VATCode='E'">E</xsl:when>
					<xsl:when test="VATCode='Z'">Z</xsl:when>
					<xsl:when test="VATCode='L'">5</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
		
				<xsl:text>&#13;&#10;</xsl:text>
		
			</xsl:if>

		</xsl:for-each>
	
	</xsl:template>

</xsl:stylesheet>
