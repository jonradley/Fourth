<?xml version="1.0" encoding="UTF-8"?>
<!--
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name		: tsValidateHospitalityLynxGoodsReceivedNote.xsl
Description	: Validates hospitality lynx goods received notes.
Author		: Steve Hewitt
Date		: 20/01/2005
Alterations	: 
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
		<xsl:for-each select="//LynxGoodsReceivedNoteLine">
			<!--Check LineValueExclVAT-->
			<xsl:if test="(format-number(number(AcceptedQuantity) * number(UnitValueExclVAT), '#.00') &gt; format-number(number(LineValueExclVAT) + 0.01, '#.00')) or (format-number(number(AcceptedQuantity) * number(UnitValueExclVAT), '#.00') &lt; format-number(number(LineValueExclVAT) - 0.01, '#.00'))">
				<xsl:element name="Error">
					<xsl:text>The total value on line </xsl:text>
					<xsl:value-of select="LineNumber"/>
					<xsl:text> does not match the unit value multiplied by the quantity.</xsl:text>
				</xsl:element>	
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!--This template will check various validation rules for the totals-->
	<xsl:template name="tempTotals">
		<xsl:variable name="Tolerance"><xsl:value-of select="0.01 * (count(//LynxGoodsReceivedNoteLine))"/></xsl:variable>
	
		<!--Check NumberOfLines-->
		<xsl:if test="not(format-number(count(//LynxGoodsReceivedNoteLine), '#') = format-number(//NumberOfLines, '#'))">
			<xsl:element name="Error">
				<xsl:text>The line count given in this document does not match the number of lines present.</xsl:text>
			</xsl:element>
		</xsl:if>
		<!--Check TotalExclVAT-->
		<xsl:if test="(format-number(sum(//LineValueExclVAT), '#.00') &gt; format-number(number(//TotalExclVAT) + $Tolerance, '#.00')) or (format-number(sum(//LineValueExclVAT), '#.00') &lt; format-number(number(//TotalExclVAT) - $Tolerance, '#.00'))">
			<xsl:element name="Error">
				<xsl:text>The lines total excl vat does not match the sum of the line totals.</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>