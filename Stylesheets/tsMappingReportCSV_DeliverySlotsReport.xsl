<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Delivery Slots Report into a CSV format

 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           	| Description of modification
******************************************************************************************
 11/07/2007	| A Sheppard	| Created module for 1290
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="/Report/LineDetails/Columns/Column[@ID='1'] = 'Error'">
				<xsl:value-of select="script:msFormatForCSV(/Report/LineDetails/LineDetail[1]/Columns/Column[@ID='1'])"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>"H"</xsl:text>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(/Report/HeaderDetails/HeaderDetail[Description='BuyersCodeForSupplier']/Value)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(/Report/HeaderDetails/HeaderDetail[Description='FileDateTime']/Value)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(/Report/HeaderDetails/HeaderDetail[Description='PeriodStartDateTime']/Value)"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="script:msFormatForCSV(/Report/HeaderDetails/HeaderDetail[Description='PeriodEndDateTime']/Value)"/>
				<xsl:for-each select="/Report/LineDetails/LineDetail">
					<xsl:text>&#xD;</xsl:text>
					<xsl:text>"D"</xsl:text>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='1'])"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='2'])"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='3'])"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='4'])"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='5'])"/>
					<xsl:text>,</xsl:text>
					<xsl:value-of select="script:msFormatForCSV(Columns/Column[@ID='6'])"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
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
			else
			{
				return '';
			}
			
			while(vsString.indexOf('"') != -1)
			{
				vsString = vsString.replace('"','¬');
			}
			while(vsString.indexOf('¬') != -1)
			{
				vsString = vsString.replace('¬','""');
			}
					
			return '"' + vsString + '"';
				
		}
	]]></msxsl:script>
</xsl:stylesheet>