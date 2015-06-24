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
 2015-05-18  | Y Kovalenko 	| FB10274 Added catalogue code and name
******************************************************************************************
             |            	| 
******************************************************************************************
             |             	|           
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/Catalogue">
	
		<Catalogue>
		
		
			<TradeSimpleHeader>
				<SendersCodeForRecipient>
					<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
				</SendersCodeForRecipient>
				<SendersName>
					<xsl:value-of select="TradeSimpleHeader/SendersName"/>
				</SendersName>
				<SendersAddress>
					<AddressLine1>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine3"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select="TradeSimpleHeader/SendersAddress/AddressLine4"/>
					</AddressLine4>
					<PostCode>
						<xsl:value-of select="TradeSimpleHeader/SendersAddressPostCode"/>
					</PostCode>
				</SendersAddress>
				<RecipientsCodeForSender>
					<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
				</RecipientsCodeForSender>
				<RecipientsBranchReference>
					<xsl:value-of select="TradeSimpleHeader/RecipientsBranchReference"/>
				</RecipientsBranchReference>
				<RecipientsName>
					<xsl:value-of select="TradeSimpleHeader/RecipientsName"/>
				</RecipientsName>
				<RecipientsAddress>
					<AddressLine1>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine1"/>
					</AddressLine1>
					<AddressLine2>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine2"/>
					</AddressLine2>
					<AddressLine3>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine3"/>
					</AddressLine3>
					<AddressLine4>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/AddressLine4"/>
					</AddressLine4>
					<PostCode>
						<xsl:value-of select="TradeSimpleHeader/RecipientsAddress/PostCode"/>
					</PostCode>
				</RecipientsAddress>
				<TestFlag>
					<xsl:value-of select="TradeSimpleHeader/TestFlag"/>
				</TestFlag>
			</TradeSimpleHeader>
		
		
		
			<ValidFrom>
				<xsl:value-of select="CatalogueHeader/ValidFrom"/>
			</ValidFrom>
			
			<!-- Hardcoded expiry date (matches old BP_Cat_Master default value) -->
			<ValidTo>2075-12-31</ValidTo>
			
			<VendorCode>
				<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
			</VendorCode>

      <CatalogueCode>
        <xsl:value-of select="CatalogueHeader/CatalogueCode"/>
      </CatalogueCode>

      <CatalogueName>
        <xsl:value-of select="CatalogueHeader/CatalogueName"/>
      </CatalogueName>
      
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
