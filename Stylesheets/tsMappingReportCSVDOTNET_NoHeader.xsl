<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Report into CSV having column headers but without the Report header 

 © Fourth Hospitality., 2014.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 30/07/2014 | Sandeep Sehgal | 7908 Created. Ported from tsmappingReportCSVDotNet.xsl
******************************************************************************************

******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="InternationalisationDOTNET.xsl"/>
	<xsl:param name="RootFolderPath" select="'./Translations'"/>
	<xsl:param name="LocaleID"><xsl:value-of select="/Report/@LocaleID"/></xsl:param>
	<xsl:variable name="TranslationFile">Report<xsl:value-of select="/Report/@ReportID"/>.xml</xsl:variable>
	<xsl:variable name="ReportID"><xsl:value-of select="/Report/@ReportID"/></xsl:variable>
	<xsl:variable name="CommaCharacter">
		<xsl:if test="$LocaleID=1034">;</xsl:if>
		<xsl:if test="$LocaleID=2057">,</xsl:if>
	</xsl:variable>
	<xsl:template match="/">
		<!--Line Details-->
		<xsl:if test="/Report/LineDetails/LineDetail">
			<xsl:for-each select="/Report/LineDetails/LineDetail">
				<xsl:if test="script:mbNeedHeader(Columns/Column[@GroupBy = '1' or @GroupBy = 'true'])">
					<xsl:for-each select="Columns/Column[@GroupBy = '1' or @GroupBy = 'true']">
						<xsl:variable name="ColumnID">
							<xsl:value-of select="@ID"/>
						</xsl:variable>
						<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/Columns/Column[@ID = $ColumnID])"/>
						<xsl:text>,</xsl:text>
						<xsl:value-of select="script:msFormatForCSV(.)"/>
						<xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
					<xsl:for-each select="/Report/LineDetails/Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
						<xsl:value-of select="script:msFormatForCSV(.)"/>
						<xsl:text>,</xsl:text>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>&#xD;</xsl:text>
				<xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
					<xsl:choose>
						<xsl:when test="(@DataType = 200) and . != ''">
							<xsl:text>"</xsl:text><xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>"</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="script:msFormatForCSV(.)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>,</xsl:text>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
