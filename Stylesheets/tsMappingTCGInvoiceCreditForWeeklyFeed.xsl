<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a tab delimited format to be compiled into
 the weekly feed for TCG

 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 18/07/2007 | A Sheppard 	| Created module.
******************************************************************************************
 11/08/2008 | Lee Boyton	| 2410. Ensure line numbers are unique.
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:user="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		<xsl:variable name="Tab">
			<xsl:text>&#09;</xsl:text>
		</xsl:variable>

		<!--Detail Lines-->
		<xsl:for-each select="//InvoiceLine | //CreditNoteLine">
			<xsl:value-of select="//RecipientsCodeForSender"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="//SuppliersName"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="//RecipientsBranchReference"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="//ShipToName"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference | /Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate | /Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/TaxPointDate | /Invoice/InvoiceHeader/InvoiceReferences/TaxPointDate"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="position()"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteReference"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="DeliveryNoteReferences/DespatchDate"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="ProductID/SuppliersProductCode"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="ProductDescription"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="PackSize"/>
			<xsl:value-of select="$Tab"/>
			<xsl:choose>
				<xsl:when test="CreditedQuantity"><xsl:value-of select="-1 * number(CreditedQuantity)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="InvoicedQuantity"/></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$Tab"/>
			<xsl:choose>
				<xsl:when test="CreditedQuantity"><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="UnitValueExclVAT"/>
			<xsl:value-of select="$Tab"/>
			<xsl:choose>
				<xsl:when test="CreditedQuantity"><xsl:value-of select="-1 * number(LineValueExclVAT)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="LineValueExclVAT"/></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="VATCode"/>
			<xsl:value-of select="$Tab"/>
			<xsl:value-of select="VATRate"/>
			<xsl:value-of select="$NewLine"/>
		</xsl:for-each>

	</xsl:template>

</xsl:stylesheet>