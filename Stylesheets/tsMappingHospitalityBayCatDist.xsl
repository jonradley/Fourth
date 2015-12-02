<?xml version="1.0" encoding="UTF-8"?>
<!--************************************************************************************************
Date				| Name					| Comments	
****************************************************************************************************
		?			|			?				|				?
****************************************************************************************************
25/08/2011		|	Koshaughnessy		| FB case 4745 Change to strip '/' from recipients code for sender.
****************************************************************************************************
07/09/2011		|	R Cambridge			| 4810 Ensure 'slash-less' codes are copied to the output
****************************************************************************************************
11/11/2011		|	H Robson				| 5015 Set output encoding to UTF-8
****************************************************************************************************
02/07/2012		| M Emanuel				| Stonegate changed their code for Brakes logistics to S20293538803
												| Hard Coding traslation rule to map S20293538803 to S20293538800				  
*************************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                              xmlns:fo="http://www.w3.org/1999/XSL/Format"
                              xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output encoding="UTF-8"/> 
	<xsl:template match="PriceCatalog">
		<Catalogue>
		
			<TradeSimpleHeader>
			
				<xsl:for-each select="TradeSimpleHeader/RecipientsCodeForSender/preceding-sibling::*">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				
				<RecipientsCodeForSender>
					<!-- 4810, R Cambridge, check for a slash in RCS and output as required -->
					<xsl:choose>
						<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'/')">
							<xsl:value-of select="substring-before(TradeSimpleHeader/RecipientsCodeForSender,'/')"/>
						</xsl:when>
						<!-- 5560, M Emanuel Hard Coding traslation rule to map S20293538803 to S20293538800-->
						<xsl:when test="TradeSimpleHeader/RecipientsCodeForSender='S20293538803'">
							<xsl:text>S20293538800</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TradeSimpleHeader/RecipientsCodeForSender"/>
						</xsl:otherwise>
					</xsl:choose>					
				</RecipientsCodeForSender>
				
				<xsl:for-each select="TradeSimpleHeader/RecipientsCodeForSender/following-sibling::*">
					<xsl:copy-of select="."/>
				</xsl:for-each>				
			
			</TradeSimpleHeader>
			
			<CatalogueHeader>
				<CatalogueCode>
					<xsl:value-of select="PriceCatHeader/CatHdrRef/PriceCat/RefNum"/>
				</CatalogueCode>
				<CatalogueName>
					<xsl:value-of select="PriceCatHeader/ListOfDescription/Description"/>
				</CatalogueName>
				<CatalogueType>
					<xsl:value-of select="@CatType"/>
				</CatalogueType>
				<RequiresApproval>true</RequiresApproval>
				<RequiresOnlineOrdering>true</RequiresOnlineOrdering>
				<ValidFrom>
					<xsl:value-of select="substring(PriceCatHeader/ValidStartDate,7,4)"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(PriceCatHeader/ValidStartDate,4,2)"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="substring(PriceCatHeader/ValidStartDate,1,2)"/>
				</ValidFrom>
				<Currency>GBP</Currency>
			</CatalogueHeader>
			<Sections>
				<xsl:variable name="nsGroups">
					<xsl:copy-of select="/"/>
					<xsl:for-each select="//PriceCatalog/ListOfPriceCatAction/PriceCatAction">
						<xsl:sort select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
						<!--xsl:if test="position() = 1 or PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group'] != preceding-sibling::*[1]/PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"-->
						<Item>
							<Group>
								<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
							</Group>
						</Item>
						<!--/xsl:if-->
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="nsSubGroups">
					<xsl:copy-of select="/"/>
					<xsl:for-each select="//PriceCatalog/ListOfPriceCatAction/PriceCatAction[PriceCatDetail/ListOfKeyVal/KeyVal/@Keyword='SubGroup']">
						<xsl:sort select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
						<xsl:sort select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/>
						<xsl:variable name="sGroup">
							<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
						</xsl:variable>
						<xsl:variable name="sSubGrp">
							<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/>
						</xsl:variable>
						<xsl:variable name="thisSubGroup">
							<xsl:value-of select="concat(PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group'],'~',PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup'])"/>
						</xsl:variable>
						<xsl:variable name="lastSubGroup">
							<xsl:value-of select="concat(preceding-sibling::*[1]/PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group'],'~',preceding-sibling::*[1]/PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup'])"/>
						</xsl:variable>
						<xsl:if test="position() = 1 or $thisSubGroup != $lastSubGroup">
							<Item>
								<Group>
									<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group']"/>
								</Group>
								<SubGroup>
									<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup']"/>
								</SubGroup>
								<NoProds>
									<xsl:value-of select="count(following-sibling::*[concat(PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='Group'],'~',PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword='SubGroup'])=$thisSubGroup]) + 1"/>
								</NoProds>
							</Item>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
								
				<xsl:for-each select="msxsl:node-set($nsGroups)/Item">
					<xsl:variable name="sSection">
						<xsl:value-of select="Group"/>
					</xsl:variable>
					<xsl:if test="position() = 1 or preceding-sibling::*[1]/Group != $sSection">
					<xsl:element name="Section1">
						<xsl:attribute name="ID"><xsl:value-of select="Group"/></xsl:attribute>
						<xsl:attribute name="Name"><xsl:value-of select="Group"/></xsl:attribute>
						<xsl:attribute name="NoProducts">
							<xsl:choose>
								<xsl:when test="count(msxsl:node-set($nsSubGroups)/Item[Group = $sSection]) = 0">
									<xsl:value-of select="count(//PriceCatalog/ListOfPriceCatAction/PriceCatAction[PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'Group'] = $sSection])"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="count(//PriceCatalog/ListOfPriceCatAction/PriceCatAction[PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'Group'] = $sSection and PriceCatDetail/ListOfKeyVal/KeyVal[@KeyWord='SubGroup'] = ''])"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<xsl:for-each select="msxsl:node-set($nsSubGroups)/Item[Group = $sSection]">
							<xsl:variable name="sGroup">
								<xsl:value-of select="Group"/>
							</xsl:variable>
							<xsl:variable name="sSub">
								<xsl:value-of select="SubGroup"/>
							</xsl:variable>
							<xsl:if test="position() = 1 or preceding-sibling::*[1] != $sSub">
								<xsl:element name="Section2">
									<xsl:attribute name="ID"><xsl:value-of select="$sSub"/></xsl:attribute>
									<xsl:attribute name="Name"><xsl:value-of select="$sSub"/></xsl:attribute>
									<xsl:attribute name="NoProducts"><xsl:value-of select="NoProds"/></xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</Sections>
			<Products>
				<xsl:for-each select="ListOfPriceCatAction/PriceCatAction">
					<Product>
						<SectionID>
							<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'Group']"/>
						</SectionID>
						<ProductID>
							<SuppliersProductCode>
								<xsl:value-of select="PriceCatDetail/PartNum/PartID"/>
							</SuppliersProductCode>
						</ProductID>
						<ProductDescription>
							<xsl:value-of select="PriceCatDetail/ListOfDescription/Description"/>
						</ProductDescription>
						<UOM>
							<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'UOM']"/>
						</UOM>
						<PackSize>
							<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'PackSize']"/>
						</PackSize>
						<UnitValueExclVAT>
							<xsl:value-of select="PriceCatDetail/ListOfPrice/Price/UnitPrice"/>
						</UnitValueExclVAT>
						<ExtraData>
							<Item>
								<xsl:attribute name="Name">DefaultAccountCode</xsl:attribute>
								<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'DefaultAccountCode']"/>
							</Item>
							<Item>
								<xsl:attribute name="Name">StockItem</xsl:attribute>
								<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'StockItem']"/>
							</Item>
							<Item>
								<xsl:attribute name="Name">IgnorePriceChange</xsl:attribute>
								<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'IgnorePriceChange']"/>
							</Item>
							<xsl:if test="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'InvoicePrice'] != ''">
								<Item>
									<xsl:attribute name="Name">InvoicePrice</xsl:attribute>
									<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'InvoicePrice']"/>
								</Item>
							</xsl:if>
							<xsl:if test="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'InvoicePriceUOM'] != ''">
								<Item>
									<xsl:attribute name="Name">InvoicePriceUOM</xsl:attribute>
									<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'InvoicePriceUOM']"/>
								</Item>
							</xsl:if>
							<xsl:if test="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'Average Weight'] != ''">
								<Item>
									<xsl:attribute name="Name">Average Weight</xsl:attribute>
									<xsl:value-of select="PriceCatDetail/ListOfKeyVal/KeyVal[@Keyword = 'Average Weight']"/>
								</Item>
							</xsl:if>
						</ExtraData>
					</Product>
				</xsl:for-each>
			</Products>
		</Catalogue>
	</xsl:template>
</xsl:stylesheet>
