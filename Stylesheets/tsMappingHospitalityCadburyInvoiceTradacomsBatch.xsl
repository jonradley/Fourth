<?xml version="1.0" encoding="UTF-8"?>

<!--******************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
S Jefford	| 22/08/2005		| GTIN field now sourced from ILD/SPRO(1).
				|						| ILD/CRLI now stored in BuyersProductCode
**********************************************************************
N Emsen		| 14/09/2006		| Purchase order date stipped if = blank
**********************************************************************
N Emsen		|	08/11/2006		| Case 531: Purchase order reference working.
**********************************************************************
R Cambridge	| 26/02/2007		| 706 remove sender's branch reference
												make 10 digit SCR 9 digits by removing leading zero
**********************************************************************
R Cambridge	| 01/03/2007		| 706 GTIN is also suppliers product code
**********************************************************************
R Cambridge	| 08/06/2007 		| 1189 Ensure FGN is unique by appending Cadbury's code for ship to
**********************************************************************
           	|            		| 
*******************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
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
	
	
	<!-- 1189 Invoice/InvoiceHeader/BatchInformation/FileGenerationNo add suppliers code for unit (Cadbuy's sequences may not be unique across an estate) -->
	<xsl:template match="Invoice/InvoiceHeader/BatchInformation/FileGenerationNo">
		<xsl:copy>
			<xsl:value-of select="."/>
			<xsl:text> (</xsl:text>
			<xsl:value-of select="../../ShipTo/ShipToLocationID/SuppliersCode"/>
			<xsl:text>)</xsl:text>
		</xsl:copy>
	</xsl:template>	
	
	
	<!-- /Batch/BatchDocuments/BatchDocument/Invoice/TradeSimpleHeader/SendersCodeForRecipient: ensure code is 9 digits -->
	<xsl:template match="Invoice/TradeSimpleHeader/SendersCodeForRecipient">
		<SendersCodeForRecipient>
			<xsl:call-template name="msFormatSCR">
				<xsl:with-param name="vsCodeIn" select="."/>
				<xsl:with-param name="vsLeadingZeros" select="'0'"/>	
			</xsl:call-template>	
		</SendersCodeForRecipient>	
	</xsl:template>
	
	<!-- ShipTo/ShipToLocationID/SuppliersCode: ensure code is 9 digits  -->
	<xsl:template match="ShipTo/ShipToLocationID/SuppliersCode">
		<SuppliersCode>
			<xsl:call-template name="msFormatSCR">
				<xsl:with-param name="vsCodeIn" select="."/>
				<xsl:with-param name="vsLeadingZeros" select="'0'"/>	
			</xsl:call-template>	
		</SuppliersCode>	
	</xsl:template>
	
	<!-- /Batch/BatchDocuments/BatchDocument/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode: ensure code is 9 digits -->
	<xsl:template match="Buyer/BuyersLocationID/SuppliersCode">
		<SuppliersCode>
		
			<xsl:call-template name="msFormatSCR">
				<xsl:with-param name="vsCodeIn" select="."/>
				<xsl:with-param name="vsLeadingZeros" select="'0000'"/>	
			</xsl:call-template>
	
		</SuppliersCode>	
	</xsl:template>
	
	<!-- InvoiceLine/ProductID/SuppliersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="SuppliersProductCode">
		<SuppliersProductCode>
			<xsl:value-of select="../GTIN"/>
		</SuppliersProductCode>
	</xsl:template>	

	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>	
	
	<!-- /Batch/BatchDocuments/BatchDocument/Invoice/TradeSimpleHeader/SendersBranchReference should not be copied over -->
	<xsl:template match="Invoice/TradeSimpleHeader/SendersBranchReference"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- INVOIC-ILD-QTYI (InvoiceLine/InvoicedQuantity) needs to be multiplied by -1 if (InvoiceLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="InvoiceLine/InvoicedQuantity">
		<xsl:choose>
			<!--Parent of InvoicedQuantity is InvoiceLine-->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
				<!--INVOIC-ILD-CRLI is not blank, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeDPUnchanged">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeDPUnchanged"/>
			</xsl:otherwise>
		</xsl:choose>
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
						VATSubTotal/* |
						InvoiceTrailer/DocumentTotalExclVAT |
						InvoiceTrailer/SettlementDiscount |
						InvoiceTrailer/SettlementTotalExclVAT |
						InvoiceTrailer/VATAmount |
						InvoiceTrailer/DocumentTotalInclVAT |
						InvoiceTrailer/SettlementTotalInclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="OrderingMeasure | 
						TotalMeasure | 
						InvoiceLine/VATRate">
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
						InvoiceReferences/TaxPointDate">
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
	
	<!-- Check for pairing of Purchase Order Date & Purchase Order Reference -->
	<xsl:template match="//PurchaseOrderReferences">
		<xsl:variable name="sPORefDate" select="translate(PurchaseOrderDate,' ','')"/>
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
	</xsl:template>	
	
	<!-- Cadburys specific SCR formatting: removing leading zeros to make code 4 digit
			Anything other than leading zeros not removed -->
	<xsl:template name="msFormatSCR">
		<xsl:param name="vsCodeIn"/>
		<xsl:param name="vsLeadingZeros"/>
		
		<xsl:variable name="nLeadingZeros" select="string-length($vsLeadingZeros)"/>
		
			<xsl:choose>
				<!-- If the leading zeros match what's expected remove them -->
				<xsl:when test="string-length($vsCodeIn) = 9+$nLeadingZeros and substring($vsCodeIn,1,$nLeadingZeros) = $vsLeadingZeros">
					<xsl:value-of select="substring($vsCodeIn, $nLeadingZeros+1)"/>
				</xsl:when>
				<!-- Leaving anything else untouched -->
				<xsl:otherwise>
					<xsl:value-of select="$vsCodeIn"/>
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
