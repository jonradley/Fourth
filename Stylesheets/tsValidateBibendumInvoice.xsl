<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateBibendumInvoice.xsl
Description	: Validates Bibendum invoices
Author		: A Sheppard
Date		: 04/03/2004
Alterations	: A Sheppard, 15/10/2004 - Upgraded for new schemas
Alterations	: A Sheppard, 17/12/2004. Add tolerances
Alterations	: Lee Boyton, 27/04/2005. H408. Changed into Bibendum specific version to
                                     remove some of the restrictions.
Alterations	: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet version="1.0" 
			     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			     xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:element name="ValidationErrors">
			<xsl:call-template name="tempVATSubtotals"/>
			<xsl:call-template name="tempTotals"/>
		</xsl:element>	
	</xsl:template>

	<!--This template will check various validation rules for all vat sub totals-->
	<xsl:template name="tempVATSubtotals">
		<xsl:for-each select="//VATSubTotal">
			<xsl:variable name="VATCode"><xsl:value-of select="@VATCode"/></xsl:variable>
			<xsl:variable name="VATRate"><xsl:value-of select="@VATRate"/></xsl:variable>
			<!--Check NumberOfLinesAtRate-->
			<xsl:if test="not(format-number(count(//InvoiceLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]), '#') = format-number(NumberOfLinesAtRate, '#'))">
				<xsl:element name="Error">
					<xsl:text>The line count at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the actual number of lines at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check NumberOfItemsAtRate-->
			<xsl:if test="not(format-number(sum(//InvoiceLine[VATCode=$VATCode and format-number(VATRate, '#.00')=format-number($VATRate, '#.00')]/InvoicedQuantity), '#.0000') = format-number(NumberOfItemsAtRate, '#.0000'))">
				<xsl:element name="Error">
					<xsl:text>The item count at rate for VAT code </xsl:text>
					<xsl:value-of select="$VATCode"/>
					<xsl:text> does not match the actual number of items at the rate.</xsl:text>
				</xsl:element>	
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!--This template will check various validation rules for the totals-->
	<xsl:template name="tempTotals">
		<!--Check NumberOfLines-->
		<xsl:if test="not(format-number(count(//InvoiceLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>The line count given in this document does not match the number of lines present.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check NumberOfItems-->
		<xsl:if test="not(format-number(sum(//InvoicedQuantity), '#.0000') = format-number(//NumberOfItems, '#.0000'))">
			<xsl:element name="Error">
				<xsl:text>The item count given in this document does not match the number of items present.</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>