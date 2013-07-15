<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Date          | Name        	 | Description of modification
'******************************************************************************************
10/02/2013  | Sahir Hussain  | FB 6744: Created for IMS of Smithfield (EDI) Member
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" indent="no" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Document>
				<Batch>
					<BatchDocuments>
						<xsl:apply-templates select="Batch/BatchDocuments/BatchDocument/Invoice"/>
					</BatchDocuments>
				</Batch>
			</Document>
		</BatchRoot>
	</xsl:template>
	<xsl:template match="Batch/BatchDocuments/BatchDocument/Invoice">
		<BatchDocument>
			<xsl:choose>
				<xsl:when test="starts-with(string(./InvoiceHeader/InvoiceReferences/InvoiceReference),'OP/I')">
					<Invoice>
						<xsl:apply-templates/>
					</Invoice>
				</xsl:when>
				<xsl:otherwise>
					<!--Credit Notes Document-->
					<xsl:call-template name="CreateCreditNotes"/>
				</xsl:otherwise>
			</xsl:choose>
		</BatchDocument>
	</xsl:template>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	<xsl:template match="InvoiceDetail/InvoiceLine">
		<xsl:choose>
			<xsl:when test="starts-with(string(../../InvoiceHeader/InvoiceReferences/InvoiceReference),'OP/I')">
				<xsl:copy>
					<LineNumber><xsl:value-of select="position()"/></LineNumber>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<CreditNoteLine>
					<LineNumber><xsl:value-of select="position()"/></LineNumber>
					<PurchaseOrderReferences>
						<xsl:copy-of select="./PurchaseOrderReferences/PurchaseOrderReference"/>
						<xsl:apply-templates select="./PurchaseOrderReferences/PurchaseOrderDate"/>
					</PurchaseOrderReferences>
					<xsl:copy-of select="./ProductID"/>
					<xsl:copy-of select="./ProductDescription"/>
					<CreditedQuantity>
						<xsl:attribute name="UnitOfMeasure"><xsl:apply-templates select="./InvoicedQuantity/@UnitOfMeasure"/></xsl:attribute>
						<xsl:value-of select="format-number(./InvoicedQuantity, '0.00')"/>
					</CreditedQuantity>
					<xsl:apply-templates select="./UnitValueExclVAT"/>
					<xsl:apply-templates select="./LineValueExclVAT"/>
				</CreditNoteLine>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="InvoiceReferences/InvoiceDate |
									 InvoiceReferences/TaxPointDate |
									 PurchaseOrderReferences/PurchaseOrderDate">
		<xsl:copy>
			<xsl:call-template name="FormatDate">
				<xsl:with-param name="sDate" select="string(.)"/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="FormatDate">
		<xsl:param name="sDate"/>
		<xsl:choose>
			<xsl:when test="string-length($sDate) = 5">
				<xsl:value-of select="concat(20, substring($sDate, 4, 2), '-', substring($sDate, 2, 2), '-', 0, substring($sDate, 1, 1))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(20, substring($sDate, 5, 2), '-', substring($sDate, 3, 2), '-', substring($sDate, 1, 2))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="InvoiceLine/InvoicedQuantity |
									 InvoiceLine/UnitValueExclVAT |
									 InvoiceLine/LineValueExclVAT">
		<xsl:element name="{name()}">
			<xsl:if test="name() = 'InvoicedQuantity'">
				<xsl:attribute name="UnitOfMeasure"><xsl:apply-templates select="./@UnitOfMeasure"/></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="format-number(.,'0.00')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="InvoiceLine/InvoicedQuantity/@UnitOfMeasure">
		<xsl:choose>
			<xsl:when test="string(.) = 'EACH'">EA</xsl:when>
			<xsl:when test="string(.) = 'KG'">KGM</xsl:when>
			<xsl:when test="string(.) = 'CASE'">CS</xsl:when>
			<xsl:otherwise>EA</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="CreateCreditNotes">
		<CreditNote>
			<xsl:copy-of select="TradeSimpleHeader"/>
			<CreditNoteHeader>
				<DocumentStatus>Original</DocumentStatus>
				<xsl:copy-of select="InvoiceHeader/Buyer"/>
				<xsl:copy-of select="InvoiceHeader/Supplier"/>
				<xsl:copy-of select="InvoiceHeader/ShipTo"/>
				<InvoiceReferences>
					<xsl:copy-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					<xsl:apply-templates select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
					<xsl:apply-templates select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
				</InvoiceReferences>
				<CreditNoteReferences>
					<CreditNoteReference>
						<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
					</CreditNoteReference>
					<CreditNoteDate>
						<xsl:call-template name="FormatDate">
							<xsl:with-param name="sDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
						</xsl:call-template>
					</CreditNoteDate>
					<xsl:apply-templates select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
				</CreditNoteReferences>
			</CreditNoteHeader>
			<CreditNoteDetail>
				<xsl:apply-templates select="InvoiceDetail/InvoiceLine"/>
			</CreditNoteDetail>
		</CreditNote>
	</xsl:template>
</xsl:stylesheet>
