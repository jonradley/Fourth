<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
<xsl:output method="xml" encoding="UTF-8"/>


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

<xsl:template match="BatchDocument">
	<BatchDocument>	
		<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
		<xsl:apply-templates/>
	</BatchDocument>
</xsl:template>

<xsl:template match="DeliveryNoteDate">
	<DeliveryNoteDate>
		<xsl:value-of select="concat(substring(.,1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
	</DeliveryNoteDate>
</xsl:template>

<xsl:template match="DespatchedQuantity">
	<DespatchedQuantity>
		<xsl:value-of select="format-number(. div 1000.0,'0.00#')"/>
	</DespatchedQuantity>
</xsl:template>

<xsl:template match="UnitValueExclVAT">
	<UnitValueExclVAT>
		<xsl:value-of select="format-number(. div 1000.0,'0.00#')"/>
	</UnitValueExclVAT>
</xsl:template>

</xsl:stylesheet>