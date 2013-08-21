<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Name		| Date			| Change
**********************************************************************
S Jefford	| 22/08/2005	| GTIN field now sourced from CLD/SPRO(1).
			|				| CLD/DRLI now stored in BuyersProductCode
**********************************************************************
	KO		|28/01/2010	| a change so we wont duplicate block on FGN by putting the GLN in the FGN tag
**********************************************************************
 06/02/2012 | H Robson 	| 5236 Generate PODs for Spirit
**********************************************************************
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
			<!-- Start Generation POD's for Spirit -->
			<!-- 2012 02 06 - POD template copied in/modified from Invoice mapper -->
			<xsl:if test="/Batch/BatchDocuments/BatchDocument/CreditNote[CreditNoteDetail/CreditNoteLine/CreditedQuantity &lt; 0]/CreditNoteHeader/Buyer/BuyersLocationID/SuppliersCode='5060166761066'"> <!-- recipient = Spirit -->
				<Document>
	           			<xsl:attribute name="TypePrefix">POD</xsl:attribute>
					<Batch>
						<BatchDocuments>
							<xsl:for-each select="Batch/BatchDocuments/BatchDocument/CreditNote[CreditNoteDetail/CreditNoteLine/CreditedQuantity &lt; 0]">
								<BatchDocument>
									<xsl:attribute name="DocumentTypeNo">313</xsl:attribute>
									<ProofOfDelivery>
										<xsl:apply-templates select="TradeSimpleHeader"/>
										<ProofOfDeliveryHeader>
											<xsl:apply-templates select="CreditNoteHeader/Buyer"/>
											<xsl:apply-templates select="CreditNoteHeader/Supplier"/>
											<xsl:apply-templates select="CreditNoteHeader/ShipTo"/>
											
											<xsl:variable name="dDPODDate">
												<!-- 2012-02-29 use the DeliveryNoteDate if possible, if not use CreditNoteDate as next best thing -->
												<xsl:choose>
													<xsl:when test="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate != ''">
														<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="CreditNoteHeader/CreditNoteReferences/CreditNoteDate"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											
											<PurchaseOrderReferences>									
												<PurchaseOrderReference>
													<xsl:value-of select="(CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderReference | CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference)[1]"/>
												</PurchaseOrderReference>
												<xsl:variable name="sDPODate">
													<xsl:value-of select="(CreditNoteDetail/CreditNoteLine[1]/PurchaseOrderReferences/PurchaseOrderDate | CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate)[1]"/>
												</xsl:variable>
												<PurchaseOrderDate>
													<xsl:value-of select="concat('20',substring($sDPODate,1,2),'-',substring($sDPODate,3,2),'-',substring($sDPODate,5,2))"/>
												</PurchaseOrderDate>
											</PurchaseOrderReferences>
											<ProofOfDeliveryReferences>
												<ProofOfDeliveryReference>
													<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
												</ProofOfDeliveryReference>
												<ProofOfDeliveryDate>
													<xsl:value-of select="concat('20',substring($dDPODDate,1,2),'-',substring($dDPODDate,3,2),'-',substring($dDPODDate,5,2))"/>
												</ProofOfDeliveryDate>
											</ProofOfDeliveryReferences>										
											<DeliveryNoteReferences>
												<DeliveryNoteReference>
													<!-- 2012-03-05 use the DeliveryNoteReference if possible, if not use InvoiceReference as next best thing -->
													<xsl:choose>
														<xsl:when test="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference != ''">
															<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="CreditNoteHeader/InvoiceReferences/InvoiceReference"/>
														</xsl:otherwise>
													</xsl:choose>
												</DeliveryNoteReference>
												<!--<xsl:variable name="dDDelNoteDate">
													<xsl:value-of select="CreditNoteDetail/CreditNoteLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
												</xsl:variable>-->
												<DeliveryNoteDate>
													<xsl:value-of select="concat('20',substring($dDPODDate,1,2),'-',substring($dDPODDate,3,2),'-',substring($dDPODDate,5,2))"/>
												</DeliveryNoteDate>
											</DeliveryNoteReferences>								
										</ProofOfDeliveryHeader>
										<ProofOfDeliveryDetail>
											<!-- for creditnote lines with a negative quantity i.e. invoice lines on a credit, generate a POD line  -->
											<xsl:for-each select="CreditNoteDetail/CreditNoteLine[CreditedQuantity &lt; 0]">
												<ProofOfDeliveryLine>
													<xsl:apply-templates select="ProductID"/>
													<xsl:apply-templates select="ProductDescription"/>
													<DespatchedQuantity>
														<!-- value needs to become positive -->
														<xsl:value-of select="CreditedQuantity * -1"/>
													</DespatchedQuantity>
													<xsl:apply-templates select="PackSize"/>
												</ProofOfDeliveryLine>									
											</xsl:for-each>
										</ProofOfDeliveryDetail>
									</ProofOfDelivery>
								</BatchDocument>
							</xsl:for-each>
						</BatchDocuments>
					</Batch>
				</Document>
			</xsl:if>		
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
	
	<!-- This is so we dont duplicate block Carlsberg's Credit notes's on FGN -->
	<xsl:template match="CreditNote/CreditNoteHeader/BatchInformation/FileGenerationNo">
		<xsl:copy>
			<xsl:value-of select="."/>
			<xsl:text> (</xsl:text>
			<xsl:value-of select="../../Buyer/BuyersLocationID/SuppliersCode"/>
			<xsl:text>)</xsl:text>
		</xsl:copy>
	</xsl:template>	
	
	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="CreditNoteLine/LineNumber">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="CreditNoteReferences/VATRegNo">
		<xsl:copy>
			<!-- Convert all colons to spaces, then trim leading and trailing whitespace - trims leading and trailing colons, and converts mid string colons to spaces -->
			<xsl:value-of select="normalize-space(translate(., ':', ' '))"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- CLD-QTYC(1) (CreditNoteLine/CreditedQuantity) needs to be multiplied by -1 if (CreditNoteLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="CreditNoteLine/CreditedQuantity">
		<xsl:choose>
			<!--Parent of CreditedQuantity is CreditNoteLine-->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
				<!--CLD-DRLI is not blank, multiply by -1-->
				<xsl:call-template name="copyCurrentNodeDPUnchanged">
					<xsl:with-param name="lMultiplier" select="-1.0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copyCurrentNodeDPUnchanged"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- CLD-EXLV (CreditNoteLine/LineValueExclVAT) need to be multiplied by -1 if (CreditNoteLine/ProductID/BuyersProductCode) is NOT blank -->
	<xsl:template match="CreditNoteLine/LineValueExclVAT">
		<!-- Implicit 4DP conversion required regardless of BuyersProductCode -->
		<xsl:choose>
			<!--Parent of LineValueExclVAT is CreditNoteLine -->
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0" >
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
	
	<!--Don't copy invoicereferences if no invoice reference is present-->
	<xsl:template match="InvoiceReferences[not(InvoiceReference)]">
		
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
	

	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
