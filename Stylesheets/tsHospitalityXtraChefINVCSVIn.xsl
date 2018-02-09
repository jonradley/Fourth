<?xml version="1.0" encoding="UTF-8"?>
<!--***************************************************************************************
Overview

Maps XtraChef CSV Invoices to internal XML
 
******************************************************************************************
 Module History
******************************************************************************************
 Date 			| Name           | Description of modification
******************************************************************************************
 29/03/2017		| M Dimant	    | FB 11652 - Created.
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt">

<xsl:output method="xml" encoding="UTF-8"/>
<xsl:strip-space elements="*" />


	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	<!-- Copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">	
			<xsl:copy>
				<xsl:apply-templates/>
			</xsl:copy>			
	</xsl:template>		
	
		
	<!-- Ensure we remove first invoice in the batch which values contain only headers -->
	<xsl:template match="
	BatchDocument[Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference='Invoice Number'] |
	BatchDocument[Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate='Invoice Date'] |
	BatchDocument[Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode='Vendor Code']"/>
	

	<!--Underneath each LineValueExclVAT, create Exempt VATCode and VATRate tags -->
	<xsl:template match="LineValueExclVAT">
		<LineValueExclVAT><xsl:value-of select="."/></LineValueExclVAT>
		<VATCode>E</VATCode>
		<VATRate>0.00</VATRate>		
	</xsl:template>

	<!-- Date/Time Conversion: MM/DD/YYYY to YYYY-MM-DD -->
	<xsl:template match="PurchaseOrderDate |  InvoiceDate | TaxPointDate">
		<xsl:copy>		
			<xsl:value-of select="concat(substring(., 7, 4), '-', substring(., 1, 2), '-', substring(., 4, 2))"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>