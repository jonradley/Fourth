<?xml version="1.0" encoding="UTF-8"?>
<!--
/******************************************************************************************
' Date 			| Name			| Description of modification
'******************************************************************************************
16/04/2013		| H Robson		| FB:6363 Branched from tsMappingHospitalityInvoiceCSVBatch.xsl
'******************************************************************************************
13/05/2013		| H Robson		| FB:6363 Create DCNs from INVs
'******************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:vbscript="http://abs-Ltd.com">
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- Start point - ensure required outer BatchRoot tag is applied -->
	<xsl:template match="/">
		<BatchRoot>
			<Document>	
				<xsl:attribute name="TypePrefix">INV</xsl:attribute>
				<xsl:apply-templates/>
			</Document>
			<Document>
				<xsl:attribute name="TypePrefix">DNB</xsl:attribute>
				<Batch>
					<BatchDocuments>
						<xsl:for-each select="Batch/BatchDocuments/BatchDocument/Invoice">
							<xsl:call-template name="createDeliveryNotes"/>
						</xsl:for-each>
					</BatchDocuments>
				</Batch>
			</Document>
		</BatchRoot>
	</xsl:template>
	
	<!-- convert VAT codes to T|S -->
	<xsl:template match="VATCode">
		<VATCode>
			<xsl:choose>
				<xsl:when test=". = '2'">Z</xsl:when>
				<!-- zero -->
				<xsl:when test=". = '1'">S</xsl:when>
				<!-- standard -->
				<xsl:when test=". = '0'">E</xsl:when>
				<!-- exempt -->
			</xsl:choose>
		</VATCode>
	</xsl:template>
	
	<xsl:template match="InvoiceDetail/InvoiceLine">
		<xsl:copy>
			<xsl:element name="LineNumber">
				<xsl:value-of select="vbscript:getLineNumber()"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceHeader">
		<!-- Init our line number counter -->
		<xsl:variable name="dummyVar" select="vbscript:resetLineNumber()"/>
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="InvoiceLine/DeliveryNoteReferences">
		<xsl:variable name="DeliveryNoteDate" select="string(./DeliveryNoteDate)"/>
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:if test="$DeliveryNoteDate != ''">
				<xsl:element name="DespatchDate">
					<xsl:value-of select="concat(substring($DeliveryNoteDate, 1, 4), '-', substring($DeliveryNoteDate, 5, 2), '-', substring($DeliveryNoteDate, 7, 2))"/>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
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
	
	<!-- CONVERT TestFlag from Y / N to 1 / 0 -->
	<xsl:template match="TradeSimpleHeader/TestFlag">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string(.) = 'N'">
					<!-- Is NOT TEST: found an N char, map to '0' -->
					<xsl:value-of select="'0'"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Is TEST: map anything else to '1' -->
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- DATE CONVERSION YYYYMMDD to xsd:date -->
	<xsl:template match="BatchInformation/FileCreationDate |
						InvoiceReferences/InvoiceDate |
						InvoiceReferences/TaxPointDate |
						PurchaseOrderReferences/PurchaseOrderDate |
						DeliveryNoteReferences/DeliveryNoteDate">
		<xsl:copy>
			<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- DATE CONVERSION YYYYMMDD:[HHMMSS] to xsd:dateTime YYYY-MM-DDTHH:MM:SS -->
	<xsl:template match="BatchInformation/SendersTransmissionDate">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="string-length(.) &lt; 15">
					<!-- Convert YYYYMMDD: to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T00:00:00')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Convert YYYYMMDD:HHMMSS to YYYY-MM-DDTHH:MM:SS form (xsd:dateTime) -->
					<xsl:value-of select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2), 'T', substring(.,10,2), ':', substring(.,12,2), ':', substring(.,14,2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="createDeliveryNotes">
		<xsl:variable name="PurchaseOrderDate" select="concat(substring(InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate, 1, 4), '-', substring(InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate, 5, 2), '-', substring(InvoiceDetail/InvoiceLine/PurchaseOrderReferences/PurchaseOrderDate, 7, 2))"/>
		<xsl:variable name="DeliveryNoteDate" select="concat(substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate, 1, 4), '-', substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate, 5, 2), '-', substring(InvoiceDetail/InvoiceLine/DeliveryNoteReferences/DeliveryNoteDate, 7, 2))"/>
		<BatchDocument DocumentTypeNo="7">
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
							<PurchaseOrderReference><xsl:value-of select="InvoiceDetail/InvoiceLine[1]/PurchaseOrderReferences/PurchaseOrderReference"/></PurchaseOrderReference>
							<PurchaseOrderDate><xsl:value-of select="$PurchaseOrderDate"/></PurchaseOrderDate>
						</PurchaseOrderReferences>
					</xsl:if>
					<DeliveryNoteReferences>
						<DeliveryNoteReference><xsl:value-of select="InvoiceDetail/InvoiceLine[1]/DeliveryNoteReferences/DeliveryNoteReference"/></DeliveryNoteReference>
						<DeliveryNoteDate><xsl:value-of select="$DeliveryNoteDate"/></DeliveryNoteDate>
					</DeliveryNoteReferences>
				</DeliveryNoteHeader>
				<DeliveryNoteDetail>
					<xsl:for-each select="InvoiceDetail/InvoiceLine">
						<DeliveryNoteLine>
							<xsl:copy-of select="ProductID"/>
							<xsl:copy-of select="ProductDescription"/>
							
							<DespatchedQuantity>
								<xsl:if test="string-length(InvoicedQuantity/UnitOfMeasure) &gt; 0">
									<xsl:attribute name="UnitOfMeasure">
										<xsl:value-of select="InvoicedQuantity/UnitOfMeasure"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="InvoicedQuantity"/>			
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
	</xsl:template>
	
	<msxsl:script language="VBScript" implements-prefix="vbscript"><![CDATA[ 
		Dim lLineNumber
		
		Function resetLineNumber()
			lLineNumber = 1
			resetLineNumber = 1
		End Function
		
		Function getLineNumber()
			getLineNumber = lLineNumber
			lLineNumber = lLineNumber + 1
		End Function
]]></msxsl:script>
</xsl:stylesheet>
