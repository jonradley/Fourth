<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Caring Homes Invoice and Credit Batch Map
**********************************************************************
Name				| Date			| Change
*********************************************************************
Andrew Barber	| 22/01/2014	| Created.
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>

	<!--xsl:template match="/BatchRoot"-->
	<xsl:template match="/">
	
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
	
		<xsl:for-each select="Invoice">
		
			<!-- HEADER -->
			
			<!-- Record Type -->
			<xsl:text>H</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Supplier Code -->
			<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
			<xsl:text>,</xsl:text>
			
			<!-- Invoice Number -->
			<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>			
			
			<!-- Invoice Date -->
			<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:text>,</xsl:text>
			
			<!-- Total Invoice Value -->
			<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			<xsl:value-of select="$NewLine"/>			
			
			<!-- DETAIL -->
			<xsl:for-each select="InvoiceDetail/InvoiceLine">
			
				<!-- Record Type -->
				<xsl:text>D</xsl:text>
				<xsl:text>,</xsl:text>
			
				<!-- Company Number -->
				<xsl:value-of select="substring-before(//TradeSimpleHeader/RecipientsBranchReference,'-')"/>	
				<xsl:text>,</xsl:text>
				
				<!-- Cost Centre Number -->
				<xsl:value-of select="substring-after(//TradeSimpleHeader/RecipientsBranchReference,'-')"/>	
				<xsl:text>,</xsl:text>
				
				<!-- Expense Code Number -->
				<xsl:value-of select="LineExtraData/AccountCode"/>
				<xsl:text>,</xsl:text>
				
				<!-- Description of Goods -->
				<xsl:text>"</xsl:text>
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="ProductDescription"/>
				 </xsl:call-template>
				<xsl:text>"</xsl:text>
				<xsl:text>,</xsl:text>
				
				<!-- Quantity -->
				<xsl:value-of select="format-number(InvoicedQuantity,'0.000')"/>
				<xsl:text>,</xsl:text>
				
				<!-- Date of Supply -->
				<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
				<xsl:text>,</xsl:text>
				
				<!-- Value of Invoice Line -->
				<xsl:value-of select="format-number(LineValueExclVAT + (LineValueExclVAT * (VATRate div 100)),'0.00')"/>
				<xsl:value-of select="$NewLine"/>
				
			</xsl:for-each>
		
		</xsl:for-each>
			
		<xsl:for-each select="CreditNote">

			<!-- HEADER -->
			
			<!-- Record Type -->
			<xsl:text>H</xsl:text>
			<xsl:text>,</xsl:text>
			
			<!-- Supplier Code -->
			<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
			<xsl:text>,</xsl:text>
			
			<!-- Invoice Number -->
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			
			<!-- Invoice Date -->
			<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>
			
			<!-- Total Invoice Value -->
			<xsl:value-of select="format-number(-1 * CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
			<xsl:value-of select="$NewLine"/>			
			
			<!-- DETAIL -->
			<xsl:for-each select="CreditNoteDetail/CreditNoteLine">
			
				<!-- Record Type -->
				<xsl:text>D</xsl:text>
				<xsl:text>,</xsl:text>
			
				<!-- Company Number -->
				<xsl:value-of select="substring-before(//TradeSimpleHeader/RecipientsBranchReference,'-')"/>	
				<xsl:text>,</xsl:text>
				
				<!-- Cost Centre Number -->
				<xsl:value-of select="substring-after(//TradeSimpleHeader/RecipientsBranchReference,'-')"/>	
				<xsl:text>,</xsl:text>
				
				<!-- Expense Code Number -->
				<xsl:value-of select="LineExtraData/AccountCode"/>
				<xsl:text>,</xsl:text>
				
				<!-- Description of Goods -->
				<xsl:text>"</xsl:text>
				<xsl:call-template name="msQuotes">
					<xsl:with-param name="vs" select="ProductDescription"/>
				 </xsl:call-template>
				<xsl:value-of select="ProductDescription"/>
				<xsl:text>"</xsl:text>
				<xsl:text>,</xsl:text>
				
				<!-- Quantity -->
				<xsl:value-of select="format-number(CreditedQuantity,'0.000')"/>
				<xsl:text>,</xsl:text>
				
				<!-- Date of Supply -->
				<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
				<xsl:text>,</xsl:text>
				
				<!-- Value of Invoice Line -->
				<xsl:value-of select="format-number(-1 * LineValueExclVAT + (LineValueExclVAT * (VATRate div 100)),'0.00')"/>
				<xsl:value-of select="$NewLine"/>
				
			</xsl:for-each>
				
		</xsl:for-each>
	
	</xsl:template>
	
	<!--=======================================================================================
	  Routine		: msQuotes
	  Description	: Recursively searches for " and replaces it with ""
	  Inputs			: A string
	  Outputs		: 
	  Returns		: A string
	  Author		: Robert Cambridge
	  Version		: 1.0
	  Alterations	: (none)
	 =======================================================================================-->
	 <xsl:template name="msQuotes">
		<xsl:param name="vs"/>
	
		<xsl:choose>
	
		  <xsl:when test="$vs=''"/>
		  <!-- base case-->
	
		  <xsl:when test="substring($vs,1,1)='&quot;'">
			<!-- " found -->
			<xsl:value-of select="substring($vs,1,1)"/>
			<xsl:value-of select="'&quot;'"/>
			<xsl:call-template name="msQuotes">
			  <xsl:with-param name="vs" select="substring($vs,2)"/>
			</xsl:call-template>
		  </xsl:when>
	
		  <xsl:otherwise>
			<!-- other character -->
			<xsl:value-of select="substring($vs,1,1)"/>
			<xsl:call-template name="msQuotes">
			  <xsl:with-param name="vs" select="substring($vs,2)"/>
			</xsl:call-template>
		  </xsl:otherwise>
		</xsl:choose>
	
	 </xsl:template>

</xsl:stylesheet>
