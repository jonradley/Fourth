<?xml version="1.0" encoding="UTF-8"?>
<!--
*******************************************************************************************************************
21/06/2012	| Mark Emanuel	| FB 5529 New Invoice and Delivery Note Mapper for John Sheppard
*******************************************************************************************************************
07/01/2013	| Mark Emanuel	| FB 5885 Created from tsMappingHospitalitySeafoodHoldingsInvoiceTradacomsBatch.xsl
*******************************************************************************************************************
30/04/2013	| Sahir Husssain| FB 5885 Corrected purchase order date formatting.
*******************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:jscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="utf-8"/>
	<!-- we use constants for default values -->
	<xsl:variable name="defaultDocumentDiscountRate" select="'0'"/>
	<xsl:variable name="defaultSettlementDiscountRate" select="'0'"/>
	<xsl:variable name="defaultDocumentDiscountValue" select="'0'"/>
	<xsl:template match="/">
		<BatchRoot>
			<Document>
				<xsl:attribute name="TypePrefix">INV</xsl:attribute>
				<xsl:apply-templates/>
			</Document>
			<Document>
				<xsl:attribute name="TypePrefix">DNB</xsl:attribute>
				<xsl:call-template name="createDeliveryNotes"/>
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
			<xsl:apply-templates select="PurchaseOrderReferences"/>
			<xsl:apply-templates select="PurchaseOrderConfirmationReferences"/>
			<xsl:apply-templates select="DeliveryNoteReferences"/>
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
					<xsl:otherwise>
						<xsl:value-of select="InvoicedQuantity"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="sUoM">
				<xsl:choose>
					<xsl:when test="string(InvoicedQuantity/@UnitOfMeasure) = 'KG' or string(InvoicedQuantity/@UnitOfMeasure) = 'KGM' ">KGM</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="InvoicedQuantity/@UnitOfMeasure"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<InvoicedQuantity>
				<xsl:if test="string-length($sUoM) &gt; 0">
					<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$sUoM"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="string-length(./ProductID/BuyersProductCode) &gt; 0">-</xsl:if>
				<xsl:value-of select="$sQuantity"/>
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
			<xsl:when test="string-length(../ProductID/BuyersProductCode) &gt; 0">
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
		<xsl:attribute name="{name()}"><xsl:value-of select="format-number(. div 1000.0, '0.00')"/></xsl:attribute>
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
			<xsl:value-of select="concat('20', substring(., 3, 2), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:copy>
	</xsl:template>
	<!-- DATE CONVERSION YYMMDD:[HHMMSS] to xsd:dateTime CCYY-MM-DDTHH:MM:SS+00:00 -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 13">
					<!-- Convert YYMMDD: to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 3, 2), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYMMDD:HHMMSS to CCYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat('20', substring(., 3, 2), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T', substring(.,8,2), ':', substring(.,10,2), ':', substring(.,12,2))"/>
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
				<xsl:value-of select="format-number((. * $lMultiplier), '0.00')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 3 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit3DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier), '0.00#')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- Produces copy of node without content if content was NaN, otherwise copy of node and content adjusted to explicit 4 D.P. -->
	<xsl:template name="copyCurrentNodeExplicit4DP">
		<xsl:param name="lMultiplier" select="1.0"/>
		<xsl:copy>
			<xsl:if test="string(number(.)) != 'NaN'">
				<xsl:value-of select="format-number((. * $lMultiplier), '0.00##')"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<!-- END of CURRENT NODE HELPERS -->
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
					<xsl:value-of select="concat('20',substring($sPORefDate,3,2),'-',substring($sPORefDate,5,2),'-',substring($sPORefDate,7,2))"/>
				</PurchaseOrderDate>
			</PurchaseOrderReferences>
		</xsl:if>
	</xsl:template>
	<!-- Test Flag Conversion -->
	<xsl:template match="TestFlag">
		<xsl:call-template name="Flag">
			<xsl:with-param name="FlagConversion" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- Test Flag Conversion -->
	<xsl:template name="Flag">
		<xsl:param name="FlagConversion"/>
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$FlagConversion='Y'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:when test="$FlagConversion='1'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:when test="$FlagConversion='N'">
					<xsl:text>false</xsl:text>
				</xsl:when>
				<xsl:when test="$FlagConversion='0'">
					<xsl:text>false</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<!-- Create Delivery Notes -->
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
												<xsl:value-of select="concat('20',substring($sDPODate,3,2),'-',substring($sDPODate,5,2),'-',substring($sDPODate,7,2))"/>
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
										<xsl:value-of select="concat('20',substring($dDDelNoteDate,3,2),'-',substring($dDDelNoteDate,5,2),'-',substring($dDDelNoteDate,7,2))"/>
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
												<xsl:otherwise>
													<xsl:value-of select="InvoicedQuantity"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="sUoM">
											<xsl:call-template name="translateUoM">
												<xsl:with-param name="givenUoM" select="./Measure/TotalMeasureIndicator"/>
											</xsl:call-template>
										</xsl:variable>
										<DespatchedQuantity>
											<xsl:if test="string-length($sUoM) &gt; 0">
												<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="$sUoM"/></xsl:attribute>
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
			<xsl:otherwise>
				<xsl:value-of select="$givenUoM"/>
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
