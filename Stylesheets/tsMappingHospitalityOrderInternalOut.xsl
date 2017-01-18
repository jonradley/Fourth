<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XML Spy v4.4 U (http://www.xmlspy.com) by Sandeep Sehgal (ABS Ltd) -->
<!--
'******************************************************************************************
' Overview
' Mapper for outbound Goods Received Note. Strips out TS specific elements from Internal XML.
'
' 
' 
'******************************************************************************************
' Module History
'******************************************************************************************
' Date       | Name    		| Description of modification
'******************************************************************************************
' 18/11/2009 | S Sehgal 		| Created
'******************************************************************************************
' 26/11/2009 | R Cambridge   | 3250 Added encoding attribute
'******************************************************************************************
' 				 |               |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output encoding="utf-8"/>
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TradeSimpleHeader"/>
	<xsl:template match="HeaderExtraData"/>
	<xsl:template match="LineExtraData"/>
	<xsl:template match="TrailerExtraData"/>
</xsl:stylesheet>
