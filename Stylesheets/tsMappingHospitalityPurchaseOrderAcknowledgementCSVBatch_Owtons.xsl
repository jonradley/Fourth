<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************
Purchase Order Acknowledgement translation following CSV 
flat file mapping for BUNZL on HOSP.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Name         		| Date      	 | Change
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Lee Boyton   	| 22/09/2006 | Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Nigel Emsen  	| 22/04/2007 | Amended for Bunzl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Andrew Barber  | 22/04/2007 | Amended for Wincanton
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Harold Robson  | 25/02/2013 | Created copy for Owtons
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>
	
	<xsl:template match="/">
	
		<!-- create the BatchRoot element required by the Inbound XSL Transform processor -->
		<BatchRoot>
			<!-- Batch -->
				<!-- BatchDocuments-->
					<xsl:apply-templates select="@*|node()"/>
				<!--/BatchDocuments-->
			<!--/Batch-->
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
	
	<!-- translate the date from [yyyymmdd] format to [yyyy-mm-dd] -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:variable name="dayPart">
			<xsl:value-of select="substring(.,7,2)"/>
		</xsl:variable>
		<xsl:variable name="monthPart">
			<xsl:value-of select="substring(.,5,2)"/>
		</xsl:variable>
		<xsl:variable name="yearPart">
			<xsl:value-of select="substring(.,1,4)"/>
		</xsl:variable>
		<!-- construct the final xml formatted date -->
		<PurchaseOrderDate>
			<xsl:value-of select="concat($yearPart,'-',$monthPart,'-',$dayPart)"/>
		</PurchaseOrderDate>
	</xsl:template>
	
	<!--identity transformation -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
