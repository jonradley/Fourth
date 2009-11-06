<!--
******************************************************************************************
 $Header: /trunk/Stylesheets/tsMappingAramarkGRNWithSubTotalReportCSV.xsl
 Overview

 This XSL file is used to transform XML for a Report into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date            | Name           | Description of modification
******************************************************************************************
 30/06/2009 | Rave Tech	  | 2965 Created module.
******************************************************************************************
 06/11/2009 | Rave Tech	  | 3226 Added Stock Amount(id=10) & Non Stock Amount(id=11) columns.
 ******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text" encoding="utf-8"/>	 
	<xsl:template match="/">
		<xsl:value-of select="script:msFormatForCSV(/Report/ReportName)"/><xsl:text> - </xsl:text><xsl:value-of select="script:msFormatDate(/Report/ReportDate)"/>
		<xsl:text>&#xD;</xsl:text>
		<xsl:text>&#xD;</xsl:text>
		<!--Header Details-->
		<xsl:if test="/Report/HeaderDetails">
			<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
				<xsl:value-of select="script:msFormatForCSV(Description)"/><xsl:text>,</xsl:text><xsl:value-of select="script:msFormatForCSV(Value)"/><xsl:text>&#xD;</xsl:text>
			</xsl:for-each>
		</xsl:if>
		<!--Line Details-->
		<xsl:if test="/Report/LineDetails/LineDetail">	
			
			<xsl:variable name="xmlSortLines">
				<Report>
					<LineDetails>					
						<xsl:copy-of select="/Report/LineDetails/Columns"/>					
					
						<xsl:for-each select="/Report/LineDetails/LineDetail">
							<xsl:sort select="Columns/Column[@ID = 6]" data-type="text"/>
							<xsl:sort select="Columns/Column[@ID = 8]" data-type="text"/>
						
							<xsl:copy-of select="."/>
						
						</xsl:for-each>				
					
					</LineDetails>				
				</Report>		
			</xsl:variable>		
			
			
			<xsl:for-each select="msxsl:node-set($xmlSortLines)/Report/LineDetails/LineDetail">				
             
					<xsl:if test="script:mbNeedHeader(../Columns/Column[@GroupBy = '1' or @GroupBy = 'true'])">
						<xsl:text>&#xD;</xsl:text>				
						<xsl:for-each select="../Columns/Column">
							<xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
						</xsl:for-each>
					</xsl:if>
					<xsl:text>&#xD;</xsl:text>								
					<xsl:for-each select="Columns/Column">
						<xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
					</xsl:for-each>
					
					<xsl:variable name="GRNRef" select="Columns/Column[@ID = 6]"/>
				
					<xsl:if test="(following-sibling::LineDetail[1]/Columns/Column[@ID = 6] != $GRNRef) or (position() = last())">
					
						<xsl:text>&#xD;</xsl:text>								
						
						<xsl:variable name="summaryLine">						
							<LineDetail>
								<Columns>
									<Column ID="1"></Column>
									<Column ID="2"></Column>
									<Column ID="3"></Column>
									<Column ID="4"></Column>
									<Column ID="5"></Column>
									<Column ID="6">
										<xsl:value-of select="$GRNRef"/>
										<xsl:text> Total</xsl:text>
									</Column>
									<Column ID="7"></Column>
									<Column ID="8"></Column>									
									<Column ID="9">
										<xsl:value-of select="sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 9])"/>
									</Column>
									<Column ID="10">
										<xsl:value-of select="sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 10])"/>
									</Column>
									<Column ID="11">
										<xsl:value-of select="sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 11])"/>
									</Column>
								</Columns>
							</LineDetail>				
						</xsl:variable>							
						
						<xsl:for-each select="msxsl:node-set($summaryLine)/LineDetail/Columns/Column">
							<xsl:value-of select="script:msFormatForCSV(.)"/><xsl:text>,</xsl:text>
						</xsl:for-each>				
					
					</xsl:if>						
				
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
