<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="tsMappingHospitalityInvoiceAccrualExportOut.xsl"/>
	
	<xsl:output method="text"/>
	
	<xsl:variable name="FormatDescription" select="'STANDARD #1 format'"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="'|'"/>
		
	
</xsl:stylesheet>
