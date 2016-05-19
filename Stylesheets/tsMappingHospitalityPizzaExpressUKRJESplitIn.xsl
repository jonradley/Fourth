<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================
Overview

Pizza Express UK inbound mapper to split the report by currency to prepare it for export
==========================================================================================
 Module History
==========================================================================================
 Version
==========================================================================================
 Date				| Name				| Description of modification
==========================================================================================
 25/11/2015	| Jose Miguel	| FB10643 - Receipts and Returns Journal Export mappers
==========================================================================================
 06/04/2016	| Jose Miguel	| FB10899 - Adding GRNI support
==========================================================================================
 14/04/2016	| Jose Miguel	| FB10911 - Refactor
==========================================================================================
 18/05/2016	| Jose Miguel	| FB10995 - Calculate file name
==========================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:user="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl user">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<!-- This key holds all currencies for entries, regardless of the type, that belong to EDI suppliers. without the test sites entries. -->
	<xsl:key name="keyEDISupplierEntries" match="Batch/BatchDocuments/BatchDocument[not(starts-with(Receipt/ReceiptHeader/BuyersSiteName | Return/ReturnHeader/BuyersSiteName, 'TEST')) and (contains(Receipt/ReceiptHeader/BuyersCodeForSupplier | Return/ReturnHeader/BuyersCodeForSupplier, 'EDI') or contains(Receipt/ReceiptHeader/BuyersCodeForSupplier | Return/ReturnHeader/BuyersCodeForSupplier, 'REYCAT'))]" use="Receipt/ReceiptHeader/CurrencyCode | Return/ReturnHeader/CurrencyCode"/>
	<!-- This key holds all currencies for receipts for non - EDI suppliers. without the test sites entries. -->	
	<xsl:key name="keyReceiptCurrency" match="Batch/BatchDocuments/BatchDocument[not(starts-with(Receipt/ReceiptHeader/BuyersSiteName | Return/ReturnHeader/BuyersSiteName, 'TEST') or contains(Receipt/ReceiptHeader/BuyersCodeForSupplier, 'EDI') or contains(Receipt/ReceiptHeader/BuyersCodeForSupplier, 'REYCAT'))]" use="Receipt/ReceiptHeader/CurrencyCode"/>
		<!-- This key holds all currencies for returns for non - EDI suppliers. without the test sites entries. -->	
	<xsl:key name="keyReturnCurrency" match="Batch/BatchDocuments/BatchDocument[not(starts-with(Receipt/ReceiptHeader/BuyersSiteName | Return/ReturnHeader/BuyersSiteName, 'TEST') or contains(Return/ReturnHeader/BuyersCodeForSupplier, 'EDI') or contains(Return/ReturnHeader/BuyersCodeForSupplier, 'REYCAT'))]" use="Return/ReturnHeader/CurrencyCode"/>
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
			<!-- GRNi feed only with suppliers that are defined as IDE. One file per currency. All suppliers and all entries receipts and returns together-->
			<xsl:for-each select="BatchDocuments/BatchDocument [generate-id() = generate-id(key('keyEDISupplierEntries', Receipt/ReceiptHeader/CurrencyCode | Return/ReturnHeader/CurrencyCode)[1])]">
				<xsl:variable name="CurrencyCode" select="Receipt/ReceiptHeader/CurrencyCode | Return/ReturnHeader/CurrencyCode"/>
				<!-- Group the receipts and returns together -->
				<Document TypePrefix="RJE">
					<Batch>
						<xsl:call-template name="createBatchHeader">
							<xsl:with-param name="Prefix" select="'FourthEDIReceipts'"/>
							<xsl:with-param name="CurrencyCode" select="$CurrencyCode"/>
						</xsl:call-template>
						<BatchDocuments>
							<xsl:for-each select="key('keyEDISupplierEntries',$CurrencyCode)">
								<BatchDocument>
									<xsl:apply-templates/>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:for-each>
			<!-- For each different Receipt currency -->
			<xsl:for-each select="BatchDocuments/BatchDocument [generate-id() = generate-id(key('keyReceiptCurrency', Receipt/ReceiptHeader/CurrencyCode)[1])]">
				<xsl:variable name="CurrencyCode" select="Receipt/ReceiptHeader/CurrencyCode"/>
				<!-- Group the receipts and returns together -->
				<Document TypePrefix="RJE">
					<Batch>
						<xsl:call-template name="createBatchHeader">
							<xsl:with-param name="Prefix" select="'FourthReceipts'"/>
							<xsl:with-param name="CurrencyCode" select="$CurrencyCode"/>
						</xsl:call-template>
						<BatchDocuments>
							<xsl:for-each select="key('keyReceiptCurrency',$CurrencyCode)">
								<BatchDocument>
									<xsl:apply-templates/>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:for-each>
			<!-- For each different Return currency -->
			<xsl:for-each select="BatchDocuments/BatchDocument [generate-id() = generate-id(key('keyReturnCurrency', Return/ReturnHeader/CurrencyCode)[1])]">
				<xsl:variable name="CurrencyCode" select="Return/ReturnHeader/CurrencyCode"/>
				<!-- Group the receipts and returns together -->
				<Document TypePrefix="RJE">
					<Batch>
						<xsl:call-template name="createBatchHeader">
							<xsl:with-param name="Prefix" select="'FourthReturns'"/>
							<xsl:with-param name="CurrencyCode" select="$CurrencyCode"/>
						</xsl:call-template>
						<BatchDocuments>
							<xsl:for-each select="key('keyReturnCurrency',$CurrencyCode)">
								<BatchDocument>
									<xsl:apply-templates/>
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
				<xsl:value-of select="concat($Prefix, '_', $Day, '_',$Month, '_', $Year, '_', $Hours, '_' , $Minutes,  '_', $CurrencyCode,'.csv')"/>
			</FormatCode>
			<xsl:apply-templates select="/Batch/BatchHeader/OrganisationName | /Batch/BatchHeader/ExportRunDate | /Batch/BatchHeader/ExportRunTime"/>
		</BatchHeader>
	</xsl:template>
	
	<xsl:template match="ReceiptLine">
		<xsl:if test="AcceptedQuantity!=0">
			<ReceiptLine>
				<xsl:apply-templates/>
			</ReceiptLine>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ReturnLine">
		<xsl:if test="ReturnedQuantity!=0">
			<ReturnLine>
				<xsl:apply-templates/>
			</ReturnLine>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
