<?xml version="1.0" encoding="UTF-8"?>
<!--
************************************************************************************************************************************************************************************
 Overview

************************************************************************************************************************************************************************************
 Module History
************************************************************************************************************************************************************************************
 Date       | Name      | Description of modification
************************************************************************************************************************************************************************************
05/09/2017	| M Dimant	| FB 12105 : Created
************************************************************************************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
<xsl:output method="text" encoding="UTF-8"/>
	
<xsl:variable name="FieldSeperator" select="','"/>	
<xsl:variable name="NewLine" select="'&#13;&#10;'"/>

	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
		
	<xsl:template match="BatchHeader"/>
	
	<xsl:template match="InvoiceCreditJournalEntries">
		
		<xsl:for-each select="InvoiceCreditJournalEntriesDetail/InvoiceCreditJournalEntriesLine">

			<!-- Invoice  Date  -->	
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceDate"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Delivery Date  -->
			<xsl:choose>
				<xsl:when test="../../InvoiceCreditJournalEntriesHeader/DeliveryDate">
					<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/DeliveryDate"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Not Provided</xsl:text>
				</xsl:otherwise>
			</xsl:choose>			
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Vendor  -->	
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Invoice No  -->	
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>			
			 
			<!-- Description -->
			<xsl:value-of select="CategoryName"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- GROSS (inc vat) -->
			<xsl:value-of select="LineGross"/>
			<xsl:value-of select="$FieldSeperator"/>	
				
			<!-- Nom Code -->	
			<xsl:value-of select="CategoryNominal"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Area -->
			<xsl:value-of select="substring-before(../../InvoiceCreditJournalEntriesHeader/UnitSiteName,'/')"/>
			<xsl:value-of select="$FieldSeperator"/>	
				
			<!-- VBPG -->	
			<xsl:value-of select="../../InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- VAT00% -->
			<xsl:variable name="VATRate" select="format-number(LineVATPercentage,'00')"/>
			<xsl:value-of select="concat('VAT',$VATRate,'%')"/>
			<xsl:value-of select="$NewLine"/>	
		          	
		</xsl:for-each>
	
	</xsl:template>
	
</xsl:stylesheet>