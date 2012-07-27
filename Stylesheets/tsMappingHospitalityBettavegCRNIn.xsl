<!--**************************************************************************
Date		|	Name				|	Comment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
08/11/2011|	KOshaughnessy	| Created
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			|						|
***************************************************************************-->	

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
	<xsl:template match="SendersCodeForRecipient | SuppliersCode
							   |	AddressLine1 | InvoiceReference | DeliveryNoteReference 
							   | SuppliersProductCode | ProductDescription">
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
	
	<xsl:template name="stripQuotes">
		<xsl:param name="sInput"/>
		<xsl:variable name="sLF"><xsl:text>&#10;</xsl:text></xsl:variable>
		<xsl:variable name="sWorking">
			<xsl:choose>
				<xsl:when test="substring($sInput,string-length($sInput),1) = $sLF">
					<xsl:value-of select="substring($sInput,1,string-length($sInput)-1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sInput"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="starts-with($sWorking,'&quot;') and substring($sWorking,string-length($sWorking),1) = '&quot;'">
				<xsl:value-of select="substring($sWorking,2,string-length($sWorking)-2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sWorking"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<!--Translation to trade|simple date format-->
	<xsl:template match="CreditNoteDate | TaxPointDate | InvoiceDate | DeliveryNoteDate | DespatchDate ">
		<xsl:call-template name="DateFormat">
			<xsl:with-param name="TranslateDate">
				<xsl:call-template name="stripQuotes">
					<xsl:with-param name="sInput">
						<xsl:value-of select="."/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="DateFormat">
		<xsl:param name="TranslateDate" select="."/>
		<xsl:copy>
			<xsl:value-of select="concat(substring($TranslateDate,7,4),'-',substring($TranslateDate,4,2),'-',substring($TranslateDate,1,2))"/>
		</xsl:copy>
	</xsl:template>
	
	<!--Removing negative line inidicators-->
	<xsl:template match="CreditedQuantity | LineValueExclVAT | CreditedQuantity | LineValueExclVAT | DiscountedLinesTotalExclVAT | DocumentTotalExclVAT |
								SettlementTotalExclVAT | DocumentTotalInclVAT | SettlementTotalInclVAT">
		<xsl:call-template name="NegativeValues"/>								
	</xsl:template>

	<xsl:template name="NegativeValues">
		<xsl:param name="Translate" select="."/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="contains($Translate,'-')">
					<xsl:value-of select="translate($Translate,'-','')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$Translate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	
	<!--Sorting out the VAT codes-->
	<xsl:template match="VATCode">
		<xsl:element name="VATCode">
			<xsl:call-template name="VATDecode">
				<xsl:with-param name="Translate">
					<xsl:call-template name="stripQuotes">
						<xsl:with-param name="sInput">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@VATCode">
		<xsl:attribute name="VATCode">
			<xsl:call-template name="VATDecode">
				<xsl:with-param name="Translate">
					<xsl:call-template name="stripQuotes">
						<xsl:with-param name="sInput">
							<xsl:value-of select="."/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>
	
	<!--VAT decoded-->
	<xsl:template name="VATDecode">
		<xsl:param name="Translate"/>
			<xsl:choose>
				<xsl:when test="$Translate = 'T0' ">
					<xsl:text>Z</xsl:text>
				</xsl:when>
				<xsl:when test="$Translate = 'T1' ">
					<xsl:text>S</xsl:text>
				</xsl:when>
			</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>