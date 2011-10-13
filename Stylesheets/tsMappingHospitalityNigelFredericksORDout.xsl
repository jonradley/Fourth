<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Overview
'
' Maps Nigel Fredericks outbound purchase orders 
'
'******************************************************************************************
' Module History
'******************************************************************************************
' Date             | Name              | Description of modification
'******************************************************************************************
' 10/05/2011  | M Dimant | Created
'******************************************************************************************

'******************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">	
		<PurchaseOrders>	
				<xsl:apply-templates/>					
		</PurchaseOrders>		
	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>

			
	<xsl:template match="TradeSimpleHeader"/>
		

	
</xsl:stylesheet>
