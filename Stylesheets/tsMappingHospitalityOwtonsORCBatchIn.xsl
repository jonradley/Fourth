<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Purchase Order Confirmation mapper (OWTONS)
'  Hospitality post flat file mapping to iXML format.
'
******************************************************************************************
 Module History
******************************************************************************************
 Date         | Name       		| Description of modification
******************************************************************************************
 08/04/2013	| Harold Robson		| FB5985 Created module 
******************************************************************************************
				| 							|
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="tsMappingHospitalityBenEKeithIncludes.xsl"/>
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument>
						<xsl:apply-templates/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
	</xsl:template>
	
	<!-- Correct line values for rejected lines, the value should be 0 -->
	<xsl:template match="LineValueExclVAT">
			<LineValueExclVAT>
				<xsl:choose>
					<xsl:when test="../ConfirmedQuantity = 0">0</xsl:when>
					<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
				</xsl:choose>
			</LineValueExclVAT>
	</xsl:template>
	
	<!-- format dates for T|S -->
	<xsl:template match="InvoiceDate | PurchaseOrderConfirmationDate | PurchaseOrderDate | DeliveryDate">
		<xsl:element name="{name()}">
			<xsl:value-of select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2))"/>
		</xsl:element>
	</xsl:template>	
	
	<!-- calculate total number of lines as OWTONS' total is for confirmed lines only -->
	<xsl:template match="NumberOfLines">
		<NumberOfLines>
			<xsl:value-of select="count(../../PurchaseOrderConfirmationDetail/PurchaseOrderConfirmationLine)"/>
		</NumberOfLines>
	</xsl:template>
	
	<!-- convert test flag -->
	<xsl:template match="TestFlag">
		<xsl:if test=". != ''">
			<TestFlag>
				<xsl:choose>
					<xsl:when test="TradeSimpleHeader/TestFlag = 'false'">false</xsl:when>
					<xsl:when test="TradeSimpleHeader/TestFlag = 'False'">false</xsl:when>
					<xsl:when test="TradeSimpleHeader/TestFlag = 'FALSE'">false</xsl:when>
					<xsl:when test="TradeSimpleHeader/TestFlag = '0'">false</xsl:when>
					<xsl:when test="TradeSimpleHeader/TestFlag = 'N'">false</xsl:when>
					<xsl:when test="TradeSimpleHeader/TestFlag = 'n'">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</TestFlag>
		</xsl:if>
	</xsl:template>
	
	<!-- convert line status -->
	<xsl:template match="PurchaseOrderConfirmationLine">
		<PurchaseOrderConfirmationLine>
			<!-- translate the inbound line status -->
			<xsl:if test="@LineStatus != ''">
				<xsl:attribute name="LineStatus">
					<xsl:choose>
						<xsl:when test="@LineStatus = 'A'">
							<xsl:text>Accepted</xsl:text>
						</xsl:when>
						<xsl:when test="@LineStatus = 'C'">
							<xsl:text>Changed</xsl:text>
						</xsl:when>
						<xsl:when test="@LineStatus = 'R'">
							<xsl:text>Rejected</xsl:text>
						</xsl:when>
						<xsl:when test="@LineStatus = 'S'">
							<xsl:text>Added</xsl:text>
						</xsl:when>
						<!-- if the line status is not recognised then pass through the inbound value
							 so the document fails at the xsd validation stage -->
						<xsl:otherwise>
							<xsl:value-of select="@LineStatus"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</PurchaseOrderConfirmationLine>
	</xsl:template>
	
	<!-- copy template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
