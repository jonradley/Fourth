<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a Saffron csv format for Harrison Catering.
 The csv files will be concatenated by a subsequent processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 30/01/2009	| Rave Tech		| Created Module
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.-->
	<xsl:key name="keyLinesByVATCode" match="InvoiceTrailer/VATSubTotals/VATSubTotal | CreditNoteTrailer/VATSubTotals/VATSubTotal" use="concat(@VATCode,generate-id(../../..))"/>
	
	<xsl:template match="/BatchRoot/Invoice | /BatchRoot/CreditNote">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--### HEADER LINE ###-->
		<xsl:text>INVHEAD,</xsl:text>
		
		<!-- Invoice Number -->
		<xsl:value-of select="substring(InvoiceHeader/InvoiceReferences/InvoiceReference | CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
		<xsl:text>,</xsl:text>

		<!-- Invoice Date -->
		<xsl:choose>
			<xsl:when test="/BatchRoot/CreditNote">
				<xsl:value-of select="script:msFormatDate(CreditNoteHeader/CreditNoteReferences/CreditNoteDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="script:msFormatDate(InvoiceHeader/InvoiceReferences/InvoiceDate)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- Supplier Code -->
		<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
		<xsl:text>,</xsl:text>
		
		<!-- Unit Code -->
		<xsl:value-of select="substring(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode| CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,1,10)"/>
		<xsl:text>,</xsl:text>

		<!-- Number of Deliveries -->
		<xsl:value-of select="InvoiceTrailer/NumberOfDeliveries | CreditNoteTrailer/NumberOfDeliveries"/>
		<xsl:text>,</xsl:text>

		<!-- Lines Total Ex VAT -->
		<xsl:choose>
			<xsl:when test="/BatchRoot/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalExclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/DocumentTotalExclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		
		<!-- Tax Amount Total -->
		<xsl:choose>
			<xsl:when test="/BatchRoot/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/VATAmount,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/VATAmount,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>

		<!-- Total Payable -->
		<xsl:choose>
			<xsl:when test="/BatchRoot/Invoice">
				<xsl:value-of select="format-number(InvoiceTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(-1 * CreditNoteTrailer/DocumentTotalInclVAT,'0.00')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>

		<!-- Original Invoice Number -->
		<xsl:value-of select="substring(CreditNoteHeader/InvoiceReferences/InvoiceReference,1,20)"/>

		<!--### VAT LINES ###-->
		<!-- use the keys for grouping Lines by VAT Code -->
		<xsl:for-each select="(InvoiceTrailer/VATSubTotals/VATSubTotal | CreditNoteTrailer/VATSubTotals/VATSubTotal)">
			<xsl:sort select="@VATCode" data-type="text"/>
			<xsl:variable name="VATCode" select="@VATCode"/>
			<xsl:if test="generate-id() = generate-id(key('keyLinesByVATCode', concat($VATCode,generate-id(../../..))))">					
				<xsl:value-of select="$NewLine"/>
				<xsl:text>INVTAX,</xsl:text>
	
				<xsl:value-of select="substring(../../../InvoiceHeader/InvoiceReferences/InvoiceReference | 	../../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
				<xsl:text>,</xsl:text>
				
				<xsl:value-of select="substring($VATCode,1,10)"/>
				<xsl:text>,</xsl:text>
	
				<xsl:choose>
					<xsl:when test="/BatchRoot/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= 	$VATCode]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
			
				<xsl:choose>
					<xsl:when test="/BatchRoot/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode]/VATAmountAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode]/VATAmountAtRate),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>

		<!--### ITEM LINES ###-->
		<xsl:for-each select="(InvoiceDetail/InvoiceLine | CreditNoteDetail/CreditNoteLine)">

			<xsl:value-of select="$NewLine"/>
			<xsl:text>INVITEM,</xsl:text>

			<xsl:value-of select="substring(../../InvoiceHeader/InvoiceReferences/InvoiceReference | ../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PurchaseOrderReferences/PurchaseOrderReference,1,13)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(../../InvoiceHeader/InvoiceReferences/InvoiceReference | ../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductID/SuppliersProductCode,1,20)"/>

			<!--Suffix 'X' to product code when invoice price is 50% different (more or less) from Catalogue price-->
			<xsl:if test="LineExtraData/CataloguePrice">
				<xsl:variable name="FiftyPercentCP">
					<xsl:value-of select="0.5 * LineExtraData/CataloguePrice"/>
				</xsl:variable>
				<xsl:variable name="OneFiftyPercentCP">
					<xsl:value-of select="1.5 * LineExtraData/CataloguePrice"/>
				</xsl:variable>

				<xsl:if test="UnitValueExclVAT &lt; $FiftyPercentCP or UnitValueExclVAT &gt; $OneFiftyPercentCP">
					<xsl:text>X</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:text>,</xsl:text>

			<xsl:choose>
				<xsl:when test="/BatchRoot/Invoice">
					<xsl:value-of select="format-number(InvoicedQuantity,'0.000')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * CreditedQuantity,'0.000')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="format-number(UnitValueExclVAT,'0.00')"/>
			<xsl:text>,</xsl:text>

			<xsl:choose>
				<xsl:when test="/BatchRoot/Invoice">
					<xsl:value-of select="format-number(LineValueExclVAT,'0.00')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(-1 * LineValueExclVAT,'0.00')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(VATCode,1,10)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(ProductDescription,1,50)"/>
			<xsl:text>,</xsl:text>

			<xsl:value-of select="substring(PackSize,1,20)"/>
			
		</xsl:for-each>
		<xsl:value-of select="$NewLine"/>	
	</xsl:template>
		
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 

		/*=========================================================================================
		' Routine       	 : msFormatDate
		' Description 	 : Formats the date
		' Inputs          	 : Date in yyyy-mm-dd format
		' Outputs       	 : None
		' Returns       	 : Date in "dd/mm/yyyy" format
		' Author       		 : A Sheppard, 23/08/2004.
		' Alterations   	 : 
		'========================================================================================*/
		function msFormatDate(vsDate)
		{
			if(vsDate.length > 0)
			{
				vsDate = vsDate(0).text;
				return vsDate.substr(0,4) + "" +vsDate.substr(5,2) + "" + vsDate.substr(8,2);
			}
			else
			{
				return '';
			}
		}

	]]></msxsl:script>
</xsl:stylesheet>