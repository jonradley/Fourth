<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2008.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 08/12/2008	| R Cambridge			| 2601 Created module (based on tsMappingHospitalityNullMap.xsl)
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>
	
	<xsl:template match="/ | @* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="SendersBranchReference"/>
	
</xsl:stylesheet>