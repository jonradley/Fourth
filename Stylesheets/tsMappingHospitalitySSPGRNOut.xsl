<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      		| Name 					| Description of modification
==========================================================================================
27/05/2009	| R Cambridge			| Created module. Copies the buyers code for shipto in the suppliers code field
==========================================================================================
           		|                 				|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode">
		<xsl:copy>
			<xsl:value-of select="../BuyersCode"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>