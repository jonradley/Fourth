<?xml version="1.0" encoding="UTF-8"?>
<!--
Maps Bidvest tradacoms credits into internal XML

06/11/2012	M Dimant		5834: Created. Based on 3663 stylesheet.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	<!-- NOTE that these string literals are not only enclosed with double quotes, but have single quotes within also-->
	<xsl:variable name="FileHeaderSegment" select="'CREHDR'"/>
	<xsl:variable name="DocumentSegment" select="'CREDIT'"/>
	<xsl:variable name="FileTrailerSegment" select="'CRETLR'"/>
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
	
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="CreditNoteLine/LineNumber">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- 3663 specific - Manual product lines: SuppliersProductCode can be missing, but ProductID and underlying BuyersProductCode (a placeholder) will always be present -->
	<xsl:template match="CreditNoteLine/ProductID">
		<!-- Copy always-present ProductID tag -->
		<xsl:copy>
			<xsl:element name="SuppliersProductCode">
				<xsl:choose>
					<xsl:when test="string-length(SuppliersProductCode) &gt; 0" >
						<xsl:value-of select="SuppliersProductCode"/>
					</xsl:when>				
					<xsl:otherwise>
						<xsl:value-of select="'MANUAL'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	
	<!-- Also 3663 specific - combine first 2 chars of CRF-CRNR with (fragment of CLO-CLOC(2) before / or ? and left padded with zeroes to 6 chars) to produce real SendersCodeForRecipient and ShipToLocationID/SuppliersCode-->
	<xsl:template match="TradeSimpleHeader/SendersCodeForRecipient">
		<xsl:copy>
			<xsl:call-template name="Combine3663DocRefAndCLOC2">
				<!-- DocRef requires backout to TradeSimpleHeader, backout to CreditNote, then find CreditNoteHeader -->
				<xsl:with-param name="DocRef" select="../../CreditNoteHeader/CreditNoteReferences/CreditNoteReference"/>
				<!-- CLO-CLOC(2) is in the current node -->
				<xsl:with-param name="CLOC2" select="."/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ShipToLocationID/SuppliersCode">
		<xsl:copy>
			<xsl:call-template name="Combine3663DocRefAndCLOC2">
				<!-- DocRef requires backout to ShipToLocationID, another backout to ShipTo and another to CreditNoteHeader -->
				<xsl:with-param name="DocRef" select="../../../CreditNoteReferences/CreditNoteReference"/>
				<!-- CLO-CLOC(2) requires backout to ShipToLocationID, another backout to ShipTo, another to CreditNoteHeader and another to CreditNote -->
				<xsl:with-param name="CLOC2" select="../../../../TradeSimpleHeader/SendersCodeForRecipient"/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="Combine3663DocRefAndCLOC2">
		<xsl:param name="DocRef"/>
		<xsl:param name="CLOC2"/>
		
		<xsl:variable name="locationWithoutSuffix">
			<xsl:variable name="CLOC2Fragment" select="substring-before(translate(concat($CLOC2, '?'), '/', '?'), '?')"/>
			<!-- Now create left pad string with enough zeroes to make final CLOC2 Fragment 6 chars: if fragment was length 0, copy starts at posn 1 to end - 6 chars, if length was 6 copy starts at posn 7 - 0 chars -->
			<xsl:variable name="CLOC2LeadingZeroString" select="substring('000000', 1 + string-length($CLOC2Fragment))"/>
			<!-- Now create our always 6 character CLOC2Fragment -->
			<xsl:value-of select="concat($CLOC2LeadingZeroString, $CLOC2Fragment)"/>
		</xsl:variable>
		
		<xsl:variable name="locationCodeLength" select="string-length($locationWithoutSuffix)"/>
		
		<!--xsl:variable name="suffixCode" select="substring-after(translate(concat($CLOC2, '?'), '/', '?'), '?')"/-->
		<xsl:variable name="suffixCode" select="substring-after(translate($CLOC2, '/', '?'), '?')"/>

		
		<xsl:variable name="depotCode">
			<xsl:choose>
				<!-- 8 digit codes should start with a depot code -->
				<xsl:when test="string-length($DocRef) = 8">
					<xsl:value-of select="substring($DocRef,1,2)"/>
				</xsl:when>
				
				<!-- 6 digit codes don't -->
				<xsl:otherwise/>
			</xsl:choose>
		
		</xsl:variable>
		
		
		<xsl:choose>
		
			<!-- Check which 3663 system this code relates to derive the location code accordingly -->
			
			<xsl:when test="$locationCodeLength = 6 and $suffixCode = '8'">
				<!-- Frozen codes used on the Crystal system -->
				<!-- ======================================= -->
				<!-- Recover the 6 digit code needed for ordering -->
				
				<xsl:value-of select="$locationWithoutSuffix"/>
			
			</xsl:when>
			
			<xsl:when test="$locationCodeLength = 6 and $suffixCode = 'A'">
				<!-- Multi-temp codes used on the Crystal system -->
				<!-- =========================================== -->
				<!-- Recover the 8 digit code needed for ordering -->
				
				<xsl:value-of select="$depotCode"/>
				<xsl:value-of select="$locationWithoutSuffix"/>
			
			</xsl:when>
			
			<xsl:when test="$locationCodeLength = 8 and starts-with($locationWithoutSuffix, '00')">
				<!-- Frozen codes migrated from Crystal to the AX system -->
				<!-- =================================================== -->
				<!-- Recover the 6 digit code needed for ordering -->
				
				<xsl:value-of select="substring-after($locationWithoutSuffix, '00')"/>
				
			</xsl:when>
			
			<xsl:otherwise>
				<!-- MT codes migrated from Crystal to the AX system -->
				<!--  and codes newly created on the AX system -->		
				<!-- =============================================== -->		
				<!-- Don't change the code -->
				
				<!-- (NB 3663 haven't confirmed how new AX codes should be set up when ordering on Frozen) -->	
						
				<xsl:value-of select="$CLOC2"/>
			
			</xsl:otherwise>
			
		</xsl:choose>
			
	</xsl:template>
	
		
	<xsl:template match="CreditNoteReferences/VATRegNo">
		<xsl:copy>
			<!-- Convert all colons to spaces, then trim leading and trailing whitespace - trims leading and trailing colons, and converts mid string colons to spaces -->
			<xsl:value-of select="normalize-space(translate(., ':', ' '))"/>
		</xsl:copy>
	</xsl:template>
	

	<xsl:template match="CreditNoteLine/CreditedQuantity">
		
		
		<CreditedQuantity>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:choose>
					<!-- If the product code ends in S it's a single -->
					<xsl:when test="substring(../ProductID/SuppliersProductCode,string-length(../ProductID/SuppliersProductCode))='S'">EA</xsl:when>
					<!-- if there's a weight it's in kilos -->
					<xsl:when test="string(../Measure/TotalMeasure) !=''">KGM</xsl:when>
					<!-- Every thing else is a case -->
					<xsl:otherwise>CS</xsl:otherwise>
				</xsl:choose>		
			</xsl:attribute>
			
			<!-- If this is a credit line, make the quantity negative  -->
			<xsl:if test="string-length(../ProductID/GTIN) &gt; 0">-</xsl:if>			
			
			<xsl:choose>
				<!-- Check and map from wt'd item segments -->
				<xsl:when test="string(../Measure/TotalMeasure) !='' ">
					<xsl:value-of select="format-number(../Measure/TotalMeasure div 1000,'0.000#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>	
		</CreditedQuantity>
		
	</xsl:template>
	
	
	<!-- CLD-EXLV (CreditNoteLine/LineValueExclVAT) need to be multiplied by -1 if (CreditNoteLine/ProductID/GTIN) is NOT blank -->
	<xsl:template match="CreditNoteLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of GTIN -->
		<xsl:choose>
			<!--Parent of LineValueExclVAT is CreditNoteLine -->
			<xsl:when test="string-length(../ProductID/GTIN) &gt; 0" >
				<!--CLD-DRLI is not blank, multiply by -1-->
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
						CreditNoteTrailer/DocumentTotalExclVAT |
						CreditNoteTrailer/SettlementDiscount |
						CreditNoteTrailer/SettlementTotalExclVAT |
						CreditNoteTrailer/VATAmount |
						CreditNoteTrailer/DocumentTotalInclVAT |
						CreditNoteTrailer/SettlementTotalInclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit2DP"/>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 3 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 3 D.P. -->
	<xsl:template match="TotalMeasure">
		<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
	</xsl:template>
	<!--Add any attribute XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="VATSubTotal/@VATRate">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:attribute>
	</xsl:template>
	<!--Add any element XPath whose value needs to be converted from implicit 3 D.P to explicit 2 D.P. -->
	<xsl:template match="CreditNoteLine/VATRate">
		<xsl:copy>
			<xsl:value-of select="format-number(. div 1000.0, '0.00')"/>
		</xsl:copy>
	</xsl:template>
	<!-- SIMPLE CONVERSION IMPLICIT TO EXPLICIT 4 D.P -->
	<!-- Add any XPath whose text node needs to be converted from implicit to explicit 4 D.P. -->
	<xsl:template match="CreditNoteLine/UnitValueExclVAT">
		<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
	</xsl:template>
	<!-- END of SIMPLE CONVERSIONS-->

	<!-- DATE CONVERSION YYMMDD to xsd:date -->
	<xsl:template match="PurchaseOrderReferences/PurchaseOrderDate | 
						CreditNoteReferences/CreditNoteDate |
						BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
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
	CREDIT segments, which are only required at document level, under CreditNoteHeader, so the following template does not copy those.
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
	<xsl:template match="BatchDocument/CreditNote/CreditNoteHeader">
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
