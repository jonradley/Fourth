<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal Purchase Order into a McMullen Brewery text file .
 
 © Alternative Business Solutions Ltd., 2009.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       				| Description of modification
******************************************************************************************
 09/12/2009	| Sandeep Sehgal	| FB 3278 Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:template name="prepend-pad">
		<!-- recursive template to right justify and prepend-->
		<!-- the value with whatever padChar is passed in   -->
		<xsl:param name="padChar"/>
		<xsl:param name="padVar"/>
		<xsl:param name="length"/>
		<xsl:choose>
			<xsl:when test="string-length($padVar) &lt; $length">
				<xsl:call-template name="prepend-pad">
					<xsl:with-param name="padChar" select="$padChar"/>
					<xsl:with-param name="padVar" select="concat($padChar,$padVar)"/>
					<xsl:with-param name="length" select="$length"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($padVar,string-length($padVar) - $length + 1)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>
		<xsl:for-each select="/PurchaseOrder">
			<!--Header -->
			<xsl:text>1</xsl:text>
			<xsl:variable name="sRecipientCode">
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</xsl:variable>
			<!--xsl:call-template name="prepend-pad">
				<xsl:with-param name="padVar" select="$sRecipientCode"/>
				<xsl:with-param name="padChar" select="0"/>
				<xsl:with-param name="length" select="4"/>
			</xsl:call-template-->
			<xsl:variable name="sPONo">
				<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderReference"/>
			</xsl:variable>
			<xsl:call-template name="prepend-pad">
				<xsl:with-param name="padVar" select="$sPONo"/>
				<xsl:with-param name="padChar" select="0"/>
				<xsl:with-param name="length" select="11"/>
			</xsl:call-template>
			<xsl:text>&#x20;MM</xsl:text>
			<xsl:call-template name="prepend-pad">
				<xsl:with-param name="padVar" select="$sRecipientCode"/>
				<xsl:with-param name="padChar" select="0"/>
				<xsl:with-param name="length" select="4"/>
			</xsl:call-template>
			<xsl:variable name="sPODate">
				<xsl:value-of select="PurchaseOrderHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			</xsl:variable>
			<xsl:value-of select="concat(substring($sPODate,9,2),'/',substring($sPODate,6,2),'/',substring($sPODate,1,4))"/>
			<xsl:variable name="sDeliveryDate">
				<xsl:value-of select="PurchaseOrderHeader/OrderedDeliveryDetails/DeliveryDate"/>
			</xsl:variable>
			<xsl:value-of select="concat(substring($sDeliveryDate,9,2),'/',substring($sDeliveryDate,6,2),'/',substring($sDeliveryDate,1,4))"/>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
			<xsl:text>N1 1</xsl:text>
			<xsl:value-of select="$NewLine"/>
			<!--Purchase Order Line one or more detail lines  -->
			<xsl:for-each select="PurchaseOrderDetail/PurchaseOrderLine">
				<xsl:text>2</xsl:text>
				<!--xsl:call-template name="prepend-pad">
					<xsl:with-param name="padVar" select="$sRecipientCode"/>
					<xsl:with-param name="padChar" select="0"/>
					<xsl:with-param name="length" select="4"/>
				</xsl:call-template-->
				<xsl:call-template name="prepend-pad">
					<xsl:with-param name="padVar" select="$sPONo"/>
					<xsl:with-param name="padChar" select="0"/>
					<xsl:with-param name="length" select="11"/>
				</xsl:call-template>
				<xsl:text>&#x20;</xsl:text>
				<xsl:call-template name="prepend-pad">
					<xsl:with-param name="padVar" select="ProductID/SuppliersProductCode"/>
					<xsl:with-param name="padChar" select="0"/>
					<xsl:with-param name="length" select="5"/>
				</xsl:call-template>
				<xsl:text>&#x20;</xsl:text>
				<xsl:variable name="sQuantity">
					<xsl:value-of select="OrderedQuantity"/>
				</xsl:variable>
				<xsl:call-template name="prepend-pad">
					<xsl:with-param name="padVar" select="ceiling($sQuantity)"/>
					<xsl:with-param name="padChar" select="0"/>
					<xsl:with-param name="length" select="6"/>
				</xsl:call-template>
				<xsl:text>SMCMU99</xsl:text>
				<xsl:value-of select="$NewLine"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
