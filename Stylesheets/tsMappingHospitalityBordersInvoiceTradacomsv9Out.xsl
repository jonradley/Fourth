<?xml version="1.0" encoding="UTF-8"?>

<!--======================================================================================
 Overview

 Maps internal XML into an EDI Tradacoms v9 format.
 
 © Alternative Business Solutions Ltd, 2006.
==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      	| Name 					| Description of modification
==========================================================================================
 29/04/2009	| Rave Tech   			| Created.FB 2870
==========================================================================================
           	|                 	|
==========================================================================================
           	|                 	|
=======================================================================================-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:js="http://www.abs-ltd.com/dummynamespaces/javascript"
	xmlns:vb="http://www.abs-ltd.com/dummynamespaces/vbscript"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="text"/>

	<!-- define keys (think of them a bit like database indexes) to be used for finding distinct line information.
	     note 1) the '::' literal is simply used as a convenient separator for the 2 values that make up the second key.
	     note 2) the extra ¬ character is needed because PO and DN references are optional. -->
	<xsl:key name="keyLinesByPO" match="InvoiceLine" use="concat('¬',PurchaseOrderReferences/PurchaseOrderReference)"/>
	<xsl:key name="keyLinesByPOAndDN" match="InvoiceDetail/InvoiceLine" use="concat('¬',PurchaseOrderReferences/PurchaseOrderReference,'::¬',DeliveryNoteReferences/DeliveryNoteReference)"/>
	
	<xsl:template match="/Invoice">

		<xsl:variable name="sRecordSep">
			<xsl:text>'</xsl:text>
			<!--xsl:text>'&#13;&#10;</xsl:text-->
		</xsl:variable>		
		
		<xsl:variable name="FGN">
			<!-- if a new file generation number has been generated for this message use it, otherwise
			     use the file generation number sent by the original message sender -->
			<xsl:variable name="atLeast4DigitFGN">						
				<xsl:choose>
					<xsl:when test="InvoiceHeader/FileGenerationNumber != ''">
						<xsl:value-of select="format-number(InvoiceHeader/FileGenerationNumber,'0000')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number(InvoiceHeader/BatchInformation/FileGenerationNo,'0000')"/>				
					</xsl:otherwise>
				</xsl:choose>						
			</xsl:variable>		
			<!-- Only get 4 right hand digits -->
			<xsl:value-of select="substring($atLeast4DigitFGN, string-length($atLeast4DigitFGN)-3)"/>			
		</xsl:variable>
			
			
		<xsl:variable name="sFileGenerationDate" select="vb:msFileGenerationDate()"/>
	
		<xsl:text>STX=</xsl:text>
			<xsl:text>ANA:1+</xsl:text>
			<!--Our mailbox reference-->
			<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersName), 35)"/>
			<xsl:text>+</xsl:text>
			<!--Your mailbox reference-->
			<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersName), 35)"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$sFileGenerationDate"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="vb:msFileGenerationTime()"/>
			<xsl:text>+</xsl:text>
			<xsl:value-of select="$FGN"/>
			<xsl:text>+</xsl:text>
			<xsl:text>+</xsl:text>
			<xsl:choose>
				<xsl:when test="TradeSimpleHeader/TestFlag = 'false' or TradeSimpleHeader/TestFlag = '0'">
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
			<xsl:when test="InvoiceHeader/Supplier/SuppliersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- SIDN 1 = 3050 must be a number (ANA) -->
				<xsl:if test="string(number(InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode)) != 'NaN'">
					<xsl:value-of select="InvoiceHeader/Supplier/SuppliersLocationID/SuppliersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 SIDN 2 = 3051 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 SNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersName),40)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 35 SADD 1-4 = 3062 = AN..35-->		
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine1),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine2),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine3),35)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersAddress/AddressLine4),35)"/>
		<xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) SADD 5 = 3063 = AN..8-->		
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Supplier/SuppliersAddress/PostCode),8)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 17 (if an alphanumeric value) VATN 2 = 308A = AN..17 -->
		<xsl:choose>
			<xsl:when test="string(number(InvoiceHeader/InvoiceReferences/VATRegNo)) != 'NaN'">
				<xsl:value-of select="InvoiceHeader/InvoiceReferences/VATRegNo"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="js:msSafeText(string(InvoiceHeader/InvoiceReferences/VATRegNo),17)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>CDT=</xsl:text>
		<xsl:choose>
			<xsl:when test="InvoiceHeader/Buyer/BuyersLocationID/GLN != '5555555555555'">
				<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/GLN"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- CIDN 1 = 3020 must be a number (ANA) -->
				<xsl:if test="string(number(InvoiceHeader/Buyer/BuyersLocationID/BuyersCode)) != 'NaN'">
					<xsl:value-of select="InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>:</xsl:text>
		<!-- truncate to 17 CIDN 2 = 3021 = AN..17 -->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode),17)"/>
		<xsl:text>+</xsl:text>
		<!-- truncate to 40 CNAM = 3060 = AN..40-->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersName),40)"/>
		<xsl:text>+</xsl:text> 
		<!-- truncate to 35 CADD 1-4 = 3032 = AN..35-->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine1),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine2),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine3),35)"/><xsl:text>:</xsl:text>
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersAddress/AddressLine4),35)"/><xsl:text>:</xsl:text>
		<!-- truncate to 8 (just in case) CADD 5 = 3033 = AN..8-->
		<xsl:value-of select="js:msSafeText(string(InvoiceHeader/Buyer/BuyersAddress/PostCode),8)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<!--
		<xsl:text>DNA=1</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>Code Table Number</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Code Value</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>
		-->
		
		<xsl:text>FIL=</xsl:text>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+1+</xsl:text>
		<xsl:value-of select="$sFileGenerationDate"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=6</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=</xsl:text>	
		<xsl:text>2+INVOIC:9</xsl:text>
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
		
		<xsl:text>DNA=</xsl:text>
		<xsl:text>1+</xsl:text>
		<xsl:text><!-- Code Table Number --></xsl:text>
		<xsl:text>:</xsl:text>
		<!-- <xsl:text>Code Value</xsl:text>
		<xsl:text>+</xsl:text>
		<xsl:text>082</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Application Text</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>2nd Application Code</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Application Text</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>3rd Application Code</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Application Text</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>4th Application Code</xsl:text>
		<xsl:text>:</xsl:text>
		<xsl:text>Application Text</xsl:text>	-->	
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
					<xsl:text>:</xsl:text>
					<!-- truncate to 17 ORNO 1 = 5010 = AN..17 -->
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationReference"/>
						<xsl:with-param name="vnLength" select="17"/>
					</xsl:call-template>
					<xsl:text>:</xsl:text>
					<xsl:call-template name="msFormateDate">
						<xsl:with-param name="vsUTCDate" select="PurchaseOrderReferences/PurchaseOrderDate"/>
					</xsl:call-template>
					<xsl:text>:</xsl:text>
						<xsl:call-template name="msFormateDate">
							<xsl:with-param name="vsUTCDate" select="PurchaseOrderConfirmationReferences/PurchaseOrderConfirmationDate"/>
						</xsl:call-template>						
					<xsl:text>+</xsl:text>
					<!-- truncate to 17 DELN 1 = 5040 = AN..17 -->
					<xsl:call-template name="msCheckField">
						<xsl:with-param name="vobjNode" select="DeliveryNoteReferences/DeliveryNoteReference"/>
						<xsl:with-param name="vnLength" select="17"/>
					</xsl:call-template>
					<xsl:text>:</xsl:text>
					<!-- <xsl:call-template name="msFormateDate">
						<xsl:with-param name="vsUTCDate" select="DeliveryNoteReferences/DeliveryNoteDate"/>
					</xsl:call-template>
					<xsl:text>+++:</xsl:text>-->
					<xsl:call-template name="msFormateDate">
						<xsl:with-param name="vsUTCDate" select="DeliveryNoteReferences/DespatchDate"/>
					</xsl:call-template>
					<!--NODU -->
					<xsl:text>+</xsl:text>
					<xsl:value-of select="$sRecordSep"/>
					
					<!-- now output all the lines for the current PO reference and DN reference combination -->
					<xsl:for-each select="key('keyLinesByPOAndDN',concat($POReference,'::',$DNReference))">
					
						<xsl:text>ILD=</xsl:text>
						<xsl:value-of select="$DeliveryNumber"/>
						<xsl:text>+</xsl:text>
						<xsl:variable name="ILDNumber" select="position()"/>					
						<xsl:value-of select="$ILDNumber"/>
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
						<!-- UNOR-->
						<xsl:text>+1</xsl:text>						
						<xsl:text>+::</xsl:text>
						<!-- <xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/> -->
						<xsl:text>+</xsl:text>
						<xsl:value-of select="format-number(InvoicedQuantity,'0')"/>						
						<xsl:text>+</xsl:text>
						<!-- AUCT -->
						<xsl:value-of select="translate(format-number((UnitValueExclVAT + LineDiscountValue),'#.0000'),'.','')"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="translate(format-number(LineValueExclVAT,'#.0000'),'.','')"/>
						<xsl:text>+</xsl:text>
						<!-- VATC = 4030 = AN..1 -->
						<xsl:value-of select="VATCode"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="translate(format-number(VATRate,'#.000'),'.','')"/>
						<xsl:text>+</xsl:text>
					<!-- <xsl:text>MIXI</xsl:text> -->
						<xsl:text>+</xsl:text>
						<xsl:text>+</xsl:text>
						<xsl:if test="string-length(ProductID/GTIN) = 0">
							<xsl:value-of select="js:msSafeText(string(ProductDescription),40)"/>	
						</xsl:if>
						<xsl:text>:</xsl:text>
						<xsl:text>+</xsl:text>
						<xsl:if test="LineExtraData/CataloguePrice != 0">
							<xsl:value-of select="translate(format-number(LineExtraData/CataloguePrice,'#.0000'),'.','')"/>
						</xsl:if>
						<xsl:text>+</xsl:text>
						<!-- BUCT -->
						<xsl:value-of select="translate(format-number(UnitValueExclVAT,'#.0000'),'.','')"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="translate(format-number(LineDiscountValue,'#.0000'),'.','')"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="translate(format-number(LineDiscountRate,'#.0000'),'.','')"/>
						<xsl:text>+</xsl:text>	
						<!-- <xsl:text>PIND</xsl:text> -->	
						<xsl:text>+</xsl:text>	
						<!-- <xsl:text>IGPI</xsl:text> -->	
						<xsl:text>+</xsl:text>	
						<!-- <xsl:text>CSDI</xsl:text> -->
						<xsl:value-of select="$sRecordSep"/>
						
						<xsl:text>DNC=</xsl:text>
						<xsl:value-of select="$DeliveryNumber"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="$ILDNumber"/>
						<xsl:text>+</xsl:text>
						<xsl:text>1</xsl:text>
						<!-- DNAC -->
						<!-- <xsl:text>+</xsl:text>--> 							
						<!-- <xsl:text> Code Table Number</xsl:text> -->
						<!-- <xsl:text>:</xsl:text>--> 
						<!-- <xsl:text>Code Value</xsl:text> -->
						<!-- RTEX -->
						<!-- <xsl:text>+</xsl:text>
						<xsl:text>082</xsl:text>
						<xsl:text>:</xsl:text>-->
						<!--<xsl:text> Application Text </xsl:text>-->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>2nd Application Code </xsl:text>-->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>Application Text</xsl:text> -->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>3rd Application Code</xsl:text> -->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>Application Text </xsl:text>-->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>4th Application Code</xsl:text> -->
						<!-- <xsl:text>:</xsl:text> -->
						<!-- <xsl:text>Application Text</xsl:text>-->		
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
		<xsl:value-of select="InvoiceTrailer/NumberOfLines"/>
		<xsl:text>+</xsl:text>
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
		<xsl:value-of select="6 + number(InvoiceTrailer/NumberOfDeliveries) + count(InvoiceDetail/InvoiceLine) * 2 + count(InvoiceTrailer/VATSubTotals/VATSubTotal)"/>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=3+VATTLR:9</xsl:text>		
		<xsl:value-of select="$sRecordSep"/>

		<xsl:for-each select="InvoiceTrailer/VATSubTotals/VATSubTotal">
		
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
				
		<xsl:text>MTR=</xsl:text>	
		<xsl:value-of select="2 + count(InvoiceTrailer/VATSubTotals/VATSubTotal)"/>
		<xsl:value-of select="$sRecordSep"/>
	
		<xsl:text>MHD=4+INVTLR:9</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>TOT=</xsl:text>
		<xsl:value-of select="translate(format-number(InvoiceTrailer/DocumentTotalExclVAT,'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(InvoiceTrailer/SettlementTotalExclVAT,'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(InvoiceTrailer/VATAmount,'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(InvoiceTrailer/DocumentTotalInclVAT,'#.00'),'.','')"/>
		<xsl:text>+</xsl:text>
		<xsl:value-of select="translate(format-number(InvoiceTrailer/SettlementTotalInclVAT,'#.00'),'.','')"/>
		<xsl:text>+1</xsl:text>
		<xsl:value-of select="$sRecordSep"/>

		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MHD=5+RSGRSG:2</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>RSG=</xsl:text>
		<xsl:value-of select="$FGN"/>
		<xsl:text>+</xsl:text>
		<xsl:text>BORDERS</xsl:text>
		<xsl:value-of select="$sRecordSep"/>
		
		<xsl:text>MTR=3</xsl:text>	
		<xsl:value-of select="$sRecordSep"/>

		<!-- END = number of message headers (MHD) -->
		<xsl:text>END=5</xsl:text>
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
					<xsl:text>Error raised by tsMappingHospitalityInvoiceTradacomsv9Out.xsl.&#13;&#10;</xsl:text>
					
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
