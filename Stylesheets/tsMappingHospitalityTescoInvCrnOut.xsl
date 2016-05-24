<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
Tesco outbound mapper for invoices and credit notes.
This mapper is only prepared to process an invoice or a credit note.
******************************************************************************************
 Module History
******************************************************************************************
 Date				| Name		| Description of modification
******************************************************************************************
 24/05/2016	| J Miguel	| FB11018 - Created
******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//Invoice/InvoiceTrailer | //CreditNote/CreditNoteTrailer"/>
	</xsl:template>
	<!-- Process a file with an Invoice -->
	<xsl:template match="InvoiceTrailer">
		<xsl:call-template name="createLine">
			<xsl:with-param name="Type" select="'STANDARD'"/>
			<xsl:with-param name="LineNum" select="position()"/>
			<xsl:with-param name="LineType" select="'Tax'"/>
			<xsl:with-param name="Amount" select="number(VATAmount)"/>
			<xsl:with-param name="TaxCode" select="number(0)"/>
			<xsl:with-param name="NominalCode" select="'20400'"/>
		</xsl:call-template>
		<xsl:for-each select="VATSubTotals/VATSubTotal">
			<xsl:call-template name="createLine">
				<xsl:with-param name="Type" select="'STANDARD'"/>
				<xsl:with-param name="LineNum" select="position()"/>
				<xsl:with-param name="LineType" select="'Item'"/>
				<xsl:with-param name="Amount" select="number(DocumentTotalExclVATAtRate)"/>
				<xsl:with-param name="TaxCode" select="number(@VATRate)"/>
				<xsl:with-param name="NominalCode" select="'23220'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Process a file with a credit note -->
	<xsl:template match="CreditNoteTrailer">
		<xsl:call-template name="createLine">
			<xsl:with-param name="Type" select="'CREDIT'"/>
			<xsl:with-param name="LineNum" select="position()"/>
			<xsl:with-param name="LineType" select="'Tax'"/>
			<xsl:with-param name="Amount" select="-number(VATAmount)"/>
			<xsl:with-param name="TaxCode" select="number(0)"/>
			<xsl:with-param name="NominalCode" select="'20400'"/>
		</xsl:call-template>
		<xsl:for-each select="VATSubTotals/VATSubTotal">
			<xsl:call-template name="createLine">
				<xsl:with-param name="Type" select="'CREDIT'"/>
				<xsl:with-param name="LineNum" select="position()"/>
				<xsl:with-param name="LineType" select="'Item'"/>
				<xsl:with-param name="Amount" select="'DocumentTotalExclVATAtRate'"/>
				<xsl:with-param name="TaxCode" select="number(@VATRate)"/>
				<xsl:with-param name="NominalCode" select="'23220'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Create a line in the export -->
	<xsl:template name="createLine">
		<xsl:param name="Type"/>
		<xsl:param name="LineNum"/>
		<xsl:param name="LineType"/>
		<xsl:param name="Amount"/>
		<xsl:param name="TaxCode"/>
		<xsl:param name="NominalCode"/>
		
		<!-- A - Type - 2 export files are produced. -->
		<xsl:value-of select="$Type"/>
		<xsl:text>,</xsl:text>
		<!-- B - Supplier Name - To start with we will only have ‘Bidvest’ as a supplier that will send in EDI invoices. -->
		<xsl:value-of select="//Supplier/SuppliersName"/>
		<xsl:text>,</xsl:text>
		<!-- C - Supplier Number - To start with we will only have ‘Bidvest’ as a supplier that will send in EDI invoices. -->
		<xsl:value-of select="//Supplier/SuppliersLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<!-- D - Site - This code is relating the Supplier address and is fixed for each supplier -->
		<xsl:value-of select="//ShipTo/ShipToLocationID/BuyersCode"/>
		<xsl:text>,</xsl:text>
		<!-- E - Date Invoice Received - This will be the date that the electronic Invoice has arrived / loaded into Trade Simple DD/MM/YYYY -->
		<xsl:value-of select="script:getFormattedDate(string(//SendersTransmissionDate))"/>
		<xsl:text>,</xsl:text>
		<!-- F - Invoice Date - The date the supplier has included on the Invoice. -->
		<xsl:value-of select="script:getFormattedDate(string(//InvoiceReferences/InvoiceDate))"/>
		<xsl:text>,</xsl:text>
		<!-- G - Invoice Number - Supplier Invoice Number -->
		<xsl:value-of select="//InvoiceReferences/InvoiceReference"/>
		<xsl:text>,</xsl:text>
		<!-- H - Line Num - Every invoice line will have its own line number. (1...n) -->
		<xsl:value-of select="$LineNum"/>
		<xsl:text>,</xsl:text>
		<!-- I - Line Type - Each row is identified as either a Tax or Item row. (invoice lines are split into Item and tax) -->
		<xsl:value-of select="$LineType"/>
		<xsl:text>,</xsl:text>
		<!-- J - Invoice Currency - Fixed -->
		<xsl:value-of select="//Currency"/>
		<xsl:text>,</xsl:text>
		<!-- K - Invoice Amount - Positive amounts for Invoice row -->
		<xsl:value-of select="$Amount"/>
		<xsl:text>,</xsl:text>
		<!-- L - Voucher Number - No data -->
		<xsl:text>,</xsl:text>
		<!-- M - Tax Code -  -->
		<xsl:value-of select="format-number($TaxCode div 100, '0.#')"/>
		<xsl:text>,</xsl:text>
		<!-- N - Tax Amount - No data -->
		<xsl:text>,</xsl:text>
		<!-- O - Additional Comment - No data -->
		<xsl:text>,</xsl:text>
		<!-- P - Distribution - See table below for components of the code -->
		<!-- Company code -->
		<xsl:value-of select="//STXSupplierCode"/>
		<xsl:text>.</xsl:text>
		<!-- Nominal code -->
		<xsl:value-of select="$NominalCode"/>
		<xsl:text>.</xsl:text>
		<!-- Cost centre - RecipientsBranchReference- -->
		<xsl:value-of select="//RecipientsBranchReference"/>
		<xsl:text>.</xsl:text>
		<!-- Cost Centre Type - Fixed always display ‘0000’ -->
		<xsl:text>0000</xsl:text>
		<xsl:text>.</xsl:text>
		<!-- Product - Fixed always display ‘Z00’ -->
		<xsl:text>Z00</xsl:text>
		<xsl:text>.</xsl:text>
		<!-- Project - Fixed always display ‘Z00000’ -->
		<xsl:text>Z00000</xsl:text>
		<xsl:text>.</xsl:text>
		<!-- Intercompany - Fixed always display ‘000’ -->
		<xsl:text>000</xsl:text>
		<xsl:text>.</xsl:text>
		<!-- Local - Fixed always display ‘00000’  -->
		<xsl:text>00000</xsl:text>
		<xsl:text>&#13;&#10;</xsl:text>
	</xsl:template>
	<msxsl:script language="Javascript" implements-prefix="script"><![CDATA[
	function getFormattedDate(input) 
	{
		var pattern = /(.{4})-(.{2})-(.{2}).*$/;
		var result = input.replace(pattern, function(match, p1, p2, p3)
			{
				var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
				return p3 + "-" + months[(p2-1)] + "-" + p1;
			}
		);
		return result;
	}
]]></msxsl:script>
</xsl:stylesheet>
