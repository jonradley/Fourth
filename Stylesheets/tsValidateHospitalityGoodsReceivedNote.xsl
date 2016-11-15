<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateHospitalityGoodsReceivedNote.xsl
Description	: Validates hospitality goods received notes.
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
			<xsl:call-template name="tempLines"/>
			<xsl:call-template name="tempTotals"/>
		</xsl:element>	
	</xsl:template>

	<!--This template will check various validation rules for all lines-->
	<xsl:template name="tempLines">
		<xsl:for-each select="//GoodsReceivedNoteLine">
			<!--Check LineValueExclVAT-->
			<xsl:if test="(format-number(number(AcceptedQuantity) * number(UnitValueExclVAT), '#.00') &gt; format-number(number(LineValueExclVAT) + 0.01, '#.00')) or (format-number(number(AcceptedQuantity) * number(UnitValueExclVAT), '#.00') &lt; format-number(number(LineValueExclVAT) - 0.01, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The total value on line </xsl:text>
					<xsl:value-of select="LineNumber"/>
					<xsl:text> does not match the unit value multiplied by the quantity.</xsl:text>
				</xsl:element>	
			</xsl:if>
			<!--Check LineDiscountValue-->
			<xsl:if test="LineDiscountRate">
				<xsl:if test="(format-number(number(LineValueExclVAT) * number(LineDiscountRate) div 100, '#.00') &gt; format-number(number(LineDiscountValue) + 0.01, '#.00')) or (format-number(number(LineValueExclVAT) * number(LineDiscountRate) div 100, '#.00') &lt; format-number(number(LineDiscountValue) - 0.01, '#.00'))">
					<xsl:element name="Error">
						<xsl:text>The discount value on line </xsl:text>
						<xsl:value-of select="LineNumber"/>
						<xsl:text> does not match the line value multiplied by the discount rate.</xsl:text>
					</xsl:element>	
				</xsl:if>
			</xsl:if>		
		</xsl:for-each>
	</xsl:template>

	<!--This template will check various validation rules for the totals-->
	<xsl:template name="tempTotals">
		<xsl:variable name="Tolerance"><xsl:value-of select="0.01 * (count(//GoodsReceivedNoteLine) + count(//GoodsReceivedNoteLine[LineDiscountValue and number(LineDiscountValue) != 0]))"/></xsl:variable>
	
		<!--Check NumberOfLines-->
		<xsl:if test="not(format-number(count(//GoodsReceivedNoteLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>The line count given in this document does not match the number of lines present.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DiscountedLinesTotalExclVAT-->
		<xsl:if test="(format-number(sum(//LineValueExclVAT) - sum(//LineDiscountValue), '#.00') &gt; format-number(number(//DiscountedLinesTotalExclVAT) + $Tolerance, '#.00')) or (format-number(sum(//LineValueExclVAT) - sum(//LineDiscountValue), '#.00') &lt; format-number(number(//DiscountedLinesTotalExclVAT) - $Tolerance, '#.00'))">
			<xsl:element name="Error">
				<xsl:text>The discounted lines total excl vat does not match the sum of the discounted line totals.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check DocumentDiscount-->
		<xsl:if test="(format-number(number(//DiscountedLinesTotalExclVAT) * number(//DocumentDiscountRate) div 100, '#.00') &gt; format-number(number(//DocumentDiscount) + ($Tolerance), '#.00')) or (format-number(number(//DiscountedLinesTotalExclVAT) * number(//DocumentDiscountRate) div 100, '#.00') &lt; format-number(number(//DocumentDiscount) - ($Tolerance), '#.00'))">
			<xsl:element name="Error">
				<xsl:text>The document discount does not match the discounted lines total excl vat * document discount rate.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check TotalExclVAT-->
		<xsl:if test="(format-number(number(//DiscountedLinesTotalExclVAT) - number(//DocumentDiscount), '#.00') &gt; format-number(number(//TotalExclVAT) + ($Tolerance), '#.00')) or (format-number(number(//DiscountedLinesTotalExclVAT) - number(//DocumentDiscount), '#.00') &lt; format-number(number(//TotalExclVAT) - ($Tolerance), '#.00'))">
			<xsl:element name="Error">
				<xsl:text>The total excl vat does not match the discounted lines excl vat - document discount.</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>