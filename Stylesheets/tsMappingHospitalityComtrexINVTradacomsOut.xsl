<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 Maps internal XML into an EDI Tradacoms v9 format for Comtrex.
 
 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 05/01/2012	| M Dimant     | Based on tsMappingHospitalityInvoiceTradacomsv9Out.xsl
==========================================================================================
 09/05/2012   | M Dimant    	| 5448: Changes to accomodate inclusion of UOM by Comtrex
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>
	
	<xsl:param name="nBatchID"/>

	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note 1) the '::' literal is simply used as a convenient separator for the 2 values that make up the second key.
	     note 2) the extra ¬ character is needed because PO and DN references are optional. -->
	<xsl:key name="keyLinesByPO" match="//InvoiceLine" use="concat('¬',//PurchaseOrderReferences/PurchaseOrderReference)"/>
	<xsl:key name="keyLinesByPOAndDN" match="//InvoiceDetail/InvoiceLine" use="concat('¬',//PurchaseOrderReferences/PurchaseOrderReference,'::¬',//DeliveryNoteReferences/DeliveryNoteReference)"/>
	
	<xsl:template match="/">

		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
			<!--xsl:text>'&#13;&#10;</xsl:text-->
		</xsl:variable>		
		
		<xsl:variable name="FGN">
			<xsl:value-of select="$nBatchID"/>					
		</xsl:variable>
			
			
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<xsl:text>STX=</xsl:text>
			<xsl:text>ANA:1+</xsl:text>
			<!-- Usually our mailbox reference, however Comtrex require this to be supplier's GLN-->
			<xsl:choose>
				<xsl:when test="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
					<xsl:value-of select="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- SIDN 1 = 3050 must be a number (ANA) -->
					<xsl:if test="string(number(Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
						<xsl:value-of select="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="//PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:choose>
				<xsl:when test="Invoice/TradeSimpleHeader/TestFlag = 'false' or Invoice/TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>INVFIL</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>INVTES</xsl:text></xsl:otherwise>
			</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=1+INVFIL:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>
		<xsl:text>0700</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SIDN 1 = 3050 must be a number (ANA) -->
				<xsl:if test="string(number(Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
					<xsl:value-of select="Invoice/InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 SIDN 2 = 3051 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Supplier/SuppliersAddress/PostCode),8)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 17 (if an alphanumeric value) VATN 2 = 308A = AN..17 -->
		<xsl:choose>
			<xsl:when test="string(number(Invoice/InvoiceHeader/InvoiceReferences/VATRegNo)) != 'NaN'">
				<xsl:value-of select="Invoice/InvoiceHeader/InvoiceReferences/VATRegNo"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/InvoiceReferences/VATRegNo),17)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="Invoice/InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- CIDN 1 = 3020 must be a number (ANA) -->
				<xsl:if test="string(number(Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode)) != 'NaN'">
					<xsl:value-of select="Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CIDN 2 = 3021 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(Invoice/InvoiceHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=</xsl:text>
		<xsl:text>1++073:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Currency),3)"/>
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="/Invoice/InvoiceHeader/BatchInformation/FileGenerationNo"/>
		<xsl:text>+1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:for-each select="Invoice">
		
			<xsl:text>MHD=</xsl:text>	
			<xsl:value-of select="format-number(count(preceding-sibling::* | self::*) + 1,'0')"/>
			<xsl:text>+</xsl:text>
			<xsl:text>INVOIC:9</xsl:text>
			<xsl:value-of select="$sRecordSep"/>
	
			<xsl:text>CLO=</xsl:text>
			<xsl:if test="InvoiceHeader/ShipTo/ShipToLocationID/GLN != '5555555555555'">
				<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
			</xsl:if>
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 2 = 3001 = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode),17)"/>
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 3 = 300A = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode),17)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToName),40)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/ShipTo/ShipToAddress/PostCode),8)"/>
			<xsl:value-of select="$sRecordSep"/>
	
			<xsl:text>IRF=</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="InvoiceHeader/InvoiceReferences/InvoiceDate"/>
			</xsl:call-template>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="InvoiceHeader/InvoiceReferences/TaxPointDate"/>
			</xsl:call-template>
			<xsl:value-of select="$sRecordSep"/>
	
			<!-- use the keys for grouping Lines by PO Reference and then by DN Reference -->
			<!-- the first loop will match the first line in each set of lines grouped by PO Reference -->
			<xsl:for-each select="InvoiceDetail/InvoiceLine[generate-id() = generate-id(key('keyLinesByPO',concat('¬',PurchaseOrderReferences/PurchaseOrderReference))[1])]">
				<xsl:sort select="PurchaseOrderReferences/PurchaseOrderReference" data-type="text"/>
				<xsl:variable name="POReference" select="concat('¬',PurchaseOrderReferences/PurchaseOrderReference)"/>
				<!-- now, given we can find all lines for the current PO reference, loop through and match the first line for each unique DN reference -->
				<xsl:for-each select="key('keyLinesByPO',$POReference)[generate-id() = generate-id(key('keyLinesByPOAndDN',concat($POReference,'::',concat('¬',DeliveryNoteReferences/DeliveryNoteReference)))[1])]">
					<xsl:sort select="DeliveryNoteReferences/DeliveryNoteReference" data-type="text"/>
					<xsl:variable name="DNReference" select="concat('¬',DeliveryNoteReferences/DeliveryNoteReference)"/>
					
						<!-- now that we have our distinct and sorted list of lines we can output the required delivery line and associated detail lines-->
						<xsl:text>ODD=</xsl:text>
						<xsl:variable name="DeliveryNumber" select="position()"/>					
						<xsl:value-of select="$DeliveryNumber"/>
						<xsl:text>+</xsl:text>
						<!-- truncate to 17 ORNO 1 = 5010 = AN..17 -->
						<xsl:call-template name="msCheckField">
							<xsl:with-param name="vobjNode" select="PurchaseOrderReferences/PurchaseOrderReference"/>
							<xsl:with-param name="vnLength" select="17"/>
						</xsl:call-template>
						<xsl:text>::</xsl:text>
						<xsl:call-template name="msFormateDate">
							<xsl:with-param name="vsUTCDate" select="PurchaseOrderReferences/PurchaseOrderDate"/>
						</xsl:call-template>					
						<xsl:text>+</xsl:text>
						<!-- truncate to 17 DELN 1 = 5040 = AN..17 -->
						<xsl:choose>
							<xsl:when test="DeliveryNoteReferences/DeliveryNoteReference!=''">						
								<xsl:call-template name="msCheckField">
									<xsl:with-param name="vobjNode" select="DeliveryNoteReferences/DeliveryNoteReference"/>
									<xsl:with-param name="vnLength" select="17"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceReference"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>:</xsl:text>
						<xsl:choose>
							<xsl:when test="DeliveryNoteReferences/DeliveryNoteDate!=''">
								<xsl:call-template name="msFormateDate">
									<xsl:with-param name="vsUTCDate" select="DeliveryNoteReferences/DeliveryNoteDate"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="msFormateDate">
									<xsl:with-param name="vsUTCDate" select="/Invoice/InvoiceHeader/InvoiceReferences/InvoiceDate"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:text>+++:</xsl:text>
						<xsl:call-template name="msFormateDate">
							<xsl:with-param name="vsUTCDate" select="DeliveryNoteReferences/DespatchDate"/>
						</xsl:call-template>
						<xsl:value-of select="$sRecordSep"/>
						
						<!-- now output all the lines for the current PO reference and DN reference combination -->
						<xsl:for-each select="key('keyLinesByPOAndDN',concat($POReference,'::',$DNReference))">
						
							<xsl:text>ILD=</xsl:text>
							<xsl:value-of select="$DeliveryNumber"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>+</xsl:text>
							<!-- use GTIN here if 13 digit EAN number -->
							<xsl:if test="string-length(ProductID/GTIN) = 13 and ProductID/GTIN != '5555555555555'">
								<xsl:value-of select="ProductID/GTIN"/>
							</xsl:if>
							<xsl:text>:</xsl:text>
							<!-- truncate to 30 SPRO 2 = 3071 = AN..30-->
							<xsl:call-template name="msCheckField">
								<xsl:with-param name="vobjNode" select="ProductID/SuppliersProductCode"/>
								<xsl:with-param name="vnLength" select="30"/>
							</xsl:call-template>
							<!-- use GTIN here if 14 digit DUN number -->
							<xsl:if test="string-length(ProductID/GTIN) = 14 and ProductID/GTIN != '55555555555555'">
								<xsl:text>:</xsl:text>
								<xsl:value-of select="ProductID/GTIN"/>
							</xsl:if>						
							<xsl:text>+</xsl:text>
							<xsl:text>+</xsl:text>
							<!-- truncate to 30 -->
							<xsl:call-template name="msCheckField">
								<xsl:with-param name="vobjNode" select="ProductID/BuyersProductCode"/>
								<xsl:with-param name="vnLength" select="30"/>
							</xsl:call-template>
							<xsl:text>+:</xsl:text>
							<xsl:value-of select="format-number(InvoicedQuantity,'0')"/>
							<xsl:text>:</xsl:text>
							<xsl:choose>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='CS'">PK</xsl:when>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='KGM'">KG</xsl:when>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='DZN'">DZ</xsl:when>
								<xsl:otherwise><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:otherwise>
							</xsl:choose>							
							<xsl:text>+</xsl:text>
							<xsl:value-of select="format-number(InvoicedQuantity,'0')"/>
							<xsl:text>:</xsl:text>
							<xsl:value-of select="translate(format-number(InvoicedQuantity,'#.000'),'.','')"/>
							<xsl:text>:</xsl:text>
							<xsl:choose>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='CS'">PK</xsl:when>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='KGM'">KG</xsl:when>
								<xsl:when test="InvoicedQuantity/@UnitOfMeasure='DZN'">DZ</xsl:when>
								<xsl:otherwise><xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/></xsl:otherwise>
							</xsl:choose>			
							<xsl:text>+</xsl:text>
							<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="translate(format-number(LineValueExclVAT,'#.0000'),'.','')"/>
							<xsl:text>+</xsl:text>
							<!-- VATC = 4030 = AN..1 -->
							<xsl:value-of select="VATCode"/>
							<xsl:text>+</xsl:text>
							<xsl:value-of select="translate(format-number(VATRate,'#.000'),'.','')"/>
							<xsl:text>+++</xsl:text>
							<!-- truncate to 40 TDES = 9030 = AN..40-->
							<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>			
							<xsl:value-of select="$sRecordSep"/>
							
						</xsl:for-each>
				</xsl:for-each>					
			</xsl:for-each>
			
			<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
			
				<xsl:text>STL=</xsl:text>
				<xsl:value-of select="position()"/>
				<xsl:text>+</xsl:text>
				<!-- VATC = 4030 = AN..1 -->
				<xsl:value-of select="@VATCode"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(@VATRate,'#.000'),'.','')"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="NumberOfLinesAtRate"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(DiscountedLinesTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+++++</xsl:text>
				<xsl:value-of select="translate(format-number(DocumentTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<xsl:if test="number(SettlementDiscountAtRate) != 0">
					<xsl:value-of select="translate(format-number(SettlementDiscountAtRate,'#.00'),'.','')"/>
				</xsl:if>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(SettlementTotalExclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(VATAmountAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(DocumentTotalInclVATAtRate,'#.00'),'.','')"/>
				<xsl:text>+</xsl:text>
				<xsl:value-of select="translate(format-number(SettlementTotalInclVATAtRate,'#.00'),'.','')"/>
				<xsl:value-of select="$sRecordSep"/>
			
			</xsl:for-each>
			
			<xsl:text>TLR=</xsl:text>	
			<!--xsl:value-of select="InvoiceTrailer/NumberOfLines"/-->
			<xsl:text>1+</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/DiscountedLinesTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+++++</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/DocumentTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:if test="number(InvoiceTrailer/SettlementDiscount) != 0">
				<xsl:value-of select="translate(format-number(InvoiceTrailer/SettlementDiscount,'#.00'),'.','')"/>
			</xsl:if>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/SettlementTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/DocumentTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(InvoiceTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
			<xsl:value-of select="$sRecordSep"/>
			
			<xsl:text>MTR=</xsl:text>
			<xsl:value-of select="5 + number(InvoiceTrailer/NumberOfDeliveries) + count(InvoiceDetail/InvoiceLine) + count(InvoiceTrailer/VATSubTotals/VATSubTotal)"/>
			<xsl:value-of select="$sRecordSep"/>
			
		</xsl:for-each>
		
		<xsl:text>MHD=</xsl:text>			
		<xsl:value-of select="format-number(count(/BatchRoot/Invoice) + 2,'0')"/>		
		<xsl:text>+</xsl:text>	
		<xsl:text>VATTLR:9</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>

		<xsl:for-each select="//InvoiceTrailer/VATSubTotals/VATSubTotal">
			
			<xsl:text>VRS=</xsl:text>	
			<xsl:value-of select="position()"/>
			<xsl:text>+</xsl:text>
			<!-- VATC = 4030 = AN..1 -->
			<xsl:value-of select="@VATCode"/>
			<xsl:text>+</xsl:text>
			<!-- format to 3 implied decimal places -->
			<xsl:value-of select="translate(format-number(@VATRate,'#.000'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(DocumentTotalExclVATAtRate,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(SettlementTotalExclVATAtRate,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(VATAmountAtRate,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(DocumentTotalInclVATAtRate,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(SettlementTotalInclVATAtRate,'#.00'),'.','')"/>
			<xsl:value-of select="$sRecordSep"/>
		
		</xsl:for-each>
		
		
		<!-- /a/*[.!=preceding-sibling::*] -->
		
		<xsl:variable name="VATRatesInBatch">
			<xsl:copy-of select="/"/>
			<xsl:for-each select="/BatchRoot/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/@VATRate">
				<xsl:sort select="."/>
				<VAT>
					<VATRate>
						<xsl:value-of select="."/>
					</VATRate>
				</VAT>
			</xsl:for-each>
		</xsl:variable>
	
<!--  -->
	
		<xsl:for-each select="msxsl:node-set($VATRatesInBatch)/VAT">
			<xsl:variable name="VATRate">
				<xsl:value-of select="VATRate"/>
			</xsl:variable>
			<xsl:text>VRS=</xsl:text>
			<!-- SEQA -->
			<xsl:value-of select="format-number(count(preceding-sibling::* | self::*) + 1,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VATC -->
			<xsl:choose>
				<xsl:when test="/BatchRoot/Invoice/InvoiceDetail/InvoiceLine[number(./VATRate) = number($VATRate)]/VATCode = 'S'">S</xsl:when>
				<xsl:when test="/BatchRoot/Invoice/InvoiceDetail/InvoiceLine[number(./VATRate) = number($VATRate)]/VATCode = 'Z'">Z</xsl:when>
			</xsl:choose>
			<xsl:text>+</xsl:text>
			<!-- VATP -->
			<xsl:value-of select="format-number($VATRate * 1000,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDE -->
			<xsl:value-of select="format-number(sum(/BatchRoot/Invoice/InvoiceDetail/InvoiceLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDI -->
			<xsl:value-of select="format-number(sum(/BatchRoot/Invoice/InvoiceDetail/InvoiceLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VVAT -->
			<xsl:value-of select="format-number(sum(/BatchRoot/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/VATAmountAtRate) * 100,'0')"/>
			<!-- VPSE -->
			<xsl:text>++</xsl:text>
			<!-- VPSI -->
			<xsl:value-of select="format-number((sum(/BatchRoot/Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/DocumentTotalInclVATAtRate) ) * 100,'0')"/>
			<xsl:value-of select="$sRecordSep"/>
	
		</xsl:for-each>

<!--  -->
				
		<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="2 + count(msxsl:node-set($VATRatesInBatch)/VAT)"/>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>MHD=</xsl:text>
		<xsl:value-of select="format-number(count(/BatchRoot/Invoice) + 3,'0')"/>
		<xsl:text>+</xsl:text>
		<xsl:text>INVTLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>TOT=</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/Invoice/InvoiceTrailer/DocumentTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/Invoice/InvoiceTrailer/SettlementTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/Invoice/InvoiceTrailer/VATAmount),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/Invoice/InvoiceTrailer/DocumentTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/Invoice/InvoiceTrailer/SettlementTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- END = number of message headers (MHD) -->
		<xsl:text>END=</xsl:text>
		<xsl:value-of select="format-number(count(/BatchRoot/Invoice) + 3,'0')"/>
		<xsl:value-of select="$sRecordSep"/>
		
	</xsl:template>
	

<!--=======================================================================================
  Routine        : msFormateDate()
  Description    : Converts a date in the format YYYY-MM-DD to the format YYMMDD 
  Inputs         : vsUTCDate
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msFormateDate">
		<xsl:param name="vsUTCDate"/>
	
		<xsl:value-of select="substring(translate($vsUTCDate,'-',''), 3)"/>
	
	</xsl:template>
	
<!--=======================================================================================
  Routine        : msCheckField()
  Description    : Checks the (escaped) value of the given element won't be truncated
  						  Raises an error if it will.
  Inputs         : vobjNode, the element, 
						  vnLength, the length of the tradacoms field
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->
	<xsl:template name="msCheckField">
		<xsl:param name="vobjNode"/>
		<xsl:param name="vnLength"/>
		
		<xsl:variable name="sEscapedField" select="js:msEscape(string($vobjNode))"/>
		
		<xsl:choose>
		
			<xsl:when test="string-length($sEscapedField) &gt; $vnLength">
				<xsl:message terminate="yes">
					<xsl:text>Error raised by tsMappingHospitalityInvoiceTradacomsv9BatchOut.xsl.&#13;&#10;</xsl:text>
					
					<xsl:text>The internal format of this message contains a field that would be truncated when mapped to a corresponding tradacoms field.&#13;&#10;</xsl:text>
					<xsl:text>The element is </xsl:text>
					<xsl:call-template name="msWriteXPath">
						<xsl:with-param name="vobjNode" select="$vobjNode"/>					
					</xsl:call-template>
					<xsl:text>[. = '</xsl:text>
					<xsl:value-of select="$vobjNode"/>
					<xsl:text>'].&#13;&#10;</xsl:text>
					
					<xsl:text>The maximum length after escaping is </xsl:text>
					<xsl:value-of select="$vnLength"/>
					<xsl:text> characters.</xsl:text>
				</xsl:message>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$sEscapedField"/>
			</xsl:otherwise>
			
		</xsl:choose>		
	
	</xsl:template>

<!--=======================================================================================
  Routine        : msWriteXPath()
  Description    : Writes out the Xpath to the given element 
  Inputs         : 
  Outputs        : 
  Returns        : A string
  Author         : Robert Cambridge
  Version        : 1.0
  Alterations    : (none)
 =======================================================================================-->	
	<xsl:template name="msWriteXPath">
		<xsl:param name="vobjNode"/>		
		
		<xsl:if test="$vobjNode != /*">
			<xsl:call-template name="msWriteXPath">
				<xsl:with-param name="vobjNode" select="$vobjNode/ancestor::*[1]"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:text>/</xsl:text>
		<xsl:value-of select="name($vobjNode)"/>
		
	</xsl:template>

<msxsl:script language="VBScript" implements-prefix="vb"><![CDATA[

'==========================================================================================
' Routine        : msFileGenerationDate()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationDate()

Dim sNow

	sNow = CStr(Date)

	msFileGenerationDate = Right(sNow,2) & Mid(sNow,4,2) & Left(sNow,2)
		
End Function

'==========================================================================================
' Routine        : msFileGenerationTime()
' Description    : 
' Inputs         :  
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'==========================================================================================

Function msFileGenerationTime()

Dim sNow

	sNow = CStr(Time)

	msFileGenerationTime = Replace(sNow,":","")
			
End Function

]]></msxsl:script>


<msxsl:script language="JScript" implements-prefix="js"><![CDATA[ 

/*=========================================================================================
' Routine        : msSafeText()
' Description    : escapes and then truncates a string 
' Inputs         : the field, the maximum length
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msSafeText(vsField, nLength){
	
	return msTruncate(msEscape(vsField),nLength);
	
}


/*=========================================================================================
' Routine        : msTruncate()
' Description    : truncates a string in an escape-char-aware manner
' Inputs         : the field, the maximum length
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/

function msTruncate(vsField, nLength){

var sText;
var objRegExp = new RegExp("[?]*$");

	//truncate the string
	sText = vsField.substring(0,nLength);
	
	//capture any sequence of '?' at the end of the string
	objRegExp.exec(sText);
	
	//length of a sequence of '?' is odd the last one 
	//is acting as an escape character and should be removed
	if((RegExp.lastMatch.length % 2) == 1){
		sText = sText.substring(0,nLength-1)
	}
	
	return sText;
	
}


/*=========================================================================================
' Routine        : msEscape()
' Description    : escapes reserved characters
' Inputs         : the field 
' Outputs        : 
' Returns        : A string
' Author         : Robert Cambridge
' Version        : 1.0
' Alterations    : (none)
'========================================================================================*/


function msEscape(vsField){

	//match all reserved characters in the string and put and ? in fornt of it
	return vsField.replace(/([?+=:'])/g, "?$1");
	
}


   
]]></msxsl:script>







</xsl:stylesheet>
