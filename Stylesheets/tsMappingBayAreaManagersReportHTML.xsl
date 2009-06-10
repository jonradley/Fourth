<!--
******************************************************************************************
 Overview

 This XSL file is used to transform XML for a Bay Area Managers Report into an HTML page

 © Alternative Business Solutions Ltd., 2004.
******************************************************************************************
 Module History
******************************************************************************************
 Date		| Name			| Description of modification
******************************************************************************************
 10/06/2009 | Rave Tech		| Created module. 2922
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
			xmlns:script="http://mycompany.com/mynamespace"
		       xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		      exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="html"/>
	<xsl:template match="/">
		<html>
			<style>
				BODY
				{
				    FONT-SIZE: 8pt;
				    COLOR: #0d0d67;
				    FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
				    BACKGROUND-COLOR: #ffffff;
				    style: "text-decoration: none"
				}
				TR.listrow0
				{
				    BACKGROUND-COLOR: #dde6e4
				}
				TR.listrow1
				{
				    BACKGROUND-COLOR: #ffffff
				}
				TH
				{
				    FONT-WEIGHT: bold;
				    FONT-SIZE: 10pt;
				    COLOR: #ffffff;
				    FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;
				    BACKGROUND-COLOR: #024a37
				}
				THEAD
				{
				}
				THEAD TH
				{
				    COLOR: #ffffff;
				    BACKGROUND-COLOR: #0d0d67
				}
				TD
				{
				    FONT-SIZE: 8pt
				}
				TABLE.DocumentSurround
				{
				    BACKGROUND-COLOR: #dde6e4
				}
				TABLE.DocumentSurround TH
				{
				    FONT-SIZE: larger
				}
				TABLE.DocumentInner
				{
				    WIDTH: 100%;
				    BACKGROUND-COLOR: white
				}
				TABLE.DocumentInner TH
				{
				    FONT-SIZE: smaller
				}
				TABLE.DocumentLines
				{
				    BACKGROUND-COLOR: white
				}
				TABLE.DocumentLines TH
				{
				    FONT-SIZE: smaller
				}
			</style>
			<body>
				<table class="DocumentSurround" width="100%">	
					<!--Main Header-->
					<tr>
						<td align="center" colspan="2">
							<table width="100%">
								<thead>
									<tr>
										<th align="center"><xsl:value-of select="/Report/ReportName"/> - <xsl:value-of select="script:msFormatDate(/Report/ReportDate)"/></th>		
									</tr>
								</thead>
							</table>
						</td>
					</tr>
					<!--Header Details-->
					<xsl:if test="/Report/HeaderDetails">
						<tr>
							<td width="50%">
								<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
									<thead>
										<tr>
											<th colspan="2">Header Details</th>
										</tr>
									</thead>
									<xsl:for-each select="/Report/HeaderDetails/HeaderDetail">
										<tr>
											<th width="50%"><xsl:value-of select="Description"/></th>
											<td><xsl:value-of select="Value"/></td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
							<td valign="top" width="50%"><br/></td>
						</tr>
						<tr>
							<td colspan="2"><br/></td>
						</tr>
					</xsl:if>
					<xsl:if test="/Report/LineDetails/LineDetail">
						<tr>
							<td colspan="2">
								<!--Line Details-->
								<table class="DocumentLines" cellpadding="1" cellspacing="1" width="100%">
									<thead>
										<tr>
											<th>
												<xsl:attribute name="colspan">2</xsl:attribute>Line Details
											</th>
										</tr>
									</thead>
									<xsl:for-each select="/Report/LineDetails/LineDetail">
											<xsl:attribute name="class">
												<xsl:value-of select="script:msGetRowClass()"/>
											</xsl:attribute>
											<xsl:for-each select="Columns/Column[(@GroupBy != '1' and @GroupBy != 'true') or not(@GroupBy)]">
												<xsl:variable name="ColumnID"><xsl:value-of select="@ID"/></xsl:variable>
												<xsl:variable name="ColumnName"><xsl:value-of select="/Report/LineDetails/Columns/Column[@ID =  $ColumnID]"/></xsl:variable>

												<xsl:variable name="ColorName">
													<xsl:choose>
														<xsl:when test="$ColumnName = 'Invoices Requiring Manual Authorisation' and . > 0">red</xsl:when>
														<xsl:when test="$ColumnName = 'Invoices Requiring Manual Authorisation' and . = 0">green</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Correctly ' and . > 0">green</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Correctly ' and . = 0">white</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Auto-Recie' and . > 0">red</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Auto-Recie' and . = 0">white</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Orders Del' and . > 0">red</xsl:when>
														<xsl:when test="script:msLeft($ColumnName) = 'Orders Del' and . = 0">white</xsl:when>
														<xsl:when test="$ColumnName = 'Orders Not Yet Delivered'">white</xsl:when>
														<xsl:otherwise>yellow</xsl:otherwise> 
													</xsl:choose> 
												</xsl:variable>

												<tr>
													<xsl:attribute name="bgcolor"><xsl:value-of select="$ColorName"/></xsl:attribute>
													<td align="left" width="30%">
														<xsl:value-of select="/Report/LineDetails/Columns/Column[@ID =  $ColumnID]"/>
													</td>
													<td align="left">
														<xsl:value-of select="."/>
													</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td colspan="2" style="color=white">.</td>
											</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
					</xsl:if>
					<!--Trailer Details-->
					<xsl:if test="/Report/TrailerDetails">
						<tr>
							<td valign="top" width="50%"><br/></td>
							<td width="50%">
								<table class="DocumentInner" style="height:100%" cellpadding="1" cellspacing="1">
									<thead>
										<tr>
											<th colspan="2">Trailer Details</th>
										</tr>
									</thead>
									<xsl:for-each select="/Report/TrailerDetails/TrailerDetail">
										<tr>
											<th width="50%"><xsl:value-of select="Description"/></th>
											<td align="right"><xsl:value-of select="Value"/></td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
					</xsl:if>
				</table>	
			</body>
		</html>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
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
		' Routine       	 : msLeft
		' Description 	 : Returns Left(str,10)
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : Rave Tech, 10/06/2009.
		' Alterations   	 : 
		'========================================================================================*/
		function msLeft(vsString)
		{
			if(vsString.length > 0)
			{
				vsString= vsString(0).text;
				return vsString.substr(0,10);
			}
			else
			{
				return '';
			}
		}
		
		/*=========================================================================================
		' Routine       	 : msGetRowClass
		' Description 	 : Gets listrow 0,1,0 etc.
		' Inputs          	 : None
		' Outputs       	 : None
		' Returns       	 : Class of row
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		var msPreviousRowClass = 'listrow0';
		function msGetRowClass()
		{
			if(msPreviousRowClass == 'listrow1')
			{
				msPreviousRowClass = 'listrow0';
			}
			else
			{
				msPreviousRowClass = 'listrow1';
			}
			return msPreviousRowClass;
		}

	]]></msxsl:script>
</xsl:stylesheet>