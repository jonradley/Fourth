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
	
	<!-- Bug fix where they incorrectly send multiple credit note structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every credit note found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="CreditNote">
			<!-- Each time we find an credit note element, first (repeat) copy the BatchDocument element -->
			<xsl:element name="BatchDocument">
				<!-- Now process the credit note -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another credit note, (repeat) close the BatchDocument element -->
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<!--Translate UOM based on the Units In Pack value-->
	<xsl:template match="CreditNoteLine/CreditedQuantity">
		<xsl:element name="CreditedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="substring(../Measure/UnitsInPack, 1, 4) = 'CASE'">CS</xsl:when>
					<xsl:otherwise>EA</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
