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
 Date       | Name       | Description of modification
******************************************************************************************
 30/07/2008 | Shailesh Dubey| Created module.
****************************************************************************************** 
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:user="http://mycompany.com/mynamespace"
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
				<xsl:when test="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode">
					<xsl:choose>
					     <xsl:when test="contains(/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode,'/')">			      
					         <xsl:value-of select="substring-before(/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode,'/')"/>			     
					     </xsl:when>
					     <xsl:otherwise>
					        <xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
					     </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
					     <xsl:when test="contains(/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode,'/')">			      
					         <xsl:value-of select="substring-before(/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode,'/')"/>			     
					     </xsl:when>
					     <xsl:otherwise>
					        <xsl:value-of select="/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
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
					<xsl:value-of select="format-number(-1* /CreditNote/CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
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
			<xsl:value-of select="$NewLine"/>
			
		
		<!--VAT Line-->
			<xsl:value-of select="$TransactionType"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$FinancialYear"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$FinancialPeriod"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$DocumentType"/>
			<xsl:text>,</xsl:text>
			<xsl:text>2</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
			<xsl:text>30405010</xsl:text>   
			<xsl:text>,</xsl:text>			
			<xsl:text>,</xsl:text>			
			<xsl:text>,</xsl:text>			
			<xsl:text>,</xsl:text> 
			<xsl:choose>
				<xsl:when test="/Invoice/InvoiceTrailer/VATAmount">
					<xsl:value-of select="format-number(/Invoice/InvoiceTrailer/VATAmount,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * /CreditNote/CreditNoteTrailer/VATAmount,'0.00')"/>
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
			
		
		<!--Expense Line-->		
		<!-- use the keys for grouping Lines by Account Code -->
		<!-- the first loop will match the first line in each set of lines grouped by Account Code -->
		<xsl:for-each select="(CreditNoteDetail/CreditNoteLine | InvoiceDetail/InvoiceLine)[generate-id() = generate-id(key('keyLinesByAccount',LineExtraData/AccountCode)[1])]">
			<xsl:sort select="LineExtraData/AccountCode" data-type="text"/>
			<xsl:variable name="AccountCode" select="LineExtraData/AccountCode"/>
						
			<xsl:value-of select="$NewLine"/>
			
			<xsl:value-of select="$TransactionType"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$FinancialYear"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$FinancialPeriod"/>
			<xsl:text>,</xsl:text>				
			<xsl:value-of select="$DocumentType"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="position() + 2"/>	
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$DocumentDate"/>
			<xsl:text>,</xsl:text>
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
			<xsl:text>,</xsl:text>			
			<xsl:text>,</xsl:text> 
			<xsl:choose>
				<xsl:when test="/Invoice">
					<xsl:value-of select="format-number(sum(//InvoiceLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * sum(//CreditNoteLine[LineExtraData/AccountCode = $AccountCode]/LineValueExclVAT),'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>			
			<xsl:value-of select="$DocumentReference"/>
			<xsl:text>,</xsl:text>					
			<xsl:choose>
			     <xsl:when test="contains($AccountCode,'/')">			      
			         <xsl:value-of select="substring-after($AccountCode,'/')"/>			     
			     </xsl:when>
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
		
</xsl:stylesheet>

