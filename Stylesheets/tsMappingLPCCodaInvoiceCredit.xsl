<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 $Header: $
 Overview

 This XSL file is used to transform XML for a Laurel Invoice or Credit Note into 
 	a Coda Invoice or Credit XML file

 © Alternative Business Solutions Ltd., 2003.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 20/05/2003 | L Beattie      | Created module.
******************************************************************************************
 24/06/2003 | A Sheppard | Bug fix.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:user="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl user">
<xsl:output method="xml"/>
<xsl:template match="/InvoiceOrCredit">
<ABSformatEDIdocument>
	<coda-document-code>
		<xsl:choose>
			<xsl:when test="InvoiceOrCreditHeader/DocumentType='Invoice'">PIEDI</xsl:when>
			<xsl:otherwise>PCEDI</xsl:otherwise>
		</xsl:choose>	
	</coda-document-code>
	<supplier-invoice-date>
		<xsl:value-of select="InvoiceOrCreditHeader/DocumentDate"></xsl:value-of>
	</supplier-invoice-date>
	<year>
		<xsl:value-of select="substring(InvoiceOrCreditHeader/CodaFinancialPeriod,1,4)"></xsl:value-of>
	</year>
	<period>
		<xsl:value-of select="substring(InvoiceOrCreditHeader/CodaFinancialPeriod,5,2)"></xsl:value-of>	
	</period>
	<supplier-invoice-number>
		<xsl:choose>
			<xsl:when test="InvoiceOrCreditHeader/DocumentType='Invoice'">I<xsl:value-of select="InvoiceOrCreditHeader/DocumentReference"/></xsl:when>
			<xsl:otherwise>C<xsl:value-of select="InvoiceOrCreditHeader/DocumentReference"/></xsl:otherwise>
		</xsl:choose>	
	</supplier-invoice-number>
	<file-generation-and-version>
		<xsl:value-of select="InvoiceOrCreditHeader/FileGenerationNo"></xsl:value-of>.<xsl:value-of select="InvoiceOrCreditHeader/FileVersionNo"></xsl:value-of>
	</file-generation-and-version>
	<edi-sequence>
		<xsl:value-of select="InvoiceOrCreditHeader/SequenceNo"></xsl:value-of>
	</edi-sequence>
	<delivery-date>
		<xsl:value-of select="InvoiceOrCreditHeader/DeliveryDate"></xsl:value-of>
	</delivery-date>
	<batch-reference>
		<xsl:value-of select="InvoiceOrCreditHeader/CodaBatchID"></xsl:value-of>
	</batch-reference>
	<summary-line>
		<pl-control-account>
			<xsl:value-of select="InvoiceOrCreditHeader/CodaPLAccount1"/>
		</pl-control-account>
		<supplier-account>
			<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
		</supplier-account>
		<house-number>
			<xsl:value-of select="InvoiceOrCreditHeader/CodaPLAccount2"/>
		</house-number>
		<summary-line-description>
			<xsl:choose>
				<xsl:when test="InvoiceOrCreditHeader/DocumentType='Invoice'">EDI Invoice</xsl:when>
				<xsl:otherwise>EDI Credit Note</xsl:otherwise>
			</xsl:choose>	
		</summary-line-description>
		<summary-line-value>
			<xsl:value-of select="format-number(InvoiceOrCreditTrailer/TotalInclVATExclDiscount,'0.00')"></xsl:value-of>
		</summary-line-value>
		<summary-line-type>
			<xsl:choose>
				<xsl:when test="InvoiceOrCreditHeader/DocumentType='Invoice'">Credit</xsl:when>
				<xsl:otherwise>Debit</xsl:otherwise>
			</xsl:choose>			
		</summary-line-type>
		<tax-summary-value>
			<xsl:value-of select="format-number(InvoiceOrCreditTrailer/VATAmount,'0.00')"></xsl:value-of>
		</tax-summary-value>
	</summary-line>	
	<analysis-lines>
		<xsl:for-each select="InvoiceOrCreditDetail/InvoiceOrCreditLine">
			<xsl:sort select="CodaLedgerCode" data-type="text"/>
			<xsl:sort select="CodaVATCode" data-type="text"/>
			
			<xsl:if test="CodaLedgerCode[not(.=user:GetNominalCode())] or CodaVATCode[not(.=user:GetVATCode())]">
				<xsl:variable name="NominalCode" select="CodaLedgerCode"></xsl:variable>
				<xsl:variable name="VATCode" select="CodaVATCode"></xsl:variable>
				<xsl:variable name="LineValue" select="sum(//InvoiceOrCreditLine[CodaLedgerCode[.=$NominalCode] and CodaVATCode[.=$VATCode]]/LineValueExclVAT)"/>
				<analysis-line>
					<nominal-account>
						<xsl:value-of select="CodaLedgerCode"></xsl:value-of>
					</nominal-account>
					<house-number>
						<xsl:value-of select="//InvoiceOrCreditHeader/DeliveryLocationCode"></xsl:value-of>		
					</house-number>
					<detail-line-description>
						<xsl:choose>
							<xsl:when test="not(//InvoiceOrCreditHeader/DeliveryDate)">Unknown Delivery Date EDI</xsl:when>
							<xsl:otherwise><xsl:value-of select="user:msFormatDate(//InvoiceOrCreditHeader/DeliveryDate)"></xsl:value-of> EDI</xsl:otherwise>
						</xsl:choose>
					</detail-line-description>
					<detail-line-value>
						<xsl:choose>
							<xsl:when test="$LineValue &lt; 0">
								<xsl:value-of select="format-number(-1 * $LineValue, '0.00')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number($LineValue, '0.00')"/>
							</xsl:otherwise>
						</xsl:choose>
					</detail-line-value>
					<detail-line-type>
						<xsl:choose>
							<xsl:when test="$LineValue &lt; 0">
								<xsl:choose>
									<xsl:when test="//InvoiceOrCreditHeader/DocumentType='Invoice'">Credit</xsl:when>
									<xsl:otherwise>Debit</xsl:otherwise>
								</xsl:choose>	
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="//InvoiceOrCreditHeader/DocumentType='Invoice'">Debit</xsl:when>
									<xsl:otherwise>Credit</xsl:otherwise>
								</xsl:choose>	
							</xsl:otherwise>
						</xsl:choose>							
					</detail-line-type>
					<detail-line-tax-code>
						<xsl:value-of select="CodaVATCode"></xsl:value-of>
					</detail-line-tax-code>
					<detail-line-tax-value>
						<xsl:choose>
							<xsl:when test="$LineValue &lt; 0">
								<xsl:value-of select="format-number(-1 * VATRate * $LineValue div 100, '0.00')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="format-number(VATRate * $LineValue div 100, '0.00')"/>
							</xsl:otherwise>
						</xsl:choose>
					</detail-line-tax-value>
				</analysis-line>
			</xsl:if>
			<xsl:value-of select="user:SetNominalCode(CodaLedgerCode)"/>
			<xsl:value-of select="user:SetVATCode(CodaVATCode)"/>
		</xsl:for-each>
	</analysis-lines>
	<tax-lines>
		<xsl:for-each select="InvoiceOrCreditTrailer/VATDetail/VATSubtotals">
			<tax-line>
				<tax-account-element-1>
					<xsl:value-of select="//InvoiceOrCreditHeader/CodaVATNominalCode"></xsl:value-of>
				</tax-account-element-1>
				<tax-account-element-2>
					<xsl:value-of select="CodaVATCode"></xsl:value-of>
				</tax-account-element-2>
				<tax-line-description>
					<xsl:choose>
						<xsl:when test="//InvoiceOrCreditHeader/DocumentType='Invoice'">EDI Invoice</xsl:when>
						<xsl:otherwise>EDI Credit Note</xsl:otherwise>
					</xsl:choose>				
				</tax-line-description>
				<tax-line-value>
					<xsl:value-of select="format-number(VATAmountAtRate,'0.00')"></xsl:value-of>
				</tax-line-value>
				<tax-line-type>
					<xsl:choose>
						<xsl:when test="//InvoiceOrCreditHeader/DocumentType='Invoice'">Debit</xsl:when>
						<xsl:otherwise>Credit</xsl:otherwise>
					</xsl:choose>				
				</tax-line-type>
				<tax-line-tax-code>
					<xsl:value-of select="CodaVATCode"></xsl:value-of>
				</tax-line-tax-code>
				<tax-line-tax-turnover>
					<xsl:value-of select="format-number(TotalExclVATAtRate,'0.00')"></xsl:value-of>
				</tax-line-tax-turnover>
			</tax-line>
		</xsl:for-each>
	</tax-lines>
</ABSformatEDIdocument>
</xsl:template>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[   
		var msNominalCode = ''
		var msVATCode = ''
		
		//Saves the nominal Code
		function SetNominalCode(vsNominalCode)
		{
			if(vsNominalCode.length > 0)
			{
				vsNominalCode= vsNominalCode(0).text;
			}
			
			msNominalCode = vsNominalCode;
			return '';
		}
		
		//Get the stored nominal code
		function GetNominalCode()
		{
			return msNominalCode ;
		}
		
		//Saves the VAT code
		function SetVATCode(vsVATCode)
		{
			if(vsVATCode.length > 0)
			{
				vsVATCode= vsVATCode(0).text;
			}
			
			msVATCode = vsVATCode;
			return '';
		}
		
		//Get the stored customer name
		function GetVATCode()
		{
			return msVATCode;
		}
		
		//Reformats the date
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
			}
			
			return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
				
		}
	]]></msxsl:script>
</xsl:stylesheet>