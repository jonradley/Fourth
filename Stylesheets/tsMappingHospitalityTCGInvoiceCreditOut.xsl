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
 21/03/2007	| R Cambridge			| 864 infer missing more expense codes 
==========================================================================================
 29/03/2007	| R Cambridge			| 864 re-instate minus in credit 
==========================================================================================
 16/06/2008	| A Sheppard			| 2283. Minor changes to spec
==========================================================================================
 22/08/2008	| Lee Boyton			| 2436. Support for "0" (Outside the scopt of VAT) VAT code.
==========================================================================================
 01/09/2008	| Lee Boyton			| 2456. Change to specification to include Company code.
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text" encoding="utf-8"/>

	<xsl:template 	match="/Invoice | /CreditNote">
	
		<xsl:text>H</xsl:text>		
		<xsl:text>|</xsl:text>

		<xsl:value-of select="(/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode | /CreditNote/CreditNoteHeader/HeaderExtraData/CompanyCode)"/>
		<xsl:text>|</xsl:text>
		
		<xsl:choose>
			<xsl:when test="/Invoice">XPIN</xsl:when>
			<xsl:otherwise>XPCR</xsl:otherwise>
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
				<xsl:when test="@VATCode='L'">5</xsl:when>
				<xsl:otherwise><xsl:value-of select="@VATCode"/></xsl:otherwise>
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
		
		
		
		<xsl:variable name="objLines">
		
			<xsl:for-each select="(/Invoice/InvoiceDetail/InvoiceLine | /CreditNote/CreditNoteDetail/CreditNoteLine)">
			
				<LineCopy>
				
					<!-- The expense code for this product, guessed if need be -->
					<xsl:variable name="sAccountCode">
						<xsl:choose>
							<!-- The value looked up from the catalogue -->
							<xsl:when test="LineExtraData/AccountCode != ''"><xsl:value-of select="LineExtraData/AccountCode"/></xsl:when>
							<xsl:otherwise>							
								<!-- Guess based on supplier code -->
								<xsl:choose>
									<xsl:when test="string(LineExtraData/AccountCode)='' and substring(/*/TradeSimpleHeader/RecipientsCodeForSender,1,3) = 'SCO'">2000-</xsl:when>
									<xsl:when test="string(LineExtraData/AccountCode)='' and substring(/*/TradeSimpleHeader/RecipientsCodeForSender,1,3) = 'BRA'">2300-</xsl:when>
									<xsl:when test="string(LineExtraData/AccountCode)='' and substring(/*/TradeSimpleHeader/RecipientsCodeForSender,1,3) = 'BUN'">3300-</xsl:when>
								</xsl:choose>							
							</xsl:otherwise>
						</xsl:choose>					
					</xsl:variable>
					
					<!-- Record the expense code -->
					<xsl:attribute name="AccountCode">
						<xsl:value-of select="$sAccountCode"/>
					</xsl:attribute>
					
					<!-- Lines will be agregated based on VAT code and expense code -->
					<xsl:attribute name="AccountGroup">
						<xsl:value-of select="./VATCode"/>
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$sAccountCode"/>
					</xsl:attribute>
									
					<xsl:copy-of select="."/>
				
				</LineCopy>							
			
			</xsl:for-each>
			
							
		</xsl:variable>
		
		
		<xsl:variable name="objDoc" select="/*"/>
		
		<xsl:for-each select="msxsl:node-set($objLines)/*">
			<xsl:sort select="@AccountGroup"/>
			
			<xsl:variable name="sCurrentKey" select="@AccountGroup"/>
			
			
			<!-- Dothis once for each combination of VAT and expense code -->
			<xsl:if test="not(preceding-sibling::*[@AccountGroup = $sCurrentKey])">
			
				<xsl:text>N</xsl:text>		
				<xsl:text>|</xsl:text>
				
				<!-- ???? -->
				<xsl:text>|</xsl:text>
				
				<xsl:value-of select="$objDoc/TradeSimpleHeader/RecipientsBranchReference"/>	
				<xsl:text>|</xsl:text>
				
				<xsl:value-of select="@AccountCode"/>
				<xsl:text>|</xsl:text>
				
				<xsl:if test="$objDoc/CreditNoteHeader">-</xsl:if>
				<xsl:value-of select="format-number(sum(../*[@AccountGroup=$sCurrentKey]/*/LineValueExclVAT), '0.00')"/>
				<xsl:text>|</xsl:text>
				
				<xsl:choose>
					<xsl:when test="*/VATCode='L'">5</xsl:when>
					<xsl:otherwise><xsl:value-of select="*/VATCode"/></xsl:otherwise>
				</xsl:choose>
		
				<xsl:text>&#13;&#10;</xsl:text>
		
			</xsl:if>
		
		</xsl:for-each>	

		
	
	</xsl:template>

</xsl:stylesheet>
