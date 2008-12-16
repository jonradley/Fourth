<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a SAGE csv format for MDH.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 12/03/2008	| A Sheppard	| Created Module
******************************************************************************************
 03/12/2008	| Lee Boyton	| 2057. Do not output final VAT detail line if total is zero.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
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

		<!-- Header Line-->
		<xsl:text>H</xsl:text>
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		<xsl:value-of select="//TradeSimpleHeader/RecipientsCodeForSender"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference | /CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="/CreditNote">
				<xsl:value-of select="script:msFormatDate(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="script:msFormatDate(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate)"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		<xsl:if test="/CreditNote">
			<xsl:text>-</xsl:text>
		</xsl:if>
		<xsl:value-of select="//SettlementTotalInclVAT"/>
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		<xsl:value-of select="script:msGetCurrentDate()"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(//PurchaseOrderReference[1],0,11)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(//DeliveryNoteReference[1],0,11)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/InvoiceReferences/InvoiceReference,0,11)"/>
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		
		<xsl:text>,</xsl:text>
		
		<!--VAT detail lines-->		
		<!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',VATCode))[1])]">
				<xsl:sort select="VATCode" data-type="text"/>
				<xsl:variable name="VATCode" select="VATCode"/>
				
				<!-- now output a line for the current Account Code and VAT Code combination -->
				<xsl:value-of select="$NewLine"/>
				<xsl:text>D</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="//ShipTo/ShipToLocationID/BuyersCode"/><xsl:text>-</xsl:text><xsl:value-of select="$AccountCode"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="substring(//Supplier/SuppliersName,0,21)"/>
				<xsl:text>,</xsl:text>
				<xsl:choose>
					<xsl:when test="$VATCode = 'S'">
						<xsl:text>V2</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>V0</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				<xsl:text>G</xsl:text>
				<xsl:text>,</xsl:text>
				
				<xsl:text>,</xsl:text>
				
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number(sum(//InvoiceLine[VATCode = $VATCode and LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT) + sum(//CreditNoteLine[VATCode = $VATCode and LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00')"/>
				
			</xsl:for-each>
		</xsl:for-each>
	
		<!--VAT total line (only required if non-zero)-->
		<xsl:if test="number(//VATAmount) != 0">
			<xsl:value-of select="$NewLine"/>
			<xsl:text>D</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>A-099-000-211180</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>VAT</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>V2</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>V</xsl:text>
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			
			<xsl:text>,</xsl:text>
			<xsl:value-of select="//VATAmount"/>
		</xsl:if>
	
		<xsl:value-of select="$NewLine"/>
	
	</xsl:template>
		
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 

		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in "dd/mm/yyyy" format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(2,2);
			}
			else
			{
				return '';
			}
				
		}

		/*=========================================================================================
		' Routine       	 : msGetCurrentDate
		' Description 	 : Gets the current date in the format "dd/mm/yy"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 12/07/2007
		' Alterations   	 : 
		'========================================================================================*/
		function msGetCurrentDate()
		{
			var dtDate = new Date();
			var sReturn = '';
			
			if(dtDate.getDate() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getDate() + '/';
	
			if(dtDate.getMonth() < 9)
			{
				sReturn += '0';
			}
			sReturn += (dtDate.getMonth() + 1) + '/';
			var sTemp = dtDate.getYear() + ' ';
			sReturn += sTemp.substr(2,2)

			return sReturn;
		}
	]]></msxsl:script>
</xsl:stylesheet>