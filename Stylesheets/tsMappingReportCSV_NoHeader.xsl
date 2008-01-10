<!--
******************************************************************************************
 $Header: /trunk/Stylesheets/tsMappingReportCSV.xsl 4     29/09/04 10:15 Shepparda $
 Overview

 This XSL file is used to transform XML for a Report into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 23/08/2004 | A Sheppard | Created module.
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<!--Line Details-->
		<xsl:if test="/Report/LineDetails/LineDetail">
			<xsl:for-each select="/Report/LineDetails/LineDetail">
				<xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
					<xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
				</xsl:for-each>
				<xsl:text>&#xD;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>&#xD;</xsl:text>
		<!--Trailer Details-->
		<xsl:if test="/Report/TrailerDetails">
			<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
				<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		/*=========================================================================================
		' Routine       	 : msFormatForCSV
		' Description 	 : Formats the string for a csv file
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatForCSV(vsString)
		{
			if(vsString.length > 0)
			{
				vsString = vsString(0).text;
			}
			
			while(vsString.indexOf('"') != -1)
			{
				vsString = vsString.replace('"','¬');
			}
			while(vsString.indexOf('¬') != -1)
			{
				vsString = vsString.replace('¬','""');
			}
			
			if(vsString.indexOf('"') != -1 || vsString.indexOf(',') != -1)
			{
				vsString = '"' + vsString + '"';
			}
			
			return vsString;
				
		}
		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in mm/dd/yyyy format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
		
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(8,2) + "/" +vsDate.substr(5,2) + "/" + vsDate.substr(0,4);
			}
			else
			{
				return '';
			}
				
		}
		
		/*=========================================================================================
		' Routine       	 : mbNeedHeader
		' Description 	 : Determines whether a new header row is required
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/08/2004
		' Alterations   	 : 
		'========================================================================================*/
		var msPreviousGroupingValues = '-';
		function mbNeedHeader(vcolGroupingValues)
		{
		var sCurrentGroupingValues = '';	
			
			if(vcolGroupingValues.length > 0)
			{
				for(var n1 = 0; n1 <= vcolGroupingValues.length - 1; n1++)
				{
					sCurrentGroupingValues += vcolGroupingValues(n1).text + '¬';
				}
			}
			
			if(sCurrentGroupingValues != msPreviousGroupingValues)
			{
				msPreviousGroupingValues = sCurrentGroupingValues;
				msPreviousRowClass = 'listrow0'
				return true;
			}
			else
			{
				return false;
			}
		}
	]]></msxsl:script>
</xsl:stylesheet>