<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
==========================================================================================
 01/06/2018	| W Nassor 		| FB12882 -  The Seafood Restaurant (Padstow Ltd) - (MemberID: 38705) Stock Transfer Out Export
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://abs-ltd.com">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#xd;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<xsl:template match="/">
		<!--A-->
		<xsl:text>AccountCostCentre</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--B-->
		<xsl:text>AccountDepartment</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--C-->
		<xsl:text>AccountNumber</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--D-->
		<xsl:text>TransactionType</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--E-->
		<xsl:text>TransactionDate</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--F-->
		<xsl:text>GoodsAmount</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--G-->
		<xsl:text>Reference</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--H-->
		<xsl:text>Narrative</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--I-->
		<xsl:text>UniqueReferenceNumber</xsl:text>
		

		<xsl:value-of select="$RecordSeperator"/>
				<xsl:apply-templates select="SiteTransfersExport/SiteTransfers/SiteTransfer"/>

	</xsl:template>
	
	<xsl:template match="SiteTransfer">
		<!--A-->
		<!--COST-CENTRE-->
		<xsl:value-of select="SiteTransferLocation/UnitSiteNominal"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--B-->
		<!-- DEPARTMENT NUMBER -->
		<xsl:value-of select="$FieldSeperator"/>
		<!--C-->
		<!--ACCOUNT-NUMBER-->
		<xsl:value-of select="CategoryNominal"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--D-->
		<!--TRANSACTION-TYPE-->
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!--E-->
		<!-- TRANSACTION-DATE -->
		<xsl:value-of select="TransactionDate"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!--F-->
		<!-- GOODS-AMOUNT -->
		<xsl:choose>
			<xsl:when test="TransactionType = 'Credit'">
				<xsl:value-of select="format-number(LineValueExclVAT,'-00.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(LineValueExclVAT,'00.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$FieldSeperator"/>
		<!--G-->
		<!-- REFERENCE-NUMBER -->
		<xsl:value-of select="$FieldSeperator"/>
		<!--H-->
		<!-- TEXT -->
		<xsl:text>Fnb tfrs - </xsl:text>
		<xsl:value-of select="substring-after(SiteTransferLocation/UnitSiteName,'/')"/>
		<!--I-->
		<!-- UNIQUE REFERENCE NUMBER - ALEWAYS BLANK -->

	<xsl:value-of select="$RecordSeperator"/>

	</xsl:template>
</xsl:stylesheet>
