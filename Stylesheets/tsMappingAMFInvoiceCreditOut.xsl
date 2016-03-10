<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a  csv format for AMF.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 30/07/2008 | Shailesh Dubey| Created module.
****************************************************************************************** 
 12/01/2009 | Rave Tech 	| 2681. Create VAT Lines for each AMF account code.
****************************************************************************************** 
 02/04/2009 | Natalie Dry        | Changed place that AMF's code for supplier comes from, because with 3663 and the parent 3663 member, it picks up the wrong one
 ****************************************************************************************** 
 25/01/2012 | H Robson 	| 5208 Multiple codes are supplied in the AccountCode field and (for certain suppliers) the format is going to change from "Nominal Code/VAT code" 
 to "Nominal Code/VAT code/Marketing Code". Backwards compatibility needs to be maintained. 
 ****************************************************************************************** 
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:user="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		  xmlns:vbscript="http://abs-Ltd.com"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output encoding="UTF-8"/>
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>	
	
	<!--Define keys to be used for finding distinct line information. -->
	<!-- this key uses the entirety of the account code -->
	<xsl:key name="keyLinesByAccount" match="InvoiceLine | CreditNoteLine" use="LineExtraData/AccountCode"/>	
	<!-- this key should only use the VAT code portion of the account code -->
	<xsl:key name="keyLinesByAccount2" match="InvoiceLine | CreditNoteLine" use="substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/')"/>
	
	<xsl:template match="/Invoice | /CreditNote">
			
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!-- store the Transaction type as it is referenced on multiple lines -->
		<xsl:variable name="TransactionType">
			<xsl:text>ACTUAL</xsl:text>
		</xsl:variable>
		
		<!-- store the Financial Year as it is referenced on multiple lines -->		
		<xsl:variable name="FinancialYear">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod">
					<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 1, 4)"/>					
				</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>	
		
		<!-- store the Financial Period  as it is referenced on multiple lines -->		
		<xsl:variable name="FinancialPeriod">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod">					
					<xsl:value-of select="substring(/Invoice/InvoiceHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				</xsl:when>
				<xsl:otherwise>				
					<xsl:value-of select="substring(/CreditNote/CreditNoteHeader/HeaderExtraData/FinancialPeriod, 5, 2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- store the Document Type  as it is referenced on multiple lines -->	
		<xsl:variable name="DocumentType">
					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:text>PINV</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>PCRN</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
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
		
		<!--  store the Supplier Name as it is referenced on multiple lines -->		
		<xsl:variable name="SuppliersName">
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersName">
					<xsl:value-of select="translate(/Invoice/InvoiceHeader/Supplier/SuppliersName,',','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate(/CreditNote/CreditNoteHeader/Supplier/SuppliersName,',','')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- store the VAT amount -->		
		<xsl:variable name="VATAmount">
			<xsl:choose>
				<xsl:when test="//InvoiceTrailer/VATAmount">
					<xsl:value-of select="//InvoiceTrailer/VATAmount"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//CreditNoteTrailer/VATAmount"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
				
		<!-- Control Account  Line-->
		<xsl:value-of select="$TransactionType"/>
		<xsl:text>,</xsl:text>				
		<xsl:value-of select="$FinancialYear"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$FinancialPeriod"/>
		<xsl:text>,</xsl:text>				
		<xsl:value-of select="$DocumentType"/>
		<xsl:text>,</xsl:text>
		<xsl:text>1</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$DocumentDate"/>
		<xsl:text>,</xsl:text>
		<xsl:text>30100005</xsl:text>   
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsCodeForSender">
				<xsl:choose>
				     <xsl:when test="contains(/Invoice/TradeSimpleHeader/RecipientsCodeForSender,'/')">			      
				         <xsl:value-of select="substring-before(/Invoice/TradeSimpleHeader/RecipientsCodeForSender,'/')"/>			     
				     </xsl:when>
				     <xsl:otherwise>
				        <xsl:value-of select="/Invoice/TradeSimpleHeader/RecipientsCodeForSender"/>
				     </xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				     <xsl:when test="contains(/CreditNote/TradeSimpleHeader/RecipientsCodeForSender,'/')">			      
				         <xsl:value-of select="substring-before(/CreditNote/TradeSimpleHeader/RecipientsCodeForSender,'/')"/>			     
				     </xsl:when>
				     <xsl:otherwise>
				        <xsl:value-of select="/CreditNote/TradeSimpleHeader/RecipientsCodeForSender"/>
				   </xsl:otherwise>
				</xsl:choose>					
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>			
		<xsl:text>,</xsl:text>			
		<xsl:text>,</xsl:text> 
		<xsl:choose>
			<xsl:when test="/Invoice/InvoiceTrailer/DocumentTotalInclVAT">
				<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>			
		<xsl:value-of select="$DocumentReference"/>
		<xsl:text>,</xsl:text>			
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$SuppliersName"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="$DocumentReference"/>
		<xsl:text>,</xsl:text>
		<xsl:text>,</xsl:text>																		
			
		<!--VAT Line-->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount2',substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/'))[1])]">
			<xsl:sort select="substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/')" data-type="text"/> 
			<xsl:variable name="AccountCode" select="substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/')"/> 
	
			<xsl:value-of select="$NewLine"/>
			<xsl:value-of select="$TransactionType"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$FinancialYear"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$FinancialPeriod"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentType"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="vbscript:getLineNumber()"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
			<xsl:text>30405010</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:text>,</xsl:text> 

			<xsl:choose>
				<!--When its NOT the last account code, Calculate VAT amt as, sum of (Line Value * VATRate) -->
				<xsl:when test="position() != last()">
					<xsl:variable name="summaryXML">
						<xsl:for-each select="//InvoiceLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') = $AccountCode] | //CreditNoteLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') = $AccountCode]">
							<LineVat>
								<xsl:value-of select="./LineValueExclVAT * ./VATRate div 100"/>
							</LineVat>
						</xsl:for-each>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number(sum(msxsl:node-set($summaryXML)/LineVat),'0.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(sum(msxsl:node-set($summaryXML)/LineVat),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:when>
				<!--When its a last account code, Calculate VAT amt as, Tralier VAT amount minus sum of VAT amounts of earlier lines to avoid rounding difference -->
				<xsl:otherwise>
					<xsl:variable name="summaryXML">
						<xsl:for-each select="//InvoiceLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') != $AccountCode] | //CreditNoteLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') != $AccountCode]">
							<LineVat>
								<xsl:value-of select="./LineValueExclVAT * ./VATRate div 100"/>
							</LineVat>
						</xsl:for-each>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="/Invoice">
							<xsl:value-of select="format-number($VATAmount - sum(msxsl:node-set($summaryXML)/LineVat),'0.00')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number($VATAmount - sum(msxsl:node-set($summaryXML)/LineVat),'0.00')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>  
			</xsl:choose>
			
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>
                    <xsl:value-of select="$AccountCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$SuppliersName"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(sum(//InvoiceLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(//CreditNoteLine[substring-before(substring-after(concat(LineExtraData/AccountCode,'/'),'/'),'/') = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

		</xsl:for-each>
		
		<!--Expense Line-->		
		<!-- use the keys for grouping Lines by Account Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<!-- 25/01/2012 - Marketing code needs to be output on Expense line -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
			
			<!-- 26/01/2012 - store the number of segments in the Account code -->
			<xsl:variable name="numberOfDelimiters">
				<xsl:call-template name="countChar">
					<xsl:with-param name="string" select="$AccountCode" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:value-of select="$NewLine"/>

			<xsl:value-of select="$TransactionType"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$FinancialYear"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$FinancialPeriod"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$DocumentType"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="vbscript:getLineNumber()"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
			<!-- nominal code (always the first segment of account code field) -->
			<xsl:choose>
			     <xsl:when test="contains($AccountCode,'/')">			      
			         <xsl:value-of select="substring-before($AccountCode,'/')"/>			     
			     </xsl:when>
			     <xsl:otherwise>
			        <xsl:value-of select="$AccountCode"/>
			     </xsl:otherwise>
			</xsl:choose> 
			<xsl:text>,</xsl:text>
				<xsl:choose>
				<xsl:when test="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode">
					<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- marketing code  -->
			<xsl:if test="$numberOfDelimiters = 2">
				<xsl:value-of select="substring-after(substring-after($AccountCode,'/'),'/')"/>
			</xsl:if>
			<xsl:text>,</xsl:text>			
			<xsl:text>,</xsl:text> 
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>
			<!-- VAT code -->			
			<xsl:choose>
				<xsl:when test="$numberOfDelimiters = 1"><xsl:value-of select="substring-after($AccountCode,'/')"/></xsl:when>
				<xsl:when test="$numberOfDelimiters = 2"><xsl:value-of select="substring-before(substring-after($AccountCode,'/'),'/')"/></xsl:when>
			     <xsl:otherwise>
			        <xsl:text>01</xsl:text>
			     </xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$SuppliersName"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>	
			<xsl:text>,</xsl:text>	
		</xsl:for-each>			
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
	
	<!-- a template to count instances of given character in string-->
	<xsl:template name="countChar">
		<xsl:param name="string" />
		<xsl:param name="char" select="'/'" />
		<xsl:variable name="stringWithoutChar">
			<xsl:value-of select="translate($string,'/','')" />
		</xsl:variable>
		<!-- return the result -->
		<xsl:value-of select="string-length($string) - string-length($stringWithoutChar)" />
	</xsl:template>

	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Dim lLineNumber
		lLineNumber = 2
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
	]]></msxsl:script>

</xsl:stylesheet>

