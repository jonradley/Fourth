<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name	| Date		 | Change
**********************************************************************
Maha	| 04/10/2011 | 4913: Map vatcode S8 to vatrate 20 and 17.5
**********************************************************************
M Emanuel	| 28/11/2012  	| 5876 Changes to accomodate swapped codes 
									for Elior's invoices but not affect other customers
**********************************************************************
-->
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
	<xsl:template match="Buyer">
		<Buyer>
			<BuyersLocationID>
				<xsl:choose>
					<xsl:when test="substring-before(BuyersLocationID/BuyersCode,'/') !=''">
						<BuyersCode>
							<xsl:value-of select="substring-before(BuyersLocationID/BuyersCode,'/')"/>
						</BuyersCode>
					</xsl:when>
					<xsl:when test="BuyersLocationID/BuyersCode !=''">
						<BuyersCode>
							<xsl:value-of select="BuyersLocationID/BuyersCode"/>
						</BuyersCode>
					</xsl:when>
				</xsl:choose>
				<SuppliersCode>
					<xsl:value-of select="BuyersLocationID/SuppliersCode"/>
				</SuppliersCode>
			</BuyersLocationID>
			<BuyersName>
				<xsl:value-of select="BuyersName"/>
			</BuyersName>
		</Buyer>
		<xsl:if test="substring-after(BuyersLocationID/BuyersCode,'/') !=''">
			<Supplier>
				<SuppliersLocationID>
					<BuyersCode>
						<xsl:value-of select="../ShipTo/ShipToLocationID/SuppliersCode"/>
					</BuyersCode>
				</SuppliersLocationID>
			</Supplier>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ShipTo">
		<ShipTo>
			<ShipToLocationID>
				<xsl:choose>
					<xsl:when test="substring-after(../Buyer/BuyersLocationID/BuyersCode,'/') !=''">
						<SuppliersCode>
							<xsl:value-of select="substring-after(../Buyer/BuyersLocationID/BuyersCode,'/')"/>
						</SuppliersCode>
					</xsl:when>
					<xsl:otherwise>
						<SuppliersCode>
							<xsl:value-of select="ShipToLocationID/SuppliersCode"/>
						</SuppliersCode>
					</xsl:otherwise>
				</xsl:choose>
			</ShipToLocationID>
			<ShipToName>
				<xsl:value-of select="ShipToName"/>
			</ShipToName>
		</ShipTo>
	</xsl:template>
	<!-- insert VAT Rates -->
	<xsl:template match="InvoiceLine">
		<!--xsl:element name="InvoiceLine"-->
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:element name="VATRate">
				<xsl:call-template name="lookupVATRate">
					<xsl:with-param name="sVATCode" select="VATCode"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:copy>
		<!--/xsl:element-->
	</xsl:template>
	<!-- tradesimple VAT codes -->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="decodeVATCodes">
				<xsl:with-param name="sVATCode" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode"><xsl:call-template name="decodeVATCodes"><xsl:with-param name="sVATCode" select="."/></xsl:call-template></xsl:attribute>
	</xsl:template>
	<!-- Sort the dates -->
	<xsl:template match="CreditNoteDate">
		<xsl:element name="CreditNoteDate">
			<xsl:call-template name="sortDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="InvoiceDate">
		<xsl:element name="InvoiceDate">
			<xsl:call-template name="sortDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="TaxPointDate">
		<xsl:element name="TaxPointDate">
			<xsl:call-template name="sortDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!-- Date sorter -->
	<xsl:template name="sortDate">
		<xsl:param name="sDate"/>
		<xsl:value-of select="concat(substring($sDate,7,4),'-',substring($sDate,4,2),'-',substring($sDate,1,2))"/>
	</xsl:template>
	<!-- Decodes and lookups -->
	<!-- Decode the VATCodes -->
	<xsl:template name="decodeVATCodes">
		<xsl:param name="sVATCode"/>
		<xsl:choose>
			<xsl:when test="$sVATCode = 'S0'">Z</xsl:when>
			<xsl:when test="$sVATCode = 'S1'">S</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="lookupVATRate">
		<xsl:param name="sVATCode"/>
		<xsl:choose>
			<xsl:when test="$sVATCode = 'S0'">0.00</xsl:when>
			<xsl:when test="$sVATCode = 'S1'">20.00</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
