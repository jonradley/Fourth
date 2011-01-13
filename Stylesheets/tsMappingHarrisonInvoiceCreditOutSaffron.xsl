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
 30/03/2009	| Lee Boyton	| 2817. If the RCS contains a # character then take the string after the #.
******************************************************************************************
 24/06/2009	| Lee Boyton	| 2957. Strip newline characters from packsize field,
                                | as these cause an additional blank line to appear in final output
******************************************************************************************
 26/02/2010	| Graham Neicho | 3383. Removed hard coded X suffix to product code for when invoice price is more than 50% different from catalogue price.
******************************************************************************************
 14/07/2010	| Andrew Barber | 3756: Send only customer head office code from RecipientsBranchReference before '#' where exists.
 ******************************************************************************************
 13/10/2010	| KO | 3950: Strip out spurious characters from the product description
******************************************************************************************

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:script="http://mycompany.com/mynamespace" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.-->
	<xsl:key name="keyLinesByVATCode" match="InvoiceTrailer/VATSubTotals/VATSubTotal | CreditNoteTrailer/VATSubTotals/VATSubTotal" use="concat(@VATCode,number(@VATRate),generate-id(../../..))"/>
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
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsCodeForSender,'#')">
				<xsl:value-of select="substring(substring-after(TradeSimpleHeader/RecipientsCodeForSender,'#'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsCodeForSender,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<!-- Unit Code -->
		<xsl:choose>
			<xsl:when test="contains(TradeSimpleHeader/RecipientsBranchReference,'#')">
				<xsl:value-of select="substring(substring-before(TradeSimpleHeader/RecipientsBranchReference,'#'),1,10)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring(TradeSimpleHeader/RecipientsBranchReference,1,10)"/>
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:variable name="VATRate" select="@VATRate"/>
			<xsl:if test="generate-id() = generate-id(key('keyLinesByVATCode', concat($VATCode,number($VATRate),generate-id(../../..))))">
				<xsl:value-of select="$NewLine"/>
				<xsl:text>INVTAX,</xsl:text>
				<xsl:value-of select="substring(../../../InvoiceHeader/InvoiceReferences/InvoiceReference | 	../../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference,1,20)"/>
				<xsl:text>,</xsl:text>
				<xsl:choose>
					<xsl:when test="substring($VATCode,1,1) = 'L'">S</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring($VATCode,1,1)"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="number($VATRate) = 20.0">20</xsl:when>
					<xsl:when test="number($VATRate) = 17.5">17.5</xsl:when>
					<xsl:when test="number($VATRate) = 15">15</xsl:when>
					<xsl:when test="number($VATRate) = 5">5</xsl:when>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				<xsl:choose>
					<xsl:when test="/BatchRoot/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/DocumentTotalExclVATAtRate),'0.00')"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,</xsl:text>
				<xsl:choose>
					<xsl:when test="/BatchRoot/Invoice">
						<xsl:value-of select="format-number(sum(../../../InvoiceTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/VATAmountAtRate),'0.00')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteTrailer/VATSubTotals/VATSubTotal[@VATCode= $VATCode and number(@VATRate) = number($VATRate)]/VATAmountAtRate),'0.00')"/>
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
			<xsl:choose>
				<xsl:when test="substring(VATCode,1,1) = 'L'">S</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(VATCode,1,1)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="number(VATRate) = 20.0">20</xsl:when>
				<xsl:when test="number(VATRate) = 17.5">17.5</xsl:when>
				<xsl:when test="number(VATRate) = 15">15</xsl:when>
				<xsl:when test="number(VATRate) = 5">5</xsl:when>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="characterStrip">
				<xsl:with-param name="inputText" select="substring(ProductDescription,1,50)"/>
			</xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="substring(normalize-space(PackSize),1,20)"/>
		</xsl:for-each>
		<xsl:value-of select="$NewLine"/>
	</xsl:template>
	<!-- Harrisons have asked us to remove spurious characters in the product description exluding the character defined in the template-->
	<xsl:template name="characterStrip">
		<xsl:param name="inputText"/>
		<xsl:choose>
			<xsl:when test="$inputText = ''"/>
			<xsl:otherwise>
				<xsl:variable name="firstCharacter" select="substring($inputText,1,1)"/>
				<xsl:choose>
					<xsl:when test="translate($firstCharacter,'-/','') = ''">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="translate($firstCharacter,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890() ','') = ''">
						<xsl:value-of select="$firstCharacter"/>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="characterStrip">
					<xsl:with-param name="inputText" select="substring($inputText,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
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
