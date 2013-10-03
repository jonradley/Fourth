<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge	| 2010-10-14		| 3951 Created Module
**********************************************************************
R Cambridge	| 2011-03-16		| 4306 Added litres into UoM translation lists
**********************************************************************
				|						|
**********************************************************************
				|						|
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	
	
	<xsl:variable name="TOPLEVELSYSID_SEPARATOR" select="'/'"/>
	<xsl:variable name="SITE_CODE_SEPARATOR" select="' '"/>
	
	
	
	<xsl:template name="getTopLevelSysID">
		<xsl:param name="tsUnitCode"/>
		
		<xsl:choose>
		
			<xsl:when test="contains($tsUnitCode, $TOPLEVELSYSID_SEPARATOR)">
				<xsl:value-of select="substring-before($tsUnitCode, $TOPLEVELSYSID_SEPARATOR)"/>
			</xsl:when>
			
			<xsl:otherwise/>
			
		</xsl:choose>
		
	</xsl:template>
	
	
	
	<xsl:template name="getSiteAndSecondaryID">
		<xsl:param name="tsUnitCode"/>
		
		<xsl:choose>
				
			<xsl:when test="contains($tsUnitCode, $TOPLEVELSYSID_SEPARATOR)">
				<xsl:value-of select="substring-after($tsUnitCode, $TOPLEVELSYSID_SEPARATOR)"/>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$tsUnitCode"/>
			</xsl:otherwise>
			
		</xsl:choose>
	
	</xsl:template>
	
	
	
	<xsl:template name="getSiteID">
		<xsl:param name="tsUnitCode"/>
		
		<xsl:variable name="siteID_noSysID">
			
			<xsl:call-template name="getSiteAndSecondaryID">
				<xsl:with-param name="tsUnitCode" select="$tsUnitCode"/>
			</xsl:call-template>
		
		</xsl:variable>
		
		<xsl:value-of select="substring-before(concat($siteID_noSysID,$SITE_CODE_SEPARATOR),$SITE_CODE_SEPARATOR)"/>
		
	</xsl:template>
	
	
	<xsl:template name="getSecondarySiteID">
		<xsl:param name="tsUnitCode"/>
		
		<xsl:value-of select="substring-after($tsUnitCode, $SITE_CODE_SEPARATOR)"/>
		
	</xsl:template>
	
	
	<xsl:template name="getTSSiteID">
		<xsl:param name="bavelUnitCode"/>
		<xsl:param name="bavelSecondaryUnitCode"/>
		<xsl:param name="bavelTopLevelSysID"/>
		
		
		<xsl:if test="$bavelTopLevelSysID != ''">
			<xsl:value-of select="$bavelTopLevelSysID"/>
			<xsl:value-of select="$TOPLEVELSYSID_SEPARATOR"/>
		</xsl:if>
		
		<xsl:value-of select="$bavelUnitCode"/>
		
		<xsl:if test="$bavelSecondaryUnitCode != ''">
			<xsl:value-of select="$SITE_CODE_SEPARATOR"/>		
			<xsl:value-of select="$bavelSecondaryUnitCode"/>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="getTSSiteID_noSysID">
		<xsl:param name="bavelUnitCode"/>
		<xsl:param name="bavelSecondaryUnitCode"/>
		
		<xsl:value-of select="$bavelUnitCode"/>
		
		<xsl:if test="$bavelSecondaryUnitCode != ''">
			<xsl:value-of select="$SITE_CODE_SEPARATOR"/>		
			<xsl:value-of select="$bavelSecondaryUnitCode"/>
		</xsl:if>
		
	</xsl:template>


	<xsl:template name="transUoM_toBaVel">
		<xsl:param name="tsUoM"/>
		<xsl:choose>
			<xsl:when test="$tsUoM = 'EA'">Unidades</xsl:when>
			<xsl:when test="$tsUoM = 'CS'">Cajas</xsl:when>
			<xsl:when test="$tsUoM = 'KGM'">Kgs</xsl:when>
			<xsl:when test="$tsUoM = 'LTR'">Lts</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template name="transUoM_fromBaVel">
		<xsl:param name="voxelUoM"/>	
		<xsl:choose>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'unidades'">EA</xsl:when>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'cajas'">CS</xsl:when>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'kgs'">KGM</xsl:when>
			<xsl:when test="translate($voxelUoM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'lts'">LTR</xsl:when>
		</xsl:choose>	
	</xsl:template>
	
	
	
</xsl:stylesheet>
