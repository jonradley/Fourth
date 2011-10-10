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
 01/06/2007		| R Cambridge    | 1109 Created Module
******************************************************************************************
 23/07/2007		| R Cambridge		| 1317 Ensure invoice reference is always 10 digits (pad with 0s on the LHS)
******************************************************************************************
 07/03/2008		| R Cambridge		| 2050 Add dummy invoice date when none is given to ensure validation fails
******************************************************************************************
			  		|                |
***************************************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>

	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
<BatchRoot>
		<xsl:apply-templates/>
</BatchRoot>
	</xsl:template>
	
	<xsl:template match="BatchDocuments">
		<xsl:copy>
			<xsl:for-each select="BatchDocument[position()!=1]">
				<xsl:copy>
					<xsl:attribute name="DocumentTypeNo">86</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:copy>			
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceDetail/InvoiceLine">
	
		<InvoiceLine>
		
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="ProductDescription"/>
			<xsl:apply-templates select="InvoicedQuantity"/>
			
			<UnitValueExclVAT><xsl:value-of select="format-number(LineValueExclVAT div InvoicedQuantity,'0.00')"/></UnitValueExclVAT>
			
			<xsl:apply-templates select="LineValueExclVAT"/>
			<xsl:apply-templates select="VATCode"/>
			<xsl:apply-templates select="VATRate"/>		

		</InvoiceLine>
		
	</xsl:template>
	
	<xsl:template match="InvoiceHeader">
		<!-- Init our line number counter -->
		<xsl:variable name="dummyVar" select="vbscript:resetLineNumber()"/>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceReferences/InvoiceReference">
		<xsl:copy>
			<xsl:value-of select="substring(concat('0000000000',.),10 - (9 - string-length(.)))"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceReferences">
	
		<xsl:copy>
	
			<xsl:apply-templates select="*"/>
			
			<xsl:if test="not(InvoiceDate | TaxPointDate)">
			
				<InvoiceDate>0000-00-00</InvoiceDate>
				
				<TaxPointDate>0000-00-00</TaxPointDate>	
			
			</xsl:if>
			
		</xsl:copy>
		

		
	</xsl:template>
	
	<xsl:template match="InvoiceLine/DeliveryNoteReferences">
		<xsl:variable name="DeliveryNoteDate" select="string(./DeliveryNoteDate)"/>
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:element name="DespatchDate">
				<xsl:value-of select="concat(substring($DeliveryNoteDate, 1, 4), '-', substring($DeliveryNoteDate, 5, 2), '-', substring($DeliveryNoteDate, 7, 2))"/>
			</xsl:element>
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
						InvoiceReferences/TaxPointDate |
						PurchaseOrderReferences/PurchaseOrderDate |
						DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:copy>
			<xsl:value-of select="concat(substring(., 7, 4), '-', substring(., 4, 2), '-', substring(., 1, 2))"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- DATE CONVERSION YYYYMMDD:[HHMMSS] to xsd:dateTime YYYY-MM-DDTHH:MM:SS -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 15">
					<!-- Convert YYYYMMDD: to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 7, 4), '-', substring(., 4, 2), '-', substring(., 1, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYYYMMDD:HHMMSS to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 7, 4), '-', substring(., 4, 2), '-', substring(., 1, 2), 'T', substring(.,10,2), ':', substring(.,12,2), ':', substring(.,14,2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!--END of DATE CONVERSIONS -->
	
	<xsl:template match="VATCode">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test=".='1'">S</xsl:when>
				<xsl:when test=".='2'">Z</xsl:when>
				<xsl:otherwise>L</xsl:otherwise>
			</xsl:choose>		
		</xsl:copy>
	</xsl:template>
	
	
	
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