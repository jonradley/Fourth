<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         	| Date       	| Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
K Oshaughnessy| 29/01/2013	| Created Module FB 5957
*******************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>

	<xsl:template match="/">
		<BatchRoot>
			<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>	
	</xsl:template>

	<!--identity transformation -->
	<xsl:template match="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
	</xsl:template>
	
	<xsl:template match="PurchaseOrderDate | DeliveryDate">
		<xsl:call-template name="dateToUTCFormat">
			<xsl:with-param name="input" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="dateToUTCFormat">
		<xsl:param name="input"/>
		<xsl:copy>
			<xsl:value-of select="concat(20,substring($input,1,2),'-',substring($input,3,2),'-',substring($input,5,2))"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
