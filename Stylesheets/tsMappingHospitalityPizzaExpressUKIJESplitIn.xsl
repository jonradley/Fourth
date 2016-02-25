<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK inbound mapper for invoice journal to split the report by currency to prepare it for export
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 25/02/2016	| Jose Miguel	| FB10850 - Pay File with IJE Integration
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:key name="keyCurrency" match="Batch/BatchDocuments/BatchDocument" use="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
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
			<xsl:for-each select="BatchDocuments/BatchDocument [generate-id() = generate-id(key('keyCurrency', InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/CurrencyCode)[1])]">
				<xsl:variable name="CurrencyCode" select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/CurrencyCode"/>
				<!-- Group the receipts and returns together -->
				<Document TypePrefix="IJE">
					<Batch>
						<xsl:copy-of select="/Batch/BatchHeader"/>
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
</xsl:stylesheet>
