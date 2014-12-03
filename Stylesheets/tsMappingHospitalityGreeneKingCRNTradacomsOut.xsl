<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 Maps an internal XML Credit Note into an outbound Tradacoms v9 format.
 
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 30/10/2012	| M Dimant     	| Created.
==========================================================================================
 20/11/2014	| M Dimant     	| 10087: Corrected GLN (mailbox reference) being used in STX segment.
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
	<xsl:key name="keyLinesByPO" match="//CreditNoteLine" use="concat('¬',//PurchaseOrderReferences/PurchaseOrderReference)"/>
	<xsl:key name="keyLinesByPOAndDN" match="//CreditNoteDetail/CreditNoteLine" use="concat('¬',//PurchaseOrderReferences/PurchaseOrderReference,'::¬',//DeliveryNoteReferences/DeliveryNoteReference)"/>
	
	<xsl:template match="/">

		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
		</xsl:variable>		
		
		<xsl:variable name="FGN">
			<xsl:value-of select="$nBatchID"/>					
		</xsl:variable>
			
			
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<xsl:text>STX=</xsl:text>
			<xsl:text>ANA:1+</xsl:text>
			<!--Our mailbox reference-->
			<xsl:choose>
				<xsl:when test="CreditNote/TradeSimpleHeader/TestFlag = 'false' or CreditNote/TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>5013546145710</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>5013546164209</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="//PurchaseOrderReferences/PurchaseOrderReference"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:choose>
				<xsl:when test="CreditNote/TradeSimpleHeader/TestFlag = 'false' or CreditNote/TradeSimpleHeader/TestFlag = '0'">
					<xsl:text>CREHDR</xsl:text>
				</xsl:when>
				<xsl:otherwise><xsl:text>CRETES</xsl:text></xsl:otherwise>
			</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=1+CREHDR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>TYP=</xsl:text>
		<xsl:text>0700</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>SDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SIDN 1 = 3050 must be a number (ANA) -->
				<xsl:if test="string(number(CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
					<xsl:value-of select="CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 SIDN 2 = 3051 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Supplier/SuppliersAddress/PostCode),8)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 17 (if an alphanumeric value) VATN 2 = 308A = AN..17 -->
		<xsl:choose>
			<xsl:when test="string(number(CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo)) != 'NaN'">
				<xsl:value-of select="CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/CreditNoteReferences/VATRegNo),17)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- CIDN 1 = 3020 must be a number (ANA) -->
				<xsl:if test="string(number(CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode)) != 'NaN'">
					<xsl:value-of select="CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/BuyersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CIDN 2 = 3021 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(CreditNote/CreditNoteHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="/CreditNote/CreditNoteHeader/BatchInformation/FileGenerationNo"/>
		<xsl:text>+1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:for-each select="CreditNote">
		
			<xsl:text>MHD=</xsl:text>	
			<xsl:value-of select="format-number(count(preceding-sibling::* | self::*) + 1,'0')"/>
			<xsl:text>+</xsl:text>
			<xsl:text>CREDIT:9</xsl:text>
			<xsl:value-of select="$sRecordSep"/>
	
			<xsl:text>CLO=</xsl:text>
			<xsl:if test="InvoiceHeader/ShipTo/ShipToLocationID/GLN != '5555555555555'">
				<xsl:value-of select="InvoiceHeader/ShipTo/ShipToLocationID/GLN"/>
			</xsl:if>
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 2 = 3001 = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToLocationID/BuyersCode),17)"/>
			<xsl:text>:</xsl:text>
			<!-- truncate to 17 CLOC 3 = 300A = AN..17 -->
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToLocationID/SuppliersCode),17)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 40 CNAM = 3060 = AN..40-->
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToName),40)"/>
			<xsl:text>+</xsl:text>
			<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
			<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
			<xsl:value-of select="js:msSafeText(string(CreditNoteHeader/ShipTo/ShipToAddress/PostCode),8)"/>
			<xsl:value-of select="$sRecordSep"/>
	
			<xsl:text>CRF=</xsl:text>
			<xsl:call-template name="msCheckField">
				<xsl:with-param name="vobjNode" select="CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				<xsl:with-param name="vnLength" select="17"/>
			</xsl:call-template>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
			</xsl:call-template>
			<xsl:text>+</xsl:text>
			<xsl:call-template name="msFormateDate">
				<xsl:with-param name="vsUTCDate" select="CreditNoteHeader/CreditNoteReferences/TaxPointDate"/>
			</xsl:call-template>
			<xsl:value-of select="$sRecordSep"/>
	
			<!-- use the keys for grouping Lines by PO Reference and then by DN Reference -->
			<!-- the first loop will match the first line in each set of lines grouped by PO Reference -->
			<xsl:for-each select="CreditNoteDetail/CreditNoteLine[generate-id() = generate-id(key('keyLinesByPO',concat('¬',PurchaseOrderReferences/PurchaseOrderReference))[1])]">
				<xsl:sort select="PurchaseOrderReferences/PurchaseOrderReference" data-type="text"/>
				<xsl:variable name="POReference" select="concat('¬',PurchaseOrderReferences/PurchaseOrderReference)"/>
				<!-- now, given we can find all lines for the current PO reference, loop through and match the first line for each unique DN reference -->
				<xsl:for-each select="key('keyLinesByPO',$POReference)[generate-id() = generate-id(key('keyLinesByPOAndDN',concat($POReference,'::',concat('¬',DeliveryNoteReferences/DeliveryNoteReference)))[1])]">
					<xsl:sort select="DeliveryNoteReferences/DeliveryNoteReference" data-type="text"/>
					<xsl:variable name="DNReference" select="concat('¬',DeliveryNoteReferences/DeliveryNoteReference)"/>
					
									
						<xsl:text>OIR=</xsl:text>						
						<xsl:text>1+</xsl:text>
						<xsl:text>+++::</xsl:text>											
						<xsl:text>:</xsl:text>
						<xsl:value-of select="$sRecordSep"/>
						
						<!-- now output all the lines for the current PO reference and DN reference combination -->
						<xsl:for-each select="key('keyLinesByPOAndDN',concat($POReference,'::',$DNReference))">
						
							<xsl:text>CLD=</xsl:text>
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
							<xsl:value-of select="translate(format-number(CreditedQuantity,'#.000'),'.','')"/>
							<xsl:text>:</xsl:text>
						<xsl:choose>
								<xsl:when test="InvoicedQuantity /@UnitOfMeasure='CS'">PK</xsl:when>
								<xsl:when test="InvoicedQuantity /@UnitOfMeasure='KGM'">KG</xsl:when>
								<xsl:when test="InvoicedQuantity /@UnitOfMeasure='DZN'">DZ</xsl:when>
								<xsl:otherwise><xsl:value-of select="InvoicedQuantity /@UnitOfMeasure"/></xsl:otherwise>
							</xsl:choose>	
							<xsl:text>+</xsl:text>
							<xsl:value-of select="format-number(CreditedQuantity,'0')"/>
							<xsl:text>:</xsl:text>
							<xsl:value-of select="translate(format-number(CreditedQuantity,'#.000'),'.','')"/>
							<xsl:text>:</xsl:text>
							<xsl:choose>
								<xsl:when test="CreditedQuantity/@UnitOfMeasure='CS'">PK</xsl:when>
								<xsl:when test="CreditedQuantity/@UnitOfMeasure='KGM'">KG</xsl:when>
								<xsl:when test="CreditedQuantity/@UnitOfMeasure='DZN'">DZ</xsl:when>
								<xsl:otherwise><xsl:value-of select="CreditedQuantity/@UnitOfMeasure"/></xsl:otherwise>
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
			
			<xsl:for-each select="CreditNoteTrailer/VATSubTotals/VATSubTotal">
			
				<xsl:text>CST=</xsl:text>
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
			
			<xsl:text>CTR=</xsl:text>	
			<xsl:text>1+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DiscountedLinesTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+++++</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:if test="number(CreditNoteTrailer/SettlementDiscount) != 0">
				<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementDiscount,'#.00'),'.','')"/>
			</xsl:if>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalExclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/VATAmount,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/DocumentTotalInclVAT,'#.00'),'.','')"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="translate(format-number(CreditNoteTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
			<xsl:value-of select="$sRecordSep"/>
			
			<xsl:text>MTR=</xsl:text>
			<xsl:value-of select="5 + number(CreditNoteTrailer/NumberOfDeliveries) + count(CreditNoteDetail/CreditNoteLine) + count(CreditNoteTrailer/VATSubTotals/VATSubTotal)"/>
			<xsl:value-of select="$sRecordSep"/>
			
		</xsl:for-each>
		
		<xsl:text>MHD=</xsl:text>			
		<xsl:value-of select="format-number(count(/BatchRoot/CreditNote) + 2,'0')"/>		
		<xsl:text>+</xsl:text>	
		<xsl:text>VATTLR:9</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>

		<xsl:for-each select="//CreditNoteTrailer/VATSubTotals/VATSubTotal">
			
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
		
		
		
		<xsl:variable name="VATRatesInBatch">
			<xsl:copy-of select="/"/>
			<xsl:for-each select="/BatchRoot/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal/@VATRate">
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
				<xsl:when test="/BatchRoot/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/VATCode = 'S'">S</xsl:when>
				<xsl:when test="/BatchRoot/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/VATCode = 'Z'">Z</xsl:when>
			</xsl:choose>
			<xsl:text>+</xsl:text>
			<!-- VATP -->
			<xsl:value-of select="format-number($VATRate * 1000,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDE -->
			<xsl:value-of select="format-number(sum(/BatchRoot/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VSDI -->
			<xsl:value-of select="format-number(sum(/BatchRoot/CreditNote/CreditNoteDetail/CreditNoteLine[number(./VATRate) = number($VATRate)]/LineCostExclVat) * 100,'0')"/>
			<xsl:text>+</xsl:text>
			<!-- VVAT -->
			<xsl:value-of select="format-number(sum(/BatchRoot/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/VATAmountAtRate) * 100,'0')"/>
			<!-- VPSE -->
			<xsl:text>++</xsl:text>
			<!-- VPSI -->
			<xsl:value-of select="format-number((sum(/BatchRoot/CreditNote/CreditNoteTrailer/VATSubTotals/VATSubTotal[number(./@VATRate) = number($VATRate)]/DocumentTotalInclVATAtRate) ) * 100,'0')"/>
			<xsl:value-of select="$sRecordSep"/>
	
		</xsl:for-each>

<!--  -->
				
		<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="2 + count(msxsl:node-set($VATRatesInBatch)/VAT)"/>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>MHD=</xsl:text>
		<xsl:value-of select="format-number(count(/BatchRoot/CreditNote) + 3,'0')"/>
		<xsl:text>+</xsl:text>
		<xsl:text>CRETLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>TOT=</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/DocumentTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/SettlementTotalExclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/VATAmount),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/DocumentTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(sum(/CreditNote/CreditNoteTrailer/SettlementTotalInclVAT),'#.00'),'.','')"/>
		<xsl:text>+1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
		<!-- END = number of message headers (MHD) -->
		<xsl:text>END=</xsl:text>
		<xsl:value-of select="format-number(count(/BatchRoot/CreditNote) + 3,'0')"/>
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
					<xsl:text>Error raised by tsMappingHospitalityCreditNoteTradacomsv9BatchOut.xsl.&#13;&#10;</xsl:text>
					
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
