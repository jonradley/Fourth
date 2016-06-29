<?xml version="1.0" encoding="UTF-8"?>
<!--
'******************************************************************************************
' Module History
'******************************************************************************************
' Date		    | Name				   | Description of modification
'******************************************************************************************
' 07/05/2013	| Sahir Hussain	   | Created
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:import href="HospitalityInclude.xsl"/>
	<xsl:output method="xml" indent="no" encoding="UTF-8"/>
	<xsl:template match="/">
		<BatchRoot>
				<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->
	<xsl:template match="CreditNoteDetail/CreditNoteLine">
		<xsl:copy>
			<LineNumber><xsl:value-of select="position()"/></LineNumber>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="CreditNoteLine/DeliveryNoteReferences">
		<xsl:variable name="DeliveryNoteDate" select="string(./DeliveryNoteDate)"/>
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:if test="$DeliveryNoteDate != ''">
				<xsl:element name="DespatchDate">
					<xsl:call-template name="fixDate">
						<xsl:with-param name="sDate" select="$DeliveryNoteDate"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Remove the invoice references element if an invoice date has been provided without an invoice reference, or
		an invoice reference has been provided without an invoice date. -->
	<xsl:template match="InvoiceReferences[(InvoiceDate and not(InvoiceReference)) or (InvoiceReference and not(InvoiceDate))]"/>
	<!-- CONVERT TestFlag from Y / N to 1 / 0 -->
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYYYMMDD to xsd:date -->
	<xsl:template match="BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
						CreditNoteReferences/CreditNoteDate |
						CreditNoteReferences/TaxPointDate |
						CreditRequestReferences/CreditRequestDate |
						PurchaseOrderReferences/PurchaseOrderDate |
						DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:copy>
			<xsl:call-template name="fixDate">
				<xsl:with-param name="sDate" select="."/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYYYMMDD:[HHMMSS] to xsd:dateTime YYYY-MM-DDTHH:MM:SS -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 15">
					<!-- Convert YYYYMMDD: to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYYYMMDD:HHMMSS to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T', substring(.,10,2), ':', substring(.,12,2), ':', substring(.,14,2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!--END of DATE CONVERSIONS -->
</xsl:stylesheet>