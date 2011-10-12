<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal invoices and credits into a csv format to be compiled into
 the monthly archive report for Harrison Catering

 © Alternative Business Solutions Ltd., 2006.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 12/01/2007 | A Sheppard 	| Created module.
******************************************************************************************
 25/01/2007 | A Sheppard	| 755. Post-live format changes
******************************************************************************************
 14/07/2010	| Andrew Barber | 3756: Send only customer head office code from ShipTo/../BuyersCode before '#' where exists.
 ******************************************************************************************
 
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:user="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">

		<xsl:variable name="NewLine">
			<xsl:text>&#13;&#10;</xsl:text>
		</xsl:variable>

		<!--Header Line-->
		<xsl:text>"H"</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:choose><xsl:when test="Invoice"><xsl:text>"Invoice"</xsl:text></xsl:when><xsl:otherwise>"Credit"</xsl:otherwise></xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#') = ''">
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//TradeSimpleHeader/RecipientsCodeForSender"/></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#')"/></xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference | //InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DocumentStatus"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//BatchInformation/FileGenerationNo"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//BatchInformation/FileVersionNo"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//BatchInformation/FileCreationDate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//BatchInformation/SendersTransmissionReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//BatchInformation/SendersTransmissionDate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersLocationID/BuyersCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Buyer/BuyersAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersLocationID/BuyersCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Supplier/SuppliersAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(//ShipTo/ShipToLocationID/BuyersCode,'#')">
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="substring-before(//ShipTo/ShipToLocationID/BuyersCode,'#')"/></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToLocationID/BuyersCode"/></xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToName"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToAddress/AddressLine1"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToAddress/AddressLine2"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToAddress/AddressLine3"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToAddress/AddressLine4"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//ShipTo/ShipToAddress/PostCode"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//CreditNoteReferences/CreditNoteReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//CreditNoteReferences/CreditNoteDate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//InvoiceReferences/InvoiceReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//InvoiceReferences/InvoiceDate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="//TaxPointDate[1]"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//VATRegNo[1]"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//Currency"/></xsl:call-template>
		
		<!--Detail Lines-->
		<xsl:for-each select="//InvoiceLine | //CreditNoteLine">
			<xsl:value-of select="$NewLine"/>
			<xsl:text>"L"</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:choose><xsl:when test="//Invoice"><xsl:text>"Invoice"</xsl:text></xsl:when><xsl:otherwise>"Credit"</xsl:otherwise></xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#') = ''">
					<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//TradeSimpleHeader/RecipientsCodeForSender"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#')"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference | //InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineNumber"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="CreditRequestReferences/CreditRequestReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="PurchaseOrderReferences/PurchaseOrderReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="PurchaseOrderReferences/PurchaseOrderDate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="DeliveryNoteReferences/DeliveryNoteReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="formatDate"><xsl:with-param name="xmlDate" select="DeliveryNoteReferences/DeliveryNoteDate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="ProductID/SuppliersProductCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="ProductDescription"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:choose><xsl:when test="CreditedQuantity"><xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="CreditedQuantity"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="InvoicedQuantity"/></xsl:call-template></xsl:otherwise></xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="PackSize"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="UnitValueExclVAT"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineValueExclVAT"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineDiscountRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineDiscountValue"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="VATCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="VATRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="Narrative"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineExtraData/CataloguePrice"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="LineExtraData/CataloguePackSize"/></xsl:call-template>
		</xsl:for-each>
		
		<!--VAT Subtotal Lines-->
		<xsl:for-each select="//VATSubTotal">
			<xsl:value-of select="$NewLine"/>
			<xsl:text>"V"</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:choose><xsl:when test="//Invoice"><xsl:text>"Invoice"</xsl:text></xsl:when><xsl:otherwise>"Credit"</xsl:otherwise></xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:choose>
				<xsl:when test="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#') = ''">
					<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//TradeSimpleHeader/RecipientsCodeForSender"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#')"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference | //InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="@VATCode"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="@VATRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="NumberOfLinesAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="NumberOfItemsAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="DiscountedLinesTotalExclVATAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="DocumentDiscountAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="DocumentTotalExclVATAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="SettlementTotalExclVATAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="SettlementDiscountAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="VATAmountAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="DocumentTotalInclVATAtRate"/></xsl:call-template>
			<xsl:text>,</xsl:text>
			<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="SettlementTotalInclVATAtRate"/></xsl:call-template>
		</xsl:for-each>
		
		<!--Trailer Line-->
		<xsl:value-of select="$NewLine"/>
		<xsl:text>"T"</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:choose><xsl:when test="//Invoice"><xsl:text>"Invoice"</xsl:text></xsl:when><xsl:otherwise>"Credit"</xsl:otherwise></xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:choose>
			<xsl:when test="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#') = ''">
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//TradeSimpleHeader/RecipientsCodeForSender"/></xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="substring-after(//TradeSimpleHeader/RecipientsCodeForSender,'#')"/></xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference | //InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//NumberOfLines"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//NumberOfItems"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DocumentDiscountRate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//SettlementDiscountRate"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//SettlementDiscountRate/@SettlementDiscountDays"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DiscountedLinesTotalExclVAT"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DocumentDiscount"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DocumentTotalExclVAT"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//SettlementDiscount"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//SettlementTotalExclVAT"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//VATAmount"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//DocumentTotalInclVAT"/></xsl:call-template>
		<xsl:text>,</xsl:text>
		<xsl:call-template name="convertForCSV"><xsl:with-param name="stringToConvert" select="//SettlementTotalInclVAT"/></xsl:call-template>
		
	</xsl:template>
			
	<!-- translates a date in YYYY-MM-DD format to a date in "DD/MM/YYYY" format -->
	<xsl:template name="formatDate">
		<xsl:param name="xmlDate"/>
		<xsl:text>"</xsl:text>	
		<xsl:if test="$xmlDate">
			<xsl:value-of select="substring($xmlDate,9,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($xmlDate,6,2)"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="substring($xmlDate,1,4)"/>
		</xsl:if>
		<xsl:text>"</xsl:text>	
	</xsl:template>
	
	<!--adds quotes and converts existing quotes into a pair of quotes-->
	<xsl:template name="convertForCSV">
		<xsl:param name="stringToConvert"/>
		<xsl:text>"</xsl:text>	
		<xsl:call-template name="convertQuotes">
			<xsl:with-param name="stringToConvert" select="$stringToConvert"/>
		</xsl:call-template>
		<xsl:text>"</xsl:text>	
	</xsl:template>
	
	<xsl:template name="convertQuotes">
		<xsl:param name="stringToConvert"/>
		<xsl:choose>
			<xsl:when test="$stringToConvert=''"/><!-- base case-->
			<xsl:when test="substring($stringToConvert,1,1)='&quot;'"><!-- " found -->
				<xsl:value-of select="substring($stringToConvert,1,1)"/>
				<xsl:value-of select="'&quot;'"/>				
				<xsl:call-template name="convertQuotes">
					<xsl:with-param name="stringToConvert" select="substring($stringToConvert,2)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><!-- other character -->
				<xsl:value-of select="substring($stringToConvert,1,1)"/>
				<xsl:call-template name="convertQuotes">
					<xsl:with-param name="stringToConvert" select="substring($stringToConvert,2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
</xsl:stylesheet>