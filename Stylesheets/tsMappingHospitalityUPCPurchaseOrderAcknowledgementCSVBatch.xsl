<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Purchase Order Acknowledgement translation following CSV flat file mapping

**********************************************************************
Name         | Date       | Change
*********************************************************************
Lee Boyton   | 22/09/2006 | Created
**********************************************************************
             |            |
*******************************************************************-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<xsl:apply-templates select="@*|node()"/>
		</BatchRoot>
	</xsl:template>
	
	<!-- add the DocumentTypeNo attribute to each BatchDocument element -->
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">
				<xsl:text>84</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- translate the date from [d]d/[m]m/[yy]yy format to yyyy-mm-dd -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring-before(.,'/')"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring-before(substring-after(.,'/'),'/')"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring-after(substring-after(.,'/'),'/')"/>
		</xsl:variable>
		<!-- translate a 2 digit year to a 4 digit year -->
		<xsl:variable name="fullYearPart">
			<xsl:choose>
				<xsl:when test="string-length($yearPart) = 2">
					<xsl:text>20</xsl:text>
					<xsl:value-of select="$yearPart"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$yearPart"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderDate>
			<xsl:value-of select="concat($fullYearPart,'-',format-number(number($monthPart),'00'),'-',format-number(number($dayPart),'00'))"/>
		</PurchaseOrderDate>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
