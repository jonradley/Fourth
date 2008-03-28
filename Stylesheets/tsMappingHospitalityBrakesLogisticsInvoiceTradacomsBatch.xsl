<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
R Cambridge | 13/09/2007		| 1439 branched from tsMappingHospitalityBrakesFrozenGroceryInvoiceTradacomsBatch.xsl
**********************************************************************
Lee Boyton  | 21/09/2007 		| Cater for the UoM being unrecognised by defaulting to each.
**********************************************************************
R Cambridge | 13/02/2008		| 1626 If there's a PO refence but no date, use the delivery date (request by Mark Sayers)
**********************************************************************
R Cambridge | 28/03/2008		| 2099 Logic to determine DN ref
**********************************************************************
            |           		| 
*******************************************************************-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<!-- Buyers Code detection function and lookup table -->
	<xsl:include href="tsMapping_LookupBuyersANA_Table.xsl"/>

	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- NOTE that these string literals are not only enclosed with double quotes, but have single quotes within also-->
	<xsl:variable name="FileHeaderSegment" select="'INVFIL'"/>
	<xsl:variable name="DocumentSegment" select="'INVOIC'"/>
	<xsl:variable name="FileTrailerSegment" select="'INVTLR'"/>
	<xsl:variable name="VATTrailerSegment" select="'VATTLR'"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<xsl:apply-templates/>
		</BatchRoot>
	</xsl:template>
	
	
	
	<!-- GENERIC HANDLER to copy unchanged nodes, will be overridden by any node-specific templates below -->
	<xsl:template match="*">
		<!-- Copy the node unchanged -->
		<xsl:copy>
			<!--Then let attributes be copied/not copied/modified by other more specific templates -->
			<xsl:apply-templates select="@*"/>
			<!-- Then within this node, continue processing children -->
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- GENERIC ATTRIBUTE HANDLER to copy unchanged attributes, will be overridden by any attribute-specific templates below-->
	<xsl:template match="@*">
		<!--Copy the attribute unchanged-->
		<xsl:copy/>
	</xsl:template>
	<!-- END of GENERIC HANDLERS -->

	<!-- SSP amendment - to remap SCFR using CLO(3) IF SSP. -->
	<xsl:template match="//TradeSimpleHeader/SendersCodeForRecipient">
	
		<SendersCodeForRecipient>
		
			<xsl:variable name="sCurValue" select="."/>
			<xsl:variable name="sCLO2Value" select="//InvoiceHeader/ShipTo/ShipToLocationID/BuyersCode"/>
			<xsl:variable name="sBuyersGLN" select="//Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
			<xsl:variable name="sCheckFlag">
				<xsl:call-template name="msDetectBuyersANA">
					<xsl:with-param  name="sANA" select="$sBuyersGLN"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<!-- Check is an invoice for SSP -->
				<xsl:when test="$sCheckFlag ='1' ">
					<xsl:value-of select="$sCLO2Value"/>
				</xsl:when>
				<!-- IS NOT an invoice for SSP -->
				<xsl:otherwise>
					<xsl:value-of select="$sCurValue"/>
				</xsl:otherwise>
			</xsl:choose>
			
		</SendersCodeForRecipient>
		
	</xsl:template>
	
	<!-- SSP amendment - to remap SBR using SDT(2) IF SSP. -->
	<xsl:template match="//TradeSimpleHeader/SendersBranchReference">
	
		<SendersBranchReference>
		
			<xsl:variable name="sCurValue" select="."/>
			<xsl:variable name="sScanRefValue" select="substring(//Invoice/InvoiceHeader/Supplier/SuppliersLocationID/BuyersCode,2,5)"/>
			<xsl:variable name="sBuyersGLN" select="/Batch/BatchDocuments/BatchDocument/Invoice/InvoiceHeader/Buyer/BuyersLocationID/BuyersCode"/>
				
			<xsl:variable name="sCheckFlag">
				<xsl:call-template name="msDetectBuyersANA">
					<xsl:with-param name="sANA" select="$sBuyersGLN"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<!-- Check is an invoice for SSP -->
				<xsl:when test="$sCheckFlag ='1' ">
					<xsl:value-of select="$sScanRefValue"/>
				</xsl:when>
				<!-- IS NOT an invoice for SSP -->
				<xsl:otherwise>
					<xsl:value-of select="$sCurValue"/>
				</xsl:otherwise>
			</xsl:choose>
			
		</SendersBranchReference>
		
	</xsl:template>
	
	
	
	<xsl:template match="InvoiceLine">
	
		<InvoiceLine>
		
			<!--  
			
			2099
			
			Determine DN ref by using the 1st of these values that's present
			 - Buyer's PO ref
			 - Supplier's PO ref
			 - Invoice ref
			-->

			<xsl:variable name="sDNRefDate">		
				<xsl:choose>
					<xsl:when test="translate(DeliveryNoteReferences/DeliveryNoteDate,' ','') != ''">
						<xsl:variable name="temp" select="translate(DeliveryNoteReferences/DeliveryNoteDate,' ','')"/>
						<xsl:value-of select="concat('20',substring($temp,1,2),'-',substring($temp,3,2),'-',substring($temp,5,2))"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			
			<xsl:variable name="sPORefReference">
			
				<!-- //PurchaseOrderReference holds all ORNO sub fields (ie will have the form {BuyerRef}:{SupplierRef}:{BuyerPODate}) -->
			
				<xsl:variable name="fieldORNO" select="concat(translate(PurchaseOrderReferences/PurchaseOrderReference,' ',''),':')"/>
				
				<xsl:variable name="buyerRef" select="substring-before($fieldORNO,':')"/>
				
				<xsl:variable name="supplierRef" select="substring-before(substring-after($fieldORNO,':'),':')"/>
			
				<xsl:choose>
					<xsl:when test="$buyerRef != ''"><xsl:value-of select="$buyerRef"/></xsl:when>
					<xsl:when test="$supplierRef != ''"><xsl:value-of select="$supplierRef"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="../../InvoiceHeader/InvoiceReferences/InvoiceReference"/></xsl:otherwise>
				</xsl:choose>
			
			</xsl:variable>
			
			<xsl:variable name="sPORefDate">		
				<xsl:choose>
					<!-- Use PO date if provided -->
					<xsl:when test="translate(PurchaseOrderReferences/PurchaseOrderDate,' ','') != ''">
						<xsl:variable name="temp" select="translate(PurchaseOrderReferences/PurchaseOrderDate,' ','')"/>
						<xsl:value-of select="concat('20',substring($temp,1,2),'-',substring($temp,3,2),'-',substring($temp,5,2))"/>
					</xsl:when>
					<!-- Delivery date should be close enough to the real PO date to thread -->
					<xsl:when test="$sDNRefDate != ''">
						<xsl:value-of select="$sDNRefDate"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>		
			</xsl:variable>
			
		
	
			<xsl:apply-templates select="LineNumber"/>
			
			<xsl:if test="string($sPORefDate) !='' and string($sPORefReference) != '' ">
				
				<PurchaseOrderReferences>
					
					<PurchaseOrderReference>
						<xsl:value-of select="$sPORefReference"/>
					</PurchaseOrderReference>
					
					<PurchaseOrderDate>
						<xsl:value-of select="$sPORefDate"/>
					</PurchaseOrderDate>
					
				</PurchaseOrderReferences>
				
			</xsl:if>
			
			<xsl:apply-templates select="PurchaseOrderConfirmationReferences"/>
			
			<xsl:if test="string($sDNRefDate) !='' and string($sPORefReference) != '' ">
				
				<DeliveryNoteReferences>
					
					<DeliveryNoteReference>
						<xsl:value-of select="$sPORefReference"/>
					</DeliveryNoteReference>
					
					<DeliveryNoteDate>
						<xsl:value-of select="$sDNRefDate"/>
					</DeliveryNoteDate>
					
					<xsl:apply-templates select="DeliveryNoteReferences/DespatchDate"/>
	
				</DeliveryNoteReferences>
				
			</xsl:if>
			
			<xsl:apply-templates select="GoodsReceivedNoteReferences"/>
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="ProductDescription"/>
			<xsl:apply-templates select="OrderedQuantity"/>
			<xsl:apply-templates select="ConfirmedQuantity"/>
			<xsl:apply-templates select="DeliveredQuantity"/>			
			<xsl:apply-templates select="InvoicedQuantity"/>			
			<xsl:apply-templates select="PackSize"/>
			<xsl:apply-templates select="UnitValueExclVAT"/>
			<xsl:apply-templates select="LineValueExclVAT"/>
			<xsl:apply-templates select="LineDiscountRate"/>
			<xsl:apply-templates select="LineDiscountValue"/>
			<xsl:apply-templates select="VATCode"/>
			<xsl:apply-templates select="VATRate"/>
			<xsl:apply-templates select="NetPriceFlag"/>
			<xsl:apply-templates select="Measure"/>
			<xsl:apply-templates select="LineExtraData"/>
			
		</InvoiceLine>
		
	</xsl:template>

	
	
	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- Check if invoice QTY is given, if not use measured quantity taking the value from @UnitOfMeasure. Also we need to ensure this attribute is stripped to avoid a validation error later on. -->
	<xsl:template match="//InvoicedQuantity" >
		
		<xsl:variable name="UoM">
			<xsl:call-template name="sConvertUOMForInternal">
				<xsl:with-param name="vsGivenValue" select="../Measure/TotalMeasureIndicator"/>
			</xsl:call-template>
		</xsl:variable>
		
		<InvoicedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:value-of select="$UoM"/>
			</xsl:attribute>
					
			<xsl:choose>
				<xsl:when test="$UoM = 'CS' or $UoM = 'EA'">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number(../Measure/TotalMeasure div 1000,'0.000')"/>
				</xsl:otherwise>
			</xsl:choose>
					
		</InvoicedQuantity>
		
	</xsl:template>
	
		
			
	<!-- INVOIC-ILD-LEXC(InvoiceLine/LineValueExclVAT) need to be multiplied by -1 if (InvoiceLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="InvoiceLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of BuyersProductCode -->
		<xsl:choose>
			<!--Parent of LineValueExclVAT is InvoiceLine -->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
				<!--INVOIC-ILD-CRLI is not blank, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeExplicit4DP">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. -->
		<xsl:template match="BatchHeader/DocumentTotalExclVAT |
						BatchHeader/SettlementTotalExclVAT |
						BatchHeader/VATAmount |
						BatchHeader/DocumentTotalInclVAT |
						BatchHeader/SettlementTotalInclVAT |
						InvoiceTrailer/DocumentTotalExclVAT |
						InvoiceTrailer/SettlementDiscount |
						InvoiceTrailer/SettlementTotalExclVAT |
						InvoiceTrailer/VATAmount |
						InvoiceTrailer/DocumentTotalInclVAT |
						InvoiceTrailer/SettlementTotalInclVAT |
						VATSubTotal/*">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="OrderingMeasure | InvoiceLine/VATRate">
		<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
	</xsl:template>
	<!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 4 D.P. -->
	<xsl:template match="InvoiceLine/UnitValueExclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
	</xsl:template>
	<!-- END of SIMPLE CONVERSIONS-->
	
	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderDate | 
						DeliveryNoteReferences/DeliveryNoteDate |
						DeliveryNoteReferences/DespatchDate |
						BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
						InvoiceReferences/TaxPointDate | 
						CreditNoteReferences/CreditNoteDate |
						CreditNoteReferences/TaxPointDate">
		<xsl:copy>
			<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2))"/>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYMMDD:[HHMMSS] to xsd:dateTime CCYY-MM-DDTHH:MM:SS+00:00 -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 13">
					<!-- Convert YYMMDD: to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYMMDD:HHMMSS to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 1, 2), '-', substring(., 3, 2), '-', substring(., 5, 2), 'T', substring(.,8,2), ':', substring(.,10,2), ':', substring(.,12,2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!--END of DATE CONVERSIONS -->
	
	<!-- CURRENT NODE HELPERS -->
	<xsl:template name="copyCurrentNodeDPUnchanged">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select=". * $lMultiplier"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 2 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit2DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 100.0, '0.00')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 3 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit3DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 1000.0, '0.00#')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 4 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit4DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier) div 10000.0, '0.00##')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- END of CURRENT NODE HELPERS -->
	
	<!--
	MHDSegment HANDLER
	This handler works with the MHDSegment tags which should be at the start of the BatchHeader, but are actually at start and end. Furthermore, This collection of MHDSegments includes unwanted
	INVOIC segments, which are only required at document level, under InvoiceHeader, so the following template does not copy those.
	-->
	<xsl:template match="BatchHeader/MHDSegment">
		<xsl:if test="contains(jscript:toUpperCase(string(./MHDHeader)), $FileHeaderSegment)">
			<!--
			Only action when this template match occurs on the first useful MHDSegment (which is *probably* the first MHDSegment to be found). 
			Once this tag is found, all other useful MHDSegment tags should follow as immediate siblings in the output, 
			even though they don't in the input - they are siblings, but the rest of the BatchHeader siblings are interspersed with them in the input.
			
			Make a copy of this first useful MHDSegment tree...
			-->
			<xsl:copy-of select="."/>
			<!-- ... and ensure all the other useful MHDSegments follow on immediatley -->
			<xsl:for-each select="../MHDSegment">
				<xsl:choose>
					<xsl:when test="contains(jscript:toUpperCase(string(./MHDHeader)), $FileTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:when test="contains(jscript:toUpperCase(string(./MHDHeader)), $VATTrailerSegment)">
						<xsl:copy-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>	
	<xsl:template match="BatchDocument/Invoice/InvoiceHeader">
		<!-- Get a count of all the preceding instances of BatchDocument/Invoice/InvoiceHeader -->
		<xsl:variable name="BatchDocumentIndex" select="1 + count(../../preceding-sibling::*)"/>
		<!-- Get a node list of all the MHDSegment nodes under the BatchHeader tag-->
		<xsl:variable name="MHDSegmentNodeList" select="/Batch/BatchHeader/MHDSegment"/>
		<!-- Filter this node list to exclude any which do not have MHDHeader tag set to INVOIC -->
		<xsl:variable name="DocumentSegmentNodeList" select="$MHDSegmentNodeList[contains(jscript:toUpperCase(string(MHDHeader)), $DocumentSegment)]"/>
		<xsl:copy>
			<!-- Copy the Nth instance of an INVOIC MHDSegment tag to this, the Nth Invoice header tag-->
			<xsl:copy-of select="$DocumentSegmentNodeList[$BatchDocumentIndex]"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- END of MHDSegment HANDLER -->
	
	<!--
	Delivery Location Code Converter
	If the delivery location code is 6 characters long, add a "1" in as the second character
	-->
	<xsl:template match="ShipTo/ShipToLocationID/SuppliersCode">
		<xsl:choose>
			<xsl:when test="string-length(.) = 6">
				<xsl:copy>
					<xsl:value-of select="substring(.,1,1)"/>1<xsl:value-of select="substring(.,2,5)"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- END of Delivery Location Code Converter-->
	

	<!-- Check for pairing of Purchase Order Date & Purchase Order Reference >
	<xsl:template match="//PurchaseOrderReferences">
	
		<xsl:variable name="sPORefDate">		
			<xsl:choose>
				<- Use PO date if provided ->
				<xsl:when test="translate(PurchaseOrderDate,' ','') != ''">
					<xsl:value-of select="translate(PurchaseOrderDate,' ','')"/>
				</xsl:when>
				< Delivery date should be close enough to the real PO date to thread >
				<xsl:when test="translate(../DeliveryNoteReferences/DeliveryNoteDate,' ','') != ''">
					<xsl:value-of select="translate(../DeliveryNoteReferences/DeliveryNoteDate,' ','')"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
		
		<xsl:variable name="sPORefReference" select="translate(PurchaseOrderReference,' ','')"/>
		
		<xsl:if test="string($sPORefDate) !='' and string($sPORefReference) != '' ">
			<PurchaseOrderReferences>
				<PurchaseOrderReference>
					<xsl:value-of select="$sPORefReference"/>
				</PurchaseOrderReference>
				<PurchaseOrderDate>
					<xsl:value-of select="concat('20',substring($sPORefDate,1,2),'-',substring($sPORefDate,3,2),'-',substring($sPORefDate,5,2))"/>
				</PurchaseOrderDate>

			</PurchaseOrderReferences>
		</xsl:if>
		
	</xsl:template-->
	
	<!-- 
		Template to convert UOM's into internal values
		
		Values from Invoice Schema
		
			<xsd:enumeration value="CS"/>
			<xsd:enumeration value="GRM"/>
			<xsd:enumeration value="KGM"/>
			<xsd:enumeration value="PND"/>
			<xsd:enumeration value="ONZ"/>
			<xsd:enumeration value="GLI"/>
			<xsd:enumeration value="LTR"/>
			<xsd:enumeration value="OZI"/>
			<xsd:enumeration value="PTI"/>
			<xsd:enumeration value="PTN"/>
			<xsd:enumeration value="001"/>
			<xsd:enumeration value="DZN"/>
			<xsd:enumeration value="EA"/>
			<xsd:enumeration value="PF"/>
			<xsd:enumeration value="PR"/>
			<xsd:enumeration value="HUR"/>
	-->

	<xsl:template name="sConvertUOMForInternal">
		<xsl:param name="vsGivenValue"/>
		<xsl:variable name="vsLowerCaseGivenValue" select="translate($vsGivenValue,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:choose>
			<xsl:when test="contains($vsLowerCaseGivenValue,'case') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'each') "><xsl:text>EA</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'kilos') "><xsl:text>KGM</xsl:text></xsl:when>
			
			<xsl:when test="contains($vsLowerCaseGivenValue,'kg') "><xsl:text>KGM</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'bx') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'cs') "><xsl:text>CS</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'grm') "><xsl:text>GRM</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pnd') "><xsl:text>PND</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'onz') "><xsl:text>ONZ</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'gli') "><xsl:text>GLI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ltr') "><xsl:text>LTR</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ozi') "><xsl:text>OZI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pti') "><xsl:text>PTI</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ptn') "><xsl:text>PTN</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'001') "><xsl:text>001</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'dzn') "><xsl:text>DZN</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'ea') "><xsl:text>EA</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pf') "><xsl:text>PF</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'pr') "><xsl:text>PR</xsl:text></xsl:when>
			<xsl:when test="contains($vsLowerCaseGivenValue,'hur') "><xsl:text>HUR</xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:text>EA</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
