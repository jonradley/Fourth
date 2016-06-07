<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml"/>
	<xsl:template match="/">	
		<SupplierPrices>
			<xsl:attribute name="Supplier"><xsl:value-of select="/PriceCatalog/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
			<xsl:for-each select="/PriceCatalog/ListOfPriceCatAction/PriceCatAction/PriceCatDetail[ListOfKeyVal/KeyVal[@Keyword='InAztec'] = 1]">
				<NewPrice>
					<xsl:attribute name="ImpExpRef"><xsl:value-of select="PartNum/PartID"/></xsl:attribute>
					<xsl:attribute name="Price"><xsl:value-of select="ListOfPrice/Price[1]/UnitPrice"/></xsl:attribute>
					<xsl:if test="ListOfPrice/Price[2]">
						<xsl:attribute name="EffectiveDate"><xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,7,4)"/>-<xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,4,2)"/>-<xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,1,2)"/></xsl:attribute>
						<xsl:attribute name="NewPrice"><xsl:value-of select="ListOfPrice/Price[2]/UnitPrice"/></xsl:attribute>
					</xsl:if>
				</NewPrice>
			</xsl:for-each>
		</SupplierPrices>
	</xsl:template>
</xsl:stylesheet>
