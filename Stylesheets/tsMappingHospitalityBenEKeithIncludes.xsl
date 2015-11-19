<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name		| Date		   	| Change
**********************************************************************
H Robson	| 2013-03-19		| 6189 Created Module
**********************************************************************
H Robson	| 2013-04-05		| 6298 Disjoin method: if theres no separator just output the whole code
**********************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!-- =============================================================================================
	CompoundProductCodeOperations
	INPUT: Product code, [UoM], [method]
	OUTPUT for join and disjoin methods: Product code		OUTPUT for validate method: Boolean showing if UoM is present or not
	DESCRIPTION: Creates compound product codes using UoMs (or other input), or removes compound part depending on method
	============================================================================================== -->
	<xsl:template name="CompoundProductCodeOperations">
		<xsl:param name="ProductCode" />
		<xsl:param name="UoM" />
		<xsl:param name="method" select="'join'" /> <!-- join, disjoin, validate -->
		<xsl:param name="separator" select="'&#45;'"/> <!-- minus sign -->
		
		<xsl:choose>
			<xsl:when test="$method = 'join'">
				<xsl:value-of select="$ProductCode" />
				<xsl:value-of select="$separator" />
        <!-- Use the Bek UoM codes for the product codes, as they are familiar to them -->
				<xsl:choose>
					<xsl:when test="$UoM = 'CA'"><xsl:text>CA</xsl:text></xsl:when>
					<xsl:when test="$UoM = 'LB'"><xsl:text>LB</xsl:text></xsl:when>
					<xsl:when test="$UoM = 'CS'"><xsl:text>CA</xsl:text></xsl:when>
					<xsl:when test="$UoM = 'EA'"><xsl:text>EA</xsl:text></xsl:when>
					<xsl:when test="$UoM = 'PND'"><xsl:text>LB</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$method = 'disjoin'">
				<xsl:choose>
					<xsl:when test="contains($ProductCode,$separator)"><xsl:value-of select="substring-before($ProductCode,$separator)"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$ProductCode"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$method = 'validate'">
				<xsl:choose>
					<xsl:when test="string-length(substring-before($ProductCode,$separator)) &gt; 0 and string-length(substring-after($ProductCode,$separator)) &gt; 0">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
