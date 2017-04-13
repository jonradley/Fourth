<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************
Alterations
**********************************************************************
Name		| Date			| Change
**********************************************************************
S Jefford	| 22/08/2005		| GTIN field now sourced from ILD/SPRO(1).
				|						| ILD/CRLI now stored in BuyersProductCode
**********************************************************************
N Emsen		|	14/09/2006	|	Purchase order date stipped if = blank
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N Emsen		|	21/09/2006	|	Case: To only create purchase order 
				|						|	references if both Date and Reference are
				|						|	present.
				|						|	Ready to live.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		|	19/10/2011	|	FB 4907: Created POD document type from invoice for Spirit.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		|	29/05/2013	|	FB 6600: Added Spirit Franchise to POD creation and applied 'correct' (expected) sender code value mapping in header and ship to.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		|	06/02/2014	|	FB 7695: Added new system Spirit codes in SCfR and SuppliersCode ship to determination.
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
			<!-- Start Generation POD's for Spirit -->
			<xsl:if test="/Batch/BatchDocuments/BatchDocument/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode='5060166761066' or /Batch/BatchDocuments/BatchDocument/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode='5060166761226'">
				<Document>
	           			<xsl:attribute name="TypePrefix">POD</xsl:attribute>
					<Batch>
						<BatchDocuments>
							<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
								<BatchDocument>
									<xsl:attribute name="DocumentTypeNo">313</xsl:attribute>
									<ProofOfDelivery>
										<xsl:apply-templates select="TradeSimpleHeader"/>
										<ProofOfDeliveryHeader>
											<xsl:apply-templates select="InvoiceHeader/Buyer"/>
											<xsl:apply-templates select="InvoiceHeader/Supplier"/>
											<xsl:apply-templates select="InvoiceHeader/ShipTo"/>
											<PurchaseOrderReferences>									
												<PurchaseOrderReference>
													<xsl:value-of select="(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference | InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference)[1]"/>
												</PurchaseOrderReference>
												<xsl:variable name="sDPODate">
													<xsl:value-of select="(InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate | InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate)[1]"/>
												</xsl:variable>
												<PurchaseOrderDate>
													<xsl:value-of select="concat('20',substring($sDPODate,1,2),'-',substring($sDPODate,3,2),'-',substring($sDPODate,5,2))"/>
												</PurchaseOrderDate>
											</PurchaseOrderReferences>
											<ProofOfDeliveryReferences>
												<ProofOfDeliveryReference>
													<xsl:value-of select="InvoiceHeader/InvoiceReferences/InvoiceReference"/>
												</ProofOfDeliveryReference>
												<xsl:variable name="dDPODDate">
													<xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/>
												</xsl:variable>
												<ProofOfDeliveryDate>
													<xsl:value-of select="concat('20',substring($dDPODDate,1,2),'-',substring($dDPODDate,3,2),'-',substring	($dDPODDate,5,2))"/>
												</ProofOfDeliveryDate>
											</ProofOfDeliveryReferences>										
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
										</ProofOfDeliveryHeader>
										<ProofOfDeliveryDetail>
											<xsl:for-each select="InvoiceDetail/InvoiceLine">
												<xsl:choose>
													<xsl:when test="ProductID/BuyersProductCode"/>
													<xsl:otherwise>
														<ProofOfDeliveryLine>
															<xsl:apply-templates select="ProductID"/>
															<xsl:apply-templates select="ProductDescription"/>
															<DespatchedQuantity>
																<xsl:value-of select="InvoicedQuantity"/>
															</DespatchedQuantity>
															<xsl:apply-templates select="PackSize"/>
														</ProofOfDeliveryLine>									
													</xsl:otherwise>
												</xsl:choose>
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
	
	<!-- Use the correct supplier code for Spirit in the tradesimple header -->
	<xsl:template match="Invoice/TradeSimpleHeader">
		<TradeSimpleHeader>
			<SendersCodeForRecipient>
				<xsl:choose >
					<xsl:when test="string(SendersBranchReference)!='1066546' and string(SendersBranchReference)!='1083067' and string(SendersBranchReference)!='5809416' and string(SendersBranchReference)!='5823984'">
						<xsl:value-of select="SendersCodeForRecipient"/>		
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
					</xsl:otherwise>
				</xsl:choose>
			</SendersCodeForRecipient>
			<SendersBranchReference>
				<xsl:value-of select="SendersBranchReference"/>
			</SendersBranchReference>
		</TradeSimpleHeader>
	</xsl:template>

	<!-- Use BuyersCode as SuppliersCode for non-Spirit Invoices -->
	<xsl:template match="ShipTo/ShipToLocationID">
		<ShipToLocationID>
			<BuyersCode>
				<xsl:value-of select="BuyersCode"/>
			</BuyersCode>
			<SuppliersCode>
				<xsl:choose>
					<xsl:when test="string(../../../TradeSimpleHeader/SendersBranchReference)!='1066546' and string(../../../TradeSimpleHeader/SendersBranchReference)!='1083067' and string(../../../TradeSimpleHeader/SendersBranchReference)!='5809416' and string(../../../TradeSimpleHeader/SendersBranchReference)!='5823984'">
						<xsl:value-of select="BuyersCode"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="SuppliersCode"/>
					</xsl:otherwise>
				</xsl:choose>
			</SuppliersCode>
		</ShipToLocationID>
	</xsl:template>
	
	<!-- This is so we dont duplicate block Carlsberg's invoice's on FGN -->
	<xsl:template match="Invoice/InvoiceHeader/BatchInformation/FileGenerationNo">
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
	
	<msxsl:script language="JScript" implements-prefix="jscript"><![CDATA[ 
		function toUpperCase(vs) {
			return vs.toUpperCase();
			//return vs;
		}
	]]></msxsl:script>
	
</xsl:stylesheet>
