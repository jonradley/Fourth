<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Report into a csv format

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 03/07/2008 | Steve Hewitt | Created module. FB2305 - standard report csv with no column headers.
******************************************************************************************
 18/12/2008 | Lee Boyton   | 2305. Do not add trailing comma after last field.
******************************************************************************************
 24/05/2010 | Lee Boyton   | 3536. Internationalisation for Aramark Spain
******************************************************************************************
 21/06/2010 | Sandeep Sehgal | 3536. For Spanish Reports use ; as the field separator
******************************************************************************************
  08/07/2010 | Steve Hewitt  | FB3536 The path to the translations files cannot access a web box and branched into hosp
******************************************************************************************
  08/07/2010 | Sandeep Sehgal  | FB3739 CommaCharacter param changed to a variable
******************************************************************************************

******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="Internationalisation.xsl"/>
	<xsl:param name="RootFolderPath" select="'./Translations'"/>		
	<xsl:param name="LocaleID">
		<xsl:value-of select = "/Report/@LocaleID"></xsl:value-of>
	</xsl:param>
	<xsl:variable name="TranslationFile">
		Report<xsl:value-of select = "/Report/@ReportID"></xsl:value-of>.xml
	</xsl:variable>
	<xsl:variable name="ReportID">
		<xsl:value-of select = "/Report/@ReportID"></xsl:value-of>
	</xsl:variable>	
	<xsl:variable name="CommaCharacter"><xsl:if test="$LocaleID=1034">;</xsl:if><xsl:if test="$LocaleID=2057">,</xsl:if></xsl:variable >
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$LocaleID>0 and ($ReportID=88 or $ReportID=89 )">
				<!--Header Details-->
				<xsl:if test="/Report/HeaderDetails">
					<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
						<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Description"/><xsl:with-param name="ReportID" select="$ReportID"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
				<!--Line Details-->
				<xsl:if test="/Report/LineDetails/LineDetail">
					<xsl:for-each select="/Report/LineDetails/LineDetail">
						<xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
							<xsl:if test="position()>1">
								<xsl:value-of select="$CommaCharacter"></xsl:value-of>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@DataType = 6  or @DataType=14 or @DataType=5 or @DataType=131">
									<xsl:value-of select="script:gsFormatNumberByLocale(.,2,number($LocaleID),0)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="script:msFormatForCSV(.)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>&#xD;</xsl:text>
				<xsl:text>&#xD;</xsl:text>
				<!--Trailer Details-->
				<xsl:if test="/Report/TrailerDetails">
					<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
						<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:value-of select="script:gsFormatNumberByLocale(Value,2,number($LocaleID),0)"/><xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!--Header Details-->
				<xsl:if test="/Report/HeaderDetails">
					<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
						<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
				<!--Line Details-->
				<xsl:if test="/Report/LineDetails/LineDetail">
					<xsl:for-each select="/Report/LineDetails/LineDetail">
						<xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
							<xsl:if test="position()>1">
								<xsl:text>,</xsl:text>
							</xsl:if>
							<xsl:value-of select="script:msFormatForCSV(.)"/>
						</xsl:for-each>
						<xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>&#xD;</xsl:text>
				<xsl:text>&#xD;</xsl:text>
				<!--Trailer Details-->
				<xsl:if test="/Report/TrailerDetails">
					<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
						<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="SelectString">
		<xsl:param name="InputString"/>
		<xsl:param name="ReportID"/>
	</xsl:template>
</xsl:stylesheet>