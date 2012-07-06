<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Overview

 MWFS invoice translator
 
 © Alternative Business Solutions Ltd., 2007.
******************************************************************************************
 Module History
******************************************************************************************
 Date 			| Name           | Description of modification
******************************************************************************************
 27/04/2012	|K Oshaughnessy   |  Created Module
******************************************************************************************
			  		|                |
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- NOTE: the FFS creates a duplicate invoice document for each unique invoice line -->
	<!-- key invoices by their invoice reference, so we can deduplicate invoice documents -->
	<xsl:key name="invoicesByRef" match="//Invoice" use="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
	<!-- key invoice lines by the invoice reference, so we can recover invoice lines from the duplicated documents -->
	<xsl:key name="invoiceLinesByRef" match="//InvoiceLine" use="ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/> 
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<xsl:template match="BatchDocuments">
		<xsl:copy>
			<!-- exclude first document as it just contains headers -->
			<xsl:for-each select="BatchDocument[position()!=1]">
					<!-- map just the first invoice with each unique reference -->
					<xsl:for-each select="Invoice[generate-id() = generate-id(key('invoicesByRef',InvoiceHeader/InvoiceReferences/InvoiceReference)[1])]">
						<BatchDocument DocumentTypeNo="86">
							<xsl:copy>
								<xsl:apply-templates/>
							</xsl:copy>
						</BatchDocument>
					</xsl:for-each>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
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
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	
		<!--Reformating Date to Trade|Simple format-->
	<xsl:template match="InvoiceDate | TaxPointDate">
		<xsl:call-template name="DateFormat"/>
	</xsl:template>
	
	<xsl:template name="DateFormat">
		<xsl:param name="sDateFormat" select="."/>
		<xsl:copy>
			<xsl:value-of select="concat(substring($sDateFormat,7,4),'-',substring($sDateFormat,4,2),'-',substring($sDateFormat,1,2))"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="InvoiceDetail">
		<!-- current invoice reference -->
		<xsl:variable name="invRef" select="ancestor::Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
		<InvoiceDetail>
			<!-- use key to recover missing invoice lines from the duplicate invoices that we didnt map -->
			<xsl:for-each select="key('invoiceLinesByRef',$invRef)">
				<InvoiceLine>
					<xsl:apply-templates/>
				</InvoiceLine>
			</xsl:for-each>
		</InvoiceDetail>
	</xsl:template>
	
	<xsl:template match="//Invoice/InvoiceDetail/InvoiceLine[not(UnitValueExclVAT)]">
		<xsl:copy>
			<xsl:value-of select="(/Invoice/InvoiceDetail/InvoiceLine/LineValueExclVAT div /Invoice/InvoiceDetail/InvoiceLine/InvoicedQuantity)"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
