<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Angus Invoice and Credit Batch Map
**********************************************************************
Name				| Date			| Change
*********************************************************************
M Dimant			|05/02/2018		| 12567: Created
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text" encoding="UTF-8"/>	

	<xsl:key name="InvNominal" match="Invoice/InvoiceDetail/InvoiceLine/LineExtraData/AccountCode" use="concat(.,../../VATCode)"/>
	<xsl:key name="CredNominal" match="CreditNote/CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode" use="concat(.,../../VATCode)"/>
	
	<xsl:variable name="NewLine">
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:variable>
	
	
	<xsl:template match="Invoice">	
	
	<!-- HEADERS -->
	<xsl:text>Our Reference,Invoice/Credit Note,2nd Reference,Invoice Date,Due Date,Description,Supplier,Actual Invoice No.,Invoice No.,Invoice Total,Total VAT,Site,Site Code,Nominal Name,Expense Code,Nominal Code,VAT Code,Value,VAT Amount,Gross (£),Status</xsl:text>
	<xsl:value-of select="$NewLine"/>	
				
		<!-- Create a line for each product nominal -->		
		<xsl:for-each select="InvoiceDetail/InvoiceLine/LineExtraData/AccountCode[generate-id() = generate-id(key('InvNominal',concat(.,../../VATCode))[1])]">
	
			<!-- Put the product nominal into a variable so we can use it later -->
			<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>
		
			<!-- Put the VAT code in a variable to use later -->
			<xsl:variable name="ProdVAT"><xsl:value-of select="../../VATCode"/></xsl:variable>	
		
			<!-- Internal Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Record Type -->
			<xsl:text>INV</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- 2nd Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Due Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Description (Supplier name) -->
			<xsl:value-of select="/Invoice/InvoiceHeader/Supplier/SuppliersName"/>
			<xsl:text>,</xsl:text>		
			<!-- Supplier Ledger Code -->	
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Actual Invoice Number -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Number -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Total Invoice Value -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/DocumentTotalInclVAT"/>
			<xsl:text>,</xsl:text>		
			<!-- Invoice VAT -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Name -->
			<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToName"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Name - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Expense Code -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Code -->	
			<xsl:value-of select="concat(/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode,'-',$ProdNom)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code - PV=20% VAT, NIL=0 VAT -->
			<xsl:choose>
				<xsl:when test="$ProdVAT = 'S'"><xsl:text>PV</xsl:text></xsl:when>
				<xsl:when test="$ProdVAT = 'Z'"><xsl:text>NIL</xsl:text></xsl:when>
				<xsl:otherwise><xsl:value-of select="$ProdVAT"/></xsl:otherwise>
			</xsl:choose>	
			<xsl:text>,</xsl:text>							
			<!-- Net Amount for given Nominal Code and VAT code  -->
			<xsl:variable name="NetAmount" select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode=$ProdVAT]/LineValueExclVAT)"/> 
			<xsl:value-of select="format-number($NetAmount,'0.00')"/>		
			<xsl:text>,</xsl:text>					
			<!-- VAT Amount for given Nominal Code and VAT code -->
			<xsl:variable name="VATAmount">
				<xsl:value-of select="format-number($NetAmount * (../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode=$ProdVAT]/VATRate div 100),'0.00')"/>
			</xsl:variable>
			<xsl:value-of select="$VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Gross  for given Nominal Code and VAT code -->	
			<xsl:value-of select="format-number($NetAmount + $VATAmount,'0.00')"/>
			<xsl:text>,</xsl:text>			
			<!-- Status - always Approved -->
			<xsl:text>Approved</xsl:text>
			
			<xsl:value-of select="$NewLine"/>	
		
		</xsl:for-each>
		
	</xsl:template>
			
	
	<!-- CREDIT NOTES -->
	
	<xsl:template match="CreditNote">

	<!-- HEADERS -->
	<xsl:text>Our Reference,Invoice/Credit Note,2nd Reference,Invoice Date,Due Date,Description,Supplier,Actual Invoice No.,Invoice No.,Invoice Total,Total VAT,Site,Site Code,Nominal Name,Expense Code,Nominal Code,VAT Code,Value,VAT Amount,Gross (£),Status</xsl:text>
	<xsl:value-of select="$NewLine"/>	
				
				
	<!-- Create a line for each product nominal -->		
	<xsl:for-each select="CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode[generate-id() = generate-id(key('CredNominal',.)[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">
		
			<!-- Internal Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Record Type -->
			<xsl:text>CRN</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- 2nd Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- CreditNote Date -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Due Date -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Description (Supplier name) -->
			<xsl:value-of select="//CreditNoteHeader/Supplier/SuppliersName"/>
			<xsl:text>,</xsl:text>		
			<!-- Supplier Ledger Code -->	
			<xsl:value-of select="//CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Actual CreditNote Number -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			<!-- CreditNote Number -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Total CreditNote Value -->
			<xsl:value-of select="//CreditNoteTrailer/DocumentTotalInclVAT"/>
			<xsl:text>,</xsl:text>		
			<!-- CreditNote VAT -->
			<xsl:value-of select="//CreditNoteTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Name -->
			<xsl:value-of select="//CreditNoteHeader/ShipTo/ShipToName"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Code -->
			<xsl:value-of select="//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Name - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Expense Code -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Code -->	
			<xsl:value-of select="concat(//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,'-',$ProdNom)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code - PV=20% VAT, NIL=0 VAT -->			
			<xsl:text>NIL,</xsl:text>			
			<!-- Value-->
			<xsl:variable name="LineValue">
				<xsl:value-of select="format-number(sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT),'0.00')"/>
			</xsl:variable>			
			<xsl:value-of select="$LineValue"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->			
			<xsl:variable name="VATAmount">
				<xsl:value-of select="format-number($LineValue * (../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/VATRate * 0.01),'0.00')"/>
			</xsl:variable>	
			<xsl:value-of select="$VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Gross (£) -->	
			<xsl:value-of select="format-number($LineValue + $VATAmount,'0.00')"/>
			<xsl:text>,</xsl:text>			
			<!-- Status - always Approved -->
			<xsl:text>Approved</xsl:text>
			
			<xsl:value-of select="$NewLine"/>	
				
		</xsl:if>	
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">
		
			<!-- Internal Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Record Type -->
			<xsl:text>INV</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- 2nd Reference field - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- CreditNote Date -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Due Date -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Description (Supplier name) -->
			<xsl:value-of select="//CreditNoteHeader/Supplier/SuppliersName"/>
			<xsl:text>,</xsl:text>			
			<!-- Supplier Ledger Code -->	
			<xsl:value-of select="//CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>				
			<!-- Actual CreditNote Number -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>				
			<!-- CreditNote Number -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>				
			<!-- Total CreditNote Value -->
			<xsl:value-of select="//CreditNoteTrailer/DocumentTotalInclVAT"/>
			<xsl:text>,</xsl:text>			
			<!-- CreditNote VAT -->
			<xsl:value-of select="//CreditNoteTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Name -->
			<xsl:value-of select="//CreditNoteHeader/ShipTo/ShipToName"/>
			<xsl:text>,</xsl:text>			
			<!-- Site Code -->
			<xsl:value-of select="//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Name - leave blank-->
			<xsl:text>,</xsl:text>			
			<!-- Expense Code -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Code -->	
			<xsl:value-of select="concat(//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,'-',$ProdNom)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code - PV=20% VAT, NIL=0 VAT -->			
			<xsl:text>PV,</xsl:text>			
			<!-- Value-->
			<xsl:variable name="LineValue">
				<xsl:value-of select="format-number(sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT),'0.00')"/>
			</xsl:variable>			
			<xsl:value-of select="$LineValue"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->			
			<xsl:variable name="VATAmount">
				<xsl:value-of select="format-number($LineValue * (../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/VATRate * 0.01),'0.00')"/>
			</xsl:variable>	
			<xsl:value-of select="$VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Gross (£) -->	
			<xsl:value-of select="format-number($LineValue + $VATAmount,'0.00')"/>
			<xsl:text>,</xsl:text>			
			<!-- Status - always Approved -->
			<xsl:text>Approved</xsl:text>
			
			<xsl:value-of select="$NewLine"/>	
				
		</xsl:if>
		
	</xsl:for-each>
		
	</xsl:template>


</xsl:stylesheet>
