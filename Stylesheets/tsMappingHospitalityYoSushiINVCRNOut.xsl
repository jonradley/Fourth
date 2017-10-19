<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************************************************************
Yo Sushi Invoice and Credit Batch Map
*******************************************************************************************************************************************
Name			| Date			| Change
*******************************************************************************************************************************************
M Dimant		| 10/10/2017	| 12082: Created
*******************************************************************************************************************************************
W Nassor		| 19/10/2017	| 12082: Removed '-' for credit values in Net Amount
*******************************************************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="text" encoding="UTF-8"/>
	
		<xsl:variable name="NewLine" select="'&#13;&#10;'"/>
		
		<xsl:key name="InvNominal" match="Invoice/InvoiceDetail/InvoiceLine/LineExtraData/AccountCode" use="concat(.,../../VATCode)"/>
		<xsl:key name="CredNominal" match="CreditNote/CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode" use="concat(.,../../VATCode)"/>

		<xsl:template match="Invoice">
		
		<!-- Create a line for each product nominal -->		
		<xsl:for-each select="InvoiceDetail/InvoiceLine/LineExtraData/AccountCode[generate-id() = generate-id(key('InvNominal',concat(.,../../VATCode))[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>		
		
		<!-- Put the VAT code in a variable to use later -->
		<xsl:variable name="ProdVAT"><xsl:value-of select="../../VATCode"/></xsl:variable>		

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
			<!-- VAT total -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT value -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:choose>
				<xsl:when test="contains($ProdNom,'-')">
					<xsl:value-of select="substring-before($ProdNom,'-')"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$ProdNom"/></xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>			
			
			<!-- Net Amount for given Nominal Code and VAT code  -->
			<xsl:variable name="NetAmount" select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode=$ProdVAT]/LineValueExclVAT)"/> 
			<xsl:value-of select="format-number($NetAmount,'0.00')"/>
			
			<xsl:text>,</xsl:text>		
				
			<!-- VAT Amount -->
			<xsl:value-of select="/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode=$ProdVAT]/VATAmountAtRate"/>
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
			<xsl:choose>
				<xsl:when test="contains($ProdNom,'-')">
					<xsl:value-of select="substring-after($ProdNom,'-')"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$ProdNom"/></xsl:otherwise>
			</xsl:choose>	
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:value-of select="$ProdVAT"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:value-of select="position()"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>		
			<xsl:value-of select="$NewLine"/>			
		
		
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="CreditNote">
		
		<!-- Create a line for each product nominal -->		
		<xsl:for-each select="CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode[generate-id() = generate-id(key('CredNominal',concat(.,../../VATCode))[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>		
		
		<!-- Put the VAT code in a variable to use later -->
		<xsl:variable name="ProdVAT"><xsl:value-of select="../../VATCode"/></xsl:variable>		

			<!-- Internal Ref -->	
			<xsl:value-of select="/CreditNote/CreditNoteHeader/BatchInformation/FileGenerationNo"/>		
			<xsl:text>,</xsl:text>			
			<!-- Credit -->
			<xsl:text>PCR</xsl:text>
			<xsl:text>,</xsl:text>
			<!-- Supplier Code -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Ref-->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT total -->
			<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT value -->
			<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATAmount"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Description -->
			<xsl:choose>
				<xsl:when test="contains($ProdNom,'-')">
					<xsl:value-of select="substring-before($ProdNom,'-')"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$ProdNom"/></xsl:otherwise>
			</xsl:choose>			
			<xsl:text>,</xsl:text>			
			<!-- Net Amount for given Nominal Code and VAT code -->			
			<xsl:variable name="NetAmount" select="sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode=$ProdVAT]/LineValueExclVAT)"/> 		
			<xsl:value-of select="format-number($NetAmount,'0.00')"/>
			<xsl:text>,</xsl:text>			
			<!-- VAT Amount -->
			<xsl:value-of select="/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode=$ProdVAT]/VATAmountAtRate"/>
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
			<xsl:choose>
				<xsl:when test="contains($ProdNom,'-')">
					<xsl:value-of select="substring-after($ProdNom,'-')"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$ProdNom"/></xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>			
			<!-- VAT Code -->
			<xsl:value-of select="$ProdVAT"/>
			<xsl:text>,</xsl:text>			
			<!-- Nominal Line No -->
			<xsl:value-of select="position()"/>
			<xsl:text>,</xsl:text>			
			<!-- Invoice Date -->
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>		
			<xsl:value-of select="$NewLine"/>	
		
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
