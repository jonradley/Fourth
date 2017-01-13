<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- xsl:import declaration would go here in variation stylesheets -->
	
	<xsl:output method="text"/>
	
	<xsl:variable name="FormatDescription" select="'DEFAULT format'"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	
	<xsl:template match="/">
	
		<xsl:value-of select="$FormatDescription"/>
		<xsl:value-of select="$RecordSeperator"/>
		
		<xsl:for-each select="/Batch/BatchDocuments/BatchDocument/*">		
		
			<xsl:call-template name="writeChildren">
				<xsl:with-param name="childNodes" select="*/*[count(descendant::*) = 0]"/>
			</xsl:call-template>
			
			<xsl:value-of select="$RecordSeperator"/>
		
			<xsl:for-each select="*[contains(name(.), 'Detail')]/*">
			
				<xsl:call-template name="writeChildren">
					<xsl:with-param name="childNodes" select="*[count(descendant::*) = 0]"/>
				</xsl:call-template>
			
				<xsl:value-of select="$RecordSeperator"/>
			
			</xsl:for-each>
		
		</xsl:for-each>
	
	</xsl:template>
	
	<xsl:template name="writeChildren">
		<xsl:param name="childNodes"/>
		
		<xsl:for-each select="$childNodes">
			
			<xsl:call-template name="writeField">
				<xsl:with-param name="childNode" select="."/>
			</xsl:call-template>
		
			<xsl:if test="position() != last()">
			
				<xsl:value-of select="$FieldSeperator"/>
			
			</xsl:if>

		</xsl:for-each>
		
	</xsl:template> 
	
	<xsl:template name="writeField">
		<xsl:param name="childNode"/>
		
		<xsl:value-of select="$childNode"/>
		
	</xsl:template> 
	
	
</xsl:stylesheet>
