<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateHospitalityPurchaseOrderConfirmation.xsl
Description	: Validates hospitality purchase orders confirmations.
Author		: A Sheppard
Date		: 02/02/2004
Alterations	: A Sheppard, 17/12/2004. Add tolerances
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet version="1.0" 
			     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			     xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:element name="ValidationErrors">
			<xsl:call-template name="tempLineValueExclVAT"/>
			<xsl:call-template name="tempNumberOfLines"/>
			<xsl:call-template name="tempTotalExclVAT"/>
		</xsl:element>	
	</xsl:template>

	<!--This template will check that all values of LineValueExclVAT = Quantity*UnitValueExclVat for all lines that include prices-->
	<xsl:template name="tempLineValueExclVAT">
		<xsl:for-each select="//PurchaseOrderConfirmationLine">
			<xsl:if test="UnitValueExclVAT">
				<xsl:if test="(format-number(number(ConfirmedQuantity) * number(UnitValueExclVAT), '#.00') &gt; format-number(number(LineValueExclVAT) + 0.01, '#.00')) or (format-number(number(ConfirmedQuantity) * number(UnitValueExclVAT), '#.00') &lt; format-number(number(LineValueExclVAT) - 0.01, '#.00'))">
					<xsl:element name="Error">
						<xsl:text>The total value on line </xsl:text>
						<xsl:value-of select="LineNumber"/>
						<xsl:text> does not match the unit value multiplied by the quantity.</xsl:text>
					</xsl:element>	
				</xsl:if>
			</xsl:if>			
		</xsl:for-each>
	</xsl:template>

	<!--This template will check that the number of lines in the document matches the value found at the trailer level-->
	<xsl:template name="tempNumberOfLines">
		<xsl:if test="not(format-number(count(//PurchaseOrderConfirmationLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>The line count given in this document does not match the number of lines present.</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!--This template will check that the total of all line values excl VAT in the document matches the total value excl VAT if there is a total value-->
	<xsl:template name="tempTotalExclVAT">
		<xsl:if test="//TotalExclVAT">
			<xsl:if test="(format-number(sum(//LineValueExclVAT), '#.00') &gt; format-number(number(//TotalExclVAT) + (0.01 * count(//PurchaseOrderConfirmationLine)), '#.00')) or (format-number(sum(//LineValueExclVAT), '#.00') &lt; format-number(number(//TotalExclVAT) - (0.01 * count(//PurchaseOrderConfirmationLine)), '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The value excl VAT of the lines in this document does not add up to the total value excl VAT</xsl:text>
				</xsl:element>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>