<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation mapper
'  Hospitality post flat file mapping to iXML format.
'
' © Fourth Ltd., 2013.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 04/07/2014  | Jose Miguel  | FB 7566: Created
'******************************************************************************************
' 09/10/2014  | Jose Miguel  | FB 10045 Fix Senders Branch Reference (do not limit to 2 chars any longer)
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="PurchaseOrderConfirmation">
		<PurchaseOrderConfirmation>
			<xsl:apply-templates select="*"/>
			<PurchaseOrderConfirmationTrailer>
				<NumberOfLines>
					<xsl:value-of select="count(PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine)"/>
				</NumberOfLines>
			</PurchaseOrderConfirmationTrailer>
		</PurchaseOrderConfirmation>
	</xsl:template>
	<!-- Formatting dates to T|S format -->
	<xsl:template match="PurchaseOrderDate | DeliveryDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
		</xsl:element>
	</xsl:template>
	<!-- Adjust the ConfirmedQuantity: if the flag CatchWeightFlag is set then the order must use the AverageWeight -->
	<xsl:template match="ConfirmedQuantity/@UnitOfMeasure">
			<!-- Translate the UoM. It is 'each' when BreakLevelInd (hidden in LineNumber) is 1... or if it is 0, when the UoM is 'EA'
				 This way BreakLevelInd has more precedence.-->
			<xsl:choose>
				<xsl:when test="(0 &lt; number(@LineNumber)) or @UnitOfMeasure = 'EA'">
					<xsl:value-of select="EA"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="CS"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- check the CatchWeightFlag (BackOrderQuantity) if it is 1 then the AverageWeight (PackSize) will be used instead -->
	</xsl:template>
	<xsl:template match="UnitValueExclVAT">
		<UnitValueExclVAT>
			<xsl:choose>
				<!-- check the CatchWeightFlag (BackOrderQuantity) if it is 1 then the AverageWeight (PackSize) will be used instead -->
				<xsl:when test="../BackOrderQuantity = '1'">
					<xsl:value-of select="number(.) * number(../PackSize)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</UnitValueExclVAT>
	</xsl:template>
	<!-- Adding the break level to the supliers product code -->
	<xsl:template match="SuppliersProductCode">
		<SuppliersProductCode>
			<xsl:value-of select="."/>
			<!-- if the BreakLevel indicator is present and non zero.-->
			<xsl:if test="number(../../Measure/UnitsInPack)">
				<xsl:text>~</xsl:text>
				<xsl:value-of select="../../Measure/UnitsInPack"/>
			</xsl:if>
		</SuppliersProductCode>
	</xsl:template>
	<!-- These fields where used for other purposes so they get removed to avoid undesired effects -->
	<xsl:template match="BackOrderQuantity | LineNumber | PackSize"/>
</xsl:stylesheet>
