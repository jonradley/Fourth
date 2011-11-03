<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview

 © Alternative Business Solutions Ltd, 2007.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 06/07/2007	| R Cambridge			| Created module
==========================================================================================
 10/10/2007	| R Cambridge			| 1503 Added customer product code
==========================================================================================
 26/10/2007	| R Cambridge			| 1503 Add customer product code unconditionally
==========================================================================================
           	|                 	|
=======================================================================================-->
<xsl:stylesheet 	version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">	
	
		<SupplierPrices>
			
			<xsl:attribute name="SupplierCode"><xsl:value-of select="/PriceCatalog/TradeSimpleHeader/RecipientsCodeForSender"/></xsl:attribute>
			
			<xsl:attribute name="SupplierName"><xsl:value-of select="/PriceCatalog/TradeSimpleHeader/SendersName"/></xsl:attribute>
			
			<xsl:attribute name="CatalogueReference"><xsl:value-of select="/PriceCatalog/PriceCatHeader/CatHdrRef/PriceCat/RefNum"/></xsl:attribute>
			
			<xsl:for-each select="/PriceCatalog/ListOfPriceCatAction/PriceCatAction/PriceCatDetail">
				
				<NewPrice>
					
					<xsl:attribute name="ProductCode"><xsl:value-of select="PartNum/PartID"/></xsl:attribute>
					
					<xsl:attribute name="Description"><xsl:value-of select="ListOfDescription/Description"/></xsl:attribute>
					
					<xsl:attribute name="UoM"><xsl:value-of select="ListOfKeyVal/KeyVal[@Keyword='UOM']"/></xsl:attribute>
					
					<xsl:attribute name="PackSize"><xsl:value-of select="ListOfKeyVal/KeyVal[@Keyword='PackSize']"/></xsl:attribute>
					
					<xsl:attribute name="Category"><xsl:value-of select="ListOfKeyVal/KeyVal[@Keyword='Group']"/></xsl:attribute>
					
					<xsl:attribute name="SubCategory"><xsl:value-of select="ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/></xsl:attribute>					
					
					<xsl:attribute name="Price"><xsl:value-of select="ListOfPrice/Price[1]/UnitPrice"/></xsl:attribute>	
										
					<xsl:if test="ListOfPrice/Price[2]">
						<xsl:attribute name="EffectiveDate"><xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,7,4)"/>-<xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,4,2)"/>-<xsl:value-of select="substring(ListOfPrice/Price[1]/EndDate,1,2)"/></xsl:attribute>
						<xsl:attribute name="NewPrice"><xsl:value-of select="ListOfPrice/Price[2]/UnitPrice"/></xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="CustomerProductCode"><xsl:value-of select="ListOfKeyVal/KeyVal[@Keyword='CustomerProductCode']"/></xsl:attribute>				
					
				</NewPrice>
				
			</xsl:for-each>
			
		</SupplierPrices>
		
	</xsl:template>
	
</xsl:stylesheet>
