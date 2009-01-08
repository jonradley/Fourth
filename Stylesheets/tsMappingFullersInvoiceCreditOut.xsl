<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a csv format for Fullers.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 07/01/2008	| A Sheppard	| 1675.Created module.
 ******************************************************************************************
 22/12/2008	| Rave Tech		| 2653. Get Fullers STX Supplier Code.
 ******************************************************************************************
 08/01/2009	| Lee Boyton	| 2674. Fullers requested change to the GL code derivation.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>
	
	<!--Define keys to be used for finding distinct line information. -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	
	<xsl:template match="/Invoice | /CreditNote">
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		
		<!--Batch Header-->
		<xsl:text>TF</xsl:text>
		<xsl:value-of select="script:msGetTodaysDate()"/>
		<xsl:value-of select="script:gsFormatFixedWidth(//CostCentreCode, 4)"/>
		<xsl:value-of select="script:gsFormatFixedWidth('', 88)"/>
		
		<!--Document Header-->
		<xsl:value-of select="$NewLine"/>
		<xsl:text>TD</xsl:text>
		<xsl:choose>
			<xsl:when test="InvoiceHeader"><xsl:text>I</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>N</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="script:gsFormatFixedWidth(//HeaderExtraData/STXSupplierCode, 10)"/>
		<xsl:choose>
			<xsl:when test="InvoiceHeader">
				<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//InvoiceDate"/></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//CreditNoteDate"/></xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="script:gsFormatFixedWidth(//SettlementTotalExclVAT, 15)"/>
		<xsl:value-of select="script:gsFormatFixedWidth(//VATAmount, 15)"/>
		<xsl:choose>
			<xsl:when test="InvoiceHeader">
				<xsl:value-of select="script:gsFormatFixedWidth(//InvoiceReference, 25)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="script:gsFormatFixedWidth(//CreditNoteReference, 25)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="script:gsFormatFixedWidth(//SettlementTotalInclVAT, 15)"/>
		<xsl:text>Y</xsl:text>
		<xsl:value-of select="script:gsFormatFixedWidth('', 10)"/>
		
		<!--Tax Analysis-->
		<xsl:for-each select="//VATSubTotal">
			<xsl:value-of select="$NewLine"/>
			<xsl:text>TV</xsl:text>
			<xsl:choose>
				<xsl:when test="@VATCode = 'S'"><xsl:text>S</xsl:text></xsl:when>
				<xsl:when test="@VATCode = 'Z'"><xsl:text>Z</xsl:text></xsl:when>
				<xsl:when test="@VATCode = 'E'"><xsl:text>X</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>O</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:gsFormatFixedWidth(DocumentTotalExclVATAtRate, 15)"/>
			<xsl:value-of select="script:gsFormatFixedWidth(VATAmountAtRate, 15)"/>
			<xsl:value-of select="script:gsFormatFixedWidth('', 67)"/>
		</xsl:for-each>
		
		<!--Nominal Analysis-->		
		<!-- use the keys for grouping Lines by Account Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			
			<!--Add the info from all lines with this account code-->
			<xsl:value-of select="$NewLine"/>
			<xsl:text>TN</xsl:text>
			<xsl:value-of select="script:gsFormatFixedWidth($AccountCode,2)"/>
			<xsl:value-of select="script:gsFormatFixedWidth(//CostCentreCode, 4)"/>
			<xsl:value-of select="script:gsFormatFixedWidth(substring($AccountCode,3),9)"/>
			<xsl:value-of select="script:gsFormatFixedWidth(format-number(sum((//InvoiceLine | //CreditNoteLine)[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00'),15)"/>
			<xsl:value-of select="script:gsFormatFixedWidth('', 68)"/>
			
		</xsl:for-each>
	<!--Add a final new line as Fullers require a CR/LF on the last line of the document-->
		<xsl:value-of select="$NewLine"/>
		
	</xsl:template>
		
	<!-- translates a date in YYYY-MM-DD format to a date in DDMMYY format -->
	<xsl:template name="formatDate">
		<xsl:param name="xmlDate"/>
		<xsl:value-of select="substring($xmlDate,9,2)"/>
		<xsl:value-of select="substring($xmlDate,6,2)"/>
		<xsl:value-of select="substring($xmlDate,3,2)"/>
	</xsl:template>

	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msGetTodaysDate
		' Description 	 : Gets todays date, formatted to ddmmyy
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 07/01/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetTodaysDate()
		{
		var dtDate = new Date();
			
			var sDate = dtDate.getDate();
			if(sDate<10)
			{
				sDate = '0' + sDate;
			}
			
			var sMonth = dtDate.getMonth() + 1;
			if(sMonth<10)
			{
				sMonth = '0' + sMonth;
			}
						
			var sYear  = dtDate.getYear() + '';
			sYear = sYear.substr(2,2);
		
			return sDate + sMonth + sYear;
		}
	]]></msxsl:script>	
</xsl:stylesheet>