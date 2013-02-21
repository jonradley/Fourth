<?xml version="1.0" encoding="UTF-8"?>
<!--**************************************************************************************
 Overview

 Outbound catalogue xml to Adaco.Net (called a quote file in Adaco)
 
******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         	| Description of modification
******************************************************************************************
 2013-02-21  | R Cambridge 	| FB6038 Created Module
******************************************************************************************
             |            	| 
******************************************************************************************
             |            	| 
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/Catalogue">
	
		<Catalogue>
		
			<ValidFrom>
				<xsl:value-of select="CatalogueHeader/ValidFrom"/>
			</ValidFrom>
			
			<!-- Hardcoded expiry date (matches old BP_Cat_Master default value) -->
			<ValidTo>2075-12-31</ValidTo>
			
			<VendorCode>
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</VendorCode>
			
			<Products>
			
				<xsl:for-each select="Products/Product">			
			
					<Product>
						<VendorsProductCode>
							<xsl:value-of select="ProductID/SuppliersProductCode"/>
						</VendorsProductCode>
						<UOM>
							<xsl:value-of select="UOM"/>
						</UOM>
						<ProductPrice>
							<xsl:value-of select="UnitValueExclVAT"/>
						</ProductPrice>
					</Product>
										
				</xsl:for-each>
				
			</Products>
			
		</Catalogue>
	
	</xsl:template>

</xsl:stylesheet>
