<?xml version="1.0" encoding="UTF-8"?>
<!--======================================================================================

Maps 3663 tradacoms invoices into internal XML

==========================================================================================
 Module History
==========================================================================================
 Version		| 
==========================================================================================
 Date      		| Name 						|	Description of modification
==========================================================================================
06/03/2013	| M Dimant					|	6114: Created. Based on 3663 stylesheets.
==========================================================================================
09/04/2013	| M Dimant					|	6364: Fixed  PO reference for every line
==========================================================================================
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
			<Document>	
				<xsl:attribute name="TypePrefix">INV</xsl:attribute>
				<xsl:apply-templates/>
			</Document>
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
	<!--<xsl:template match="GTIN"/> Redundant as 3663 mapper has template for entire ProductID tag-->
	<!-- 3663 Specific -  InvoiceLine/ProductID/BuyersProductCode is a placeholder containing ILD sequence number to ensure that FFS output always contains a ProductID tag, value can be discarded -->
	<!--<xsl:template match="BuyersProductCode"/>Redundant for the same reasons -->
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- 3663 specific - Manual product lines: SuppliersProductCode can be missing, but ProductID and underlying BuyersProductCode (a placeholder) will always be present -->
	<xsl:template match="InvoiceLine/ProductID">
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
	
	<!-- Also 3663 specific - combine first 2 chars of IRF-INVN with (fragment of CLO-CLOC(2) before / or ? and left padded with zeroes to 6 chars) to produce real SendersCodeForRecipient and ShipToLocationID/SuppliersCode-->
	<xsl:template match="TradeSimpleHeader/SendersCodeForRecipient">
		<xsl:copy>
			<xsl:call-template name="Combine3663DocRefAndCLOC2">
				<!-- DocRef requires backout to TradeSimpleHeader, backout to Invoice, then find InvoiceHeader -->
				<xsl:with-param name="DocRef" select="../../InvoiceHeader/InvoiceReferences/InvoiceReference"/>
				<!-- CLO-CLOC(2) is in the current node -->
				<xsl:with-param name="CLOC2" select="."/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="ShipToLocationID/SuppliersCode">
		<xsl:copy>
			<xsl:call-template name="Combine3663DocRefAndCLOC2">
				<!-- DocRef requires backout to ShipToLocationID, another backout to ShipTo and another to InvoiceHeader -->
				<xsl:with-param name="DocRef" select="../../../InvoiceReferences/InvoiceReference"/>
				<!-- CLO-CLOC(2) requires backout to ShipToLocationID, another backout to ShipTo, another to InvoiceHeader and another to Invoice -->
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
		
		
		<!-- 2838 -->
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
	
	<!-- 3663 specific, H433 implemenatation ensure unique FGNs by prepending SendersBranchReference to left 0 padded original FGN -->
	<xsl:template match="BatchInformation/FileGenerationNo">
		<xsl:variable name="FGN" select="string(.)"/>
		<xsl:variable name="FGNLength" select="string-length($FGN)"/>
		<xsl:variable name="PaddedFGN" select="substring(concat('0000', $FGN), 1 + $FGNLength)"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="($FGNLength &gt; 0) and ($FGNLength &lt; 5) and (string(number($FGN)) != 'NaN')">
					<!-- Action to take if FGN is between 1 and 4 in length and is a numeric:  -->
					<!-- Back out to BatchInformation, again to DocumentHeader, again to Invoice/CreditNote, then down into TradeSimpleHeader, and again into SendersBranchReference -->
					<xsl:variable name="SBR" select="string(../../../TradeSimpleHeader/SendersBranchReference)"/>
					<xsl:variable name="SBRLength" select="string-length($SBR)"/>
					<xsl:choose>
						<xsl:when test="($SBRLength &gt; 0) and ($SBRLength &lt; 5) and (string(number($SBR)) != 'NaN')">
							<!-- Action to take when SBR is numeric and between 1 and 4 characters long -->
							<xsl:value-of select="concat($SBR, $PaddedFGN)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('FGN cannot be combined with SBR: ', $SBR, ' to meet requirements of H433')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('FGN: ', $FGN, ' does not meet requirements of H433')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!--  End of this 3663 specific block -->
	
		<xsl:template match="InvoiceLine/InvoicedQuantity">		
		
		<InvoicedQuantity>
		
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
			
					
			
			<xsl:choose>
				<!-- Check and map from wt'd item segments -->
				<xsl:when test="string(../Measure/TotalMeasure) !='' ">
					<xsl:value-of select="format-number(../Measure/TotalMeasure div 1000,'0.000#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>			
		
		</InvoicedQuantity>
		
		
	</xsl:template>
	
	<xsl:template match="InvoiceLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of GTIN -->
		<xsl:call-template name="copyCurrentNodeExplicit4DP"/>
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
	
	<xsl:template match="InvoiceDetail">
		<InvoiceDetail>
			<xsl:for-each select="InvoiceLine">
			<xsl:variable name="sPORefDate" select="translate(../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate,' ','')"/>
			<xsl:variable name="sPORefReference" select="translate(../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference,' ','')"/>			
					<InvoiceLine>			
						<xsl:copy-of select="LineNumber"/>
						<PurchaseOrderReferences>
							<PurchaseOrderReference>
								<xsl:value-of select="$sPORefReference"/>
							</PurchaseOrderReference>
							<PurchaseOrderDate>
								<xsl:value-of select="concat('20',substring($sPORefDate,1,2),'-',substring($sPORefDate,3,2),'-',substring($sPORefDate,5,2))"/>
							</PurchaseOrderDate>
						</PurchaseOrderReferences>
						<DeliveryNoteReferences>
							<xsl:variable name="sDNRefDate" select="translate(../InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate,' ','')"/>
							<DeliveryNoteReference><xsl:value-of select="../InvoiceLine/DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
							<DeliveryNoteDate><xsl:value-of select="concat('20',substring($sDNRefDate,1,2),'-',substring($sDNRefDate,3,2),'-',substring($sDNRefDate,5,2))"/></DeliveryNoteDate>
							<DespatchDate><xsl:value-of select="concat('20',substring($sDNRefDate,1,2),'-',substring($sDNRefDate,3,2),'-',substring($sDNRefDate,5,2))"/></DespatchDate>
						</DeliveryNoteReferences>
						<xsl:copy-of select="ProductID"/>
						<xsl:copy-of select="ProductDescription"/>
						<xsl:copy-of select="InvoicedQuantity"/>
						<xsl:copy-of select="PackSize"/>
						<xsl:copy-of select="UnitValueExclVAT"/>
						<xsl:copy-of select="LineValueExclVAT"/>
						<xsl:copy-of select="VATCode"/>
						<xsl:copy-of select="VATRate"/>
						<xsl:copy-of select="Measure"/>
					</InvoiceLine>			
			</xsl:for-each>	
		</InvoiceDetail>
	</xsl:template>	
	
	<!-- END of MHDSegment HANDLER -->
	
	<xsl:template name="createDeliveryNotes">
	
		<Batch>
			<BatchDocuments>
				<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
					<BatchDocument>
						<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
						<DeliveryNote>
							<TradeSimpleHeader>
								<SendersCodeForRecipient>
									<xsl:value-of select="TradeSimpleHeader/SendersCodeForRecipient"/>
								</SendersCodeForRecipient>
								<xsl:if test="TradeSimpleHeader/SendersBranchReference != ''">
									<SendersBranchReference>
										<xsl:value-of select="TradeSimpleHeader/SendersBranchReference"/>
									</SendersBranchReference>
								</xsl:if>
							</TradeSimpleHeader>
							<DeliveryNoteHeader>
								<DocumentStatus>Original</DocumentStatus>
								<xsl:copy-of select="InvoiceHeader/Buyer"/>
								<xsl:copy-of select="InvoiceHeader/Supplier"/>
								<xsl:copy-of select="InvoiceHeader/ShipTo"/>
								<xsl:if test="//InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference != '' ">
									<PurchaseOrderReferences>
										<xsl:if test="InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderReference != ''">
											<PurchaseOrderReference>
												<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/>
											</PurchaseOrderReference>
										</xsl:if>
										<xsl:if test="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate != ''">
											<xsl:variable name="sDPODate">
												<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/>
											</xsl:variable>
											<PurchaseOrderDate>
												<xsl:value-of select="concat('20',substring($sDPODate,1,2),'-',substring($sDPODate,3,2),'-',substring($sDPODate,5,2))"/>
											</PurchaseOrderDate>
										</xsl:if>
									</PurchaseOrderReferences>
								</xsl:if>	
								<DeliveryNoteReferences>
									<DeliveryNoteReference>
										<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
									</DeliveryNoteReference>
									<xsl:variable name="dDDelNoteDate">
										<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
									</xsl:variable>
									<DeliveryNoteDate>
										<xsl:value-of select="concat('20',substring($dDDelNoteDate,1,2),'-',substring($dDDelNoteDate,3,2),'-',substring($dDDelNoteDate,5,2))"/>
									</DeliveryNoteDate>
								</DeliveryNoteReferences>
							</DeliveryNoteHeader>
							<DeliveryNoteDetail>
								<xsl:for-each select="InvoiceDetail/InvoiceLine">
									<DeliveryNoteLine>
										<xsl:copy-of select="ProductID"/>
										<xsl:copy-of select="ProductDescription"/>
										
										<xsl:variable name="sQuantity">
											<xsl:choose>
												<xsl:when test="string(./*[TotalMeasureIndicator]/TotalMeasure) != ''">
													<xsl:for-each select="./Measure/TotalMeasure[1]">
														<xsl:call-template name="copyCurrentNodeExplicit3DP"/>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="InvoicedQuantity"/></xsl:otherwise>
											</xsl:choose>		
										</xsl:variable>
										
										<xsl:variable name="sUoM">
											<xsl:call-template name="translateUoM">
												<xsl:with-param name="givenUoM" select="./Measure/TotalMeasureIndicator"/>
											</xsl:call-template>		
										</xsl:variable>
								
										<DespatchedQuantity>
											<xsl:if test="string-length($sUoM) &gt; 0">
												<xsl:attribute name="UnitOfMeasure">
													<xsl:value-of select="$sUoM"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="$sQuantity"/>			
										</DespatchedQuantity>
										
										<xsl:copy-of select="PackSize"/>
									</DeliveryNoteLine>
								</xsl:for-each>
							</DeliveryNoteDetail>
							<xsl:if test="InvoiceTrailer/NumberOfLines != ''">
								<DeliveryNoteTrailer>
									<xsl:copy-of select="InvoiceTrailer/NumberOfLines"/>
								</DeliveryNoteTrailer>
							</xsl:if>
						</DeliveryNote>
					</BatchDocument>
				</xsl:for-each>
			</BatchDocuments>
		</Batch>

	</xsl:template>
	
	<!-- Templates shared by both doc types -->
	<xsl:template name="translateUoM">
		<xsl:param name="givenUoM"/>
		
		<xsl:choose>
			<xsl:when test="$givenUoM = 'KG'">KGM</xsl:when>
			<xsl:when test="$givenUoM = 'EACH'">EA</xsl:when>
			<xsl:otherwise><xsl:value-of select="$givenUoM"/></xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
