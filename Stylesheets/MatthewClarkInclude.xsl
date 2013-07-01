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
				<xsl:when test="//TradeSimpleHeader/SendersBranchReference">
					<xsl:value-of select="string(//TradeSimpleHeader/SendersBranchReference)"/>
				</xsl:when>
				<xsl:when test="//Buyer/SellerAssigned">
					<xsl:value-of select="string(//Buyer/SellerAssigned)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string(//TradeSimpleHeader/SendersCodeForRecipient)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$accountCode = '7414' or $accountCode = '50514623'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7020' or $accountCode = '50171639'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7021' or $accountCode = '50171641'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7022' or $accountCode = '50171645'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7023' or $accountCode = '50171638'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7024' or $accountCode = '50171640'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7025' or $accountCode = '50171644'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7026' or $accountCode = '50171642'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7028' or $accountCode = '50171646'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7029' or $accountCode = '50171647'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7030' or $accountCode = '50171648'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7031' or $accountCode = '50171649'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7033' or $accountCode = '50243577'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7034' or $accountCode = '50243578'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7036' or $accountCode = '50393740'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7037' or $accountCode = '50420006'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7038' or $accountCode = '50424863'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7039' or $accountCode = '50436461'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7040' or $accountCode = '50439391'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7041' or $accountCode = '50464958'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7042' or $accountCode = '50474183'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7403' or $accountCode = '50514593'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7404' or $accountCode = '50514595'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7405' or $accountCode = '50514599'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7406' or $accountCode = '50514606'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7407' or $accountCode = '50514608'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7408' or $accountCode = '50514609'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7409' or $accountCode = '50514613'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7410' or $accountCode = '50514615'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7411' or $accountCode = '50514619'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7412' or $accountCode = '50514621'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7415' or $accountCode = '50514625'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7416' or $accountCode = '50514626'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7417' or $accountCode = '50514629'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7418' or $accountCode = '50514701'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7420' or $accountCode = '50585130'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7421' or $accountCode = '50657783'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7422' or $accountCode = '50673742'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7423' or $accountCode = '50621702'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7424' or $accountCode = '50637125'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7425' or $accountCode = '50690837'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7426' or $accountCode = '50696949'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7427' or $accountCode = '50704724'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7428' or $accountCode = '50702621'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '7429' or $accountCode = '50713924'"><xsl:value-of select="$B_P"/></xsl:when>
			<xsl:when test="$accountCode = '50617412'"><xsl:value-of select="$B_P"/></xsl:when>
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
	<!--Supplier Product Code Formatting to Truncate UOM-->
	<xsl:template name="FormatSupplierProductCode">
		<xsl:param name="sUOM"/>
		<xsl:param name="sProductCode"/>
		<xsl:choose>
			<xsl:when test="contains($sProductCode,concat('-',string($sUOM))) and $CustomerFlag = $B_P">
				<xsl:value-of select="substring-before($sProductCode, concat('-',$sUOM))"/>
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
