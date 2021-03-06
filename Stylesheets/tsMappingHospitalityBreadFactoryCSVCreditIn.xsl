<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Date        | Name         | Description of modification
'******************************************************************************************
16/04/2013  | H Robson  | FB:6363 Branched from tsMappingHospitalityCreditSVBatch.xsl
'******************************************************************************************
31/05/2013		| H Robson		| FB:6610 The infiller does not currently recognise that a VATRate of 0 is the same as 0.00; 
	because the input file is inconsistent between line level and VAT trailer, decimals will have to be added in the mapper
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!-- convert VAT codes to T|S -->
	<xsl:template match="VATCode">
		<VATCode>
			<xsl:choose>
				<xsl:when test=". = '2'">Z</xsl:when><!-- zero -->
				<xsl:when test=". = '1'">S</xsl:when><!-- standard -->
				<xsl:when test=". = '0'">E</xsl:when><!-- exempt -->
			</xsl:choose>
		</VATCode>
	</xsl:template>
	<!-- standardise VATRate -->
	<xsl:template match="VATRate">
		<VATRate>
			<xsl:value-of select="format-number(., '0.00')"/>
		</VATRate>
	</xsl:template>
	<xsl:template match="VATSubTotal">
		<VATSubTotal>
			<xsl:attribute name="VATCode"><xsl:value-of select="@VATCode"/></xsl:attribute>
			<xsl:attribute name="VATRate"><xsl:value-of select="format-number(@VATRate, '0.00')"/></xsl:attribute>
			<xsl:apply-templates/>
		</VATSubTotal>
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
	<xsl:template match="CreditNoteDetail/CreditNoteLine">
		<xsl:copy>
			<xsl:element name="LineNumber">
				<xsl:value-of select="vbscript:getLineNumber()"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="CreditNoteHeader">
		<!-- Init our line number counter -->
		<xsl:variable name="dummyVar" select="vbscript:resetLineNumber()"/>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="CreditNoteLine/DeliveryNoteReferences">
		<xsl:variable name="DeliveryNoteDate" select="string(./DeliveryNoteDate)"/>
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:element name="DespatchDate">
				<xsl:value-of select="concat(substring($DeliveryNoteDate, 1, 4), '-', substring($DeliveryNoteDate, 5, 2), '-', substring($DeliveryNoteDate, 7, 2))"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<!-- Remove the invoice references element if an invoice date has been provided without an invoice reference, or
		an invoice reference has been provided without an invoice date. -->
	<xsl:template match="InvoiceReferences[(InvoiceDate and not(InvoiceReference)) or (InvoiceReference and not(InvoiceDate))]">
	</xsl:template>
	<!-- CONVERT TestFlag from Y / N to 1 / 0 -->
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<!-- Is NOT TEST: found an N char, map to '0' -->
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Is TEST: map anything else to '1' -->
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
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
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
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Dim lLineNumber
		
		Function resetLineNumber()
			lLineNumber = 1
			resetLineNumber = 1
		End Function
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
]]></msxsl:script>
</xsl:stylesheet>
