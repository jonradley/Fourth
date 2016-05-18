<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK inbound mapper for stock journal journal to split the report by currency to prepare it for export
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 14/04/2016	| Jose Miguel	| FB10911 - Created
==========================================================================================
 18/05/2016	| Jose Miguel	| FB10995 - Calculate file name
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:key name="keyCurrency" match="Batch/BatchDocuments/BatchDocument" use="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/CurrencyCode"/>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!-- Copy the attribute unchanged -->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	<xsl:template match="Batch">
		<BatchRoot>
			<!-- For each different currency -->
			<xsl:for-each select="BatchDocuments/BatchDocument [generate-id() = generate-id(key('keyCurrency', ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/CurrencyCode)[1])]">
				<xsl:variable name="CurrencyCode" select="ClosingStockJournalEntries/ClosingStockJournalEntriesHeader/CurrencyCode"/>
				<!-- Group the receipts and returns together -->
				<Document TypePrefix="CSJ">
					<Batch>
						<xsl:call-template name="createBatchHeader">
							<xsl:with-param name="Prefix" select="'Closing_Stock_Accrual'"/>
							<xsl:with-param name="CurrencyCode" select="$CurrencyCode"/>
						</xsl:call-template>
						<BatchDocuments>
							<xsl:for-each select="key('keyCurrency',$CurrencyCode)">
								<BatchDocument>
									<xsl:copy-of select="node()"/>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:for-each>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template name="createBatchHeader">
		<xsl:param name="Prefix"/>
		<xsl:param name="CurrencyCode"/>
		<xsl:param name="Date" select="/Batch/BatchHeader/ExportRunDate"/>
		<xsl:param name="Time" select="/Batch/BatchHeader/ExportRunTime"/>		
		<xsl:variable name="Year" select="substring($Date, 3, 2)"/>
		<xsl:variable name="Month" select="substring($Date, 6, 2)"/>
		<xsl:variable name="Day" select="substring($Date, 9, 2)"/>
		<xsl:variable name="Hours" select="substring($Time, 1, 2)"/>
		<xsl:variable name="Minutes" select="substring($Time, 4, 2)"/>
		<BatchHeader>
			<xsl:apply-templates select="/Batch/BatchHeader/OrganisationCode | /Batch/BatchHeader/SourceSystemExportID | /Batch/BatchHeader/SourceSystemOrgID | /Batch/BatchHeader/SourceSystemOrgID"/>
			<FormatCode>
				<xsl:value-of select="concat($Prefix, '_', $CurrencyCode, '_', $Day, '_',$Month, '_', $Year, '_', $Hours, '_' , $Minutes ,'.csv')"/>
			</FormatCode>
			<xsl:apply-templates select="/Batch/BatchHeader/OrganisationName | /Batch/BatchHeader/OrganisationName/ExportRunDate"/>
		</BatchHeader>
	</xsl:template>	
</xsl:stylesheet>
