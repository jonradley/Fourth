<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
<BatchRoot>
		<xsl:apply-templates/>
</BatchRoot>
	</xsl:template>
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
	<xsl:template match="BatchDocument">
		<xsl:copy>
			<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteHeader">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
			<xsl:element name="SequenceNumber">1</xsl:element>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="DeliveryNoteLine">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
			<xsl:element name="UnitValueExclVAT">0.00</xsl:element>
			<xsl:element name="LineExtraData">
				<xsl:element name="IsStockProduct">1</xsl:element>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	
	<!-- sort all the dates in the file -->
	<xsl:template match="PurchaseOrderDate">
		<xsl:if test=". != ''">
			<xsl:element name="PurchaseOrderDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="DeliveryNoteDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryNoteDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="DeliveryDate">
		<xsl:if test=". != ''">
			<xsl:element name="DeliveryDate" >
				<xsl:call-template name="fixDate">
					<xsl:with-param name="sDate" select="."/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>


	<!--  Format a YYMMDD as YYYY-MM-DD -->
	<xsl:template name="fixDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,7,4),'-',substring($sDate,4,2),'-',substring($sDate,1,2))"/>
	</xsl:template>
	
</xsl:stylesheet>
