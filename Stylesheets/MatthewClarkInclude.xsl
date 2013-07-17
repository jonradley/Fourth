<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
S Hussain		| 2013-05-14	| FB6588 - Created a common stylesheets with generic functionalities by Matthew Clark
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<!--Generic Variable-->
	<xsl:variable name="B_P" select="'B_P'"/>
	<xsl:variable name="CustomerFlag">
		<xsl:variable name="accountCode">
			<xsl:choose>
				<xsl:when test="//TradeSimpleHeader/SendersCodeForRecipient">
					<xsl:value-of select="string(//TradeSimpleHeader/SendersCodeForRecipient)"/>
				</xsl:when>
				<xsl:when test="//Buyer/SellerAssigned">
					<xsl:value-of select="string(//Buyer/SellerAssigned)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$accountCode = '50514495' or $accountCode = '50171636' or $accountCode = 'V000047'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<!-- we use constants for default values -->
	<xsl:variable name="defaultTaxCategory" select="'S'"/>
	<xsl:variable name="NewTaxRate" select="'20.0'"/>
	<xsl:variable name="defaultTaxRate" select="'17.5'"/>
	<xsl:variable name="defaultDocumentStatus" select="'Original'"/>
	<xsl:variable name="defaultUnitOfMeasure" select="'EA'"/>
	<xsl:variable name="defaultInvoiceQuantity" select="'1'"/>
	<xsl:variable name="defaultCreditQuantity" select="'1'"/>
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDiscountedLinesTotalExclVAT" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountValue" select="'0'"/>
	<xsl:variable name="creditLineIndicator" select="'2'"/>
	<xsl:variable name="invoiceLineIndicator" select="'1'"/>
	<xsl:variable name="defaultNewTaxRate" select="'15'"/>
	<!--Supplier UOM Formatting Based on Product Code-->
	<xsl:template name="FormatSupplierUOM">
		<xsl:param name="sUOM"/>
		<xsl:param name="sProductCode"/>
		<xsl:choose>
			<xsl:when test="contains($sProductCode,'-EA') and $CustomerFlag = $B_P">
				<xsl:text>EA</xsl:text>
			</xsl:when>
			<xsl:when test="contains($sProductCode,'-CS') and $CustomerFlag = $B_P">
				<xsl:text>CS</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sUOM"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Supplier Product Code Formatting to Truncate UOM-->
	<xsl:template name="FormatSupplierProductCode">
		<xsl:param name="sUOM"/>
		<xsl:param name="sProductCode"/>
		<xsl:choose>
			<xsl:when test="contains($sProductCode,'-EA') and $CustomerFlag = $B_P">
				<xsl:value-of select="substring-before($sProductCode, '-EA')"/>
			</xsl:when>
			<xsl:when test="contains($sProductCode,'-CS') and $CustomerFlag = $B_P">
				<xsl:value-of select="substring-before($sProductCode, '-CS')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sProductCode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Customer Product Code Formatting to Append UOM-->
	<xsl:template name="FormatCustomerProductCode">
		<xsl:param name="sUOM"/>
		<xsl:param name="sProductCode"/>
		<xsl:choose>
			<xsl:when test="$CustomerFlag != $B_P">
				<xsl:value-of select="$sProductCode"/>
			</xsl:when>
			<xsl:when test="string($sUOM) = '' and $CustomerFlag = $B_P">
				<xsl:value-of select="$sProductCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sProductCode,'-',$sUOM)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Split DateTime Field in seperate Date and Time Fields-->
	<xsl:template name="FormatDateTime">
		<xsl:param name="DateField"/>
		<xsl:param name="TimeField"/>
		<xsl:param name="Node"/>
		<!--Add The Date Node-->
		<xsl:element name="{$DateField}">
			<xsl:value-of select="substring-before($Node,'T')"/>
		</xsl:element>
		<!--Add The Time Node-->
		<xsl:element name="{$TimeField}">
			<xsl:value-of select="substring-after($Node,'T')"/>
		</xsl:element>
	</xsl:template>
	<!--Retrieve Date From Date Time Field-->
	<xsl:template name="FormatDate">
		<xsl:param name="DateField"/>
		<xsl:param name="Node"/>
		<xsl:if test="$Node">
			<xsl:element name="{$DateField}">
				<xsl:value-of select="substring-before($Node,'T')"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!--Format Number to 2 Decimal Places-->
	<xsl:template name="FormatNumber">
		<xsl:param name="NumField"/>
		<xsl:value-of select="format-number($NumField, '0.00')"/>
	</xsl:template>
	<!--Decode VATCode-->
	<xsl:template name="decodeVATCode">
		<xsl:param name="VATCode"/>
		<xsl:choose>
			<xsl:when test="$VATCode">
				<xsl:value-of select="$VATCode"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$defaultTaxCategory"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Decode VAT Rate-->
	<xsl:template name="decodeVATRate">
		<xsl:param name="VATRate"/>
		<xsl:choose>
			<xsl:when test="translate(substring-before($VATRate, 'T'),'-','') &gt;= translate('2011-01-04','-','')">
				<xsl:value-of select="format-number($NewTaxRate, '0.00')"/>
			</xsl:when>
			<xsl:when test="translate(substring-before($VATRate, 'T'),'-','')  &lt;= translate('2008-11-30','-','') or translate(substring-before($VATRate, 'T'),'-','')  &gt;= translate('2010-01-01','-','')">
				<xsl:value-of select="format-number($defaultTaxRate, '0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number($defaultNewTaxRate, '0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
