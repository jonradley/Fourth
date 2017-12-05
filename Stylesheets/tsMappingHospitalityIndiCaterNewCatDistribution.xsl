<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Fourth Hospitality 2010
 .
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
15/04/2010	| John Cahill		    		| Created module
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">	
	
		<SupplierPrices>
			
			<xsl:attribute name="SupplierCode"><xsl:value-of select="/Catalogue/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
			
			<xsl:attribute name="SupplierName"><xsl:value-of select="/Catalogue/TradeSimpleHeader/SendersName"/></xsl:attribute>
			
			<xsl:attribute name="CatalogueReference"><xsl:value-of select="/Catalogue/CatalogueHeader/CatalogueCode"/></xsl:attribute>
			
			<xsl:for-each select="/Catalogue/Products/Product">
				
				<NewPrice>
					
					<xsl:attribute name="ProductCode"><xsl:value-of select="ProductID/SuppliersProductCode"/></xsl:attribute>
					
					<xsl:attribute name="Description"><xsl:value-of select="ProductDescription"/></xsl:attribute>
					
					<xsl:attribute name="UoM"><xsl:value-of select="UOM"/></xsl:attribute>
					
					<xsl:attribute name="PackSize"><xsl:value-of select="PackSize"/></xsl:attribute>
					
					<xsl:attribute name="Category"><xsl:value-of select="SectionID"/></xsl:attribute>
					
					<xsl:attribute name="SubCategory"><xsl:value-of select="WeDontHaveThis"/></xsl:attribute>					
					
					<xsl:attribute name="Price"><xsl:value-of select="UnitValueExclVAT"/></xsl:attribute>	
					
					<xsl:attribute name="CustomerProductCode"><xsl:value-of select="ProductID/BuyersProductCode"/></xsl:attribute>				
					
				</NewPrice>
				
			</xsl:for-each>
			
		</SupplierPrices>
		
	</xsl:template>
	
</xsl:stylesheet>

