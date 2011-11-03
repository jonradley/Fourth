<?xml version="1.0" encoding="UTF-8"?>
<!-- 
24th Feb 05 Andy Trafford Created from tsMappingHospitlaityInvoiceTradacomsBatch.xsl, to add support for SCR in CLO-CLO(3) if not found in CLO-CLOC(2)
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

	<!-- InvoiceLine/ProductID/GTIN is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="GTIN"/>
	<!-- FCC specific: TradeSimpleHeader/SendersName is actually CLO-CLOC(3) - do not copy -->
	<xsl:template match="TradeSimpleHeader/SendersName"/>
	<!-- FCC specific: ShipToLocationID/GLN is actually CLO-CLOC(3) - do not copy -->
	<xsl:template match="ShipToLocationID/GLN"/>
	
	<!-- FCC specific: Use TradeSimpleHeader/SendersName if TradeSimpleHeader/SendersCodeForRecipient is missing -->
	<xsl:template match="Invoice/TradeSimpleHeader">
		<!-- Copy the TradeSimpleHeader tag - needs to contain SCR, SBR in that order -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(./SendersCodeForRecipient) = ''">
					<!-- Nothing provided in CLOC(2), use CLOC(3) -->
					<xsl:element name="SendersCodeForRecipient">
						<!-- Since CLOC(2) was missing there will be no SendersCodeForRecipient tag, create and populate from CLOC(3) placeholder: SendersName -->
						<xsl:value-of select="SendersName"/>
					</xsl:element>
					<!-- Now copy SenderBranchReference and allow any SendersName to be processed without being copied -->
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<!-- CLOC(2) was provided, copy and allow any SendersName to be processed without being copied -->
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- FCC specific: Use ShipToLocationID/GLN if ShipToLocationID/SuppliersCode is missing -->
	<xsl:template match="ShipTo/ShipToLocationID">
		<!-- Copy the ShipToLocationID tag - needs to contain SuppliersCode only -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(./SuppliersCode) = ''">
					<!-- Nothing provided in CLOC(2), use CLOC(3) -->
					<xsl:element name="SuppliersCode">
						<!-- Since CLOC(2) was missing there will be no SuppliersCode tag, create and populate from CLOC(3) placeholder: GLN -->
						<xsl:value-of select="GLN"/>					
					</xsl:element>
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<!-- CLOC(2) was provided, copy and allow any GLN to be processed without being copied -->
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- FCC specific: InvoicedQuantity is currently the entire content of ILD-QTYI, INVOIC-ILD-QTYI (InvoiceLine/InvoicedQuantity) needs to be multiplied by -1 if (InvoiceLine/ProductID/GTIN) is NOT blank -->
	<xsl:template match="InvoiceLine/InvoicedQuantity">
		<!-- append a colon -->
		<xsl:variable name="QTY123" select="concat(string(.), ':')"/>
		<!-- QTY1 contains all chars before first : can be NaN -->
		<xsl:variable name="QTY1orNaN" select="number(substring-before($QTY123, ':'))"/>
		<!-- QTY2and3 contains all chars after first : can be null or contain other colons, will not start with a colon unless QTY(2) was empty -->
		<xsl:variable name="QTY23" select="substring-after($QTY123, ':')"/>
		<!-- Now attempt to extract the QTY2 value, can be null but will not contain colons - assume valid and correct for 3 D.P.-->
		<xsl:variable name="QTY2orNaN" select="number(substring-before($QTY23, ':')) div 1000.0"/>
		<!-- Copy the tag -->
		<xsl:copy>
			<!-- Write an empty tag if both QTY's are null -->
			<xsl:choose>
				<xsl:when test="string($QTY1orNaN) != 'NaN'">
					<!-- Using QTY(1) check if we need to negate it -->
					<xsl:choose>
						<xsl:when test="string-length(../ProductID/GTIN) &gt; 0">
							<!-- Should be negated -->
							<xsl:value-of select="$QTY1orNaN * -1"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- Use without negating -->
							<xsl:value-of select="$QTY1orNaN"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- Attempt to use QTY(2) -->
					<xsl:if test="string($QTY2orNaN) != 'NaN'">
						<!-- Using QTY(2) -->
						<xsl:choose>
							<xsl:when test="string-length(../ProductID/GTIN) &gt; 0">
								<!-- Should be negated -->
								<xsl:value-of select="$QTY2orNaN * -1"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- Use without negating -->
								<xsl:value-of select="$QTY2orNaN"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- INVOIC-ILD-LEXC(InvoiceLine/LineValueExclVAT) need to be multiplied by -1 if (InvoiceLine/ProductID/GTIN) is NOT blank -->
	<xsl:template match="InvoiceLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of GTIN -->
		<xsl:choose>
			<!--Parent of LineValueExclVAT is InvoiceLine -->
			<xsl:when test="string-length(../ProductID/GTIN) &gt; 0" >
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
	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
