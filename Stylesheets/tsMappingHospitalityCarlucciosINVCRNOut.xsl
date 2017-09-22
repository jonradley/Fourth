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
====================================================================================================================================================================================
 15-09-2017		| M Dimant  	| FB 12133: Slight changes to format and mapping of data from correct fields
====================================================================================================================================================================================
 22-09-2017		| W Nassor  | FB 12140: Fixing errors for FGN and Company Code // Added additional character (i) contcat for FnB Shop Voicher Number
=================================================================================================================================================================================-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:variable name="RecordSeperator" select="'&#13;&#10;'"/>
	<xsl:variable name="FieldSeperator" select="'|'"/>
	<xsl:key name="InvNominal" match="Invoice/InvoiceDetail/InvoiceLine/LineExtraData/AccountCode" use="."/>
	<xsl:key name="CredNominal" match="CreditNote/CreditNoteDetail/CreditNoteLine/LineExtraData/AccountCode" use="."/>
	<xsl:template match="Invoice">
		<!-- Create a line for each product nominal -->
		<xsl:for-each select="InvoiceDetail/InvoiceLine/LineExtraData/AccountCode[generate-id() = generate-id(key('InvNominal',.)[1])]">
			<xsl:variable name="CompanyCode_Full">
				<xsl:choose>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FDSTPNC'">2-410</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FFHR'">2-400</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BRUNFF_dup'">2-320</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CWFF_dup'">2-090</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'OXFOD_dup'">2-220</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'EALFF_dup'">2-120</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'MPFF_dup'">2-050</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CAMFF'">2-420</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CLFF'">2-430</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CBFF'">2-440</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'EARLFF'">2-450</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FFFENCAN'">2-460</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CBCCFF'">2-470</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'EXEFresh'">2-480</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'WIMFF'">2-490</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CARDFF'">2-530</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'MKFF'">2-500</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CCF'">2-510</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CFF'">2-540</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'KNFF'">2-520</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BSEF'">2-550</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BIRMFF'">2-560</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'MHFF'">2-580</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'NOTFF'">2-570</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FFNOR'">2-590</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F610'">2-610</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F620'">2-620</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F640'">2-640</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F650'">2-650</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F660'">2-660</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'PNRFFood'">2-680</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F630'">2-630</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F690'">2-690</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F670'">2-670</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F710'">2-710</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F730'">2-730</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F720'">2-720</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'WESTFFresh'">2-750</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CarlDORFF'">2-740</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CarlucWCFF'">2-700</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'PeteFRF'">2-760</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F800'">2-800</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F780'">2-780</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F790'">2-790</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'AberFF'">2-810</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'NewcFFR'">2-820</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'TR02'">2-999</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F831'">2-830</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F833'">2-833</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F835'">2-835</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FT4'">2-831</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F832'">2-832</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F834'">2-834</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F837'">2-837</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F838'">2-838</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F836'">2-836</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F839'">2-839</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F840'">2-840</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F841'">2-841</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F842'">2-842</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F846'">2-846</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F848'">2-848</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F845'">2-845</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F849'">2-849</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F847'">2-847</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F850'">2-850</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F851'">2-851</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F852'">2-852</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F843'">2-843</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F857'">2-857</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F856'">2-856</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F855'">2-855</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F844'">2-844</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F858'">2-858</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F862'">2-862</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F859'">2-859</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F865'">2-865</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'F863'">2-863</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'SCPFF'">2-070</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'MPFF'">2-050</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CWFF'">2-090</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'OXFOD'">2-220</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'SMFF'">2-110</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'KFF'">2-080</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BRUNFF'">2-320</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'REAFF'">2-260</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'EALFF'">2-120</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'TWFF'">2-180</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'PTFF'">2-190</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FWFOD'">2-060</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BCFF'">2-160</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'WGFF'">2-270</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'SJWFF'">2-240</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CKFOD'">2-200</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'WIFF'">2-210</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CHFF'">2-300</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FREFOOD'">2-340</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'STALFF'">2-130</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'SPFFF'">2-350</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'FFTC'">2-330</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'ISFF'">2-170</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BLUEFF'">2-140</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'RICHFF'">2-310</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BRFF'">2-290</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'SKFF'">2-230</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'BNFF'">2-370</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'GSFF'">2-360</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CSFF'">2-380</xsl:when>
					<xsl:when test="/Invoice/TradeSimpleHeader/RecipientsBranchReference = 'CSPFF'">2-390</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//Invoice/InvoiceHeader/HeaderExtraData/CompanyCode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!-- Put the product nominal into a variable so we can use it later -->
			<xsl:variable name="ProdNom">
				<xsl:value-of select="."/>
			</xsl:variable>
			<!-- Create one line per VAT Code for each product nominal -->
			<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">
				<!-- FnB Shop Voucher Number (<storeno.>i0000001) -->
				<xsl:variable name="FGN" select="//InvoiceHeader/FileGenerationNumber"/>
				<xsl:variable name="CompanyCode" select="substring-after($CompanyCode_Full,'-')"/>
				<xsl:value-of select="concat($CompanyCode, 'I', format-number(substring($FGN, string-length($FGN) - 5), '00000'))"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Sage Supplier Number  -->
				<xsl:value-of select="//Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
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
				<xsl:value-of select="concat($CompanyCode_Full,'-',$ProdNom)"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Net Amount for given Nominal Code and VAT code Z -->
				<xsl:value-of select="format-number(sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT),'0.00')"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
				<xsl:text>Z</xsl:text>
				<xsl:value-of select="$RecordSeperator"/>
			</xsl:if>
			<!-- Create one line per VAT Code for each product nominal -->
			<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">
				<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
				<xsl:variable name="FGN" select="//InvoiceHeader/FileGenerationNumber"/>
				<xsl:variable name="CompanyCode" select="substring-after($CompanyCode_Full,'-')"/>
				<xsl:value-of select="concat($CompanyCode,substring($FGN, string-length($FGN) - 5))"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Sage Supplier Number  -->
				<xsl:value-of select="//Invoice/InvoiceHeader/HeaderExtraData/STXSupplierCode"/>
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
				<xsl:value-of select="concat(//InvoiceHeader/HeaderExtraData/CompanyCode,'-',$ProdNom)"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Net Amount for given Nominal Code and VAT code S -->
				<xsl:value-of select="format-number(sum(../../../InvoiceLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT),'0.00')"/>
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
		
			             <xsl:variable name="CompanyCode_Full">
                           <xsl:choose>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FDSTPNC'">2-410</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FFHR'">2-400</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BRUNFF_dup'">2-320</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CWFF_dup'">2-090</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'OXFOD_dup'">2-220</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'EALFF_dup'">2-120</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'MPFF_dup'">2-050</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CAMFF'">2-420</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CLFF'">2-430</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CBFF'">2-440</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'EARLFF'">2-450</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FFFENCAN'">2-460</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CBCCFF'">2-470</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'EXEFresh'">2-480</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'WIMFF'">2-490</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CARDFF'">2-530</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'MKFF'">2-500</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CCF'">2-510</xsl:when>
                                  <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CFF'">2-540</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'KNFF'">2-520</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BSEF'">2-550</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BIRMFF'">2-560</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'MHFF'">2-580</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'NOTFF'">2-570</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FFNOR'">2-590</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F610'">2-610</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F620'">2-620</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F640'">2-640</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F650'">2-650</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F660'">2-660</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'PNRFFood'">2-680</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F630'">2-630</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F690'">2-690</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F670'">2-670</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F710'">2-710</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F730'">2-730</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F720'">2-720</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'WESTFFresh'">2-750</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CarlDORFF'">2-740</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CarlucWCFF'">2-700</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'PeteFRF'">2-760</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F800'">2-800</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F780'">2-780</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F790'">2-790</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'AberFF'">2-810</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'NewcFFR'">2-820</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'TR02'">2-999</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F831'">2-830</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F833'">2-833</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F835'">2-835</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FT4'">2-831</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F832'">2-832</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F834'">2-834</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F837'">2-837</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F838'">2-838</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F836'">2-836</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F839'">2-839</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F840'">2-840</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F841'">2-841</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F842'">2-842</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F846'">2-846</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F848'">2-848</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F845'">2-845</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F849'">2-849</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F847'">2-847</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F850'">2-850</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F851'">2-851</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F852'">2-852</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F843'">2-843</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F857'">2-857</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F856'">2-856</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F855'">2-855</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F844'">2-844</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F858'">2-858</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F862'">2-862</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F859'">2-859</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F865'">2-865</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'F863'">2-863</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'SCPFF'">2-070</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'MPFF'">2-050</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CWFF'">2-090</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'OXFOD'">2-220</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'SMFF'">2-110</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'KFF'">2-080</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BRUNFF'">2-320</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'REAFF'">2-260</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'EALFF'">2-120</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'TWFF'">2-180</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'PTFF'">2-190</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FWFOD'">2-060</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BCFF'">2-160</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'WGFF'">2-270</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'SJWFF'">2-240</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CKFOD'">2-200</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'WIFF'">2-210</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CHFF'">2-300</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FREFOOD'">2-340</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'STALFF'">2-130</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'SPFFF'">2-350</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'FFTC'">2-330</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'ISFF'">2-170</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BLUEFF'">2-140</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'RICHFF'">2-310</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BRFF'">2-290</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'SKFF'">2-230</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'BNFF'">2-370</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'GSFF'">2-360</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CSFF'">2-380</xsl:when>
                                 <xsl:when test="/CreditNote/TradeSimpleHeader/RecipientsBranchReference = 'CSPFF'">2-390</xsl:when>
                                 <xsl:otherwise>
                                        <xsl:value-of select="//CreditNote/CreditNoteHeader/HeaderExtraData/CompanyCode"/>
                                 </xsl:otherwise>
                           </xsl:choose>       
             </xsl:variable>

			<!-- Put the product nominal into a variable so we can use it later -->
			<xsl:variable name="ProdNom">
				<xsl:value-of select="."/>
			</xsl:variable>
			<!-- Create one line per VAT Code for each product nominal -->
			<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='Z']">
				<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
				<xsl:variable name="FGN" select="//CreditNoteHeader/FileGenerationNumber"/>
				<xsl:variable name="CompanyCode" select="substring-after($CompanyCode_Full,'-')"/>
				<xsl:value-of select="concat($CompanyCode, 'I', format-number(substring($FGN, string-length($FGN) - 5),'00000'))"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Sage Supplier Number  -->
				<xsl:value-of select="//CreditNote/CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
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
				<xsl:value-of select="concat($CompanyCode_Full,'-',$ProdNom)"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Net Amount for given Nominal Code and VAT code Z -->
				<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='Z']/LineValueExclVAT),'0.00')"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
				<xsl:text>Z</xsl:text>
				<xsl:value-of select="$RecordSeperator"/>
			</xsl:if>
			<!-- Create one line per VAT Code for each product nominal -->
			<xsl:if test="//LineExtraData/AccountCode[.=$ProdNom and ../../VATCode='S']">
				<!-- FnB Shop Voucher Number (<storeno.>0000001) -->
				<xsl:variable name="FGN" select="//CreditNoteHeader/FileGenerationNumber"/>
				<xsl:variable name="CompanyCode" select="substring-after($CompanyCode_Full,'-')"/>
				<xsl:value-of select="concat($CompanyCode,substring($FGN, string-length($FGN) - 5))"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Sage Supplier Number  -->
				<xsl:value-of select="//CreditNote/CreditNoteHeader/HeaderExtraData/STXSupplierCode"/>
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
				<xsl:value-of select="concat($CompanyCode_Full,'-',$ProdNom)"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- Net Amount for given Nominal Code and VAT code S -->
				<xsl:value-of select="format-number(-1 * sum(../../../CreditNoteLine[LineExtraData/AccountCode=$ProdNom and VATCode='S']/LineValueExclVAT),'0.00')"/>
				<xsl:value-of select="$FieldSeperator"/>
				<!-- VAT Code –Z=Zero Rated, Z=Exempt, S=Standard 17.5%	Z -->
				<xsl:text>S</xsl:text>
				<xsl:value-of select="$RecordSeperator"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
