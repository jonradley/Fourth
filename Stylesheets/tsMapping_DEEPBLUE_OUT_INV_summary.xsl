<?xml version="1.0" encoding="UTF-8"?>
<!--
======================================================================================================================
 Overview
======================================================================================================================
 09/01/2014	| J Miguel	|	FB7610 - Deep Blue / FnB (R9) - Invoice and Credit Journal Entries Batch Report | Created
 15/01/2014	| J Miguel	|	FB7628 - Fixing the padding space.
======================================================================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://mycompany.com/mynamespace">
	<xsl:output method="text"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	<!--Get rid of this template if the header is not required finally-->
	<xsl:template match="/">
		<xsl:apply-templates select="//InvoiceCreditJournalEntriesLine"/>
	</xsl:template>
	<xsl:template match="InvoiceCreditJournalEntriesLine">
		<!-- Account	C	8		Purchase Supplier Account Code/Identifier -->
		<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/SupplierNominalCode, ',', '')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Reference	C	10		Usually Invoice Number -->
		<xsl:value-of select="translate(../../InvoiceCreditJournalEntriesHeader/InvoiceReference, ',', '')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Date	D	10		Invoice Date DD/MM/YYYY -->
		<xsl:value-of select="user:gsFormatDateToDDMMYYYY(../../InvoiceCreditJournalEntriesHeader/InvoiceDate)"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Stock Ref	C	16 left blank! -->
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Description	C	40		Description of the goods - the current mapping for this one has to be reviewed (do they want all the categories?) -->
		<xsl:value-of select="translate(CategoryName, ',', '')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Quantity	N	12	2	Quantity of the goods. Set to 1. -->
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Goods	N	12	2	Goods value -->
		<xsl:value-of select="format-number(LineNet, '0.00')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VAT Code	C	1 -->
		<xsl:value-of select="VATCode"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- VAT Amount	N	12	2	Vat amount -->
		<xsl:value-of select="format-number(LineVAT, '0.00')"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Supply Code	C	8 -->
		<xsl:value-of select="concat(translate(CategoryNominal, ',', ' '), concat('    ', ../../InvoiceCreditJournalEntriesHeader/BuyersUnitCode))"/>
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Project	C	8 - not used -->
		<!--<xsl:value-of select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>-->
		<xsl:value-of select="$FieldSeperator"/>
		<!-- Department	C	8 - not used -->
		<!--<xsl:value-of select="InvoiceCreditJournalEntries/InvoiceCreditJournalEntriesHeader/UnitSiteNominal"/>-->
		<xsl:value-of select="$RecordSeperator"/>
	</xsl:template>
	<msxsl:script language="JScript" implements-prefix="user"><![CDATA[ 
		function gsFormatDateToDDMMYYYY(vsDate)
		{
			var dtDate = Get1stValue(vsDate);
			try
			{
				if(dtDate.length >= 10)
				{
					if(dtDate.indexOf('T') == -1)
						return dtDate.substr(8,2) + "/" +dtDate.substr(5,2) + "/" + dtDate.substr(0,4);
					else
						return dtDate.substr(8,2) + "/" +dtDate.substr(5,2) + "/" + dtDate.substr(0,4) + ' ' + dtDate.substr(11);
				}
				else
				{
					return '';
				}
			}
			catch (e)
			{
				 return e;
			}
		}
		
		function Get1stValue (nodes)
		{
			if (typeof(nodes) == 'string')
			{
				return nodes;
			}
			else
			{
				return nodes[0].text;
			}
		}
	]]></msxsl:script>
</xsl:stylesheet>
