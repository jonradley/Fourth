<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/">
		<fourthheader>
			<productheader>
				<orgid/>
				
				<xsl:variable name="sSupplierCode" select="Catalogue/TradeSimpleHeader/RecipientsCodeForSender"/>
				<xsl:variable name="sCurrencyCode" select="Catalogue/CatalogueHeader/Currency"/>
				
						<xsl:for-each select="Catalogue/Products/Product">
							<product>
								<productname><xsl:value-of select="ProductDescription"/></productname>
								<size></size>
								<unit>EA</unit>
								<VAT>Z</VAT>
								<categoryid>1</categoryid>
								<tscategory><xsl:value-of select="SectionID"/></tscategory>
								<tspacksize><xsl:value-of select="PackSize"/></tspacksize>
								<supplierheader>
									<supplierrecord>
										<supplierID><xsl:value-of select="$sSupplierCode"/></supplierID>
										<suppliercode><xsl:value-of select="ProductID/SuppliersProductCode"/></suppliercode>
										<costprice><xsl:value-of select="UnitValueExclVAT"/></costprice>
										<currency><xsl:value-of select="$sCurrencyCode"/></currency>
										<casesize>1</casesize>
									</supplierrecord>
								</supplierheader>
							</product>
					</xsl:for-each>
				</productheader>
			</fourthheader>
	</xsl:template>
</xsl:stylesheet>
