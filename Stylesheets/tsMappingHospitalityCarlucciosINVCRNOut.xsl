<?xml version="1.0" encoding="UTF-8"?>
<!--================================================================================================================================================================================
 Overview: sage line 500 mapper for Carluccio's outbound invoices

 © Fourth 2017
====================================================================================================================================================================================
 Module History
====================================================================================================================================================================================
 Version		| 
====================================================================================================================================================================================
 Date      		| Name 			| Description of modification
====================================================================================================================================================================================
 07-07-2017		| M Dimant  	| FB 11925: Created
=================================================================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="','"/>
	
	<xsl:key name="InvNominal" match="Invoice/InvoiceDetail/InvoiceLine/LineExtraData/AccountCode" use="."/>
	<xsl:key name="CredNominal" match="CreditNote/CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode" use="."/>

<xsl:template match="Invoice">	
	
	<!-- Create a line for each product nominal -->		
	<xsl:for-each select="InvoiceDetail/InvoiceLine/LineExtraData/AccountCode[generate-id() = generate-id(key('InvNominal',.)[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">
	
			<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
			<xsl:value-of select="concat(//InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode,//InvoiceHeader/BatchInformation/FileGenerationNo)"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Sage Supplier Number  -->
			<xsl:value-of select="//InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Carluccios PO Number. This could be blank but will be a maximum of 10 characters	 -->
			<xsl:value-of select="//InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Supplier Invoice No (30 characters) -->
			<xsl:value-of select="//InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Invoice Date-yyyymmdd -->
			<xsl:value-of select="translate(//InvoiceHeader/InvoiceReferences/InvoiceDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Invoice Amount including VAT (format of 8,2) -->
			<xsl:value-of select="//InvoiceTrailer/SettlementTotalInclVAT"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Sage General Ledger Code (max 16) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Net Amount for given Nominal Code and VAT code Z -->									
			<xsl:value-of select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:if>
	
<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">
	
			<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
			<xsl:value-of select="concat(//InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode,//InvoiceHeader/BatchInformation/FileGenerationNo)"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Sage Supplier Number  -->
			<xsl:value-of select="//InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Carluccios PO Number. This could be blank but will be a maximum of 10 characters	 -->
			<xsl:value-of select="//InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Supplier Invoice No (30 characters) -->
			<xsl:value-of select="//InvoiceHeader/InvoiceReferences/InvoiceReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Invoice Date-yyyymmdd -->
			<xsl:value-of select="translate(//InvoiceHeader/InvoiceReferences/InvoiceDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Invoice Amount including VAT -->
			<xsl:value-of select="//InvoiceTrailer/SettlementTotalInclVAT"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Sage General Ledger Code (max 16) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Net Amount for given Nominal Code and VAT code S -->									
			<xsl:value-of select="sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
			<xsl:text>S</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:if>	
	
	</xsl:for-each>

</xsl:template>



<xsl:template match="CreditNote">	
	
	<!-- Create a line for each product nominal -->		
	<xsl:for-each select="CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode[generate-id() = generate-id(key('CredNominal',.)[1])]">
	
		<!-- Put the product nominal into a variable so we can use it later -->
		<xsl:variable name="ProdNom"><xsl:value-of select="."/></xsl:variable>
		
		<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">
	
			<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
			<xsl:value-of select="concat(//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,//CreditNoteHeader/BatchInformation/FileGenerationNo)"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Sage Supplier Number  -->
			<xsl:value-of select="//CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Carluccios PO Number. This could be blank but will be a maximum of 10 characters	 -->
			<xsl:value-of select="//CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Supplier Invoice No (30 characters) -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Credit Note Date-yyyymmdd -->
			<xsl:value-of select="translate(//CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Credit Amount including VAT (format of 8,2) -->
			<xsl:value-of select="concat('-', //CreditNoteTrailer/SettlementTotalInclVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Sage General Ledger Code (max 16) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Net Amount for given Nominal Code and VAT code Z -->									
			<xsl:value-of select="concat('-', sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT))"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:if>
	
<!-- Create one line per VAT Code for each product nominal -->
		<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">
	
			<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
			<xsl:value-of select="concat(//CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode,//CreditNoteHeader/BatchInformation/FileGenerationNo)"/>
			<xsl:value-of select="$FieldSeperator"/>	
			
			<!-- Sage Supplier Number  -->
			<xsl:value-of select="//CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Carluccios PO Number. This could be blank but will be a maximum of 10 characters	 -->
			<xsl:value-of select="//CreditNoteDetail/CreditNoteLine/PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Supplier Invoice No (30 characters) -->
			<xsl:value-of select="//CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Credit Note Date-yyyymmdd -->
			<xsl:value-of select="translate(//CreditNoteHeader/CreditNoteReferences/CreditNoteDate,'-','')"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Credit Note Amount including VAT -->
			<xsl:value-of select="concat('-', //CreditNoteTrailer/SettlementTotalInclVAT)"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Sage General Ledger Code (max 16) -->
			<xsl:value-of select="$ProdNom"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- Net Amount for given Nominal Code and VAT code S -->									
			<xsl:value-of select="concat('-', sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT))"/>
			<xsl:value-of select="$FieldSeperator"/>
			
			<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
			<xsl:text>S</xsl:text>
			<xsl:value-of select="$RecordSeperator"/>
			
		</xsl:if>	
	
	</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
