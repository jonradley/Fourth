<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' $Header: $ $NoKeywords: $
' Overview 
'  XSL Invoice mapper
'  Hospitality post flat file mapping to iXML format.
'
' © Fourth Ltd., 2013.
'******************************************************************************************
' Module History
'******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
' 15/08/2014  | Jose Miguel  | Created - FB7927 - Total Produce - Integration for Invoice / Credit Notes Batches 
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*|text()|comment()|processing-instruction()">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	<!-- translate currency intro the Purchase Reference Order -->
	<xsl:template match="InvoiceLine">
		<InvoiceLine>
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="../../InvoiceHeader/Currency"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:call-template name="FormatDate">
						<xsl:with-param name="date" select="../../InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:call-template>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			<DeliveryNoteReferences>
				<DeliveryNoteReference><xsl:value-of select="../../InvoiceHeader/InvoiceReferences/InvoiceReference"/></DeliveryNoteReference>
				<DeliveryNoteDate>
					<xsl:call-template name="FormatDate">
						<xsl:with-param name="date" select="../../InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					</xsl:call-template>
				</DeliveryNoteDate>				
			</DeliveryNoteReferences>			
			<xsl:apply-templates/>
		</InvoiceLine>
	</xsl:template>
	<!-- translate currency intro the Purchase Reference Order -->
	<xsl:template match="CreditNoteLine">
		<CreditNoteLine>
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="../../CreditNoteHeader/Currency"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:call-template name="FormatDate">
						<xsl:with-param name="date" select="../../CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
					</xsl:call-template>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
			<xsl:apply-templates/>
		</CreditNoteLine>
	</xsl:template>
	<!-- Remove proxy tags used for other purposes -->
	<xsl:template match="Currency"/>
	<!-- re format dates -->
	<xsl:template match="InvoiceDate | CreditNoteDate">
		<xsl:element name="{local-name(.)}">
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="date" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<!-- VARRate -->
	<xsl:template match="VATRate[. != 0]">
		<VATRate>
			<xsl:value-of select="format-number(/UnitValueExclVAT div .,'#0')"/>
		</VATRate>
	</xsl:template>
	<!-- Date Formatting -->
	<xsl:template name="FormatDate">
		<xsl:param name="date"/>
		<xsl:value-of select="concat(substring($date, 1, 4),'-',substring($date, 5, 2),'-',substring($date, 7, 2))"/>
	</xsl:template>
</xsl:stylesheet>
