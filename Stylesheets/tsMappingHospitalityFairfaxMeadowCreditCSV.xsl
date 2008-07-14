<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
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

	<!-- Remove quotes from text fields -->
	<xsl:template match="SendersCodeForRecipient |
	                     SendersBranchReference |
	                     BuyersLocationID/SuppliersCode |
	                     ShipToLocationID/SuppliersCode |
	                     InvoiceReference |
	                     CreditNoteReference |
	                     PurchaseOrderReference |
	                     ContractReference |
	                     DeliveryNoteReference |
	                     SuppliersProductCode | 
	                     ProductDescription">
		<xsl:variable name="tagName">
			<xsl:value-of select="name()"/>
		</xsl:variable>
		<xsl:element name="{$tagName}">
		<xsl:call-template name="stripQuotes">
			<xsl:with-param name="sInput">
				<xsl:value-of select="."/>
			</xsl:with-param>
		</xsl:call-template>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="InvoiceDate |
                        CreditNoteDate |
	                     TaxPointDate |
	                     PurchaseOrderDate |
	                     DeliveryNoteDate">
	
		<xsl:element name="{name()}"	>
			<xsl:call-template name="formatDates">
				<xsl:with-param name="sInput">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	
	</xsl:template>
	
	<!-- where there is an ordered quantity, make it an invoiced quantity -->
	<xsl:template match="OrderedQuantity">
		<InvoicedQuantity>
			<xsl:value-of select="."/>
		</InvoicedQuantity>
	</xsl:template>
	
	<xsl:template match="CreditedQuantity">
		<InvoicedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:call-template name="decodePacksize">
					<xsl:with-param name="sInput">
						<xsl:value-of select="../PackSize"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</InvoicedQuantity>
	</xsl:template>
	
	<xsl:template match="PackSize"></xsl:template>
	
	<xsl:template match="VATCode">
		<VATCode>
			<xsl:choose>
				<xsl:when test=". = '&quot;0&quot;'">Z</xsl:when>
				<xsl:when test=". = '&quot;1&quot;'">S</xsl:when>
			</xsl:choose>
		</VATCode>
	</xsl:template>
	
	<xsl:template match="ProductID">
		<ProductID>
			<GTIN>55555555555555</GTIN>
			<SuppliersProductCode>
				<xsl:call-template name="stripQuotes">
					<xsl:with-param name="sInput">
						<xsl:value-of select="SuppliersProductCode"/>
					</xsl:with-param>
				</xsl:call-template>
			</SuppliersProductCode>
		</ProductID>
	</xsl:template>


	<xsl:template name="stripQuotes">
		<xsl:param name="sInput"/>
	
		<xsl:choose>
			<xsl:when test="starts-with($sInput,'&quot;') and substring($sInput,string-length($sInput),1) = '&quot;'">
				<xsl:value-of select="substring($sInput,2,string-length($sInput)-2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sInput"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<xsl:template name="formatDates">
		<xsl:param name="sInput"/>
		<xsl:value-of select="concat(substring($sInput,7,4),'-',substring($sInput,4,2),'-',substring($sInput,1,2))"/>
	</xsl:template>
	
	<xsl:template name="decodePacksize">
		<xsl:param name="sInput"/>
		<xsl:choose>
			<xsl:when test="$sInput = '&quot;KG&quot;'">KGM</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>