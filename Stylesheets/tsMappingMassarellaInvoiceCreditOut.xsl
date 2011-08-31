<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a JDE pipe delimited format for Aramark.
 The pipe separated files will be concatenated into a batch by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       | Name      			      | Description of modification
******************************************************************************************
 21/07/08 |S Dubey, G Lokhande | Created module.
******************************************************************************************
		  |						| 
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">

	<xsl:output method="text" encoding="ISO-8859-1"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note;  the '::' literal is simply used as a convenient separator for the 2 values that make up the second key. -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>
	<xsl:key name="keyLinesByAccountAndVAT" match="InvoiceLine | CreditNoteLine" use="concat(LineExtraData/AccountCode,'::',VATCode)"/>
	
	<xsl:template match="/Invoice | /CreditNote">
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
				
		<!-- store the Document Type as it is referenced on multiple lines -->
		<xsl:variable name="DocumentType">
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:text>PI</xsl:text>
				</xsl:when>				
				<xsl:otherwise>
					<xsl:text>PC</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- store the Account as it is referenced on multiple lines -->	
		<xsl:variable name="Account">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
					<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</xsl:when>				
				<xsl:otherwise>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>		
		
		<!-- store the Dept as it is referenced on multiple lines -->
		<xsl:variable name="Dept">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
					<xsl:value-of select="substring(/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode,string-length(/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode)-2)"/>		
				</xsl:when>				
				<xsl:otherwise>				
					 <xsl:value-of select="substring(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,string-length(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode)-2)"/> 
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<!-- store the Invoice Date -->		
		<xsl:variable name="DocumentDate">
			<xsl:choose>
				<xsl:when test="//HeaderExtraData/FinancialPeriodStartDate">
					<xsl:call-template name="formatDate">					
						<xsl:with-param name="xmlDate" select="//HeaderExtraData/FinancialPeriodStartDate"/>
					</xsl:call-template>	
				</xsl:when>
				<xsl:when test="InvoiceHeader/InvoiceReferences/InvoiceDate">
					<xsl:call-template name="formatDate">					
						<xsl:with-param name="xmlDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:call-template>				
				</xsl:when>				
				<xsl:otherwise>	
					<xsl:call-template name="formatDate">					
						<xsl:with-param name="xmlDate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</xsl:call-template>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- store the Invoice/Debit Number-->
		<xsl:variable name="DocumentReference">
			<xsl:choose>
				<xsl:when test="InvoiceHeader/InvoiceReferences/InvoiceReference">
					<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				</xsl:when>			
				<xsl:otherwise>
					<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		

		<!-- use the keys for grouping Lines by Account Code and then by VAT Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(InvoiceDetail/InvoiceLine |  CreditNoteDetail/CreditNoteLine )[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>			
			
			<!-- now, given we can find all lines for the current Account Code, loop through and match the first line for each unique VAT Code -->
			<xsl:for-each select="key('keyLinesByAccount',$AccountCode)[generate-id() = generate-id(key('keyLinesByAccountAndVAT',concat($AccountCode,'::',VATCode))[1])]">
				<xsl:sort select="VATCode" data-type="text"/>
				<xsl:variable name="VATCode" select="VATCode"/>
				<xsl:variable name="VATRate" select="VATRate"/>

				<!-- calculate the NET and VAT amounts for this summary line  -->
				<xsl:variable name="LineTotalExclVAT">
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
						</xsl:when>						
						<xsl:otherwise>
							<xsl:value-of select="format-number(sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
								
				<xsl:variable name="LineVATAmount">
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT) * ($VATRate div 100),'0.00')"/>
						</xsl:when>					
						<xsl:otherwise>
							<xsl:value-of select="format-number(sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode and VATCode = $VATCode]/LineValueExclVAT) * ($VATRate div 100),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:variable>
				
				<!-- now output a summary line for the current Account Code and VAT Code combination -->					
				<xsl:value-of select="$DocumentType"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$Account"/>
				<xsl:text>,</xsl:text>					
				<xsl:value-of select="$AccountCode"/> 
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$Dept"/>
				<xsl:text>,</xsl:text>				
				<xsl:value-of select="$DocumentDate"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$DocumentReference"/>					
				<xsl:text>,</xsl:text>							
				<xsl:text>,</xsl:text>
				<xsl:value-of select="format-number($LineTotalExclVAT,'0.00')"/>
				<xsl:text>,</xsl:text>
				<!-- translate the VAT code -->
				<xsl:choose>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'S') or LineExtraData/BuyersVATCode = 'S' or LineExtraData/BuyersVATCode = '1'"><xsl:text>T1</xsl:text>											</xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'Z') or LineExtraData/BuyersVATCode = 'Z' or LineExtraData/BuyersVATCode = '3'"><xsl:text>T3</xsl:text>											</xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'E') or LineExtraData/BuyersVATCode = 'E' or LineExtraData/BuyersVATCode = '4'"><xsl:text>T4</xsl:text></xsl:when>
					<xsl:when test="(not(LineExtraData/BuyersVATCode) and $VATCode = 'L') or LineExtraData/BuyersVATCode = 'L' or LineExtraData/BuyersVATCode = '2'"><xsl:text>T2</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text>5</xsl:text></xsl:otherwise>
				</xsl:choose>				
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$LineVATAmount"/>						
				<xsl:value-of select="$NewLine"/>
			</xsl:for-each>
		</xsl:for-each>
		
	</xsl:template>
	<!-- translates a date in YYYY-MM-DD format to a date in DDMMYYYY format -->
	<xsl:template name="formatDate">
		<xsl:param name="xmlDate"/>
		
		<xsl:value-of select="substring($xmlDate,9,2)"/>		
		<xsl:value-of select="substring($xmlDate,6,2)"/>		
		<xsl:value-of select="substring($xmlDate,1,4)"/>
		
	</xsl:template>	
</xsl:stylesheet>
