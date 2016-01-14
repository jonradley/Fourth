<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Stylesheet to map in the Site Transfer Exports from R9

******************************************************************************************
 Module History
******************************************************************************************
 Date        | Name         | Description of modification
******************************************************************************************
 04/02/2014  | S Sehgal  | 7691 Created
******************************************************************************************

***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:output method="xml" encoding="utf-8"/>
	<xsl:template match="Document">
		<BatchRoot>
			<SiteTransfersExport>
				<SiteTransfersExportHeader>
					<OrganisationCode>
						<xsl:choose>
							<xsl:when test="E/L2[6]!=''">
								<xsl:value-of select="E/L2[6]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="E/L2[2]"/>
							</xsl:otherwise>
						</xsl:choose>
					</OrganisationCode>
					<SourceSystemExportID>
						<xsl:value-of select="E/L2[3]"/>
					</SourceSystemExportID>
					<SourceSystemOrgID>
						<xsl:value-of select="E/L2[5]"/>
					</SourceSystemOrgID>
					<MapperID>
						<xsl:value-of select="E/L2[4]"/>
					</MapperID>
					<xsl:if test="T/L2[6] != ''">
						<OrganisationName>
							<xsl:value-of select="T/L2[6]"/>
						</OrganisationName>
					</xsl:if>
					<xsl:if test="T/L2[15] != ''">
						<ExportRunDate>
							<xsl:call-template name="fixDate">
								<xsl:with-param name="sDate" select="T/L2[15]"/>
							</xsl:call-template>
						</ExportRunDate>
					</xsl:if>
				</SiteTransfersExportHeader>
				<SiteTransfers>
					<xsl:for-each select="T">
						<SiteTransfer>
							<SiteTransferLocation>
								<xsl:if test="L2[2] != ''">
									<BuyersUnitCode>
										<xsl:value-of select="L2[2]"/>
									</BuyersUnitCode>
								</xsl:if>
								<xsl:if test="L2[3] != ''">
									<BuyersSiteCode>
										<xsl:value-of select="L2[3]"/>
									</BuyersSiteCode>
								</xsl:if>
								<xsl:if test="L2[4] != ''">
									<UnitSiteName>
										<xsl:value-of select="L2[4]"/>
									</UnitSiteName>
								</xsl:if>
								<xsl:if test="L2[5] != ''">
									<UnitSiteNominal>
										<xsl:value-of select="L2[5]"/>
									</UnitSiteNominal>
								</xsl:if>
							</SiteTransferLocation>
							<xsl:if test="L2[7] != ''">
								<TransactionType>
									<xsl:value-of select="L2[7]"/>
								</TransactionType>
							</xsl:if>
							<xsl:if test="L2[9] != ''">
								<TransactionDescription>
									<xsl:value-of select="L2[9]"/>
								</TransactionDescription>
							</xsl:if>
							<xsl:if test="L2[10] != ''">
								<TransactionDate>
									<xsl:call-template name="fixDate">
										<xsl:with-param name="sDate" select="L2[10]"/>
									</xsl:call-template>
								</TransactionDate>
							</xsl:if>
							<xsl:if test="L2[11] != ''">
								<FinancialYear>
									<xsl:value-of select="L2[11]"/>
								</FinancialYear>
							</xsl:if>
							<xsl:if test="L2[12] != ''">
								<FinancialPeriod>
									<xsl:value-of select="L2[12]"/>
								</FinancialPeriod>
							</xsl:if>
							<xsl:if test="L2[13] != ''">
								<StockFinancialYear>
									<xsl:value-of select="L2[13]"/>
								</StockFinancialYear>
							</xsl:if>
							<xsl:if test="L2[14] != ''">
								<StockFinancialPeriod>
									<xsl:value-of select="L2[14]"/>
								</StockFinancialPeriod>
							</xsl:if>
							<xsl:if test="L2[22] != ''">
								<CurrencyCode>
									<xsl:value-of select="L2[22]"/>
								</CurrencyCode>
							</xsl:if>
							<xsl:if test="L2[23] != ''">
								<CreatedBy>
									<xsl:value-of select="normalize-space(L2[23])"/>
								</CreatedBy>
							</xsl:if>
							<xsl:if test="L2[8] != ''">
								<TransactionID>
									<xsl:value-of select="L2[8]"/>
								</TransactionID>
							</xsl:if>
							<xsl:if test="L2[16] != ''">
								<SuppliersProductCode>
									<xsl:value-of select="L2[16]"/>
								</SuppliersProductCode>
							</xsl:if>
							<xsl:if test="L2[17] != ''">
								<ProductDescription>
									<xsl:value-of select="L2[17]"/>
								</ProductDescription>
							</xsl:if>
							<xsl:if test="L2[18] != ''">
								<LineValueExclVAT>
									<xsl:value-of select="L2[18]"/>
								</LineValueExclVAT>
							</xsl:if>
							<xsl:if test="L2[19] != ''">
								<CostCentreName>
									<xsl:value-of select="L2[19]"/>
								</CostCentreName>
							</xsl:if>
							<xsl:if test="L2[20] != ''">
								<CategoryName>
									<xsl:value-of select="L2[20]"/>
								</CategoryName>
							</xsl:if>
							<xsl:if test="L2[21] != ''">
								<CategoryNominal>
									<xsl:value-of select="L2[21]"/>
								</CategoryNominal>
							</xsl:if>
						</SiteTransfer>
					</xsl:for-each>
				</SiteTransfers>
			</SiteTransfersExport>
		</BatchRoot>
	</xsl:template>
</xsl:stylesheet>
