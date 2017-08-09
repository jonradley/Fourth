<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
 Overview
 
 La Tasca mapper inbound splitter. Splits the IJE into independent entries.
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date      	| Name 		| Description of modification
==========================================================================================
 04/03/2015	| Jose Miguel	| FB10182 - La Tasca - Add FnB Invoice and Credit Journal Entries Feed
=======================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
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
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates select="/Batch/BatchDocuments/BatchDocument/InvoiceCreditJournalEntries"/>
		</BatchRoot>
	</xsl:template>
	
	<!-- Splits the document into separate IJE feeds -->
	<xsl:template match="/Batch/BatchDocuments/BatchDocument/InvoiceCreditJournalEntries">
		<Document TypePrefix="IJE">
			<Batch>
				<xsl:copy-of select="../../../BatchHeader"/>
				<BatchDocuments>
					<BatchDocument>
						<InvoiceCreditJournalEntries>
							<xsl:apply-templates/>
						</InvoiceCreditJournalEntries>
					</BatchDocument>
				</BatchDocuments>
			</Batch>
		</Document>
	</xsl:template>
</xsl:stylesheet>

