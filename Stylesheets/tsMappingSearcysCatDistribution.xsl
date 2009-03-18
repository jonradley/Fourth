<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/">
		<fourthheader>
			<productheader>
				<orgid>Not provided</orgid>
				
				<xsl:variable name="sSupplierCode" select="Catalogue/TradeSimpleHeader/RecipientsCodeForSender"/>
				<xsl:variable name="sCurrencyCode" select="Catalogue/CatalogueHeader/Currency"/>
				
						<xsl:for-each select="Catalogue/Products/Product">
							<product>
								<productname><xsl:value-of select="ProductDescription"/></productname>
								<vintage>N/A</vintage>
								<size><xsl:value-of select="PackSize"/></size>
								<unit><xsl:value-of select="UOM"/></unit>
								<VAT>Not provided</VAT>
								<categoryname><xsl:value-of select="SectionID"/></categoryname>
								<categoryid>Not provided</categoryid>
								<productcode><xsl:value-of select="ProductID/SuppliersProductCode"/></productcode>
								<useasingredient>Not provided</useasingredient>
								<excludefromgp>Not provided</excludefromgp>
								<origin>Not provided</origin>
								<binno>Not provided</binno>
								<yield>Not provided</yield>
								<zerostock>Not provided</zerostock>
								<bakersdozen>Not provided</bakersdozen>
								<bakersdozenqty>Not provided</bakersdozenqty>
								<supplierheader>
									<supplierrecord>
										<supplierID><xsl:value-of select="$sSupplierCode"/></supplierID>
										<suppliercode><xsl:value-of select="ProductID/SuppliersProductCode"/></suppliercode>
										<costprice><xsl:value-of select="UnitValueExclVAT"/></costprice>
										<currency><xsl:value-of select="$sCurrencyCode"/></currency>
										<casesize>Not provided</casesize>
									</supplierrecord>
								</supplierheader>
								<siteheader>
									<sites>
										<siteid>Not provided</siteid>
										<sitename>Not provided</sitename>
									</sites>
								</siteheader>
							</product>
					</xsl:for-each>
				</productheader>
			</fourthheader>
	</xsl:template>
</xsl:stylesheet>
