<?xml version="1.0" encoding="UTF-8"?>
<!--******************************************************************
Alterations
**********************************************************************
Name			| Date			| Change
**********************************************************************
M Dimant		| 06/09/2011  |  Created. Derived from tsMappingHospitalityInvoiceTradacomsBatch.xsl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Dimant		| 07/09/2011  | Added creation of a Delivery Notes for Aramark. Hides the invoice.	
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		| 08/10/2013	| 7214 Added logic to complete senders branch reference for ISS HED.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		| 04/11/2013	| 7290 Do not map PO reference where value = 'NA'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
A Barber		| 28/11/2013	| 7465 Strip '/00' from delivery note reference.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
M Dimant		| 22/01/2014  | 7664 Major changes to NCB stylesheet to accomodate new fixed length format.

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
		<xsl:variable name="suppliersCodeForBuyer" select="translate(/Batch/BatchDocuments/BatchDocument/Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		
		
			<xsl:if test="$suppliersCodeForBuyer != '5027615900013'">
				<!-- Don't create invoices for Aramark -->
				<Document>
					<xsl:attribute name="TypePrefix">INV</xsl:attribute>
					<!-- Create invoice -->		
					<xsl:apply-templates/>
				</Document>
			</xsl:if>
			
			<xsl:if test="$suppliersCodeForBuyer = '5027615900013'">
				<!-- Create delivery notes for Aramark -->
				<Document>
					<xsl:attribute name="TypePrefix">DNB</xsl:attribute>				
					<!-- 2722 -->
					<xsl:call-template name="createDeliveryNotes"/>
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
	
	<!-- Create Sender Branch Reference if buyer is Aramark, otherwise don't.  --> 
	<xsl:template match="TradeSimpleHeader">
		<TradeSimpleHeader>		
		<xsl:choose>
			<xsl:when test="./Invoice/InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode='5027615900013'">
				<SendersCodeForRecipient><xsl:value-of select="substring-before(././././SendersCodeForRecipient,'-')"/></SendersCodeForRecipient>
				<SendersBranchReference><xsl:value-of select="substring-after(././././SendersCodeForRecipient,'-')"/></SendersBranchReference>
			</xsl:when>
			<xsl:when test="../InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode='5060166761103'">
				<SendersCodeForRecipient>
					<xsl:value-of select="../InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode"/>
				</SendersCodeForRecipient>
				<SendersBranchReference>
					<xsl:value-of select="substring(../InvoiceHeader/ShipTo/ShipToLocationID/SuppliersCode,8,1)"/>
				</SendersBranchReference>
			</xsl:when>
			<xsl:otherwise>
				<SendersCodeForRecipient><xsl:value-of select="SendersCodeForRecipient"/></SendersCodeForRecipient>
			</xsl:otherwise>
		</xsl:choose>	
		</TradeSimpleHeader>
	</xsl:template>

	<!-- InvoiceLine/ProductID/BuyersProductCode is used as a placeholder for INVOIC-ILD-CRLI and should not be copied over -->
	<xsl:template match="BuyersProductCode"/>
	
	<!-- Tags which need to be stripped of all leading zeros and have 2 optional trailing digits (not zero) -->
	<xsl:template match="InvoiceLine/LineNumber | Measure/UnitsInPack">
		<xsl:copy>
			<xsl:value-of select="format-number(., '#0.##')"/>
		</xsl:copy>
	</xsl:template>
	
		
	<xsl:template match="InvoiceLine">
	
		<InvoiceLine>
	
			<xsl:apply-templates select="LineNumber"/>
			<xsl:apply-templates select="PurchaseOrderConfirmationReferences"/>
			<xsl:apply-templates select="GoodsReceivedNoteReferences"/>
			<xsl:apply-templates select="ProductID"/>
			<xsl:apply-templates select="ProductDescription"/>
			<xsl:apply-templates select="OrderedQuantity"/>
			<xsl:apply-templates select="ConfirmedQuantity"/>
			<xsl:apply-templates select="DeliveredQuantity"/>
			
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
					<xsl:with-param name="givenUoM" select="./InvoicedQuantity/@UnitOfMeasure"/>
				</xsl:call-template>		
			</xsl:variable>			
		
	
			<xsl:variable name="POref"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></xsl:variable>
			<xsl:variable name="POdate"><xsl:value-of select="../InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate"/></xsl:variable>
			<xsl:if test="string($POdate) !='' and string($POref) != 'NA' and string($POref) != ''">
				<PurchaseOrderReferences>
					<PurchaseOrderReference><xsl:value-of select="$POref"/></PurchaseOrderReference>
					<PurchaseOrderDate>
						<xsl:value-of select="concat('20', substring($POdate, 5, 2), '-', substring($POdate, 3, 2), '-', substring($POdate, 1, 2))"/>
					</PurchaseOrderDate>						
				</PurchaseOrderReferences>
			</xsl:if>	
		
			<!-- Strip '/nn' component from delivery note reference -->	
			<DeliveryNoteReferences>
				<DeliveryNoteReference>
					<xsl:choose>
						<xsl:when test="contains(../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference,'/')">
							<xsl:value-of select="substring-before(../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference,'/')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/>
						</xsl:otherwise>
					</xsl:choose>
				</DeliveryNoteReference>				
				<DeliveryNoteDate>
				<xsl:variable name="DNdate"><xsl:value-of select="../InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteDate"/></xsl:variable>
					<xsl:value-of select="concat('20', substring($DNdate, 5, 2), '-', substring($DNdate, 3, 2), '-', substring($DNdate, 1, 2))"/>
				</DeliveryNoteDate>						
			</DeliveryNoteReferences>			
			
			<InvoicedQuantity>
				<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$sUoM"/></xsl:attribute>			
				<xsl:choose>
					<xsl:when test="substring-after(InvoicedQuantity,' ')=0">
						<xsl:value-of select="format-number(substring-before(InvoicedQuantity,' '),0000)"/>
					</xsl:when>
					<xsl:otherwise>						
						<xsl:value-of select="format-number((substring-after(InvoicedQuantity,' ')) div 1000.0, '0.00##')"/>
					</xsl:otherwise>
				</xsl:choose>							
			</InvoicedQuantity>
			
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
			<xsl:value-of select="concat('20', substring(., 5, 2), '-', substring(., 3, 2), '-', substring(., 1, 2))"/>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYMMDD:[HHMMSS] to xsd:dateTime CCYY-MM-DDTHH:MM:SS+00:00 -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 13">
					<!-- Convert YYMMDD: to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 5, 2), '-', substring(., 3, 2), '-', substring(., 1, 2), 'T00:00:00')"/>
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

	
	
	<xsl:template name="createDeliveryNotes">
	
		<Batch>
			<BatchDocuments>
				<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
					<BatchDocument>
						<xsl:attribute name="DocumentTypeNo">7</xsl:attribute>
						<DeliveryNote>					
							<TradeSimpleHeader>		
								<xsl:choose>
									<xsl:when test="//InvoiceHeader/Buyer/BuyersLocationID/SuppliersCode='5027615900013'">
										<SendersCodeForRecipient><xsl:value-of select="substring-before(././././TradeSimpleHeader/SendersCodeForRecipient,'-')"/></SendersCodeForRecipient>
										<SendersBranchReference><xsl:value-of select="substring-after(././././TradeSimpleHeader/SendersCodeForRecipient,'-')"/></SendersBranchReference>
									</xsl:when>
									<xsl:otherwise>
										<SendersCodeForRecipient><xsl:value-of select="././././TradeSimpleHeader/SendersCodeForRecipient"/></SendersCodeForRecipient>
									</xsl:otherwise>
								</xsl:choose>	
							</TradeSimpleHeader>
							<DeliveryNoteHeader>
								<DocumentStatus>Original</DocumentStatus>
								<!--xsl:copy-of select="InvoiceHeader/Buyer"/-->
								<xsl:copy-of select="InvoiceHeader/Supplier"/>
								<xsl:copy-of select="InvoiceHeader/ShipTo"/>
								<xsl:if test="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference != '' and InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderDate != ''">
									<PurchaseOrderReferences>
										<xsl:if test="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference != ''">
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
								<xsl:for-each select="InvoiceDetail/InvoiceLine[not(ProductID/BuyersProductCode = '1')]">
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
			<xsl:when test="$givenUoM = 'CASE'">CS</xsl:when>
			<xsl:when test="$givenUoM = 'DOZEN'">DZN</xsl:when>
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
