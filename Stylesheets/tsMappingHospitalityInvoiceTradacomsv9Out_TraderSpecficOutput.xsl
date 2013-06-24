<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
H Robson		|	2013-06-20	| FB 6687  Crated tsMappingHospitalityInvoiceTradacomsv9Out_TraderSpecficOutput.xsl
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<!--Generic Variables-->
	<xsl:variable name="BAXTER" select="'BAXTER'"/>
	<xsl:variable name="CPM" select="'CPM'"/>

	<xsl:variable name="accountCode" select="string(//TradeSimpleHeader/RecipientsCodeForSender)"/>	
	
	<xsl:variable name="Buyer">	
		<xsl:choose>
			<xsl:when test="//TradeSimpleHeader/RecipientsCodeForSender = 'campbell'"><xsl:value-of select="$BAXTER"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>		
	<xsl:variable name="Supplier">
		<xsl:choose>
			<xsl:when test="//TradeSimpleHeader/SendersCodeForRecipient = 'WILSON STOR(NAT'"><xsl:value-of select="$CPM"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- when campbells is the supplier and baxter is the buyer, a different field is used for BuyerName -->
	<xsl:template name="BuyerName-TradeSpecific">
		<xsl:choose>
			<xsl:when test="$Buyer=$BAXTER and $Supplier=$CPM"><xsl:value-of select="InvoiceHeader/Buyer/BuyersAddress/AddressLine1"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="InvoiceHeader/Buyer/BuyersName"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
