<?xml version="1.0" encoding="UTF-8"?>
<!--
*************************************************************************************************************************
 Overview

 Maps internal invoices and credits into a  csv format for JW Lees .
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
*************************************************************************************************************************
 Module History
*************************************************************************************************************************
 Date       | Name       	| Description of modification
*************************************************************************************************************************
 13/08/2008 | Shailesh Dubey| Created module.
*************************************************************************************************************************
 27/10/2008 | Lee Boyton	| 2537. Spec. change (DRAFT 3). Credit note monetary values need to be negative.
*************************************************************************************************************************
 06/12/2017 | Moty Dimant 	| 12223: Corrected how total value of Credits are calculated
*************************************************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:user="http://mycompany.com/mynamespace"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note;  the '::' literal is simply used as a convenient separator for the 2 values that make up the second key. -->	
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	<xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',LineExtraData/BuyersVATCode)"/>
	
	<xsl:template match="/Invoice | /CreditNote">
			
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>		
		
		<!--Purchase Lines-->		
		<!-- use the keys for grouping Lines by Account Code and then by Translated VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			<xsl:variable name="LineReference" select="position()"/>
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',LineExtraData/BuyersVATCode))[1])]">
				<xsl:sort select="LineExtraData/BuyersVATCode" data-type="text"/>
				<xsl:variable name="TranslatedVatCode" select="LineExtraData/BuyersVATCode"/>
				<xsl:variable name="VATCode" select="VATCode"/>				
				<xsl:variable name="VATRate" select="VATRate"/>
				
					<xsl:text>,</xsl:text>				
					<xsl:text>TransactionNumberReference</xsl:text>
					<xsl:text>,</xsl:text>				
					<xsl:value-of select="$LineReference + position() - 1"/>
					<xsl:text>,</xsl:text>
					<xsl:choose>
						<xsl:when test="//TradeSimpleHeader/RecipientsCodeForSender = 'LW0163OLD'">LW0163</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//TradeSimpleHeader/RecipientsCodeForSender"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:text>,</xsl:text>
					<xsl:choose>
					<xsl:when test="/Invoice">1</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>	
					<xsl:choose>
					<xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate">
						<xsl:value-of select="script:msFormatDate(/Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="script:msFormatDate(/CreditNote/CreditNoteHeader/InvoiceReferences/TaxPointDate)"/>
					</xsl:otherwise>
					</xsl:choose>	
					<xsl:text>,</xsl:text>
					<xsl:text>,</xsl:text>
					<xsl:choose>
					<xsl:when test="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference">
						<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
					</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT) + sum(//InvoiceLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT)  * ($VATRate div 100),'0.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="-1 * (format-number(sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT) + sum(//CreditNoteLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT) * ($VATRate div 100),'0.00'))"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:choose>
					<xsl:when test="/Invoice">
						<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT)  * ($VATRate div 100) ,'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/BuyersVATCode= $TranslatedVatCode]/LineValueExclVAT) * ($VATRate div 100),'0.00')"/>
					</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="$TranslatedVatCode"/>
					<xsl:text>,</xsl:text>
					<xsl:call-template name="for.loop"> 
					<xsl:with-param name="i">1</xsl:with-param> 
					<xsl:with-param name="count">41</xsl:with-param> 
					</xsl:call-template>					
					<xsl:value-of select="$AccountCode"/>
					<xsl:text>,</xsl:text>
					<xsl:choose>
						<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference">
							<xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsBranchReference"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsBranchReference"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>					
					<xsl:text>MH</xsl:text> 																			
					<xsl:value-of select="$NewLine"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
		
	
	<!-- 41 balnks -->
	<xsl:template name="for.loop"> 
	<xsl:param name="i" /> 
	<xsl:param name="count" /> 
	<!--begin_: Line_by_Line_Output --> 
	<xsl:if test="$i &lt;= $count"> 
	<br /> <xsl:text>,</xsl:text>
	</xsl:if> 
	
	<!--begin_: RepeatTheLoopUntilFinished--> 
	<xsl:if test="$i &lt;= $count"> 
	<xsl:call-template name="for.loop"> 
	<xsl:with-param name="i"> 
	<xsl:value-of select="$i + 1"/> 
	</xsl:with-param> 
	<xsl:with-param name="count"> 
	<xsl:value-of select="$count"/> 
	</xsl:with-param> 
	</xsl:call-template> 
	</xsl:if> 	
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in "CYYMMDD" format
		' Author       		 : shailesh, 13/08/2008.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
        return vsDate.substr(8,2) + vsDate.substr(5, 2) + vsDate.substr(2,2);
			}
			else
			{
				return '';
			}
		}
	]]></msxsl:script>
</xsl:stylesheet>
