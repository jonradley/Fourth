<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order translation following CSV 
flat file mapping for Moto.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Sheppard	| 16/07/2007	| Created Module
*******************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
	
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<Batch>
				<BatchDocuments>
					<BatchDocument DocumentType="2">
						<xsl:apply-templates select="@*|node()"/>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</BatchRoot>
		
	</xsl:template>
		
	<!-- translate the date from [dd/mm/yyyy] format to [yyyy-mm-dd] -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</PurchaseOrderDate>
	</xsl:template>
	
	<!-- translate the date from [dd/mm/yyyy] format to [yyyy-mm-dd] -->
	<xsl:template match="DeliveryDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,1,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,4,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,7,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<DeliveryDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</DeliveryDate>
	</xsl:template>
	
	<xsl:template match="PackSize">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
		<UnitValueExclVAT>0.00</UnitValueExclVAT>
		<LineValueExclVAT>0.00</LineValueExclVAT>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
