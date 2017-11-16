<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps iXML statements into the Elior (NXG system) csv statement format.
' 
' © Alternative Business Solutions Ltd., 2004.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  09/09/2004 | Lee Boyton   | Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			 |                        |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl fo user msxsl">
	<xsl:output method="text"/>
	<xsl:template match="/Statement">
		<xsl:variable name="SupplierPLCode" select="user:msQuoteString(TradeSimpleHeader/RecipientsCodeForSender)"/>
		<xsl:for-each select="StatementDetail/StatementLine">
			<xsl:value-of select="$SupplierPLCode"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="user:msQuoteString(DocumentReference)"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="user:msFormatDate(DocumentDate)"/>
			<xsl:text>,</xsl:text>
			<!-- a document type indicator determines the sign of the total. Invoice positive, Credit negative -->
			<xsl:choose>
				<xsl:when test="DocumentType = 'Invoice'">
					<xsl:value-of select="format-number(LineValueExclVAT, '#.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * LineValueExclVAT, '#.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<!-- a ValidationResult of 1 means passed, 2 failed, if the attribute does not exist then treat this as a failure -->
			<xsl:choose>
				<xsl:when test="DocumentReference/@ValidationResult = '1'">
					<xsl:choose>
						<xsl:when test="not(Narrative) or Narrative = ''">
							<xsl:text>Exists</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="Narrative">
								<xsl:text>Exists: </xsl:text><xsl:value-of select="Narrative"/>
							</xsl:variable>
							<xsl:value-of select="user:msQuoteString($Narrative)"/>
						</xsl:otherwise>						
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Not Found</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[
		function msFormatDate(nodeDate)
		{
			var sDate,dd,mm,yyyy;

			if(nodeDate.length > 0)
			{
				sDate=nodeDate(0).text;

				if(sDate != "")
				{			
					yyyy=sDate.substring(0,4);
					mm=sDate.substring(5,7); 
					dd=sDate.substring(8,10);
			
					return(dd + '/' + mm + '/' + yyyy);
				}
				else
				{
					return ""; 
				} 
			}
			else 
			{
				return ""; 
			}
		}
		/* if a string contains comma characters then it is returned surrounded by double quotes */
		function msQuoteString(nodeString)
		{
			var s;
			
			if(nodeString.length > 0)
			{
				s = nodeString(0).text;
				
				if(s != "")
				{
					if(s.indexOf(',') != -1)
					{
						// replace any embedded double quotes with 2 double quotes to escape them
						return '"' + s.replace(/"/g,'""') + '"';
					}
					else
					{
						return s;
					}
				}
				else
				{
					return "";
				}
			}
			else
			{
				return "";
			}			
		}
	]]></msxsl:script>
</xsl:stylesheet>
