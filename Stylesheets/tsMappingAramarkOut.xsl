<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************
 Overview

 Maps internal GRNs into a Aramark fixed width format.
 The files will be concatenated by the outbound batch processor.

 © Alternative Business Solutions Ltd., 2008.
******************************************************************************************
 Module History
******************************************************************************************
 Date       	| Name       		| Description of modification
******************************************************************************************
 07/05/2008	| A Sheppard	| Created Module
******************************************************************************************
 05/05/2009	| Lee Boyton	| 2863. All numerical line values should be output
                    |                          | as positive numbers as there is a separate flag
                    |                          | to indicate return/credit lines.
 ******************************************************************************************
 14/05/2009	| Rave Tech		| 2880. summed the line values to show in  Field #41 and formatted to show - sign in case of negative number.              
******************************************************************************************
 18/08/2009	| Rave Tech		| 3047. Handle negative value totals       
******************************************************************************************
 18/08/2009	| Rave Tech		| 3066. TotalExclVAT value for  Field #41    
******************************************************************************************
28/07/2010	| Sandeep Sehgal		| 3792. Now handles Invoices and Crediot Notes also  
******************************************************************************************
28/07/2010	| Sandeep Sehgal		| 3792. Document Total Invoice mapping corrected for Invoice/Credit Note
******************************************************************************************
24/09/2010	| Sandeep Sehgal		| 3792. If PO/DN date are missing for Inv/CN then replace with Inv/CN date
******************************************************************************************
01/11/2010	| Sandeep Sehgal		| 3989. Mapping for Invoice and CN Ref corrected. Changed from padding '0' to space
******************************************************************************************
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		   xmlns:script="http://mycompany.com/mynamespace"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="#default xsl msxsl script">
	<xsl:output method="text"/>
	<xsl:include href="HospitalityInclude.xsl"/>

	<xsl:template match="/">

		<xsl:for-each select="//GoodsReceivedNoteLine">
			<xsl:if test="script:mbIsNotFirstLine()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
			<xsl:text>3</xsl:text>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(translate(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 10)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToName, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine1, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine2, 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/AddressLine4, 30)"/>
			<xsl:value-of select="script:msPad('', 2)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/ShipTo/ShipToAddress/PostCode, 10)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPad('United Kingdom', 30)"/>
			<xsl:text>G-</xsl:text><xsl:value-of select="script:msPadNumber(/GoodsReceivedNote/GoodsReceivedNoteHeader/GoodsReceivedNoteReferences/GoodsReceivedNoteReference, 13, 0)"/>		
			<xsl:choose>
				<xsl:when test="/GoodsReceivedNote/GoodsReceivedNoteHeader/InvoiceDates/InvoiceDate !=''">
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/InvoiceDates/InvoiceDate"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode, 20)"/>
			<xsl:value-of select="script:msPad(AcceptedQuantity/@UnitOfMeasure, 10)"/>
			<xsl:value-of select="script:msPadNumber(0, 9, 0)"/>
			<xsl:value-of select="script:msPad(PackSize, 15)"/>
			<xsl:value-of select="script:msPadNumber(AcceptedQuantity * (1 - 2 * (AcceptedQuantity &lt; 0)), 7, 2)"/>
			<xsl:value-of select="script:msPadNumber(UnitValueExclVAT * (1 - 2 * (UnitValueExclVAT &lt; 0)), 10, 4)"/>
			<xsl:value-of select="script:msPadNumber(LineValueExclVAT * (1 - 2 * (LineValueExclVAT &lt; 0)), 9, 2)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Manufacturer, 40)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Brand, 40)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		  	<xsl:choose>
				<xsl:when test="ProductID/GTIN and ProductID/GTIN != '55555555555555' and Product/GTIN != '0000000000000'">
					<xsl:value-of select="script:msPad(ProductID/GTIN, 15)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('', 15)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad(ProductDescription, 75)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('N', 1)"/>
			<xsl:choose>
				<xsl:when test="LineValueExclVAT &lt; 0">
					<xsl:value-of select="script:msPad('Y', 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('N', 1)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msGetCurrentDate()"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad(/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderReference, 22)"/>
			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/PurchaseOrderReferences/PurchaseOrderDate"/>
			<xsl:value-of select="script:msPadNumber(/GoodsReceivedNote/GoodsReceivedNoteTrailer/TotalExclVAT, 12, 2)"/>
			<xsl:value-of select="script:msPad('', 3)"/>
			<xsl:value-of select="/GoodsReceivedNote/GoodsReceivedNoteHeader/ReceivedDeliveryDetails/DeliveryDate"/>
			<xsl:variable name="PaddedPLAccountNumber">
				<xsl:value-of select="script:msAddPaddingPrefix(/GoodsReceivedNote/GoodsReceivedNoteHeader/Supplier/SuppliersLocationID/BuyersCode, 7, '0')" />
			</xsl:variable>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(LineNumber, 6, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad(LineExtraData/PurchaseCategoryCode, 10)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		</xsl:for-each>

		<xsl:for-each select="//InvoiceLine">
			<xsl:if test="script:mbIsNotFirstLine()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
			<xsl:text>3</xsl:text>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(translate(/Invoice/InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 10)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/ShipTo/ShipToName, 40)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine1, 40)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine2, 40)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/ShipTo/ShipToAddress/AddressLine4, 30)"/>
			<xsl:value-of select="script:msPad('', 2)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/ShipTo/ShipToAddress/PostCode, 10)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPad('United Kingdom', 30)"/>
			<xsl:value-of select="script:msPad(/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference, 15)"/>		
			<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode, 20)"/>
			<xsl:value-of select="script:msPad(InvoicedQuantity/@UnitOfMeasure, 10)"/>
			<xsl:value-of select="script:msPadNumber(0, 9, 0)"/>
			<xsl:value-of select="script:msPad(PackSize, 15)"/>
			<xsl:value-of select="script:msPadNumber(InvoicedQuantity* (1 - 2 * (InvoicedQuantity&lt; 0)), 7, 2)"/>
			<xsl:value-of select="script:msPadNumber(UnitValueExclVAT * (1 - 2 * (UnitValueExclVAT &lt; 0)), 10, 4)"/>
			<xsl:value-of select="script:msPadNumber(LineValueExclVAT * (1 - 2 * (LineValueExclVAT &lt; 0)), 9, 2)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Manufacturer, 40)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Brand, 40)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		  	<xsl:choose>
				<xsl:when test="ProductID/GTIN and ProductID/GTIN != '55555555555555' and Product/GTIN != '0000000000000'">
					<xsl:value-of select="script:msPad(ProductID/GTIN, 15)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('', 15)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad(ProductDescription, 75)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('N', 1)"/>
			<xsl:choose>
				<xsl:when test="LineValueExclVAT &lt; 0">
					<xsl:value-of select="script:msPad('Y', 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('N', 1)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msGetCurrentDate()"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad(PurchaseOrderReferences/PurchaseOrderReference, 22)"/>
			<xsl:choose>		
				<xsl:when test="PurchaseOrderReferences/PurchaseOrderDate"><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/></xsl:otherwise>
			</xsl:choose>

			<xsl:value-of select="script:msPadNumber(/Invoice/InvoiceTrailer/SettlementTotalExclVAT, 12, 2)"/>
			<xsl:value-of select="script:msPad('', 3)"/>
			<xsl:choose>		
				<xsl:when test="DeliveryNoteReferences/DeliveryNoteDate"><xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/></xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="PaddedPLAccountNumber">
				<xsl:value-of select="script:msAddPaddingPrefix(/Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode, 7, '0')" />
			</xsl:variable>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(LineNumber, 6, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 10)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		</xsl:for-each>
		
		<xsl:for-each select="//CreditNoteLine">
			<xsl:if test="script:mbIsNotFirstLine()">
				<xsl:text>&#13;&#10;</xsl:text>
			</xsl:if>
			<xsl:text>3</xsl:text>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/Supplier/SuppliersName, 40)"/>
			<xsl:value-of select="script:msPad(translate(/CreditNote/CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 10)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/ShipTo/ShipToName, 40)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1, 40)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2, 40)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4, 30)"/>
			<xsl:value-of select="script:msPad('', 2)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/ShipTo/ShipToAddress/PostCode, 10)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPad('United Kingdom', 30)"/>
			<xsl:value-of select="script:msPad(/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteReference, 15)"/>		
			<xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			<xsl:value-of select="script:msPad(ProductID/SuppliersProductCode, 20)"/>
			<xsl:value-of select="script:msPad(CreditedQuantity/@UnitOfMeasure, 10)"/>
			<xsl:value-of select="script:msPadNumber(0, 9, 0)"/>
			<xsl:value-of select="script:msPad(PackSize, 15)"/>
			<xsl:value-of select="script:msPadNumber(CreditedQuantity* (1 - 2 * (CreditedQuantity&lt; 0)), 7, 2)"/>
			<xsl:value-of select="script:msPadNumber(UnitValueExclVAT * (1 - 2 * (UnitValueExclVAT &lt; 0)), 10, 4)"/>
			<xsl:value-of select="script:msPadNumber(LineValueExclVAT * (1 - 2 * (LineValueExclVAT &lt; 0)), 9, 2)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Manufacturer, 40)"/>
			<xsl:value-of select="script:msPad(LineExtraData/Brand, 40)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		  	<xsl:choose>
				<xsl:when test="ProductID/GTIN and ProductID/GTIN != '55555555555555' and Product/GTIN != '0000000000000'">
					<xsl:value-of select="script:msPad(ProductID/GTIN, 15)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('', 15)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad(ProductDescription, 75)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('N', 1)"/>
			<xsl:choose>
				<xsl:when test="LineValueExclVAT &lt; 0">
					<xsl:value-of select="script:msPad('N', 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="script:msPad('Y', 1)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msGetCurrentDate()"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 40)"/>
			<xsl:value-of select="script:msPad(PurchaseOrderReferences/PurchaseOrderReference, 22)"/>
			<xsl:choose>		
				<xsl:when test="PurchaseOrderReferences/PurchaseOrderDate"><xsl:value-of select="PurchaseOrderReferences/PurchaseOrderDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="script:msPadNumber(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT, 12, 2)"/>
			<xsl:value-of select="script:msPad('', 3)"/>
			<xsl:choose>		
				<xsl:when test="DeliveryNoteReferences/DeliveryNoteDate"><xsl:value-of select="DeliveryNoteReferences/DeliveryNoteDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="/CreditNote/CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/></xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="PaddedPLAccountNumber">
				<xsl:value-of select="script:msAddPaddingPrefix(/CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode, 7, '0')" />
			</xsl:variable>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad(concat('019', $PaddedPLAccountNumber), 20)"/>
			<xsl:value-of select="script:msPad('', 30)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 35)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(LineNumber, 6, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 1)"/>
			<xsl:value-of select="script:msPad('', 10)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 15)"/>
			<xsl:value-of select="script:msPadNumber(0, 12, 0)"/>
			<xsl:value-of select="script:msPad('', 20)"/>
		</xsl:for-each>

	</xsl:template>
		
	<msxsl:script language="JScript" implements-prefix="script"><![CDATA[ 
		var mbIsFirstLine = true;
		function mbIsNotFirstLine()
		{
			var bIsFirstLine = mbIsFirstLine;
			mbIsFirstLine = false;
			return (!bIsFirstLine);
		}
		
		/*=========================================================================================
		' Routine       	 : msPad
		' Description 	 : Pads the string to the appropriate length
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msPad(vsString, vlLength)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			
			try
			{
				vsString = vsString.substr(0, vlLength);
			}
			catch(e)
			{
				vsString = '';
			}
			
			while(vsString.length < vlLength)
			{
				vsString = vsString + ' ';
			}
			
			return vsString
				
		}

		function msAddPaddingPrefix(vsString, vlLength, vsPrefix)
		{
			try
			{
				vsString = vsString(0).text;
			}
			catch(e){}
			while(vsString.length<vlLength)
			{
				vsString = vsPrefix + vsString;
			}
			return vsString.substring(vsString.length - vlLength)
		}
		
		/*=========================================================================================
		' Routine       	 : msPadNumber
		' Description 	 : Pads the number to the appropriate length with appropriate number of implied dps
		' Inputs          	 : A string, the desired length
		' Outputs       	 : None
		' Returns       	 : The string padded/truncated as necessary
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : Rave Tech,   18/08/2009 FB3047 Handle negative value totals.
		'========================================================================================*/
		function msPadNumber(vvNumber, vlLength, vlDPs)
		{
			var sNumber = '';
			var neg = false;
			
			try
			{
				sNumber = vvNumber(0).text;
			}
			catch(e)
			{
				sNumber = vvNumber.toString();
			}
			
			
			if(sNumber.search(/-/)!=-1)
			{
				sNumber = sNumber.replace(/-/,'');
				neg=true;
			}		

			
			if(sNumber.indexOf('.') != -1)
			{
				var lDPs;
				if(neg) 
				{
				     lDPs = sNumber.length - sNumber.indexOf('.') - 2;
				 }
				 else
				 {
				     lDPs = sNumber.length - sNumber.indexOf('.') - 1;
				 } 
				
				if(lDPs > vlDPs)
				{
					sNumber = sNumber.substr(0, sNumber.length + vlDPs - lDPs);
					vlDPs = 0;
				}
				else
				{
					vlDPs -= lDPs;
				} 
			}
			
			for(var i=0; i<vlDPs; i++)
			{
				sNumber += '0';
			}
			
			sNumber = sNumber.replace('.','');
			
			while(sNumber.length < vlLength)
			{
				sNumber = '0' + sNumber;
			}
			
			if(neg) 
			{
				sNumber = '-' +  sNumber ;
			}
			return sNumber.substr(0, vlLength);
				
		}

		/*=========================================================================================
		' Routine       	 : msGetCurrentDate
		' Description 	 : Gets the current date in the format "yyyy-mm-dd"
		' Inputs          	 : String
		' Outputs       	 : None
		' Returns       	 : String
		' Author       		 : A Sheppard, 07/05/2008
		' Alterations   	 : 
		'========================================================================================*/
		function msGetCurrentDate()
		{
			var dtDate = new Date();
			var sReturn = '';
			
			sReturn = dtDate.getYear() + '-';
			
			if(dtDate.getMonth() < 9)
			{
				sReturn += '0';
			}
			
			sReturn += (dtDate.getMonth() + 1) + '-';
			
			if(dtDate.getDate() < 10)
			{
				sReturn += '0';
			}
			sReturn += dtDate.getDate();

			return sReturn;
		}

	]]></msxsl:script>
</xsl:stylesheet>