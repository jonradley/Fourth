<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Name			| Date				| Change
**********************************************************************
Koshaughnessy	| 29/05/2011	| created
**********************************************************************
-->
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

	<xsl:template match="VATSubTotals/VATSubTotal/@VATCode">
		<xsl:call-template name="VATTrailer"/>
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
	
	<!-- Shuffle up address lines -->
	<xsl:template match="BuyersAddress | SuppliersAddress | ShipToAddress">
		<xsl:copy>
			<xsl:for-each select="*[starts-with(name(),'AddressLine')][.!=''][position() &lt;5 ]">
				<xsl:element name="{concat('AddressLine',position())}">
					<xsl:value-of select="."/>
				</xsl:element>			
			</xsl:for-each>
			<PostCode><xsl:value-of select="PostCode"/></PostCode>
		</xsl:copy>
	</xsl:template>

	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<!--INVOIC-ILD-QTYI to 4 decimal places-->
	<xsl:template match="InvoiceLine/InvoicedQuantity">
		<xsl:call-template name="copyCurrentNodeDPUnchanged">
			<xsl:with-param name="lMultiplier" select="1.0"/>
		</xsl:call-template>
	</xsl:template>
	
	<!--INVOIC-ILD-LEXC to 4 decimal places -->
	<xsl:template match="InvoiceLine/LineValueExclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit4DP">
			<xsl:with-param name="lMultiplier" select="1.0"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 2 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 2 D.P. -->
	<xsl:template match="
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
		<xsl:call-template name="ZeroPrice2"/>
	</xsl:template>	
	<!-- This effects Stonegate only. They do not want prices to appear on the Invoices-->
	<xsl:template name="ZeroPrice2">
		<xsl:param name="Zero2" select="//Buyer/BuyersLocationID/SuppliersCode = '5060166760007'"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$Zero2">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>	
	</xsl:template>
	
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="OrderingMeasure | 
						TotalMeasure | 
						InvoiceLine/VATRate">
		<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
	</xsl:template>
	
	<!--decoing the VAT code from the rate-->
	<xsl:template match="Invoice/InvoiceDetail/InvoiceLine/VATCode">
		<xsl:call-template name="VATCode"/>
	</xsl:template>
	
	<!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P -->
	<xsl:template match="//InvoiceLine/UnitValueExclVAT |
							//BatchHeader/DocumentTotalExclVAT">
		<xsl:call-template name="ZeroPrice"/>
	</xsl:template>
	<!-- This effects Stonegate only. They do not want prices to appear on the Invoices-->
	<xsl:template name="ZeroPrice">
		<xsl:param name="Zero" select="//Buyer/BuyersLocationID/SuppliersCode = '5060166760007' "/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$Zero =  '10000' ">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!--docing the VAT sub totals-->
	<xsl:template match="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/@VATCode">
		<xsl:call-template name="VATTrailer"/>
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
	
	<xsl:template name="VATCode">
		<xsl:variable name="decodeVAT" select="Invoice/InvoiceDetail/InvoiceLine/VATCode"/>
		<xsl:choose>
			<xsl:when test="Invoice/InvoiceDetail/InvoiceLine/VATRate = '00000' "><VATCode>Z</VATCode></xsl:when>
			<xsl:otherwise><VATCode>S</VATCode></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="VATTrailer">
		<xsl:variable name="decodeVATTrailer" select="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/@VATCode"/>
		<xsl:choose>
			<xsl:when test="Invoice/InvoiceTrailer/VATSubTotals/VATSubTotal/@VATRate = '00000' ">
				<xsl:attribute name="VATCode">Z</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="VATCode">S</xsl:attribute>
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
