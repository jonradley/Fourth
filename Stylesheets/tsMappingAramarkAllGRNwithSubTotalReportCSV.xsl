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
 24/05/2010 | Sandeep Sehgal| 3536| Internationalisation for Aramark Spain
 ******************************************************************************************
  21/06/2010 | Sandeep Sehgal | FB3536 For Spanish Reports use semi-colon as record separator
******************************************************************************************
  08/07/2010 | Steve Hewitt  | FB3536 The path to the translations files cannot access a web box
******************************************************************************************
  08/07/2010 | Sandeep Sehgal  | FB3739 CommaCharacter param changed to a variable
******************************************************************************************
  16/07/2010 | Sandeep Sehgal  | FB3758 Decimal separator for Subtotals now formated as per locale
******************************************************************************************
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text" encoding="utf-8"/>	 
	<xsl:include href="Internationalisation.xsl"/>
	<xsl:param name="RootFolderPath" select="'./Translations'"/>	
	<xsl:variable name="TranslationFile">
		Report<xsl:value-of select = "/Report/@ReportID"></xsl:value-of>.xml
	</xsl:variable>	
	<xsl:param name="LocaleID">
		<xsl:value-of select = "/Report/@LocaleID"></xsl:value-of>
	</xsl:param>
	<xsl:variable name="CommaCharacter"><xsl:if test="$LocaleID=1034">;</xsl:if><xsl:if test="$LocaleID=2057">,</xsl:if></xsl:variable >
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$LocaleID>0">
		          	<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(Report/ReportName)"/></xsl:call-template><xsl:text> - </xsl:text><xsl:value-of select="script:gsFormatDateByLocale(/Report/ReportDate,number($LocaleID))"/>
				<xsl:text>&#xD;</xsl:text>
				<xsl:text>&#xD;</xsl:text>
				<!--Header Details-->
				<xsl:if test="/Report/HeaderDetails">
					<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
						<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Description"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Value"/></xsl:call-template><xsl:text>&#xD;</xsl:text>
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
									<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
								</xsl:for-each>
							</xsl:if>
							<xsl:text>&#xD;</xsl:text>
							<xsl:for-each select="Columns/Column">
								<xsl:choose>
									<xsl:when test="@DataType = 6 or @DataType=14 or @DataType=5 or @DataType=131">
										<xsl:value-of select="script:gsFormatNumberByLocale(.,2,number($LocaleID),0)"/><xsl:value-of select="$CommaCharacter"></xsl:value-of>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="script:msFormatForCSV(.)"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
									</xsl:otherwise>
								</xsl:choose>
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
												<xsl:value-of select="script:gsFormatNumberByLocale(sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 9]),2,number($LocaleID),0)"/>
											</Column>
											<Column ID="10">
												<xsl:value-of select="script:gsFormatNumberByLocale(sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 10]),2,number($LocaleID),0)"/>
											</Column>
											<Column ID="11">
												<xsl:value-of select="script:gsFormatNumberByLocale(sum(/Report/LineDetails/LineDetail[Columns/Column[@ID = 6] = $GRNRef]/Columns/Column[@ID = 11]),2,number($LocaleID),0)"/>
											</Column>
										</Columns>
									</LineDetail>				
								</xsl:variable>
								
								<xsl:for-each select="msxsl:node-set($summaryLine)/LineDetail/Columns/Column">
										<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="."/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of>
								</xsl:for-each>				
							
							</xsl:if>						
						
					</xsl:for-each>
				</xsl:if>
				<xsl:text>&#xD;</xsl:text>
				<xsl:text>&#xD;</xsl:text>
				<!--Trailer Details-->
				<xsl:if test="/Report/TrailerDetails">
					<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
					<xsl:call-template name="SelectString"><xsl:with-param name="InputString" select="Description"/></xsl:call-template><xsl:value-of select="$CommaCharacter"></xsl:value-of><xsl:value-of select="script:gsFormatNumberByLocale(Value,2,number($LocaleID),0)"/><xsl:text>&#xD;</xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
		          	<xsl:value-of select="script:msFormatForCSV(/Report/ReportName)"/><xsl:text> - </xsl:text><xsl:value-of select="script:gsFormatDateByLocale(/Report/ReportDate,2057)"/>
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
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="SelectString">
		<xsl:param name="InputString"/>
		<xsl:choose>
			<xsl:when test="$InputString='Aramark All Goods Received With Subtotal Report'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="1"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Start Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="2"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='End Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="3"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Sender Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="4"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Supplier'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="5"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='All'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="6"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Component Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="7"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Supplier Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="8"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='GRN Date'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="9"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='PO Number'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="10"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='GRN Ref'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="11"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='G/L Code'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="12"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Component Name'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="13"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='GRN Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="14"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Stock Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="15"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Non Stock Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="16"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Invoiced'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="17"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Total GRN Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="18"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Total Stock Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="19"/></xsl:call-template></xsl:when>
			<xsl:when test="$InputString='Total Non Stock Amount'"><xsl:call-template name="TranslateString"><xsl:with-param name="ID" select="20"/></xsl:call-template></xsl:when>
			<xsl:otherwise><xsl:value-of select="$InputString" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
