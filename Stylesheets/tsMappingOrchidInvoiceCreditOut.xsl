<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a (Sun) csv format for Orchid Pubs.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2006.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name       | Description of modification
******************************************************************************************
 05/08/2006 | Lee Boyton | Created module.
******************************************************************************************
 10/08/2006 | Lee Boyton | Take the supplier Nominal Code from the recipient's code for sender.
******************************************************************************************
 25/08/2006 | Lee Boyton | 285. Company code should appear on all line types.
******************************************************************************************
 06/10/2006 | Lee Boyton | 430. Changes required in the file format produced.
******************************************************************************************
 11/12/2006 | A Sheppard | 608. ORC003 changes to format
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
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	<xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',VATCode)"/>
	
	<xsl:template match="/Invoice | /CreditNote">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
	
		<xsl:variable name="UnitCode">
			<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
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
		
		<!-- store the company code as it is referenced on multiple lines -->		
		<xsl:variable name="CompanyCode">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode">
					<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/CompanyCode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- construct the value for the description field as it is used on multiple lines -->		
		<xsl:variable name="Description">
			<xsl:value-of select="$UnitCode"/>
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
					<xsl:value-of select="substring(translate(/Invoice/InvoiceHeader/Supplier/SuppliersName,',',''),1,19)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName,',',''),1,19)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- construct the value for the journal type field as it is used on multiple lines -->
		<xsl:variable name="JournalType">
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:text>EINV</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>ECRN</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- construct the value for the Allocation indicator as it is used on multiple lines -->
		<xsl:variable name="Allocation">
			<xsl:if test="/Invoice/InvoiceTrailer/TrailerExtraData/CreditRequestTotalExclVAT">
				<xsl:text>R</xsl:text>
			</xsl:if>
		</xsl:variable>
		
		<!--Purchase Lines-->		
		<!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',VATCode))[1])]">
				<xsl:sort select="VATCode" data-type="text"/>
				<xsl:variable name="VATCode" select="VATCode"/>
				
					<!-- now output a summary line for the current Account Code and VAT Code combination -->				
					<xsl:value-of select="$CompanyCode"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="user:glGetRowNumber()"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$DocumentDate"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$AccountCode"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$DocumentReference"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$JournalType"/>
					<xsl:text>,</xsl:text>					
					<xsl:value-of select="$Description"/>
					<xsl:text>,</xsl:text>
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$UnitCode"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="LineExtraData/BuyersVATCode"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$Allocation"/>					
					<xsl:value-of select="$NewLine"/>
				
			</xsl:for-each>
		</xsl:for-each>
		
		<!--Taxes Lines-->
		<xsl:for-each select="//VATSubTotal[@VATRate != 0.00]">
			<xsl:value-of select="$CompanyCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="user:glGetRowNumber()"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="//HeaderExtraData/TaxAccount"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$JournalType"/>
			<xsl:text>,</xsl:text>					
			<xsl:value-of select="$Description"/>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(VATAmountAtRate,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * VATAmountAtRate,'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$UnitCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="VATTrailerExtraData/BuyersVATCode"/>			
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$NewLine"/>
		</xsl:for-each>
		
		<!--Supplier Line-->
		<xsl:value-of select="$CompanyCode"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="user:glGetRowNumber()"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$DocumentDate"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$DocumentReference"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$JournalType"/>
		<xsl:text>,</xsl:text>					
		<xsl:value-of select="$Description"/>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="/Invoice/InvoiceTrailer/DocumentTotalInclVAT">
				<xsl:value-of select="format-number(-1 * /Invoice/InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$UnitCode"/>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>
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