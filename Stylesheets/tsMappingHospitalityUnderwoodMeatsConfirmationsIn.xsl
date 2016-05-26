<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation mapper (BUNZL)
'  Hospitality post flat file mapping to iXML format.
'
' © ABS Ltd., 2005.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 26/06/2009| KO | Created
'******************************************************************************************
' 07/01/2013| M Emanuel| FB 5885 Created from tsMappingHospitality_defaultConfirmationCSV.xsl
'******************************************************************************************
-->
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:vbscript="http://abs-Ltd.com">

	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>	
	</xsl:template>	
	
	<xsl:template match="BatchDocument">
		<BatchDocument DocumentTypeNo="3">
			<xsl:apply-templates select="@*|node()"/>
		</BatchDocument>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- DATE CONVERSION dd/mm/yyyy to xsd:date -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:element name="PurchaseOrderDate">
			<xsl:call-template name="DateConversion">
				<xsl:with-param name="FormatDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="DeliveryDate">
		<xsl:element name="DeliveryDate">
			<xsl:call-template name="DateConversion">
				<xsl:with-param name="FormatDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<!-- Test Flag Conversion -->
		<xsl:template match="TestFlag">
			<xsl:call-template name="Flag">
				<xsl:with-param name="FlagConversion" select="."/>
			</xsl:call-template>
		</xsl:template>
	

		
	<!-- Date Conversion -->
	<xsl:template name="DateConversion">
		<xsl:param name="FormatDate"/>
			<xsl:value-of select="concat('20',substring($FormatDate, 3, 2), '-', substring($FormatDate, 5, 2), '-', substring($FormatDate, 7, 2))"/>
	</xsl:template>
	
	<!-- Test Flag Conversion -->
	<xsl:template name="Flag">
		<xsl:param name="FlagConversion"/>
			<xsl:copy>
				<xsl:choose>
					<xsl:when test="$FlagConversion='Y'">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:when test="$FlagConversion='1'">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:when test="$FlagConversion='N'">
						<xsl:text>false</xsl:text>
					</xsl:when>
					<xsl:when test="$FlagConversion='0'">
						<xsl:text>false</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:copy>	
		</xsl:template>
		
		<!-- Line Status, UMC always send only accept lines -->
	<xsl:template match="@LineStatus">
		<xsl:attribute name="LineStatus">
			<xsl:choose>
				<xsl:when test="'A'">
					<xsl:text>Accepted</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>	




