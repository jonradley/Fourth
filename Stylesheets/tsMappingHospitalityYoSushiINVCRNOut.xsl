<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************************************************************
Yo Susgi Invoice and Credit Batch Map
*******************************************************************************************************************************************
Name			| Date			| Change
*******************************************************************************************************************************************
M Dimant		| 10/10/2017	| 12082: Created
*******************************************************************************************************************************************

*******************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	
		<xsl:variable name="NewLine" select="'&#13;&#10;'"/>
		
		<xsl:key name="InvNominal" match="Invoice/InvoiceDetail/InvoiceLine/LineExtraData/AccountCode" use="."/>
		<xsl:key name="CredNominal" match="CreditNote/CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode" use="."/>

		<xsl:template match="Invoice">
		
		<!-- Create a line for each product nominal -->		
		<xsl:for-each select="InvoiceDetail/InvoiceLine/LineExtraData/AccountCode[generate-id() = generate-id(key('InvNominal',.)[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>		
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">

			<!-- Internal Ref -->	
			<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileGenerationNo"/>		
			<xsl:text>,</xsl:text>			
			<!-- Invoice -->
			<xsl:text>PIN</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Ref-->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Net Amount for given Nominal Code and VAT code Z -->
			<xsl:value-of select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode='Z']/VATAmountAtRate"/>
			<xsl:text>,</xsl:text>			
			<!-- UK/US -->
			<xsl:choose>
				<xsl:when test="substring(/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode,1,2) = 'Y9' ">
					<xsl:text>US</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>UK</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>			
			<!-- Restaurant Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode"/>
			<xsl:text>,</xsl:text>			
			<!-- GL Code (Nominal) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:text>Z</xsl:text>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>		
			<xsl:value-of select="$NewLine"/>			
		</xsl:if>
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">

			<!-- Internal Ref -->	
			<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileGenerationNo"/>		
			<xsl:text>,</xsl:text>			
			<!-- Invoice -->
			<xsl:text>PIN</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Ref-->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Net Amount for given Nominal Code and VAT code S -->
			<xsl:value-of select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode='S']/VATAmountAtRate"/>
			<xsl:text>,</xsl:text>			
			<!-- UK/US -->
			<xsl:choose>
				<xsl:when test="substring(/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode,1,2) = 'Y9' ">
					<xsl:text>US</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>UK</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>			
			<!-- Restaurant Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/CompanyCode"/>
			<xsl:text>,</xsl:text>			
			<!-- GL Code (Nominal) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:text>S</xsl:text>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>		
			<xsl:value-of select="$NewLine"/>			
		</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="CreditNote">
		
		<!-- Create a line for each product nominal -->		
		<xsl:for-each select="CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode[generate-id() = generate-id(key('Nominal',.)[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>		
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">

			<!-- Internal Ref -->	
			<xsl:value-of select="/CreditNote/CreditNoteHeader/BatchInformation/FileGenerationNo"/>		
			<xsl:text>,</xsl:text>			
			<!-- Invoice -->
			<xsl:text>PCR</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Ref-->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Net Amount for given Nominal Code and VAT code Z -->			
			<xsl:variable name="NetAmount">
				<xsl:value-of select="sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT)"/>
			</xsl:variable>
			<!-- Credit values must be represented as negatives -->
			<xsl:value-of select="concat('-',$NetAmount)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->
			<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode='Z']/VATAmountAtRate"/>
			<xsl:text>,</xsl:text>			
			<!-- UK/US -->
			<xsl:choose>
				<xsl:when test="substring(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,2) = 'Y9' ">
					<xsl:text>US</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>UK</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>			
			<!-- Restaurant Code -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			<xsl:text>,</xsl:text>			
			<!-- GL Code (Nominal) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:text>Z</xsl:text>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>		
			<xsl:value-of select="$NewLine"/>			
		</xsl:if>
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">

			<!-- Internal Ref -->	
			<xsl:value-of select="/CreditNote/CreditNoteeHeader/BatchInformation/FileGenerationNo"/>		
			<xsl:text>,</xsl:text>			
			<!-- Invoice -->
			<xsl:text>PIN</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier Code -->
			<xsl:value-of select="/Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Ref-->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Blank -->
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- Net Amount for given Nominal Code and VAT code S -->
			<xsl:variable name="NetAmount">
				<xsl:value-of select="sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT)"/>
			</xsl:variable>
			<!-- Credit values must be represented as negatives -->
			<xsl:value-of select="concat('-',$NetAmount)"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->
			<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode='S']/VATAmountAtRate"/>
			<xsl:text>,</xsl:text>			
			<!-- UK/US -->
			<xsl:choose>
				<xsl:when test="substring(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,2) = 'Y9' ">
					<xsl:text>US</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>UK</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>			
			<!-- Restaurant Code -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			<xsl:text>,</xsl:text>			
			<!-- GL Code (Nominal) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:text>S</xsl:text>	
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:text>1</xsl:text>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>		
			<xsl:value-of select="$NewLine"/>			
		</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
