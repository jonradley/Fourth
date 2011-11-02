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
	
	<!-- Bug fix where they incorrectly send multiple invoice structures within each BatchDocument -->
	<xsl:template match="BatchDocument">
		<!-- Now run the following for every invoice found within this BatchDocument element, even if there is only one -->
		<xsl:for-each select="Invoice">
			<!-- Each time we find an invoice element, first (repeat) copy the BatchDocument element -->
			<xsl:element name="BatchDocument">
				<!-- Now process the invoice -->
				<xsl:copy>
					<xsl:apply-templates/>
				</xsl:copy>
			<!-- And before looking for another invoice, (repeat) close the BatchDocument element -->
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="SendersCodeForRecipient">
		<xsl:element name="SendersCodeForRecipient">
		<xsl:choose>
			<xsl:when test=". = 'SSP25T'">
				<xsl:value-of select="../../InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<!--Translate UOM based on the Units In Pack value-->
	<xsl:template match="InvoiceLine/InvoicedQuantity">
		<xsl:element name="InvoicedQuantity">
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<xsl:when test="substring(../Measure/UnitsInPack, 1, 4) = 'CASE'">CS</xsl:when>
					<xsl:otherwise>EA</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

	<!-- SSP specific change to append the unit of measure onto the product code -->
	<xsl:template match="ProductID/SuppliersProductCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="../../../../TradeSimpleHeader/SendersCodeForRecipient = 'SSP25T'">

					<!-- translate the Units In Pack value and then append this to the product code -->
					<xsl:variable name="UOM">
						<xsl:choose>
							<xsl:when test="substring(../../Measure/UnitsInPack, 1, 4) = 'CASE'">CS</xsl:when>
							<xsl:otherwise>EA</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
				
					<xsl:value-of select="concat(.,'~',$UOM)"/>
										
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!--xsl:template match="SendersBranchReference">
		<xsl:element name="SendersBranchReference">
			<xsl:choose>
				<xsl:when test=". = 'SSP25T'">MIL14T</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="SendersTransmissionReference">
		<xsl:element name="SendersTransmissionReference">
			<xsl:choose>
				<xsl:when test=". = 'SSP25T'">MIL14T</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="Buyer/BuyersLocationID/SuppliersCode">
		<xsl:element name="SuppliersCode">
			<xsl:choose>
				<xsl:when test=". = 'SSP25T'">MIL14T</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template-->

</xsl:stylesheet>
