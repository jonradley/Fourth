<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps iXML notifications into Holdsworh notification format.
' 
' © Alternative Business Solutions Ltd.,2004
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name            | Description of modification
'******************************************************************************************
'  12/07/2004 | A Sheppard   | Created 
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'			 |                        |
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:fo="http://www.w3.org/1999/XSL/Format" 
				xmlns:script="http://mycompany.com/mynamespace" 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	<xsl:template match="/">Portal Notification

Date Sent: <xsl:value-of select="/Notification/NotificationHead/NotificationDate"/>
Time Sent: <xsl:value-of select="/Notification/NotificationHead/NotificationTime"/>

Subject: 
<xsl:value-of select="//Notification/Narrative[@Sequence='1']"/>

Message: 
<xsl:value-of select="//Notification/Narrative[@Sequence='2']"/>

Data:
<xsl:value-of select="//Notification/Narrative[@Sequence='3']"/>

Technical information:
<xsl:value-of select="//Notification/Narrative[@Sequence='4']"/>

	</xsl:template>
</xsl:stylesheet>
